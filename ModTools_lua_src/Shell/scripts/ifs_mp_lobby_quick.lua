--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

function ifs_mp_lobby_quick_fnOnCancel()
	Popup_Busy:fnActivate(nil)
	ifs_mp_sessionlist.bForceRefresh = 1
	ScriptCB_SetInNetGame(nil)

	local EntryService = gOnlineServiceStr
	-- Fix for 11051 - must restore entry connect type if join fails.
	if(ifs_mpxl_friends_fnRestoreOnlineService) then
		ifs_mpxl_friends_fnRestoreOnlineService()
	end

	if(EntryService == gOnlineServiceStr) then
		-- Fix for 11844 - once we start joining, all session info is gone.
		-- Must back up over sessionlist screen, if present. Go back to last
		-- known-safe screen.
		ScriptCB_PopScreen("ifs_mp_main")
	else
		-- If service type changed, need to bail out to "pick connection" screen.
		-- This is because we could have been in XBox Systemlink w/ >1 player,
		-- then the user chooses to join a friend's game, which unbinds the
		-- extra players behind their back. So, force them back to a place they
		-- can easily recover from. Ugly, but necessary. - NM 8/25/05
		ScriptCB_PopScreen("ifs_mp")
	end
end
	
function ifs_mp_lobby_quick_fnOnSuccess()
	Popup_Busy:fnActivate(nil)
	IFObj_fnSetVis(this.launching, 1)
end
	
function ifs_mp_lobby_quick_fnCheckDone()
	return 0
end
	
ifs_mp_lobby_quick = NewIFShellScreen {

-- make it empty screen
--	title = NewIFText {
--		string = "ifs.mp.lobby_server",
--		font = "gamefont_large",
--		textw = 460,
--		texth = 80,
--		y = 0,
--		ScreenRelativeX = 0.5, -- 
--		ScreenRelativeY = 0, -- top
--	},
	
	bg_texture = "iface_bg_1",
	launchflag		= nil,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,    
	bNohelptext_backPC = 1,    

	launching = NewIFText {
		string = "common.launching",
		font = "gamefont_large",
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.3, -- top
		flashy = 0,
	},

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		this.bAutoLaunch = 1
		
		IFObj_fnSetVis(this.launching, nil)
		
		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		if(bFwd) then
			Popup_Busy.fnCheckDone = ifs_mp_lobby_quick_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_mp_lobby_quick_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_mp_lobby_quick_fnOnCancel
			Popup_Busy.fnOnCancel = ifs_mp_lobby_quick_fnOnCancel
			Popup_Busy.bNoCancel = nil
			Popup_Busy.fTimeout = 60 -- seconds
			if (not gFinalBuild) then
				Popup_Busy.fTimeout = 60 * 5
			end
--			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
			Popup_Busy:fnActivate(1)

			ScriptCB_BeginLobby()
		else
			-- force an update, NOW. (we zapped everything leaving this screen, gotta
			-- restore it on re-entry)
			ScriptCB_UpdateLobby(1)
		end
	end,

	Exit = function(this, bFwd)
		if(bFwd) then -- going to sub-screen
			-- Nothing to do
		else
			-- Fix for 11051 - must restore entry connect type if join fails.
			if(ifs_mpxl_friends_fnRestoreOnlineService) then
				ifs_mpxl_friends_fnRestoreOnlineService()
			end
			-- Force mp_main to go back to first button on entry
			ifs_mp_main.bAdjustButtonsOnEntry = 1

			ScriptCB_CancelLobby() -- going back to create opts (host) or sessionlist (client)
		end
	end,
	
	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
		
		ScriptCB_UpdateLobby(nil)

		if(this.bAutoLaunch) then
--			print("Autolaunching...")
			ScriptCB_LaunchLobby()
		end
	end,

	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	
	Input_Back = function(this)
	end,
	Input_Accept = function(this)
	end,

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
		print("ifs_mp_lobby_quick fnPostError(..,",bUserHitYes,ErrorLevel)

		-- Hack for bug 7600 - ifs_mp_lobby_quick's fnPostError gets no error
		-- reported, as it's been cleared by then. So, store a copy of the
		-- last error, as long as it's not a controller-pulled error.
		if((ErrorLevel < 1) and (Popup_Error.iLastNetError)) then
			ErrorLevel = Popup_Error.iLastNetError
			Popup_Error.iLastNetError = nil -- clear this out
		end

		if(ErrorLevel >= 6) then
			if( Popup_Error ) then
				Popup_Error:fnActivate( nil )
			end
			if( Popup_Busy ) then
				Popup_Busy:fnActivate( nil )
			end
			
			if( ifs_mp_sessionlist ) then
				ifs_mp_sessionlist.bForceRefresh = 1
			end
			ScriptCB_PopScreen()
		end

		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end

	end,
}

AddIFScreen(ifs_mp_lobby_quick,"ifs_mp_lobby_quick")
