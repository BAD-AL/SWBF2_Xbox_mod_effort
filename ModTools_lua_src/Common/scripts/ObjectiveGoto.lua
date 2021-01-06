--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("Objective")


--=============================
-- ObjectiveGoto
--	Handles the logic for a simple "go to this region" objective
--=============================
ObjectiveGoto = Objective:New
{ 
	-- required values
	regionName = "noname",
	mapIcon = "imp_icon",
}


function ObjectiveGoto:Start()

	--===============================
	-- Initialization logic
	--===============================	
	--initialize the base objective data first
	Objective.Start(self)
	
	ActivateRegion(self.regionName)
	MapAddRegionMarker(self.regionName, self.mapIcon, 2.5, self.teamATT, "YELLOW", true)
	MapAddRegionMarker(self.regionName, self.mapIcon, 2.5, self.teamDEF, "YELLOW", true)
	
	--set AI goals
	self.AIGoals = {}
	if self.AIGoalWeight > 0.0 then
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
	end
	
	--=======================================
	-- Event responses
	--=======================================
	OnEnterRegion(
		function(regionPtr, characterId)
			if self.isComplete then	return end
			
			if IsCharacterHuman(characterId) then
				MapRemoveRegionMarker(self.regionName)
				self:Complete( GetCharacterTeam(characterId) )
			end
		end,
		self.regionName
		)
			
	
end
