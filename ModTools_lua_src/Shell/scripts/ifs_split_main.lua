--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ifs_split_main_vbutton_layout = {
--	yTop = -70, -- auto-calc'd now
	xWidth = 400,
	width = 400,
	xSpacing = 6,
	yHeight = 50,
	ySpacing = 0,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "local", string = "ifs.split.local", },
		{ tag = "lan", string = "ifs.split.lan", },
		{ tag = "wan", string = "ifs.split.online", },
	},
}

ifs_split_main = NewIFShellScreen {
    movieIntro      = nil,
    movieBackground = nil,
    
	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- top
		y = 20, -- offset slightly down
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- we don't use this screen any more
		assert(false)
		
		-- temp!
		-- jump forward to local
		if (bFwd) then
			this.CurButton = "local"
			this.Input_Accept(this)
		end	
		

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end
	end,

	Exit = function(this, bFwd)
	end,

	Input_Accept = function(this) 
		if(this.CurButton == "local") then
			ifs_missionselect.bForMP = nil
            ifs_movietrans_PushScreen(ifs_sp)
		elseif ((this.CurButton == "wan") or (this.CurButton == "lan")) then
			ifs_missionselect.bForMP = 1
			ifelem_shellscreen_fnStopMovie()
			ScriptCB_SetConnectType(this.CurButton)

			if(this.CurButton == "lan") then
				-- Hack? Set current service appropriately
				gOnlineServiceStr = "LAN"
                ifs_movietrans_PushScreen(ifs_mp_main)
			else
				-- Reacquire default from exe
				gOnlineServiceStr = ScriptCB_GetOnlineService()
				if(gOnlineServiceStr == "XLive") then
                    ifs_movietrans_PushScreen(ifs_mpxl_login)
				else
                    ifs_movietrans_PushScreen(ifs_mp_main)
				end
			end
		end
	end,
}


ifs_split_main.CurButton = AddVerticalButtons(ifs_split_main.buttons,ifs_split_main_vbutton_layout)
AddIFScreen(ifs_split_main,"ifs_split_main")