--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--------------------------------------------
-- LinkedDestroyables contains a list of "object sets", each of which contains one or more destroyable objects.
-- When all the objects in one set are destroyed, it automatically kills the rest of the objects in all the other sets.

LinkedDestroyables = 
{
	objectSets = nil,		--Must be set to a two-dimensional table of objects. Each row must be a list of object names, 
							--which represents a so-called "object set"

	New = function(self, o)
		o = o or {}
		setmetatable(o, self)
		self.__index = self
		return o
	end,
	
	
	Init = function(self)
		--------------------
		-- Local functions
		--
		local ObjectKilled = function(setIndex)
			for _, objectName in pairs(self.objectSets[setIndex]) do
				if IsObjectAlive(objectName) then
					return
				end
			end
			
			--if you reach reach here, all the objects in the set are dead, so 
			--we need to now go and kill all the objects in the other sets
			for setIdx, set in pairs(self.objectSets) do
				if setIdx ~= setIndex then
					for _, objectName in pairs(set) do
						if IsObjectAlive(objectName) then
							KillObject(objectName)
						end
					end
				end
			end
			
			--callback notifier
			self:OnSetDestroyed()
			
		end
		
	
		--------------------
		-- Initialization logic
		--
		for setIdx, set in pairs(self.objectSets) do
			--create a callback for each object in the set
			for _, objectName in pairs(set) do
				local whichSetIndex = setIdx   				--silly lua and your closure rules
				OnObjectKillName(
					function (objectPtr, killer)
						ObjectKilled(whichSetIndex)
					end,
					objectName
					)
			end
		end
	end,
}

function LinkedDestroyables:OnSetDestroyed()
	--override me!
end
