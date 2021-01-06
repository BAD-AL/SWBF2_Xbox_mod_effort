--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_opt_general_vbutton_layout = {
--	yTop = -150,
	yHeight = 35,
	ySpacing = 0, 
-- 	width = 350, -- calculated below based on screen size
	font = "gamefont_small",
	LeftJustify = 1,
	RightJustifyT = 1,
	flashy = 0,
	buttonlist = {
		-- Title is for the left column, string the option (filled in by code later)
		{ tag = "persp", title = "ifs.gameopt.camera", string = "", },
		{ tag = "rumble", title = "ifs.gameopt.rumble", string = "" },
		{ tag = "friendlyfire", title = "ifs.gameopt.friendlyfire", string = "" },
		{ tag = "autoaim", title = "ifs.gameopt.autoaim", string = "" },
		{ tag = "aimassist", title = "ifs.gameopt.aimassist", string = "" },
		{ tag = "stickyreticule", title = "ifs.gameopt.stickyreticule", string = "" },
--		{ tag = "hero", title = "ifs.gameopt.hero", string = "" },
		{ tag = "diff", title = "ifs.gameopt.difficulty", string = "" },
		{ tag = "ttstate", title = "ifs.gameopt.ttstate", string = "" },
		{ tag = "ttreset", title = "", string = "ifs.gameopt.ttreset" },
	},
	nocreatebackground = 1,
}

----------------------------------------------------------------------------------------
-- save the profile in slot 1
----------------------------------------------------------------------------------------

function ifs_opt_general_StartSaveProfile()
	--print("ifs_opt_general_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_opt_general_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_opt_general_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_general_SaveProfileSuccess()
	--print("ifs_opt_general_SaveProfileSuccess")
	local this = ifs_opt_general
	
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

function ifs_opt_general_SaveProfileCancel()
	local this = ifs_opt_general
	
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

-- Helper function, sets text of all the strings
function ifs_opt_general_fnUpdateStrings(this)
	this.GeneralOpts = ScriptCB_GetGeneralOptions()

	if(this.Helptext_Accept) then
		if(this.CurButton == "ttreset") then
			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.select")
		else
			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.change")
		end
		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end
	
	if(gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

function ifs_opt_general_ShowHideButtons( this )
	ShowHideVerticalText(this.buttonlabels,ifs_opt_general_vbutton_layout)
	ShowHideVerticalButtons(this.buttons,ifs_opt_general_vbutton_layout)
end

local image_background = nil
if( 1 ) then
--if( gPCBetaBuild ) then
	if( ScriptCB_GetShellActive() ) then
		--print("set background iface_bg_1")
		image_background = "iface_bg_1"
	end
end

function ifs_opt_general_fnBoolToSelValue(bValue)
	if ( bValue == true ) then
		return 2
	else
		return 1
	end
end

function ifs_opt_general_fnApplySettings(this)
	local generalForm = this.formcontainergeneral.form
	this.GeneralOpts = ScriptCB_GetGeneralOptions()
	
	this.GeneralOpts = ScriptCB_GetGeneralOptions()

	local ff = 2
	if ( this.GeneralOpts.iFriendlyFire < 1 ) then
		ff = 1
	end
	local tt = 1
	if ( this.GeneralOpts.bToolTips ) then
		tt = 3
	elseif ( this.GeneralOpts.bToolTipAuto ) then
		tt = 2
	end

	generalForm.elements["diff"].selValue = this.GeneralOpts.iDifficulty - 1
	generalForm.elements["persp"].selValue = ifs_opt_general_fnBoolToSelValue(not this.GeneralOpts.bFirstPerson)
	generalForm.elements["rumble"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bRumble)
	generalForm.elements["friendlyfire"].selValue = ff
	generalForm.elements["autoaim"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bAutoAim)
	generalForm.elements["aimassist"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bAimAssist)
	generalForm.elements["stickyreticule"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bStickyReticule)
	generalForm.elements["soldierhints"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bSoldierHints)
	generalForm.elements["reticulealpha"].selValue = 1 - this.GeneralOpts.iReticuleAlpha
	generalForm.elements["subtitles"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bMovieSubtitles)
	--generalForm.elements["hero"].selValue = ifs_opt_general_fnBoolToSelValue(this.GeneralOpts.bHeroes)
	generalForm.elements["ttstate"].selValue = tt
	--generalForm.elements["ttreset"].selValue = 1
end

ifs_opt_general = NewIFShellScreen {
	nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
	bNohelptext_backPC = 1,
	bg_texture = image_background,
	
--	title = NewIFText {
--		string = "ifs.GameOpt.title",
--		font = "gamefont_large",
--		y = 5,
--		textw = 460, -- center on screen. Fixme: do real centering!
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0, -- top
--		inert = 1, -- delete out of Lua mem when pushed to C
--		nocreatebackground = 1,
--	},

	-- When entering this screen, check if we need to save (triggered
	-- by a subscreen or something). If so, start that process.
	Enter = function(this, bFwd)
		ScriptCB_MarkCurrentProfile()
		this.bResetProfile = nil --default to not resetting the profile
		
		if(gPlatformStr == "PC") then
			-- use shell mode?
			this.bShellMode = 
				ScriptCB_GetShellActive() and 
				ScriptCB_GetGameRules() ~= "metagame" and 
				ScriptCB_GetGameRules() ~= "campaign"
			
			-- if in the shell...
			if( this.bShellMode ) then
				-- hide done and cancel buttons
				IFObj_fnSetVis(this.donebutton, 1)
				IFObj_fnSetVis(this.cancelbutton, false)
				
				-- show options and general tabs
				ifs_main.option_mp = nil		-- set to option			
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_general", 1)
				
				-- set pc profile & title version text
				UpdatePCTitleText(this)
			else
				-- show done and cancel buttons
				IFObj_fnSetVis(this.donebutton, true)
				IFObj_fnSetVis(this.cancelbutton, true)
				
				-- show general tabs
                ifelem_tabmanager_SelectTabGroup(this, nil, 1, nil)
                ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_general", 1)
                
                -- hide PC profile & title version text
                HidePCTitleText(this)
			end
			
			-- dim tabs for PC Demo
			ifs_DimTabsPCDemo(this)
		end
		
		local generalForm = this.formcontainergeneral.form
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function      
		Form_Enter(generalForm, bFwd)

		--this:ApplySettings()
		ifs_opt_general_fnApplySettings(this)

		generalForm.elements["persp"].hidden = true
		generalForm.elements["rumble"].hidden = (gPlatformStr == "PC")
		generalForm.elements["friendlyfire"].hidden = not ScriptCB_GetShellActive() or gDemoBuild
		generalForm.elements["aimassist"].hidden = (gPlatformStr == "PC")
		generalForm.elements["autoaim"].hidden = ScriptCB_IsNetworkOn() or (gPlatformStr == "PC")
		generalForm.elements["stickyreticule"].hidden = (gPlatformStr == "PC")
		--generalForm.elements["ttreset"].hidden = (gPlatformStr == "PC")
		
		SetCurButton(this.CurButton)
		Form_ShowHideElements(generalForm)

		--AnimationMgr_AddAnimation(this.buttonlabels, {fStartAlpha = 0, fEndAlpha = 1,})
		ifs_opt_general_fnUpdateStrings(this)
		
		Form_SetValues(generalForm)
		
		-- For foreign languages, 'reset tooltips' may need a switch to a
		-- smaller font
		--RoundIFButtonLabel_fnSetString(this.buttons.ttreset,"ifs.gameopt.ttreset")

----		this.buttons.rumble.hidden = (gPlatformStr == "PC")
----		this.buttonlabels.rumble.hidden = (gPlatformStr == "PC")
----		this.buttons.friendlyfire.hidden = not ScriptCB_GetShellActive() or gDemoBuild	
----		this.buttonlabels.friendlyfire.hidden = not ScriptCB_GetShellActive() or gDemoBuild
		--this.buttonlabels.autoaim.hidden = ScriptCB_IsNetworkOn() --or (gPlatformStr == "PC")
----		this.buttons.autoaim.hidden = ScriptCB_IsNetworkOn() --or (gPlatformStr == "PC")

		-- removed from PC because the higher-ups said so.
----		this.buttons.aimassist.hidden = (gPlatformStr == "PC")
----		this.buttonlabels.aimassist.hidden = (gPlatformStr == "PC")
----		this.buttons.stickyreticule.hidden = (gPlatformStr == "PC")
----		this.buttonlabels.stickyreticule.hidden = (gPlatformStr == "PC")
		
		-- if we're in the game, hide the "hero" option, since we can't change that mid game
-- 		this.buttons.hero.hidden = not ScriptCB_GetShellActive() or gDemoBuild
-- 		this.buttonlabels.hero.hidden = not ScriptCB_GetShellActive() or gDemoBuild

----		this.buttons.ttreset.hidden = (gPlatformStr == "PC")
----		this.buttonlabels.ttreset.hidden = (gPlatformStr == "PC")
--		this.buttons.ttstate.hidden = (gPlatformStr == "PC")
--		this.buttonlabels.ttstate.hidden = (gPlatformStr == "PC")

----		this.buttonlabels.rumble.hidden = (gPlatformStr == "PC")
		--this.buttons.autoaim.hidden = (gPlatformStr == "PC")
	end, -- function Enter()
	
	Exit = function(this)
		if( this.bResetProfile ) then
			ScriptCB_ReloadMarkedProfile()
		end
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end
	end,

	Input_Accept = function(this) 
		-- If base class handled this work, then we're done
		--if(gShellScreen_fnDefaultInputAccept(this)) then
		--	return
		--end

		-- If the tab manager handled this event, then we're done
		if(gPlatformStr == "PC") then
			-- Check tabs to see if we have a hit
			this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCOptionsTabsLayout, 1, 1)
			if(not this.NextScreen) then
				this.NextScreen = ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout, nil, 1)
			end
			
			-- If nextscreen was handled via a callback, we're done
			if(this.NextScreen == -1) then
				this.NextScreen = nil
				return
			end
			
			if(this.NextScreen) then
				if(ScriptCB_IsCurProfileDirty()) then
					ifs_opt_general_StartSaveProfile()
					return
				else
					-- No need to save. Just jump there
					ScriptCB_SetIFScreen(this.NextScreen)
					this.NextScreen = nil
					return
				end
			end -- this.Nextscreen is valid (i.e. clicked on a tab)
		end -- cur platform == PC
		
		if (Form_InputAccept(this.formcontainergeneral.form) == true) then
			return
		end

		if (this.CurButton == "_back") then
 			this.bResetProfile = 1
 			this:Input_Back(1)
 		elseif (this.CurButton == "_ok") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.bResetProfile = nil
			if(ScriptCB_IsCurProfileDirty()) then
				this.NextScreen = -1 -- flag special behavior
				ifs_opt_general_StartSaveProfile()
			else
				this:Input_Back(1)
			end
		elseif (this.CurButton == "reset") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			ScriptCB_ResetGameOptionsToDefault()
			ifs_opt_general_fnUpdateStrings(this)
			--this:ApplySettings()
			ifs_opt_general_fnApplySettings(this)
			Form_SetValues(this.formcontainergeneral.form)
		else
			-- Act like 'right' was hit. This reduces duplicated code.
			--this:Input_GeneralRight()
 		end
	end,

	ApplySettings = function(this)
	end,
	
	UpdateGeneralOptionBools = function(this)
		local opts = this.GeneralOpts
		local generalForm = this.formcontainergeneral.form
		opts.bFirstPerson = ( generalForm.elements["persp"].selValue == 1 )
		opts.bRumble = generalForm.elements["rumble"].selValue == 2
		opts.bAutoAim = generalForm.elements["autoaim"].selValue == 2
		opts.bAimAssist = generalForm.elements["aimassist"].selValue == 2
		opts.bStickyReticule = generalForm.elements["stickyreticule"].selValue == 2
		opts.bSoldierHints = generalForm.elements["soldierhints"].selValue == 2
		opts.bMovieSubtitles = generalForm.elements["subtitles"].selValue == 2
	end,

	OnRadioChanged = function(buttongroup, btnNum)
		local this = ifs_opt_general
		local generalForm = this.formcontainergeneral.form

		if ( buttongroup.tag == "friendlyfire" ) then
			this.GeneralOpts.iFriendlyFire = 100 - this.GeneralOpts.iFriendlyFire
		elseif ( buttongroup.tag == "diff" ) then
			-- 'easy' is 1, but there is no easy.
			this.GeneralOpts.iDifficulty = btnNum + 1
		elseif ( buttongroup.tag == "ttstate" ) then
			ScriptCB_SetToolTipState(btnNum)
		end

		generalForm.elements[buttongroup.tag].selValue = btnNum
		this:UpdateGeneralOptionBools()

		Form_SetValues(this.formcontainergeneral.form)
		ScriptCB_SetGeneralOptions(this.GeneralOpts)
		ifs_opt_general_fnUpdateStrings(this)
	end,

    OnElementChanged = function(form, element)
		local this = ifs_opt_general
		local generalForm = this.formcontainergeneral.form
		this.GeneralOpts = ScriptCB_GetGeneralOptions()
		
		if ( element.tag == "reticulealpha" ) then
			ScriptCB_SetReticuleTransparency(1 - element.selValue)
			this.GeneralOpts.iReticuleAlpha = 1 - element.selValue
		end
		
		ScriptCB_SetGeneralOptions(this.GeneralOpts)
		Form_SetValues(this.formcontainergeneral.form)
		ifs_opt_general_fnUpdateStrings(this)
	end,


	Input_GeneralLeft = function(this)
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
 			this.bResetProfile = 1
			ScriptCB_PopScreen()
		end
	end,
	
	Input_GeneralRight = function(this)
		local button_changed = nil
		if(this.CurButton == "persp") then
			this.GeneralOpts.bFirstPerson = not this.GeneralOpts.bFirstPerson
			button_changed = 1
		elseif (this.CurButton == "rumble") then
			this.GeneralOpts.bRumble = not this.GeneralOpts.bRumble
			button_changed = 1
		elseif (this.CurButton == "friendlyfire") then
			this.GeneralOpts.iFriendlyFire = 100 - this.GeneralOpts.iFriendlyFire
			button_changed = 1
		elseif (this.CurButton == "autoaim") then
			this.GeneralOpts.bAutoAim = not this.GeneralOpts.bAutoAim
			button_changed = 1
		elseif (this.CurButton == "aimassist") then
			this.GeneralOpts.bAimAssist = not this.GeneralOpts.bAimAssist
			button_changed = 1
		elseif (this.CurButton == "stickyreticule") then
			this.GeneralOpts.bStickyReticule = not this.GeneralOpts.bStickyReticule
			button_changed = 1
-- 		elseif (this.CurButton == "hero") then
-- 			this.GeneralOpts.bHeroes = not this.GeneralOpts.bHeroes
-- 			button_changed = 1
		elseif (this.CurButton == "diff") then
			local CurDiff = this.GeneralOpts.iDifficulty
			local NewDiff
			if(CurDiff < 3) then
				NewDiff = 3 -- hard
			else
				NewDiff = 2 -- medium
			end
			this.GeneralOpts.iDifficulty = NewDiff
			button_changed = 1
		elseif (this.CurButton == "ttstate") then
			ScriptCB_NextToolTipState();
			button_changed = 1
		end
		ScriptCB_SetGeneralOptions(this.GeneralOpts)
		ifs_opt_general_fnUpdateStrings(this)
		
		Form_SetValues(this.formcontainergeneral.form)
		
		if button_changed then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
		end
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		gDefault_Input_GeneralUp(this)
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		gDefault_Input_GeneralDown(this)
	end,
	
    Update = function(this, fDt)
        gIFShellScreenTemplate_fnUpdate(this, fDt)  -- always call base class
        Form_Update(this.formcontainergeneral.form, fDt)
	end
}

ifs_opt_general_layout = {
	yTop = 25,
	yHeight = 30,
	ySpacing = 5,
	bUseYSpacing = 1,
	xSpacing = 20,
	font = "gamefont_small",
	flashy = 0,
	width = 300,
	elements = {
		{ tag = "diff", title = "ifs.gameopt.difficulty", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.difficulty.medium", "ifs.difficulty.hard"}},
		{ tag = "persp", title = "ifs.gameopt.camera", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.GameOpt.cam_cockpit", "ifs.GameOpt.cam_forward"}},
		{ tag = "rumble", title = "ifs.gameopt.rumble", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
		{ tag = "friendlyfire", title = "ifs.gameopt.friendlyfire", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
		{ tag = "autoaim", title = "ifs.gameopt.autoaim", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
		{ tag = "aimassist", title = "ifs.gameopt.aimassist", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
		{ tag = "stickyreticule", title = "ifs.gameopt.stickyreticule", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
		{ tag = "soldierhints", title = "ifs.gameopt.soldierhint", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}},
--		{ tag = "hero", title = "ifs.gameopt.hero", string = "" },
		{ tag = "ttstate", title = "ifs.gameopt.ttstate", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.GameOpt.tt_off", "ifs.GameOpt.tt_auto", "ifs.GameOpt.tt_on"}},
        --{ tag = "lightingquality", title = "ifs.videoopt.lightingquality", selValue = 1, control = "dropdown", values = {"ifs.VideoOpt.low", "ifs.VideoOpt.med", "ifs.VideoOpt.high"} },
        { tag = "subtitles", title = "ifs.gameopt.moviesubtitles", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.off", "common.on"}, },
		--{ tag = "ttreset", title = "", fnChanged = ifs_opt_general.OnRadioChanged, selValue = 1, control = "radio", values = {"common.select", "common.change"}},
        --{ tag = "viewdistance", title = "ifs.VideoOpt.viewdistance", selValue = 0.5, control = "slider", minValue = 0.0, maxValue = 1.0 },
		{ tag = "reticulealpha", title = "ifs.gameopt.reticulealpha", fnChanged = ifs_opt_general.OnElementChanged, selValue = 1.0, control = "slider", minValue = 0.0, maxValue = 1.0},
	}
}


function ifs_opt_general_fnBuildScreen(this)
	local w
	local h
	w,h = ScriptCB_GetSafeScreenInfo()
	
	-- add pc profile & title version text
	AddPCTitleText( this )
	
	ifs_opt_general_layout.width = w * 0.5
	this.formcontainergeneral = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.28,
		x = 0,
		y = 0,
	}
	for i, element in ipairs(ifs_opt_general_layout.elements) do
		if element.tag == "ttstate" then
			element.width = w * 0.75 * 0.5
		end
	end
	Form_CreateVertical(this.formcontainergeneral, ifs_opt_general_layout)
	this.formcontainergeneral.form.radiobuttons.x = 0
	this.formcontainergeneral.form.sliders.x = ifs_opt_general_layout.width * 0.5 
	this.formcontainergeneral.form.buttons.x = ifs_opt_general_layout.width + 35

	if( not ScriptCB_GetShellActive() ) then	
		this.Background = NewIFImage 
		{
 				ZPos = 255, 
 				x = w/2,  --centered on the x
 				y = h/2, -- inertUVs = 1,
 				alpha = 1,
 				localpos_l = -w/1.5, localpos_t = -h/1.5,
 				localpos_r = w/1.5, localpos_b =  h/1.5,
				texture = "opaque_black",
				ColorR = 0, ColorG = 0, ColorB = 0, -- black
 		}
 	end
 	
	-- Accept/Cancel buttons are PC only
	if(gPlatformStr == "PC") then

		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCOptionsTabsLayout)

		local BackButtonW = 150 -- made 130 to fix 6198 on PC - NM 8/18/04
		local BackButtonH = 25
		
		this.cancelbutton =	NewPCIFButton -- NewRoundIFButton 
		{
			ScreenRelativeX = 0.0, -- left
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = BackButtonW * 0.5,
			btnw = BackButtonW, 
			btnh = BackButtonH,
			font = "gamefont_medium", 
			bg_width = BackButtonW, 
			noTransitionFlash = 1,
			tag = "_back",
			string = "common.cancel",
		}
        
		this.resetbutton = NewPCIFButton
		{
			ScreenRelativeX = 0.5, -- right
			ScreenRelativeY = 1.0, -- bottom
			x = 0,
			y = -15, -- just above bottom						
			btnw = BackButtonW * 1.5,
			btnh = BackButtonH,
			font = "gamefont_medium",
			noTransitionFlash = 1,
			tag = "reset",
			string = "common.reset",
		}
		
		this.donebutton = NewPCIFButton -- NewRoundIFButton 
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
			string = "common.accept"
		}
	end
end

ifs_opt_general_fnBuildScreen(ifs_opt_general)
ifs_opt_general_fnBuildScreen = nil
AddIFScreen(ifs_opt_general,"ifs_opt_general")
ifs_opt_general = DoPostDelete(ifs_opt_general)
