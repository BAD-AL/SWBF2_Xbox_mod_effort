--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Online options

----------------------------------------------------------------------------------------
-- save the profile in slot 1
----------------------------------------------------------------------------------------

function ifs_opt_mp_StartSaveProfile()
	print("ifs_opt_mp_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_opt_mp_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_opt_mp_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_mp_SaveProfileSuccess()
	--  print("ifs_opt_mp_SaveProfileSuccess")
	local this = ifs_opt_mp
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		this:Input_Back(1)
	end
	this.NextScreen = nil
end

function ifs_opt_mp_SaveProfileCancel()
	--  print("ifs_opt_mp_SaveProfileCancel")
	local this = ifs_opt_mp
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()

	-- Replace current screen with next screen from tabs
	if(this.NextScreen ~= -1) then
		ScriptCB_SetIFScreen(this.NextScreen)
	else
		this:Input_Back(1)
	end
	this.NextScreen = nil
end


---------------------------

-- Helper functions for determining if the Gamespy login can be set to
-- 'always' (i.e. the info looks valid)

-- Returns 1 if the specifed string starts with valid chars, nil if
-- not.
function ifs_opt_mp_fnCheckGamespyString(Str)
	local FirstChar = string.sub(Str,1,1)
	if((FirstChar == "@") or (FirstChar == "+") or (FirstChar == ":") or (FirstChar == "#")) then
		return nil
	end

	return 1
end

-- Returns true if the login info looks ok (to allow the 'always'
-- login type)
function ifs_opt_mp_fnLoginInfoLooksOk(NickStr,EmailStr,PasswordStr)
	return ScriptCB_IsLegalGamespyString(NickStr,EmailStr,PasswordStr)
end

function ifs_mp_opt_fnBadHostPopupDone(bResult)
	local this = ifs_opt_mp
	
	IFObj_fnSetVis(this.buttons, 1)
	IFObj_fnSetVis(this.buttonlabels, 1)

	if(bResult) then
		ifs_opt_mp_SaveAndPop()
	end
end

local image_background = nil
if( ScriptCB_IsInShell() ) then
	--print("set background iface_bg_1")
	image_background = "iface_bg_1"
end

function ifs_opt_mp_fnUpdateForm( form )
	local this = ifs_opt_mp
	this.OnlinePrefs = ScriptCB_GetOnlineOpts()

	if ( this.OnlinePrefs.bAppearOffline == true ) then
		form.elements["appear"].selValue = 1
	else
		form.elements["appear"].selValue = 2
	end
	
	form.elements["voicemask"].selValue = ifs_opt_general_fnBoolToSelValue(this.OnlinePrefs.bVoiceMask)
	form.elements["allregions"].selValue = ifs_opt_general_fnBoolToSelValue(this.OnlinePrefs.bAllRegions)
	form.elements["voiceenable"].selValue = ifs_opt_general_fnBoolToSelValue(ScriptCB_GetVoiceEnable())
	form.elements["voicevol"].selValue = ifs_opt_general_fnBoolToSelValue(this.OnlinePrefs.iTVVoiceVol)
	form.elements["voicerecord"].selValue = this.OnlinePrefs.iVoiceRecordVol
	form.elements["voiceplayback"].selValue = this.OnlinePrefs.iVoicePlayVol
	form.elements["players"].selValue = this.OnlinePrefs.iPlayersSupported + 1

	if ( this.OnlinePrefs.iTurnsPerSecond == 30 ) then
		form.elements["turns"].selValue = 3
	elseif ( this.OnlinePrefs.iTurnsPerSecond == 15 ) then
		form.elements["turns"].selValue = 1
	else
		form.elements["turns"].selValue = 2
	end
	
	form.elements["icon"].selValue = this.OnlinePrefs.iOnlineIcon + 1

	this.NickStr,this.EmailStr,this.PasswordStr,this.iSaveType,this.iPromptType = ScriptCB_GetGSProfileInfo()
	if ( this.iPromptType == 0 ) then
		form.elements["prompt"].selValue = 1
	elseif ( this.iPromptType == 1 ) then
		form.elements["prompt"].selValue = 2
	else
		form.elements["prompt"].selValue = 0
	end
	
	Form_SetValues(form)

	if (gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

ifs_opt_mp = NewIFShellScreen {

	nologo = 1,
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed
	bNohelptext_backPC = 1,
	bg_texture = image_background,
	
	--bg_texture = "iface_bgmeta_space",

	-- display network performance icon 
	icon = 0,
	bAllRegions = true,
	iNumPlayers = 0,
	iTurnsPerSecond = 20,
	pollProfileTime = 2,
	
	--    title = NewIFText {
	--        string = "ifs.onlineopt.title",
	--        font = "gamefont_large",
	--        textw = 460,
	--        y = 0,
	--        ScreenRelativeX = 0.5,
	--        ScreenRelativeY = 0.0,
	--        inert = 1,
	--        nocreatebackground = 1,
	--    },

	-- Do any adjustments necessary on entering this screen
	Enter = function(this, bFwd)
		-- use shell mode?
		this.bShellMode = 
			ScriptCB_GetShellActive() and 
			ScriptCB_GetGameRules() ~= "metagame" and 
			ScriptCB_GetGameRules() ~= "campaign"
			
		-- if in the shell...
		if(this.bShellMode) then
			-- hide done and cancel buttons
			IFObj_fnSetVis(this.donebutton, 1)
			IFObj_fnSetVis(this.cancelbutton, false)
			
			-- if inside the multiplayer menu...
			ifelem_tabmanager_SelectTabGroup(this, 1, not ifs_main.option_mp, ifs_main.option_mp )
			if( ifs_main.option_mp ) then
				-- show multiplayer and multiplayer options tabs
				ifelem_tabmanager_SelectTabGroup(this, 1, nil, 1)
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_multi")
				ifelem_tabmanager_SetSelected(this, gPCMultiPlayerTabsLayout, "_tab_mp_opt", 2 )
				-- dim options that require login if not logged in
				local loggedin = ScriptCB_IsLoggedIn()
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", not loggedin, 2 )
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", not loggedin, 2 )
			else
				-- show options and multiplayer tabs
				ifelem_tabmanager_SelectTabGroup(this, 1, 1, nil)
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_mp", 1)
			end
			
			-- set pc profile & title version text
			UpdatePCTitleText(this)
		else
			-- show done and cancel buttons
			IFObj_fnSetVis(this.donebutton, true)
			IFObj_fnSetVis(this.cancelbutton, true)
			
			-- show multiplayer tabs
			ifelem_tabmanager_SelectTabGroup(this, nil, 1, nil)
			ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_mp", 1)
			
			-- hide PC profile & title version text
			HidePCTitleText(this)
		end
		
		-- dim tabs for PC Demo
		ifs_DimTabsPCDemo(this)            
		
		ScriptCB_MarkCurrentProfile()
		if(gPlatformStr == "PC") then
			this.bReloadProfile = 1
		end
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		--      print("Enter Top, this.CurButton = ",this.CurButton)

		if(this.PopOnEnter) then
			this.PopOnEnter = nil
			print ("Pop On Enter")
			if (gPlatformStr == "PC") and this.bShellMode then
				-- rethink interface state, but don't leave
				this:Exit(false)
				this:Enter(true)
			else
				ScriptCB_PopScreen()
			end
		end

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				print ("Error")
				ScriptCB_PopScreen()
			end
		end

		-- enable local voice echo for test / auditioning
		ScriptCB_SetVoiceLocalEchoEnable(1)

		-- Disable presence button if not on XLive
		local bIsXLive = (ScriptCB_GetConnectType() == "XLive") -- current setting; r2 
		local bIsXbox = (gPlatformStr == "XBox")  -- r3 
		local bIsPC = (gPlatformStr == "PC")     -- r4 

		local bCouldBeXLive = (ScriptCB_GetOnlineService() == "XLive") -- binary was compiled for XLive; r5

		local bCouldBeGalaxy = (ScriptCB_GetOnlineService() == "Galaxy") -- r6 
		
		local form = this.formcontainer.form
		form.elements["appear"].hidden = ( not bCouldBeXLive)  and (not bCouldBeGalaxy)   -- i think thses 2 lines are correct, but they don't match exactly the lua listing 
		form.elements["voicemask"].hidden = ( not bCouldBeXLive)  and (not bCouldBeGalaxy)
		
		form.elements["prompt"].hidden = true
		form.elements["turns"].hidden = bIsPC
		form.elements["allregions"].hidden = not bIsPC
		form.elements["voicevol"].hidden = not bIsXBox
		form.elements["voiceplayback"].hidden = bIsPC or bIsXbox
		form.elements["voicerecord"].hidden = bIsPC or bIsXbox
		form.elements["voiceenable"].hidden = bIsPC

		ifs_opt_mp_fnUpdateForm(form)
		Form_SetValues(form)
		Form_ShowHideElements(form)
		SetCurButton(this.CurButton)

		this.OnlinePrefs = ScriptCB_GetOnlineOpts()
	end,
    
	Exit = function(this, bFwd)
		-- disable local voice echo 
		ScriptCB_SetVoiceLocalEchoEnable(0)
		print("ifs_opt_mp - Exit. Reload = ", this.bReloadProfile)
		if( this.bReloadProfile ) then
			ScriptCB_ReloadMarkedProfile()
		end
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end
	end,
	
	OnRadioChanged = function(buttongroup, btnNum)
		local this = ifs_opt_mp
		local form = this.formcontainer.form
		this.OnlinePrefs = ScriptCB_GetOnlineOpts()

		if (buttongroup.tag == "appear") then
			this.OnlinePrefs.bAppearOffline = btnNum == 2
		elseif (buttongroup.tag == "voicemask") then
			this.OnlinePrefs.bVoiceMask = btnNum == 2
		elseif (buttongroup.tag == "allregions") then
			this.OnlinePrefs.bAllRegions = btnNum == 2
		elseif (buttongroup.tag == "voicevol") then
			this.OnlinePrefs.iTVVoiceVol = math.min(10, this.OnlinePrefs.iTVVoiceVol + 1)
			if (this.OnlinePrefs.iTVVoiceVol > 0) then
				ScriptCB_VoiceEnable(true)
			else
				ScriptCB_VoiceEnable(false)
			end
			ScriptCB_SetOnlineOpts(this.OnlinePrefs) -- apply now
		elseif (buttongroup.tag == "voicerecord") then
			this.OnlinePrefs.iVoicePlayVol = btnNum
		elseif (buttongroup.tag == "players") then
			this.OnlinePrefs.iPlayersSupported = btnNum - 1
		elseif (buttongroup.tag == "turns") then
			if ( btnNum == 1 ) then
				this.OnlinePrefs.iTurnsPerSecond = 15
			elseif ( btnNum == 2 ) then
				this.OnlinePrefs.iTurnsPerSecond = 20
			else
				this.OnlinePrefs.iTurnsPerSecond = 30
			end
		elseif (buttongroup.tag == "icon") then
			this.OnlinePrefs.iOnlineIcon = btnNum - 1
		elseif (buttongroup.tag == "voiceenable") then
			ScriptCB_VoiceEnable(btn - 1)
		elseif (buttongroup.tag == "prompt") then
            local NickStr,EmailStr,PasswordStr,iSaveType,iPromptType = ScriptCB_GetGSProfileInfo()
            if (btnNum == 1) then iPrompt = 2			-- never
            elseif ( btnNum == 2 ) then iPrompt = 3		-- prompt
            else iPrompt = 1 end						-- always
            ScriptCB_SetGSProfileInfo(NickStr,EmailStr,PasswordStr,iSaveType,iPrompt)
		end
		ScriptCB_SetOnlineOpts(this.OnlinePrefs)
		ifs_opt_mp_fnUpdateForm(this.formcontainer.form)
	end,
	
	OnElementChanged = function(form, element)
		local this = ifs_opt_mp
		this.OnlinePrefs = ScriptCB_GetOnlineOpts()

		if (element.tag == "players") then
			this.OnlinePrefs.iPlayersSupported = element.selValue - 1
			Form_UpdateElement(form, "players")
		end
		
		ScriptCB_SetOnlineOpts(this.OnlinePrefs)
		ifs_opt_mp_fnUpdateForm(this.formcontainer.form)
	end,

	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- Lobby might be active (if we entered thru it). Update it.
		ScriptCB_UpdateLobby(nil)
		
		-- handle TV voice gain changes
		this.pollProfileTime = this.pollProfileTime - fDt

		if (this.pollProfileTime < 0) then
			local voiceTVGain    = ScriptCB_GetVoiceTVGain()
			this.pollProfileTime = 2
			
			
			-- if the TV voice is turned off and headset is disconnected
			if (this.OnlinePrefs.iTVVoiceVol == 0 and 
					voiceTVGain                  == 0 and
						not ScriptCB_GetVoiceCaptureConnected()) then
				ScriptCB_VoiceEnable(nil) -- disable voice

				ifs_opt_mp_fnUpdateForm(this.formcontainer.form)
			end

			-- if the TV gain has changed (due to headset insertion / removal) 
			-- update profile
			if (this.OnlinePrefs.iTVVoiceVol ~= voiceTVGain) then
				this.OnlinePrefs.iTVVoiceVol = voiceTVGain
				ScriptCB_SetOnlineOpts(this.OnlinePrefs)
				ifs_opt_mp_fnUpdateForm(this.formcontainer.form)
			end
		end
		
		Form_Update(this.formcontainer.form, fDt)
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this, 1)) then
			return
		end

		-- If the tab manager handled this event, then we're done
		-- Check tabs to see if we have a hit
		this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout, nil, 1)
		if(not this.NextScreen) then
			if( ifs_main and ifs_main.option_mp and this.bShellMode ) then
				this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCMultiPlayerTabsLayout, 2, 1)
			else
				this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCOptionsTabsLayout, 1, 1)
			end
		end -- main tabs not yet hit
		
		-- If nextscreen was handled via a callback, we're done
		if(this.NextScreen == -1) then
			this.NextScreen = nil
			return
		end

		-- If we have a destination, go there.
		if(this.NextScreen) then
			this.bReloadProfile = nil -- accept changes made here
			if(ScriptCB_IsCurProfileDirty()) then
				ifs_opt_mp_StartSaveProfile()
				return
			else
				-- No need to save. Just jump there
				ScriptCB_SetIFScreen(this.NextScreen)
				this.NextScreen = nil
				return
			end
		end -- this.Nextscreen is valid (i.e. clicked on a tab)
		
		if (this.CurButton == "journal") then
			ScriptCB_EnableJournal()
		end

		if (Form_InputAccept(this.formcontainer.form) == true) then
			return
		end

		if(this.CurButton == "_cancel") then
			ifelm_shellscreen_fnPlaySound(this.cancelSound)
			this.bReloadProfile = true
			this:Input_Back(1)
			return
		end

		if(this.CurButton == "_ok" ) then 
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_SetOnlineOpts(this.OnlinePrefs)

			if(ScriptCB_IsCurProfileDirty()) then
				this.NextScreen = -1 -- flag special behavior
				ifs_opt_mp_StartSaveProfile()
			else
				this:Input_Back(1)
			end
			
			-- don't reload profile when we leave
			this.bReloadProfile = nil
			return
		end
		
		if ( this.CurButton == "_reset" ) then
			ScriptCB_ResetOnlineOptionsToDefault()

			ifs_opt_mp_fnUpdateForm(this.formcontainer.form)
		end
	end,
    
	Input_Back = function(this)
		if (gPlatformStr == "PC") and this.bShellMode then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			ScriptCB_PopScreen()
		end
	end,

	Input_Start = function(this)
		if not this.bShellMode then
 			this.bReloadProfile = 1
			ScriptCB_PopScreen()
		end
	end,
	
	Input_Misc  = function(this)
		this:Input_GeneralLeft()
	end,

	Input_GeneralLeft = function(this)
	end,

    Input_GeneralRight = function(this)     
    end,

}


----------------------------------------------------------------------------------------
-- when we're done with this screen, save any dirty profiles
----------------------------------------------------------------------------------------

function ifs_opt_mp_SaveAndPop()
--  print("ifs_opt_mp_SaveAndPop")
    local this = ifs_opt_mp
    
    -- if we're in the game, or a subscreen of the options tree, don't try to save
    if((not ifs_saveop) or (ScriptCB_IsScreenInStack("ifs_opt_top"))) then
		if (gPlatformStr == "PC") and this.bShellMode then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			print ("Save and Pop")
			ScriptCB_PopScreen()
		end
        return
    end
    
    ifs_saveop.doOp = "SaveProfile"
    ifs_saveop.OnSuccess = ifs_opt_mp_SaveProfile1Success
    ifs_saveop.OnCancel = ifs_opt_mp_SaveProfile1Cancel
    local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
    ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
    ifs_saveop.saveProfileNum = iProfileIdx
    ifs_movietrans_PushScreen(ifs_saveop)   
end

function ifs_opt_mp_SaveProfile1Success()
--  print("ifs_opt_mp_SaveProfile1Success")
    -- exit once we reenter
    ifs_opt_mp.PopOnEnter = 1
    ScriptCB_PopScreen()
end

function ifs_opt_mp_SaveProfile1Cancel()
--  print("ifs_opt_mp_SaveProfile1Cancel")
    -- exit once we reenter
    ifs_opt_mp.PopOnEnter = 1
    ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- done profile save
----------------------------------------------------------------------------------------

ifs_opt_mp_form_layout = {
	yTop = -50,
	yHeight = 45,
	xSpacing = 20,
	ySpacing  = 0,
	bUseYSpacing = 1,
	width = 310,
	bRightJustifyText = 1, -- just the text, not the buttons
	font = "gamefont_small",
	flashy = 0,
	leftColumn = 0.8,
	elements = {
		-- Title is for the left column, string the right-hand option
		{ tag = "appear",    title = "ifs.onlineopt.appear", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.onlineopt.offline", "ifs.onlineopt.online"}},
		{ tag = "voicemask", title = "ifs.onlineopt.voicemask", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"}},
		{ tag = "voicevol",  title = "ifs.onlineopt.voicetotvvolume", fnChanged = ifs_opt_mp.OnElementChanged, selValue = 10, control = "slider", minValue = 0.0, maxValue = 100.0,},
		{ tag = "prompt",  title = "ifs.onlineopt.autologin", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"common.never", "ifs.gsprofile.prompt", "common.always"}},
		{ tag = "players", title = "ifs.onlineopt.hostbandwidth", fnChanged = ifs_opt_mp.OnElementChanged, selValue = 1, control = "dropdown", values = {"128K", "256K", "384K", "512K", "768K", "1M", "1.5M", "3M", "6M"},},
		{ tag = "turns", title = "ifs.onlineopt.tps", fnChanged = ifs_opt_mp.OnElementChanged, selValue = 1, control = "dropdown", values = {"15", "20", "30"},},
		{ tag = "allregions", title = "ifs.onlineopt.allregions", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"}},
		{ tag = "icon", title = "ifs.onlineopt.icon", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"}},   -- display network performance icon 
		{ tag = "voicerecord",   title = "ifs.onlineopt.voicerecordvol", fnChanged = ifs_opt_mp.OnElementChanged, selValue = 10, control = "slider", minValue = 0.0, maxValue = 10.0,},
		{ tag = "voiceplayback", title = "ifs.onlineopt.voiceplaybackvol", fnChanged = ifs_opt_mp.OnElementChanged, selValue = 10, control = "slider", minValue = 0.0, maxValue = 100.0,},
		{ tag = "voiceenable",   title = "ifs.onlineopt.voiceenable", fnChanged = ifs_opt_mp.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"}},

	},
}


function ifs_opt_mp_fnBuildScreen(this)
	local w
	local h
	w,h = ScriptCB_GetSafeScreenInfo()

	-- add pc profile & title version text
	AddPCTitleText( this )

	ifs_opt_mp_form_layout.width = w * 1.5
	for i, element in ipairs(ifs_opt_mp_form_layout.elements) do
		element.width = w * 0.15
	end
	this.formcontainer = NewIFContainer {
		ScreenRelativeX = 0.7,
		ScreenRelativeY = 0.5,
	}
	Form_CreateVertical(this.formcontainer, ifs_opt_mp_form_layout)
	this.formcontainer.form.text.x = 0
	this.formcontainer.form.text.y = -9
	this.formcontainer.form.radiobuttons.x = ifs_opt_mp_form_layout.xSpacing
	this.formcontainer.form.dropdowns.x = w * 0.1 + ifs_opt_mp_form_layout.xSpacing

	this.Background = NewIFImage 
	{
		ZPos = 255, 
		x = w/2,  --centered on the x
		y = h/2, -- inertUVs = 1,
		alpha = 10,
		localpos_l = -w/1.5, localpos_t = -h/1.5,
		localpos_r = w/1.5, localpos_b =  h/1.5,
		texture = "opaque_black",
		ColorR = 20, ColorG = 20, ColorB = 150, -- blue
	}
	
	if(gPlatformStr == "PC") then

		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCOptionsTabsLayout, gPCMultiPlayerTabsLayout)
		

		local BackButtonW = 150 -- made 130 to fix 6198 on PC - NM 8/18/04
		local BackButtonH = 25
		
		this.cancelbutton = NewPCIFButton
		{
			ScreenRelativeX = 0.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = BackButtonW * 0.5,
			btnw = BackButtonW, 
			btnh = BackButtonH,
			font = "gamefont_medium", 
			bg_width = BackButtonW, 
			noTransitionFlash = 1,
			tag = "_cancel",
			string = "common.cancel",
		}
		
		this.resetbutton = NewPCIFButton
		{
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			btnw = BackButtonW * 1.5,
			btnh = BackButtonH,
			font = "gamefont_medium",
			bg_width = BackButtonW,
			noTransitionFlash = 1,
			tag = "_reset",
			string = "common.reset",
		}

		this.donebutton = NewPCIFButton
		{
			ScreenRelativeX = 1.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = -BackButtonW * 0.5,
			btnw = BackButtonW, 
			btnh = BackButtonH,
			font = "gamefont_medium", 
			bg_width = BackButtonW, 
			noTransitionFlash = 1,
			tag = "_ok",
			string = "common.accept",
		}
		
	end
	--this.Helptext_Back.helpstr.string = "common.cancel"   
end

ifs_opt_mp_fnBuildScreen(ifs_opt_mp)
ifs_opt_mp_fnBuildScreen = nil
AddIFScreen(ifs_opt_mp, "ifs_opt_mp")

ifs_opt_mp = DoPostDelete(ifs_opt_mp)
