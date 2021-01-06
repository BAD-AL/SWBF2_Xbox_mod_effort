--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Gamespy list of friends

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function GSFriends_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, y = layout.y - 10,
	}

	Temp.namefield = NewIFText{ 
--		x = 56, y = 0, -- space for icon to left of name
		x = 15, y = 0,
		textw = 220, halign = "left", 
		font = gsfriends_listbox_layout.font, nocreatebackground=1,
	}

	local IconSize = 0.9 * layout.height

-- 	Temp.StateIcon = NewIFImage{ 
-- 		x = 15, y = 6, texture = "lobby_icons", 
-- 		localpos_l = 0, localpos_t = 0, 
-- 		localpos_b = IconSize, localpos_r = IconSize,
-- 	} -- y-pos is to get it centered in bar

-- 	Temp.VoiceIcon = NewIFImage{ 
-- 		x = layout.width - 25 - IconSize, y = 6,
-- 		texture = "lobby_icons", 
-- 		localpos_l = 0, localpos_t = 0, 
-- 		localpos_b = IconSize, localpos_r = IconSize,
-- 	} -- y-pos is to get it centered in bar

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function GSFriends_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	-- If we need to zap the glyphcache, do so.
	if(gBlankListbox) then
		IFText_fnSetString(Dest.namefield,"")

	elseif (Data) then
		-- Have data. Apply it.
		IFText_fnSetString(Dest.namefield,Data.name)

		IFObj_fnSetColor(Dest.namefield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.namefield, fAlpha)
	end

	-- Show entry if Data != nil
	IFObj_fnSetVis(Dest,Data)
end

gsfriends_listbox_layout = {
	showcount = 6,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 26,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	font = gListboxItemFont,
	CreateFn = GSFriends_Listbox_CreateItem,
	PopulateFn = GSFriends_Listbox_PopulateItem,
}

gsfriends_listbox_contents = {
	-- Filled in from C++ now. NM 8/7/03
	-- Stubbed to show the string.format it wants.
--	{ indexstr = "1", namestr = "Alpha"},
--	{ indexstr = "2", namestr = "Bravo"},
}

gsfriends_vbutton_layout = {
	yTop = 10,
	ySpacing = 0,
	width = 460,
	font = gMenuButtonFont,
	buttonlist = {
-- 		{ tag = "INVITE", string = "ifs.mp.friends.invite" },
-- 		{ tag = "UNINVITE", string = "ifs.mp.friends.uninvite" },
-- 		{ tag = "ADD", string = "ifs.onlinelobby.addfriend" },
 		{ tag = "JOIN", string = "ifs.mp.friends.joingame" },
 		{ tag = "ACCEPT", string = "ifs.mp.friends.accept" },
 		{ tag = "DECLINE", string = "ifs.mp.friends.decline" },
-- 		{ tag = "NEVER", string = "ifs.mp.friends.never" },
-- 		{ tag = "YESINVITE", string = "ifs.mp.friends.yesinvite" },
-- 		{ tag = "NOINVITE", string = "ifs.mp.friends.noinvite" },
-- 		{ tag = "FEEDBACK", string = "ifs.mp.friends.feedback" },
		{ tag = "REMOVE", string = "ifs.mp.friends.remove" },
		{ tag = "BACK", string = "common.back" },
	},
	title = "ifs.mp.friends.title",
	-- rotY = 20,
}

-- Callbacks from the busy popup

-- Callback function when the virtual keyboard is done
function ifs_mpgs_friends_fnKeyboardDone()
--	print("ifs_mp_gameopts_fnKeyboardDone()")
	local this = ifs_mpgs_friends
	this.LastPasswordStr = ScriptCB_ununicode(ifs_vkeyboard.CurString)
	this.bPasswordJoinOnEnter = 1
	ScriptCB_PopScreen()
--	vkeyboard_specs.fnDone = nil -- clear our registration there
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_mpgs_friends_fnIsAcceptable()
--	print("ifs_mp_gameopts_fnIsAcceptable()")
	return 1,"" -- any value is acceptable for a password
end

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mpgs_joinpopup_fnCheckDone()
--	local this = ifs_mpgs_friends
	ScriptCB_UpdateQuickmatch() -- think...
		
	return ScriptCB_IsQuickmatchDone()
end

function ifs_mpgs_joinpopup_fnOnSuccess()
	local this = ifs_mpgs_friends

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	Popup_Busy:fnActivate(nil)

	if(ScriptCB_IsQuickmatchPassworded()) then
		if(gPlatformStr == "PC") then
			IFObj_fnSetVis(this.PassBox, 1) -- show it now...
			this.PassBox.passedit.bKeepsFocus = 1
			gCurEditbox = this.PassBox.passedit
			IFObj_fnSetVis( this.friend_buttons.accept_btn, nil )
			IFObj_fnSetVis( this.friend_buttons.decline_btn, nil )
			IFObj_fnSetVis( this.friend_buttons.join_btn, nil )
			IFObj_fnSetVis( this.friend_buttons.remove_btn, nil )
			IFObj_fnSetVis( this.infobox, nil )

		else
			ifs_vkeyboard.CurString = ScriptCB_tounicode("")
			ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
			vkeyboard_specs.bPasswordMode = 1
			
			IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
			vkeyboard_specs.fnDone = ifs_mpgs_friends_fnKeyboardDone
			vkeyboard_specs.fnIsOk = ifs_mpgs_friends_fnIsAcceptable
			
			local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
			vkeyboard_specs.MaxWidth = (w * 0.5)
			vkeyboard_specs.MaxLen = 16
			ifs_movietrans_PushScreen(ifs_vkeyboard)
		end
	else
		-- Game isn't passworded. Just join it.
		ScriptCB_LaunchQuickmatch()
		ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
	end
end

function ifs_mpgs_joinpopup_fnOnFail()
	print("Join failed")

	Popup_Busy:fnActivate(nil)
	Popup_YesNo.CurButton = "no" -- default
	Popup_YesNo.fnDone = ifs_xlive_main_fnAskCreateDone
	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo,"ifs.quickopti.nonefound")

	local this = ifs_mpgs_friends
	ifs_mpgs_friends_fnShowListbox(this,1,nil) -- back to listbox
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})


	-- If we were in a session, gotta rearrange screen stack.
	if(this.bWasInSession) then
		ScriptCB_PopScreen("ifs_mp_main") -- back to here
        ifs_movietrans_PushScreen(ifs_mpgs_friends)
		this.bWasInSession = nil
	end
end

-- User hit cancel. Do what they want.
function ifs_mpgs_joinpopup_fnOnCancel()
	local this = ifs_mpgs_friends

	-- Stop logging in.
	ScriptCB_CancelQuickmatch()

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	IFObj_fnSetVis(this.buttons, (gPlatformStr ~= "PC"))

	-- show friends list
	ifs_mpgs_friends_fnShowListbox(this,1)
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	AnimationMgr_AddAnimation(this.listbox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 0,})

	-- If we were in a session, gotta rearrange screen stack.
	if(this.bWasInSession) then
		ScriptCB_PopScreen("ifs_mp_main") -- back to here
        ifs_movietrans_PushScreen(ifs_mpgs_friends)
		this.bWasInSession = nil
	end

end

-- (Optional) prompting is done, join is committed. Start it.
function ifs_mpgs_fnStartJoin(this)
	if (ScriptCB_GetShellActive()) then
		ScriptCB_SetAmHost(nil)
		ScriptCB_SetDedicated(nil)
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)

		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
		AnimationMgr_AddAnimation(this.infobox,
															{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
		this.bShowListbox = 1

		ifs_mpgs_friends_fnShowListbox(this,1)
		ifs_mpgs_friends_fnShowListbox(this,nil)
		ifs_mpgs_friends_fnShowListbox(this,1)
		ifs_mpgs_friends_fnShowListbox(this,1,1)
		IFObj_fnSetVis(this.listbox, nil)

		Popup_Busy.fnCheckDone = ifs_mpgs_joinpopup_fnCheckDone
		Popup_Busy.fnOnSuccess = ifs_mpgs_joinpopup_fnOnSuccess
		Popup_Busy.fnOnFail = ifs_mpgs_joinpopup_fnOnFail
		Popup_Busy.fnOnCancel = ifs_mpgs_joinpopup_fnOnCancel
		Popup_Busy.fTimeout = 30 -- seconds
		IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
		Popup_Busy:fnActivate(1)
	else
		-- We're in a game. DoFriendAction will set things up to be
		-- completed on re-entering the shell, so help finish the job.
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
		ScriptCB_QuitToShell()
	end

end

-- Shows or hides buttons. If bShowListbox is true, it'll show the
-- listbox, else the buttons will be visible. If bImmediate is true,
-- it'll set them visible now, else it'll do a fancy fade.
function ifs_mpgs_friends_fnShowListbox(this,bShowListbox,bImmediate)
	bImmediate = 1

	IFObj_fnSetVis(this.listbox, bShowListbox and not gCurEditbox)
	IFObj_fnSetVis(this.buttons, not bShowListbox and (gPlatformStr ~= "PC"))

	-- Always store current state
	this.bShowListbox = bShowListbox
end

-- Callbacks from the "This will leave your current session" popup. If
-- bResult is true, user selected 'yes'
function ifs_mpgs_friends_fnAskedJoin(bResult)
	local this = ifs_mpgs_friends

	-- Always restore infobox
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	if(bResult) then
		-- Exit out of current game...
		ScriptCB_CancelLobby()
		-- and try to join new one
		ifs_mpgs_fnStartJoin(this)
	else
		-- User hit no. Put buttons back
		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
		IFObj_fnSetVis(this.buttons, (gPlatformStr ~= "PC"))
	end
end

-- Callbacks from the "Remove from friendslist" popup. If bResult is
-- true, user selected 'yes'
function ifs_mpgs_friends_fnAskedRemove(bResult)
	local this = ifs_mpgs_friends

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	if(bResult) then
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
		ifs_mpgs_friends_fnShowListbox(this,1,nil) -- back to listbox
		ScriptCB_UpdateFriends(this.bRecentMode)			
		if( gPlatformStr == "PC" ) then
			ifs_mpgs_friends_fnPCShowHideButton( this )
		end
	else
		-- User hit no. Put buttons back
		if(gPlatformStr ~= "PC") then
			local fAnimTime = 0.2
			AnimationMgr_AddAnimation(this.buttons,
																{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
			IFObj_fnSetVis(this.buttons, (gPlatformStr ~= "PC"))
		end
	end
end

-- Callbacks from the "never accept friends requests" popup. If
-- bResult is true, user selected 'yes'
function ifs_mpgs_friends_fnAskedNever(bResult)
	local this = ifs_mpgs_friends
	
	if(bResult) then
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
		ifs_mpgs_friends_fnShowListbox(this,1,nil) -- back to listbox
	else
		-- User hit no. Put buttons back
		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
		IFObj_fnSetVis(this.buttons, (gPlatformStr ~= "PC"))
	end
end

function ifs_mpgs_friends_fnPCShowHideButton( this )
	if( gPlatformStr ~= "PC" ) then
		return
	end

	IFObj_fnSetVis( this.friend_buttons.accept_btn, nil )
	IFObj_fnSetVis( this.friend_buttons.decline_btn, nil )
	IFObj_fnSetVis( this.friend_buttons.join_btn, nil )
	IFObj_fnSetVis( this.friend_buttons.remove_btn, nil )

	if(gCurEditbox or table.getn(friends_listbox_contents) == 0 ) then
		return
	end

--	print("PCShowHideButton. gCurEditBox is nil, so proceeding")
	
	-- Then, enable only the buttons the game says should be on
	local tButtonlist = ScriptCB_GetFriendActions( this.bRecentMode )
	for k,v in tButtonlist do
		--print( "friends action =", k )
		if( k ~= nil ) then
			if( k == this.friend_buttons.join_btn.tag ) then
				IFObj_fnSetVis( this.friend_buttons.join_btn, 1 )
			elseif( k == this.friend_buttons.remove_btn.tag ) then
				IFObj_fnSetVis( this.friend_buttons.remove_btn, 1 )
			elseif( k == this.friend_buttons.accept_btn.tag ) then
				IFObj_fnSetVis( this.friend_buttons.accept_btn, 1 )
			elseif( k == this.friend_buttons.decline_btn.tag ) then
				IFObj_fnSetVis( this.friend_buttons.decline_btn, 1 )
			end
		end
	end
	
end

local bNo_backPC = nil
local bBackDrop = 1
if( (gPlatformStr == "PC") and ScriptCB_IsInShell() ) then
	bNo_backPC = 1
	bBackDrop = nil
end

ifs_mpgs_friends = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	bDimBackdrop = bBackDrop,
	bg_texture = "iface_bg_1",
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bNohelptext_backPC = bNo_backPC,

	title = NewIFText {
		string = "ifs.mp.friends.title",
		font = "gamefont_large",
		y = 0,
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground=1,
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.16, -- top
	},

	Enter = function(this, bFwd)
		-- set pc profile & title version text
		if(gPlatformStr == "PC") then
			UpdatePCTitleText(this)
		end
		IFObj_fnSetVis( this.infobox, 1 ) -- on by default until something overrides
		IFObj_fnSetVis( this.listbox, 1 ) -- on by default until something overrides
		gCurEditbox = nil

		-- bring up tabs
		if(gPlatformStr == "PC") then
			IFObj_fnSetVis(this.PassBox, nil) -- until needed by join buddy's game

			if( ifs_main and ifs_main.option_mp ) then
				IFObj_fnSetVis( this.title, nil )
				ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_multi")	
				ifelem_tabmanager_SetSelected(this, gPCMultiPlayerTabsLayout, "_tab_friends", 1 )
				if( ScriptCB_IsLoggedIn() ) then
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", nil, 1 )
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", nil, 1 )
				else
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", 1, 1 )
					ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", 1, 1 )
				end
			else
				ifelem_tabmanager_SelectTabGroup( this, nil, nil, nil )
				HidePCTitleText(this)
			end
			
			if( ScriptCB_IsInShell() ) then
				-- set gamespy login name
				if( ScriptCB_IsLoggedIn() ) then
					IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.login_as" )
					local NickStr, EmailStr, PasswordStr, iSaveType, iPromptType = ScriptCB_GetGSProfileInfo()
					IFText_fnSetString( this.LoginAsText2, NickStr )
					IFObj_fnSetVis( this.LoginAsText2, 1 )
				else
					IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.notlogin" )
					IFObj_fnSetVis( this.LoginAsText2, nil )
				end								
			end
		end
		
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		if(this.bPasswordJoinOnEnter) then
			this.bPasswordJoinOnEnter = nil
			ScriptCB_LaunchQuickmatch(this.LastPasswordStr)
			ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
			return
		end

		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		gsfriends_listbox_layout.FirstShownIdx = 1
		gsfriends_listbox_layout.SelectedIdx = 1
		gsfriends_listbox_layout.CursorIdx = 1
		ScriptCB_BeginFriends(this.bRecentMode)
		ListManager_fnFillContents(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
		
		if( ScriptCB_IsLoggedIn() ) then
			IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
		else
			IFText_fnSetString(this.infobox.text, "ifs.mp.join.notlogin")
		end

		ifs_mpgs_friends_fnShowListbox(this,1,1)		

		if( gPlatformStr == "PC" ) then
			IFObj_fnSetVis( this.friend_buttons.join_btn, nil )
			IFObj_fnSetVis( this.friend_buttons.remove_btn, nil )	
			IFObj_fnSetVis( this.friend_buttons.accept_btn, nil )
			IFObj_fnSetVis( this.friend_buttons.decline_btn, nil )	
		end
		ifs_mpgs_friends_fnPCShowHideButton( this )
	end,

	Exit = function(this, bFwd)
		ScriptCB_CancelFriends(this.bRecentMode)
		gBlankListbox = 1
		ListManager_fnFillContents(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
		IFText_fnSetString(this.infobox.text,"")
		friends_listbox_contents = nil
		gBlankListbox = nil
	end,

	Input_Accept = function(this)
		if((gPlatformStr == "PC")) then
			if( ( gMouseListBox == this.listbox ) and gsfriends_listbox_layout.SelectedIdx ) then
				if( ( gsfriends_listbox_layout.CursorIdx > 0 ) and 
					( gsfriends_listbox_layout.CursorIdx <= table.getn(friends_listbox_contents) ) ) then
					gsfriends_listbox_layout.SelectedIdx = gsfriends_listbox_layout.CursorIdx
				end				
				--print( "gsfriends_listbox_layout.SelectedIdx = ", gsfriends_listbox_layout.SelectedIdx )
				IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
				ifs_mpgs_friends_fnPCShowHideButton( this )
			end

			if(this.CurButton == "_passok") then
				this.LastPasswordStr = IFEditbox_fnGetString(this.PassBox.passedit)
				ScriptCB_LaunchQuickmatch(this.LastPasswordStr)
				ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
				return
			end
		end

		-- If base class handled this work, then we're done
 		if(gShellScreen_fnDefaultInputAccept(this)) then
-- 			print(" exit as default handled")
-- 			return
 		end

		-- Don't do anything else if editbox is up
		if(gCurEditBox) then
			return
		end

		if((gPlatformStr == "PC")) then
			if( ifs_main and ifs_main.option_mp ) then
				if( ( ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout) or
					ifelem_tabmanager_HandleInputAccept(this, gPCMultiPlayerTabsLayout, 1) ) ) then
					return
				end
			end
		end

		if(table.getn(friends_listbox_contents) < 1) then
			return
		end

		local Selection = friends_listbox_contents[gsfriends_listbox_layout.SelectedIdx]

		if( this.bShowListbox and ( gPlatformStr ~= "PC" ) ) then
			-- Set hidden flag for all buttons
			local k,v
			for k,v in gsfriends_vbutton_layout.buttonlist do
				this.buttons[v.tag].hidden = 1
			end
			-- Then, enable only the buttons the game says should be on
			local tButtonlist = ScriptCB_GetFriendActions(this.bRecentMode)
			for k,v in tButtonlist do
--				print("k =",k)
				if((k ~= nil) and this.buttons[k]) then
					this.buttons[k].hidden = nil
				end
			end

			IFText_fnSetString(this.buttons._titlebar_,Selection.name)

			-- Update list of what's visible
			local NewButton = ShowHideVerticalButtons(this.buttons,gsfriends_vbutton_layout)
			SetCurButton(NewButton)
			ifs_mpgs_friends_fnShowListbox(this,nil,nil)
		elseif( Selection ) then
			-- On buttons. Do them.
			if(this.CurButton == "FEEDBACK") then
				ifs_mpgs_feedback.TargetName = Selection.name
				ifs_movietrans_PushScreen(ifs_mpgs_feedback)
			elseif ((this.CurButton == "REMOVE") or (this.CurButton == "NEVER") ) then
				-- These two are considered "Destructive" actions -- must ask
				-- for confirmation first

				Popup_YesNo.CurButton = "no" -- default

				local Key
				if( (this.CurButton == "REMOVE") ) then
					Popup_YesNo.fnDone = ifs_mpgs_friends_fnAskedRemove
					Key = "ifs.mp.friends.removeprompt"
				else
					Popup_YesNo.fnDone = ifs_mpgs_friends_fnAskedNever
					Key = "ifs.mp.friends.neverprompt"
				end
				
				local Selection = friends_listbox_contents[gsfriends_listbox_layout.SelectedIdx]
				local ShowUStr = ScriptCB_usprintf(Key,ScriptCB_tounicode(Selection.name))
				Popup_YesNo:fnActivate(1)
				gPopup_fnSetTitleUStr(Popup_YesNo,ShowUStr)

				local fAnimTime = 0.2
				AnimationMgr_AddAnimation(this.buttons,
																	{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
				AnimationMgr_AddAnimation(this.infobox,
																	{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})

			elseif( (this.CurButton == "JOIN") ) then
				-- Flow is different depending on whether we're in a session or
				-- not. Store flag for later
				this.bWasInSession = ScriptCB_InNetSession()
				if(this.bWasInSession) then
					-- Must prompt that this'll leave current session.
					Popup_YesNo.CurButton = "no" -- default
					Popup_YesNo.fnDone = ifs_mpgs_friends_fnAskedJoin
					Popup_YesNo:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_YesNo, "ifs.mp.friends.willexitsession")
					local fAnimTime = 0.2
					AnimationMgr_AddAnimation(this.buttons,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
					AnimationMgr_AddAnimation(this.infobox,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
				else
					-- Not in session. No prompt necessary
					ifs_mpgs_fnStartJoin(this)
				end
				-- end of "JOIN"
			else
					-- Simple action that can be done asap
				ScriptCB_DoFriendAction(this.CurButton, this.bRecentMode)
				ifs_mpgs_friends_fnShowListbox(this, 1, nil) -- back to listbox
			end

		end


	end,

	Input_KeyDown = function(this, iKey)
		if(gCurEditbox) then
			this.bKeyPressed = 1
			if((iKey == 10) or (iKey == 13)) then -- handle Enter different
				this.CurButton = "_passok"
				this:Input_Accept(1)

--				gCurEditbox = nil
			else
				IFEditbox_fnAddChar(gCurEditbox, iKey)
			end
		end

	end,


	Input_Back = function(this)
		if(this.bShowListbox) then
			if( (gPlatformStr == "PC") and ScriptCB_IsInShell() ) then			
				ScriptCB_PopScreen("ifs_main") -- default action
			else		
				ScriptCB_PopScreen()
			end
		else
			ScriptCB_SndPlaySound("shell_menu_exit")
			ifs_mpgs_friends_fnShowListbox(this,1,nil)
		end
	end,

	Input_GeneralUp = function(this)
		if(this.bShowListbox) then
			ListManager_fnNavUp(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
			IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			ifs_mpgs_friends_fnPCShowHideButton( this )
		else
			gDefault_Input_GeneralUp(this)
		end
	end,

	Input_GeneralDown = function(this)
		if(this.bShowListbox) then
			ListManager_fnNavDown(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
			IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			ifs_mpgs_friends_fnPCShowHideButton( this )
		else
			gDefault_Input_GeneralDown(this)
		end
	end,

	Input_LTrigger = function(this)
		if(this.bShowListbox) then
			ListManager_fnPageUp(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
			IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			ifs_mpgs_friends_fnPCShowHideButton( this )
		end
	end,

	Input_RTrigger = function(this)
		if(this.bShowListbox) then
			ListManager_fnPageDown(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
			IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			ifs_mpgs_friends_fnPCShowHideButton( this )
		end
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- Lobby might be active (if we entered thru it). Update it.
		ScriptCB_UpdateLobby(nil)

		-- print("Brad, call FriendsUpdate from here, do client/server switch in C")
		ScriptCB_UpdateFriends(this.bRecentMode)
		-- Fix for 14367 - constantly refresh buttons on the PC. 
		-- This is a little bit of overkill, but should be fast enough.
		if(gPlatformStr == "PC") then
			ifs_mpgs_friends_fnPCShowHideButton(this)
		end
		
		if( not ScriptCB_IsLoggedIn() ) then
			IFText_fnSetString(this.infobox.text, "ifs.mp.join.notlogin")
		end		
	end,

	-- Brad, call this function from C (with LuaScript::CallTableProcWThis() ) to
	-- refresh the listbox contents. The contents should be in the lua global
	-- gsfriends_listbox_contents
	RepaintListbox = function(this)
		ListManager_fnFillContents(this.listbox,friends_listbox_contents,gsfriends_listbox_layout)
		IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
	end,
}


-- Do programatic work to set up this screen
function ifs_mpgs_friends_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	-- add pc profile & title version text
	if(gPlatformStr == "PC") then
		AddPCTitleText( this )
	end
	
	local BoxW = w * 0.65
	gsfriends_listbox_layout.yHeight = ScriptCB_GetFontHeight(gsfriends_listbox_layout.font) + 5
	local BoxH = gsfriends_listbox_layout.showcount * (gsfriends_listbox_layout.yHeight + gsfriends_listbox_layout.ySpacing) + 30

	this.listbox = NewButtonWindow { ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		y = 50 + (BoxH * 0.5), -- enough to be under the title
		
		width = BoxW, height = BoxH,
	}
	gsfriends_listbox_layout.width = BoxW - 35	

	ListManager_fnInitList(this.listbox,gsfriends_listbox_layout)

	-- Also, do the box at the bottom of the screen
	local BoxW = w * 0.95
	local BoxH = 110

	this.infobox = NewButtonWindow { ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 1.0, -- bottom of screen
		y = -(40 + (BoxH * 0.5)),
		
		width = BoxW, height = BoxH,
	}

	this.infobox.text = NewIFText{
		y = BoxH * -0.5 - 5, valign = "vcenter", -- centered around parent
		textw= BoxW - 32, texth = BoxH,
		font = "gamefont_small",
--		string = "data here",
		nocreatebackground=1,
	}

	this.CurButton = AddVerticalButtons(this.buttons,gsfriends_vbutton_layout)

	if(gPlatformStr == "PC") then
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCMultiPlayerTabsLayout)
		
		-- add friends list button
		this.friend_buttons =	NewIFContainer
		{
			ScreenRelativeX = 0.5,
			ScreenRelativeY = 0,
			x = 0,
			y = 270,

			accept_btn = NewPCIFButton
			{
				y = 0,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "ACCEPT",
--				nocreatebackground=1,
			}, -- end of btn

			decline_btn = NewPCIFButton
			{
				y = 30,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "DECLINE",
--				nocreatebackground=1,
			}, -- end of btn
			
			join_btn = NewPCIFButton
			{
				y = 60,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "JOIN",
--				nocreatebackground=1,
			}, -- end of btn
			
			remove_btn = NewPCIFButton
			{
				y = 90,
				btnw = 250, -- made wider to fix 9173 - NM 8/25/04
				btnh = 10,
				font = "gamefont_small",
				halign = "hcenter",
				--bg_width = BackButtonW,
				--bg_xflipped = 1,
				tag = "REMOVE",
--				nocreatebackground=1,
			}, -- end of btn
		}
		this.friend_buttons.accept_btn.label.halign = "hcenter"
		this.friend_buttons.decline_btn.label.halign = "hcenter"
		this.friend_buttons.join_btn.label.halign = "hcenter"
		this.friend_buttons.remove_btn.label.halign = "hcenter"
		RoundIFButtonLabel_fnSetString( this.friend_buttons.accept_btn, "ifs.mp.friends.accept" )
		RoundIFButtonLabel_fnSetString( this.friend_buttons.decline_btn, "ifs.mp.friends.decline" )		
		RoundIFButtonLabel_fnSetString( this.friend_buttons.join_btn, "ifs.mp.friends.joingame" )
		RoundIFButtonLabel_fnSetString( this.friend_buttons.remove_btn, "ifs.mp.friends.remove" )
		
		if( ScriptCB_IsInShell() ) then
			-- add gamespy logo & login
			ifs_mp_sessionlist_fnAddGamespyLogin( this )		
		end

		local EditBoxW = 500
		local BackButtonW = 180
		local BackButtonH = ScriptCB_GetFontHeight("gamefont_medium")
		this.PassBox = NewIFContainer
		{
			ScreenRelativeX = 0.5, -- center
			ScreenRelativeY = 0.5, -- center

			title = NewIFText {
				string = "ifs.vkeyboard.title_password",
				font = "gamefont_large",
				y = -50,
				textw = EditBoxW,
				nocreatebackground = 1,
				halign = "left",
			},

			passedit = NewEditbox {
				width = EditBoxW,
				height = 40,
				font = "gamefont_medium",
				--		string = "Player 1",
				MaxLen = EditBoxW - 30,
				MaxChars = 31,
				bPasswordMode = 1,
			},

			passokbutton = NewPCIFButton {
				y = 35,
				btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
				btnh = BackButtonH,
				font = "gamefont_medium",
				tag = "_passok",
				string = "common.ok",
			},
			-- MUST enter password here.
-- 			passbackbutton = NewPCIFButton {
-- 				y = 35,
-- 				btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
-- 				btnh = BackButtonH,
-- 				font = "gamefont_medium",
-- 				tag = "_passback",
-- 				string = "common.cancel",
-- 			},

		}
		this.PassBox.passokbutton.x = (EditBoxW - BackButtonW - 16) * 0.5 
--		this.PassBox.passbackbutton.x = (EditBoxW - BackButtonW - 16) * -0.5
		this.PassBox.title.x = EditBoxW * -0.5

	end	
end

ifs_mpgs_friends_fnBuildScreen(ifs_mpgs_friends)
ifs_mpgs_friends_fnBuildScreen = nil

AddIFScreen(ifs_mpgs_friends,"ifs_mpgs_friends")
