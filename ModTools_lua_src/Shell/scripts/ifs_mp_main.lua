--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- MP's "main" screen, with options to go to all the rest of the screens

-- Layout for this screen's buttons. Note: do *NOT* delete this out of
-- memory, as it's used during the 

ifs_mp_main_vbutton_layout = {
--	yTop = 110,
	ySpacing = 0,
	width = 400,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "fastclient", string = "common.mp.fastclient", },
		{ tag = "client", string = "common.join", }, -- was "common.mp.client",
		{ tag = "host", string = "ifs.profile.create", }, -- was common.mp.host
		{ tag = "joinip", string = "common.mp.joinip", },
 		{ tag = "friends", string = "common.mp.friends", },
 		{ tag = "download", string = "common.mp.downloadable", },
 		{ tag = "recent", string = "common.mp.recent", },
 		{ tag = "stats", string = "common.mp.stats", },
 		{ tag = "leaderboard", string = "ifs.main.leaderboard", },
 		{ tag = "options", string = "common.mp.options", },
 		{ tag = "signout", string = "common.mp.signout", },
	},
	title = "common.mp.title",
--	rotY = 45,
}

function ifs_mp_fnForceOk()
	return 1
end

-- Helper function, starts the process of hosting, with a flag for
-- dedicated hosting
function ifs_mp_fnStartHosting(this, bDedicated)
--	this.bDedicated = bDedicated
--	ifs_mp_gameopts.bDedicated = bDedicated -- copy setting

	ScriptCB_SetAmHost(1)
	if(gPlatformStr == "PC" ) then	
--		print("I Want to host a multiplayer PC game")
		ScriptCB_SetGameName(ScriptCB_ununicode("Default Game Name"))
		ifs_missionselect_pcMulti.fnDone = ifs_mp_fnMissionsDone
		ifs_missionselect_pcMulti.bForMP = 1
		ScriptCB_SetGameRules("mp")
		ifs_movietrans_PushScreen(ifs_missionselect_pcMulti)	
	else
		
	--	ScriptCB_SetDedicated(bDedicated)
		
		local LoginIdx = ifs_login_listbox_layout.SelectedIdx
		if((not LoginIdx) or (LoginIdx < 1)) then
			LoginIdx = 1
		end
		
		ifs_vkeyboard.CurString = ScriptCB_GetCurrentProfileNetName()
		ifs_vkeyboard.bCursorOnAccept = 1 -- start cursor on Accept
		
		--			IFText_fnSetString(ifs_vkeyboard.title,"ifs.mp.create.entername")
		IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_gamename")
		vkeyboard_specs.fnDone = ifs_mp_fnKeyboardDone
		vkeyboard_specs.fnIsOk = ifs_login_fnIsAcceptable -- reuse this

		local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		vkeyboard_specs.MaxWidth = (w * 0.5)
		vkeyboard_specs.MaxLen = 32

		if(gOnlineServiceStr == "XLive") then
			ifs_mp_fnKeyboardDone() -- act like we went thru this
		else
			ifs_movietrans_PushScreen(ifs_vkeyboard)
		end
	end
end

function ifs_mp_fnMissionsDone()
	if(ifs_missionselect.SelectedMap) then
		ifs_mp_main.bAutoLaunch = 1
		ScriptCB_BeginLobby()
		ScriptCB_PopScreen("ifs_mp_main") -- back to this screen
--		ifs_movietrans_PushScreen(ifs_mp_gameopts)
	end
end

-- Yep, this really does nothing...
function ifs_mp_DoNothing()
end

-- Returns 1 if this is the primary joystick, 2 if it's the secondary,
-- or nil if a different one.
function ifs_mp_fnTranslateJoystick(this, iJoystick)
	if ((iJoystick+1) == this.iPrimaryPort) then
		return 1 -- primary
	end

	if(this.iSecondaryPort and ((iJoystick+1) == this.iSecondaryPort)) then
		return 2 -- secondary
	end

	return nil -- neither primary nor secondary
end

-- Callback function when the virtual keyboard is done
function ifs_mp_fnKeyboardDone()
	if(string.len(ifs_vkeyboard.CurString) > 1) then

		-- Hack! Netcode should be unicoded
		ScriptCB_SetGameName(ScriptCB_ununicode(ifs_vkeyboard.CurString))
--		ifs_vkeyboard.CurString = "" -- clear
		ifs_missionselect.fnDone = ifs_mp_fnMissionsDone
		if(gOnlineServiceStr == "XLive") then
			-- So that we don't go back two screens on exiting.
			ifs_missionselect.fnCancel = ifs_mp_DoNothing
		else
			ifs_missionselect.fnCancel = nil
		end
		ifs_missionselect.bForMP = 1
		ScriptCB_SetGameRules("mp")
		
		if(ifs_sp.bForSplitScreen) then
-- 			ifs_movietrans_PushScreen(ifs_split_map)
			ScriptCB_SetIFScreen("ifs_split_map")
		else
			if(gOnlineServiceStr == "XLive") then
				-- XLive never had the VK. Don't replace this screen with next - NM 8/6/05
				ifs_movietrans_PushScreen(ifs_missionselect)
			else
				--do SetIFScreen so we don't back out to the keyboard--cbb 08/04/05
				ScriptCB_SetIFScreen("ifs_missionselect")
			end
		end
	else
	end
end

-- Callbacks from the "Really signout?" popup. If bResult is true,
-- they selected 'yes'
function ifs_xlive_main_fnLogoutPopupDone(bResult)
	local this = ifs_mp_main
	if(bResult) then
		-- They really want to kill the login
		if(gPlatformStr == "XBox") then
			ScriptCB_CancelLogin()
		end

		-- But, for bug 11051, if we're in LAN mode after a failed friend join,
		-- then we need to back up further.
		if((gOnlineServiceStr == "LAN") and (ScriptCB_IsScreenInStack("ifs_split2_profile"))) then
			ScriptCB_PopScreen("ifs_mp") -- kick back further
		else
			ScriptCB_PopScreen() -- default action
		end
	end
	IFObj_fnSetVis(this.buttons, 1) -- always re-enable screen
end

-- Callbacks from the "No sessions found, create one?" popup. If
-- bResult is true, they selected 'yes'
function ifs_xlive_main_fnAskCreateDone(bResult)
	local this = ifs_mp_main
	if(bResult) then
		ifs_mp_fnStartHosting(this, nil)
	end
	IFObj_fnSetVis(this.buttons, 1) -- always re-enable screen
end

-- Callbacks from the busy popup

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_main_quickmatch_fnCheckDone()
--	local this = ifs_main_quickmatch
	ScriptCB_UpdateQuickmatch() -- think...

	return ScriptCB_IsQuickmatchDone()
end

-- Callback function when the virtual keyboard is done
function ifs_mp_main_fnKeyboardDone()
--	print("ifs_mp_gameopts_fnKeyboardDone()")
	local this = ifs_mp_main
	this.LastPasswordStr = ScriptCB_ununicode(ifs_vkeyboard.CurString)
	this.bPasswordJoinOnEnter = 1
	ScriptCB_PopScreen()
--	vkeyboard_specs.fnDone = nil -- clear our registration there
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_mp_main_fnIsAcceptable()
--	print("ifs_mp_gameopts_fnIsAcceptable()")
	return 1,"" -- any value is acceptable for a password
end

function ifs_main_quickmatch_fnOnSuccess()
	local this = ifs_mp_main
--	print(" ** ifs_main_quickmatch_fnOnSuccess")
	Popup_Busy:fnActivate(nil)
	if(ifs_vkeyboard and ScriptCB_IsQuickmatchPassworded()) then
		ifs_vkeyboard.CurString = ScriptCB_tounicode("")
		ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
		vkeyboard_specs.bPasswordMode = 1
		
		IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
		vkeyboard_specs.fnDone = ifs_mp_main_fnKeyboardDone
		vkeyboard_specs.fnIsOk = ifs_mp_main_fnIsAcceptable
		
		local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		vkeyboard_specs.MaxWidth = (w * 0.5)
		vkeyboard_specs.MaxLen = 16
		ifs_movietrans_PushScreen(ifs_vkeyboard)
	else

		ScriptCB_LaunchQuickmatch()
		ifs_missionselect.bForMP = 1
		ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
	end
end

function ifs_main_fnAdjustButtonVis(this, bSetCurButton)
	-- set the title to the current connection type
	if(gOnlineServiceStr == "Direct") then
		IFText_fnSetString(this.buttons._titlebar_,"ifs.mp.connection.direct")
	elseif (gOnlineServiceStr == "XLive") then
		IFText_fnSetString(this.buttons._titlebar_, "ifs.mp.connection.xlive")
	elseif (gOnlineServiceStr == "GameSpy") then
		IFText_fnSetString(this.buttons._titlebar_, "ifs.mp.connection.gamespy")
	elseif (gOnlineServiceStr == "LAN") then
		IFText_fnSetString(this.buttons._titlebar_,"ifs.mp.connection.lan")
	elseif (gOnlineServiceStr == "GameSpy") then
		IFText_fnSetString(this.buttons._titlebar_,"ifs.mp.connection.gamespy")
	end
	

	-- always re-enable screen on entry (by default). Might be turned off below
	--		print("turning on this.buttons")
	IFObj_fnSetVis(this.buttons, 1) 
	--	if(this.Helptext_Back) then
	--		print("turning on helptext back and accept")
	--		IFObj_fnSetVis(this.Helptext_Back, 1)
	--		IFObj_fnSetVis(this.Helptext_Accept, 1)
	--	end
	--	print("done turning on helptext back and accept")
	local bForXLive = (gOnlineServiceStr == "XLive")
	local bForGamespy = (gOnlineServiceStr == "GameSpy")
	this.buttons.fastclient.hidden = not bForXLive
	this.buttons.recent.hidden = not bForXLive
	this.buttons.stats.hidden = not bForXLive
	this.buttons.joinip.hidden = (gOnlineServiceStr ~= "Direct")
	this.buttons.download.hidden = (not bForXLive) or ScriptCB_HideDownloadableContent()
	this.buttons.signout.hidden = not bForXLive
	this.buttons.leaderboard.hidden = not( ( bForXLive or bForGamespy ) and ScriptCB_IsEnableLeaderBoard() )
	this.buttons.options.hidden = (gPlatformStr == "PC")

	if(gPlatformStr == "XBox") then
		if(bForXLive) then
			ifs_mp_main_vbutton_layout.ySpacing = gButtonGutter * 0.5
		else
			-- Syslink
			ifs_mp_main_vbutton_layout.ySpacing = gButtonGutter 				
		end
	end

	this.bIsLoggedIn = ScriptCB_IsLoggedIn()
	this.fFriendCheck = 0.1
	this.buttons.friends.hidden = not this.bIsLoggedIn
	this.buttons.leaderboard.hidden = not this.bIsLoggedIn
	if(bForXLive) then
		local RealUser = ScriptCB_XL_GetLoginName(ScriptCB_GetPrimaryController() + 1, 1) -- returns nil if guest
		if(not RealUser) then
			this.buttons.friends.hidden = 1
			this.buttons.recent.hidden = 1
			this.buttons.stats.hidden = 1
		end
	end

	if(gPlatformStr == "XBox") then
		if(not bForXLive) then
			IFText_fnSetString(this.buttons.client.label,"common.mp.client_lan") -- search
			-- no leaderboard for system link on XBOX
			this.buttons.leaderboard.hidden = 1
		else
			IFText_fnSetString(this.buttons.client.label,"common.mp.client")
		end
		IFText_fnSetString(this.buttons.host.label,"common.mp.host")
	end

	this.buttons.client.hidden = (gOnlineServiceStr == "Direct")

	-- If we have flag set to set cur button, do so. Else, just show it.
	local NewTopButton = ShowHideVerticalButtons(this.buttons,ifs_mp_main_vbutton_layout)
	if(bSetCurButton) then
		this.CurButton = NewTopButton
		SetCurButton(this.CurButton, this)
	end
end

function ifs_main_quickmatch_fnOnFail()
--	print("Quickmatch search failed")

	-- Fix for 11051 - must restore entry connect type if join fails.
	if(ifs_mpxl_friends_fnRestoreOnlineService) then
		ifs_mpxl_friends_fnRestoreOnlineService()
		ifs_main_fnAdjustButtonVis(ifs_mp_main, 1)
	end

	Popup_Busy:fnActivate(nil)
--	print(" ** ifs_main_quickmatch_fnOnFail")
	Popup_YesNo.CurButton = "no" -- default
	Popup_YesNo.fnDone = ifs_xlive_main_fnAskCreateDone
	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo, "ifs.quickopti.nonefound")
end

function ifs_mp_main_fnPostOKPopup()
	local this = ifs_mp_main
	IFObj_fnSetVis(this.buttons, 1)
end

function ifs_main_specialmatch_fnOnFail()
--	print("Special search failed")

	-- Fix for 11051 - must restore entry connect type if join fails.
	if(ifs_mpxl_friends_fnRestoreOnlineService) then
		ifs_mpxl_friends_fnRestoreOnlineService()
		ifs_main_fnAdjustButtonVis(ifs_mp_main, 1)
	end

	Popup_Busy:fnActivate(nil)
--	print(" ** ifs_main_specialmatch_fnOnFail")
	Popup_Ok_Large.fnDone = ifs_mp_main_fnPostOKPopup
	Popup_Ok_Large:fnActivate(1)

	-- Fix for 12139 - only XBox has this string. Other platforms get error in
	-- common localize file.
	if(gPlatformStr == "XBox") then
		gPopup_fnSetTitleStr(Popup_Ok_Large, "xlive.errors.sessionnotavailable")
	else
		gPopup_fnSetTitleStr(Popup_Ok_Large, "ifs.mp.joinerrors.noconnect")
	end

end

-- User hit cancel. Do what they want.
function ifs_main_quickmatch_fnOnCancel()
	local this = ifs_mp_main

	-- Stop logging in.
	ScriptCB_CancelQuickmatch()

	-- Fix for 11051 - must restore entry connect type if join fails.
	if(ifs_mpxl_friends_fnRestoreOnlineService) then
		ifs_mpxl_friends_fnRestoreOnlineService()
		ifs_main_fnAdjustButtonVis(ifs_mp_main, 1)
	end

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
--	print(" ** ifs_main_quickmatch_fnOnCancel")
	IFObj_fnSetVis(this.buttons, 1)
end

ifs_mp_main = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	bFriendsIcon = 1,
	bAcceptIsSelect = 1,

	bAutoLaunch = nil,
	
	launching = NewIFText {
		string = "common.launching",
		font = "gamefont_large",
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.3, -- top
		flashy = 0,
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},
		
	Enter = function(this, bFwd)
		-- Call default Enter function
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Function test added NM 6/17/05. Remove after about a week
		if(ScriptCB_RestorePrimaryController) then
			-- Always restore true primary controller on entry, in case it was ever switched
			ScriptCB_RestorePrimaryController()
		end

		ifs_main.bJumpToMPMain = nil -- always clear this

		-- right align the ok button	
		if(gPlatformStr == "PC") then
			gIFShellScreenTemplate_fnMoveClickableButton(this.JoinIPBtn,this.JoinIPBtn.label,0)
		end
		
--		print("gOnlineServiceStr ===========" ,gOnlineServiceStr) 
		-- Force a refresh of this
		ScriptCB_SetNetLoginName(ScriptCB_GetCurrentProfileNetName())

		if(this.JoinIPBox) then -- hidden until button is selected
			IFObj_fnSetVis(this.JoinIPBox, nil)
			IFObj_fnSetVis(this.JoinIPBtn, nil)
			this.bJoinIPBoxVis = nil
		end

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
--			print("ifs_mp_main, ErrorLevel = ",ErrorLevel)
			if(ErrorLevel >= 8) then -- login error, must keep going further
				ScriptCB_PopScreen()
			else
				-- In-session error that requires leaving it. We know we're
				-- out of it now, can do things normally.
				ScriptCB_ClearError()
			end
		end
		

		if(this.bPasswordJoinOnEnter) then
			this.bPasswordJoinOnEnter = nil
			ScriptCB_LaunchQuickmatch(this.LastPasswordStr)
			ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
			return
		end

		if(gOnlineServiceStr == "XLive") then
			ifs_XLive_fnUpdateSilentLoginBox(this)
		end

		--print("turning on helptext back and accept")
		IFObj_fnSetVis(this.LoginInfoWindow, (gOnlineServiceStr == "XLive"))
		
		ifs_main_fnAdjustButtonVis(this, bFwd or ifs_mp_main.bAdjustButtonsOnEntry)
		ifs_mp_main.bAdjustButtonsOnEntry = nil

		if(not bFwd) then
			if(ifs_mp_main.bHostOnEnter) then
				ifs_mp_fnStartHosting(this, nil)
				ifs_mp_main.bHostOnEnter = nil
			end
		end
		SetCurButton(this.CurButton)
		ifs_mp_main.bHostOnEnter = nil
		
		-- Move friends icon if appropriate
		if(ScriptCB_GetOnlineService() == "XLive") then
			local XPos = IFText_fnGetExtent(this.buttons.friends.label) + 30
			local YPos = this.buttons.friends.y - 15
			IFObj_fnSetPos(this.buttons.FriendIcon,XPos,YPos)
			IFObj_fnSetVis(this.buttons.FriendIcon, this.bIsLoggedIn)
		else
			IFObj_fnSetVis(this.buttons.FriendIcon, nil) -- just hide it.
		end

		local bSetFlow = nil
		local bSpecialJoinPending = ScriptCB_IsSpecialJoinPending()

		if(bFwd) then -- if entering this screen from main menu, start network
			ScriptCB_OpenNetShell(1)
			-- If we have a special join ready, then ignore auto-rejoin info.
			if (ScriptCB_InNetGame() and (not bSpecialJoinPending)) then
				if (ScriptCB_NetWasHost()) then
					if (ScriptCB_NetWasDedicated()) then
						if( ( ScriptCB_NetWasDedicatedQuit() == 0 ) or			-- pause menu disactivated
							( ScriptCB_NetWasDedicatedQuit() == 1 ) ) then		-- pause menu activated but didn't select quit
							-- not quit from dedicated server
							ScriptCB_SetAmHost(1)
							ScriptCB_SetDedicated(1)
							ifs_movietrans_PushScreen(ifs_mp_lobby);
							bSetFlow = 1
						end
					else
						ScriptCB_SetAmHost(1)
						ScriptCB_SetDedicated(nil)
						--ifs_movietrans_PushScreen(ifs_mp_lobby);
						bSetFlow = 1
						ifs_mp_main.bAutoLaunch = 1
						IFObj_fnSetVis(this.buttons, nil)
						if(this.Helptext_Back) then
							IFObj_fnSetVis(this.Helptext_Back, nil)
						end
						if(this.Helptext_Accept) then
							IFObj_fnSetVis(this.Helptext_Accept, nil)
						end
						IFObj_fnSetVis(this.LoginInfoWindow, nil)
						ScriptCB_BeginLobby()						
					end
				elseif (ScriptCB_NetWasClient()) then
					-- todo make a special session list for autojoining last game
					ScriptCB_SetAmHost(nil)
					ScriptCB_SetDedicated(nil)
					ifs_movietrans_PushScreen(ifs_mp_sessionlist)     
					bSetFlow = 1
				end
			end
		end

--		print(" ** Before special join!")

		local CmdlinePending = ScriptCB_IsCmdlineJoinPending()
		if(CmdlinePending) then
			this.bJoinIPOnEntry = 1
			ifs_vkeyboard = ifs_vkeyboard or {}
			ifs_vkeyboard.CurString = CmdlinePending
		end

		-- See if we need to do a JoinIP (or an XLive join friend)
		if((not bSetFlow) and ((this.bJoinIPOnEntry) or (bSpecialJoinPending))) then
--			print(" ** Begin special join!")
			ScriptCB_SetAmHost(nil)
			ScriptCB_SetDedicated(nil)
			if(this.bJoinIPOnEntry) then
				ScriptCB_BeginJoinIP(ifs_vkeyboard.CurString)
			else
				ScriptCB_BeginJoinSpecial()
			end
			IFObj_fnSetVis(this.buttons, nil)

			Popup_Busy.fnCheckDone = ifs_main_quickmatch_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_main_quickmatch_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_main_specialmatch_fnOnFail
			Popup_Busy.fnOnCancel = ifs_main_quickmatch_fnOnCancel
			Popup_Busy.bNoCancel = nil
			Popup_Busy.fTimeout = 15 -- seconds
--			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
			Popup_Busy:fnActivate(1)
--			print(" ** Special join - popup open")

			this.bJoinIPOnEntry = nil
		end

--		print(" ** Special join - post startup")

		this.iPrimaryPort = ScriptCB_GetPrimaryController() + 1
		this.iSecondaryPort = nil
		this.LoginName2 = nil -- clear

		if(this.Friend2InfoWindow) then
			IFObj_fnSetVis(this.Friend2InfoWindow, nil) -- default off, until proven otherwise
		end
		if(gOnlineServiceStr == "XLive") then
			-- Function test added NM 6/15/05. Remove after about a week.
			if(ScriptCB_GetSecondaryController) then
				this.iSecondaryPort = ScriptCB_GetSecondaryController()
				if(this.iSecondaryPort) then
					this.iSecondaryPort = this.iSecondaryPort + 1 -- convert from C's 0-base to Lua's 1-base
				end
			end

			this.LoginName1 = ScriptCB_XL_GetLoginName(this.iPrimaryPort, 1)
			if(this.iSecondaryPort) then
				this.LoginName2 = ScriptCB_XL_GetLoginName(this.iSecondaryPort, 1)
			end
			-- And, update helptext in there as necessary
			if(this.iSecondaryPort and this.LoginName2) then
				local ShowUStr = ScriptCB_usprintf("ifs.mp.main.player2friends",ScriptCB_tounicode(this.LoginName2))
				IFText_fnSetUString(this.Friend2InfoWindow.ShowText, ShowUStr)
			end

			-- Hide info window if not possible to access it
			IFObj_fnSetVis(this.Friend2InfoWindow, (this.iSecondaryPort and this.LoginName2))
		end -- XBox code for multiple friends

		-- Always turn on read-all, but no new bindings.
		ScriptCB_ReadAllControllers(1,1)

		IFObj_fnSetVis(this.launching, this.bAutoLaunch)
		if(this.bAutoLaunch) then
			IFObj_fnSetVis(this.LoginInfoWindow, nil)
			if (this.Helptext_Accept) then
				IFObj_fnSetVis(this.Helptext_Accept, nil)
			end
			if (this.Helptext_Back) then
				IFObj_fnSetVis(this.Helptext_Back, nil)
			end
			IFObj_fnSetVis(this.buttons, nil)
		end

		-- Also stop the movie (if going)
		ifelem_shellscreen_fnStopMovie()
	end,

	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		IFObj_fnSetVis(this.launching, this.bAutoLaunch)


		-- Periodically, see if we're still logged in. As we show 'friends' in
		-- the Syslink UI, we need to immediately hide that if the XLive login
		-- goes sour.
		this.fFriendCheck = this.fFriendCheck - fDt
		if(this.fFriendCheck < 0) then
			this.fFriendCheck = 0.1
			local bIsLoggedIn = ScriptCB_IsLoggedIn()
			if(this.bIsLoggedIn ~= bIsLoggedIn) then
				this.bIsLoggedIn = bIsLoggedIn
				this.buttons.friends.hidden = not this.bIsLoggedIn
				IFObj_fnSetVis(this.buttons.FriendIcon, this.bIsLoggedIn)
				ShowHideVerticalButtons(this.buttons,ifs_mp_main_vbutton_layout) -- refresh buttons
				if (this.CurButton == "friends") then
					this:Input_GeneralUp(this.iPrimaryPort - 1) -- move off now-disabled option
				end
			end
		end

		if(this.bAutoLaunch) then
			if (this.Helptext_Accept) then
				IFObj_fnSetVis(this.Helptext_Accept, nil)
			end
			if (this.Helptext_Back) then
				IFObj_fnSetVis(this.Helptext_Back, nil)
			end
			IFObj_fnSetVis(this.buttons, nil)
			IFObj_fnSetVis(this.LoginInfoWindow, nil)

			ScriptCB_UpdateLobby(nil)
	
--			print("Autolaunching...")
			ScriptCB_LaunchLobby()
		end
	end,

	Exit = function(this, bFwd)
		ScriptCB_ReadAllControllers(nil) -- don't read all anymore
		if(bFwd) then
			-- going to a sub-page of this. Don't need to do anything
		else
			-- if leaving this screen towards the main menu, close network
			-- [Except for XLive and its silent login nonsense]
			if(gPlatformStr ~= "XBox") then
				ScriptCB_CancelLogin()
			end

			ScriptCB_CloseNetShell(1)
		end
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end
	end,

	Input_Accept = function(this, iJoystick) 
		local iPort = ifs_mp_fnTranslateJoystick(this, iJoystick)
		if(iPort ~= 1) then
			return -- input from a bad controller
		end

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.CurButton == "host") then
			ScriptCB_ClearPrevSessionId()
			ifs_mp_fnStartHosting(this, nil)
		elseif (this.CurButton == "fastclient") then
			ScriptCB_SetAmHost(nil)
			ScriptCB_SetDedicated(nil)
			ScriptCB_SetGameRules("mp")
			ScriptCB_BeginQuickmatch()
			IFObj_fnSetVis(this.buttons, nil)

			Popup_Busy.fnCheckDone = ifs_main_quickmatch_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_main_quickmatch_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_main_quickmatch_fnOnFail
			Popup_Busy.fnOnCancel = ifs_main_quickmatch_fnOnCancel
			Popup_Busy.bNoCancel = nil -- allow cancel button
			Popup_Busy.fTimeout = 15 -- seconds
--			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
			Popup_Busy:fnActivate(1)
		elseif (this.CurButton == "client") then
			ScriptCB_SetAmHost(nil)
			ScriptCB_SetDedicated(nil)
			ScriptCB_SetGameRules("mp")
			ifs_missionselect.bForMP = 1
			if (gPlatformStr == "PS2") then
				ifs_movietrans_PushScreen(ifs_mpps2_optimatch)
			elseif (gOnlineServiceStr == "XLive") then
				ifs_movietrans_PushScreen(ifs_mpxl_optimatch)
			else
				ifs_movietrans_PushScreen(ifs_mp_sessionlist)
			end
			--		elseif (this.CurButton == "dedicated") then
			--			ifs_mp_fnStartHosting(this,1)
		elseif (this.CurButton == "joinip" or this.CurButton=="launch") then
			ScriptCB_SetGameRules("mp")
			if(not this.bJoinIPBoxVis) then
				local JoinIP = ScriptCB_GetProfileJoinIP()
				if( JoinIP ) then
--					print("JoinIP = ", JoinIP)
					IFEditbox_fnSetString(this.JoinIPBox.ipedit,JoinIP)
				end
				
				IFObj_fnSetVis(this.JoinIPBox, this.bJoinIPBoxVis)
				IFObj_fnSetVis(this.JoinIPBtn, this.bJoinIPBoxVis)
				this.bJoinIPBoxVis = 1
			else
				-- box was visible. Now try and join
				this.bJoinIPBoxVis = nil
				ScriptCB_SetConnectType("direct")
				gOnlineServiceStr  = "Direct"
				local JoinIPStr = IFEditbox_fnGetString(this.JoinIPBox.ipedit)
				ScriptCB_SetProfileJoinIP(JoinIPStr)

				local PassStr = IFEditbox_fnGetString(this.JoinIPBox.passedit)

				ScriptCB_SetAmHost(nil)
				ScriptCB_SetDedicated(nil)
				ScriptCB_BeginJoinIP(JoinIPStr,PassStr)
				IFObj_fnSetVis(this.buttons, nil)

				Popup_Busy.fnCheckDone = ifs_main_quickmatch_fnCheckDone
				Popup_Busy.fnOnSuccess = ifs_main_quickmatch_fnOnSuccess
				Popup_Busy.fnOnFail = ifs_main_specialmatch_fnOnFail
				Popup_Busy.fnOnCancel = ifs_main_quickmatch_fnOnCancel
				Popup_Busy.bNoCancel = nil
				Popup_Busy.fTimeout = 15 -- seconds
--			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
				IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
				Popup_Busy:fnActivate(1)
			end

			IFObj_fnSetVis(this.JoinIPBox, this.bJoinIPBoxVis)
			IFObj_fnSetVis(this.JoinIPBtn, this.bJoinIPBoxVis)

		elseif (this.CurButton == "download") then
			ScriptCB_RebootToDownloaderXBE()
			--this function doesn't return.
		elseif (this.CurButton == "options") then
			ifs_movietrans_PushScreen(ifs_opt_mp)
		elseif (this.CurButton == "friends") then
			if(ScriptCB_GetOnlineService() == "XLive") then -- check what we're compiled for
				ifs_mpxl_friends.bRecentMode = nil
				ifs_movietrans_PushScreen(ifs_mpxl_friends)
			else
				ifs_movietrans_PushScreen(ifs_mpgs_friends)
			end
		elseif (this.CurButton == "recent") then
			ifs_mpxl_friends.bRecentMode = 1
			ifs_movietrans_PushScreen(ifs_mpxl_friends)
		elseif (this.CurButton == "stats") then
			-- init gamertag info
			ifs_mp_leaderboarddetails.gamertag = nil
			ifs_mp_leaderboarddetails.playerrank = nil
			ifs_mp_leaderboarddetails.playerrating = nil
			ifs_mp_leaderboarddetails.playerindex = 1
			local time_filter = 3	--[1-3] weekly, monthly, overall
			local game_mode = 1		--[1-5] conquest, ctf1, ctf2, obj, team dm
			ScriptCB_SetLeaderBoardID( 3, 1 )
			ifs_movietrans_PushScreen(ifs_mp_leaderboarddetails)
		elseif (this.CurButton == "leaderboard") then
			ifs_movietrans_PushScreen(ifs_mp_leaderboard)
		elseif (this.CurButton == "signout") then
			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_xlive_main_fnLogoutPopupDone
			IFObj_fnSetVis(this.buttons, nil) -- re-enable screen
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pickacct.asksignout")
		end
	end,

	Input_Back = function(this, iJoystick)
		local iPort = ifs_mp_fnTranslateJoystick(this, iJoystick)
		if(iPort ~= 1) then
			return -- input from a bad controller
		end

		local bAskSignout = ((gOnlineServiceStr == "GameSpy") and (ScriptCB_IsLoginDone() > 0))

		if(bAskSignout) then
			-- Need to pop up "really signout" dialog

			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_xlive_main_fnLogoutPopupDone
			IFObj_fnSetVis(this.buttons, nil) -- re-enable screen
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pickacct.asksignout")
		else 
			-- not GS, no need to "sign out"
			-- But, for bug 11051, if we're in LAN mode after a failed friend join,
			-- then we need to back up further.
			if((gOnlineServiceStr == "LAN") and (ScriptCB_IsScreenInStack("ifs_split2_profile"))) then
				ScriptCB_PopScreen("ifs_mp") -- kick back further
			else
				ScriptCB_PopScreen() -- default action
			end
		end
	end,

	Input_GeneralUp = function(this, iJoystick)
		local iPort = ifs_mp_fnTranslateJoystick(this, iJoystick)
		if(iPort ~= 1) then
			return -- input from a bad controller
		end

		gDefault_Input_GeneralUp(this)
	end,

	Input_GeneralDown = function(this, iJoystick)
		local iPort = ifs_mp_fnTranslateJoystick(this, iJoystick)
		if(iPort ~= 1) then
			return -- input from a bad controller
		end

		gDefault_Input_GeneralDown(this)
	end,

	Input_Misc2  = function(this, iJoystick)
		local iPort = ifs_mp_fnTranslateJoystick(this, iJoystick)
		if(iPort ~= 2) then
			return -- input from a bad controller
		end

		if(this.iSecondaryPort and this.LoginName2) then
			-- Function test added NM 6/17/05. Remove after about a week.
			if(ScriptCB_SwapPrimaryController) then
				ScriptCB_SwapPrimaryController()
			end
			ifs_mpxl_friends.bRecentMode = nil
			ifs_movietrans_PushScreen(ifs_mpxl_friends)
		end
	end,

	Input_KeyDown = function(this, iKey)

		if(gCurEditbox) then
			if(iKey == 10) then -- handle Enter different
				gCurEditbox = nil
				this.CurButton = "joinip"
				this:Input_Accept()
			elseif (iKey == 9) then
				-- Handle tab key
				if(gCurEditbox) then
					IFEditbox_fnHilight(gCurEditbox, nil)
				end
				if(gCurEditbox == this.JoinIPBox.ipedit) then
					gCurEditbox = this.JoinIPBox.passedit
				elseif (gCurEditbox == this.JoinIPBox.passedit) then
					gCurEditbox = this.JoinIPBox.ipedit
				end
				if(gCurEditbox) then
					IFEditbox_fnHilight(gCurEditbox, 1)
				end
			else
				IFEditbox_fnAddChar(gCurEditbox, iKey)
			end
		end
	end,

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
--		print("ifs_mp_main fnPostError(..,",bUserHitYes,ErrorLevel)
		if(ErrorLevel >= 6) then
			ScriptCB_PopScreen()
		end

		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end

	end,

}


-- Does any programatic work to build this screen
function ifs_mp_main_fnBuildScreen(this)
	local InfoWindowW = 260
	local InfoWindowH = 55

	this.LoginInfoWindow = NewIFContainer {
		ScreenRelativeY = 0.0, -- top
		ScreenRelativeX = 1.0, -- right
		x = InfoWindowW * -0.5,
		y = InfoWindowH * 0.5,
		width = InfoWindowW,
		height = InfoWindowH,
		ZPos = 200,
	}

	this.LoginInfoWindow.ShowText = NewIFText {
		font = "gamefont_small",
		textw = InfoWindowW - 20,
		texth = InfoWindowH - 10,
		nocreatebackground = 1,		
		startdelay = math.random() * 0.5,
		valign = "vcenter",
	}

	if(gPlatformStr == "XBox") then
		ifs_mp_main_vbutton_layout.bNoDefaultSizing = 1

		this.Friend2InfoWindow = NewButtonWindow {
			ScreenRelativeY = 1.0, -- top
			ScreenRelativeX = 0.5, -- right
			x = 0,
			y = InfoWindowH * -0.5 - 25,
			width = InfoWindowW + 60,
			height = InfoWindowH,
			ZPos = 200,
		}

		this.Friend2InfoWindow.ShowText = NewIFText {
			font = "gamefont_small",
			textw = InfoWindowW - 20 + 60,
			texth = InfoWindowH - 10,
			nocreatebackground = 1,		
			startdelay = math.random() * 0.5,
			valign = "vcenter",
		}

		-- Move buttons up to compensate for things
		this.buttons.y = -10
	end

	-- Not needed anymore now that things are centered - NM 6/3/05
-- 	if(gOnlineServiceStr == "XLive") then
-- 		ifs_mp_main_vbutton_layout.font = "gamefont_small"
-- 	end

	this.CurButton = AddVerticalButtons(this.buttons,ifs_mp_main_vbutton_layout)

	if(gPlatformStr == "PC") then
		local EditBoxW = 375
		local EditBoxH = 40
		local EditBoxYSpace = 15

		this.JoinIPBox = NewIFContainer
		{
			ScreenRelativeX = 0.5, -- right
			ScreenRelativeY = 0.65, -- a bit below buttons
			-- rotY = 35,

			iptitle = NewIFText {
				string ="common.mp.joinip_prompt",
				font = "gamefont_small",
				textw = 250,
				x = -260 + EditBoxW * -0.5,
				y = -12,
				halign = "right",
				nocreatebackground = 1,
			},

			ipedit = NewEditbox {
				width = EditBoxW,
				height = EditBoxH,
				font = "gamefont_medium",
				--		string = "Player 1",
				MaxLen = EditBoxW - 30,
				MaxChars = 19,
			},

			passtitle = NewIFText {
				string ="ifs.gsprofile.password",
				font = "gamefont_small",
				textw = 250,
				x = -260 + EditBoxW * -0.5,
				y = -12 + EditBoxH + EditBoxYSpace,
				halign = "right",
				nocreatebackground = 1,
			},

			passedit = NewEditbox {
				width = EditBoxW,
				height = EditBoxH,
				font = "gamefont_medium",
				--		string = "Player 1",
				MaxLen = EditBoxW - 30,
				MaxChars = 25,
				y = EditBoxH + EditBoxYSpace,
				bPasswordMode = 1,
			},
		}
		
		
		local BackButtonW = 100
		local w,h = ScriptCB_GetSafeScreenInfo()
		this.JoinIPBtn = NewClickableIFButton
		{ 
			ScreenRelativeX = 1,
			ScreenRelativeY = 1,
			y = -15, 
			btnw = BackButtonW, 
			btnh =  ScriptCB_GetFontHeight("gamefont_medium"),
			font = "gamefont_medium", 
			bg_tail = 20,
			nocreatebackground = 1,
			tag = "launch",
			string = "common.ok",
		}
		

	end

end

ifs_mp_main_fnBuildScreen(ifs_mp_main)
ifs_mp_main_fnBuildScreen = nil
AddIFScreen(ifs_mp_main,"ifs_mp_main")
