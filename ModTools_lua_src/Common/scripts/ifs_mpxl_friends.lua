--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- XBox Live list of friends

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function XLFriends_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width,
		y=layout.y - 10,
		bInertPos = 1,
	}
--	Temp.indexfield = NewIFText{ x = 10, y = 0, halign = "left", font = "gamefont_medium", nocreatebackground=1,}
	Temp.namefield = NewIFText{ 
		x = 56, y = 2, textw = layout.width - 56, halign = "left", 
		font = xlfriends_listbox_layout.font, nocreatebackground=1,
		bInertPos = 1,
		inert_all = 1,
	}

	local IconSize = 0.8 * layout.height

	Temp.StateIcon = NewIFImage{ x = 15, y = 3, texture = "lobby_icons", 
		localpos_l = 0, localpos_t = -2, 
		localpos_b = IconSize - 2, localpos_r = IconSize,
		bInertPos = 1,
		inert_all = 1,
	} -- y-pos is to get it centered in bar

	Temp.VoiceIcon = NewIFImage{ 
		x = layout.width - 25 - IconSize, y = 3,
		texture = "lobby_icons", 
		localpos_l = 0, localpos_t = -2, 
		localpos_b = IconSize - 2, localpos_r = IconSize,
		bInertPos = 1,
		inert_all = 1,
	} -- y-pos is to get it centered in bar

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function XLFriends_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)
	-- If we need to zap the glyphcache, do so.
	if(gBlankListbox) then
		IFText_fnSetString(Dest.namefield,"")

	elseif (Data) then
		-- Have data. Apply it.
		IFText_fnSetString(Dest.namefield,Data.name)

		IFObj_fnSetColor(Dest.namefield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.namefield, fAlpha)

--		IFText_fnSetString(Dest.namefield,"WWWWWWWWWWWWWWM") -- space test
		local UVs = gXLFriendsEnum2UVs[Data.StateIcon+1] -- lua counts from 1
		IFImage_fnSetUVs(Dest.StateIcon,UVs.u,UVs.v,UVs.u+0.25,UVs.v+0.25)
		
		UVs = gXLFriendsEnum2UVs[Data.VoiceIcon+1] -- lua counts from 1
		IFImage_fnSetUVs(Dest.VoiceIcon,UVs.u,UVs.v,UVs.u+0.25,UVs.v+0.25)
	end

	-- Show entry if Data != nil
	IFObj_fnSetVis(Dest,Data)
end

xlfriends_listbox_layout = {
	showcount = 6,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 26,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	font = gListboxItemFont,
	CreateFn = XLFriends_Listbox_CreateItem,
	PopulateFn = XLFriends_Listbox_PopulateItem,
}

friends_listbox_contents = {
	-- Filled in from C++ now. NM 8/7/03
	-- Stubbed to show the string.format it wants.
--	{ indexstr = "1", namestr = "Alpha"},
--	{ indexstr = "2", namestr = "Bravo"},
}

xlfriends_vbutton_layout = {
	yTop = 10, -- force it to grow down.
	ySpacing = 5,
	width = 510,
	font = gMenuButtonFont,
	buttonlist = {
		{ tag = "INVITE", string = "ifs.mp.friends.invite" },
		{ tag = "INVITEVOICE", string = "ifs.mp.friends.invitevoice", font = "gamefont_small" , yAdd = 8},
		{ tag = "UNINVITE", string = "ifs.mp.friends.uninvite" },
		{ tag = "ADD", string = "ifs.onlinelobby.addfriend" },
		{ tag = "ADDVOICE", string = "ifs.onlinelobby.addfriendvoice", font = "gamefont_small" , yAdd = 8},
		{ tag = "JOIN", string = "ifs.mp.friends.joingame" },
		{ tag = "ACCEPT", string = "ifs.mp.friends.accept" },
		{ tag = "DECLINE", string = "ifs.mp.friends.decline" },
		{ tag = "NEVER", string = "ifs.mp.friends.never", font = "gamefont_small", yAdd = 8 }, -- smaller font as this is a HUGE string
		{ tag = "VOICEMAIL", string = "ifs.xvoicemail.play" },
		{ tag = "YESINVITE", string = "ifs.mp.friends.yesinvite" },
		{ tag = "NOINVITE", string = "ifs.mp.friends.noinvite" },
		{ tag = "FEEDBACK", string = "ifs.mp.friends.feedback" },
		{ tag = "REMOVE", string = "ifs.mp.friends.remove" },
		{ tag = "BACK", string = "common.back" },
	},
	title = "ifs.mp.friends.title",
--	rotY = 20,
}

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mpxl_voicemail_fnCheckDone()
--	local this = ifs_mpxl_friends
	ScriptCB_UpdateVoicemailDownload() -- think...
	return ScriptCB_IsVoicemailDownloaded()
end

function ifs_mpxl_voicemail_fnOnSuccess()
	local this = ifs_mpxl_friends

	ScriptCB_XL_DownloadVoicemail(nil)
	Popup_Busy:fnActivate(nil)

	IFObj_fnSetVis(this.infobox, 1)
	this.buttons.VOICEMAIL.hidden = nil
	local NewButton = ShowHideVerticalButtons(this.buttons,xlfriends_vbutton_layout)
	SetCurButton(NewButton)
	ifs_mpxl_friends_fnShowListbox(this,nil,1)
end

function ifs_mpxl_voicemail_fnOnFail()
	local this = ifs_mpxl_friends

	ScriptCB_XL_DownloadVoicemail(nil)
	Popup_Busy:fnActivate(nil)
	IFObj_fnSetVis(this.infobox, 1)

	this.buttons.VOICEMAIL.hidden = 1
	local NewButton = ShowHideVerticalButtons(this.buttons,xlfriends_vbutton_layout)
	SetCurButton(NewButton)
	ifs_mpxl_friends_fnShowListbox(this,nil,1)
end

-- User hit cancel. Do what they want.
function ifs_mpxl_voicemail_fnOnCancel()
	local this = ifs_mpxl_friends

	ScriptCB_XL_DownloadVoicemail(nil)
	Popup_Busy:fnActivate(nil)
	IFObj_fnSetVis(this.infobox, 1)

	this.buttons.VOICEMAIL.hidden = 1
	local NewButton = ShowHideVerticalButtons(this.buttons,xlfriends_vbutton_layout)
	SetCurButton(NewButton)
	ifs_mpxl_friends_fnShowListbox(this,nil,1)
end


-- Callbacks from the busy popup

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mpxl_joinpopup_fnCheckDone()
--	local this = ifs_mpxl_friends
	ScriptCB_UpdateQuickmatch() -- think...
		
	return ScriptCB_IsQuickmatchDone()
end

function ifs_mpxl_joinpopup_fnOnSuccess()
	local this = ifs_mpxl_friends

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	Popup_Busy:fnActivate(nil)
	ScriptCB_LaunchQuickmatch()
	ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
end

function ifs_mpxl_fnPostOKPopup()

	local this = ifs_mpxl_friends
	ifs_mpxl_friends_fnShowListbox(this,1,nil) -- back to listbox

	this.bShowListbox = 1
	
	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,nil)
	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,1,1)
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
end

-- Helper function for bug 11051 - must restore entry connect type if
-- join fails.  This function backs up the config, sets it to XLive.
function ifs_mpxl_friends_fnBackupOnlineService()
	local this = ifs_mpxl_friends
	if(not this.PreJoinService) then
		this.PreJoinService = ScriptCB_GetConnectType()
		ScriptCB_SetConnectType("wan")
		gOnlineServiceStr = ScriptCB_GetConnectType()
	end
end

-- Helper function for bug 11051 - must restore entry connect type if join fails.
function ifs_mpxl_friends_fnRestoreOnlineService()
	local this = ifs_mpxl_friends
	if(this.PreJoinService) then
		if(this.PreJoinService == "LAN") then
			ScriptCB_SetConnectType("lan")
		else
			ScriptCB_SetConnectType("wan")
		end

		gOnlineServiceStr = ScriptCB_GetConnectType()
		this.PreJoinService = nil
	end
end

function ifs_mpxl_joinpopup_fnOnFail()
	print("mpxl_joinpopup failed")
	local this = ifs_mpxl_friends

	-- Fix for 11051 - must restore entry connect type if join fails.
	ifs_mpxl_friends_fnRestoreOnlineService()

	Popup_Busy:fnActivate(nil)
--	Popup_Ok_Large.CurButton = "no" -- default
	Popup_Ok_Large.fnDone = ifs_mpxl_fnPostOKPopup
	Popup_Ok_Large:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_Ok_Large, "xlive.errors.sessionnotavailable")

end

-- User hit cancel. Do what they want.
function ifs_mpxl_joinpopup_fnOnCancel()
	print("mpxl_joinpopup canceled")
	local this = ifs_mpxl_friends

	-- Fix for 11051 - must restore entry connect type if join fails.
	ifs_mpxl_friends_fnRestoreOnlineService()

	-- Stop logging in.
	ScriptCB_CancelQuickmatch()

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	IFObj_fnSetVis(this.buttons, 1)

	this.bShowListbox = 1
	
	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,nil)
	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,1,1)

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
end

-- User input on the "Insert disc for game X" dialog. The only input
-- possible is 'cancel', so put us back in that state
function ifs_mpxl_friends_RebootNotCanceled(bResult)
	local this = ifs_mpxl_friends

	-- Get rid of popup, turn this screen back on
	IFObj_fnSetVis(this.buttons, 1)

	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,nil)
	ifs_mpxl_friends_fnShowListbox(this,1)
	ifs_mpxl_friends_fnShowListbox(this,1,1)
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	AnimationMgr_AddAnimation(this.listbox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	-- Restore button label in dialog
	RoundIFButtonLabel_fnSetString(Popup_Ok.buttons.ok,"common.ok")

	Popup_YesNo.fnDone = nil
end

-- (Optional) prompting is done, join is committed. Start it.  This is
-- used for both "JOIN" and "YESINVITE" - this.CurButton has which one
-- is actually in use.
function ifs_mpxl_fnStartJoin(this)

	if(not this.bInSameTitle) then
		-- Let the other guy know we want to join in case this was an invite
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)

		-- Must put up dialog box asking for that other title.
		Popup_Ok.fnDone = ifs_mpxl_friends_RebootNotCanceled
		local ShowUStr = ScriptCB_usprintf("ifs.mp.friends.gimmedisc",this.RemoteTitleUStr)
		RoundIFButtonLabel_fnSetString(Popup_Ok.buttons.ok,"common.cancel")
		Popup_Ok:fnActivate(1)
		gPopup_fnSetTitleUStr(Popup_Ok,ShowUStr)

		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.infobox,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 0,})

	elseif (ScriptCB_GetShellActive() and (not this.bInGCROTE)) then
		ScriptCB_SetAmHost(nil)
		ScriptCB_SetDedicated(nil)
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)

		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
		AnimationMgr_AddAnimation(this.infobox,
															{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
		this.bShowListbox = 1

		ifs_mpxl_friends_fnShowListbox(this,1)
		ifs_mpxl_friends_fnShowListbox(this,nil)
		ifs_mpxl_friends_fnShowListbox(this,1)
		ifs_mpxl_friends_fnShowListbox(this,1,1)
		IFObj_fnSetVis(this.listbox, nil)

		Popup_Busy.fnCheckDone = ifs_mpxl_joinpopup_fnCheckDone
		Popup_Busy.fnOnSuccess = ifs_mpxl_joinpopup_fnOnSuccess
		Popup_Busy.fnOnFail = ifs_mpxl_joinpopup_fnOnFail
		Popup_Busy.fnOnCancel = ifs_mpxl_joinpopup_fnOnCancel
		Popup_Busy.fTimeout = 30 -- seconds
		IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
		Popup_Busy:fnActivate(1)
	else
		-- We're in a game. DoFriendAction will set things up to be
		-- completed on re-entering the shell, so help finish the job.
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)

		-- clear any campaign/metagame state
		ScriptCB_ClearCampaignState()
		ScriptCB_ClearMetagameState()
		ScriptCB_ClearMissionSetup()
		-- disable metagame rules
		ScriptCB_SetGameRules("instantaction")

		if(this.bInGCROTE) then
			-- restart the shell (HACK)
			SetState("shell")
		else
			ScriptCB_QuitToShell()
		end
	end
end

-- Shows or hides buttons. If bShowListbox is true, it'll show the
-- listbox, else the buttons will be visible. If bImmediate is true,
-- it'll set them visible now, else it'll do a fancy fade.
function ifs_mpxl_friends_fnShowListbox(this,bShowListbox,bImmediate)

	IFObj_fnSetVis(this.listbox, bShowListbox)
	IFObj_fnSetAlpha(this.listbox, 1)
	IFObj_fnSetVis(this.title, bShowListbox)
	IFObj_fnSetAlpha(this.title, 1)
	IFObj_fnSetVis(this.buttons, not bShowListbox)
	IFObj_fnSetAlpha(this.buttons, 1)

	-- Always store current state
	this.bShowListbox = bShowListbox
end

-- Callbacks from the "This will leave your current session" popup. If
-- bResult is true, user selected 'yes'
function ifs_mpxl_friends_fnAskedJoin(bResult)
	local this = ifs_mpxl_friends

	-- Always restore infobox
	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	if(bResult) then
		-- Exit out of current game...
		if(this.bInSameTitle) then
			ScriptCB_CancelLobby()
		end
		-- and try to join new one
		ifs_mpxl_fnStartJoin(this)
	else
		-- User hit no. Put buttons back
		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
		IFObj_fnSetVis(this.buttons, 1)
	end

	Popup_YesNo.fnDone = nil
end

-- Callbacks from the "Remove from friendslist" popup. If bResult is
-- true, user selected 'yes'
function ifs_mpxl_friends_fnAskedRemove(bResult)
	local this = ifs_mpxl_friends

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	if(bResult) then
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
		ifs_mpxl_friends_fnShowListbox(this,1,nil) -- back to listbox
	else
		-- User hit no. Put buttons back
		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
		IFObj_fnSetVis(this.buttons, 1)
	end

	Popup_YesNo.fnDone = nil
end

-- Callbacks from the "never accept friends requests" popup. If
-- bResult is true, user selected 'yes'
function ifs_mpxl_friends_fnAskedNever(bResult)
	local this = ifs_mpxl_friends

	local fAnimTime = 0.2
	AnimationMgr_AddAnimation(this.infobox,
														{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	
	if(bResult) then
		ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
		ifs_mpxl_friends_fnShowListbox(this,1,nil) -- back to listbox
	else
		-- User hit no. Put buttons back
		local fAnimTime = 0.2
		AnimationMgr_AddAnimation(this.buttons,
															{ fTotalTime = fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
		IFObj_fnSetVis(this.buttons, 1)
	end

	Popup_YesNo.fnDone = nil
end

ifs_mpxl_friends = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	bg_texture = "iface_bgmeta_space",
	bDimBackdrop = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed

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
		ScreenRelativeY = 0.16, -- near top of screen
	},

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

--		print("ifs_mpxl_friends Enter. RecentMode = ",this.bRecentMode)
		if(this.bRecentMode) then
			IFText_fnSetString(this.title,"common.mp.recent")
		else
			IFText_fnSetString(this.title,"ifs.mp.friends.title")
		end

		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		xlfriends_listbox_layout.FirstShownIdx = 1
		xlfriends_listbox_layout.SelectedIdx = 1
		xlfriends_listbox_layout.CursorIdx = 1
		ScriptCB_BeginFriends(this.bRecentMode)
		xlfriends_listbox_layout.FirstShownIdx = 1
		xlfriends_listbox_layout.SelectedIdx = 1
		xlfriends_listbox_layout.CursorIdx = 1
		ListManager_fnFillContents(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
		IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))

		ifs_mpxl_friends_fnShowListbox(this,1,1)
	end,

	Exit = function(this, bFwd)
		ScriptCB_CancelFriends(this.bRecentMode)
		gBlankListbox = 1
		ListManager_fnFillContents(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
		IFText_fnSetString(this.infobox.text,"")
		friends_listbox_contents = nil
		gBlankListbox = nil
	end,

	Input_Accept = function(this)
		if(table.getn(friends_listbox_contents) < 1) then
			return
		end

		local Selection = friends_listbox_contents[xlfriends_listbox_layout.SelectedIdx]

		ifelm_shellscreen_fnPlaySound(this.acceptSound)
		if(this.bShowListbox) then
            
			-- Set hidden flag for all buttons
			local k,v
			for k,v in xlfriends_vbutton_layout.buttonlist do
				this.buttons[v.tag].hidden = 1
			end
			-- Then, enable only the buttons the game says should be on
			local tButtonlist = ScriptCB_GetFriendActions(this.bRecentMode)
			for k,v in tButtonlist do
				print(" Got FriendActions of ", k, v)
				this.buttons[k].hidden = nil
			end

			IFText_fnSetString(this.buttons._titlebar_,Selection.name)

			if((this.buttons.YESINVITE.hidden) and (this.buttons.ACCEPT.hidden)) then
				-- Old path. No invite, no possibility of voicemail. Go straight there.

				-- Update list of what's visible
				local NewButton = ShowHideVerticalButtons(this.buttons,xlfriends_vbutton_layout)
				SetCurButton(NewButton)
				ifs_mpxl_friends_fnShowListbox(this,nil,nil)
			else
				-- New path. Invite is present. 
				ifs_mpxl_friends_fnShowListbox(this,nil,1)
				IFObj_fnSetVis(this.listbox, nil) -- screen all off.
				IFObj_fnSetVis(this.buttons, nil) -- screen all off.
				IFObj_fnSetVis(this.infobox, nil)

				ScriptCB_XL_DownloadVoicemail(1)

				Popup_Busy.fnCheckDone = ifs_mpxl_voicemail_fnCheckDone
				Popup_Busy.fnOnSuccess = ifs_mpxl_voicemail_fnOnSuccess
				Popup_Busy.fnOnFail = ifs_mpxl_voicemail_fnOnFail
				Popup_Busy.fnOnCancel = ifs_mpxl_voicemail_fnOnCancel
				Popup_Busy.fTimeout = 15 -- seconds
				Popup_Busy.fMinTimeout = 0.4 + ScriptCB_random()*0.5

				IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
				Popup_Busy:fnActivate(1)
			end


		else
			-- On buttons. Do them.
			if(this.CurButton == "FEEDBACK") then
				ifs_mpxl_feedback.TargetName = Selection.name
				ifs_mpxl_feedback.bVoicemailOnly = nil
				ifs_movietrans_PushScreen(ifs_mpxl_feedback)
			elseif (this.CurButton == "INVITEVOICE") then
				ifs_mpxl_voicemail.bRecordOnly = 1
				ifs_mpxl_voicemail.bInviteMode = 1
				ifs_mpxl_voicemail.bFriendMode = nil
				ifs_movietrans_PushScreen(ifs_mpxl_voicemail)
			elseif (this.CurButton == "ADDVOICE") then
				ifs_mpxl_voicemail.bRecordOnly = 1
				ifs_mpxl_voicemail.bInviteMode = nil
				ifs_mpxl_voicemail.bFriendMode = 1
				ifs_mpxl_voicemail.iTargetIdx = Selection.indexstr
				ifs_mpxl_voicemail.TargetStr = Selection.name
				ifs_movietrans_PushScreen(ifs_mpxl_voicemail)
			elseif (this.CurButton == "VOICEMAIL") then
				ifs_mpxl_feedback.TargetName = Selection.name -- in case they end up on that screen
				ifs_mpxl_voicemail.bRecordOnly = nil
				ifs_movietrans_PushScreen(ifs_mpxl_voicemail)
			elseif ((this.CurButton == "REMOVE") or (this.CurButton == "NEVER")) then
				-- These two are considered "Destructive" actions -- must ask
				-- for confirmation first

				Popup_YesNo.CurButton = "no" -- default

				local Key
				if(this.CurButton == "REMOVE") then
					Popup_YesNo.fnDone = ifs_mpxl_friends_fnAskedRemove
					Key = "ifs.mp.friends.removeprompt"
				else
					Popup_YesNo.fnDone = ifs_mpxl_friends_fnAskedNever
					Key = "ifs.mp.friends.neverprompt"
				end
				
				local ShowUStr = ScriptCB_usprintf(Key,ScriptCB_tounicode(Selection.name))

				Popup_YesNo:fnActivate(1)
				gPopup_fnSetTitleUStr(Popup_YesNo,ShowUStr)

				local fAnimTime = 0.2
				AnimationMgr_AddAnimation(this.buttons,
																	{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
				AnimationMgr_AddAnimation(this.infobox,
																	{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})

			elseif ((this.CurButton == "JOIN") or (this.CurButton == "YESINVITE")) then
				-- Flow is different depending on whether we're in a session or
				-- not. Store flag for later
				this.bWasInSession = not ScriptCB_IsInShell()

				-- Fix for BF2 bug 11264 - if we're in GC or ROTE, that's
				-- technically the shell, but we need to quit and restart the
				-- shell. So, treat that more like the game. NM 8/23/05
				this.bInGCROTE = ScriptCB_IsScreenInStack("ifs_campaign_main") or ScriptCB_IsScreenInStack("ifs_freeform_main")

				this.bInSameTitle,this.RemoteTitleUStr = ScriptCB_XL_FriendInSameTitle(this.bRecentMode)

				if(not this.bInSameTitle) then
					-- Must prompt that this'll leave current session.
					Popup_YesNo_Large.CurButton = "no" -- default
					Popup_YesNo_Large.fnDone = ifs_mpxl_friends_fnAskedJoin

					local ShowUStr = ScriptCB_usprintf("ifs.mp.friends.willreboot",this.RemoteTitleUStr)

					Popup_YesNo_Large:fnActivate(1)
					gPopup_fnSetTitleUStr(Popup_YesNo_Large, ShowUStr)
					local fAnimTime = 0.2
					AnimationMgr_AddAnimation(this.buttons,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
					AnimationMgr_AddAnimation(this.infobox,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
--				elseif (this.bInGCROTE) then
					-- Shell, but 
				elseif (this.bInGCROTE or this.bWasInSession) then
					-- Must prompt that this'll leave current session.
					Popup_YesNo_Large.CurButton = "no" -- default
					Popup_YesNo_Large.fnDone = ifs_mpxl_friends_fnAskedJoin
					Popup_YesNo_Large:fnActivate(1)
					gPopup_fnSetTitleStr(Popup_YesNo_Large, "ifs.mp.friends.willexitsession")

					local fAnimTime = 0.2
					AnimationMgr_AddAnimation(this.buttons,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
					AnimationMgr_AddAnimation(this.infobox,
																		{ fTotalTime = fAnimTime, fStartAlpha = 1, fEndAlpha = 0,})
				else
					-- Not in session. No prompt necessary

					-- Fix for 7055/11051 - must switch to 'wan' (==XLive) before join, but
					-- also must back up entry config in case join fails
					ifs_mpxl_friends_fnBackupOnlineService()
					ifs_mpxl_fnStartJoin(this)
				end
				-- end of "JOIN"
			else
				-- Simple action that can be done asap
				ScriptCB_DoFriendAction(this.CurButton,this.bRecentMode)
				ifs_mpxl_friends_fnShowListbox(this,1,nil) -- back to listbox
			end

		end


	end,

	Input_Back = function(this)
		if(this.bShowListbox) then
			ScriptCB_PopScreen()
		else
			ScriptCB_SndPlaySound("shell_menu_exit")
			ifs_mpxl_friends_fnShowListbox(this,1,1)
		end
	end,

	Input_GeneralUp = function(this)
		if(this.bShowListbox) then
			if(table.getn(friends_listbox_contents) > 0) then
				ListManager_fnNavUp(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
				IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			end
		else
				gDefault_Input_GeneralUp(this)
		end
	end,

	Input_GeneralDown = function(this)
		if(this.bShowListbox) then
			if(table.getn(friends_listbox_contents) > 0) then
				ListManager_fnNavDown(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
				IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			end
		else
			gDefault_Input_GeneralDown(this)
		end
	end,

	Input_LTrigger = function(this)
		if(this.bShowListbox) then
			if(table.getn(friends_listbox_contents) > 0) then
				ListManager_fnPageUp(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
				IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			end
		end
	end,

	Input_RTrigger = function(this)
		if(this.bShowListbox) then
			if(table.getn(friends_listbox_contents) > 0) then
				ListManager_fnPageDown(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
				IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
			end
		end
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	fHeadsetTimer = 0,
	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- Lobby might be active (if we entered thru it). Update it.
		ScriptCB_UpdateLobby(nil)

		local bCurChanged = ScriptCB_UpdateFriends(this.bRecentMode)
		-- If the current player's options changed, then kick them out of the
		-- sub-screen
		if((bCurChanged) and not this.bShowListbox) then
			ifs_mpxl_friends_fnShowListbox(this,1,1)
		end

		-- Update INVITEVOICE status when the buttons are up, and depending on
		-- whether a headset is preset or not. [If that button is hidden,
		-- do nothing]
		if((not this.bShowListbox) and 
			 ((not this.buttons.INVITEVOICE.hidden) or (not this.buttons.ADDVOICE.hidden))) then
			this.fHeadsetTimer = this.fHeadsetTimer - fDt
			if(this.fHeadsetTimer < 0) then
				this.fHeadsetTimer = 0.15
				local bMissingHeadset = not ScriptCB_XL_IsHeadsetPresent()
				if(this.buttons.INVITEVOICE.bDimmed ~= bMissingHeadset) then
					this.buttons.INVITEVOICE.bDimmed = bMissingHeadset
					this.buttons.ADDVOICE.bDimmed = bMissingHeadset
					ShowHideVerticalButtons(this.buttons,xlfriends_vbutton_layout)
--					print("Refreshing buttons!")
					if ((this.CurButton == "INVITEVOICE") or (this.CurButton == "ADDVOICE")) then
						this:Input_GeneralUp()
					end
				end -- state needs to change
			end -- timer update
		end -- INVITEVOICE isn't hidden

	end,

	-- Brad, call this function from C (with LuaScript::CallTableProcWThis() ) to
	-- refresh the listbox contents. The contents should be in the lua global
	-- friends_listbox_contents
	RepaintListbox = function(this)

		local NumEntries = table.getn(friends_listbox_contents)

		if(NumEntries < 1) then
			xlfriends_listbox_layout.SelectedIdx = nil
		else
			if((not xlfriends_listbox_layout.SelectedIdx) or (xlfriends_listbox_layout.SelectedIdx < 1)) then
				xlfriends_listbox_layout.SelectedIdx = 1
			elseif (xlfriends_listbox_layout.SelectedIdx > NumEntries) then
				xlfriends_listbox_layout.SelectedIdx = NumEntries
			end
		end
		xlfriends_listbox_layout.CursorIdx = xlfriends_listbox_layout.SelectedIdx

		ListManager_fnFillContents(this.listbox,friends_listbox_contents,xlfriends_listbox_layout)
		IFText_fnSetUString(this.infobox.text,ScriptCB_GetFriendStateStr(this.bRecentMode))
	end,
}


-- Do programatic work to set up this screen
function ifs_mpxl_friends_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

	local BoxW = w * 0.85
	xlfriends_listbox_layout.yHeight = ScriptCB_GetFontHeight(xlfriends_listbox_layout.font) + 5
	local BoxH = xlfriends_listbox_layout.showcount * (xlfriends_listbox_layout.yHeight + xlfriends_listbox_layout.ySpacing) + 30

	this.listbox = NewButtonWindow { ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		y = 50 + (BoxH * 0.5), -- enough to be under the title
		
		width = BoxW, height = BoxH,
	}
	xlfriends_listbox_layout.width = BoxW - 35	

	ListManager_fnInitList(this.listbox,xlfriends_listbox_layout)

	-- Also, do the box at the bottom of the screen
	local BoxW = w * 0.95
	local BoxH = 110

	this.infobox = NewButtonWindow { ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 1.0, -- middle of screen
		y = -(40 + (BoxH * 0.5)),
		
		width = BoxW, height = BoxH,
	}

	this.infobox.text = NewIFText{
		y = BoxH * -0.5 - 5, valign = "vcenter", -- centered around parent
		textw= BoxW - 32, texth = BoxH,
		font = "gamefont_medium",
--		string = "data here",
		nocreatebackground=1,
	}

	if(gLangStr ~= "english") then
		xlfriends_vbutton_layout.font = "gamefont_small"
	end

	this.CurButton = AddVerticalButtons(this.buttons,xlfriends_vbutton_layout)
end

ifs_mpxl_friends_fnBuildScreen(ifs_mpxl_friends)
ifs_mpxl_friends_fnBuildScreen = nil

AddIFScreen(ifs_mpxl_friends,"ifs_mpxl_friends")
ifs_mpxl_friends = DoPostDelete(ifs_mpxl_friends)
