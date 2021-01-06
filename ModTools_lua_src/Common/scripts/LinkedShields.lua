--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


LinkedShields = {

	--------------------------------------
	-- Fields that need to be set on creation (i.e. when New is called)
	--
	objs = nil,				--set this to a list of object names which share the same shield
	maxShield = 200000,			--maximum shield value
	addShield = 10000,			--regeneration rate for the shields
	controllerObject = nil,	--the object that, if blown up, will take down the shields
	
	
	--------------------------------------
	-- Internal state variables
	--
	

	
	--------------------------------------
	-- Methods
	--
	
	New = function(self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,


	-- initializes all this stuff
	Init = function(self)
		self.bAllShieldsDown = false
	
		---------------------------------------------------------------
		-- callback for syncing all shields when one shield is damaged.
		local AffectAllShields = function(object, objs, damage)
			local cur, max, add = GetObjectShield(object)
			for i, obj in ipairs(objs) do
				SetProperty(obj, "CurShield", cur)
				if ( cur == 0.0 ) then
					SetProperty(obj, "AddShield", 0)
				end
			end
		end
		
		local CheckAllShieldsDown = function(object)
			local AllShieldsDown = function()
				if not self.bAllShieldsDown then
					self.bAllShieldsDown = true
					if IsObjectAlive(self.controllerObject) then
						KillObject(self.controllerObject)
					end
					self:OnAllShieldsDown()
				end
			end

			local cur, max, add = GetObjectShield(object)
			if ( cur == 0.0 ) then
				AllShieldsDown()
			end
		end

		---------------------------------------------------------------
		local DisableShields = function(objs)
			for i, obj in ipairs(objs) do
				-- just do it for one.  the callback on shield health change
				-- will take care of the rest.
				local cur, max, add = GetObjectShield(obj)
				
				-- shields are already disabled.  exit out.
				if ( cur == 0.0 ) then
					return
				end
				
				SetProperty(obj, "CurShield", 0)
				SetProperty(obj, "AddShield", 0)
			end
		end
		
		-- enable all shields.  reset health.
		local EnableShields = function(objs)
			for i, obj in objs do
				SetProperty(obj, "AddShield", self.addShield / table.getn(objs))
				SetProperty(obj, "CurShield", self.maxShield)
			end
			self.bAllShieldsDown = false
			
			self:OnAllShieldsUp()
		end

		-------------------
		-- init stuff
		for i, obj in ipairs(self.objs) do
			SetProperty(obj, "CurShield", self.maxShield)
			SetProperty(obj, "MaxShield", self.maxShield)
			SetProperty(obj, "AddShield", self.addShield / table.getn(self.objs))
			
			OnObjectDamageName(
				function(object, damage) 
					AffectAllShields(object, self.objs, damage) 
					CheckAllShieldsDown(object) 
				end, 
				obj)
		end
		
		if ( self.controllerObject ) then
			OnObjectKillName(
				function() 
					--if the shields aren't already down...
					if not self.bAllShieldsDown then
						DisableShields(self.objs)
					end
					self:OnControlObjectDestroyed()
				end, 
				self.controllerObject)
				
			OnObjectRespawnName(
				function() 
					EnableShields(self.objs)
				end, 
				self.controllerObject)
		end
	end,

	ChangeAddShield = function(self, x)
		for i, obj in ipairs(self.objs) do
			SetProperty(obj, "AddShield", x)
		end
	end,

}

--------------------------------------
-- Overridable callbacks
--
function LinkedShields:OnControlObjectDestroyed()
end

function LinkedShields:OnAllShieldsUp()
end

function LinkedShields:OnAllShieldsDown()
end


--------------------------------------
-- Util functions (mainly for space combat)
--

--objs: a table of object names
--trueOrFalse: whether to turn the lockOn effect on or off
function EnableLockOn(objs, trueOrFalse)
	for i, object in pairs(objs) do
		EnableBuildingLockOn(object, trueOrFalse)
	end
end

