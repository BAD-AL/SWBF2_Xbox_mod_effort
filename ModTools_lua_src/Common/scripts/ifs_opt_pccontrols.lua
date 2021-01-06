--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- this file overrides the controller screen in the default build with the PC controls options menu
-- This is the input popup stuff

-----------------------------------
-- key press popup

ifs_opt_pckeyboard_Popup_KeyPress = NewPopup {		
	ScreenRelativeX = 0.5, -- centered onscreen
	ScreenRelativeY = 0.5,
	height = 170,
	width = 275,
	ZPos = 50,

	title = NewIFText {
		string = "ifs.GameOpt.pc_keybindpopup",
		font = "gamefont_medium",
		textw = 250,
		texth = 150,
		y = -60,
		inert = 1,
		nocreatebackground = 1,
	},

	buttons = NewIFContainer {
	},

	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	
	Enter = function(this)
		--print("Entered the enter function")
		this.gDelay = 0.35
		
		-- remove cursor from screen
		ScriptCB_EnableCursor(false)
		
		-- switch string according to input thing
		local idx = ifs_opt_pckeyboard_listbox_layout.SelectedIdx
		local action = ScriptCB_GetActionFromIdx(idx)
		local mode = ScriptCB_GetControlMode()
		
		if ( action == 30 and mode == 2 ) then -- ePROCESSEDINPUT_STRAFE_AXIS for flyers
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_ccw"))
		elseif ( action == 30 ) then -- ePROCESSEDINPUT_STRAFE_AXIS
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_right"))
		elseif ( action == 31 and mode == 2 ) then -- ePROCESSEDINPUT_MOVE_AXIS for flyers
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_throttle"))
		elseif ( action == 31 and mode == 4 ) then -- ePROCESSEDINPUT_MOVE_AXIS for turrets
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_zoom"))
		elseif ( action == 31 ) then -- ePROCESSEDINPUT_MOVE_AXIS
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_forward"))
		elseif ( action == 32 ) then -- ePROCESSEDINPUT_TURN_AXIS
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_right"))
		elseif ( action == 33 ) then -- ePROCESSEDINPUT_PITCH_AXIS
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup_up"))
		else
			IFText_fnSetUString(this.title, ScriptCB_getlocalizestr("ifs.GameOpt.pc_keybindpopup"))
		end

		-- Chunk removed NM 5/17/05 - this is a popup. It doesn't do tabs
		if(nil) then -- gPlatformStr == "PC") then
			ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
			ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_controls", 1)
		end
	end,
	
	Input_Back = function(this)
	end,

	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt)  -- call base class
		this.gDelay = this.gDelay - fDt
		
		if (this.gDelay > 0.0) then
			return
		end
		
		rtype = ScriptCB_SetBinding(ifs_opt_pckeyboard_listbox_layout.SelectedIdx, fDt)
		if(rtype == 1) then
--			print("Detected Input")
			ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
			-- put cursor back where it belongs
			ScriptCB_EnableCursor(true)
			gPopup_fnInput_Back(this)
		end
	end
}
--AddVerticalButtons(ifs_opt_pckeyboard_Popup_KeyPress.buttons,Vertical_YesNoButtons_layout)
CreatePopupInC(ifs_opt_pckeyboard_Popup_KeyPress,"ifs_opt_pckeyboard_Popup_KeyPress")

-- End of popup Input stuff

-- Helper functions for Input stuff

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_opt_pckeyboard_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}

	-- Changed to shrink text NM 8/25/04 - Squad commands are too long
	-- in Spanish to fit w/o having to really shrink things. Bug 9153
	local UseFont = "gamefont_tiny"
	local UseHScale = 1
	local UseVScale = 1
	if(gLangStr ~= "english") then
		UseHScale = 0.85
		UseVScale = 1
	end

	Temp.actionStr = NewIFText{
		x = 10, y = 0, textw = 0.4 * layout.width, 
		valign = "vcenter", halign = "left", 
		font = UseFont,
		--ColorR= 255, ColorG = 255, ColorB = 255,
		flashy = 0,
		texth = layout.height,
		HScale = UseHScale,
		VScale = UseVScale,
	}
	Temp.keyStr = NewIFText{ 
		x = layout.width*.4, y = 0, 
		textw = 0.6 * layout.width, 
		valign = "vcenter", halign = "left", 
		font = UseFont,
		ColorR= 255, ColorG = 255, ColorB = 255,
		flashy = 0,
		texth = layout.height,
		HScale = UseHScale,
		VScale = UseVScale,
	}

		
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_opt_pckeyboard_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		IFText_fnSetUString(Dest.actionStr,Data.actionStr)
		IFText_fnSetUString(Dest.keyStr,Data.keyStr)

		IFObj_fnSetColor(Dest.actionStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.actionStr, fAlpha)
		IFObj_fnSetColor(Dest.keyStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.keyStr, fAlpha)
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

--NOTE TO SELF:  Move this down
ifs_opt_pckeyboard_listbox_layout = {
	showcount = 20,
--	yTop = -130 + 13,
	yHeight = 23,
	ySpacing  = 0,
	width = 430,
	x = 0,
	slider = 1,
	CreateFn = ifs_opt_pckeyboard_Listbox_CreateItem,
	PopulateFn = ifs_opt_pckeyboard_Listbox_PopulateItem,
	font = "gamefont_tiny",
	
}
-- this creates the table _listbox_contents below, adding all the action/key pairs
ifs_opt_pckeyboard_listbox_contents = {
--	{ actionStr = "Fire", keyStr = "Ctrl"},
}
--End of Helper functions for Input stuff

----------------------------------------------------------------------------------------
-- save the profile in slot 1
----------------------------------------------------------------------------------------

function ifs_opt_pccontrols_StartSaveProfile()
	--  print("ifs_opt_top_StartSaveProfile")
	
	ifs_saveop.doOp = "SaveProfile"
	ifs_saveop.OnSuccess = ifs_opt_pccontrols_SaveProfileSuccess
	ifs_saveop.OnCancel = ifs_opt_pccontrols_SaveProfileCancel
	local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
	ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
	ifs_saveop.saveProfileNum = iProfileIdx
	ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_pccontrols_SaveProfileSuccess()
	--  print("ifs_opt_top_SaveProfileSuccess")
	local this = ifs_opt_pccontrols
	
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

function ifs_opt_pccontrols_SaveProfileCancel()
	--  print("ifs_opt_top_SaveProfileCancel")
	local this = ifs_opt_pccontrols
	
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


function ifs_opt_pccontrols_fnUpdateStrings(this)
	--update slider position
	local mouseSens, mouseSensStep, mouseSensMax = ScriptCB_GetMouseSensitivity()
	this.sliders.mousesens.thumbposn = (mouseSens / mouseSensMax)
	HSlider_MoveThumb(this.sliders.mousesens)
	RoundIFButtonLabel_fnSetUString(this.buttons.mousesens,ScriptCB_tounicode(string.format("%d",mouseSens)))

	-- link joy sensitivity so x and y are always the same.
	local joysense, joysenseStep, joysenseMax = ScriptCB_GetJoySensitivity(0)
--	print("joysense, joysenseStep, joysenseMax ",joysense,joysenseStep,joysenseMax)
	
	this.sliders.joysens.thumbposn = (joysense / joysenseMax)
	HSlider_MoveThumb(this.sliders.joysens)
	RoundIFButtonLabel_fnSetUString(this.buttons.joysens,ScriptCB_tounicode(string.format("%d",joysense)))
	
	local deadsetting, deadStep, deadMax = ScriptCB_GetDeadZone()
	this.sliders.deadzone.thumbposn = (deadsetting / deadMax)
	HSlider_MoveThumb(this.sliders.deadzone)
	RoundIFButtonLabel_fnSetUString(this.buttons.deadzone, ScriptCB_tounicode(string.format("%d",deadsetting)))
	
	
	local mode = ScriptCB_GetControlMode()
	if ( mode == 2 ) then
		IFText_fnSetString(this.buttonlabels["invert"], "ifs.GameOpt.pc_invert2")
	else
		IFText_fnSetString(this.buttonlabels["invert"], "ifs.GameOpt.pc_invert")
	end
	
	local flip = ScriptCB_GetYAxisFlip()
	
	if ( flip == 1 ) then      
		RoundIFButtonLabel_fnSetString(this.buttons.invert, "common.yes" )
		ifelem_SelectRadioButton(this.radiobuttons["invert"], 2, true)
	else	
		ifelem_SelectRadioButton(this.radiobuttons["invert"], 1, true)
		RoundIFButtonLabel_fnSetString(this.buttons.invert, "common.no" )
	end
	
	local turnassist = ScriptCB_GetMouseTurnAssist()
	if ( turnassist == 1 ) then
		ifelem_SelectRadioButton(this.radiobuttons["turnassist"], 2, true)
		RoundIFButtonLabel_fnSetString(this.buttons.turnassist, "common.yes")
	else
		ifelem_SelectRadioButton(this.radiobuttons["turnassist"], 1, true)
		RoundIFButtonLabel_fnSetString(this.buttons.turnassist, "common.no")
	end
	

	if(gPlatformStr == "PC") and this.bShellMode then
		IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
	end
end

function ifs_opt_pccontrols_fnChangeMouseSensitivity(this,delta)
	local mouseSens, mouseSensStep, mouseSensMax = ScriptCB_GetMouseSensitivity()
	mouseSens = mouseSens + mouseSensStep * delta
	
	mouseSens = math.max(mouseSens,0)
	mouseSens = math.min(mouseSens,mouseSensMax)
	ScriptCB_SetMouseSensitivity(mouseSens)
end

function ifs_opt_pccontrols_fnChangeJoySensitivity(this,delta)
	local joySens, joySensStep, joySensMax = ScriptCB_GetJoySensitivity(0)
	joySens = joySens + joySensStep * delta
	joySens = math.max(joySens,0)
	joySens = math.min(joySens,joySensMax)
--	print( "New Sensitivity=", joySens )
	ScriptCB_SetJoySensitivity(joySens, 0)
	ScriptCB_SetJoySensitivity(joySens, 1)
end

function ifs_opt_pccontrols_fnChangeDeadZone(this, delta)
	local deadSetting, deadStep, deadMax = ScriptCB_GetDeadZone(0)
	deadSetting = deadSetting + deadStep * delta
	deadSetting = math.max(deadSetting, 0)
	deadSetting = man.min(deadSetting, deadMax)
	ScriptCB_SetDeadZone(deadSetting)
end

local dim_backdrop = 1
local image_background = nil
if( 1 ) then
--if( gPCBetaBuild ) then
	if( ScriptCB_GetShellActive() ) then
		--print("set background iface_bg_1")
		image_background = "iface_bg_1"
		dim_backdrop = nil
	end
end

function ifs_opt_pccontrols_fnInvertCB(buttongroup, btnNum)
	ScriptCB_SetYAxisFlip(btnNum - 1)
end

function ifs_opt_pccontrols_fnTurnAssistCB(buttongroup, btnNum)
	ScriptCB_SetMouseTurnAssist(btnNum - 1)
end

ifs_opt_pccontrols = NewIFShellScreen {
	nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
	bNohelptext_backPC = 1,
	bg_texture = image_background,
	bDimBackdrop = dim_backdrop,
	  
--	title = NewIFText {
--		string = "ifs.GameOpt.pc_optionstitle",
--		font = "gamefont_large",
--		y = 5,
--		textw = 800,
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0, -- top
--		inert = 1, -- delete out of Lua mem when pushed to C
--		nocreatebackground=1,
--	},

	bindTitle = NewIFText {
		string = "ifs.GameOpt.pc_configbindings",
		font = "gamefont_large",
		y = 240,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		inert = 1, -- delete out of Lua mem when pushed to C
		flashy=0,
	},
	
	buttonlabels = NewIFContainer {
		ScreenRelativeX = 0.30,
		ScreenRelativeY = 0,
	},
	buttons = NewIFContainer {
		ScreenRelativeX = 1,
		ScreenRelativeY = 0,
	},
	
--	hbuttons = NewIFContainer {
--		ScreenRelativeX = 0.15,
--		ScreenRelativeY = 0,
--	},
	
	sliders = NewIFContainer {
		ScreenRelativeX = 0.15,
		ScreenRelativeY = 0,
	},

	Enter = function(this, bFwd)
		ScriptCB_MarkCurrentProfile()
		this.bResetProfile = nil
	
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		AnimationMgr_AddAnimation(this.buttonlabels, {fStartAlpha = 0, fEndAlpha = 1,})
		
		local controlMode = ScriptCB_GetControlMode()

		if(gPlatformStr == "PC") then
			-- use shell mode?
			this.bShellMode = 
				ScriptCB_GetShellActive() and 
				ScriptCB_GetGameRules() ~= "metagame" and 
				ScriptCB_GetGameRules() ~= "campaign"
				
			if( this.bShellMode ) then
				-- hide apply and cancel buttons
				IFObj_fnSetVis(this.donebutton, 1)
				IFObj_fnSetVis(this.cancelbutton, false)
				
				-- show options, controls, and soldier tabs
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_options")
				ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_controls", 1)
				ifelem_tabmanager_SetSelected(this, gPCControlsOptionsTabsLayout, "_tab_soldier", 2)
				
				-- set pc profile & title version text
				UpdatePCTitleText(this)
				
				ScriptCB_SetControlMode(0) --default to soldier first
				gPCControlsSoldierTabFn(nil) -- select the soldier tab by default
			else
				-- show apply and cancel buttons
				IFObj_fnSetVis(this.donebutton, true)
				IFObj_fnSetVis(this.cancelbutton, true)
				
				-- show controls and soldier tabs
                ifelem_tabmanager_SelectTabGroup(this, nil, 1, 2)
                ifelem_tabmanager_SetSelected(this, gPCOptionsTabsLayout, "_tab_controls", 1)
                ifelem_tabmanager_SetSelected(this, gPCControlsOptionsTabsLayout, "_tab_soldier", 2)
                
				-- hide pc profile & title version text
                HidePCTitleText(this)	
                
                if(controlMode == 1) then
					gPCControlsVehicleTabFn(nil) -- select the vehicle tab by default		
				elseif(controlMode == 2) then
					gPCControlsFlyerTabFn(nil) -- select the starfighter tab by default		
				elseif(controlMode == 3) then
					gPCControlsJediTabFn(nil) -- select the flyer tab by default		
				elseif(controlMode == 4) then
					gPCControlsTurretTabFn(nil) -- select the jedi tab by default		
				else 
					gPCControlsSoldierTabFn(nil) -- select the turret tab by default		
				end
			end
		
			-- dim tabs for PC Demo
			ifs_DimTabsPCDemo(this)            			
		end

		if ( controlMode == 0 or controlMode == 3 ) then
 			IFObj_fnSetVis(this.buttonlabels.turnassist, nil)
 			IFObj_fnSetVis(this.radiobuttons.turnassist, nil)
 		else
 			IFObj_fnSetVis(this.buttonlabels.turnassist, 1)
 			IFObj_fnSetVis(this.radiobuttons.turnassist, 1)
 		end
 		
 		IFObj_fnSetVis(this.buttonlabels.turnassist, nil)
 		IFObj_fnSetVis(this.radiobuttons.turnassist, nil)
 		IFObj_fnSetVis(this.buttonlabels.mousesens, nil)
 		IFObj_fnSetVis(this.sliders.mousesens, nil)
 		IFObj_fnSetVis(this.buttons.mousesens, nil)
 		IFObj_fnSetVis(this.buttonlabels.joysens, nil)
 		IFObj_fnSetVis(this.sliders.joysens, nil)
 		IFObj_fnSetVis(this.buttons.joysens, nil)
 		IFObj_fnSetVis(this.buttonlabels.invert, nil)
 		IFObj_fnSetVis(this.radiobuttons.invert, nil)
 		IFObj_fnSetVis(this.buttonlabels.deadzone, nil)
 		IFObj_fnSetVis(this.sliders.deadzone, nil)
 		IFObj_fnSetVis(this.buttons.deadzone, nil)

		this:ShowHide(this.formcontainer.form)
		this:ApplySettingsToForm()

		ifs_opt_pccontrols_fnUpdateStrings(this)
		
		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		ifs_opt_pckeyboard_listbox_layout.FirstShownIdx = 1
		ifs_opt_pckeyboard_listbox_layout.SelectedIdx = 1
		ifs_opt_pckeyboard_listbox_layout.CursorIdx = 1
		ScriptCB_GetKeyBoardCmds()
		ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
		
	end, -- function Enter()
	
	Exit = function(this)
		if( this.bResetProfile ) then
			ScriptCB_ReloadMarkedProfile()
		end
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil)
		end
	end,
	
	OnRadioChanged = function(buttongroup, btnNum)
		local this = ifs_opt_pccontrols
		if (buttongroup.tag == "invert") then
			ScriptCB_SetYAxisFlip(btnNum - 1)
		elseif (buttongroup.tag == "turnassist") then
			ScriptCB_SetMouseTurnAssist(btnNum - 1)
		elseif (buttongroup.tag == "persp") then
			this.GeneralOptions = ScriptCB_GetGeneralOptions()
			local mode = ScriptCB_GetControlMode()
			if ( mode == 0 ) then
				this.GeneralOptions.bFirstPerson = ( btnNum == 1 )
			elseif ( mode == 2 ) then
				this.GeneralOptions.bFirstPersonFlyer = ( btnNum == 1 )
			end
			ScriptCB_SetGeneralOptions(this.GeneralOptions)
		end
		
		this:ApplySettingsToForm()
	end,
	
	OnElementChanged = function(form, element)
		local this = ifs_opt_pccontrols
		local setting, step, max
		local newSetting
		if (element.tag == "mousesens") then
			setting, step, max = ScriptCB_GetMouseSensitivity()
			newSetting = math.floor(element.selValue * max + 0.5)
			ScriptCB_SetMouseSensitivity( newSetting )
		elseif (element.tag == "joysens") then
			setting, step, max = ScriptCB_GetJoySensitivity(0)
			newSetting = math.floor(element.selValue * max + 0.5)
			ScriptCB_SetJoySensitivity( newSetting, 0 )
			ScriptCB_SetJoySensitivity( newSetting, 1 )
		elseif (element.tag == "deadzone") then
			setting, step, max = ScriptCB_GetDeadZone()
			newSetting = math.floor(element.selValue * max + 0.5)
			ScriptCB_SetDeadZone( newSetting )
		end
		
		this:ApplySettingsToForm()
		
		if(gPlatformStr == "PC") and this.bShellMode then
			IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
		end
	end,
	
	ApplySettingsToForm = function(this)
		local form = this.formcontainer.form
		local mouseSens, mouseSensStep, mouseSensMax = ScriptCB_GetMouseSensitivity()
		local joySens, joySensStep, joySensMax = ScriptCB_GetJoySensitivity(0)
		local deadSetting, deadStep, deadMax = ScriptCB_GetDeadZone()
		this.GeneralOptions = ScriptCB_GetGeneralOptions()

		local bPersp = 2
		if ( ScriptCB_GetControlMode() == 0 and this.GeneralOptions.bFirstPerson == true ) then
			bPersp = 1
		elseif ( ScriptCB_GetControlMode() == 2 and this.GeneralOptions.bFirstPersonFlyer == true ) then
			bPersp = 1
		end
		
		form.elements["mousesens"].selValue = mouseSens / mouseSensMax
		form.elements["joysens"].selValue = joySens / joySensMax
		form.elements["invert"].selValue = ScriptCB_GetYAxisFlip() + 1
		form.elements["deadzone"].selValue = deadSetting / deadMax
		form.elements["turnassist"].selValue = ScriptCB_GetMouseTurnAssist() + 1 -- must add one, yo
		form.elements["persp"].selValue = bPersp
		
		Form_SetValues(form)

		if(gPlatformStr == "PC") and this.bShellMode then
			IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
		end
	end,
	
	ShowHide = function(this, form)
		local controlMode = ScriptCB_GetControlMode()
		form.elements["turnassist"].hidden = controlMode == 0 or controlMode == 3
		form.elements["persp"].hidden = controlMode == 1 or controlMode == 3 or controlMode == 4
		
		Form_ShowHideElements(form)
	end,

	Input_Accept = function(this) 
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this,1)) then
			return
		end

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

			-- Check options tabs 
			if(this.NextScreen) then
				if(ScriptCB_IsCurProfileDirty()) then
					ifs_opt_pccontrols_StartSaveProfile()
					return
				else
					-- No need to save. Just jump there
					ScriptCB_SetIFScreen(this.NextScreen)
					this.NextScreen = nil
					return
				end
			end -- this.Nextscreen is valid (i.e. clicked on a tab)
		end -- cur platform == PC

		-- Check sub-screen tabs
		if((gPlatformStr == "PC") and 
			 ( ifelem_tabmanager_HandleInputAccept(this, gPCControlsOptionsTabsLayout, 2))) then
			return
		end

		if (Form_InputAccept(this.formcontainer.form) == true) then
			return
		end

		-- Check radio buttons
		--if ( ifelem_HandleRadioButtonInputAccept(this) ) then
		--	return
		--end
		
--		print("CurButton=", this.CurButton)
		if(this.CurButton == "cancel" ) then
			this.bResetProfile = 1		
			this:Input_Back()
			return
		end

		if(this.CurButton == "_back") then
			this:Input_Back()
			return
		end
		
--		print("gMouseOverHorz = ", gMouseOverHorz, " pct = ",  gMouseOverHorz.fHitX)
		if((gMouseOverHorz) and (gMouseOverHorz.fHitX)) then
			-- Convert mouse percentage into 0..10 scale used on this screen

			if(gMouseOverHorz.tag == "mousesens") then
				local mouseSens, mouseSensStep, mouseSensMax = ScriptCB_GetMouseSensitivity()
				--print ( "mouseSensMax, gMouseOverHorz.fHitX:", mouseSensMax, gMouseOverHorz.fHitX)
				mouseSens = math.min(mouseSensMax, math.max(1, math.floor(mouseSensMax * gMouseOverHorz.fHitX + 0.5)))
				--print ( "mouseSensMax*gMouseOverHorz.fHitX + 0.5:", mouseSensMax * gMouseOverHorz.fHitX + 0.5)
				--print ( "math.floor() =:", math.floor(mouseSensMax * gMouseOverHorz.fHitX + 0.5) )
				ScriptCB_SetMouseSensitivity(mouseSens)

			elseif (gMouseOverHorz.tag == "joysens") then
				local joysense, joysenseStep, joysenseMax = ScriptCB_GetJoySensitivity(0)
				joysense = math.min(joysenseMax, math.max(1, math.floor(joysenseMax * gMouseOverHorz.fHitX + 0.5)))
				ScriptCB_SetJoySensitivity(joysense, 0)
				ScriptCB_SetJoySensitivity(joysense, 1)
			elseif (gMouseOverHorz.tag == "deadzone") then
				local deadSetting, deadStep, deadMax = ScriptCB_GetDeadZone()
				deadSetting = math.min(deadMax, math.max(1, math.floor(deadMax * gMouseOverHorz.fHitX + 0.5)))
				ScriptCB_SetDeadZone(deadSetting)
			end

			ifs_opt_pccontrols_fnUpdateStrings(this)
			return
		end
			


		if( gMouseListBox ~= nil ) then  --Slight hack, could be dangerous if you add list boxes
			gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
			ListManager_fnFillContents(gMouseListBox,gMouseListBox.Contents,gMouseListBox.Layout)
			ifs_opt_pckeyboard_Popup_KeyPress:fnActivate(1)
		end
		ScriptCB_SndPlaySound("shell_menu_ok");
		--if (this.CurButton == "mousesens") then
		--	ifs_opt_pccontrols_fnChangeMouseSensitivity(this,1.0)
		--elseif (this.CurButton == "joysens") then	
		--	ifs_opt_pccontrols_fnChangeJoySensitivity(this,1.0)
		if (this.CurButton == "reset") then
--			print("Resetting Controls")
			ScriptCB_ResetControl()
			ifs_opt_pccontrols_fnUpdateStrings(this)
			this.RepaintListbox(this)
		elseif (this.CurButton == "invert") then
			local flip = ScriptCB_GetYAxisFlip()
			
			if ( flip == 1 ) then
				--was flipped, unflip
				ScriptCB_SetYAxisFlip( 0 )
				--RoundIFButtonLabel_fnSetString(this.buttons.invert, "common.no" )
			else
				ScriptCB_SetYAxisFlip( 1 )
				--RoundIFButtonLabel_fnSetString(this.buttons.invert, "common.yes" )
			end
		--elseif (this.CurButton == "turnassist") then
		--	local turnassist = ScriptCB_GetMouseTurnAssist()
			
		--	if ( turnassist == 1 ) then
		--		ScriptCB_SetMouseTurnAssist( 0 )
		--		RoundIFButtonLabel_fnSetString(this.buttons.turnassist, "common.no")
		--	else
		--		ScriptCB_SetMouseTurnAssist( 1 )
		--		RoundIFButtonLabel_fnSetString(this.buttons.turnassist, "common.yes")
		--	end
		elseif (this.CurButton == "config") then
			ScriptCB_PushScreen("ifs_opt_pckeyboard") --("ifs_opt_pckeyboard")
		elseif (this.CurButton == "apply") then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			this.bResetProfile = nil
			if(ScriptCB_IsCurProfileDirty()) then
				this.NextScreen = -1 -- flag special behavior
				ifs_opt_pccontrols_StartSaveProfile()
			else
				this:Input_Back(1)
			end
 		end
		ifs_opt_pccontrols_fnUpdateStrings(this)
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
	
	Input_GeneralLeft = function(this)
		if (this.CurButton == "mousesens") then
			ifs_opt_pccontrols_fnChangeMouseSensitivity(this,-1.0)
		elseif( this.CurButton == "joysens") then
			ifs_opt_pccontrols_fnChangeJoySensitivity(this,-1.0)
		elseif ( this.CurButton == "deadzone") then
			ifs_opt_pccontrols_fnChangeDeadZone(this,-1.0)
		elseif( this.CurButton == "invert") then
			this:Input_Accept(1)
		elseif( this.CurButton == "turnassist") then
			this:Input_Accept(1)
		else
			gDefault_Input_GeneralLeft(this)
		end
		ifs_opt_pccontrols_fnUpdateStrings(this)
	end,

	Input_GeneralRight = function(this)
		if (this.CurButton == "mousesens") then
			ifs_opt_pccontrols_fnChangeMouseSensitivity(this,1.0)
		elseif( this.CurButton == "joysens") then
			ifs_opt_pccontrols_fnChangeJoySensitivity(this,1.0)
		elseif( this.CurButton == "deadzone") then
			ifs_opt_pccontrols_fnChangeDeadZone(this,1.0)
		elseif( this.CurButton == "invert") then
			this:Input_Accept(1)
		elseif( this.CurButton == "turnassist") then
			this:Input_Accept(1)
		else
			gDefault_Input_GeneralRight(this)
		end
		ifs_opt_pccontrols_fnUpdateStrings(this)
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		if(this.CurButton == "mousesens" )  then --hack
		--move onto the horizontal boxes
			--SetCurButton("soldier")
			SetCurButtonTable(this.donebutton)
		elseif( gMouseListBox ~= nil) then  
			if( ifs_opt_pckeyboard_listbox_layout.CursorIdx ~= 1 ) then
				ListManager_fnNavUp(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
			else
				gMouseListBox = nil
				--SetCurButtonTable(this.buttons.turnassist)
			end
		elseif(this.CurButton == "soldier" or this.CurButton == "vehicle" or this.CurButton == "flyer" or this.CurButton == "jedi" or this.CurButton == "turret") then
			SetCurButtonTable(this.donebutton)
		elseif(this.CurButton == "apply" or this.CurButton == "cancel" ) then
			--move onto the listbox
			SetCurButton(nil)
			gCurHiliteButton = nil
			ifs_opt_pckeyboard_listbox_layout.CursorIdx = 1
			ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
			gMouseListBox = this.listbox
		else
			gMouseListBox = nil
			gDefault_Input_GeneralUp(this)
		end
		ifs_opt_pccontrols_fnUpdateStrings(this)
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		if(this.CurButton == "turnassist" )  then --hack
		--move onto the listbox
			SetCurButton(nil)
			ifs_opt_pckeyboard_listbox_layout.CursorIdx = 1
			ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
			gMouseListBox = this.listbox
		elseif(this.CurButton == "soldier" or this.CurButton == "vehicle" or this.CurButton == "flyer" or this.CurButton == "jedi" or this.CurButton == "turret") then
			SetCurButtonTable(this.buttons.mousesens)
		elseif(this.CurButton == "apply" or this.CurButton == "cancel" ) then
			gMouseListBox = nil
			SetCurButton(nil)
			gMouseListBox = this.listbox
		elseif( gMouseListBox ~= nil ) then  --Slight hack, could be dangerous if you add list boxes
			local Count = table.getn(ifs_opt_pckeyboard_listbox_contents)
--			print("Count=", Count)
--			print("CursorIdx=",ifs_opt_pckeyboard_listbox_layout.CursorIdx)
			if ( Count == ifs_opt_pckeyboard_listbox_layout.CursorIdx ) then
				--its the last item in the listbox, move down to the accept button
				gMouseListBox = nil
				SetCurButtonTable(this.donebutton)
			else
				ListManager_fnNavDown(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
			end
		else
			gDefault_Input_GeneralDown(this)
		end
		ifs_opt_pccontrols_fnUpdateStrings(this)
		
		
		
		
	end,
	
	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global stats_listbox_contents
 	RepaintListbox = function(this)
		ScriptCB_GetKeyBoardCmds()	
 		ListManager_fnFillContents(this.listbox,ifs_opt_pckeyboard_listbox_contents,ifs_opt_pckeyboard_listbox_layout)
 		--if ( ScriptCB_GetControlMode() == 0 or ScriptCB_GetControlMode() == 3 ) then
 		--	IFObj_fnSetVis(this.buttonlabels.turnassist, nil)
 		--	IFObj_fnSetVis(this.radiobuttons.turnassist, nil)
 		--else 
 		--	IFObj_fnSetVis(this.buttonlabels.turnassist, 1)
 		--	IFObj_fnSetVis(this.radiobuttons.turnassist, 1)
 		--end
 		this:ShowHide(this.formcontainer.form)
 		this:ApplySettingsToForm()
 		--ShowHideVerticalText(this.buttons, vbutton_layout)
		if(gPlatformStr == "PC") and this.bShellMode then
			IFObj_fnSetVis(this.cancelbutton, ScriptCB_HasProfileChanged())
		end
	end,

	Update = function(this, fDt)
 		gIFShellScreenTemplate_fnUpdate(this, fDt)  -- always call base class

		HSlider_fnSetAlpha(this.sliders.mousesens,0.5) -- dim unselected one
		HSlider_fnSetAlpha(this.sliders.joysens,0.5) -- dim unselected one	
		HSlider_fnSetAlpha(this.sliders.deadzone,0.5)
		if(gMouseOverHorz ) then
			HSlider_fnSetAlpha(gMouseOverHorz,1.0) -- brite selected one
		end
		
		if( (this.CurButton == "joysens") or ( this.CurButton == "mousesens") or this.CurButton == "deadzone") then
			HSlider_fnSetAlpha(this.sliders[this.CurButton],1.0) -- brite selected one
		end
		
		Form_Update(this.formcontainer.form)
		--if ( not lastIdx or lastIdx ~= ifs_opt_pckeyboard_listbox_layout.SelectedIdx ) then
		--	print ( "idx:", ifs_opt_pckeyboard_listbox_layout.SelectedIdx )
		--	lastIdx = ifs_opt_pckeyboard_listbox_layout.SelectedIdx
		--end
	end,

}
ScriptCB_SetControlMode(0) --default to soldier first


--{ tag = "soldier", string = "ifs.Controls.Soldier.title", },
--		{ tag = "vehicle", string = "ifs.Controls.Vehicle.title", },  
--		{ tag = "flyer", string = "ifs.Controls.Flyer.title", },	
--		{ tag = "jedi", string = "ifs.Controls.Jedi.title", },
--		{ tag = "turret", string = "ifs.Controls.Turret.title", },
vbutton_layout = {
	yTop = 100,
	yHeight = 18,
	ySpacing  = 4,
	width = 200,
	xWidth = 260,
	font = "gamefont_tiny",
	RightJustify = 1,
	flashy = 0,
	buttonlist = {
		-- Title is for the left column, string the option (filled in by code later)
		{ tag = "mousesens", title = "ifs.GameOpt.pc_mousesens", string = "" },
		{ tag = "joysens", title = "ifs.GameOpt.pc_joysens", string = "" },
		{ tag = "invert", title = "ifs.gameopt.pc_invert", string = "common.no",},
		{ tag = "deadzone", title = "ifs.gameopt.pc_deadzone", string = "" },
		{ tag = "turnassist", title = "ifs.gameopt.pc_turnassist", string = "common.yes",},
	},
}

ifs_opt_pccontrols_form_layout = {
	yTop = 0,
	yHeight = 18,
	ySpacing  = 4,
	bUseYSpacing = 1,
	xSpacing = 15,
	width = 200,
	font = "gamefont_tiny",
	flashy = 0,
	elements = {
		-- Title is for the left column, string the option (filled in by code later)
		{ tag = "mousesens", title = "ifs.GameOpt.pc_mousesens", fnChanged = ifs_opt_pccontrols.OnElementChanged, selValue = 1, control = "slider", minValue = 0.0, maxValue = 1.0},
		{ tag = "joysens", title = "ifs.GameOpt.pc_joysens", fnChanged = ifs_opt_pccontrols.OnElementChanged, selValue = 1, control = "slider", minValue = 0.0, maxValue = 1.0, sliderMultiplier = 10},
		{ tag = "deadzone", title = "ifs.gameopt.pc_deadzone", fnChanged = ifs_opt_pccontrols.OnElementChanged, selValue = 1, control = "slider", minValue = 0.0, maxValue = 1.0, sliderMultiplier = 10},
		{ tag = "invert", title = "ifs.gameopt.pc_invert", fnChanged = ifs_opt_pccontrols.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"},},
		{ tag = "turnassist", title = "ifs.gameopt.pc_turnassist", fnChanged = ifs_opt_pccontrols.OnRadioChanged, selValue = 1, control = "radio", values = {"common.no", "common.yes"},},
		{ tag = "persp", title = "ifs.gameopt.camera", fnChanged = ifs_opt_pccontrols.OnRadioChanged, selValue = 1, control = "radio", values = {"ifs.GameOpt.cam_cockpit", "ifs.GameOpt.cam_forward"}},
	},
}

ifs_opt_pccontrols_hbutton_layout = {
	yTop = 60,
	xWidth = 200,
	xSpacing  = 0,	
	--font = "gamefont_medium",
--	RightJustify = 1,
--	xLeft = 0, -- calculated below
	allTitles = 1,
	buttonlist = 
	{
		{ tag = "soldier", string = "ifs.Controls.SoldierTab", },
		{ tag = "vehicle", string = "ifs.Controls.VehicleTab", },  
		{ tag = "flyer",   string = "ifs.Controls.FlyerTab", },	
		{ tag = "jedi",	   string = "ifs.Controls.JediTab", },
		{ tag = "turret",  string = "ifs.Controls.TurretTab", },
	},
}

AcceptCancel_button_layout = {
	yTop = 0,
	xWidth = 200,
	xSpacing  = 0,	
	--font = "gamefont_medium",
	RightJustify = 1,
	xLeft = 0,
	nocreatebackground = 1,
	bg_tail = 20,
	buttonlist = 
	{
		{ tag = "cancel", string = "common.cancel", },  
		{ tag = "reset", string = "common.reset", },  
		{ tag = "apply", string = "common.accept", },
		
	},
}

---------------------- horizontal buttons converted to tabs - Mike Z ---------------
gControlsOptionsTabsYPos = 101
gControlsOptionsTabsXPos = 125 --87

function gPCControlsSoldierTabFn( this )
	ScriptCB_SetControlMode(0)
	ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
	ifelem_tabmanager_SetSelected(ifs_opt_pccontrols, gPCControlsOptionsTabsLayout, "_tab_soldier", 2)
	ScriptCB_SndPlaySound("shell_menu_ok");  -- why the **** doesn't the sound call here WORK?
	ifs_opt_pccontrols_fnUpdateStrings(ifs_opt_pccontrols)
end

function gPCControlsVehicleTabFn( this )
	ScriptCB_SetControlMode(1)
	ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
	ifelem_tabmanager_SetSelected(ifs_opt_pccontrols, gPCControlsOptionsTabsLayout, "_tab_vehicle", 2)
	ScriptCB_SndPlaySound("shell_menu_ok");
	ifs_opt_pccontrols_fnUpdateStrings(ifs_opt_pccontrols)
end
function gPCControlsFlyerTabFn( this )
	ScriptCB_SetControlMode(2)
	ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
	ifelem_tabmanager_SetSelected(ifs_opt_pccontrols, gPCControlsOptionsTabsLayout, "_tab_flyer", 2)
	ScriptCB_SndPlaySound("shell_menu_ok");
	ifs_opt_pccontrols_fnUpdateStrings(ifs_opt_pccontrols)
end
function gPCControlsJediTabFn( this )
	ScriptCB_SetControlMode(3)
	ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
	ifelem_tabmanager_SetSelected(ifs_opt_pccontrols, gPCControlsOptionsTabsLayout, "_tab_jedi", 2)
	ScriptCB_SndPlaySound("shell_menu_ok");
	ifs_opt_pccontrols_fnUpdateStrings(ifs_opt_pccontrols)
end
function gPCControlsTurretTabFn( this )
	ScriptCB_SetControlMode(4)
	ifs_opt_pccontrols.RepaintListbox(ifs_opt_pccontrols)
	ifelem_tabmanager_SetSelected(ifs_opt_pccontrols, gPCControlsOptionsTabsLayout, "_tab_turret", 2)
	ScriptCB_SndPlaySound("shell_menu_ok");
	ifs_opt_pccontrols_fnUpdateStrings(ifs_opt_pccontrols)
end

local opt_tab_width = 158.5
local opt_tab_height = 30
gPCControlsOptionsTabsLayout = {
	{ tag = "_tab_soldier", string = "ifs.Controls.SoldierTab", xPos = gControlsOptionsTabsXPos, yPos = gControlsOptionsTabsYPos, callback = gPCControlsSoldierTabFn, width = opt_tab_width},
	{ tag = "_tab_vehicle", string = "ifs.Controls.VehicleTab", xPos = gControlsOptionsTabsXPos, yPos = gControlsOptionsTabsYPos + opt_tab_height, callback = gPCControlsVehicleTabFn, width = opt_tab_width},
	{ tag = "_tab_flyer", string = "ifs.Controls.FlyerTab", xPos = gControlsOptionsTabsXPos, yPos = gControlsOptionsTabsYPos + 2 * opt_tab_height, callback = gPCControlsFlyerTabFn, width = opt_tab_width},
	{ tag = "_tab_jedi", string = "ifs.Controls.JediTab", xPos = gControlsOptionsTabsXPos, yPos = gControlsOptionsTabsYPos + 3 * opt_tab_height, callback = gPCControlsJediTabFn, width = opt_tab_width},
	{ tag = "_tab_turret", string = "ifs.Controls.TurretTab", xPos = gControlsOptionsTabsXPos, yPos = gControlsOptionsTabsYPos + 4 * opt_tab_height, callback = gPCControlsTurretTabFn, width = opt_tab_width},
}
----------------

function ifs_opt_pccontrols_fnBuildScreen(this)
	-- Ask game for screen size, used to make sliders
	local w,aw,h,ah
	w,h = ScriptCB_GetSafeScreenInfo()
	aw,ah = ScriptCB_GetScreenInfo()

	-- add pc profile & title version text
	AddPCTitleText( this )
	
	ifs_opt_pccontrols_form_layout.width = w * 0.66
	for i, element in ipairs(ifs_opt_pccontrols_form_layout.elements) do
		element.width = w * 0.25
	end
	this.formcontainer = NewIFContainer {
		ScreenRelativeX = 0.6,
		ScreenRelativeY = 0.0,
		x = 0,
		y = gControlsOptionsTabsYPos - opt_tab_height,
	}
	Form_CreateVertical(this.formcontainer, ifs_opt_pccontrols_form_layout)
	this.formcontainer.form.radiobuttons.x = 0 -- -10
	this.formcontainer.form.radiobuttons.y = this.formcontainer.form.radiobuttons.y - 3
	this.formcontainer.form.sliders.x = ifs_opt_pccontrols_form_layout.xSpacing  -- 10
	this.formcontainer.form.buttons.x = ifs_opt_pccontrols_form_layout.width
	this.formcontainer.form.text.x = -ifs_opt_pccontrols_form_layout.width - ifs_opt_pccontrols_form_layout.xSpacing

	local NumButtons = table.getn(ifs_opt_pccontrols_hbutton_layout.buttonlist)
 	ifs_opt_pccontrols_hbutton_layout.xWidth = (w / NumButtons) - 20
	ifs_opt_pccontrols_hbutton_layout.xSpacing = 20
	ifs_opt_pccontrols_hbutton_layout.xLeft = -w + (ifs_opt_pccontrols_hbutton_layout.xWidth * 1.5) 
	
	local workingspace = (h*.95 )- 270 --save the bottom 5 percent for the accept / cancel butttons
	--adjust the working space because lists are always centered
	workingspace = (workingspace / 2 )
	
	this.listbox = NewButtonWindow
	{
		ZPos = 200, x=0, y = 270 + workingspace,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- Top of screen
		
		width = w,
		height = workingspace * 2,

		--height = h,
	}

	--bg layer
	this.Info = NewIFContainer { --container for all the backgrounds
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 0.0,
		inert = 1, -- delete from Lua memory once pushed to C
		ZPos = 255, 
	}
	this.Info.Background = NewButtonWindow 
	{
		ZPos = 255, 
		x = w/2,  --centered on the x
		y = (h*1.1 + 50)/2 , -- inertUVs = 1,
		alpha = 10,
		width = w*1.05,
		height = (workingspace * 2)*1.2 +140 - 30,  
		--localpos_l = -(w/2)*1.05, localpos_t = 0 ,
		--localpos_r =  (w/2)*1.05, localpos_b = (workingspace * 2)*1.1 +140,
		--texture = "opaque_black",
		--ColorR = 20, ColorG = 20, ColorB = 150, -- blue
 	}
	IFObj_fnSetVis(this.Info.Background, nil)
	
 	this.RInfo = NewIFContainer { --container for all the backgrounds
		ScreenRelativeX = 1.0,
		ScreenRelativeY = 0.0,
		inert = 1, -- delete from Lua memory once pushed to C
		ZPos = 255, 
	}
	
	local tabheight = this.Info.Background.y - (this.Info.Background.height * 0.5) - 22
	ifs_opt_pccontrols_hbutton_layout.height = 25
	ifs_opt_pccontrols_hbutton_layout.yTop = tabheight
	
	-- Made total width much larger for bug 9238 - NM 8/26/04
	AcceptCancel_button_layout.xWidth = w *.45
	AcceptCancel_button_layout.xSpacing = w*.4  - AcceptCancel_button_layout.xWidth
	AcceptCancel_button_layout.xLeft = -0.94 * w + (AcceptCancel_button_layout.xSpacing + AcceptCancel_button_layout.xSpacing + AcceptCancel_button_layout.xWidth) * 0.5
	AcceptCancel_button_layout.yTop = h - 10 --the default height - a little extra so it doesn't ride the bottom
	-- add buttons

	-- no longer using buttons, they're tabs now (at the bottom) - Mike Z
	--ifs_opt_pccontrols.CurButton = AddHorizontalButtons(this.buttons, ifs_opt_pccontrols_hbutton_layout )
	
	local BackButtonW = 150
	local BackButtonH = 25
	
	this.cancelbutton = NewPCIFButton {
		ScreenRelativeX = 0.0,
		ScreenRelativeY = 1.0,
		x = BackButtonW * 0.5,
		y = -15,
		btnw = BackButtonW,
		btnh = BackButtonH,
		font = "gamefont_medium",
		bg_tail = 20,
		noTransitionFlash = 1,
		tag = "cancel",
		string = "common.cancel",
	}
	
	this.resetbutton = NewPCIFButton {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 1.0,
		x = 0,
		y = -15,
		btnw = BackButtonW * 1.5,
		btnh = BackButtonH,
		font = "gamefont_medium",
		bg_tail = 20,
		noTransitionFlash = 1,
		tag = "reset",
		string = "common.reset",
	}
	
	this.donebutton = NewPCIFButton {
		ScreenRelativeX = 1.0,
		ScreenRelativeY = 1.0,
		x = -BackButtonW * 0.5,
		y = -15,
		btnw = BackButtonW,
		btnh = BackButtonH,
		font = "gamefont_medium",
		bg_tail = 20,
		noTransitionFlash = 1,
		tag = "apply",
		string = "common.accept",
	}

	AddVerticalText(this.buttonlabels,vbutton_layout)
	-- need to make width smaller. otherwise the button hotspot overlaps the
	-- slider, making it impossible to use the top end of the slider.
	vbutton_layout.width = 0.25 * vbutton_layout.width
	AddVerticalButtons(this.buttons,vbutton_layout)
	vbutton_layout.width = 4 * vbutton_layout.width
	--AddHorizontalButtons(this.buttons, AcceptCancel_button_layout )
	
	IFObj_fnSetVis(this.buttons.invert, nil)
	IFObj_fnSetVis(this.buttons.turnassist, nil)

	IFObj_fnSetPos(this.buttons.mousesens, this.buttons.mousesens.x - 65 )
	IFObj_fnSetPos(this.buttons.joysens, this.buttons.joysens.x - 65 )
	IFObj_fnSetPos(this.buttons.invert, this.buttons.invert.x - 65 )
	IFObj_fnSetPos(this.buttons.deadzone, this.buttons.deadzone.x - 65 )
	IFObj_fnSetPos(this.buttons.turnassist, this.buttons.turnassist.x - 65 )

 	-- mouse sensitivity slider
	this.sliders["mousesens"] = NewHSlider { 
		x = w * 0.57, y = this.buttons.mousesens.y, 
		width = w * 0.25, height = 24, thumbwidth = 10, 
		texturebg = "slider_sound", texturefg = "slider_fg",
	}
	this.sliders.mousesens.tag = "mousesens"

	this.sliders["joysens"] = NewHSlider { 
		x = w * 0.57, y = this.buttons.joysens.y, 
		width = w * 0.25, height = 24, thumbwidth = 10, 
		texturebg = "slider_sound", texturefg = "slider_fg",
	}
	this.sliders.joysens.tag = "joysens"
	
	this.sliders["deadzone"] = NewHSlider {
		x = w * 0.57, y = this.buttons.deadzone.y, 
		width = w * 0.25, height = 24, thumbwidth = 10, 
		texturebg = "slider_sound", texturefg = "slider_fg",
	}
	this.sliders.deadzone.tag = "deadzone"
	
	-- add radio buttons
	local radio_layout = {
		spacing = w * 0.125,
		font = "gamefont_tiny",
		strings = {"common.no", "common.yes"},
		x = w * 0.59,
	}
	radio_layout.callback = ifs_opt_pccontrols_fnInvertCB
	ifelem_AddRadioButtonGroup(this, radio_layout.x, this.buttons.invert.y - 7, radio_layout, "invert")
	radio_layout.callback = ifs_opt_pccontrols_fnTurnAssistCB
	ifelem_AddRadioButtonGroup(this, radio_layout.x, this.buttons.turnassist.y - 7, radio_layout, "turnassist")
	
-- 	this.Background = NewIFImage 
--	{
 --			ZPos = 255, 
 --			x = w/2,  --centered on the x
 --			y = h/2, -- inertUVs = 1,
 --			alpha = 10,
 --			localpos_l = -w/1.5, localpos_t = -h/1.5,
 --			localpos_r = w/1.5, localpos_b =  h/1.5,
--			texture = "opaque_black",
--			ColorR = 20, ColorG = 20, ColorB = 150, -- blue
 --	}

	--this.listbox.height = h - this.listbox.y/2 --hack i'm guessing the list box propagates centered, as its should be offscreen right now for a 8x6 but isnt
	ifs_opt_pckeyboard_listbox_layout.width = w - 50
	ifs_opt_pckeyboard_listbox_layout.showcount = math.floor(this.listbox.height / (ifs_opt_pckeyboard_listbox_layout.yHeight + ifs_opt_pckeyboard_listbox_layout.ySpacing)) - 1
	ListManager_fnInitList(this.listbox,ifs_opt_pckeyboard_listbox_layout)

	-- Move things around to solve bug 1863
	local MoveUpAmount = 25
	this.listbox.y = ifs_opt_pccontrols.listbox.y - MoveUpAmount
	this.bindTitle.y = this.bindTitle.y - MoveUpAmount
	--this.cancelbutton.y = this.cancelbutton.y - MoveUpAmount
	--this.resetbutton.y = this.resetbutton.y - MoveUpAmount
	--this.donebutton.y = this.donebutton.y - MoveUpAmount

	-- Add tabs to screen
	ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCOptionsTabsLayout, gPCControlsOptionsTabsLayout)
end



ifs_opt_pccontrols_fnBuildScreen(ifs_opt_pccontrols)
-- dump out of memory when done.
ifs_opt_pccontrols_fnBuildScreen = nil
vbutton_layout = nil

AddIFScreen(ifs_opt_pccontrols, "ifs_opt_pccontrols")
