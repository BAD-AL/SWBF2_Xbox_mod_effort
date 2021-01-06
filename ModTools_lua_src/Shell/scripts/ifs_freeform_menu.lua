--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Ingame pause menu

ifsfreeformmenu_vbutton_layout = {
	ySpacing = 5,
	width = 260,
	font = gMenuButtonFont,
	buttonlist = { 
		{ tag = "resume", string = "common.resume", },
		{ tag = "lobby", string = "game.pause.playerlist", },
		{ tag = "opts", string = "ifs.main.options", },
		{ tag = "cheat", string = "Cheat Menu", },
		{ tag = "friends", string = "ifs.onlinelobby.friendslist", },
		{ tag = "recent", string = "common.mp.recent", },
		{ tag = "save", string = "common.save", },
		{ tag = "load", string = "common.load", },
		{ tag = "quit", string = "common.quit", },
		{ tag = "exit", string = "common.quit2windows", },
	},
	title = "game.pause.title",
}

-- Turns pieces on/off as requested
function ifs_freeform_menu_fnSetPieceVis(this, bVis)
	IFObj_fnSetVis(this.buttons,bVis)
end

-- Callback for when the "really quit?" popup is over.  If bResult is
-- true, user wanted to quit
function ifs_freeform_menu_fnQuitPopupDone(bResult)
	local this = Popup_YesNo.calledFrom
	ifs_freeform_menu_fnSetPieceVis(this,1) -- always restore screen

	if(bResult) then
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		-- request a quit
		this.QuitRequested = true
		-- prompt to save (will push screen
		ifs_freeform_main:PromptSave(true)
	else
		ifelm_shellscreen_fnPlaySound(this.cancelSound)
	end
	Popup_YesNo.fnDone = nil
end

-- Callback for when the "really quit?" popup is over.  If bResult is
-- true, user wanted to quit
function ifs_freeform_menu_fnExitPopupDone(bResult)
	local this = Popup_YesNo.calledFrom
	ifs_freeform_menu_fnSetPieceVis(this,1) -- always restore screen

	if(bResult) then
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		ScriptCB_QuitToWindows()
	else
		ifelm_shellscreen_fnPlaySound(this.cancelSound)
	end
	Popup_YesNo.fnDone = nil
end

-- Function shared by instances: enter 
function ifs_freeform_menu_fnEnter(this, bFwd)
	if(this.buttons and this.buttons.FriendIcon) then
		local IconIdx = ScriptCB_GetFriendListIcon()
		local UVs = gXLFriendsEnum2UVs[IconIdx+1] -- lua counts from 1
		IFImage_fnSetUVs(this.buttons.FriendIcon,UVs.u,UVs.v,UVs.u+0.25,UVs.v+0.25)
	end
	gIFShellScreenTemplate_fnEnter(this, bFwd)

	-- if we're returning from the below, bail right back to the game
	if((not bFwd) and this.PopAfterPlayerList) then
		this.PopAfterPlayerList = nil
		ScriptCB_ResetSkipToPlayerList()
		ScriptCB_PopScreen()
		return
	end
	-- if we're in a net game and the user hits 'tab', jump right to the player list
	if(bFwd and ScriptCB_SkipToPlayerList() and ScriptCB_InNetGame()) then
		this.PopAfterPlayerList = 1
		ifs_movietrans_PushScreen(ifs_mp_lobby)
		return
	end
	-- if a quit was requested...
	if((not bFwd) and this.QuitRequested) then
		-- clear any campaign/metagame state
		ScriptCB_ClearCampaignState()
		ScriptCB_ClearMetagameState()
		ScriptCB_ClearMissionSetup()
		-- disable metagame rules
		ScriptCB_SetGameRules("instantaction")
		-- restart the shell (HACK)
		SetState("shell")
		return
	end

	this.PopAfterPlayerList = nil
	ScriptCB_ResetSkipToPlayerList()

	if(this.CurButton) then
		IFButton_fnSelect(this.buttons[this.CurButton],nil) -- Deactivate old button
	end

	-- Refresh which buttons are shown
	this.buttons.lobby.hidden = gDemoBuild or (not ScriptCB_InNetGame())
	
	this.buttons.exit.hidden = (gPlatformStr ~= "PC" or ScriptCB_InNetGame()) 

	local bShowFriends = ((gPlatformStr == "XBox") and (ScriptCB_XL_IsLoggedIn(1))) -- only visible if successfully signed in

	this.buttons.friends.hidden = not ScriptCB_IsLoggedIn()

	if(this.buttons.recent) then
		this.buttons.recent.hidden = not ((ScriptCB_InNetGame()) and (gOnlineServiceStr == "XLive"))
	end
	this.buttons.cheat.hidden = gDemoBuild or gFinalBuild

	if(ScriptCB_IsDedicated()) then
		--			this.buttons.lobby.hidden = 1 -- Disabled NM 7/22/04 - I think we need to show this
		this.buttons.opts.hidden = 1
	elseif (ScriptCB_IsSplitscreen()) then
		-- this.buttons.lobby.hidden    = 1
		this.buttons.exit.hidden     = 1
	end
	
	this.CurButton = ShowHideVerticalButtons(this.buttons,ifsfreeformmenu_vbutton_layout)

	if (bFwd) then
		ifelm_shellscreen_fnPlaySound(this.acceptSound)
	end

	SetCurButton(this.CurButton)

	-- Move friends icon if appropriate
	if(bShowFriends) then
		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.buttons.friends.label)
		local TextW = fRight - fLeft
		local XPos = fRight + 20
		local YPos = this.buttons.friends.y - 15
		IFObj_fnSetPos(this.buttons.FriendIcon,XPos,YPos)
	else
		IFObj_fnSetVis(this.buttons.FriendIcon, nil) -- just hide it.
	end
end

-- Function shared by instances: Input_Accept 
function ifs_freeform_menu_fnInput_Accept(this)
	-- If base class handled this work, then we're done
	if(gShellScreen_fnDefaultInputAccept(this)) then
		return
	end

	ifelm_shellscreen_fnPlaySound(this.acceptSound)

	if(this.CurButton == "resume") then
		ScriptCB_PopScreen()
	elseif (this.CurButton == "quit") then
		-- this hack
		ScriptCB_SetQuitPlayer(1)
		
		Popup_YesNo.calledFrom = this
		Popup_YesNo.CurButton = "no" -- default
		Popup_YesNo.fnDone = ifs_freeform_menu_fnQuitPopupDone
		Popup_YesNo:fnActivate(1)

		if(ScriptCB_GetAmHost()) then
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pause.warn_host_quit")
		else
			gPopup_fnSetTitleStr(Popup_YesNo, "ifs.pause.warn_quit")
		end
		ifs_freeform_menu_fnSetPieceVis(this, nil)
	elseif (this.CurButton == "exit") then
		Popup_YesNo.calledFrom = this
		Popup_YesNo.CurButton = "no" -- default
		Popup_YesNo.fnDone = ifs_freeform_menu_fnExitPopupDone
		ifs_freeform_menu_fnSetPieceVis(this, nil)
		Popup_YesNo:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_YesNo, "ifs.main.askquit")
	elseif (this.CurButton == "lobby") then
		ifs_movietrans_PushScreen(ifs_mp_lobby)
	elseif (this.CurButton == "opts") then
		if(gPlatformStr == "PC") then
			ifs_movietrans_PushScreen(ifs_opt_general)
		else
			ifs_movietrans_PushScreen(ifs_opt_top)
		end
	elseif (this.CurButton == "friends") then
		if(ScriptCB_GetOnlineService() == "XLive") then
			ifs_mpxl_friends.bRecentMode = nil
			ifs_movietrans_PushScreen(ifs_mpxl_friends)
		else
			ifs_movietrans_PushScreen(ifs_mpgs_friends)
		end
	elseif (this.CurButton == "recent") then
		ifelm_shellscreen_fnPlaySound("shell_menu_accept")    
		ifs_mpxl_friends.bRecentMode = 1
		ifs_movietrans_PushScreen(ifs_mpxl_friends)
	elseif (this.CurButton == "stats") then
		ifs_movietrans_PushScreen(ifs_teamstats)
	elseif (this.CurButton == "cheat") then
		ifs_freeform_cheat.main = ifs_freeform_main
		ifs_movietrans_PushScreen(ifs_freeform_cheat)
	elseif (this.CurButton == "load") then
		ifs_freeform_load.Mode = "Load"
		ifs_movietrans_PushScreen(ifs_freeform_load)
	elseif (this.CurButton == "save") then
		ifs_freeform_load.Mode = "Save"
		ifs_freeform_load.SkipPromptSave = 1
		ifs_movietrans_PushScreen(ifs_freeform_load)
	end
end

ifs_freeform_menu = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed
	bFriendsIcon = 1,
	bAcceptIsSelect = 1,
    bNohelptext_backPC = 1,

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
		--rotY = 25,
	},

	Enter = function(this, bFwd)
		ifs_freeform_menu_fnEnter(this,bFwd) -- Call function shared between instances
	end,

	Input_Accept = function(this, joystick)
		ifs_freeform_menu_fnInput_Accept(this) -- Call function shared between instances
	end,

	-- Override default behavior
	Input_Back = function(this, joystick)
		ifelm_shellscreen_fnPlaySound(this.exitSound)
		ScriptCB_PopScreen()
	end,
	
	Input_Start = function(this, joystick)
		this:Input_Back(joystick)
	end,
}

ifs_freeform_menu.Viewport = 0
ifs_freeform_menu.CurButton = AddVerticalButtons(ifs_freeform_menu.buttons,ifsfreeformmenu_vbutton_layout)
AddIFScreen(ifs_freeform_menu,"ifs_freeform_menu", 1)

ifs_freeform_menu = DoPostDelete(ifs_freeform_menu)

