--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Sorta-stub screen; opens up the missionselect screen, and if that
-- is successful, goes to the split_profile screen. 

function ifs_split_map_fnSelectDone()
	if(ifs_missionselect.SelectedMap) then
		if(ifs_missionselect.bForMP) then
            ifs_movietrans_PushScreen(ifs_mp_gameopts) 
		else
			ScriptCB_EnterMission()
		end
	end
end

ifs_split_map = NewIFShellScreen {
    movieIntro      = nil,
    movieBackground = nil,

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		if(bFwd) then
			ifs_missionselect.fnDone = ifs_split_map_fnSelectDone
			ifs_missionselect.bShortSideSelect = 1 -- skip side select if only 2 sides
            ifs_movietrans_PushScreen(ifs_missionselect)
		else
      ScriptCB_PopScreen()
		end
	end,
}

AddIFScreen(ifs_split_map,"ifs_split_map")