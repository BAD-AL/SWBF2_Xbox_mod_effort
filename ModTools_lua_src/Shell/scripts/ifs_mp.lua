--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_mp_vbutton_layout = {
--	yTop = -50,
	xWidth = 400,
	width = 400,
	ySpacing  = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "wan", string = "ifs.mp.connection.gamespy", }, -- or XBox XLive
		{ tag = "lan", string = "ifs.mp.connection.lan", }, -- or XBox Direct Connect
		{ tag = "direct", string = "ifs.mp.connection.direct", }, -- == XBox XLive
--		{ tag = "split", string = "ifs.mp.connection.split", },
		{ tag = "journal", string = "ifs.mp.journal" },
		{ tag = "playback", string = "ifs.mp.playback" },
	},
	title = "ifs.mp.connection.title",
}

function ifs_mp_fnCheckCable(this)
	this.fCableCheckTimer = 0.75 -- reset timer

	-- only do the fading/greying for XBOX
	this.bCablePresent = ScriptCB_IsNetCableIn() or (gPlatformStr ~= "XBox")

	if(this.bLastCablePresent ~= this.bCablePresent) then
		this.bLastCablePresent = this.bCablePresent
		this.buttons.lan.bDimmed = not this.bCablePresent

		if(not this.bCablePresent) then
			if(this.CurButton == "lan") then
				this:Input_GeneralDown()
			end
		end

		-- Redo buttons
		ShowHideVerticalButtons(this.buttons,ifs_mp_vbutton_layout)
	end
end

ifs_mp = NewIFShellScreen {
 	nologo = 1,
	movieIntro      = nil, -- WAS  nil
	movieBackground = "shell_main", -- WAS  nil
	-- music           = "STOP",
	-- exitSound       = "",
	bAcceptIsSelect = 1,
	
	bPatchCheckStatus = 0,


	newVersion = NewIFText {
		font = "gamefont_small",
		textw = 500,
		texth = 100,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.8,
		flashy = 0,
	},

	IPAddr = NewIFText {
--		string = "ifs.mp.connection.title",
		font = "gamefont_small",
		textw = 460,
		halign = "left",
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 0.0,
		nocreatebackground = 1,
	},

	BuildStr = NewIFText {
--		string = ScriptCB_GetBuildStr(),
		font = "gamefont_small",
		textw = 460,
		x = -460,
		halign = "right",
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 0.0,
		nocreatebackground = 1,
	},

	bLastCablePresent = -1, -- force an update first time thru
	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- top
	},

	fCableCheckTimer = 0.0,	
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt) -- always call base class default behavior

--		if(ScriptCB_CheckForPatch) then
--			local patchCheckStatus = ScriptCB_CheckForPatch(2)
--			if (patchCheckStatus ~= this.bPatchCheckStatus) then
--				-- show the status change
---				print("new patch status ", patchCheckStatus)
--				this.bPatchCheckStatus = patchCheckStatus
--				if(this.bPatchCheckStatus == 2) then
--					IFText_fnSetString(this.newVersion,"ifs.mp.newversion")
--				end
--			end
--		end

		this.fCableCheckTimer = this.fCableCheckTimer - fDt
		if(this.fCableCheckTimer < 0) then
			ifs_mp_fnCheckCable(this)
		end		
	end,

	Enter = function(this,bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		-- done the NTGUI skip, so clear the flag
		ScriptCB_ResetSkipToNTGUI()

		ScriptCB_SetNoticeNoCable(nil)
		-- Backing into this screen? Always clear error 
		if(not bFwd) then
			ScriptCB_ClearError()
		end

		print("In ifs_mp's Enter()")

		-- Set "wan" string to XLive if required
		if(ScriptCB_GetOnlineService() == "XLive") then
			RoundIFButtonLabel_fnSetString(this.buttons.wan, "ifs.mp.connection.xlive")
		end

		-- no ps2 for you
		IFText_fnSetString(this.IPAddr,"IP: " .. ScriptCB_GetIPAddr())
		IFText_fnSetString(this.BuildStr,ScriptCB_GetBuildStr())
		IFObj_fnSetVis(this.IPAddr, not gFinalBuild)
		IFObj_fnSetVis(this.BuildStr, not gFinalBuild)
		
		ifs_mp_fnCheckCable(this)						
		if (bFwd) then
			if (ScriptCB_IsCmdlineJoinPending()) then
--				print("L140, cmdline")
				gOnlineServiceStr = ScriptCB_GetOnlineService()
				ScriptCB_SetConnectType("wan")
				ifs_movietrans_PushScreen(ifs_mpgs_login)
			elseif (ifs_main.bJumpToMPMain) then
				ScriptCB_SetConnectType("wan")
				ifs_movietrans_PushScreen(ifs_split2_profile)
			elseif (ScriptCB_IsSpecialJoinPending()) then
--				print("L145, special")
				if(gOnlineServiceStr == "XLive") then
					ifs_mpxl_friends_fnBackupOnlineService()
					ifs_movietrans_PushScreen(ifs_split2_profile)
				else
					if(ScriptCB_GetConnectType() == "LAN") then
						gOnlineServiceStr = "LAN" -- like we'd pressed that.
						ScriptCB_StartLogin()
					end
					ifs_movietrans_PushScreen(ifs_mp_main)
					-- Whine like crazy
					ScriptCB_SetNoticeNoCable(1)
				end
			elseif (ScriptCB_InMultiplayer()) then
				if(ScriptCB_GetConnectType() == "LAN") then
					gOnlineServiceStr = "LAN" -- like we'd pressed that.
				elseif (ScriptCB_GetConnectType() == "Direct") then
					gOnlineServiceStr =  "Direct"
				else
					gOnlineServiceStr = ScriptCB_GetOnlineService()
				end
				
				-- ScriptCB_SetConnectType(ScriptCB_GetConnectType())
				if(gOnlineServiceStr == "XLive") then
					ifs_movietrans_PushScreen(ifs_split2_profile)
				else
					-- Whine like crazy
					ScriptCB_SetNoticeNoCable(1)
					if(gPlatformStr ~= "PC") then
						ScriptCB_StartLogin()
					end
					ifs_movietrans_PushScreen(ifs_mp_main)
				end
			end
		end

		if (not bFwd) then
			if (ifs_main.bJumpToMPMain) then
				ScriptCB_SetConnectType("wan")
				ifs_movietrans_PushScreen(ifs_split2_profile)
			end
		end

		-- Direct only exists on PC
		this.buttons.direct.hidden = (gPlatformStr ~= "PC")
		
		this.buttons.journal.hidden = (gPlatformStr ~= "PS2") or gFinalBuild
		this.buttons.playback.hidden = (gPlatformStr ~= "PS2") or gFinalBuild

		ShowHideVerticalButtons(this.buttons,ifs_mp_vbutton_layout)
		SetCurButton(this.CurButton)
		
--		if(ScriptCB_CheckForPatch) then
--			ScriptCB_CheckForPatch(1)
--		end
		this.bPatchCheckStatus = 0
	end,
	
	Exit = function(this, bFwd)
--		if(ScriptCB_CheckForPatch) then
--			ScriptCB_CheckForPatch(3)
--		end
		IFText_fnSetString(this.newVersion,"")
		
		if (bFwd) then 
--			ScriptCB_SetNoticeNoCable(1)
		else
-- 			if(not (gPlatformStr == "PS2")) then
-- 				ScriptCB_SetNoticeNoCable(1)
			-- 			end

			-- Always reset NetLoginName to what was in profile, as we might
			-- have changed it to the selected user's gamertag as part of a
			-- login [FIX for 5310 NM 7/27/05]
			--local Selection = ifs_login_listbox_contents[ifs_login_listbox_layout.SelectedIdx]
			--ScriptCB_SetNetLoginName(Selection.showstr)
			ScriptCB_SetConnectType("lan")
			ScriptCB_SetNetLoginName(ScriptCB_GetCurrentProfileName())
		end

		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end		
	end,

	Input_Accept = function(this) 
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(this.CurButton == "lan") then
			ScriptCB_SetConnectType(this.CurButton)
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- Hack? Set current service appropriately
			gOnlineServiceStr = "LAN"
			if(gPlatformStr == "PS2") then
				ifs_movietrans_PushScreen(ifs_mpps2_netconfig)
			else
				-- Whine like crazy
				ScriptCB_SetNoticeNoCable(1)
				if(gPlatformStr ~= "PC") then
					ScriptCB_StartLogin()
					ifs_movietrans_PushScreen(ifs_split_profile)
				else
					ifs_movietrans_PushScreen(ifs_mp_main)				
				end
			end
		elseif (this.CurButton == "direct") then
			ScriptCB_SetConnectType(this.CurButton)
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- Hack? Set current service appropriately
			gOnlineServiceStr = "Direct"
			if(gPlatformStr == "PS2") then
				ifs_movietrans_PushScreen(ifs_mpps2_netconfig)
			else
				ifs_movietrans_PushScreen(ifs_mp_main)
			end
		elseif (this.CurButton == "wan") then
			ScriptCB_SetConnectType(this.CurButton)
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- Reacquire default from exe
			gOnlineServiceStr = ScriptCB_GetOnlineService()
			if(gOnlineServiceStr == "XLive") then
				--ifs_movietrans_PushScreen(ifs_mpxl_login)
				-- XLive only has 2-way splitscreen.
				ifs_movietrans_PushScreen(ifs_split2_profile)
			elseif (gOnlineServiceStr == "GameSpy") then
				if(gPlatformStr == "PS2") then
--					ifs_movietrans_PushScreen(ifs_mpps2_dnas)
					ifs_movietrans_PushScreen(ifs_mpps2_netconfig)
				else
					ifs_movietrans_PushScreen(ifs_mpgs_login)
				end
			else
				if(gPlatformStr == "PS2") then
					ifs_movietrans_PushScreen(ifs_mpps2_netconfig)
				else
					ifs_movietrans_PushScreen(ifs_mp_main)
				end
			end
		elseif (this.CurButton == "journal") then
			ScriptCB_EnableJournal()
		elseif (this.CurButton == "playback") then
			ScriptCB_EnablePlayback()
		end
	end,

	-- Gotta skip over lan options if we have no network cable
	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end
		gDefault_Input_GeneralUp(this)
		if((this.CurButton == "lan") and (not this.bCablePresent)) then
			gDefault_Input_GeneralUp(this) -- move cursor off item
		end
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end
		gDefault_Input_GeneralDown(this)
		if((this.CurButton == "lan") and (not this.bCablePresent)) then
			gDefault_Input_GeneralDown(this) -- move cursor off item
		end
	end,
}


-- Does any programatic work to build this screen
function ifs_mp_fnBuildScreen(this)

	this.CurButton = AddVerticalButtons(this.buttons,ifs_mp_vbutton_layout)
end

ifs_mp_fnBuildScreen(ifs_mp)
ifs_mp_fnBuildScreen = nil

AddIFScreen(ifs_mp,"ifs_mp")
