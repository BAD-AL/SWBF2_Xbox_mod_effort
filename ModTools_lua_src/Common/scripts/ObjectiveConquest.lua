--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("Objective")

--=============================
-- CommandPost
--	Class representing a specific CP, allowing some measure of customization
--	of what happens at each post when it is captured
--=============================
CommandPost =
{
	-- fields that need to be specified when calling New()
	name = "noname",			--name of the CP
	
	-- Overridable functions
	OnCapture = function()
		--override me to customize behavior when the command post is captured
	end,
}

function CommandPost:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--=============================
-- ObjectiveConquest
--	Handles the logic for a conquest game (A.K.A. capture the command posts)
--=============================
ObjectiveConquest = Objective:New
{
	-- external values
	icon = "hud_objective_icon_circle",
	
	-- internal values
	defaultBleedRate = 0.3333333333,			--how many units will be lost per second
	defeatTimerSeconds = 20,		--how long the defeat timer lasts after capping the all the CPs
}

function ObjectiveConquest:GetOpposingTeam(team)
	if team == self.teamATT then
		return self.teamDEF
	else
		return self.teamATT
	end
end


function ObjectiveConquest:AddCommandPost(cp)
	--make sure we have a table to add the cp to
	self.commandPosts = self.commandPosts or {}
	
	--do all the error checking we can on the cp
	assert(cp.name, "WARNING: no name supplied for the command post")
	cp.name = string.lower(cp.name)
			
	self.commandPosts[cp.name] = cp
	
	--keep a running tally of the bleedValue relative to each team
	if not self.totalBleedValue then
		self.totalBleedValue = {}
		self.totalBleedValue[self.teamATT] = 0
		self.totalBleedValue[self.teamDEF] = 0
	end
	self.totalBleedValue[self.teamATT] = self.totalBleedValue[self.teamATT] + GetCommandPostBleedValue(cp.name, self.teamATT)
	self.totalBleedValue[self.teamDEF] = self.totalBleedValue[self.teamDEF] + GetCommandPostBleedValue(cp.name, self.teamDEF)
end


--Add a threshold value for bleeding. Basically
function ObjectiveConquest:AddBleedThreshold(team, threshold, rate)
	--assert(team == self.teamATT or team == self.teamDEF, "invalid team!")
	
	if not self.bleedRates then
		--initialize the bleedRates two-dimensional array
		self.bleedRates = {}
		self.bleedRates[self.teamATT] = {}
		self.bleedRates[self.teamDEF] = {}
	end
	
	self.bleedRates[team][threshold] = rate
end

-- Get game time limit as set in game options menu, if any.  0 if none.
function ObjectiveConquest:GetGameTimeLimit()
	return ScriptCB_GetCONMaxTimeLimit()
end

function ObjectiveConquest:GameOptionsTimeLimitUp()
	local team1pts = GetReinforcementCount(1)
	local team2pts = GetReinforcementCount(2)
	if ( team1pts > team2pts ) then
		MissionVictory(1)
	elseif ( team1pts < team2pts ) then
		MissionVictory(2)
	else
		--tied, so victory for both
		MissionVictory({1,2})
	end
end

function ObjectiveConquest:Start()
	--===============================
	-- Local functions
	--===============================
	
	
	local UpdateBleedRate = function(team)
		--count up the total bleedPoints (bleedPoints only count if they're on a CP owned by a different team)
		local bleedPoints = 0
		for i, cp in pairs(self.commandPosts) do
			local cpTeam = GetObjectTeam(cp.name)
			if cpTeam == self:GetOpposingTeam(team) then
				--print("cp.name:", cp.name, "bleedPoints:", GetCommandPostBleedValue(cp.name, cpTeam))			--uncomment me for test output!
				bleedPoints = bleedPoints + GetCommandPostBleedValue(cp.name, cpTeam)
			end
		end		
		
		
		--set the bleed rate based on the total accumulated bleedPoints
		local bleedRate = 0.0		
		if self.bleedRates and self.bleedRates[team] then
			--look through the unsorted list for the highest threshold that bleedPoints is higher than
			local highestThresholdSoFar = 0
			for threshold, rate in pairs(self.bleedRates[team]) do
				if bleedPoints >= threshold and threshold > highestThresholdSoFar then
					bleedRate = rate
					highestThresholdSoFar = threshold
				end
			end
		else
			--default bleeding rule is to start bleeding when the team's bleed points are greater
			--than half the total points
			if bleedPoints > (self.totalBleedValue[team] / 2.0) then
				bleedRate = self.defaultBleedRate
			end
		end
		
		--print("totalbleedpts:", self.totalBleedValue[team])													--uncomment me for test output!
		--print("team:", team, "bleedPoints:", bleedPoints, "bleedRate:", bleedRate)							--uncomment me for test output!
	
		--setup the bleedrate display (i.e. how fast the score flashes in the HUD)
		SetBleedRate(team, bleedRate)
		
		if bleedRate > 0.0 then
			--start bleeding reinforcements
			StopTimer(self.bleedTimer[team])
			SetTimerValue(self.bleedTimer[team], 1.0)
			SetTimerRate(self.bleedTimer[team], bleedRate)
			StartTimer(self.bleedTimer[team])
		else
			--stop bleeding reinforcements
			StopTimer(self.bleedTimer[team])
		end
	end
	
	
	--turns off the timers and resets the winningTeam number
	local DisableWinnerDoodads = function()
		self.winningTeam = 0
		StopTimer(self.defeatTimer)

		--hide the timers (HACK: this way of displaying the lose timer should be updated to use new HUD code)
		SetDefeatTimer(nil, self.teamATT)
		SetVictoryTimer(nil, self.teamATT)
		SetDefeatTimer(nil, self.teamDEF)
		SetVictoryTimer(nil, self.teamDEF)
	end
	
	
	local UpdateState = function()
		if self.multiplayerRules then
			UpdateBleedRate(self.teamDEF)
			UpdateBleedRate(self.teamATT)
		end	
	
		--check to see if one team (the winningTeam) has all the CPs
		self.winningTeam = 0
		for i, cp in pairs(self.commandPosts) do
			--NOTE: destroyed CP's aren't supposed to count against the win/loss accounting
			if IsObjectAlive(cp.name) then
				local cpTeam = GetObjectTeam(cp.name)
				
				if cpTeam == 0 then
					--can't have a winner if one of the CPs is still neutral
					DisableWinnerDoodads()
					return
				elseif self.winningTeam == 0 then
					--start tracking this team that might be winning
					self.winningTeam = cpTeam
				elseif self.winningTeam ~= cpTeam then
					--there is no winner, since we just found two CP's that don't match
					DisableWinnerDoodads()
					return
				end
			end
		end
				
		if self.winningTeam ~= 0 then
			if self.disallowDefensiveVictory and self.winningTeam ~= self.teamATT then
				return
			end
			
			if self.multiplayerRules then
				--start the defeat timer to end the game in a few seconds
				SetTimerValue(self.defeatTimer, self.defeatTimerSeconds)
				StartTimer(self.defeatTimer)
				
				--tell the C++ code about the defeat/victory timer (which will display it on the HUD)
				SetDefeatTimer(self.defeatTimer, self:GetOpposingTeam(self.winningTeam))
				SetVictoryTimer(self.defeatTimer, self.winningTeam)
			else
				--end the objective immediately
				self:Complete(self.winningTeam)
			end
		end
	end
	
	
	local InitBleedTimer = function(team)
		self.bleedTimer[team] = CreateTimer("bleed" .. team)
		
		OnTimerElapse(
			function (timer)				
				if GetReinforcementCount(team) > GetNumTeamMembersAlive(team) then
					--tick off a reinforcement when the timer elapses, and start it up again
					if GetReinforcementCount(team) > 0 then
						AddReinforcements(team, -1)
					end
					SetTimerValue(timer, GetTimerValue(timer) + 1.0)
					StartTimer(timer)					
				else
					--disallow bleeding when a team gets really low on reinforcements (so the team
					--doesn't run entirely out of units due to bleedrate, as per designer request)
					SetBleedRate(team, 0.0)
					StopTimer(timer)
				end
			end,
			self.bleedTimer[team]
			)
	end
	
	
	local InitDefeatTimer = function()
		self.defeatTimer = CreateTimer("defeat")
		SetTimerRate(self.defeatTimer, 1.0)
		
		OnTimerElapse(
			function (timer)
				StopTimer(timer)
				SetReinforcementCount(self:GetOpposingTeam(self.winningTeam), 0)
				self:Complete(self.winningTeam)	
			end,
			self.defeatTimer
			)
	end
	
	
	local UpdatePostMapMarker = function(postPtr)
		if not self.multiplayerRules then
			--check the team that capped the CP, and change the map marker accordingly
			if GetObjectTeam(postPtr) == self.teamATT then
				MapRemoveEntityMarker(postPtr, self.teamATT)
			else
				MapAddEntityMarker(postPtr, self.icon, 4.0, self.teamATT, "YELLOW", true)
			end
		end
	end
		
	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	ScriptCB_SetNumBots(ScriptCB_GetCONNumBots())

	--===============================
	-- Initialization logic
	--===============================	
	--initialize the base objective data first
	Objective.Start(self)
	
	--initialize internal values
	self.commandPosts = self.commandPosts or {}
	
	self.bleedTimer = {}
	InitBleedTimer(self.teamATT)
	InitBleedTimer(self.teamDEF)
	
	InitDefeatTimer()
	
	if self.multiplayerRules then
		self.disallowDefensiveVictory = false
	else
		self.disallowDefensiveVictory = true		--in single player/co-op, the defense can't win by capping all the CPs
	end
	
	numCPs = 0
	for i, cp in pairs(self.commandPosts) do
		if not self.multiplayerRules then
			MapAddEntityMarker(cp.name, self.icon, 4.0, self.teamATT, "YELLOW", true)
		end
		numCPs = numCPs + 1
	end
	if(numCPs == 0) then
		print ("ERROR: no valid CommandPosts were added to the ObjectiveConquest")
		return
	end	
	
	--set AI goals
	self.AIGoals = {}
	if self.AIGoalWeight > 0.0 then
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Conquest", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Conquest", 100*self.AIGoalWeight))
	end
	
	--do an initial update on the state
	UpdateState()
	
	--=======================================
	-- Event responses
	--=======================================
	-- command post captures
	OnFinishCapture(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
						
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
		)
		
	-- command post neutralize
	OnFinishNeutralize(
		function (postPtr)				
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			UpdatePostMapMarker(postPtr)
			UpdateState()
		end
		)
		
	-- command post spawn
	OnCommandPostRespawn(
		function (postPtr)				
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			UpdatePostMapMarker(postPtr)			
			UpdateState()
		end
		)
	
	-- command post kill
	OnCommandPostKill(
		function (postPtr)
			if self.isComplete then	return end
			if not self.commandPosts[GetEntityName(postPtr)] then return end
			
			if not self.multiplayerRules then
				MapRemoveEntityMarker(postPtr, self.teamATT)
			end
			
			UpdateState()
		end
		)	
end

function ObjectiveConquest:Complete(winningTeam)
	if not self.multiplayerRules then
		--remove all the cp markers
		for i, cp in pairs(self.commandPosts) do
			MapRemoveEntityMarker(cp.name)
		end
	end
	
	--then call the default objective complete method
	Objective.Complete(self, winningTeam)
end
