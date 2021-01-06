--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Analog to the XLive Optimatch screen -- allows the user to set
-- various filters on the maplist before it's shown.

-- Options for when we're in the shell and the net is off
ifs_mpps2_optimatch_listtags = {
	"players",
	"ping",
	"map",
	"era",
	"servertype",
--	"gamename",
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_mpps2_optimatch_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, 
		y = layout.y,
	}

	Temp.textitem = NewIFText { 
		x = 10,
		y = layout.height * -0.5 + 2,
		halign = "left", valign = "vcenter",
		font = "gamefont_small",
		textw = layout.width - 20, texth = layout.height,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	}

	return Temp
end


-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with appropriate values given a Tag, which
-- may be nil (==blank it) Note: the Tag is an entry out of
-- the ifs_opt_general_listtags_* arrays .
function ifs_mpps2_optimatch_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
	-- Well, no, it's technically not. But, acting like it makes things
	-- more consistent
	local this = ifs_mpps2_optimatch

	local ShowStr = Tag
	local ShowUStr = nil
	local ValUStr
	local TempUStr

	-- Cache some common items
	local AnyUStr = ScriptCB_getlocalizestr("ifs.mp.ps2filters.any")
	local AllUStr = ScriptCB_getlocalizestr("ifs.gsprofile.all")

	if(Tag == "players") then
		if(this.iFilter_NumPlayers < 1) then
			TempUStr = AnyUStr
		else
			TempUStr = ScriptCB_tounicode(string.format("%d",this.iFilter_NumPlayers))
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.players",TempUStr)

	elseif (Tag == "ping") then
		if(this.iFilter_MaxPing < 1) then
			TempUStr = AnyUStr
		else
			TempUStr = ScriptCB_tounicode(string.format("%d",this.iFilter_MaxPing))
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.ping",TempUStr)

	elseif (Tag == "map") then
		if(this.iFilter_MapIdx == 0) then
			TempUStr = AnyUStr
		else
			TempUStr = missionlist_GetLocalizedMapName(mp_missionselect_listbox_contents[this.iFilter_MapIdx].mapluafile)
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.map",TempUStr)

	elseif (Tag == "era") then
		TempUStr = ScriptCB_getlocalizestr(this.sFilter_Era)
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.era",TempUStr)

	elseif (Tag == "servertype") then
		if(this.iFilter_ServerType == 0) then
			TempUStr = AnyUStr
		elseif (this.iFilter_ServerType == 2) then
			TempUStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.pcdedicated")
		elseif (this.iFilter_ServerType == 3) then
			TempUStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.ps2")
		elseif (this.iFilter_ServerType == 4) then
			TempUStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.ps2dedicated")
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.servertype",TempUStr)
	elseif (Tag == "gamename") then
		if(this.sFilter_GameName == "") then
			TempUStr = AllUStr
		else
			TempUStr = ScriptCB_tounicode(this.sFilter_GameName)
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.gamename",TempUStr)
	end

	if (ShowUStr) then
		IFText_fnSetUString(Dest.textitem,ShowUStr)
	elseif (ShowStr) then
		IFText_fnSetString(Dest.textitem,ShowStr)
	end

	IFObj_fnSetColor(Dest.textitem, iColorR, iColorG, iColorB)
	IFObj_fnSetAlpha(Dest.textitem, fAlpha)

	IFObj_fnSetVis(Dest.textitem,Tag) -- hide if no tag
end

ifs_mpps2_optimatch_layout = {
	showcount = 10,
	--  yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
	--  width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_mpps2_optimatch_CreateItem,
	PopulateFn = ifs_mpps2_optimatch_PopulateItem,
}

-- Helper function, updates helptext
function ifs_mpps2_optimatch_fnUpdateHelptext(this)
	if(this.Helptext_Accept) then
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]
		if (Tag == "gamename") then
			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.change")
		else
			IFText_fnSetString(this.Helptext_Accept.helpstr,"common.accept")
		end

		gHelptext_fnMoveIcon(this.Helptext_Accept)
	end

	if((not this.sFilter_GameName) or (string.len(this.sFilter_GameName) < 1)) then
		IFObj_fnSetColor(this.GameSearchName, gTitleTextColor[1], gTitleTextColor[2], gTitleTextColor[3])
		IFText_fnSetString(this.GameSearchName, "ifs.mp.ps2filters.any")
	else
		IFObj_fnSetColor(this.GameSearchName, gUnselectedTextColor[1], gUnselectedTextColor[2], gUnselectedTextColor[3])
		IFText_fnSetString(this.GameSearchName, this.sFilter_GameName)
	end
end

-- Shows one of a set of listboxes depending on various heroes options
function ifs_mpps2_optimatch_fnSetListboxContents(this)
	local NewTags = ifs_mpps2_optimatch_listtags

	this.CurTags = NewTags
	this.OnlinePrefs = ScriptCB_GetOnlineOpts()
	ListManager_fnFillContents(this.listbox,NewTags,ifs_mpps2_optimatch_layout)
	ListManager_fnSetFocus(this.listbox)
	ifs_mpps2_optimatch_fnUpdateHelptext(this)
end

function ifs_mpps2_optimatch_fnResetFilters(this)
	this.sFilter_GameName = ""
	this.iFilter_NumPlayers = 0
	this.iFilter_MapIdx = 0
	this.sFilter_Era = "ifs.mp.ps2filters.era_any"
	this.iFilter_MaxPing = 0
	this.iFilter_ServerType = 0 -- changed to 'any' NM 7/29/05 2 -- PC dedicated is default
	ifs_mpps2_optimatch_fnSetListboxContents(this)
end

-- Callbacks from the "Really reset filters?" popup. If
-- bResult is true, they selected 'yes'
function ifs_mpps2_optimatch_fnAskResetDone(bResult)
	local this = ifs_mpps2_optimatch
	IFObj_fnSetVis(this.listbox, 1)

	if(bResult) then
		ifs_mpps2_optimatch_fnResetFilters(this)
	end
end

-- Pushes filters to profile. Doesn't force a save
function ifs_mpps2_optimatch_fnSaveToProfile(this)
	local EraIdx
	if (this.sFilter_Era == "common.era.cw") then
		EraIdx = 1
	elseif (this.sFilter_Era == "common.era.gcw") then
		EraIdx = 2              
	else
		EraIdx = 0
	end
	
	ScriptCB_SetFilters(this.sFilter_GameName, this.iFilter_NumPlayers, this.iFilter_MapIdx, EraIdx, this.iFilter_MaxPing, this.iFilter_ServerType)
end

-- Callback from vkeyboard. User has hit done.
function ifs_mpps2_optimatch_fnKeyboardDone()
	local this = ifs_mpps2_optimatch
	this.sFilter_GameName = ScriptCB_ununicode(ifs_vkeyboard.CurString)
	IFText_fnSetFont(ifs_vkeyboard.title,"gamefont_large") -- default for screen
	ScriptCB_PopScreen() -- back to this screen, ifs_mpps2_optimatch
end

-- Callback from vkeyboard, to see if a string is acceptable. 
-- We allow everything
function ifs_mpps2_optimatch_fnKeyboardIsAcceptable()
	return 1
end

function ifs_mpps2_optimatch_fnSaveProfileSuccess()
	--  print("ifs_mpps2_optimatch_fnSaveProfileSuccess")
	local this = ifs_mpps2_optimatch
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Just go to sessionlist
	ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end

function ifs_mpps2_optimatch_fnSaveProfileCancel()
	--  print("ifs_mpps2_optimatch_fnSaveProfileCancel")
	local this = ifs_mpps2_optimatch
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Just go to sessionlist
	ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end


ifs_mpps2_optimatch = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	bAcceptIsSelect = 1,

	
	-- auto launch game server
	bAutoLaunch = nil,
	

	--  title = NewIFText {
	--      string = "ifs.mp.createopts.title",
	--      font = "gamefont_large",
	--      textw = 460,
	--      y = 0,
	--      ScreenRelativeX = 0.5, -- center
	--      ScreenRelativeY = 0, -- top
	--  },

	Helptext_Reset = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -40, -- top row of buttons
		x = 0,
		buttonicon = "btnmisc",
		string = "ifs.mp.ps2filters.reset",
	},

	Helptext_Gamename = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -(65 + 25), -- top row of buttons
		x = 0,
		buttonicon = "btnmisc2",
		string = "ifs.mp.ps2filters.gamename_helptext",
	},

	GameSearchTitle = NewIFText { 
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		x = 20,
		y = -75,
		halign = "left", valign = "top",
		font = "gamefont_small",
		textw = 460, texth = 30,
		string = "ifs.mp.ps2filters.gamename_specified",
		startdelay=math.random()*0.5, nocreatebackground=1, 
	},

	GameSearchName = NewIFText { 
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		x = 20,
		y = -75,
		halign = "left", valign = "top",
		font = "gamefont_small",
		textw = 460, texth = 30,
		startdelay=math.random()*0.5, nocreatebackground=1, 
	},

	fnDone = nil, -- Callback function to do something when the user is done
	-- Sub-mode for full/era switch is on.
	bMapMode = nil,
	iMaxPlayers = 32,
	iVoiceMode  = 2,
	
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class

		ifs_mpps2_optimatch.bAutoLaunch = nil
		
		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		this.iMaxPlayers = 24 -- or whatever the PS2 math.max is
		this.iMaxPing = 5000 -- math.max we'll ever let anyone search for

		-- Always reposition 

		local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.GameSearchTitle)
		IFObj_fnSetPos(this.GameSearchName, 25 + fRight - fLeft, -75)

		if(bFwd) then

			-- Get values from profile, then sanity-check them
			local EraIdx
			this.sFilter_GameName, this.iFilter_NumPlayers, this.iFilter_MapIdx, EraIdx, this.iFilter_MaxPing, this.iFilter_ServerType = ScriptCB_GetFilters()

			this.iFilter_NumPlayers = math.max(this.iFilter_NumPlayers, 0)
			this.iFilter_NumPlayers = math.min(this.iFilter_NumPlayers, this.iMaxPlayers)

			local NumMaps = table.getn(mp_missionselect_listbox_contents)
			this.iFilter_MapIdx = math.max(this.iFilter_MapIdx, 0)
			this.iFilter_MapIdx = math.min(this.iFilter_MapIdx, NumMaps)

			if (EraIdx == 1) then
				this.sFilter_Era = "common.era.cw"
			elseif (EraIdx == 2) then
				this.sFilter_Era = "common.era.gcw"
			else
				this.sFilter_Era = "ifs.mp.ps2filters.era_any"
			end

			this.iFilter_MaxPing = math.max(this.iFilter_MaxPing, 0)
			this.iFilter_MaxPing = math.min(this.iFilter_MaxPing, this.iMaxPing)

			this.iFilter_ServerType = math.max(this.iFilter_ServerType, 0)
			this.iFilter_ServerType = math.min(this.iFilter_ServerType, 3)
			if(this.iFilter_ServerType == 1) then
				this.iFilter_ServerType = 0
			end
		end

		-- Always (re)show params
		ifs_mpps2_optimatch_fnSetListboxContents(this)
		ifs_mpps2_optimatch_fnUpdateHelptext(this)
		SetCurButton(this.CurButton)
	end,

	Input_Accept = function(this)
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]

		ScriptCB_SndPlaySound("shell_menu_enter")

		ifs_mpps2_optimatch_fnSaveToProfile(this)

		-- Quick convert internal string.format to string.format expected by game
		local UseName = this.sFilter_GameName
		local UsePlayers = string.format("%d",this.iFilter_NumPlayers)
		local UseMap = "ifs.gsprofile.all"
		local UseEra = this.sFilter_Era
		local UsePing = string.format("%d",this.iFilter_MaxPing)
		local UseServerType = "ifs.gsprofile.all"
		local UserGamemode = "ifs.gsprofile.all"

		if(this.iFilter_MapIdx > 0) then
			UseMap = mp_missionselect_listbox_contents[this.iFilter_MapIdx].mapluafile
		end

		if (this.iFilter_ServerType == 2) then
			UseServerType = "ifs.mp.sessionlist.servertypes.pcdedicated"
		elseif (this.iFilter_ServerType == 3) then
			UseServerType = "ifs.mp.sessionlist.servertypes.ps2"
-- 		elseif (this.iFilter_ServerType == 4) then
-- 			UseServerType = "ifs.mp.sessionlist.servertypes.ps2dedicated"
		end
		
		ScriptCB_ApplyFilters(UseName, UsePlayers, UseMap, UseEra, UsePing, UseServerType, UserGamemode)

		if(ScriptCB_IsCurProfileDirty()) then
			ifs_saveop.doOp = "SaveProfile"
			ifs_saveop.OnSuccess = ifs_mpps2_optimatch_fnSaveProfileSuccess
			ifs_saveop.OnCancel = ifs_mpps2_optimatch_fnSaveProfileCancel
			local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
			ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
			ifs_saveop.saveProfileNum = iProfileIdx
			ifs_movietrans_PushScreen(ifs_saveop)
		else
			-- Just go to sessionlist
			ifs_movietrans_PushScreen(ifs_mp_sessionlist)
		end
	end, -- end of Input_Accept

	Input_Back = function(this)
		ifs_mpps2_optimatch_fnSaveToProfile(this)
		ScriptCB_PopScreen()
	end,

	Input_Misc = function(this)
		Popup_YesNo_Large.CurButton = "no" -- default
		Popup_YesNo_Large.fnDone = ifs_mpps2_optimatch_fnAskResetDone
		Popup_YesNo_Large:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_YesNo_Large, "ifs.mp.ps2filters.reset_prompt")
		IFObj_fnSetVis(this.listbox, nil)
	end,

	Input_Misc2 = function(this)
		ifelm_shellscreen_fnPlaySound(this.acceptSound)

		ifs_vkeyboard.CurString = ScriptCB_tounicode(this.sFilter_GameName)
		IFText_fnSetFont(ifs_vkeyboard.title,"gamefont_small")
		IFText_fnSetString(ifs_vkeyboard.title,"ifs.mp.ps2filters.gamename_prompt")
		vkeyboard_specs.MaxLen = 15
		vkeyboard_specs.MaxWidth = 450
		ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
		vkeyboard_specs.fnDone = ifs_mpps2_optimatch_fnKeyboardDone
		vkeyboard_specs.fnIsOk = ifs_mpps2_optimatch_fnKeyboardIsAcceptable
		ifs_movietrans_PushScreen(ifs_vkeyboard)
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavUp(CurListbox)
			ifs_mpps2_optimatch_fnSetListboxContents(this)
		end
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end

		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavDown(CurListbox)
			ifs_mpps2_optimatch_fnSetListboxContents(this)
		end
	end,

	Input_LTrigger = function(this)
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]
		if (Tag == "players") then
			this.iFilter_NumPlayers = math.max(0,this.iFilter_NumPlayers - 10)
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		elseif (Tag == "ping") then
			this.iFilter_MaxPing = math.max(0, this.iFilter_MaxPing - 500)
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		end
		ifs_mpps2_optimatch_fnSetListboxContents(this)
	end,

	Input_RTrigger = function(this)
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]
		if (Tag == "players") then
			this.iFilter_NumPlayers = math.min(this.iMaxPlayers,this.iFilter_NumPlayers + 10)
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		elseif (Tag == "ping") then
			this.iFilter_MaxPing = math.min(this.iMaxPing, this.iFilter_MaxPing + 500)
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		end
		ifs_mpps2_optimatch_fnSetListboxContents(this)
	end,

	Input_GeneralLeft = function(this)
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]
		if (Tag == "players") then
			if(this.iFilter_NumPlayers > 0) then
				this.iFilter_NumPlayers = this.iFilter_NumPlayers - 1
			else
				this.iFilter_NumPlayers = this.iMaxPlayers
			end

		elseif (Tag == "ping") then
			if(this.iFilter_MaxPing > 0) then
				this.iFilter_MaxPing = this.iFilter_MaxPing - 50
			else
				this.iFilter_MaxPing = this.iMaxPing
			end

		elseif (Tag == "map") then
			local NumMaps = table.getn(mp_missionselect_listbox_contents)
			if(this.iFilter_MapIdx > 0) then
				this.iFilter_MapIdx = this.iFilter_MapIdx - 1
			else
				this.iFilter_MapIdx = NumMaps
			end

		elseif (Tag == "era") then
			if (this.sFilter_Era == "ifs.mp.ps2filters.era_any") then
				this.sFilter_Era = "common.era.gcw"
			elseif (this.sFilter_Era == "common.era.gcw") then
				this.sFilter_Era = "common.era.cw"
			else
				this.sFilter_Era = "ifs.mp.ps2filters.era_any"
			end

		elseif (Tag == "servertype") then
			-- This needs to be one of 0,2,3,4
			if (this.iFilter_ServerType > 2) then
				this.iFilter_ServerType = this.iFilter_ServerType - 1
			elseif (this.iFilter_ServerType == 2) then
				this.iFilter_ServerType = 0
			else
				this.iFilter_ServerType = 3
			end
		end

		if (this.CurButton ~= "gamename") then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		end
		ifs_mpps2_optimatch_fnSetListboxContents(this)
	end,

	Input_GeneralRight = function(this)
		local Tag = this.CurTags[ifs_mpps2_optimatch_layout.SelectedIdx]
		if (Tag == "players") then
			if(this.iFilter_NumPlayers < this.iMaxPlayers) then
				this.iFilter_NumPlayers = this.iFilter_NumPlayers + 1
			else
				this.iFilter_NumPlayers = 0
			end

		elseif (Tag == "ping") then
			if(this.iFilter_MaxPing < this.iMaxPing) then
				this.iFilter_MaxPing = this.iFilter_MaxPing + 50
			else
				this.iFilter_MaxPing = 0
			end

		elseif (Tag == "map") then
			local NumMaps = table.getn(mp_missionselect_listbox_contents)
			if(this.iFilter_MapIdx < NumMaps) then
				this.iFilter_MapIdx = this.iFilter_MapIdx + 1
			else
				this.iFilter_MapIdx = 0
			end

		elseif (Tag == "era") then
			if (this.sFilter_Era == "ifs.mp.ps2filters.era_any") then
				this.sFilter_Era = "common.era.cw"
			elseif (this.sFilter_Era == "common.era.cw") then
				this.sFilter_Era = "common.era.gcw"
			else
				this.sFilter_Era = "ifs.mp.ps2filters.era_any"
			end

		elseif (Tag == "servertype") then
			-- This needs to be one of 0,2,3,4
			if (this.iFilter_ServerType == 3) then
				this.iFilter_ServerType = 0
			elseif (this.iFilter_ServerType >= 2) then
				this.iFilter_ServerType = this.iFilter_ServerType + 1
			else
				this.iFilter_ServerType = 2
			end

		end

		if (this.CurButton ~= "gamename") then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
		end
		ifs_mpps2_optimatch_fnSetListboxContents(this)
	end,
}

-- Helper function, builds this screen.
function ifs_mpps2_optimatch_fnBuildScreen(this)
	local w
	local h
	w,h = ScriptCB_GetSafeScreenInfo()
	
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

	-- Don't use all of the screen for the listbox
	local BottomIconsHeight = 0
	local BotBoxHeight = 0
	local YPadding = 100 -- amount of space to reserve for titlebar, helptext, whitespace, etc

	-- Get usable screen area for listbox
	h = h - BottomIconsHeight - BotBoxHeight - YPadding

	-- Calc height of listbox row, use that to figure out how many rows will fit.
	ifs_mpps2_optimatch_layout.FontStr = "gamefont_medium"
	ifs_mpps2_optimatch_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_mpps2_optimatch_layout.FontStr)
	ifs_mpps2_optimatch_layout.yHeight = ifs_mpps2_optimatch_layout.iFontHeight + 2
	local ListBoxY = 0
	if((gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
		ifs_mpps2_optimatch_layout.yHeight = 2 * ifs_mpps2_optimatch_layout.yHeight
		ListBoxY = -16 -- fix for 9584 - move this up onscreen
	else
		ifs_mpps2_optimatch_layout.yHeight = math.floor(1.3 * ifs_mpps2_optimatch_layout.yHeight)
	end

	local RowHeight = ifs_mpps2_optimatch_layout.yHeight + ifs_mpps2_optimatch_layout.ySpacing
	ifs_mpps2_optimatch_layout.showcount = math.min(math.floor(h / RowHeight) , table.getn(ifs_mpps2_optimatch_listtags))

	local listWidth = w * 0.85
	local ListboxHeight = ifs_mpps2_optimatch_layout.showcount * RowHeight + 30
	this.listbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		y = ListBoxY, -- ListboxHeight * 0.5 + 30,
		width = listWidth,
		height = ListboxHeight,
		titleText = "ifs.mp.optimatch.title",
	}
	ifs_mpps2_optimatch_layout.width = listWidth - 40
	ifs_mpps2_optimatch_layout.x = 0

	ListManager_fnInitList(this.listbox,ifs_mpps2_optimatch_layout)
end

ifs_mpps2_optimatch_fnBuildScreen(ifs_mpps2_optimatch)
ifs_mpps2_optimatch_fnBuildScreen = nil -- clear out of memory to save space
AddIFScreen(ifs_mpps2_optimatch,"ifs_mpps2_optimatch")
