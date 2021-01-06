--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


--Each set of linked turrets has one control mainframe that will disable the turrets when it is destroyed,
--and re-enable the turrets when it is repaired

LinkedTurrets =
{
	--------------------------------------
	-- Fields that need to be set on creation (i.e. when New is called)
	--
	mainframe = nil,		--must be the name of a destroyable object
	turrets = nil,			--must be a list of names of turret objects
	team = nil,				--the number of the team that the turrets are working for
	
	
	---------------------------------------
	-- Methods
	--

	New = function(self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,

	Init = function(self)
		OnObjectKillName(
			function(objectPtr, killer)
				for _, turret in pairs(self.turrets) do
					SetObjectTeam(turret, 0)
				end
				self:OnDisableMainframe()
			end,
			self.mainframe
			)
			
		OnObjectRespawnName(
			function(objectPtr, killer)
				for _, turret in pairs(self.turrets) do
					SetObjectTeam(turret, self.team)
				end
				self:OnEnableMainframe()
			end,
			self.mainframe
			)	
	end

}

function LinkedTurrets:OnDisableMainframe()
	--override me!
end

function LinkedTurrets:OnEnableMainframe()
	--override me!
end