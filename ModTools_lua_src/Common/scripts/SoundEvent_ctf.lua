-- attacker refers to 'us' or 'our' objects
-- defender refers to 'them' or 'their' objects

---------------------------------------------------------------------------
-- FUNCTION:    SoundEvent_SetupTeams
-- PURPOSE:     instruct the system which team is attacking and which is defending
-- INPUT:		indices (num) (usually 1 or 2)
--				names (string) three letter abbreviation of the side: 'imp', 'all', 'rep', 'cis'
-- OUTPUT:		none
-- NOTES:       this must be set up before the game starts!
-- This is really retarded.  The sound cues are listed at the bottom of
-- ObjectiveOneFlagCTF.lua and ObjectiveCTF.lua
-- For some reason, we can't have aliases for the cues, so the mission scripts
-- must identify the teams involved in order to play the sounds correctly
--------------------------------------------------------------------------- 
function SoundEvent_SetupTeams( attIndex, attName, defIndex, defName )
	gSoundEventsCTF = {}
	
	gSoundEventsCTF[ attIndex ] = gSoundEventsCTF_src[ attName ]
	gSoundEventsCTF[ defIndex ] = gSoundEventsCTF_src[ defName ]
	
	gSoundEventsCTF_src = nil
end

function SoundEvent_BroadcastVO( aEvent, attIndex, defIndex )
	-- safety checking
	if not gSoundEventsCTF then return end
	if attIndex < 1 or attIndex > 2 then return end
	if defIndex < 1 or defIndex > 2 then return end
	
	local attCue = (gSoundEventsCTF[ attIndex ])[ aEvent .. "_att" ]
	local defCue = (gSoundEventsCTF[ defIndex ])[ aEvent .. "_def" ]
	
	BroadcastVoiceOver( attCue, attIndex )
	BroadcastVoiceOver( defCue, defIndex )
end
