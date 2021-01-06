--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_mp_maptype = NewIFShellScreen {
	movieIntro      = nil,
	movieBackground = nil,
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		else
			-- disable the path to multiplayer galatic conquest
			-- go to IA directly
			this.CurButton = "ia"
			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			if(ifs_sp.bForSplitScreen) then
                ifs_movietrans_PushScreen(ifs_split_map)
			else
                ifs_movietrans_PushScreen(ifs_missionselect)
			end
		end
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(this.CurButton == "ia") then
			ScriptCB_SetMetagameRulesOn(nil) -- for ingame
			if(ifs_sp.bForSplitScreen) then
				ifs_movietrans_PushScreen(ifs_split_map)
			else
				ifs_movietrans_PushScreen(ifs_missionselect)
			end
		elseif(this.CurButton == "freeform") then
			ScriptCB_SetMetagameRulesOn(1) -- for ingame
			ifs_movietrans_PushScreen(ifs_mp_gameopts)
		end
	end,
}

local vbutton_layout = {
--	yTop = -70,
	xWidth = 400,
	width = 400,
	xSpacing = 10,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "freeform", string = "ifs.sp.freeform", },
		{ tag = "ia", string = "ifs.sp.ia", },
	},
	rotY = 40,
}

ifs_mp_maptype.CurButton = AddVerticalButtons(ifs_mp_maptype.buttons,vbutton_layout)
AddIFScreen(ifs_mp_maptype,"ifs_mp_maptype")
