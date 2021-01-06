--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("Objective")

--=============================
-- Target
--	Class representing a specific assault target, allowing some measure of customization
--	of what happens when it is destroyed
--=============================
Target =
{
	-- fields that need to be specified when calling New()
	name = "noname",			--name of the target object	
		
	-- optional fields
	killedByPlayer = false,		--if set to true, then it requires the target be killed by the player
	icon = "hud_objective_icon_circle",
	iconScale = 3.5,
	weapon = nil,				--if set to a weapon odf name, then the target must be killed by that weapon to count

	-- fields that are set automatically
	isDead = false,
	
	-- Overridable functions
	OnDestroy = function(self)
		--override me to customize behavior per CommandPost
	end,
}

function Target:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end



--=============================
-- TargetType
--	Class representing an assault target that involves killing a certain number
--	of objects that match a particular type
--=============================
TargetType =
{
	-- fields that need to be specified when calling New()
	classname = "noname",		--name of the class of objects
	killLimit = 5,				--how many objects of that className need to be killed
	
	-- optional fields
	icon = "hud_objective_icon_circle",
	iconScale = 3.5,
	killedByPlayer = false,		--if set to true, then it requires the target be killed by the player
	weapon = nil,				--if set to a weapon odf name, then the target must be killed by that weapon to count
	
	-- fields that are generated automatically
	numKilled = 0,
	
	OnDestroy = function(self, targetPtr)
		--override me to customize behavior when one of the targets is killed
		--(targetPtr refers to the object that was just destroyed)
	end,
	
	OnAllDestroyed = function(self)
		--override me to customize behavior when all of the targets are killed
	end,
}

function TargetType:New(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end



--=============================
-- ObjectiveAssault
--	Handles the logic for an assault game
--=============================
ObjectiveAssault = Objective:New{}

function ObjectiveAssault:GetNumSingleTargets()
	local count = 0
	for _, target in pairs(self.specificTargets) do
		if not target.isDead then
			count = count + 1
		end
	end	
	return count
end


function ObjectiveAssault:OnSingleTargetDestroyed(target)
	--override me to do something cool
end


function ObjectiveAssault:AddTarget(t)
	if getmetatable(t) == Target then
		self:AddSingleTarget(t)
	elseif getmetatable(t) == TargetType then
		self:AddMultiTarget(t)
	else
		assert(false, "AddTarget(): invalid target type")
	end
end

--
-- Adds a specific target to the objective. "t" must be an instance of
--	Target (see above)
--
function ObjectiveAssault:AddSingleTarget(t)	
	--make sure we have a table to add the target to
	self.specificTargets = self.specificTargets or {}
	
	--error checking
	t.name = t.name or "noname"
	t.killedByPlayer = t.killedByPlayer or false
	
	self.specificTargets[t.name] = t
end

--
-- Adds a "TargetType" to the assault objective, which is really a list of targets
--	which each share a common type. "t" must be an instance of TargetType (see above)
--
function ObjectiveAssault:AddMultiTarget(t)
	--make sure we have a table to add the targets to
	self.multiTargets = self.multiTargets or {}
	
	--error checking
	t.classname = t.classname or "noname"
	t.killLimit = t.killLimit or 5
	t.killedByPlayer = t.killedByPlayer or false
	
	if t.killLimit < 0 then
		t.killLimit = 1
	end
	
	self.multiTargets[t.classname] = t
end

function ObjectiveAssault:Start()
	--===============================
	-- Local functions
	--===============================
	local CheckWinCondition = function()
		for i, target in pairs(self.specificTargets) do
			if not target.isDead then
				return
			end
		end
		
		for i, multiTarget in pairs(self.multiTargets) do
			if multiTarget.numKilled < multiTarget.killLimit then
				return
			end
		end
		
		--if we reach here, all the targets must be destroyed
		self:Complete(self.teamATT)
	end

	--==========
	-- Set the number of guys in the level to number in game options
	--==========
	ScriptCB_SetNumBots(ScriptCB_GetASSNumBots())

	
	--===============================
	-- Initialization logic
	--===============================
	--initialize the base objective data first
	Objective.Start(self)
	
	--make sure we have at least one target, and reset parameters on the targets while we're at it,
	--along with the AIGoals
	self.AIGoals = {}
	self.specificTargets = self.specificTargets or {}
	self.multiTargets = self.multiTargets or {}
	numSpecificTargets = 0
	numMultiTargets = 0
	for i, t in pairs(self.specificTargets) do
		if IsObjectAlive(t.name) then
			MapAddEntityMarker(t.name, t.icon, t.iconScale, self.teamATT, "YELLOW", true)
			numSpecificTargets = numSpecificTargets + 1
			t.isDead = false
			if self.AIGoalWeight > 0.0 then
				table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Destroy", 100*self.AIGoalWeight, t.name))
				table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Defend", 100*self.AIGoalWeight, t.name))
			end
		else
			t.isDead = true
		end
	end
		
	for i, t in pairs(self.multiTargets) do
		MapAddClassMarker(t.classname, t.icon, t.iconScale, self.teamATT, "YELLOW", true)
		table.insert(self.AIGoals, AddAIGoal(self.teamATT, "Deathmatch", 100*self.AIGoalWeight))
		table.insert(self.AIGoals, AddAIGoal(self.teamDEF, "Deathmatch", 100*self.AIGoalWeight))
		numMultiTargets = numMultiTargets + 1
		t.numKilled = 0
	end
	
	if (numSpecificTargets + numMultiTargets) == 0 then
		print(false, "WARNING: there were no targets added to the assault objective!")
	end
	
	CheckWinCondition()		--just in case all the targets are already dead
	
	--=======================================
	-- Event responses
	--=======================================
		
	--set up a callback for each specific target
	for i, t in pairs(self.specificTargets) do
		local target = t
		OnObjectKillName(
			function (objectPtr, killer)
				if self.isComplete then	return end
					
				if target.killedByPlayer == true then
					if not killer then
						return 
					elseif not IsCharacterHuman(killer) then 
						return
					end
				end
				
				if target.weapon and string.lower(target.weapon) ~= GetObjectLastHitWeaponClass(target.name) then
					return
				end
				
				MapRemoveEntityMarker(objectPtr)
				target.isDead = true
				
				--killer gets fixed number of points for destruction of assault objective
				if ( killer ) then
					AddAssaultDestroyPoints(killer)
				end
				
				--overrideable callbacks
				target:OnDestroy()
				self:OnSingleTargetDestroyed(target)
				
				CheckWinCondition()
			end,
			t.name
			)
	end
	
	
	--set up a callback for each multiTarget class
	for i, t in pairs(self.multiTargets) do
		local multiTarget = t
		OnObjectKillClass(
			function (objectPtr, killer)
				if self.isComplete then	return end
				
				if multiTarget.killedByPlayer == true then
					if not killer then
						return 
					elseif not IsCharacterHuman(killer) then 
						return
					end
				end
				
				if multiTarget.weapon and string.lower(multiTarget.weapon) ~= GetObjectLastHitWeaponClass(objectPtr) then
					return
				end
				
				multiTarget.numKilled = multiTarget.numKilled + 1
				multiTarget:OnDestroy(objectPtr)
				if multiTarget.numKilled == multiTarget.killLimit then
					multiTarget:OnAllDestroyed()
				end
				CheckWinCondition()
			end,
			t.classname
			)
	end
	
end

function ObjectiveAssault:Complete(winningTeam)
	--remove the map markers on the targets that are still alive
	for i, t in pairs(self.specificTargets) do
		if not t.isDead then
			MapRemoveEntityMarker(t.name)
		end
	end
	
	for i, t in pairs(self.multiTargets) do
		MapRemoveClassMarker(t.classname, self.teamATT)
	end
	
	Objective.Complete(self, winningTeam)
end
