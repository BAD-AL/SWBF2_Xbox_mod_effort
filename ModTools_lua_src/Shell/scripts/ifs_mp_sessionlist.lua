--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Multiplayer list of sessions screen. For XBox Optimatch or Gamespy
-- "pick a game to join" screen.

gMPSessionList_Listbox_ColumnInfo = {
	{ width = 30, tag = "favorite", string = "ifs.mp.sessionlist.favorite", maxchars = -1, }, -- Server name -- 0.28*layout.width-5
	{ width = 50, tag = "gamename", string = "ifs.mp.sessionlist.gamename", maxchars = 20, }, -- Server name -- 0.28*layout.width-5
	{ width = 60, tag = "numplayers", string = "ifs.mp.sessionlist.numplayers", maxchars = 2, }, -- # players -- 50
	{ width = 50, tag = "mapname", string = "ifs.onlinelobby.map", maxchars = -1, }, -- mapname -- 0.23*layout.width-5
	{ width = 40, tag = "ping", string = "ifs.mp.sessionlist.ping", maxchars = 4, },  -- ping -- 40
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer { 
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local XPos = 5
	local YPos = -8 -- layout.height * 0.5-- + 2
	local ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[1].width
	Temp.isfavorite = NewIFImage {
		x = XPos, y = YPos,
--		texture = "check", -- set below
		localpos_l = 1, localpos_t = 4,
		localpos_r = 11, localpos_b = 15,
		AutoHotspot = 1, tag = "check",
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[2].width
	Temp.namefield = NewIFText {
		x = XPos, y = YPos, 
		textw = ColumnWidth, texth = layout.height,
		halign = "left", valign = "vcenter", 
		font = "gamefont_tiny", nocreatebackground=1, 
--		HScale = 0.8,
--		VScale = 1,
	}
	XPos = XPos + ColumnWidth

	local ColumnWidth = gMPSessionList_Listbox_ColumnInfo[3].width
	Temp.numplayers = NewIFText {
		x = XPos, y = YPos, 
		textw = ColumnWidth, texth = layout.height,
		halign = "left", valign = "vcenter", 
		font = "gamefont_tiny", nocreatebackground=1, 
--		HScale = 0.8,
--		VScale = 1,
	}
	XPos = XPos + ColumnWidth

	local ColumnWidth = gMPSessionList_Listbox_ColumnInfo[4].width
	Temp.map = NewIFText { 
		x = XPos, y = YPos, 
		textw = ColumnWidth, texth = layout.height,
		halign = "left", valign = "vcenter", 
		font = "gamefont_tiny", nocreatebackground=1, 
--		HScale = 0.8,
--		VScale = 1,
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = layout.width - 15 - XPos -- allocate 'rest' to ping
	gMPSessionList_Listbox_ColumnInfo[5].width = ColumnWidth -- and store for later

	if(ScriptCB_GetOnlineService() == "XLive") then
		Temp.qosfield = NewIFImage{ 
			x = XPos, y = YPos, -- y-pos is to get it centered in bar
			texture = "ping_icon", 
			localpos_l = 0,              localpos_t = 2,
			localpos_b = layout.height - 5, localpos_r = 50,
		} 
	else
		Temp.pingtext = NewIFText { 
			x = XPos, y = YPos, 
			textw = ColumnWidth, texth = layout.height,
			halign = "left", valign = "vcenter", 
			font = "gamefont_tiny", nocreatebackground=1, 
			--		HScale = 0.8,
			--		VScale = 1,
		}
	end
	XPos = XPos + ColumnWidth


	local LockHeight = layout.height * 0.75
	local LockMargin = (layout.height - LockHeight) * 0.5
	Temp.lockedgame = NewIFImage { texture = "lock_icon", 
		localpos_l = layout.width-LockHeight - 4,
		localpos_t = LockMargin - 5 - 3, 
		localpos_r = layout.width - 4,
		localpos_b = LockHeight + LockMargin - 5 - 6,
	}

	return Temp
end

mpsessioninfo = {
	era = "common.era.cw",
	map = "",
}

mpsession_mapnames = {
	BES = "bespin",
	KAS = "kashyyyk",
	NAB = "naboo",
	RHN = "rhenvar",
	TAT = "tatooine",
	END = "endor",
	GEO = "geonosis",
	HOT = "hoth",
	KAM = "kamino",
	YAV = "yavin",
}

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_Listbox_PopulateItem(Dest, Data, bSelected, iColorR, iColorG, iColorB, fAlpha)

	if((gBlankListbox) or ((not Data))) then
		IFText_fnSetString(Dest.namefield,"")
		IFText_fnSetString(Dest.numplayers,"")
		IFText_fnSetString(Dest.map,"")
		IFObj_fnSetVis(Dest.lockedgame,nil) -- turn off locked icon
		IFObj_fnSetVis(Dest.isfavorite,nil) -- turn off favorite icon
	else

		IFObj_fnSetColor(Dest.namefield, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.namefield, fAlpha)
		IFObj_fnSetColor(Dest.numplayers, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.numplayers, fAlpha)
		IFObj_fnSetColor(Dest.map, iColorR, iColorG, iColorB)
		IFObj_fnSetAlpha(Dest.map, fAlpha)
		if(Dest.pingtext) then
			IFObj_fnSetColor(Dest.pingtext, iColorR, iColorG, iColorB)
			IFObj_fnSetAlpha(Dest.pingtext, fAlpha)
		end

		IFText_fnSetString(Dest.numplayers,Data.numplayers)
		IFText_fnSetString(Dest.namefield,Data.namestr)

		if(Data.bFavorite) then
			IFImage_fnSetTexture(Dest.isfavorite, "check_yes")
		else
			IFImage_fnSetTexture(Dest.isfavorite, "check_no")
		end
		IFObj_fnSetVis(Dest.isfavorite, (gOnlineServiceStr == "GameSpy"))

		if (Data.bWrongVer) then
			IFImage_fnSetTexture(Dest.lockedgame, "version_icon")
			IFObj_fnSetVis(Dest.lockedgame,1)
		elseif (Data.bLocked) then
			IFImage_fnSetTexture(Dest.lockedgame, "lock_icon")
			IFObj_fnSetVis(Dest.lockedgame,1)
		else
			IFObj_fnSetVis(Dest.lockedgame,nil) -- turn off icon
		end

		if(Data.pingint) then
			IFText_fnSetString(Dest.pingtext,string.format("%d", Data.pingint))
		end
		if(Data.qosvalue) then
			local U1 = (5 - Data.qosvalue) * 0.2
			IFImage_fnSetUVs(Dest.qosfield, U1, 0.0, U1 + 0.2, 1.0)
		end

 		local MapStr = string.upper(Data.mapname)
		local SideChar = string.sub(MapStr,5,5) -- 'G' or 'C'
		local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.mapname)
		
		if(iSource ~= 2) then
			IFObj_fnSetColor(Dest.map, 255, 255, 255)
		else
			DisplayUStr = ScriptCB_usprintf("ifs.mp.sessionlist.map_missing", DisplayUStr)
			IFObj_fnSetColor(Dest.map, 255, 255, 0)
		end
		IFText_fnSetUString(Dest.map, DisplayUStr)	

		if((SideChar=="G")) then
			ShowStr = "common.era.gcw"
		elseif ((SideChar == "C")) then
			ShowStr = "common.era.cw"
		else
			ShowStr = SideChar
		end
	end

	-- Show it if data is present, hide if no data
	IFObj_fnSetVis(Dest,Data)
end

mpsessionlist_listbox_layout = {
	showcount = 7,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 20,
	ySpacing  = -2,
--	width = 260,
	x = 0,
	slider = 1,

	CreateFn = MPSessionList_Listbox_CreateItem,
	PopulateFn = MPSessionList_Listbox_PopulateItem,
}

mpsessionlist_listbox_contents = {
	-- Filled in from C++ now. NM 8/7/03
	-- Stubbed to show the string.format it wants.
--	{ indexstr = "1", namestr = "Alpha"},
--	{ indexstr = "2", namestr = "Bravo"},
}

function ifs_mp_sessionlist_back_fnSaveProfileSuccess()
	--  print("ifs_mpps2_optimatch_fnSaveProfileSuccess")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Back up one more screen (to mpps2_optimatch)
	ScriptCB_PopScreen()
	--    ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end

function ifs_mp_sessionlist_back_fnSaveProfileCancel()
	--  print("ifs_mpps2_optimatch_fnSaveProfileCancel")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Back up one more screen (to mpps2_optimatch)
	ScriptCB_PopScreen()
	--    ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end

function ifs_mp_sessionlist_fwd_fnSaveProfileSuccess()
	--  print("ifs_mpps2_optimatch_fnSaveProfileSuccess")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	this.bPasswordJoinOnEnter = 1
end

function ifs_mp_sessionlist_fwd_fnSaveProfileCancel()
	--  print("ifs_mpps2_optimatch_fnSaveProfileCancel")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	this.bPasswordJoinOnEnter = 1
end

-- Helper function. Turns listbox on/off, as requested
function ifs_sessionlist_joinpopup_fnShowListbox(this,bVis)
	if(bVis) then
		AnimationMgr_AddAnimation(this.listbox,{ fTotalTime = 0.2, fStartAlpha = 0, fEndAlpha = 1, })
		AnimationMgr_AddAnimation(this.info,{ fTotalTime = 0.2, fStartAlpha = 0, fEndAlpha = 1, })
	else
		AnimationMgr_AddAnimation(this.listbox,{ fTotalTime = 0.2, fStartAlpha = 1, fEndAlpha = 0, })
		AnimationMgr_AddAnimation(this.info,{ fTotalTime = 0.2, fStartAlpha = 1, fEndAlpha = 0, })
	end
end

-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_joinpopup_fnCheckDone()
--	local this = ifs_sessionlist_joinpopup
	ScriptCB_UpdateJoin() -- think...

	return ScriptCB_IsJoinDone()
end

function ifs_sessionlist_joinpopup_fnOnSuccess()
	local this = ifs_mp_sessionlist
	Popup_Busy:fnActivate(nil)
	ScriptCB_LaunchJoin()
	-- go to the quick lunch lobby
	ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
end

-- "session not available" popup has been dismissed
function ifs_mp_sessionlist_fnNotAvailableOk()
	local this = ifs_mp_sessionlist

	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	
	ScriptCB_SetInNetGame(nil)
	ScriptCB_CancelSessionList()
	ScriptCB_BeginSessionList()
end

function ifs_sessionlist_joinpopup_fnOnFail()
	print("Join failed")

	local this = ifs_mp_sessionlist

 	Popup_Busy:fnActivate(nil)

	if (ScriptCB_GetOnlineService() == "XLive") then
		Popup_Ok.fnDone = ifs_mp_sessionlist_fnNotAvailableOk
		Popup_Ok:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_Ok, "xlive.errors.sessionnotavailable")
	elseif (gPlatformStr == "PS2") then
		Popup_Ok.fnDone = ifs_mp_sessionlist_fnNotAvailableOk
		Popup_Ok:fnActivate(1)
		gPopup_fnSetTitleStr(Popup_Ok, "ifs.mp.joinerrors.noconnect")
	else
		ifs_mp_sessionlist_fnShowHideInterface(this,nil)
		ifs_sessionlist_joinpopup_fnShowListbox(this,1)
		
		ScriptCB_SetInNetGame(nil)
		ScriptCB_CancelSessionList()
		ScriptCB_BeginSessionList()
	end
	-- 	Popup_YesNo.CurButton = "no" -- default
-- 	Popup_YesNo.fnDone = ifs_xlive_main_fnAskCreateDone
-- 	IFText_fnSetString(Popup_YesNo.t itle,"ifs.quickopti.nonefound")
-- 	Popup_YesNo:fnActivate(1)
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_joinpopup_fnOnCancel()
	local this = ifs_mp_sessionlist

	-- Stop logging in.
	ScriptCB_CancelJoin()
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	ScriptCB_SetInNetGame(nil)
	ScriptCB_CancelSessionList()
	ScriptCB_BeginSessionList()
end

-- snip
-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_rejoinpopup_fnCheckDone()
--	local this = ifs_sessionlist_joinpopup
	ScriptCB_UpdateSessionList()  -- think...
	return 0 -- still busy
end

function ifs_sessionlist_rejoinpopup_fnOnSuccess()
	local this = ifs_mp_sessionlist
	Popup_Busy:fnActivate(nil)
end

function ifs_sessionlist_rejoinpopup_fnOnFail()
	print("reJoin failed")

	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)

 	Popup_Busy:fnActivate(nil)
	ScriptCB_SetInNetGame(nil)
	ScriptCB_CancelSessionList()
	ScriptCB_BeginSessionList()
-- 	Popup_YesNo.CurButton = "no" -- default
-- 	Popup_YesNo.fnDone = ifs_xlive_main_fnAskCreateDone
-- 	IFText_fnSetString(Popup_YesNo.t itle,"ifs.quickopti.nonefound")
-- 	Popup_YesNo:fnActivate(1)
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_rejoinpopup_fnOnCancel()
	local this = ifs_mp_sessionlist

	ScriptCB_SetInNetGame(nil) 
	ScriptCB_CancelSessionList()

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	ScriptCB_SetInNetGame(nil)
	ScriptCB_CancelSessionList()
	ScriptCB_BeginSessionList()
end


-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_optisearch_fnCheckDone()
--	local this = ifs_sessionlist_joinpopup
	return ScriptCB_UpdateSessionList()  -- think...
end

function ifs_sessionlist_optisearch_fnOnSuccess()
	print("optisearch success")
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
end

-- Callbacks from the "No sessions found, create one?" popup. If
-- bResult is true, they selected 'yes'
function ifs_mp_sessionlist_fnAskCreateDone(bResult)
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)

	if(bResult) then
		ifs_mp_main.bHostOnEnter = 1
	end
	ScriptCB_PopScreen("ifs_mp_main")
end

function ifs_sessionlist_optisearch_fnOnFail()
	print("optisearch OnFail")

	local this = ifs_mp_sessionlist
 	Popup_Busy:fnActivate(nil)

 	Popup_YesNo.CurButton = "no" -- default
 	Popup_YesNo.fnDone = ifs_mp_sessionlist_fnAskCreateDone
 	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo,"ifs.quickopti.nonefound")

end

-- User hit cancel. Do what they want.
function ifs_sessionlist_optisearch_fnOnCancel()
	print("optisearch cancel")
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)

	-- Get rid of popup, back out
	Popup_Busy:fnActivate(nil)
	ScriptCB_PopScreen()
end

-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_refresh_fnCheckDone()
	-- Jump to top of listbox as long as we're up.
	if(table.getn(mpsessionlist_listbox_contents) > 0) then
		mpsessionlist_listbox_layout.SelectedIdx = 1
	end
	ScriptCB_UpdateSessionList()  -- think...

	if(gOnlineServiceStr ~= "LAN") then
		local iPercentDone = ScriptCB_GetSessionListPercent()
--		print("iPercentDone = ", iPercentDone)
		if(iPercentDone > 100) then
			return 1
		end
		local ShowStr = string.format("%d%%", iPercentDone)
		IFText_fnSetString(Popup_Busy.BusyTimeStr,ShowStr)
	end

	return 0 -- still busy
end

function ifs_sessionlist_refresh_fnOnSuccess()
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
	this:RepaintListbox()
end

function ifs_sessionlist_refresh_fnOnFail()
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
	ScriptCB_PauseSessionList()
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_refresh_fnOnCancel()
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
	ScriptCB_PauseSessionList()
end

-- "Server is running the wrong version" popup has been dismissed
function ifs_mp_sessionlist_fnWrongVerOk()
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
end

function ifs_mp_sessionlist_fnBadNetworkPopupDone(bResult)
	local this = ifs_mp_sessionlist

	if(bResult) then
		ifs_mp_sessionlist_fnStartJoin(this)
	else
		ifs_mp_sessionlist_fnShowHideInterface(this,nil)
		ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	end
end

function ifs_mp_sessionlist_fnBadNetworkPopupDonePassword(bResult)
	local this = ifs_mp_sessionlist

	if(bResult) then
		ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
	else
		ifs_mp_sessionlist_fnShowHideInterface(this,nil)
		ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	end
end

function ifs_sessionlist_ClearSessionInfo()
	mpsessioninfo.era = "common.era.cw"
	mpsessioninfo.map = ""
end

-- Helper function, blanks the extra info box
function ifs_mp_sessionlist_fnBlankExtraInfo(this)
	local i
	for i = 1,12 do
 		IFText_fnSetString(this.info[i],"")
	end
end

-- Helper function, fills in the extra info box. Selection will be the
-- row of the listbox up top
function ifs_mp_sessionlist_fnFillExtraInfo(this, Selection)
	local MapStr = string.upper(Selection.mapname)
	local SideChar = string.sub(MapStr,5,5) -- 'G' or 'C'
	if(SideChar=="G") then
		mpsessioninfo.era="common.era.gcw"
	else
		mpsessioninfo.era="common.era.cw"
	end

	-- Handy translation table
	-- v1.0: info[#] = 
	--   1  Era             5  # bots
	--   2  Map             6  Autoaim
  --   3  Reinforcements  7  Heroes
  --   4  Team Damage     8  Autoassign

	-- v1.1:
	--   1  Game Name        7  Reinforcements
	--   2  Era              8  # bots
  --   3  Server Type      9  Autoaim
  --   4  Spawn Invincible 10 Heroes
	--   5  AI Difficulty    11 Autoassign
	--   6  Show Names       12 Team Damage

	-- Notes on spacing:
	-- AI Difficulty, Show names, spawn invincible are *long* in Spanish. Moved to left for that


	local NewStr = ""
	local OnStr = ScriptCB_getlocalizestr("common.on")
	local OffStr = ScriptCB_getlocalizestr("common.off")
	local tempStr = ""
	tempStr = ScriptCB_getlocalizestr(mpsessioninfo.era)
	NewStr = ScriptCB_usprintf("ifs.mp.sessionlist.era",tempStr)
	IFText_fnSetUString(this.info[2],NewStr)
	IFText_fnSetUString(this.info[1],mpsessionlist_serverinfo_contents[1].text) -- Game name
	IFText_fnSetUString(this.info[7],mpsessionlist_serverinfo_contents[2].text) -- reinforcements
	IFText_fnSetUString(this.info[12],mpsessionlist_serverinfo_contents[6].text) -- team damage
	IFText_fnSetUString(this.info[5],mpsessionlist_serverinfo_contents[7].text) -- AI Difficulty
	IFText_fnSetUString(this.info[8],mpsessionlist_serverinfo_contents[3].text) -- bots
	IFText_fnSetUString(this.info[9],mpsessionlist_serverinfo_contents[8].text) -- Autoaim
	IFText_fnSetUString(this.info[10],mpsessionlist_serverinfo_contents[10].text) -- Heroes
	IFText_fnSetUString(this.info[11],mpsessionlist_serverinfo_contents[5].text) -- Autoassign
	IFText_fnSetUString(this.info[4],mpsessionlist_serverinfo_contents[11].text) -- Invincible Time
	IFText_fnSetUString(this.info[6],mpsessionlist_serverinfo_contents[9].text) -- Show names

	-- Also, fill in server type
	if(Selection.servertype) then
		local tempStr = nil
		if(Selection.servertype == 1) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.pc")
 			elseif(Selection.servertype == 2) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.pcdedicated")
 			elseif(Selection.servertype == 3) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.ps2")
 			elseif(Selection.servertype == 4) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.ps2dedicated")
 			elseif(Selection.servertype == 5) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.xbox")
 			elseif(Selection.servertype == 6) then
			tempStr = ScriptCB_getlocalizestr("ifs.mp.sessionlist.servertypes.xboxdedicated")
		end
		if(tempStr) then
			IFText_fnSetUString(this.info[3],tempStr)
		end
	end


end

-- Helper function, shows/hides the interface items on this page
function ifs_mp_sessionlist_fnShowHideInterface(this, bHideInterface)
	IFObj_fnSetVis(this.listbox, not bHideInterface)
	IFObj_fnSetVis(this.ResortButtons, not bHideInterface)
	IFObj_fnSetVis(this.info, not bHideInterface)
--	IFObj_fnSetVis(this.infoTitle, not bHideInterface)
	IFObj_fnSetVis(this.title, not bHideInterface)
	IFObj_fnSetVis(this.buttons, not bHideInterface)
	IFObj_fnSetVis(this.Helptext_R2, not bHideInterface and (gPlatformStr == "PS2"))
	IFObj_fnSetVis(this.Helptext_Refresh, not bHideInterface)
	IFObj_fnSetVis(this.Helptext_SortMode, not bHideInterface and this.bCanSort)
end

-- Starts the join. PasswordStr may be nil
function ifs_mp_sessionlist_fnStartJoin(this,PasswordStr)
	ifs_mp_sessionlist_fnShowHideInterface(this,1)
	ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
	
	Popup_Busy.fnCheckDone = ifs_sessionlist_joinpopup_fnCheckDone
	Popup_Busy.fnOnSuccess = ifs_sessionlist_joinpopup_fnOnSuccess
	Popup_Busy.fnOnFail = ifs_sessionlist_joinpopup_fnOnFail
	Popup_Busy.fnOnCancel = ifs_sessionlist_joinpopup_fnOnCancel
	Popup_Busy.bNoCancel = nil -- allow cancel button
	Popup_Busy.fTimeout = 60 -- seconds
	if (not gFinalBuild) then
		Popup_Busy.fTimeout = 150
	end
	IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
	Popup_Busy:fnActivate(1)
	
	ScriptCB_BeginJoin(PasswordStr)
end

-- Callback function when the virtual keyboard is done
function ifs_mp_sessionlist_fnKeyboardDone()
--	print("ifs_mp_gameopts_fnKeyboardDone()")
	local this = ifs_mp_sessionlist
	this.LastPasswordStr = ScriptCB_ununicode(ifs_vkeyboard.CurString)
	this.bPasswordJoinOnEnter = 1
	ScriptCB_PopScreen()
--	vkeyboard_specs.fnDone = nil -- clear our registration there
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_mp_sessionlist_fnIsAcceptable()
--	print("ifs_mp_gameopts_fnIsAcceptable()")
	return 1,""
end

-- Reads this.iSortMode, sets text to match
function ifs_mp_sessionlist_UpdateSortModeText(this)

	local i
	for i=1,table.getn(gMPSessionList_Listbox_ColumnInfo) do
		local NewLabel = gMPSessionList_Listbox_ColumnInfo[i].tag .. "Label"
		local Color = 0
		if((i == this.iSortMode) and this.bCanSort) then
			Color = 255
		end
		IFFlashyText_fnSetTextColor(this.ResortButtons[NewLabel] , Color, Color, Color)
	end

--	local SortByStr = ScriptCB_getlocalizestr()
--	local SpacesUStr = ScriptCB_tounicode(": ")
	local TitleUStr = ScriptCB_getlocalizestr(gMPSessionList_Listbox_ColumnInfo[this.iSortMode].string)

	local ShowUStr = ScriptCB_usprintf("ifs.mp.sessionlist.sortby2", TitleUStr)
	IFText_fnSetUString(this.Helptext_SortMode.helpstr, ShowUStr)
	gHelptext_fnMoveIcon(this.Helptext_SortMode)
end

-- join online game
function ifs_mp_sessionlist_JoinGame( this )
		-- Do all sanity checks to reject early and often. If they all
		-- pass, then we can join.
		if(table.getn(mpsessionlist_listbox_contents) < 1) then
			ifelm_shellscreen_fnPlaySound(this.errorSound)
			return
		end

		if (not ScriptCB_IsSessionReady()) then
			ifelm_shellscreen_fnPlaySound(this.errorSound)
			return
		end

		local Selection = mpsessionlist_listbox_contents[mpsessionlist_listbox_layout.SelectedIdx]

		if (Selection.bWrongVer) then
			-- Wrong version. Can't join
			ifs_mp_sessionlist_fnShowHideInterface(this,1)
			Popup_Ok.fnDone = ifs_mp_sessionlist_fnWrongVerOk
			Popup_Ok:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_Ok, "ifs.onlinelobby.wrongver")
			return
		end

		-- Fix for bug 1563 - XLive games can't be locked. But, if the
		-- user button-mashes thru the UI, they'll start a join before
		-- game data is in, and it'll "appear" locked. So, just ignore
		-- button presses in such cases.
		if((gOnlineServiceStr == "XLive") and Selection.bLocked) then
			return
		end

		ifelm_shellscreen_fnPlaySound(this.acceptSound)

		if (Selection.bLocked) then
			ifs_vkeyboard.CurString = ScriptCB_tounicode(this.LastPasswordStr)
			ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
			vkeyboard_specs.bPasswordMode = 1
			
			IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
			vkeyboard_specs.fnDone = ifs_mp_sessionlist_fnKeyboardDone
			vkeyboard_specs.fnIsOk = ifs_mp_sessionlist_fnIsAcceptable
			
			local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
			vkeyboard_specs.MaxWidth = (w * 0.5)
			vkeyboard_specs.MaxLen = 16
			ifs_movietrans_PushScreen(ifs_vkeyboard)
			return
		end

		if((gPlatformStr == "XBox") and (ScriptCB_IsBadNetworkConnection())) then
			ifs_mp_sessionlist_fnShowHideInterface(this,1)
			ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
			Popup_AB.CurButton = "no" -- default
			Popup_AB.fnDone = ifs_mp_sessionlist_fnBadNetworkPopupDone
			Popup_AB:fnActivate(1)
			gPopup_fnSetTitleStr(Popup_AB, "ifs.mp.badconnection")
			return
		end

		-- If we got here, then all checks passed
		ifs_mp_sessionlist_fnStartJoin(this)
end

ifs_mp_sessionlist = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	iSortMode = 2, -- gamename
	bAcceptIsSelect = 1,


	Helptext_R2 = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -65, -- third row of buttons
		x = 0,
		buttonicon = "btnr2",
		string = "ifs.mp.sessionlist.togglefavorite",
	},

	Helptext_Refresh = NewHelptext {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -40, -- top row of buttons
		x = 0,
		buttonicon = "btnmisc",
		string = "ifs.mp.sessionlist.refresh",
	},

	Helptext_SortMode = NewHelptext {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bot
		y = -40,
		buttonicon = "btnmisc2",
		string = "ifs.mp.sessionlist.sortby",
		bRightJustify = 1,
	},

	title = NewIFText {
		string = "ifs.mp.sessionlist.title",
		font = "gamefont_large",
		y = 0,
		textw = 460,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1, 
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 0, -- top
	},

	Gamespy_IconL = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 1.0, -- bottom
		texture = "gamespy_logo_128x32l",
		localpos_l = -64,
		localpos_t = -32,
		localpos_r = 0,
		localpos_b = 0,
	},

	Gamespy_IconR = NewIFImage {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 1.0, -- bottom
		texture = "gamespy_logo_128x32r",
		localpos_l = 0,
		localpos_t = -32,
		localpos_r = 64,
		localpos_b = 0,
	},

	Enter = function(this, bFwd)
		-- Always call base class
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		missionselect_listbox_contents = mp_missionselect_listbox_contents

		this.bIsXLive = (gOnlineServiceStr == "XLive")
		this.bCanSort = (gPlatformStr ~= "XBox")

		local bIsGamespy = (gOnlineServiceStr == "GameSpy")
		IFObj_fnSetVis(this.Gamespy_IconL, bIsGamespy)
		IFObj_fnSetVis(this.Gamespy_IconR, bIsGamespy)
		this.bShowRefresh = 1
		IFObj_fnSetVis(this.Helptext_R2, nil)
		IFObj_fnSetVis(this.Helptext_Refresh, nil)
		IFObj_fnSetVis(this.Helptext_SortMode, nil)

		this.iSortMode = ScriptCB_GetSessionSortMode()
		ifs_mp_sessionlist_UpdateSortModeText(this)

		if((gPlatformStr == "XBox") or (gOnlineServiceStr ~= "GameSpy")) then
			IFObj_fnSetVis(this.ResortButtons.favoriteLabel, nil)
		end

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			print("Entering sessionlist, ErrorLevel = ",ErrorLevel)
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			else
				ScriptCB_ClearError()
			end
		end


		ifs_sessionlist_joinpopup_fnShowListbox(this,1)

		if(bFwd or this.bForceRefresh) then
			this.bForceRefresh = nil

			-- Blast list initially on entry
			ScriptCB_CancelSessionList()
			ifs_sessionlist_ClearSessionInfo()
			this.bInOptiSearch = nil

			-- Reset listbox, show it. [Remember, Lua starts at 1!]
			mpsessionlist_listbox_layout.FirstShownIdx = 1
			mpsessionlist_listbox_layout.SelectedIdx = 1
			mpsessionlist_listbox_layout.CursorIdx = nil
			
			ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)

			local bHideInterface = ScriptCB_BeginSessionList()
			ifs_mp_sessionlist_fnShowHideInterface(this, bHideInterface)
			this.bWaitingForPrevSession = bHideInterface
			if(bHideInterface) then
				Popup_Busy.fnCheckDone = ifs_sessionlist_rejoinpopup_fnCheckDone
				Popup_Busy.fnOnSuccess = ifs_sessionlist_rejoinpopup_fnOnSuccess
				Popup_Busy.fnOnFail = ifs_sessionlist_rejoinpopup_fnOnFail
				Popup_Busy.fnOnCancel = ifs_sessionlist_rejoinpopup_fnOnCancel
				Popup_Busy.bNoCancel = nil -- allow cancel button
				Popup_Busy.fTimeout = 120 -- seconds
				IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
				Popup_Busy:fnActivate(1)
			elseif (gOnlineServiceStr == "XLive") then -- not this.bShowRefresh) then
				ifs_mp_sessionlist_fnShowHideInterface(this,1)
				ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
				Popup_Busy.fnCheckDone = ifs_sessionlist_optisearch_fnCheckDone
				Popup_Busy.fnOnSuccess = ifs_sessionlist_optisearch_fnOnSuccess
				Popup_Busy.fnOnFail = ifs_sessionlist_optisearch_fnOnFail
				Popup_Busy.fnOnCancel = ifs_sessionlist_optisearch_fnOnCancel
				Popup_Busy.bNoCancel = nil -- allow cancel button
				Popup_Busy.fTimeout = 45 -- seconds
				IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
				Popup_Busy:fnActivate(1)
				this.bInOptiSearch = 1
			elseif (gOnlineServiceStr ~= "LAN") then
				-- Normal entry to screen. Go busy for a few seconds
				ifs_mp_sessionlist_fnShowHideInterface(this,1)
				ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
				Popup_Busy.bCallerSetsString = 1 -- we'll manage the text ourselves
				IFText_fnSetString(Popup_Busy.BusyTimeStr,"0%")
				Popup_Busy.fnCheckDone = ifs_sessionlist_refresh_fnCheckDone
				Popup_Busy.fnOnSuccess = ifs_sessionlist_refresh_fnOnSuccess
				Popup_Busy.fnOnFail = ifs_sessionlist_refresh_fnOnFail
				Popup_Busy.fnOnCancel = ifs_sessionlist_refresh_fnOnCancel
				Popup_Busy.bNoCancel = nil -- allow cancel button
				Popup_Busy.fTimeout = 15 -- seconds
				IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
				Popup_Busy:fnActivate(1)
			end
		else
			-- backing into screen
			ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
			if(this.bPasswordJoinOnEnter) then
				if(gPlatformStr == "XBox") then
					if(ScriptCB_IsBadNetworkConnection()) then
						ifs_mp_sessionlist_fnShowHideInterface(this,1)
						ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
						Popup_AB.CurButton = "no" -- default
						Popup_AB.fnDone = ifs_mp_sessionlist_fnBadNetworkPopupDonePassword
						Popup_AB:fnActivate(1)
						gPopup_fnSetTitleStr(Popup_AB,"ifs.mp.badconnection")
					else
						ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
					end
				else
				ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
			end
		end
		end
		this.bPasswordJoinOnEnter = nil -- always clear this.

	end,

	Exit = function(this, bFwd)
		if (bFwd) then
			-- join ends the session list on fwd transition
		else
			ScriptCB_CancelSessionList()
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if (ErrorLevel == 6) then
				-- In-session error that requires leaving it. We know we're
				-- out of it now, can do things normally.
				ScriptCB_ClearError()
				IFText_fnSetString(this.info[4],NewStr)
			end
			ifelm_shellscreen_fnPlaySound(this.exitSound)
		end
	end,

	LastPasswordStr = "",
	Input_Accept = function(this)
		-----------------------------------
		-- set to non-spectator mode 
		ScriptCB_SetSpectatorMode( 0, nil )
		if(ScriptCB_IsCurProfileDirty()) then
			ifs_saveop.doOp = "SaveProfile"
			ifs_saveop.OnSuccess = ifs_mp_sessionlist_fwd_fnSaveProfileSuccess
			ifs_saveop.OnCancel = ifs_mp_sessionlist_fwd_fnSaveProfileCancel
			local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
			ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
			ifs_saveop.saveProfileNum = iProfileIdx
			ifs_movietrans_PushScreen(ifs_saveop)
		else
			ifs_mp_sessionlist_JoinGame( this )
		end
		-----------------------------------
	end,

	Input_Back = function(this)
		if(ScriptCB_IsCurProfileDirty()) then
			ifs_saveop.doOp = "SaveProfile"
			ifs_saveop.OnSuccess = ifs_mp_sessionlist_back_fnSaveProfileSuccess
			ifs_saveop.OnCancel = ifs_mp_sessionlist_back_fnSaveProfileCancel
			local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
			ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
			ifs_saveop.saveProfileNum = iProfileIdx
			ifs_movietrans_PushScreen(ifs_saveop)
		else
			ScriptCB_PopScreen() -- just go back a screen
		end
	end,

	fnFindReady = function(this)
		if(this.bWaitingForPrevSession) then
			-- Only do this once on waiting for a previous session to be ready
			this.bWaitingForPrevSession = nil
			ifs_sessionlist_rejoinpopup_fnOnSuccess() -- fake it.
			ifs_mp_sessionlist_fnStartJoin(this)
			Popup_Busy.fTimeout = 120 -- seconds
		end
	end,

	Input_GeneralUp = function(this)
		ListManager_fnNavUp(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
	end,

	Input_GeneralDown = function(this)
		ListManager_fnNavDown(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
	end,

	Input_LTrigger = function(this)
		ListManager_fnPageUp(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
	end,

	Input_RTrigger = function(this)
		ListManager_fnPageDown(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
	end,

	Input_LTrigger2 = function(this)
	end,

	Input_RTrigger2 = function(this)
			local EntryCursor = mpsessionlist_listbox_layout.SelectedIdx
			local Selection = mpsessionlist_listbox_contents[EntryCursor]
			if(Selection) then
				ScriptCB_SetAsFavorite(EntryCursor, not Selection.bFavorite)
				mpsessionlist_listbox_layout.SelectedIdx = EntryCursor
				return
			end
	end,

	Input_Misc = function(this)
		ScriptCB_CancelSessionList()
		ifs_sessionlist_ClearSessionInfo()
		ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		ifs_mp_sessionlist_fnShowHideInterface(this,1)
		ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
		ScriptCB_SetInNetGame(nil)
		ScriptCB_BeginSessionList()
		if (gOnlineServiceStr == "XLive") then -- not this.bShowRefresh) then
			ifs_mp_sessionlist_fnShowHideInterface(this,1)
			ifs_sessionlist_joinpopup_fnShowListbox(this,nil)
			Popup_Busy.fnCheckDone = ifs_sessionlist_optisearch_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_sessionlist_optisearch_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_sessionlist_optisearch_fnOnFail
			Popup_Busy.fnOnCancel = ifs_sessionlist_optisearch_fnOnCancel
			Popup_Busy.bNoCancel = nil -- allow cancel button
			Popup_Busy.fTimeout = 45 -- seconds
			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			Popup_Busy:fnActivate(1)
			this.bInOptiSearch = 1
		else

			if (gOnlineServiceStr ~= "LAN") then
				Popup_Busy.bCallerSetsString = 1 -- we'll manage the text ourselves
				IFText_fnSetString(Popup_Busy.BusyTimeStr,"0%")
			else
				Popup_Busy.bCallerSetsString = nil -- normal busy text
			end
			Popup_Busy.fnCheckDone = ifs_sessionlist_refresh_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_sessionlist_refresh_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_sessionlist_refresh_fnOnFail
			Popup_Busy.fnOnCancel = ifs_sessionlist_refresh_fnOnCancel
			Popup_Busy.bNoCancel = nil -- allow cancel button
			if(gPlatformStr == "XBox") then
				Popup_Busy.fTimeout = 2.5 -- seconds, bug 6877
			else
				Popup_Busy.fTimeout = 15 -- seconds
			end
			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			Popup_Busy:fnActivate(1)
		end -- not XLive
	end,

	-- Misc2 (PS2: circle) changes sort mode
	Input_Misc2 = function(this)
		if(this.bCanSort) then
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
--			print("iSortMode = ", this.iSortMode)
			ScriptCB_SetSessionSortMode(this.iSortMode - 1)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		end
	end,

	-- L/R just moves the sort type cursor
	Input_GeneralLeft = function(this)
		if(not this.bIsXLive) then -- BF2 bug 10572 - can't sort in Optimatch. NM 8/16/05
			local iNumEntries = table.getn(gMPSessionList_Listbox_ColumnInfo)
			local bKeepGoing
			repeat
				bKeepGoing = nil
				this.iSortMode = this.iSortMode - 1
				if(this.iSortMode < 2) then
					this.iSortMode = iNumEntries
				end
				if(gMPSessionList_Listbox_ColumnInfo[this.iSortMode].width < 10) then
					bKeepGoing = 1
				end
			until (not bKeepGoing)
			ifs_mp_sessionlist_UpdateSortModeText(this)
		end
	end,

	Input_GeneralRight = function(this)
		if(not this.bIsXLive) then -- BF2 bug 10572 - can't sort in Optimatch. NM 8/16/05
			local iNumEntries = table.getn(gMPSessionList_Listbox_ColumnInfo)
			local bKeepGoing
			repeat
				bKeepGoing = nil
				this.iSortMode = this.iSortMode + 1
				if(this.iSortMode > iNumEntries) then
					this.iSortMode = 2
				end
				if(gMPSessionList_Listbox_ColumnInfo[this.iSortMode].width < 10) then
					bKeepGoing = 1
				end
			until (not bKeepGoing)
			ifs_mp_sessionlist_UpdateSortModeText(this)
		end
	end,

	fExtraInfoTimer = 1.0,
	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
		ScriptCB_UpdateSessionList()

		this.fExtraInfoTimer = this.fExtraInfoTimer - fDt

		-- If the selection changes, then blank the extra info box.
		-- A future refresh should catch it.
		if(mpsessionlist_listbox_layout.SelectedIdx) then
			local Selection = mpsessionlist_listbox_contents[mpsessionlist_listbox_layout.SelectedIdx]
			local CurServerStr = "<undef>"
			if (Selection) then
				CurServerStr = Selection.namestr
			end

			if((this.sLastServerStr ~= CurServerStr) or (this.fExtraInfoTimer < 0)) then
				this.sLastServerStr = CurServerStr
				this.fExtraInfoTimer = 1.0

				ScriptCB_GetExtraSessionInfo()
			end
		end
	end,

	-- Zaps the listbox to empty. Used to clean out lua memory, glyphcache
	ClearListbox = function(this)
		gBlankListbox = 1
		mpsessionlist_listbox_layout.CursorIdx = mpsessionlist_listbox_layout.SelectedIdx
		ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		this.iNumSessions = 0
		this.iNumPlayers = 0
		this.iMaxPlayers = 0

--		ifs_mp_sessionlist_fnShowStats(this)
		gBlankListbox = nil
		mpsessionlist_listbox_contents = {} -- clear out completely.
	end,

	-- Callback from C to repaint the listbox. Done when the game notices
	-- the contents of that listbox have changed and it needs to trigger
	-- a repaint. The contents should be in the lua global
	-- mpsessionlist_listbox_contents
	RepaintListbox = function(this, bNoCursorSnap)
		local NumEntries = table.getn(mpsessionlist_listbox_contents)

		if(not bNoCursorSnap) then
			if(NumEntries < 1) then
				mpsessionlist_listbox_layout.SelectedIdx = nil
			else
				if((not mpsessionlist_listbox_layout.SelectedIdx) or (mpsessionlist_listbox_layout.SelectedIdx < 1)) then
					mpsessionlist_listbox_layout.SelectedIdx = 1
				elseif (mpsessionlist_listbox_layout.SelectedIdx > NumEntries) then
					mpsessionlist_listbox_layout.SelectedIdx = NumEntries
				end
			end
		end

		mpsessionlist_listbox_layout.CursorIdx = mpsessionlist_listbox_layout.SelectedIdx
		ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
	end,

	-- Callback from C to repaint the extra session info about the selected
	-- session
	RepaintExtraInfo = function(this)
		local NumEntries = table.getn(mpsessionlist_serverinfo_contents)
		if(NumEntries < 1) then
			ifs_mp_sessionlist_fnBlankExtraInfo(this)
			return -- bail if nothing else to do.
		end

		local Selection
		if(mpsessionlist_listbox_layout.SelectedIdx) then
			Selection = mpsessionlist_listbox_contents[mpsessionlist_listbox_layout.SelectedIdx]
			if(not Selection) then
				ifs_mp_sessionlist_fnBlankExtraInfo(this)
				return -- nothing else to do
			end
		else
			ifs_mp_sessionlist_fnBlankExtraInfo(this)
			return -- nothing else to do
		end

		-- Have enough data to fill the bottom info boxes. Do so.
		ifs_mp_sessionlist_fnFillExtraInfo(this, Selection)
	end,
		

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
		print("ifs_mp_sessionlist fnPostError(..,",bUserHitYes,ErrorLevel)
		if(ErrorLevel >= 6) then
			ScriptCB_PopScreen()
		end

		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end

	end,
}


-- Do programatic work to set up this screen
function ifs_mp_sessionlist_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	local smallH = ScriptCB_GetFontHeight("gamefont_small")
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local XPos

	this.title.textw = w
	this.title.x = w * -0.5 -- re-center text
	local ExtraYOffset = 0

	if(gPlatformStr == "XBox") then
		mpsessionlist_listbox_layout.showcount = 8
		ExtraYOffset = 15
	else
		this.title.font = "gamefont_medium"
	end

	local BoxW = w * 1.01 -- put border slightly into safezone
	local SessionBoxH = mpsessionlist_listbox_layout.showcount * (mpsessionlist_listbox_layout.yHeight + mpsessionlist_listbox_layout.ySpacing) + 20


	-- Calculate widths of columns for main list
	if(gPlatformStr == "XBox") then
		gMPSessionList_Listbox_ColumnInfo[1].width = 2 -- 'favorite' -- turned off on XBox
	end
	gMPSessionList_Listbox_ColumnInfo[2].width = 0.35*BoxW - 30 -- Game name
	gMPSessionList_Listbox_ColumnInfo[3].width = 80 -- # players -- 50
	gMPSessionList_Listbox_ColumnInfo[4].width = 0.35*BoxW - 30 -- mapname -- 
-- 	gMPSessionList_Listbox_ColumnInfo[4].width = 0.185*BoxW - 5 -- era -- 
	gMPSessionList_Listbox_ColumnInfo[5].width = 60 -- ping -- 30

	this.listbox = NewButtonWindow { 
		ZPos = 200, x=0, y = 45+0.5*SessionBoxH + ExtraYOffset,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		width = BoxW, height = SessionBoxH, titleText = " ",
		font = "gamefont_small",
	}

--	Temp.indexfield = NewIFText{ x = 10, y = 0, halign = "left", font = "gamefont_medium", nocreatebackground=1, }
	mpsessionlist_listbox_layout.width = BoxW - 35	
	ListManager_fnInitList(this.listbox,mpsessionlist_listbox_layout)

	-- 
	-- Make the resort buttons
	--

	this.ResortButtons = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.0,
--		y = 7,
	}

	local labelY = this.listbox.y-0.5*SessionBoxH-smallH-5
	XPos = BoxW * -0.5 + 10
	local NumColumns = table.getn(gMPSessionList_Listbox_ColumnInfo)
	for i=1,NumColumns do
		local NewLabel = gMPSessionList_Listbox_ColumnInfo[i].tag .. "Label"
		local UseWidth = gMPSessionList_Listbox_ColumnInfo[i].width
		if(i == NumColumns) then
			UseWidth = UseWidth + 15 -- Fix for 2887 - more space for 'Connection' on XBox
		end

		-- Center Game name, map name columns (fixes BF2 bug 4541, NM 7/18/05)
		local HAlign = "left"
		if((i == 2) or (i == 4)) then
			HAlign = "hcenter"
		end

		this.ResortButtons[NewLabel] = NewIFText {
			x = XPos, y = labelY, 
			textcolorr = 0, textcolorg = 0, textcolorb = 0,
			textw = UseWidth, 
			font = "gamefont_tiny", halign = HAlign, 
			string = gMPSessionList_Listbox_ColumnInfo[i].string, 
--			HScale = 0.75,
--			VScale = 1,
			nocreatebackground=1,
		}
		this.ResortButtons[NewLabel].x = XPos

		XPos = XPos + gMPSessionList_Listbox_ColumnInfo[i].width
	end

	--
	-- Game Info window, items within the game info window
	-- 

	local itemW = mpsessionlist_listbox_layout.width
	local InfoWidthL = BoxW * 0.5
	local labelY = this.listbox.y-0.5*SessionBoxH-smallH-5
	
	local InfoHScale = 1

	if((gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
		if (gLangStr == "french") then
			InfoHScale = 0.7 -- fix for BF2 bug 7567, 10406, 10490, 10491 - these strings are HUGE :(
		else
			InfoHScale = 0.75 -- fix for BF2 bug 7567, 10406, 10490, 10491 - these strings are HUGE :(
		end
	end

	if(gLangStr == "german") then
		InfoWidthL = InfoWidthL + 10 -- need more space for left column
	elseif (gLangStr == "spanish") then
		if(gPlatformStr == "XBox") then
			-- BF2 bug 11276 - not so much space on XBox
			InfoWidthL = InfoWidthL + 25 -- need lots more space for left column
		else
			InfoWidthL = InfoWidthL + 50 -- need lots more space for left column
		end
	elseif (gLangStr == "french") then
		InfoWidthL = InfoWidthL + 25 -- need more space for left column
	end

	local InfoWidthR = BoxW - InfoWidthL
	local InfoBoxH = 6 * tinyH + 15
	this.info = NewButtonWindow { 
		ZPos = 200, 
		x = 0, --BoxW * -0.5,
		y = this.listbox.y+0.5*this.listbox.height+26+0.5*InfoBoxH + 5,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top
		width = BoxW, height = InfoBoxH, titleText = "ifs.mp.sessionlist.gameinfo",
		font = "gamefont_tiny",
	}

	local i
	for i=1,6 do
		this.info[i] = NewIFText{ 
			x = BoxW * -0.5 + 5, y = 5+(i-1)*tinyH-0.5*InfoBoxH, 
			textw = InfoWidthL + 10, halign="left", font="gamefont_tiny", nocreatebackground=1,
			HScale = InfoHScale, VScale = 1, -- compress text
		}
	end
	for i=7,12 do
		this.info[i] = NewIFText{ 
			x = BoxW * -0.5 + 5 + InfoWidthL + 5, y = 5+(i-7)*tinyH-0.5*InfoBoxH, 
			textw = InfoWidthR + 10, halign="left", font="gamefont_tiny", nocreatebackground=1,
			HScale = InfoHScale, VScale = 1, -- compress text
		}
	end
	
--	labelY = this.info.y-0.5*InfoBoxH-smallH-5

	if(gLangStr ~= "english") then
		this.listbox.titleBarElement.font = "gamefont_small"
--		this.info.titleBarElement.font = "gamefont_small"
		this.Helptext_Refresh.helpstr.font = "gamefont_tiny"
		this.Helptext_SortMode.helpstr.font = "gamefont_tiny"
		this.Helptext_R2.helpstr.font = "gamefont_tiny"
		this.Helptext_Accept.helpstr.font = "gamefont_tiny"
		this.Helptext_Back.helpstr.font = "gamefont_tiny"
 		this.Helptext_Refresh.helpstr.HScale = 0.9
 		this.Helptext_SortMode.helpstr.HScale = 0.9
 		this.Helptext_Refresh.helpstr.VScale = 1
 		this.Helptext_SortMode.helpstr.VScale = 1

		this.listbox.titleBarElement.HScale = 0.8
		this.listbox.titleBarElement.VScale = 1
		this.info.titleBarElement.HScale = 0.8
		this.info.titleBarElement.VScale = 1
	end

	this.Helptext_R2.icon.localpos_l = this.Helptext_R2.icon.localpos_l - 4
	this.Helptext_R2.icon.localpos_r = this.Helptext_R2.icon.localpos_r + 4
	this.Helptext_R2.icon.localpos_b = this.Helptext_R2.icon.localpos_b + 2

	if(gLangStr == "spanish") then
		this.title.font = "gamefont_small"
	end

	-- Fix for 10509 - move helptext icons up so they don't get bisected visually
	-- by the background on this screen - NM 8/23/05
	if((gLangStr ~= "english") and (gPlatformStr == "PS2")) then
		this.Helptext_Refresh.y = -48
		this.Helptext_SortMode.y = -48
		this.Helptext_R2.y = -67
	end

end

ifs_mp_sessionlist_fnBuildScreen(ifs_mp_sessionlist)
ifs_mp_sessionlist_fnBuildScreen = nil

AddIFScreen(ifs_mp_sessionlist,"ifs_mp_sessionlist")
