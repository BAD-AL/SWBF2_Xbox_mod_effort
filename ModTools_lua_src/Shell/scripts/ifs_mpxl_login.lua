--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Functions for the XBox Live login screen

-- Special note: the passcode is built up as a string, which is then
-- passed to the game. As the passcode entries to XLive are effectively
-- control chars, this isn't really a printable string.

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_mpxl_login_listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y - 10,
	}
	Temp.NameStr = NewIFText{ 
		x = 10, y = 0, halign = "left", font = "gamefont_medium", 
		textw = layout.width,
		nocreatebackground = 1,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function ifs_mpxl_login_listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	if(Data) then
		-- Fill data
		IFText_fnSetUString(Dest.NameStr,Data.showstr)
--		IFText_fnSetString(Dest.NameStr,"WWWWWWWWWWWWWWM") -- space test
		IFObj_fnSetColor(Dest.NameStr, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.NameStr, fAlpha)
	else
		-- Blank the data
		IFText_fnSetString(Dest.NameStr,"")
	end

	IFObj_fnSetVis(Dest.NameStr,Data)
end

ifs_mpxl_login_listbox_contents = {
}

ifs_mpxl_login_listbox_layout = {
	showcount = 6,
	yHeight = 26,
	ySpacing  = 0,
	width = 280,
	x = 0,
	slider = 1,
	CreateFn = ifs_mpxl_login_listbox_CreateItem,
	PopulateFn = ifs_mpxl_login_listbox_PopulateItem,
}

-- Callbacks from the "Reboot to create an account" popup. If bResult
-- is true, they selected 'yes'
function ifs_xlive_fnRebootPopupDone(bResult)
	local this = ifs_mpxl_login
	if(bResult) then
		ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_NEW_ACCOUNT_SIGNUP");
	end

	-- Close off popup no matter what choice they made
	ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
end

-- Callbacks from the busy popup

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mpxl_login_fnCheckDone()
--	local this = ifs_mpxl_login
	return ScriptCB_IsLoginDone()
end

function ifs_mpxl_login_fnOnSuccess()
--	print("ifs_mpxl_login_fnOnSuccess()")
	local this = ifs_mpxl_login
	Popup_Busy:fnActivate(nil)
	-- Fixme! Go to XLive choice instead
	ifs_movietrans_PushScreen(ifs_mp_main)
end

function ifs_mpxl_login_fnOnFail()
--	print("ifs_mpxl_login_fnOnFail()")
	local this = ifs_mpxl_login
	Popup_Busy:fnActivate(nil)
--	print("Error in logging on!\n")
	ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
-- 	local ErrorLevel,ErrorMessage = ScriptCB_QueryNetError("login")
-- 	ScriptCB_OpenErrorBox(ErrorLevel,ErrorMessage)
end

-- User hit cancel. Do what they want.
function ifs_mpxl_login_fnOnCancel()
--	print("ifs_mpxl_login_fnOnCancel()")
	local this = ifs_mpxl_login

	-- Stop logging in.
	ScriptCB_CancelLogin()

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
end

-- Callback from "Bad passcode" dialog. Gets that dialog off screen
-- updates flow
function ifs_mpxl_login_fnBadPassDone()
	local this = ifs_mpxl_login

	this.CurPassword = ""
	this.bPasswordState = nil
	ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
end

function ifs_mpxl_login_fnAddToPasscode(this,iChar)
	if((this.bPasswordState) and (string.len(this.CurPassword) < 4)) then
		this.CurPassword = this.CurPassword .. string.char(iChar)
		ifs_mpxl_login_fnRepaintPassword(this)

		-- Recommended by QA, XBox Best Practices - when the passcode hits
		-- 4 buttons, auto-accept it
		if(string.len(this.CurPassword) == 4) then
			this:Input_Accept()
		end
	end -- len is sane, in mode to add
end

function ifs_mpxl_login_fnStartLogin(this)
	ScriptCB_XL_SelectProfileList()
	
	ifs_mpxl_login_fnSetPieceVis(this, nil, nil, nil) -- fade to blank for busy popup
	
	Popup_Busy.fnCheckDone = ifs_mpxl_login_fnCheckDone
	Popup_Busy.fnOnSuccess =  ifs_mpxl_login_fnOnSuccess
	Popup_Busy.fnOnFail =  ifs_mpxl_login_fnOnFail
	Popup_Busy.fnOnCancel =  ifs_mpxl_login_fnOnCancel
	Popup_Busy.bNoCancel = nil -- allow cancel button
	Popup_Busy.fTimeout = 60 -- seconds
	IFText_fnSetString(Popup_Busy.title,"common.mp.loggingin")
	Popup_Busy:fnActivate(1)

	-- Whine like crazy on login errors now
	ScriptCB_TrackLoginErrors(1)
	ScriptCB_StartLogin()
	this.bStartedLogin = 1
end

-- Sets the hilight on the listbox, create button given a hilight
function ifs_mpxl_login_SetHilight(this,aListIndex)
--	print("ifs_mpxl_login_SetHilight(this,",aListIndex)
	if(aListIndex) then
		-- Deactivate 'create' button, if applicable.
		if(gCurHiliteButton) then
			IFButton_fnSelect(gCurHiliteButton,nil) -- Deactivate old button
			gCurHiliteButton = nil
			this.CurButton = nil
		end
	else
		-- Not in listindex. Focus is on the create buttons
		this.CurButton = "new"
		gCurHiliteButton = this.buttons[this.CurButton]
		IFButton_fnSelect(gCurHiliteButton,1) -- Activate button
	end

	IFObj_fnSetVis(this.Helptext_Accept,1)

	ifs_mpxl_login_listbox_layout.SelectedIdx = aListIndex
	ifs_mpxl_login_listbox_layout.CursorIdx = aListIndex
	ListManager_fnFillContents(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
end

-- Helper function: turns pieces on/off as requested
function ifs_mpxl_login_fnSetPieceVis(this,bImmediate,bShowListbox,bShowPasscode)
	IFObj_fnSetVis(this.listbox,bShowListbox)
	IFObj_fnSetVis(this.buttons,bShowListbox)
	
	IFObj_fnSetVis(this.pwd_title,bShowPasscode)
	IFObj_fnSetVis(this.pwd_string,bShowPasscode)
	
	IFObj_fnSetVis(this.Helptext_Accept,bShowListbox or bShowPasscode)
	
	if(bShowListbox) then
		ifs_mpxl_login_fnRepaintListbox(this)
	end
	
	-- Store latest state
	this.bShowListbox = bShowListbox
	this.bShowPasscode = bShowPasscode
end


-- Repaints the password string
function ifs_mpxl_login_fnRepaintPassword(this)
	local i
	local ShowStr = ""
	for i=1,string.len(this.CurPassword) do
		ShowStr = ShowStr .. "#"
	end
	IFText_fnSetString(this.pwd_string,ShowStr)
end

function ifs_mpxl_login_fnRepaintListbox(this)
	-- Reset listbox, show it. [Remember, Lua starts at 1!]
	local ListCount = table.getn(ifs_mpxl_login_listbox_contents)

	ifs_mpxl_login_listbox_layout.FirstShownIdx = 1 -- top
	if(ListCount > 0) then
		-- Auto-select first item
		ifs_mpxl_login_SetHilight(this,1)
	else
		-- Auto-select 'create' button
		ifs_mpxl_login_SetHilight(this,nil)
	end
	ListManager_fnFillContents(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
end

-- The login profile list has changed. Must update things
function ifs_mpxl_login_fnProfileListChanged(this)
--	print(" ** Top of MPXL ProfileListChanged")		
	this.EverLoaded = 1
	if(this.bShowListOnUpdate) then
		ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
		this.bShowListOnUpdate = nil
	end

	local ListCount = table.getn(ifs_mpxl_login_listbox_contents)
--	print(" ** MPXL ProfileListChanged, ListCount = ",ListCount)
	if((ListCount < 1) or (not ifs_mpxl_login_listbox_layout.SelectedIdx)) then
--		print(" ** MPXL ProfileListChanged, Path 1")
		ifs_mpxl_login_fnRepaintListbox(this)
	else
--		print(" ** MPXL ProfileListChanged, Path 2")
		if (ifs_mpxl_login_listbox_layout.SelectedIdx > ListCount) then
			ifs_mpxl_login_listbox_layout.FirstShownIdx = 1 -- back to top
			ifs_mpxl_login_listbox_layout.SelectedIdx = 1
			ifs_mpxl_login_listbox_layout.CursorIdx = 1
		end

		ListManager_fnFillContents(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
		ifs_mpxl_login_SetHilight(this,1)
	end

--	print(" ** Bot of MPXL ProfileListChanged")		
end

ifs_mpxl_login = NewIFShellScreen {
	bAcceptIsSelect = 1,

--  	title = NewIFText {
--  		string = "ifs.pickacct.account",
--  		font = "gamefont_large",
--  		textw = 460,
--  		y = 30,
--  		ScreenRelativeX = 0.5, -- center
--  		ScreenRelativeY = 0, -- top
-- 	},

	movieIntro      = nil,
	movieBackground = nil,
	bg_texture = "iface_bgmeta_space",

	pwd_title = NewIFText {
--		string = "ifs.pickacct.enterpass",
		font = "gamefont_large",
		textw = 460,
		texth = 70,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.33,
		nocreatebackground = 1,
		valign = "vcenter",
 	},

	pwd_string = NewIFText {
--		string = "ifs.pickacct.enterpass",
		font = "gamefont_large",
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		nocreatebackground = 1,
		valign = "vcenter",
 	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		y = 90,
	},

	listbox = NewButtonWindow { 
		ZPos = 200, x=0, y = 40,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- middle of screen
		width = ifs_mpxl_login_listbox_layout.width + 35,
		height = ifs_mpxl_login_listbox_layout.showcount * (ifs_mpxl_login_listbox_layout.yHeight + ifs_mpxl_login_listbox_layout.ySpacing) + 30
	},

	bStartedList = nil,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- Call base class

--		print(" ** Top of MPXL Login : Enter()")

		ScriptCB_SetNoticeNoCable(nil)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 7) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		this.iPrimaryPort = ScriptCB_GetPrimaryController() + 1
		this.iSecondaryPort = nil -- force it to be requested from game
		if(bFwd) then
			this.iPrimaryIdx = 1
		end

		this.bStartedList = nil			
		ifs_mpxl_login_fnSetPieceVis(this, 1, 1, nil) -- immediatly go to listbox/buttons
		this.bPasswordState = nil
		if(bFwd) then
			ScriptCB_XL_StartProfileList()
			this.bStartedList = 1
		end

--		print(" ** Mid of MPXL Login : Enter()")

		local bMultipleUsers = nil
		-- Function test added NM 6/15/05. Remove after about a week.
		if(ScriptCB_GetSecondaryController) then
			if(ScriptCB_GetSecondaryController()) then
				bMultipleUsers = 1
				ScriptCB_ReadAllControllers(1) -- note we need this mode on this screen
			end
		end

		if(bFwd and ScriptCB_InNetGame()) then
			ifs_movietrans_PushScreen(ifs_mp_main)
		elseif (bFwd and ScriptCB_XL_IsLoggedIn(1) and (not bMultipleUsers)) then
			ifs_movietrans_PushScreen(ifs_mp_main)
		else
			-- Hide items by default on entry

			this.bShowListOnUpdate = 1
		end

		-- Go back another screen if still logged in
		if ((not bFwd) and ScriptCB_XL_IsLoggedIn()) then
			ScriptCB_PopScreen()
		end

--		print(" ** Bottom of MPXL Login : Enter()")		
	end,

 	Exit = function(this, bFwd)
		ScriptCB_ReadAllControllers(nil) -- turn off once we're done with this screen
 		if(bFwd) then 			-- Going to a subscreen

			-- Whine like crazy
			ScriptCB_SetNoticeNoCable(1)

			-- No longer need to monitor changes to this
			if (this.bStartedList) then
				ScriptCB_XL_EndProfileList()
			end
			-- Whine like crazy on login errors now (might have done this already, no
			-- big deal)
			ScriptCB_TrackLoginErrors(1)
		else
			-- Backing out to parent screen. Shutdown XLive stuff
			this.bStartedLogin = nil

			-- Silently fail on login errors on non-MP pages
			ScriptCB_TrackLoginErrors(nil)

			ScriptCB_XL_CancelProfileList()
			-- Always reset NetLoginName to what was in profile, as we might
			-- have changed it to the selected user's gamertag as part of a
			-- login
			--local Selection = ifs_login_listbox_contents[ifs_login_listbox_layout.SelectedIdx]
			--ScriptCB_SetNetLoginName(Selection.showstr)
			ScriptCB_SetNetLoginName(ScriptCB_GetCurrentProfileName())
		end
	end,

	-- XBox TCRs require rechecking this at least once a second. So,
	-- [re]check every 1/2 of a second.
	fRecheckTimer = 0.5,
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		this.fRecheckTimer = this.fRecheckTimer - fDt
		if(this.fRecheckTimer < 0.0) then
			this.fRecheckTimer = 0.5

			ScriptCB_XL_UpdateProfileList()
		end
	end,
	
	Input_GeneralUp = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if(not this.bPasswordState) then
			if(gCurHiliteButton) then
				-- On button. See if we need to go to the list.
				local ListCount = table.getn(ifs_mpxl_login_listbox_contents)
				if(ListCount > 0) then
					ifs_mpxl_login_listbox_layout.FirstShownIdx = math.max(ListCount + 1 - ifs_mpxl_login_listbox_layout.showcount,1)

					ifs_mpxl_login_SetHilight(this,ListCount)
					ScriptCB_SndPlaySound("shell_select_change")
				end
			else
				-- In listbox.
				if(ifs_mpxl_login_listbox_layout.SelectedIdx < 2) then
					-- Move off listbox to button
					ifs_mpxl_login_SetHilight(this,nil)
					ScriptCB_SndPlaySound("shell_select_change")
				else
					-- In middle of list. Nav in it
					ListManager_fnNavUp(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
				end
			end
		end -- not in password state
  end,

	Input_LTrigger = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

    if(not gCurHiliteButton) then
			ListManager_fnPageUp(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
		end
	end,

	Input_GeneralDown = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if(not this.bPasswordState) then
			local ListCount = table.getn(ifs_mpxl_login_listbox_contents)
			if(gCurHiliteButton) then
				-- On button. See if we need to go to the list.
				if(ListCount > 0) then
					-- Move off button to listbox, first entry
					ifs_mpxl_login_listbox_layout.FirstShownIdx = 1 -- snap to top (if not already there)
					ifs_mpxl_login_SetHilight(this,1)
					ScriptCB_SndPlaySound("shell_select_change")
				end
			else
				-- In listbox.
				if(ifs_mpxl_login_listbox_layout.SelectedIdx >= ListCount) then
					-- Move off bottom of listbox to button
					ifs_mpxl_login_SetHilight(this,nil)
					ScriptCB_SndPlaySound("shell_select_change")
				else
					-- In middle of list. Nav.
					ListManager_fnNavDown(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
				end
			end
		end -- not in password state
  end,

	Input_RTrigger = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

    if(not gCurHiliteButton) then
			ListManager_fnPageDown(this.listbox,ifs_mpxl_login_listbox_contents,ifs_mpxl_login_listbox_layout)
		end
	end,

	-- Not possible on this screen
	Input_GeneralLeft = function(this)
  end,
	Input_GeneralRight = function(this)
  end,

	Input_Accept = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

--		print("In MPXL Input_Accept CurButton = ",this.CurButton)
		-- This should acquire network resources if the net cable hasn't
		-- previously been in - NM 8/1/04
		ScriptCB_IsNetCableIn()
		if(this.CurButton == "new") then
			-- Must prompt before going to dashboard

			Popup_YesNo.CurButton = "no" -- default
			Popup_YesNo.fnDone = ifs_xlive_fnRebootPopupDone
			ifs_mpxl_login_fnSetPieceVis(this, nil, nil, nil) -- fade to nothing
			ScriptCB_SndPlaySound("shell_menu_enter")
			Popup_YesNo:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_YesNo,"ifs.pickacct.promptcreate")
		else
			if(ScriptCB_IsProfilePassworded()) then
				if(this.bPasswordState) then
					this.bPasswordState = nil -- clear this.
					if(ScriptCB_CheckProfilePassword(this.CurPassword)) then
						ifs_mpxl_login_fnStartLogin(this)
					else
						-- Password error
						ifs_mpxl_login_fnSetPieceVis(this, nil, nil, nil) -- fade to nothing
						Popup_Ok.fnDone = ifs_mpxl_login_fnBadPassDone
						Popup_Ok:fnActivate(1)
						gPopup_fnSetTitleStr(Popup_Ok,"ifs.pickacct.badpasscode")
					end
				else
					this.CurPassword = ""
					ifs_mpxl_login_fnRepaintPassword(this)

					local Selection = ifs_mpxl_login_listbox_contents[ifs_mpxl_login_listbox_layout.SelectedIdx]

					local ShowUStr = ScriptCB_usprintf("ifs.pickacct.enterpass",Selection.showstr)
					IFText_fnSetUString(this.pwd_title,ShowUStr)
					ifs_mpxl_login_fnSetPieceVis(this, nil, nil, 1) -- fade to pwd state
					this.bPasswordState = 1
				end
			else
				-- No pwd. Go forward
				ifs_mpxl_login_fnStartLogin(this)
			end
		end
	end,

	Input_Back = function(this, iJoystick)
		-- Translate joystick, early-exit if it's out of range
		iJoystick = ifs_split2_profile_fnTranslateJoystick(this, iJoystick)
		if(not iJoystick) then
			return
		end

		if(this.bPasswordState) then
			this.bPasswordState = nil
			this.CurPassword = ""
			ifs_mpxl_login_fnSetPieceVis(this, nil, 1, nil) -- fade to listbox/buttons
		else
			ScriptCB_PopScreen() -- default action
		end
	end,

	-- Passcode nonsense. From xonline.h:
--     XONLINE_PASSCODE_DPAD_UP = 1,
--     XONLINE_PASSCODE_DPAD_DOWN,
--     XONLINE_PASSCODE_DPAD_LEFT,
--     XONLINE_PASSCODE_DPAD_RIGHT,
--     XONLINE_PASSCODE_GAMEPAD_X,
--     XONLINE_PASSCODE_GAMEPAD_Y,
--     XONLINE_PASSCODE_GAMEPAD_LEFT_TRIGGER = 9,
--     XONLINE_PASSCODE_GAMEPAD_RIGHT_TRIGGER

	Input_DPadUp = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,1)
	end,
	Input_DPadDown = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,2)
	end,
	Input_DPadLeft = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,3)
	end,
	Input_DPadRight = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,4)
	end,
	Input_Misc = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,5)
	end,
	Input_Misc2 = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,6)
	end,
	Input_LTrigger = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,9)
	end,
	Input_RTrigger = function(this)
		ifs_mpxl_login_fnAddToPasscode(this,10)
	end,

	-- Override default handler.
 	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
 		print("MPXL Login fnPostError(..,",bUserHitYes,ErrorLevel)
		if((this.bStartedLogin) and (ErrorLevel > 5)) then
			ScriptCB_ClearError()
			ScriptCB_CancelLogin()
			this.bStartedLogin = nil
		end

		--  		if(ErrorLevel >= 6) then
		--  			ScriptCB_PopScreen()
		--  		end
		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end
 	end,

	-- Pull in utility functions (called from C)
	fnUpdateProfileList = ifs_mpxl_login_fnProfileListChanged,

}

local ifsxlive_login_vbutton_layout = {
	bNoDefaultSizing = 1, 
	yTop = 40,
	yHeight = 50,
	ySpacing  = 5,
	width = 260,
	flashy = 0,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "new", string = "ifs.profile.create", },
	},
}

function ifs_mpxl_login_fnBuildScreen(this)
	-- Ask game for screen size, use for values
	local r
	local b
	local v
	r,b,v=ScriptCB_GetSafeScreenInfo()

	local i
	for i=1,2 do
		local PaneTL_X,PaneTL_Y -- Top-left X,Y of this pane, relative to WHOLE SCREEN
		local PaneW,PaneH -- Width, height of this pane
		local InsetL = 0
		local InsetR = 0

		-- Determine TL positions of everything
		PaneW = r
		PaneH = b * 0.5
		PaneTL_X = 0
		PaneTL_Y = (i-1) * PaneH

		-- All the internal groups are centered onscreen. Move TL position
		-- to be pinned to the right place
		PaneTL_X = PaneTL_X + r * -0.5
		PaneTL_Y = PaneTL_Y + b * -0.5



	end -- i loop over panes

	this.CurButton = AddVerticalButtons(this.buttons,ifsxlive_login_vbutton_layout)
	ListManager_fnInitList(this.listbox,ifs_mpxl_login_listbox_layout)

	this.horizline = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		texture = "gray_rect", 
		alpha = 0.8,
		localpos_l = -(r * 0.5 + 200), localpos_t = -2, 
		localpos_r =  (r * 0.5 + 200), localpos_b =  2,
		inert = 1,
		ColorR = 192, ColorG = 192, ColorB = 255,		
	}
end

ifs_mpxl_login_fnBuildScreen(ifs_mpxl_login)
ifs_mpxl_login_fnBuildScreen = nil -- clear from memory

AddIFScreen(ifs_mpxl_login,"ifs_mpxl_login")
