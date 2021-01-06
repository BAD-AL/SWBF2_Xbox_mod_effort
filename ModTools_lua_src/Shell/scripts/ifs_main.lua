--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- Callback for the "not enough profiles" (QA bug 793) error
function ifs_main_CantEnterSplitOk()
	local this = ifs_main
	IFObj_fnSetVis(this.buttons,1)
end

ifsmain_vbutton_layout = {
--	yTop = -70, -- auto-calc'd now
	xWidth = 460,
	width = 460,
	xSpacing = 6,
	ySpacing = 5,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "sp", string = "ifs.main.sp", },
		{ tag = "mp", string = "ifs.main.mp", },
		{ tag = "split", string = "ifs.main.split", },
		{ tag = "tutorials", string = "ifs.main.tutorials", },
		{ tag = "opts", string = "ifs.main.options", },
		{ tag = "back2", string = "ifs.main.profiles", },
		{ tag = "quit", string = "common.quit2windows", },
		{ tag = "quitdemo", string = "ifs.main.quitdemo", },
	},
	title = "ifs.main.title",
}

-- 
function ifs_main_fnQuitPopupDone(bResult)
	local this = ifs_main	
	IFObj_fnSetVis(this.buttons,1)	

	if(bResult) then
		ScriptCB_QuitToWindows()
	elseif( ifs_main.do_save == 1 ) then
		ifs_main.do_save = nil
		ScriptCB_PopScreen("ifs_main")
	end
end

function ifs_main_fnQuitDemoPopupDone(bResult)
	local this = ifs_main
	IFObj_fnSetVis(this.buttons,1)
	IFObj_fnSetVis(this.logo_temp,1)

	if(bResult) then
		ifs_movietrans_PushScreen(ifs_postdemo)
	end
end

-- Callback from the 'No network adaptor' popup
function ifs_main_fnPostNoNetHW()
	local this = ifs_main
	IFObj_fnSetVis(this.buttons, 1)
end

function ifs_main_DoQuit( )
	Popup_YesNo.CurButton = "no" -- default
	Popup_YesNo.fnDone = ifs_main_fnQuitPopupDone
	IFObj_fnSetVis(ifs_main.buttons,nil)
	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo, "ifs.main.askquit")
end

function ifs_main_SaveDirtyAcceptQuit(fRet)
	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)

	ifs_main.do_save = nil
	if(fRet < 1.5) then
--		print("ifs_main_SaveDirtyAccept(A - Save)")
		ifs_main.do_save = 1
		ifs_saveop.doOp = "SaveProfile"
		ifs_saveop.OnSuccess = ifs_main_DoQuit
		ifs_saveop.OnCancel = ifs_main_SaveProfileCancel
		local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
		ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
		ifs_saveop.saveProfileNum = iProfileIdx
		ifs_saveop.NoPromptSave = 1
		ifs_movietrans_PushScreen(ifs_saveop)
	elseif(fRet < 2.5) then
--		print("ifs_main_SaveDirtyAccept(B - Exit without saving)")
		ifs_main_DoQuit()
	else
--		print("ifs_main_SaveDirtyAccept(C - Cancel)")
		-- show this screen
		IFObj_fnSetVis(ifs_main.buttons,1)
	end	
end

function ifs_main_TryToQuit( this )
	-- is the current profile dirty?
	if(ScriptCB_IsCurProfileDirty(1)) then
--		print("profile dirty, prompting save")
		
		-- hide this screen
		IFObj_fnSetVis(ifs_main.buttons,nil)
		
		-- set the button text
		IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".saveandexit")
		IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".exitnosave")
		IFText_fnSetString(Popup_LoadSave2.buttons.C.label,ifs_saveop.PlatformBaseStr .. ".cancel")
		-- set the button visiblity
		Popup_LoadSave2:fnActivate(1)
		-- set the load/save title text
		IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,1)
		gPopup_fnSetTitleStr(Popup_LoadSave2, ifs_saveop.PlatformBaseStr .. ".save24")
		Popup_LoadSave2_SelectButton(1)
		IFObj_fnSetVis(Popup_LoadSave2, not ScriptCB_IsErrorBoxOpen())
		Popup_LoadSave2_ResizeButtons()
		Popup_LoadSave2.fnAccept = ifs_main_SaveDirtyAcceptQuit
		return
	end

	ifs_main_DoQuit( )
end

----------------------------------------------------------------------------------------
-- try to exit backwards.  if the current profile is dirty, warn and prompt a save
----------------------------------------------------------------------------------------
function ifs_main_TryToBackup()
--	print("ifs_main_TryToBackup")
	
	-- is the current profile dirty?
	if(ScriptCB_IsCurProfileDirty(1)) then
--		print("profile dirty, prompting save")
		
		-- hide this screen
		IFObj_fnSetVis(ifs_main.buttons,nil)
		
		
		-- set the button text
		IFText_fnSetString(Popup_LoadSave2.buttons.A.label,ifs_saveop.PlatformBaseStr .. ".saveandexit")
		IFText_fnSetString(Popup_LoadSave2.buttons.B.label,ifs_saveop.PlatformBaseStr .. ".exitnosave")
		IFText_fnSetString(Popup_LoadSave2.buttons.C.label,ifs_saveop.PlatformBaseStr .. ".cancel")
		-- set the button visiblity
		Popup_LoadSave2:fnActivate(1)
		-- set the load/save title text
		IFObj_fnSetVis(Popup_LoadSave2.buttons.A.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.B.label,1)
		IFObj_fnSetVis(Popup_LoadSave2.buttons.C.label,1)
		gPopup_fnSetTitleStr(Popup_LoadSave2, ifs_saveop.PlatformBaseStr .. ".save24")
		Popup_LoadSave2_SelectButton(1)
		IFObj_fnSetVis(Popup_LoadSave2, not ScriptCB_IsErrorBoxOpen())
		Popup_LoadSave2_ResizeButtons()
		Popup_LoadSave2.fnAccept = ifs_main_SaveDirtyAccept
		return
	end
	
	-- not dirty, backup
--	print("profile not dirty, backing up")
	ScriptCB_Logout()
	ifs_login.EnterDoNothing = nil
	ScriptCB_PopScreen()
	
end

function ifs_main_SaveDirtyAccept(fRet)
	Popup_LoadSave2.fnAccept = nil
	Popup_LoadSave2:fnActivate(nil)

	-- show this screen
	IFObj_fnSetVis(ifs_main.buttons,1)

	if(fRet < 1.5) then
--		print("ifs_main_SaveDirtyAccept(A - Save)")
		ifs_main_SaveAndBackup()
	elseif(fRet < 2.5) then
--		print("ifs_main_SaveDirtyAccept(B - Exit without saving)")
		ScriptCB_Logout()
		ifs_login.EnterDoNothing = nil		
		ScriptCB_PopScreen()
	else
--		print("ifs_main_SaveDirtyAccept(C - Cancel)")
		-- do nothing, just stay in ifs_main
	end	
end

function ifs_main_SaveAndBackup()
--	print("ifs_main_SaveAndBackup")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_main_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_main_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_saveop.NoPromptSave = 1
	ifs_movietrans_PushScreen(ifs_saveop)	
	
end

function ifs_main_SaveProfileSuccess()
--	print("ifs_main_SaveProfileSuccess")
	
	ScriptCB_Logout()
	ifs_login.EnterDoNothing = nil

	-- pop to login
	ScriptCB_PopScreen("ifs_login")
end

function ifs_main_SaveProfileCancel()
--	print("ifs_main_SaveProfileCancel")
	
	-- back to the "its dirty, save?" prompt when we enter
	ifs_main.TryToBackup = 1
	-- pop ifs_saveop, return to ifs_main
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


--function ifs_main_OnLoginDone()
--	print("ifs_main_OnLoginDone")
--	local this = ifs_main
--	
--	-- where did we want to go?
--	ifs_movietrans_PushScreen(this.gotoAfterLogin)
--end

function ifs_main_GotoLoginScreen(this, afterScreen)
--	-- this is where we go when we're done with the login screen
--	this.gotoAfterLogin = afterScreen
--	-- this is what gets called by the login screen to say its done
--	ifs_login.fnDone = ifs_main_OnLoginDone
--	-- go there
--	ifs_movietrans_PushScreen(ifs_login)
	
	ifs_movietrans_PushScreen(afterScreen)
end

-- Sets the login window to full visibility, immediately
function ifs_XLive_fnFullVisSilentLogin(this)
	IFObj_fnSetVis(this.LoginInfoWindow, 1)
	IFObj_fnSetAlpha(this.LoginInfoWindow, 1)
	IFObj_fnSetAlpha(this.LoginInfoWindow.ShowText, 1)

	-- Clear anims, in case we pop back in the middle of a fadeout
	AnimationMgr_ClearAnimations(this.LoginInfoWindow)
	AnimationMgr_ClearAnimations(this.LoginInfoWindow.ShowText)
end

-- Helper function, called from several pages. Updates the silent login box
function ifs_XLive_fnUpdateSilentLoginBox(this)
	this.fSilentLoginTimer = 0.5 -- reset timer

	local ShowUStr,bSmallFont = ScriptCB_XL_GetSilentLoginState()
	if((gLangStr == "english") or (gLangStr == "uk_english")) then
		IFText_fnSetFont(this.LoginInfoWindow.ShowText,"gamefont_small")
	else
		IFText_fnSetFont(this.LoginInfoWindow.ShowText,"gamefont_tiny")
	end
	IFText_fnSetUString(this.LoginInfoWindow.ShowText,ShowUStr)

	if((gDemoBuild) and (not gDemoHasMP)) then
		IFObj_fnSetVis(this.LoginInfoWindow, nil)
	else

		if((this.LastXLiveSilentUStr ~= ShowUStr) or (not this.iLastXLiveSilentTimer)) then
			this.LastXLiveSilentUStr = ShowUStr
			this.iLastXLiveSilentTimer = 6 / this.fSilentLoginTimer -- # of seconds
			ifs_XLive_fnFullVisSilentLogin(this)
		else
			this.iLastXLiveSilentTimer = this.iLastXLiveSilentTimer - 1
			if (this.iLastXLiveSilentTimer > 0) then
				ifs_XLive_fnFullVisSilentLogin(this)
			elseif (this.iLastXLiveSilentTimer == 0) then
				local fFadeTime = 2.5
				AnimationMgr_AddAnimation(this.LoginInfoWindow.ShowText,
																	{ fTotalTime = fFadeTime, fStartAlpha = 1, fEndAlpha = 0,})
			elseif (this.iLastXLiveSilentTimer == -10) then
				IFObj_fnSetVis(this.LoginInfoWindow, nil)
			end
		end
	end
end


ifs_main = NewIFShellScreen {
	bNohelptext_backPC = 1,
	bAcceptIsSelect = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.6, -- center
		y = 10, -- move down slightly
	},

	logo_temp = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		y = -38, -- Texture has about 44 pixels of dead space at the top
--		texture = "check", -- set below
		localpos_l = -256, localpos_t = 0,
		localpos_r = 256, localpos_b = 256,
		texture = "logo",
	},
		
	movieIntro      = nil, -- WAS "ifs_main_intro",
	movieBackground = "shell_main", -- WAS "ifs_main",
	music           = "shell_soundtrack",

	Enter = function(this, bFwd)
--		print("ifs_main.Enter(",bFwd,")")
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		-- if we should attempt to back up, do it
		if(this.TryToBackup) then
			this.TryToBackup = nil
			ifs_main_TryToBackup()
			return
		end
		
		-- if we ever enter going backwards, clear these vars
		if(not bFwd) then
			ScriptCB_SetSplitscreen( nil )
			ScriptCB_SetInNetGame( nil )
		end
		
		--if we're booting from NTGUI, skip forward
		if(ScriptCB_SkipToNTGUI()) then
			this.CurButton = "mp"
--			ifs_main_GotoLoginScreen(this, ifs_mpps2_netconfig)
			ifs_main_GotoLoginScreen(this, ifs_mp)
		end

		if(not bFwd) then
			ScriptCB_UnbindController(-2) -- all but primary
		end

		-- nil if last game was singlescreen, else # cameras
		local LastWasSplitscreen = ScriptCB_WasSplitscreen()

		if(bFwd and ScriptCB_IsSpecialJoinPending()) then
			this.CurButton = "mp"
			ifs_main_GotoLoginScreen(this, ifs_mp)
		elseif (bFwd and ScriptCB_IsCmdlineJoinPending()) then
			this.CurButton = "mp"
			ifs_main_GotoLoginScreen(this, ifs_mp)
		elseif (bFwd and ScriptCB_InMultiplayer()) then
			this.CurButton = "mp"
			--ScriptCB_SndBusFade("music", 0.5, 0.0) -- fade out music
			-- Note: ps2 could go to ifs_mpps2_netconfig here, but I'd
			-- rather assume they want to use the previous netconfig. If they
			-- back all the way out to here, they can select another manually.
			-- Hopefully that'll let us get thru Sony
			if( gPlatformStr == "PC" ) then
				if(ScriptCB_GetWasHost()) then
					ifs_main_GotoLoginScreen(this, ifs_missionselect_pcMulti)
				else
					ifs_main_GotoLoginScreen(this, ifs_mp_sessionlist)
				end
			else			
				if(LastWasSplitscreen) then
					ScriptCB_SetSplitscreen(LastWasSplitscreen)
				end
				ifs_main_GotoLoginScreen(this, ifs_mp)
			end
			
		elseif(bFwd and ScriptCB_IsMetagameStateSaved()) then
			if(LastWasSplitscreen) then
				ScriptCB_SetSplitscreen(LastWasSplitscreen)
			end
			ifs_main_GotoLoginScreen(this, ifs_freeform_main)

		elseif (bFwd and ScriptCB_IsCampaignStateSaved()) then
			if(LastWasSplitscreen) then
				ScriptCB_SetSplitscreen(LastWasSplitscreen)
			end
			ifs_main_GotoLoginScreen(this, ifs_campaign_main)

		elseif (bFwd and ScriptCB_GetInTrainingMission()) then
			if( gPlatformStr ~= "PC" ) then
				ifs_main_GotoLoginScreen(this, ifs_sp)
			else
				--ScriptCB_SetGameRules("campaign")
				--ifs_sp_briefing.era = "c1"
				ifs_movietrans_PushScreen(ifs_sp_campaign)
			end			
		else
			-- Staying here... make sure other controllers are unbound, 
			-- [Fix for 7005 - NM 7/24/004]
			ScriptCB_UnbindController(-2)
		end

		this.buttons.quit.hidden = (gPlatformStr ~= "PC")
		this.buttons.back2.hidden = (gPlatformStr ~= "PC")
		this.buttons.split.hidden = (gPlatformStr == "PC") or (gDemoBuild and (not gDemoHasSplitscreen))
		this.buttons.tutorials.hidden = 1-- (gPlatformStr == "PC")

		if(gDemoBuild) then
			this.buttons.mp.hidden = 1
			this.buttons.mp.hidden = not gDemoHasMP
			this.buttons.fonttest.hidden = 1
			if((gXBox_DVDDemo) or (gPlatformStr == "PC")) then
				this.buttons.quitdemo.hidden = 1
			end
		else
			this.buttons.quitdemo.hidden = 1
		end

		ShowHideVerticalButtons(this.buttons,ifsmain_vbutton_layout)
		SetCurButton(this.CurButton)

		if(gPlatformStr == "XBox") then
			ifs_XLive_fnUpdateSilentLoginBox(this)
		end

		IFObj_fnSetVis(this.LoginInfoWindow, (gPlatformStr == "XBox"))
		if((gDemoBuild) and (not gDemoHasMP)) then
			IFObj_fnSetVis(this.LoginInfoWindow, nil)
		end
	end,

	Exit = function(this, bFwd)
		if (not bFwd) then
			ifelm_shellscreen_fnPlaySound(this.exitSound)
		end
	end,

	iNumControllers = 8, -- default value for all platforms, XBox will change this
	fSplitColor = 255,
	fControllerCheckTime = 0,
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		if(gPlatformStr ~= "PC") then
			this.fControllerCheckTime = this.fControllerCheckTime - fDt
			if((this.fControllerCheckTime < 0) and (not ScriptCB_IsPopupOpen())) then
				this.fControllerCheckTime = 0.1

				local iNumControllers = ScriptCB_GetNumControllers()
				if(this.iNumControllers ~= iNumControllers) then
					this.iNumControllers = iNumControllers
					local EntryButton = this.CurButton

					this.buttons.split.bDimmed = (this.iNumControllers < 2)
					if((this.iNumControllers < 2) and (EntryButton == "split")) then
						this:Input_GeneralUp() -- move off now-disabled option
					end
					ShowHideVerticalButtons(this.buttons,ifsmain_vbutton_layout)
					SetCurButton(this.CurButton)
				end -- # of controllers changed.
			end -- Timer elapsed
		end -- not-PC code for splitscreen on/off

		if(gPlatformStr == "XBox") then
			this.fSilentLoginTimer = this.fSilentLoginTimer - fDt
			if(this.fSilentLoginTimer < 0) then
				ifs_XLive_fnUpdateSilentLoginBox(this)
			end
		end

	end,

	Input_Back = function(this)
		-- if going backwards (to the login screen), log out
		ifs_main_TryToBackup()
	end,

	fnJumpToMPMain = function(this)
--		print("Jump to MP Main!")
		this.CurButton = "mp"
		this.bJumpToMPMain = 1
		ifs_main_GotoLoginScreen(this, ifs_mp)
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

		if(this.CurButton) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
		end
        
		if(this.CurButton == "sp") then

			-- Always reset NetLoginName to what was in profile, as we might
			-- have changed it to the selected user's gamertag as part of a
			-- login [FIX for 5310 NM 8/30/05]
			if(gPlatformStr == "XBox") then
				ScriptCB_SetConnectType("lan")
			end

			ifs_sp.bForSplitScreen = nil
			ScriptCB_SetSplitscreen( nil )

			-- clear any multiplayer setting
			if(gPlatformStr == "PC") then
				ScriptCB_CancelLogin()			
				ScriptCB_CloseNetShell(1)
			end
			
			ScriptCB_SetInNetGame( nil )
			
			if( gPlatformStr ~= "PC" ) then
				ifs_main_GotoLoginScreen(this, ifs_sp)
			else
				--ScriptCB_SetGameRules("campaign")
				--ifs_sp_briefing.era = "c1"
				ifs_movietrans_PushScreen(ifs_sp_campaign)				
			end
						
		elseif (this.CurButton == "mp") then
			-- flag for online option tab
			this.option_mp = 1
			
			local bPresent = ScriptCB_IsNetHWPresent()
			if(not bPresent) then
				Popup_Ok_Large.fnDone = ifs_main_fnPostNoNetHW
				Popup_Ok_Large:fnActivate(1)
				gPopup_fnSetTitleStr(Popup_Ok_Large, "ifs.mp.no_net_adaptor")
				IFObj_fnSetVis(this.buttons, nil) -- hide current screen
			else
				ifs_sp.bForSplitScreen = nil
				ScriptCB_SetSplitscreen( nil )
				--ScriptCB_SndBusFade("music", 0.5, 0.0) -- fade out music
				
				if(gPlatformStr == "PS2") then
					ifs_main_GotoLoginScreen(this, ifs_mp)
				elseif(gPlatformStr == "PC") then
					if( ScriptCB_IsLoggedIn() ) then
						ifs_main_GotoLoginScreen(this, ifs_mp_sessionlist)
					else
						ifs_mpgs_login.enable_autologin = 1
						ifs_main_GotoLoginScreen(this, ifs_mpgs_login)
					end
				else
					ifs_main_GotoLoginScreen(this, ifs_mp)
				end
			end -- Has network adaptor
		elseif (this.CurButton == "split") then
			-- Always reset NetLoginName to what was in profile, as we might
			-- have changed it to the selected user's gamertag as part of a
			-- login [FIX for 5310 NM 8/30/05]
			if(gPlatformStr == "XBox") then
				ScriptCB_SetConnectType("lan")
				ScriptCB_SetInNetGame( nil )
			end

			ifs_sp.bForSplitScreen = 1
			ScriptCB_SetSplitscreen( 1 )
			ifs_movietrans_PushScreen(ifs_split_profile)
		elseif (this.CurButton == "tutorials") then
			ifs_movietrans_PushScreen(ifs_tutorials)
		elseif (this.CurButton == "opts") then
			-- flag for online option tab
			this.option_mp = nil

			if(gPlatformStr == "PC") then
				ifs_main_GotoLoginScreen(this, ifs_opt_general)
			else
				ifs_main_GotoLoginScreen(this, ifs_opt_top)
			end
		elseif (this.CurButton == "quit") then
			ifs_main_TryToQuit( this )
		elseif (this.CurButton == "quitdemo") then
			Popup_YesNo_Large.CurButton = "no" -- default
			Popup_YesNo_Large.fnDone = ifs_main_fnQuitDemoPopupDone
			IFObj_fnSetVis(this.buttons,nil)
			IFObj_fnSetVis(this.logo_temp,nil)
			Popup_YesNo_Large:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo_Large, "ifs.main.askquitdemo")
		elseif (this.CurButton == "fonttest") then
			ifs_main_GotoLoginScreen(this, ifs_fonttest)
		elseif (this.CurButton == "back2") then
			-- Why we need another button to go back (for "profile
			-- management") is beyond me. But, it was insisted on.
			ifs_main_TryToBackup()
		end
	end,

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
--									print("Do Nothing")
		if(ScriptCB_IsPopupOpen()) then
			IFObj_fnSetVis(Popup_LoadSave2,1)
		end
--		print("ifs_mp_main fnPostError(..,",bUserHitYes,ErrorLevel)
--		if(ErrorLevel >= 6) then
--			ScriptCB_PopScreen()
--		end
	end,

}

function ifs_main_fnBuildScreen(this)
	if(gPlatformStr == "PC") then
		ifsmain_vbutton_layout.xWidth = 250 -- Set to 250 NM 8/13/04 to fit the "profile management" spam
		ifsmain_vbutton_layout.width = 250 -- Set to 250 NM 8/13/04 to fit the "profile management" spam
	end

	this.CurButton = AddVerticalButtons(this.buttons,ifsmain_vbutton_layout)

	-- Even with the larger window, german needs more space. Too bad it
	-- has to come at the expense of readability. - NM 7/5/04
-- 	if(gLangStr == "german") then
-- 		local k,v
-- 		for k,v in ifsmain_vbutton_layout.buttonlist do
-- 			local Tag = v.tag
-- 			this.buttons[Tag].label.font = "gamefont_small"
-- 		end
-- 	elseif (gLangStr == "italian") then
-- 		this.buttons._titlebar_.font = "gamefont_small"
-- 	end

	local InfoWindowW = 280
	local InfoWindowH = 60

	this.LoginInfoWindow = NewIFContainer {
		ScreenRelativeY = 1.0, -- bot
		ScreenRelativeX = 0.5, -- center
		x = 0,
		y = (InfoWindowH * -0.5),
		width = InfoWindowW,
		height = InfoWindowH,
		ZPos = 200,
	}

	this.LoginInfoWindow.ShowText = NewIFText {
		font = "gamefont_medium",
		textw = InfoWindowW - 20,
		texth = InfoWindowH - 20,
		nocreatebackground = 1,		
		startdelay = math.random() * 0.5,
		valign = "vcenter",
	}

	if((gDemoBuild) and (not gDemoHasMP)) then
		IFObj_fnSetVis(this.LoginInfoWindow, nil)
	end
end

ifs_main_fnBuildScreen(ifs_main)
ifs_main_fnBuildScreen = nil
AddIFScreen(ifs_main,"ifs_main")
