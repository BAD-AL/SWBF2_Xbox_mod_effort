--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("Objective")

--=============================
-- ObjectiveTDM
--	Handles the logic for a team deathmatch game
--	Aaaactually, this has morphed into the Hunt gametype (at the last minute, hence the lack of name-change), but only in multiplayer/instant-action mode
--=============================
ObjectiveTDM = Objective:New
{ 
	-- external values
	pointsPerKillATT = 1,
	pointsPerKillDEF = 1,	

	isCelebrityDeathmatch = false, 	-- exactly what it sounds like.
	isUberMode = false,				-- ditto
	uberScoreLimit = 400,			-- score limit for, get this, uber mode
}

function ObjectiveTDM:GetGameTimeLimit()
	if ( self.isCelebrityDeathmatch or self.isUberMode) then
		return 0
	else
		return ScriptCB_GetHuntMaxTimeLimit()
	end
end

function ObjectiveTDM:GameOptionsTimeLimitUp()
	local team1pts = GetTeamPoints(1)
	local team2pts = GetTeamPoints(2)
	if ( team1pts > team2pts ) then
		MissionVictory(1)
	elseif ( team1pts < team2pts ) then
		MissionVictory(2)
	else	
		--tied, so victory for both
		MissionVictory({1,2})
	end
end

function ObjectiveTDM:Start()
	if ( self.isCelebrityDeathmatch == true ) then
		ScriptCB_SetNumBots(ScriptCB_GetASSNumBots())
	end

	--===============================
	-- Initialization logic
	--===============================	
	--initialize the base objective data first
	Objective.Start(self)
	
	if self.multiplayerRules then
		ShowTeamPoints(self.teamATT, true)
		ShowTeamPoints(self.teamDEF, true)
		
		SetReinforcementCount(self.teamATT, -1)
		SetReinforcementCount(self.teamDEF, -1)
		
		SetTeamPoints(self.teamATT, 0)
		SetTeamPoints(self.teamDEF, 0)
		if ( self.isCelebrityDeathmatch ) then
			ScriptCB_ShowHuntScoreLimit(2)
		elseif ( self.isUberMode ) then
			ScriptCB_ShowHuntScoreLimit(3)
			ScriptCB_SetUberScoreLimit(self.uberScoreLimit)
		else
			ScriptCB_ShowHuntScoreLimit(1)
		end
	end
	
	
	--set AI goals
	self.AIGoals = {}
	if self.AIGoalWeight > 0.0 then
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
	end
	
	--=======================================
	-- Event responses
	--=======================================
	
	--when used in multiplayer, TDM will count points upwards until a score limit is reached
	if self.multiplayerRules then	
		local eventResponseCharacterDeath = OnCharacterDeath(
			function(character, killer)
				if not killer then return end	--no points for suicides
				
				local victimTeam = GetCharacterTeam(character)
				local killerTeam = GetCharacterTeam(killer)
				
				if victimTeam == killerTeam then return end	--no points for killing guys on your team

				if killerTeam == self.teamATT then
					AddTeamPoints(killerTeam, self.pointsPerKillATT)
				elseif killerTeam == self.teamDEF then
					AddTeamPoints(killerTeam, self.pointsPerKillDEF)
				end
				
				local scorelimit = ScriptCB_GetHuntScoreLimit()
				if ( self.isCelebrityDeathmatch ) then
					scorelimit = ScriptCB_GetAssaultScoreLimit()
				elseif ( self.isUberMode ) then
					scorelimit = ScriptCB_GetUberScoreLimit()
				end
				
				if GetTeamPoints(killerTeam) >= scorelimit then
					self:Complete(killerTeam)
					ReleaseCharacterDeath(eventResponseCharacterDeath)
				end
			end
		)
	end
	
end
