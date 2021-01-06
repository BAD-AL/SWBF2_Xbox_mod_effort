--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Sorta-stub screen; opens up the missionselect screen, and if that
-- is successful, goes to the split_side screen. 

function ifs_instant_fnSelectDone()
	if(ifs_missionselect.SelectedMap) then
        ifs_movietrans_PushScreen(ifs_instant_side) 
	end
end
function ifs_instant_fnSelectCancel()
	-- do nothing, just don't popscreen
end

ifs_instant_top = NewIFShellScreen {
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- do default behavior

		if(bFwd) then
			-- Reset difficulty to what's in profile
			ScriptCB_SetDifficulty(ScriptCB_GetDifficulty())
			ifs_missionselect.fnDone = ifs_instant_fnSelectDone
			ifs_missionselect.fnCancel = ifs_instant_fnSelectCancel
			ifs_missionselect.bForMP = nil
			ScriptCB_SetGameRules("instantaction")
			ScriptCB_SetIFScreen("ifs_missionselect")
		else
			ScriptCB_PopScreen()
		end
	end,
}

AddIFScreen(ifs_instant_top,"ifs_instant_top")