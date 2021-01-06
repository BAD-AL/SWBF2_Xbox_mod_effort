--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--Forces a certain number of dudes to spawn in on a particular path 
--  (first checking to see that they aren't already alive).
--  Since these ambushers are intended to be non-persistent characters,
--  it leaves them on the extra team (which probably shouldn't own
--  any CP's) and disallows them from capturing CP's
-- NOTE: aiDamageThreshold is completely optional, and if it is supplied,
-- it should be in the range from 0.0 to 1.0
function Ambush(pathName, numDudes, fromTeam, aiDamageThreshold)
    local numSpawned = 0
    local teamSize = GetTeamSize(fromTeam)
    for i = 0, teamSize-1 do
        local characterIndex = GetTeamMember(fromTeam, i)
        local charUnit = GetCharacterUnit(characterIndex)        
        
        if charUnit then
			--skip this character if he's already running around the world (boy i sure wish Lua had a continue statement...)
       	else
			SpawnCharacter(characterIndex, GetPathPoint(pathName, numSpawned))
			charUnit = GetCharacterUnit(characterIndex)
			if charUnit then
				SetProperty(charUnit, "CapturePosts", 0)	--disallow the character from capturing CPs
				if aiDamageThreshold then
					SetAIDamageThreshold(charUnit, aiDamageThreshold)
				end
				numSpawned = numSpawned + 1
				if numSpawned >= numDudes then return end
			end			
		end
	end
    print("WARNING: could not spawn all the ambushers...team is too small or there are too many dudes running around alive")
end

--Designers: use this function to set up an ambush (don't call Ambush() directly, please)
function SetupAmbushTrigger(ambushRegionName, spawnPathName, numDudes, fromTeam)
    local trigger       --must be declared before being used
    trigger = OnEnterRegion(
    	function(region, character)
			if IsCharacterHuman (character) then
			    Ambush(spawnPathName, numDudes, fromTeam)
			    ReleaseEnterRegion(trigger)
			end
    	end,
        ambushRegionName
        )
    ActivateRegion(ambushRegionName)
end