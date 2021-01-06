--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--



--
-- Manages a multi-dimensional table of the objectives in the map. Basically,
--	there are one or more "sets" of objectives, each of which can contain
--	one or more concurrent objectives. When all of the objectives in a particular set
--	are completed, then it moves onto the next set. When all of the sets
--	are completed, it finishes the map.
--
--	NOTE: When any of the individual objectives are won by team 2, the game will automatically
--	end (with defeat for team 1). This is how it's intended to work for the single player
--	campaign mode, but may cause surprises if the MultiObjectivecontainer is used for multiplayer.

MultiObjectiveContainer = 
{
	delayVictoryTime = 0,		--how long to delay the MissionVictory function call (to allow time for voice overs, etc..)
	delayNextSetTime = 3.0,		--how long to delay between activating the next set of objectives (mostly a hack to let the popup text go away before displaying the next objective)
	primaryTeam = 1,			--defaults to team 1 (which is the human team in single player/co-op)...this is the team that causes the container to move
								--to the next objective when they win (any other team(s) will just cause the game to end if they complete any of the objectives)
	trackPlayerDeaths = true,	--if true, then will track reinforcements and end the game when one team runs out of guys (must be set before calling :Start())
}


--
-- Creates a new ObjectiveManager
--
function MultiObjectiveContainer:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end


--
-- Insert a new objectiveLayer and add the list of objectives to it
--
function MultiObjectiveContainer:AddObjectiveSet(...)
	self.objectiveSets = self.objectiveSets or {}
	
	for i, obj in ipairs(arg) do
		obj:SetContainer(self)
		obj:AddToDisplayableList()
	end
	
	table.insert(self.objectiveSets, arg)
end


function MultiObjectiveContainer:OnlyCountHumanKills(team, isActive)
	self.onlyCountHumanKills = self.onlyCountHumanKills or {}
	
	self.onlyCountHumanKills[team] = isActive
end


function MultiObjectiveContainer:OnlyCountHumanDeaths(team, isActive)
	self.onlyCountHumanDeaths = self.onlyCountHumanDeaths or {}
	
	self.onlyCountHumanDeaths[team] = isActive
end


--
-- Activates all the objectives in the first set
--
function MultiObjectiveContainer:Start()
	local numSets = table.getn(self.objectiveSets)
	if(numSets == 0) then
		print("WARNING: No objectives were added to the MultiObjectiveContainer")
		return
	end
	
--just to be sure, clear the AI goals for ALL the teams referenced by the objectives
--	for i = 1, numSets do
--		for h, obj in ipairs(self.objectiveSets[i]) do
--			ClearAIGoals(obj.teamATT)
--			ClearAIGoals(obj.teamDEF)
--		end
--	end
--Nevermind, now that greg got rid of the default AI goals...leaving the old code here just in case we wanna re-enable it
	
	--reuse victoryTimer if possible
	self.victoryTimer = FindTimer("victoryTimer")
	if not self.victoryTimer then
		self.victoryTimer = CreateTimer("victoryTimer")
	end
	
	--reuse delayVictoryTimer if possible
	self.delayTimer = FindTimer("delayTimer")
	if not self.delayTimer then
		self.delayTimer = CreateTimer("delayTimer")
	end

	--activate the first set of objectives
	self:ActivateObjectiveSet(1)
	
	--========================
	-- Helper Functions
	--========================
	local IsMultiplayerGametype = function()
		--returns true if any of the active objectives have multiplayerRules set to true
		if self.activeSet <= table.getn(self.objectiveSets) then
			for i, obj in ipairs(self.objectiveSets[self.activeSet]) do
				if obj.multiplayerRules then
					return true 
				end
			end
		end
		
		return false
	end
	
		
	local PlayReinforcementsLow = function(team)
		if not IsCampaign() then return end
		
		if reinforcementsLowVOAlreadyPlayed then return end		
		reinforcementsLowVOAlreadyPlayed = true
		
		local soundsMap = {
			cor1 = "COR_obj_37",
			dea1 = "DEA_obj_26",
			fel1 = "FEL_obj_18",
			geo1 = "GEO_obj_34",
			hoth = "HOT_obj_27",
			kamino1 = "KAM_obj_18",
			kas2 = "KAS_obj_18",
			mus1 = "MUS_obj_26",
			myg1 = "MYG_obj_25",
			naboo2 = "NAB_obj_21",
			pol1 = "POL_obj_11",
			spa1 = "SPA1_obj_50",
			spa2 = "SPA2_obj_68",
			spa3 = "SPA3_obj_17",
			spa4 = "SPA4_obj_18",
			tan1 = "TAN_obj_15",
			uta1 = "UTA_obj_52",
			yavin1 = "YAV_obj_16",
		}
		
		soundName = soundsMap[ GetWorldFilename() ]
		if soundName then
			BroadcastVoiceOver(soundName, team)
		end
	end
	
	
	local PlayReinforcementsGone = function(team)
		if not IsCampaign() then return end
		
		if reinforcementsGoneVOAlreadyPlayed then return end
		reinforcementsGoneVOAlreadyPlayed = true
		
		local soundsMap = {
			cor1 = "COR_obj_25",
			dea1 = "DEA_obj_25",
			fel1 = "FEL_obj_17",
			geo1 = "GEO_obj_33",
			hoth = "HOT_obj_18",
			kamino1 = "KAM_obj_17",
			kas2 = "KAS_obj_17",
			mus1 = "MUS_obj_20",
			myg1 = "MYG_obj_24",
			naboo2 = "NAB_obj_20",
			pol1 = "POL_obj_10",
			spa1 = "SPA1_obj_49",
			spa2 = "SPA2_obj_55",
			spa3 = "SPA3_obj_16",
			spa4 = "SPA4_obj_17",
			tan1 = "TAN_obj_14",
			uta1 = "UTA_obj_51",
			yavin1 = "YAV_obj_15",
		}
		
		soundName = soundsMap[ GetWorldFilename() ]
		if soundName then
			BroadcastVoiceOver(soundName, team)
		end
	end
	
	
	
	--========================
	-- Event responses
	--========================
	if self.trackPlayerDeaths then
		--reduce reinforcement count on character death
		OnCharacterDeath(
			function (victim, killer)
				local victimTeam = GetCharacterTeam(victim)
				
				--ignore this kill if "only count human deaths" is on for that team
				if self.onlyCountHumanDeaths and self.onlyCountHumanDeaths[victimTeam] and not IsCharacterHuman(victim) then
					return
				end
				
				--ignore this kill if "only count human kills" is on for that team
				if killer then
					local killerTeam = GetCharacterTeam(killer)
				
					if self.onlyCountHumanKills and self.onlyCountHumanKills[killerTeam] and not IsCharacterHuman(killer) then
						return
					end
				end
				
				--MODERATE HACK: in a single player game, only a human death can cause
				-- the reinforcement count to go down to 0 for the human team 
				-- (this assumes that team 1 is the human player team)
				if victimTeam == 1 and not IsMultiplayerGametype() and GetReinforcementCount(1) == 1 and not IsCharacterHuman(victim) then
					return
				end
				
				--finally, if we reach here, reduce the reinforcements by one
				if GetReinforcementCount(victimTeam) > 0 then
					AddReinforcements(victimTeam, -1)
				end
			end
			)
		
		--If a team runs out of reinforcements, they lose right away.
		--If you want to disable the reinforcement countdown,
		--call SetReinforcementCount(teamID, -1)
		OnTicketCountChange(
			function (team, count)
				--if we already have a winner, don't do anything 
				--(the objective is probably waiting on a delay timer to end the mission)
				if self.winningTeam and self.winningTeam > 0 then return end
				
				if count == 5 then
					PlayReinforcementsLow(team)
				end
				
				if count == 0 and (team == 1 or team == 2) then
					if team == 1 then
						self.winningTeam = 2
					else
						self.winningTeam = 1
					end
					
					PlayReinforcementsGone(team)
					
					self.delayVictoryTime = 1.0
					self:StartVictoryTimer(self.winningTeam)
				end
			end
			)
	end
	
end


--
-- This method ends the mission after a certain amount of time (determined
-- by self.missionVictoryTime
--
function MultiObjectiveContainer:StartVictoryTimer(winningTeam)
	self.victoryTimerCount = 0		--count up how many times the timer has been activated (so it doesn't go on forever...just in case a VO doesn't close)
	self.winningTeam = winningTeam
	
	if self.delayVictoryTime > 0 then			
		SetTimerValue(self.victoryTimer, self.delayVictoryTime)
		StartTimer(self.victoryTimer)
		self.victoryDelayTimerResponse = OnTimerElapse(
			function(timer)
				self.victoryTimerCount = self.victoryTimerCount + 1
				
				--NOTE: assumes that all the victory/defeat VO plays through the "global_vo_slow" stream
				if AudioStreamComplete("global_vo_slow") == 1 or self.victoryTimerCount >= 15 then
					MissionVictory(self.winningTeam)
					StopTimer(self.victoryTimer)
					ReleaseTimerElapse(self.victoryDelayTimerResponse)					
				else
					--try again in a little bit...
					SetTimerValue(self.victoryTimer, 1.0)
					StartTimer(self.victoryTimer)					
				end
			end,
			self.victoryTimer
			)
	else
		MissionVictory(self.winningTeam)
	end
end

--
-- Use this to tell the container when one of the active objectives has finished
--
function MultiObjectiveContainer:NotifyObjectiveComplete(objective)
	--If the primary team fails any of its objectives, then end the map immediately (or after a slight delay)
	if objective.winningTeam ~= self.primaryTeam then
		self:StartVictoryTimer(objective.winningTeam)
		return
	end
	
	--Check through the active set of objectives. If they're all complete,
	--then move onto the next layer or trigger the mision end
	for i, obj in ipairs(self.objectiveSets[self.activeSet]) do
		if not obj.isComplete then
			return		--if there's an incomplete objective, then just keep playing the map
		end
	end
	
	--if we've reached here, then all the objectives in the current set are complete
	if self.activeSet >= table.getn(self.objectiveSets) then
		--we have no more objective sets, so finish the mission
		self:StartVictoryTimer(objective.winningTeam)
	else
		--delay for a small time before starting the next objective set
		SetTimerValue(self.delayTimer, self.delayNextSetTime)
		StartTimer(self.delayTimer)
		self.delayTimerResponse = OnTimerElapse(
			function(timer)
				--move on to the next set of objectives
				self:ActivateObjectiveSet( self.activeSet + 1 )
				ReleaseTimerElapse(self.delayTimerResponse)
			end,
			self.delayTimer
			)
	end
		
end

--
-- Updates the current objective set number, and activates all the objectives within that set
--
function MultiObjectiveContainer:ActivateObjectiveSet(whichSet)
	--don't advance to the next set if this is the last one
	-- (this handles the case when the last two objective sets
	-- are completed in a very short period of time, and the
	-- missionVictoryTime is relatively long)
	if whichSet > table.getn(self.objectiveSets) then
		self:StartVictoryTimer(self.winningTeam)
		return
	end
	
	self.activeSet = whichSet
	for i, obj in ipairs(self.objectiveSets[self.activeSet]) do
		obj:Start()
	end
end

