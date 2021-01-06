--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Multiplayer list of sessions screen. For XBox Optimatch or Gamespy
-- "pick a game to join" screen.
local mp_tab_ypos = 45
local opt_tab_width = 158.5

gPCMultiPlayerTabsLayout = {
	{ tag = "_tab_join",		string = "ifs.mp.tabs.join",		screen = "ifs_mp_sessionlist",		  xPos = 87, width = opt_tab_width, yPos = mp_tab_ypos, },
	{ tag = "_tab_create",		string = "ifs.mp.tabs.create",		screen = "ifs_missionselect_pcMulti", width = opt_tab_width, yPos = mp_tab_ypos, },
	--{ tag = "_tab_mp_opt",		string = "ifs.mp.tabs.options",		screen = "ifs_opt_mp",				  xPos = 320,width = 133, yPos = mp_tab_ypos, },
	{ tag = "_tab_gamespy",		string = "ifs.mp.tabs.gamespy",		screen = "ifs_mpgs_login",			  width = opt_tab_width, yPos = mp_tab_ypos, },
	{ tag = "_tab_friends",		string = "ifs.mp.tabs.friends",		screen = "ifs_mpgs_friends",		  width = opt_tab_width, yPos = mp_tab_ypos, },
	{ tag = "_tab_leaderboard", string = "ifs.mp.tabs.leaderboard",	screen = "ifs_mp_leaderboard",		  width = opt_tab_width, yPos = mp_tab_ypos, },
}

gMPSessionList_Listbox_ColumnInfo = {
	{ width = 40, tag = "favorite", string = "ifs.mp.sessionlist.favorite", maxchars = -1, }, -- Server name -- 0.28*layout.width-5
	{ width = 50, tag = "gamename", string = "ifs.mp.sessionlist.gamename", maxchars = 20, }, -- Server name -- 0.28*layout.width-5
	{ width = 60, tag = "numplayers", string = "ifs.mp.sessionlist.numplayers", maxchars = 2, }, -- # players -- 50
	{ width = 30, tag = "mapname", string = "ifs.onlinelobby.map", maxchars = -1, }, -- mapname -- 0.23*layout.width-5
	{ width = 30, tag = "gamemode", string = "ifs.mp.join.mode", maxchars = -1, }, -- gamemode -- 0.23*layout.width-5
	{ width = 50, tag = "era", string = "ifs.meta.Configs.era", maxchars = -1, }, -- era -- 0.19*layout.width-5
	{ width = 40, tag = "ping", string = "ifs.mp.sessionlist.ping", maxchars = 4, },  -- ping -- 40
	{ width = 200, tag = "servertypeLabel", string = "ifs.mp.sessionlist.servertype", maxchars = -1,}, -- rest of space goes to 'server type
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local XPos = 5
	local YPos = layout.height * -0.5 + 3
	local ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[1].width
	Temp.isfavorite = NewIFImage {
		x = XPos, y = YPos,
--		texture = "check", -- set below
		localpos_l = 1, localpos_t = 1,
		localpos_r = 14, localpos_b = 14,
		AutoHotspot = 1, tag = "check",
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[2].width
	Temp.namefield = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[3].width
	Temp.numplayers = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[4].width
	Temp.map = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[5].width
	Temp.gamemode = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[6].width
	Temp.eraname = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	XPos = XPos + ColumnWidth
	local IconHeight = layout.height * 0.75
	Temp.eraicon1 = NewIFImage {
		ZPos = 240, 
		localpos_l = XPos - 25 - IconHeight,
		localpos_r = XPos - 25,
		localpos_t = (IconHeight * -0.5) + 3,
		localpos_b = (IconHeight * 0.5) + 3,
		--ColorR = 240,
		--ColorG = 32,
		--ColorB = 32,
	}
	Temp.eraicon2 = NewIFImage {
		ZPos = 240, 
		localpos_l = XPos - 25 - IconHeight - IconHeight,
		localpos_r = XPos - 25 - IconHeight,
		localpos_t = (IconHeight * -0.5) + 3,
		localpos_b = (IconHeight * 0.5) + 3,
		--ColorR = 32,
		--ColorG = 240,
		--ColorB = 32,
	}

	ColumnWidth = gMPSessionList_Listbox_ColumnInfo[7].width
	Temp.pingtext = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
		string = "456",
	}
	XPos = XPos + ColumnWidth

	ColumnWidth = layout.width - 15 - XPos -- allocate 'rest' to server type
	gMPSessionList_Listbox_ColumnInfo[8].width = ColumnWidth -- and store for later
	Temp.servertype = NewIFText {
		x = XPos, y = YPos,
		textw = ColumnWidth, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}
	XPos = XPos + ColumnWidth
	
	Temp.lockicon = NewIFImage { texture = "lock_icon",
		localpos_l = layout.width-tinyH-1,
		localpos_t = 6-10,
		localpos_r = layout.width-1,
		localpos_b = tinyH+4-10 }
	Temp.mapname = ""
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
function MPSessionList_Listbox_PopulateItem(Dest,Data)

	if((gBlankListbox) or ((not Data))) then
		IFText_fnSetString(Dest.namefield,"")
		IFText_fnSetString(Dest.numplayers,"")
		IFText_fnSetString(Dest.map,"")
		IFText_fnSetString(Dest.gamemode,"")
		IFText_fnSetString(Dest.eraname,"")
		IFText_fnSetString(Dest.pingtext,"")
		IFText_fnSetString(Dest.servertype,"")
		IFObj_fnSetVis(Dest.lockicon,nil) -- turn off locked icon
		IFObj_fnSetVis(Dest.isfavorite,nil) -- turn off favorite icon
	else
		IFText_fnSetString(Dest.numplayers,Data.numplayers)
		IFText_fnSetString(Dest.namefield,Data.namestr)
--		IFObj_fnSetVis(Dest.lockedgame,Data.lockedgame)

		if(Data.bFavorite) then
			IFImage_fnSetTexture(Dest.isfavorite, "check_yes")
		else
			IFImage_fnSetTexture(Dest.isfavorite, "check_no")
		end
		IFObj_fnSetVis(Dest.isfavorite, 1)

		if(Data.bWrongVer) then
			IFImage_fnSetTexture(Dest.lockicon, "version_icon")
			IFObj_fnSetVis(Dest.lockicon,1)
		elseif (Data.bLocked) then
			IFImage_fnSetTexture(Dest.lockicon, "lock_icon")
			IFObj_fnSetVis(Dest.lockicon,1)
		else
			IFObj_fnSetVis(Dest.lockicon,nil) -- turn off icon
		end

		if(Data.pingint) then
			if(Data.pingint<9990) then
				IFText_fnSetString(Dest.pingtext,string.format("%d", Data.pingint))
			else
				local strNA = ScriptCB_usprintf("ifs.Stats.na")
				IFText_fnSetUString(Dest.pingtext,strNA)
			end
		end

		local MapStr = string.upper(Data.mapname)

		-- Figure out era by finding the character before the first _ in the mapname
		-- [Far more reliable for when modders get involved - NM 9/28/05]
		local i,LastSideChar,SideChar,MapNameLen
		MapNameLen = string.len(MapStr)
		for i = 1,MapNameLen do
			local ThisChar = string.sub(MapStr,i,i) -- 'G' or 'C'
			if((ThisChar == "_") and not SideChar) then
				SideChar = string.lower(LastSideChar)
			else
				LastSideChar = ThisChar
			end
		end

		local DisplayUStr,iSource = missionlist_GetLocalizedMapName(Data.mapname)
		
		if(iSource ~= 2) then
			IFObj_fnSetColor(Dest.map, 255, 255, 255)
		else
			DisplayUStr = ScriptCB_usprintf("ifs.mp.sessionlist.map_missing", DisplayUStr)
			IFObj_fnSetColor(Dest.map, 255, 255, 0)
		end
		IFText_fnSetUString(Dest.map, DisplayUStr)	
		
		-- set gamemode
--		print( "+++mapname = ", Data.mapname )
		local MapMode = missionlist_GetMapMode(Data.mapname)
		if(MapMode) then
			IFText_fnSetString(Dest.gamemode, MapMode.showstr)
		else
			IFText_fnSetString(Dest.gamemode, "")
		end

		IFText_fnSetString(Dest.eraname, SideChar)
		IFObj_fnSetVis(Dest.eraname, 1)
		IFObj_fnSetVis(Dest.eraicon1, nil)
		IFObj_fnSetVis(Dest.eraicon2, nil)
		for i = 1,table.getn(gMapEras) do
			if(SideChar == gMapEras[i].subst) then
				IFObj_fnSetVis(Dest.eraname, nil)
				IFImage_fnSetTexture(Dest.eraicon1, gMapEras[i].icon1)
				IFImage_fnSetTexture(Dest.eraicon2, gMapEras[i].icon2)
				IFObj_fnSetVis(Dest.eraicon1, 1)
				IFObj_fnSetVis(Dest.eraicon2, 1)
			end
		end
		-- only show one icon
		IFObj_fnSetVis(Dest.eraicon1, nil)
		
		if(Data.servertype == 1) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.pc")
		elseif (Data.servertype == 2) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.pcdedicated")
		elseif (Data.servertype == 3) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.ps2")
		elseif (Data.servertype == 4) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.ps2dedicated")
		elseif (Data.servertype == 5) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.xbox")
		elseif (Data.servertype == 6) then
			IFText_fnSetString(Dest.servertype,"ifs.mp.sessionlist.servertypes.xboxdedicated")
		else
			IFText_fnSetString(Dest.servertype,"") -- blank the data
		end
		Dest.mapname = Data.mapname
	end

	-- Show it if data is present, hide if no data
	IFObj_fnSetVis(Dest,Data)
end

mpsessionlist_listbox_layout = {
	showcount = 6,
	yTop = -130 + 47,  -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = MPSessionList_Listbox_CreateItem,
	PopulateFn = MPSessionList_Listbox_PopulateItem,
}

mpsessionlist_listbox_contents = {
	-- Filled in from C++ now. NM 8/7/03
	-- Stubbed to show the format it wants.
--	{ indexstr = "1", namestr = "Alpha"},
--	{ indexstr = "2", namestr = "Bravo"},
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_ServerInfo_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_ServerInfo_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		IFText_fnSetUString(Dest.text,Data.text)
		IFObj_fnSetVis(Dest.text,1)
	else
		IFObj_fnSetVis(Dest.text,nil)
	end
end

mpsessionlist_serverinfo_layout = {
	showcount = 6,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = MPSessionList_ServerInfo_CreateItem,
	PopulateFn = MPSessionList_ServerInfo_PopulateItem,
}

mpsessionlist_serverinfo_contents = {
	-- Filled in from C++ - NM 10/5/04
}


-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_PlayerList_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	local XPos = 10
	Temp.text = NewIFText {
		x = XPos, y = YPos,
		textw = layout.width * 0.65 - 10, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	XPos = XPos + layout.width * 0.55 - layout.width * 0.1 + 15
	Temp.points = NewIFText {
		x = XPos, y = YPos,
		textw = layout.width * 0.1, texth = layout.height,
		halign = "right", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	XPos = XPos + layout.width * 0.1
	Temp.kills = NewIFText {
		x = XPos, y = YPos,
		textw = layout.width * 0.1, texth = layout.height,
		halign = "right", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	XPos = XPos + layout.width * 0.1
	Temp.deaths = NewIFText {
		x = XPos, y = YPos,
		textw = layout.width * 0.1, texth = layout.height,
		halign = "right", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	XPos = XPos + layout.width * 0.1
	Temp.heropoints = NewIFText {
		x = XPos, y = YPos,
		textw = layout.width * 0.1, texth = layout.height,
		halign = "right", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_PlayerList_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		-- Just wipe out the contents
		IFText_fnSetString(Dest.text,"")
		IFText_fnSetString(Dest.kills,"")
		IFText_fnSetString(Dest.deaths,"")
		IFText_fnSetString(Dest.points,"")
		IFText_fnSetString(Dest.heropoints,"")
	elseif (Data) then
		IFText_fnSetUString(Dest.text,Data.text)
		if(Data.kills) then
			IFText_fnSetString(Dest.kills,string.format("%s",Data.kills))
			IFText_fnSetString(Dest.deaths,string.format("%s",Data.deaths))
			IFText_fnSetString(Dest.points,string.format("%s",Data.points))
			IFText_fnSetString(Dest.heropoints,string.format("%s",Data.heropoints))
		end
		IFObj_fnSetVis(Dest,1)
	else
		IFObj_fnSetVis(Dest,nil)
	end
end

mpsessionlist_playerlist_layout = {
	showcount = 6,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
--	width = 260,
	x = 0,
	slider = 1,
	CreateFn = MPSessionList_PlayerList_CreateItem,
	PopulateFn = MPSessionList_PlayerList_PopulateItem,
}

mpsessionlist_playerlist_contents = {
	-- Filled in from C++ - NM 10/5/04
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Servertypelist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_Servertypelist_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		IFText_fnSetString(Dest.text,Data.text)
		IFObj_fnSetVis(Dest.text,1)
	else
		IFObj_fnSetVis(Dest.text,nil)
	end
end

mpsessionlist_servertypelist_layout = {
	showcount = 3,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 15,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1, -- not with 3 items
	CreateFn = MPSessionList_Servertypelist_CreateItem,
	PopulateFn = MPSessionList_Servertypelist_PopulateItem,
}

mpsessionlist_servertypelist_contents = {
	{ text = "ifs.gsprofile.all", },
	{ text = "ifs.mp.sessionlist.servertypes.pc", },
	{ text = "ifs.mp.sessionlist.servertypes.pcdedicated", },
}


-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Eratypelist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	local IconHeight = layout.height * 0.75

	Temp.icon1 = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 3,
		localpos_b = (IconHeight * 0.5) + 3,
		--ColorR = 240,
		--ColorG = 32,
		--ColorB = 32,
	}
	
	Temp.icon = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 3,
		localpos_b = (IconHeight * 0.5) + 3,
		--ColorR = 32,
		--ColorG = 240,
		--ColorB = 32,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_Eratypelist_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		IFText_fnSetString(Dest.text,Data.text)
		IFObj_fnSetVis(Dest.text,1)
		
		-- Find icons out of list of installed eras [Better for modders!]
		local i
		IFObj_fnSetVis(Dest.icon,nil) -- hide, incase not found
		IFObj_fnSetVis(Dest.icon1,nil)
		for i = 1,table.getn(gMapEras) do
			if(Data.text == gMapEras[i].showstr) then
				IFImage_fnSetTexture(Dest.icon1, gMapEras[i].icon1)
				IFImage_fnSetTexture(Dest.icon, gMapEras[i].icon2)
				IFObj_fnSetVis(Dest.icon,1)
				IFObj_fnSetVis(Dest.icon1,1)
			end
		end
		-- show only one icon
		IFObj_fnSetVis(Dest.icon1,nil)
	else
		IFObj_fnSetVis(Dest.text,nil)
		IFObj_fnSetVis(Dest.icon,nil)
		IFObj_fnSetVis(Dest.icon1,nil)
	end
end

mpsessionlist_eratypelist_layout = {
	showcount = 3,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 15,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1, -- not with 3 items
	CreateFn = MPSessionList_Eratypelist_CreateItem,
	PopulateFn = MPSessionList_Eratypelist_PopulateItem,
}

mpsessionlist_eratypelist_contents = {
	{ text = "ifs.gsprofile.all", },
	-- Filled in automagically out of gMapEras now - NM 9/28/05
--	{ text = "common.era.cw", },
--	{ text = "common.era.gcw", },
}

----------------------------------------------------
----------------------------------------------------
-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Gamemodelist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 4
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	local IconHeight = layout.height * 0.75

	Temp.icon = NewIFImage {
		ZPos = 240, 
		localpos_l = layout.width - 5 - IconHeight,
		localpos_r = layout.width - 5,
		localpos_t = (IconHeight * -0.5) + 3,
		localpos_b = (IconHeight * 0.5) + 3,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_Gamemodelist_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		IFText_fnSetString( Dest.text, Data.string )
		IFObj_fnSetVis( Dest.text, 1 )
		
		-- If Data.icon exists, set the texture on it.
		if(Data.icon) then
			IFImage_fnSetTexture(Dest.icon, Data.icon)
			IFObj_fnSetVis( Dest.icon, 1 )
		else
			IFObj_fnSetVis( Dest.icon, nil )
		end		
	else
		IFObj_fnSetVis( Dest.text, nil )
		IFObj_fnSetVis( Dest.icon, nil )
	end
end

mpsessionlist_gamemodelist_layout = {
	showcount = 6,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 15,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1, -- not with 3 items
	CreateFn = MPSessionList_Gamemodelist_CreateItem,
	PopulateFn = MPSessionList_Gamemodelist_PopulateItem,
}

mpsessionlist_gamemodelist_contents = {
		{ string = "ifs.gsprofile.all",				subst = "ifs.gsprofile.all", icon = nil, },
		{ string = "ifs.mp.leaderboard.conquest",	subst = "con",				 icon = "mode_icon_con", },
		{ string = "ifs.mp.leaderboard.CTF2",		subst = "ctf",				 icon = "mode_icon_2ctf", },
		{ string = "ifs.mp.leaderboard.CTF1",		subst = "1flag",			 icon = "mode_icon_ctf", },
--		{ string = "ifs.mp.leaderboard.objective",	subst = "obj", },
--		{ string = "ifs.mp.leaderboard.teamdm",		subst = "tdm", },
		{ string = "modename.name.assault",			subst = "ass", 				 icon = "mode_icon_ass", },
		{ string = "modename.name.hunt",			subst = "hunt", 			 icon = "mode_icon_hunt", },
}
----------------------------------------------------
----------------------------------------------------

----------------------------------------------------
----------------------------------------------------
-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_favlist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_favlist_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		IFText_fnSetString( Dest.text, Data.string )
		IFObj_fnSetVis( Dest.text, 1 )
	else
		IFObj_fnSetVis( Dest.text, nil )
	end
end

mpsessionlist_favlist_layout = {
	showcount = 3,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 15,
	ySpacing  = 0,
--	width = 260,
	x = 0,
--	slider = 1, -- not with 3 items
	CreateFn = MPSessionList_favlist_CreateItem,
	PopulateFn = MPSessionList_favlist_PopulateItem,
}

mpsessionlist_favlist_contents = {
		{ string = "ifs.gsprofile.all",				},
		{ string = "ifs.mp.join.fav",				},
		{ string = "ifs.mp.join.not_fav",			},
}
----------------------------------------------------
----------------------------------------------------

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function MPSessionList_Maplist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_super_tiny", nocreatebackground=1,
	}

	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function MPSessionList_Maplist_PopulateItem(Dest,Data)
	if(gBlankListbox) then
		IFText_fnSetString(Dest.text,"")
	elseif (Data) then
		local MapNameUStr
		if(Data.showstr == "ifs.gsprofile.all") then
			MapNameUStr = ScriptCB_getlocalizestr("ifs.gsprofile.all")
		else
			MapNameUStr = missionlist_GetLocalizedMapName(Data.mapluafile)
		end

		IFText_fnSetUString(Dest.text,MapNameUStr)
		IFObj_fnSetVis(Dest.text,1)
	else
		IFObj_fnSetVis(Dest.text,nil)
	end
end

-- Filled in below
mpsessionlist_maplist_contents = {
	{ showstr = "ifs.gsprofile.all", mapluafile = "ifs.gsprofile.all"},
}

mpsessionlist_maplist_layout = {
	showcount = 3,
--	yTop = -130 + 13,  -- auto-calc'd now
	yHeight = 15,
	ySpacing  = -4,
--	width = 260,
	x = 0,
--	slider = 1, -- not with 3 items
	CreateFn = MPSessionList_Maplist_CreateItem,
	PopulateFn = MPSessionList_Maplist_PopulateItem,
}

function ifs_mp_sessionlist_back_fnSaveProfileSuccess()
	--  print("ifs_mpps2_optimatch_fnSaveProfileSuccess")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Back up one more screen (to mpps2_optimatch)
	ScriptCB_PopScreen()
	    ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end

function ifs_mp_sessionlist_back_fnSaveProfileCancel()
	-- print("ifs_mp_sessionlist_back_fnSaveProfileCancel")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	-- Back up one more screen (to mpps2_optimatch)
	ScriptCB_PopScreen()
	--    ifs_movietrans_PushScreen(ifs_mp_sessionlist)
end

function ifs_mp_sessionlist_fwd_fnSaveProfileSuccess()
	--  print("ifs_mp_sessionlist_fwd_fnSaveProfileSucces")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	ifs_mp_sessionlist_fnStartJoin(this)
end

function ifs_mp_sessionlist_fwd_fnSaveProfileCancel()
	--  print("ifs_mpps2_optimatch_fnSaveProfileCancel")
	local this = ifs_mp_sessionlist
	
	-- exit ifs_saveop
	ScriptCB_PopScreen()
	ifs_mp_sessionlist_fnStartJoin(this)
end


-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_joinpopup_fnCheckDone()
--	local this = ifs_sessionlist_joinpopup
	ScriptCB_UpdateJoin() -- think...

	return ScriptCB_IsJoinDone()
end

function ifs_sessionlist_joinpopup_fnOnSuccess()
	--
	-- show listbox again, just in case we cancel on the next screen
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)

	Popup_Busy:fnActivate(nil)
	
	ScriptCB_LaunchJoin()
	--ifs_movietrans_PushScreen(ifs_mp_lobby)
	-- go to the quick lunch lobby
	ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
end

function ifs_sessionlist_joinpopup_fnOnFail()
	print("Join failed")

	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)

 	Popup_Busy:fnActivate(nil)
	ScriptCB_SetInNetGame(nil)
	ScriptCB_CancelSessionList()
	ScriptCB_BeginSessionList()
-- 	Popup_YesNo.CurButton = "no" -- default
-- 	Popup_YesNo.fnDone = ifs_xlive_main_fnAskCreateDone
-- 	Popup_YesNo:fnActivate(1)
-- 	gPopup_fnSetTitleStr(Popup_YesNo,"ifs.quickopti.nonefound")
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_joinpopup_fnOnCancel()
	print("Join canceled")
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

-- Callbacks from the busy popup
-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_sessionlist_rejoinpopup_fnCheckDone()
--	local this = ifs_sessionlist_joinpopup
	ScriptCB_UpdateSessionList()  -- think...
	return 0 -- still busy
end

function ifs_sessionlist_rejoinpopup_fnOnSuccess()
	print("reJoin success")
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
-- 	Popup_YesNo:fnActivate(1)
-- 	gPopup_fnSetTitleStr(Popup_YesNo,"ifs.quickopti.nonefound")
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_rejoinpopup_fnOnCancel()
	local this = ifs_mp_sessionlist

	print("reJoin cancel")
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
	ScriptCB_UpdateSessionList()  -- think...
	return 0 -- still busy
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

-- Returns -1, 0, or 1, depending on error, busy, or success
function ifs_mp_sessionlist_buddymatch_fnCheckDone()
--	local this = ifs_mp_sessionlist_buddymatch
	ScriptCB_UpdateQuickmatch() -- think...

	return ScriptCB_IsQuickmatchDone()
end

function ifs_mp_sessionlist_buddymatch_fnOnSuccess()
	local this = ifs_mp_sessionlist
--	print(" ** ifs_mp_sessionlist_buddymatch_fnOnSuccess")
	Popup_Busy:fnActivate(nil)

	if(ScriptCB_IsQuickmatchPassworded()) then
		if(gPlatformStr == "PC") then
			if( ScriptCB_IsGamespyArcadePasswordReady() ) then
				-- go into game if password is ready
				ScriptCB_LaunchQuickmatch()
				ifs_missionselect.bForMP = 1
				ifs_movietrans_PushScreen(ifs_mp_lobby_quick)				
			else
				this.bSpecialJoinPass = 1
				--print("+++show password box")
				IFObj_fnSetVis(this.PassBox, 1) -- show it now...
				this.PassBox.passedit.bKeepsFocus = 1
				gCurEditbox = this.PassBox.passedit
			end
		else
			ifs_vkeyboard.CurString = ScriptCB_tounicode("")
			ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
			vkeyboard_specs.bPasswordMode = 1
			
			IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
			vkeyboard_specs.fnDone = ifs_mp_main_fnKeyboardDone
			vkeyboard_specs.fnIsOk = ifs_mp_main_fnIsAcceptable
			
			local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
			vkeyboard_specs.MaxWidth = (w * 0.5)
			vkeyboard_specs.MaxLen = 16
			ifs_movietrans_PushScreen(ifs_vkeyboard)
		end
	else

		ScriptCB_LaunchQuickmatch()
		ifs_missionselect.bForMP = 1
		ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
	end
end

function ifs_mp_sessionlist_buddymatch_fnPostOKPopup()
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this, nil) -- show interface
end


function ifs_mp_sessionlist_buddymatch_fnOnFail()
--	print("Special search failed")

	Popup_Busy:fnActivate(nil)
--	print(" ** ifs_main_specialmatch_fnOnFail")
	Popup_Ok_Large.fnDone = ifs_mp_sessionlist_buddymatch_fnPostOKPopup
	Popup_Ok_Large:fnActivate(1)

	-- Fix for 12139 - only XBox has this string. Other platforms get error in
	-- common localize file.
	if(gPlatformStr == "XBox") then
		gPopup_fnSetTitleStr(Popup_Ok_Large, "xlive.errors.sessionnotavailable")
	else
		gPopup_fnSetTitleStr(Popup_Ok_Large, "ifs.mp.joinerrors.noconnect")
	end

end

-- User hit cancel. Do what they want.
function ifs_mp_sessionlist_buddymatch_fnOnCancel()
	local this = ifs_mp_sessionlist

	-- Stop logging in.
	ScriptCB_CancelQuickmatch()

	-- Get rid of popup, turn this screen back on
	Popup_Busy:fnActivate(nil)
--	print(" ** ifs_mp_sessionlist_buddymatch_fnOnCancel")
	ifs_mp_sessionlist_fnShowHideInterface(this, nil) -- show interface
end


function ifs_sessionlist_optisearch_fnOnFail()
	print("optisearch OnFail")

	local this = ifs_mp_sessionlist
 	Popup_Busy:fnActivate(nil)

 	Popup_YesNo.CurButton = "no" -- default
 	Popup_YesNo.fnDone = ifs_mp_sessionlist_fnAskCreateDone
 	Popup_YesNo:fnActivate(1)
	gPopup_fnSetTitleStr(Popup_YesNo, "ifs.quickopti.nonefound")

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
--	local this = ifs_sessionlist_joinpopup

	-- Jump to top of listbox as long as we're up.
	if(table.getn(mpsessionlist_listbox_contents) > 0) then
		mpsessionlist_listbox_layout.SelectedIdx = 1
	end
	ScriptCB_UpdateSessionList()  -- think...

	if((gOnlineServiceStr ~= "LAN") and (ScriptCB_GetSessionListPercent)) then
		local iPercentDone = ScriptCB_GetSessionListPercent()
		if(iPercentDone > 100) then
			return 1
		end
		local ShowStr = string.format("%d%%", iPercentDone)
		IFText_fnSetString(Popup_Busy.BusyTimeStr,ShowStr)
	end

	return 0 -- still busy
end

function ifs_sessionlist_refresh_fnOnSuccess()
	print("refresh success")
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
end

function ifs_sessionlist_refresh_fnOnFail()
	print("refresh failed")
	local this = ifs_mp_sessionlist
	ifs_mp_sessionlist_fnShowHideInterface(this,nil)
	ifs_sessionlist_joinpopup_fnShowListbox(this,1)
	Popup_Busy:fnActivate(nil)
		ScriptCB_PauseSessionList()
end

-- User hit cancel. Do what they want.
function ifs_sessionlist_refresh_fnOnCancel()
	print("refresh cancel")
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

-- Helper function: filters have changed. [Re]apply them.
function ifs_mp_sessionlist_fnApplyFilters(this)
	local Selection
	local sNameFilter, sPlayersFilter, sMapFilter, sEraFilter, sPingFilter, sTypeFilter, sGamemodeFilter

	-- DEBUG code - temp init of values
	sNameFilter = IFEditbox_fnGetString(this.DropBoxes.filter_gamename)
	sPlayersFilter = IFEditbox_fnGetString(this.DropBoxes.filter_numplayers)
	sPingFilter = IFEditbox_fnGetString(this.DropBoxes.filter_ping)
	
	Selection = mpsessionlist_maplist_contents[mpsessionlist_maplist_layout.SelectedIdx]
	sMapFilter = Selection.mapluafile

	Selection = mpsessionlist_eratypelist_contents[mpsessionlist_eratypelist_layout.SelectedIdx]
	sEraFilter = Selection.text

	Selection = mpsessionlist_servertypelist_contents[mpsessionlist_servertypelist_layout.SelectedIdx]
	sTypeFilter = Selection.text

	Selection = mpsessionlist_gamemodelist_contents[mpsessionlist_gamemodelist_layout.SelectedIdx]
	sGamemodeFilter = Selection.subst

	ScriptCB_ApplyFilters(sNameFilter, sPlayersFilter, sMapFilter, sEraFilter, sPingFilter, sTypeFilter, sGamemodeFilter )

	ScriptCB_SetFilters(sNameFilter,
											sPlayersFilter,
											mpsessionlist_maplist_layout.SelectedIdx,
											mpsessionlist_eratypelist_layout.SelectedIdx,
											sPingFilter,
											mpsessionlist_servertypelist_layout.SelectedIdx)

end

function ifs_mp_sessionlist_fnUpdateFilterGameMode(this)
	local Selection = mpsessionlist_gamemodelist_contents[mpsessionlist_gamemodelist_layout.SelectedIdx]

	IFObj_fnSetVis(this.DropBoxes.filter_gamemode.showtext, 1)	
	IFObj_fnSetVis(this.GameMode_Filter_Image, nil)
	
	print( "Selection.string == ", Selection.string )
	
	local i = 2			-- skip "all"
	for i = 2, table.getn( mpsessionlist_gamemodelist_contents ) do
		if( Selection.string == mpsessionlist_gamemodelist_contents[i].string ) then
			IFImage_fnSetTexture(this.GameMode_Filter_Image.Icon1_Mode, mpsessionlist_gamemodelist_contents[i].icon )
			IFObj_fnSetVis(this.GameMode_Filter_Image, 1)
			IFObj_fnSetVis(this.DropBoxes.filter_gamemode.showtext, nil)		
		end
	end
end

function ifs_mp_sessionlist_fnUpdateFilterEra(this)
	local Selection = mpsessionlist_eratypelist_contents[mpsessionlist_eratypelist_layout.SelectedIdx]
	
	IFObj_fnSetVis(this.DropBoxes.filter_era.showtext, 1)	
	IFObj_fnSetVis(this.Era_Filter_Image, nil)	-- turn on era filter image
	-- Find icons out of list of installed eras [Better for modders!]
	local i
	for i = 1,table.getn(gMapEras) do
		if(Selection.text == gMapEras[i].showstr) then
			IFImage_fnSetTexture(this.Era_Filter_Image.Icon2_Era, gMapEras[i].icon1)
			IFImage_fnSetTexture(this.Era_Filter_Image.Icon1_Era, gMapEras[i].icon2)
			IFObj_fnSetVis(this.Era_Filter_Image, 1)	-- turn on era filter image
			IFObj_fnSetVis(this.Era_Filter_Image.Icon2_Era, nil)	-- only show one icon
			IFObj_fnSetVis(this.DropBoxes.filter_era.showtext, nil)
		end
	end
end

-- Helper function - reads selections from the filter dropboxes,
-- updates their text
function ifs_mp_sessionlist_fnUpdateFilterText(this)
--	print("UpdateFilterText has mpsessionlist_maplist_layout.SelectedIdx = ",
--				mpsessionlist_maplist_layout.SelectedIdx)
				
	local Selection = mpsessionlist_maplist_contents[mpsessionlist_maplist_layout.SelectedIdx]
	
	local DisplayUStr
	if(Selection.showstr == "ifs.gsprofile.all") then
		DisplayUStr = ScriptCB_getlocalizestr("ifs.gsprofile.all")
	else
		DisplayUStr = missionlist_GetLocalizedMapName(Selection.mapluafile)
	end
	IFText_fnSetUString(this.DropBoxes.filter_mapname.showtext,DisplayUStr)

	Selection = mpsessionlist_gamemodelist_contents[mpsessionlist_gamemodelist_layout.SelectedIdx]
	IFText_fnSetString(this.DropBoxes.filter_gamemode.showtext,Selection.string)

	ifs_mp_sessionlist_fnUpdateFilterGameMode( this )
	
	--Selection = mpsessionlist_favlist_contents[mpsessionlist_favlist_layout.SelectedIdx]
	--IFText_fnSetString(this.DropBoxes.filter_favorite.showtext,Selection.string)

	Selection = mpsessionlist_eratypelist_contents[mpsessionlist_eratypelist_layout.SelectedIdx]
	IFText_fnSetString(this.DropBoxes.filter_era.showtext,Selection.text)

	ifs_mp_sessionlist_fnUpdateFilterEra( this )

	Selection = mpsessionlist_servertypelist_contents[mpsessionlist_servertypelist_layout.SelectedIdx]
	IFText_fnSetString(this.DropBoxes.filter_servertypeLabel.showtext,Selection.text)

	ifs_mp_sessionlist_fnApplyFilters(this)
end

-- Helper function. Turns listbox on/off, as requested
function ifs_sessionlist_joinpopup_fnShowListbox(this,bVis)
	local A1,A2
	if(bVis) then
		A1 = 0
		A2 = 1
	else
		A1 = 1
		A2 = 0
	end

	AnimationMgr_AddAnimation(this.listbox,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
	AnimationMgr_AddAnimation(this.serverinfo,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
	AnimationMgr_AddAnimation(this.playerlist,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
	AnimationMgr_AddAnimation(this.DropBoxes,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
--	AnimationMgr_AddAnimation(this.filtertitle,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
	AnimationMgr_AddAnimation(this.refreshbutton,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })
	AnimationMgr_AddAnimation(this.donebutton,{ fTotalTime = 0.2, fStartAlpha = A1, fEndAlpha = A2, })

end

-- Helper function, shows/hides the interface items on this page
function ifs_mp_sessionlist_fnShowHideInterface(this, bHideInterface)
	IFObj_fnSetVis(this.listbox, not bHideInterface)
	IFObj_fnSetVis(this.DropBoxes, not bHideInterface)
	IFObj_fnSetVis(this.ResortButtons, not bHideInterface)
	IFObj_fnSetVis(this.serverinfo, not bHideInterface)
	IFObj_fnSetVis(this.playerlist, (not bHideInterface) and (gOnlineServiceStr ~= "LAN"))
	--IFObj_fnSetVis(this.title, not bHideInterface)
	--no title for PC
	IFObj_fnSetVis( this.title, nil )
--	IFObj_fnSetVis(this.filtertitle, not bHideInterface)
	IFObj_fnSetVis(this.refreshbutton, not bHideInterface)
	IFObj_fnSetVis(this.donebutton, not bHideInterface)
	
	--IFObj_fnSetVis(this.ProfileNameText, not bHideInterface)
	IFObj_fnSetVis(this.ProfileNameText, nil)

	local show_login_name = nil
	if( ScriptCB_IsLoggedIn() ) then
		show_login_name = 1
	end	
	IFObj_fnSetVis(this.LoginAsText1, (not bHideInterface) )
	IFObj_fnSetVis(this.LoginAsText2, (not bHideInterface) and show_login_name )

	IFObj_fnSetVis(this.Gamespy_IconL, not bHideInterface)
	IFObj_fnSetVis(this.Gamespy_IconR, not bHideInterface)
	
	--IFObj_fnSetVis(this.SourceText, not bHideInterface)

	
	local show_ip = nil
	if( this.source_value == 3 ) then
		show_ip = 1
	end	
	IFObj_fnSetVis(this.IPText, (not bHideInterface) and show_ip )
	IFObj_fnSetVis(this.IPEdit, (not bHideInterface) and show_ip )
	
	IFObj_fnSetVis(this.PasswordEdit, not bHideInterface and (gOnlineServiceStr == "Direct" ))
	IFObj_fnSetVis(this.GamePwdText, not bHideInterface and (gOnlineServiceStr == "Direct" ))
	
	IFObj_fnSetVis(this.source_button, not bHideInterface)
	
--	IFObj_fnSetVis(this.Helptext_Back, not bHideInterface)
	
--	IFObj_fnSetVis(this.bar_listbox, not bHideInterface)
--	IFObj_fnSetVis(this.bar_serverinfo, not bHideInterface)
--	IFObj_fnSetVis(this.bar_playerinfo, (not bHideInterface) and (gOnlineServiceStr ~= "LAN"))
	
	IFObj_fnSetVis(this.Era_Filter_Image, not bHideInterface)
	if(not bHideInterface) then
		ifs_mp_sessionlist_fnUpdateFilterEra(this)
	end
	
	IFObj_fnSetVis(this.GameMode_Filter_Image, not bHideInterface)
	if(not bHideInterface) then
		ifs_mp_sessionlist_fnUpdateFilterGameMode(this)
	end	
end

-- Shows a specified dropbox. If sWhich is nil, none are shown
function ifs_mp_sessionlist_fnShowDropbox(this, sWhich)

	-- Turn off everything by default
	IFObj_fnSetVis(this.maplistbox, nil)
	IFObj_fnSetVis(this.eralistbox, nil)
	IFObj_fnSetVis(this.gamemode_listbox, nil)
	IFObj_fnSetVis(this.fav_listbox, nil)
	IFObj_fnSetVis(this.serverlistbox, nil)
	IFObj_fnSetVis(this.DropBoxes, 1)
	IFObj_fnSetVis(this.ResortButtons, 1)
	IFObj_fnSetVis(this.listbox, 1)
--	IFObj_fnSetVis(this.bar_listbox, 1)
--	IFObj_fnSetVis(this.Era_Filter_Image, nil)
--	IFObj_fnSetVis(this.GameMode_Filter_Image, nil)
	
	if(not sWhich) then
		this.bDropBoxesOpen = nil
		ifs_mp_sessionlist_fnUpdateFilterText(this) -- in case anything changed
		return
	end

	-- If we got here, hide main listbox to give space to read things
	-- [Map overlaps the main list, which causes dueling cursors]. This
	-- seems quirky, but seems to work better than anything else
--	IFObj_fnSetVis(this.DropBoxes, nil)
--	IFObj_fnSetVis(this.ResortButtons, nil)
--	IFObj_fnSetVis(this.listbox, nil)
--	IFObj_fnSetVis(this.bar_listbox, nil)
	this.bDropBoxesOpen = 1

	if (sWhich == "era") then
		IFObj_fnSetVis(this.eralistbox, 1)
	elseif (sWhich == "map") then
		IFObj_fnSetVis(this.maplistbox, 1)
	elseif (sWhich == "servertype") then
		IFObj_fnSetVis(this.serverlistbox, 1)
		IFObj_fnSetVis(this.serverlistbox, 1)		
	elseif (sWhich == "gamemode") then
		IFObj_fnSetVis(this.gamemode_listbox, 1)		
	elseif (sWhich == "favorite") then
		IFObj_fnSetVis(this.fav_listbox, 1)		
	end
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
	local C1 = 0
	local C2 = 0
	local C3 = 0
	local C4 = 0

	if(this.bShowRefresh) then
		if(this.iSortMode == 1) then
			C1 = 255
		elseif (this.iSortMode == 2) then
			C2 = 255
		elseif (this.iSortMode == 3) then
			C3 = 255
		elseif (this.iSortMode == 4) then
			C4 = 255
		end
	end

--	ScriptCB_IFFlashyText_SetTextColor(this.ResortButtons.numplayersLabel.cpointer, C1, C1, C1)
--	ScriptCB_IFFlashyText_SetTextColor(this.ResortButtons.namefieldLabel.cpointer , C2, C2, C2)
--	ScriptCB_IFFlashyText_SetTextColor(this.ResortButtons.servertypeLabel.cpointer, C3, C3, C3)
--	ScriptCB_IFFlashyText_SetTextColor(this.ResortButtons.pingLabel.cpointer      , C4, C4, C4)
end

function ifs_mp_sessionlist_fnDoRefresh(this)
	if(this.bShowRefresh) then -- XLive doesn't do refresh/resort
		ScriptCB_CancelSessionList()
		ifs_sessionlist_ClearSessionInfo()
		ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		ifs_mp_sessionlist_fnShowHideInterface(this,1)
		ifs_sessionlist_joinpopup_fnShowListbox(this,nil)

		--reset the connect type
		ifs_mp_sessionlist_fnConnectTypeUpdate( this )
		
		ScriptCB_SetInNetGame(nil)
		ScriptCB_BeginSessionList()

		if(gOnlineServiceStr == "LAN") then
			Popup_Busy.bCallerSetsString = nil
			Popup_Busy.fTimeout = 3 -- seconds
			IFText_fnSetString(Popup_Busy.BusyTimeStr,"")
		elseif(	gOnlineServiceStr == "Direct" ) then
			-- direct connected
			ifs_mp_sessionlist_fnShowHideInterface(this,nil)
			ifs_sessionlist_joinpopup_fnShowListbox(this,1)
			return
		else
			-- internet
			Popup_Busy.bCallerSetsString = 1 -- we'll manage the text ourselves
			Popup_Busy.fTimeout = 15 -- seconds
			IFText_fnSetString(Popup_Busy.BusyTimeStr,"0%") -- pre-fill the string
		end

		Popup_Busy.fnCheckDone = ifs_sessionlist_refresh_fnCheckDone
		Popup_Busy.fnOnSuccess = ifs_sessionlist_refresh_fnOnSuccess
		Popup_Busy.fnOnFail = ifs_sessionlist_refresh_fnOnFail
		Popup_Busy.fnOnCancel = ifs_sessionlist_refresh_fnOnCancel
		Popup_Busy.bNoCancel = nil -- allow cancel button
		IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
		Popup_Busy:fnActivate(1)
	end
end

-- Helper function, shows/hides stats as appropriate
function ifs_mp_sessionlist_fnShowStats(this)
	if((this.iNumSessions > 0) and (gOnlineServiceStr == "GameSpy")) then
		local ShowUStr = ScriptCB_usprintf("ifs.mp.sessionlist.totalservers",
																			 ScriptCB_tounicode(string.format("%d",this.iNumSessions)))
--		IFText_fnSetUString(this.listbox.SessionCount, ShowUStr)

		ShowUStr = ScriptCB_usprintf("ifs.mp.sessionlist.totalplayers",
																 ScriptCB_tounicode(string.format("%d/%d",this.iNumPlayers,this.iMaxPlayers)))
--		IFText_fnSetUString(this.listbox.PlayerCount, ShowUStr)
--		IFObj_fnSetVis(this.listbox.SessionCount, 1)
--		IFObj_fnSetVis(this.listbox.PlayerCount, 1)

		--ShowUStr = ScriptCB_usprintf( "ifs.mp.join.players", ScriptCB_tounicode(string.format("(%d/%d)",this.iNumPlayers,this.iMaxPlayers)))
		-- IFText_fnSetUString(this.playerlist.titleBarElement, ShowUStr)
		--IFText_fnSetUString(this.bar_playerinfo.Text1, ShowUStr)
--		IFText_fnSetString(this.bar_playerinfo.Text1, "ifs.onlinelobby.players")
	else
--		IFObj_fnSetVis(this.listbox.SessionCount, nil)
--		IFObj_fnSetVis(this.listbox.PlayerCount, nil)
		
		--IFText_fnSetString( this.playerlist.titleBarElement, "ifs.onlinelobby.players" )
--		IFText_fnSetString(this.bar_playerinfo.Text1, "ifs.onlinelobby.players")
	end
end

function ifs_mp_sessionlist_fnConnectTypeUpdate( this )
	if( this.source_value == 1 ) then	
		ScriptCB_SetConnectType("wan")
		gOnlineServiceStr = ScriptCB_GetOnlineService()
		RoundIFButtonLabel_fnSetString( this.source_button, "ifs.mp.join.internet" )
	elseif( this.source_value == 2 ) then
		ScriptCB_SetConnectType( "lan" )
		gOnlineServiceStr = "LAN"
		-- Whine like crazy
		ScriptCB_SetNoticeNoCable(1)
		RoundIFButtonLabel_fnSetString( this.source_button, "ifs.mp.join.lan" )
	elseif( this.source_value == 3 ) then
		ScriptCB_SetConnectType("direct")
		gOnlineServiceStr = "Direct"
		RoundIFButtonLabel_fnSetString( this.source_button, "ifs.mp.join.direct_con" )
	else
		RoundIFButtonLabel_fnSetString( this.source_button, "common.none" )
	end
	--ScriptCB_GetSessionList()
end

function ifs_mp_sessionlist_fnSourceButtonClickUpdate( this )
	this.source_value = this.source_value + 1	
	if( this.source_value > this.source_value_max ) then
		this.source_value = 1
	end
	
	ifs_mp_sessionlist_fnDoRefresh( this )
end

function ifs_mp_sessionlist_fnDirectConnect( this )
	local ip_string = IFEditbox_fnGetString( this.IPEdit )
	local password = ""

	if(gOnlineServiceStr == "Direct" ) then
		IFEditbox_fnGetString( this.PasswordEdit )
	end

--	print( "+++ direct connect to:", ip_string, "pwd:", password )	
	if( (not ip_string) or (ip_string == "") ) then
		return
	end

	ScriptCB_SetConnectType("direct")
	gOnlineServiceStr  = "Direct"
	ScriptCB_SetProfileJoinIP( ip_string )

	ScriptCB_SetAmHost(nil)
	ScriptCB_SetHostLimit(100)
	ScriptCB_SetDedicated(nil)
	ScriptCB_BeginJoinIP( ip_string, password )

	-- dialog box
	Popup_Busy.fnCheckDone = ifs_mp_sessionlist_buddymatch_fnCheckDone
	Popup_Busy.fnOnSuccess = ifs_mp_sessionlist_buddymatch_fnOnSuccess
	Popup_Busy.fnOnFail = ifs_main_specialmatch_fnOnFail
	Popup_Busy.fnOnCancel = ifs_mp_sessionlist_buddymatch_fnOnCancel
	Popup_Busy.bNoCancel = nil
	Popup_Busy.fTimeout = 15 -- seconds
	IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
	Popup_Busy:fnActivate(1)
end

ifs_mp_sessionlist = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bg_1",
	movieIntro      = nil,
	movieBackground = nil,
	iSortMode = 1,
	bNohelptext_backPC = 1,
	
	Helptext_Refresh = NewIFContainer {
		ScreenRelativeX = 0.0, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = -50, -- top row of buttons
		x = 0,

		icon = NewIFImage {
			ZPos = 200, -- behind most.

			texture = "btnmisc",
			localpos_l = 0,
			localpos_t = -11,
			localpos_r = 20,
			localpos_b =  11,
		},

		helpstr = NewIFText {
			string = "ifs.mp.sessionlist.refresh",
			font = "gamefont_medium",
			textw = 460,
			x = 25,
			y = -15,
			halign = "left",
			nocreatebackground=1,			
		},
	},

	Helptext_SortMode = NewIFContainer {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bot
		y = -50,

		icon = NewIFImage {
			ZPos = 200, -- behind most.

			texture = "btnmisc2",
			localpos_l = -10,
			localpos_t = -11,
			localpos_r = 10,
			localpos_b = 11,
			inert = 1, -- Delete this out of lua once created (we'll never touch it again)
		},

		helpstr = NewIFText {
			string = "ifs.mp.sessionlist.sortby",
			font = "gamefont_medium",
			textw = 460,
			x = -460,
			y = -15,
			halign = "right",
			nocreatebackground = 1,
		},
	},

	title = NewIFText {
		string = "ifs.mp.sessionlist.title",
		font = "gamefont_small",
		y = -20,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	},

--	filtertitle = NewIFText {
--		string = "ifs.onlinelobby.filters",
--		font = "gamefont_super_tiny",
--		y = 0,
--		x = -15,
--		textw = 460,
--		halign = "left",
--		ScreenRelativeX = 0, -- left
--		ScreenRelativeY = 0, -- top
--		nocreatebackground = 1,
--	},

	buttons = NewIFContainer {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 0, -- top
		y = 20, -- pixels down from the top
	},

--	Gamespy_IconL = NewIFImage {
--		ScreenRelativeX = 1.0, -- right
--		ScreenRelativeY = 0.0, -- top
--		x = -30,
--		y = 5,
--		texture = "gamespy_logo_128x32l",
--		localpos_l = -64,
--		localpos_t = -32,
--		localpos_r = 0,
--		localpos_b = 0,
--	},

--	Gamespy_IconR = NewIFImage {
--		ScreenRelativeX = 1.0, -- center
--		ScreenRelativeY = 0.0, -- bottom
--		x = -30,
--		y = 5,
--		texture = "gamespy_logo_128x32r",
--		localpos_l = 0,
--		localpos_t = -32,
--		localpos_r = 64,
--		localpos_b = 0,
--	},

	bFirstTime = 1,
	Enter = function(this, bFwd)
		-- Always call base class
--		if ( gOnlineServiceStr == "GameSpy") then
--			IFObj_fnSetAlpha(this.buttons.gamespy,1.0)
--			IFObj_fnSetAlpha(this.buttons.lan,.4)
--		else
--			IFObj_fnSetAlpha(this.buttons.gamespy,.4)
--			IFObj_fnSetAlpha(this.buttons.lan,1.0)
--		end

		-- set pc profile & title version text
		UpdatePCTitleText(this)

		-- hide dropbox
		ListManager_fnFillContents(this.source_listbox,sourcelist_content,sourcelist_layout)
		ifs_mp_sessionlist_fnShowSourceDropbox( this, nil )

		-- tabs	
		if(gPlatformStr == "PC") then
			ifelem_tabmanager_SetSelected(this, gPCMainTabsLayout, "_tab_multi")
			ifelem_tabmanager_SetSelected(this, gPCMultiPlayerTabsLayout, "_tab_join", 1)
			if( ScriptCB_IsLoggedIn() ) then
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", nil, 1 )
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", nil, 1 )
			else
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_friends", 1, 1 )
				ifelem_tabmanager_SetDimmed( this, gPCMultiPlayerTabsLayout, "_tab_leaderboard", 1, 1 )
			end
			-- dimm tabs for PC Demo
			ifs_DimTabsPCDemo(this)			
		end

		gIFShellScreenTemplate_fnEnter(this, bFwd)
		missionselect_listbox_contents = mp_missionselect_listbox_contents

		-- set profile name
		local ShowUStr = ScriptCB_usprintf( "ifs.mp.join.profile_name", ScriptCB_GetCurrentProfileName() )
		IFText_fnSetUString( this.ProfileNameText, ShowUStr )
		
		-- set gamespy login name
		if( ScriptCB_IsLoggedIn() ) then
			IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.login_as" )
			local NickStr, EmailStr, PasswordStr, iSaveType, iPromptType = ScriptCB_GetGSProfileInfo()
			if(ScriptCB_GetLoginName) then
				NickStr = ScriptCB_GetLoginName()
			else
				NickStr = "Get latest executable!"
			end
			IFText_fnSetString( this.LoginAsText2, NickStr )
			IFObj_fnSetVis( this.LoginAsText2, 1 )
		else
			IFText_fnSetString( this.LoginAsText1, "ifs.mp.join.notlogin" )
			IFObj_fnSetVis( this.LoginAsText2, nil )
		end		

		-- set direct connect ip addr
		local JoinIP = ScriptCB_GetProfileJoinIP()
		if( JoinIP ) then
--			print("JoinIP = ", JoinIP)
			IFEditbox_fnSetString(this.IPEdit, JoinIP)
		end

		if(this.bFirstTime) then
			this.bFirstTime = nil

			local sGameName, iNumPlayers, iMapIdx, iEraIdx, iMaxPing, iServerType = ScriptCB_GetFilters()
			if ((iMaxPing < 1) or (iMaxPing > 9999)) then
				iMaxPing = 9999
			end
			if ((iMapIdx < 1) or (iMapIdx > table.getn(mpsessionlist_maplist_contents))) then
				iMapIdx = 1
			end
			if ((iEraIdx < 1) or (iEraIdx > table.getn(mpsessionlist_eratypelist_contents))) then
				iEraIdx = 1
			end
			if ((iServerType < 1) or (iServerType > table.getn(mpsessionlist_servertypelist_contents))) then
				iServerType = 1
			end


			IFEditbox_fnGetString(this.DropBoxes.filter_gamename, sGameName)
			IFEditbox_fnSetString(this.DropBoxes.filter_numplayers, string.format("%d", iNumPlayers))
			mpsessionlist_maplist_layout.SelectedIdx = iMapIdx
			mpsessionlist_eratypelist_layout.SelectedIdx = iEraIdx
			IFEditbox_fnSetString(this.DropBoxes.filter_ping, string.format("%d", iMaxPing))
			mpsessionlist_servertypelist_layout.SelectedIdx = iServerType
		end

		-- gIFShellScreenTemplate_fnMoveIcon(this.Helptext_SortMode)
		-- right align the done button	
--		gIFShellScreenTemplate_fnMoveClickableButton(this.donebutton,this.donebutton.btn.label,0)

		IFObj_fnSetVis(this.PassBox, nil) -- off by default
		this.PassBox.passedit.bKeepsFocus = nil
		gCurEditbox = nil
		this.bPasswordMode = nil

		ifs_mp_sessionlist_fnShowDropbox(this, nil)
		ifs_mp_sessionlist_fnShowStats(this)

		local bIsGamespy = (gOnlineServiceStr == "GameSpy")
		IFObj_fnSetVis(this.Gamespy_IconL, bIsGamespy)
		IFObj_fnSetVis(this.Gamespy_IconR, bIsGamespy)
		this.bShowRefresh = (gOnlineServiceStr ~= "XLive")
		IFObj_fnSetVis(this.Helptext_Refresh, nil)
		IFObj_fnSetVis(this.Helptext_SortMode, nil)

		if(ScriptCB_GetSessionSortMode) then
			this.iSortMode = ScriptCB_GetSessionSortMode()
		end
		ifs_mp_sessionlist_UpdateSortModeText(this)

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

		ScriptCB_SetAmHost(nil)
		
		if(bFwd or this.bForceRefresh) then
			this.bForceRefresh = nil

			-- Blast list initially on entry
			ScriptCB_CancelSessionList()
			ifs_sessionlist_ClearSessionInfo()
			this.bInOptiSearch = nil

			--reset the connect type
			ifs_mp_sessionlist_fnConnectTypeUpdate( this )
			
			ScriptCB_SetInNetGame(nil)
			
			-- Reset listbox, show it. [Remember, Lua starts at 1!]
			mpsessionlist_listbox_layout.FirstShownIdx = 1
			mpsessionlist_listbox_layout.SelectedIdx = 1
			mpsessionlist_listbox_layout.CursorIdx = nil
			
			ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)

			mpsessionlist_serverinfo_layout.FirstShownIdx = 1
			mpsessionlist_serverinfo_layout.SelectedIdx = 1
			mpsessionlist_serverinfo_layout.CursorIdx = 1
			ListManager_fnFillContents(this.serverinfo,mpsessionlist_serverinfo_contents,mpsessionlist_serverinfo_layout)

			mpsessionlist_playerlist_layout.FirstShownIdx = 1
			mpsessionlist_playerlist_layout.SelectedIdx = 1
			mpsessionlist_playerlist_layout.CursorIdx = 1
			ListManager_fnFillContents(this.playerlist,mpsessionlist_playerlist_contents,mpsessionlist_playerlist_layout)

			-- These three have SelectedIdx set the first time in - NM 2/14/05
			ListManager_fnFillContents(this.maplistbox,mpsessionlist_maplist_contents,mpsessionlist_maplist_layout)

			local ii
			local jj = table.getn(mpsessionlist_eratypelist_contents)
			if(jj < 2) then
				for ii = 1, table.getn(gMapEras) do
					jj = jj + 1
					mpsessionlist_eratypelist_contents[jj] = { text = gMapEras[ii].showstr }
				end
			end

			ListManager_fnFillContents(this.eralistbox,mpsessionlist_eratypelist_contents,mpsessionlist_eratypelist_layout)
			ListManager_fnFillContents(this.serverlistbox,mpsessionlist_servertypelist_contents,mpsessionlist_servertypelist_layout)

			ListManager_fnFillContents(this.gamemode_listbox,mpsessionlist_gamemodelist_contents,mpsessionlist_gamemodelist_layout)

			ListManager_fnFillContents(this.fav_listbox,mpsessionlist_favlist_contents,mpsessionlist_favlist_layout)
			
			ifs_mp_sessionlist_fnUpdateFilterText(this)

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
			elseif (not this.bShowRefresh) then
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
				ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
			end
		end
		this.bPasswordJoinOnEnter = nil -- always clear this.

		local bSpecialJoinPending = ScriptCB_IsSpecialJoinPending()
		local CmdlinePending = ScriptCB_IsCmdlineJoinPending()
		if(CmdlinePending) then
			this.bJoinIPOnEntry = 1
			ifs_vkeyboard = ifs_vkeyboard or {}
			ifs_vkeyboard.CurString = CmdlinePending
		end

		-- See if we need to do a JoinIP (or an XLive join friend)
		if(this.bJoinIPOnEntry or bSpecialJoinPending) then
--			print(" ** Begin special join!")
			Popup_Busy:fnActivate(nil)
			ScriptCB_SetAmHost(nil)
			ScriptCB_SetDedicated(nil)
			if(this.bJoinIPOnEntry) then
				ScriptCB_BeginJoinIP(ifs_vkeyboard.CurString)
			else
				ScriptCB_BeginJoinSpecial()
			end
			ifs_mp_sessionlist_fnShowHideInterface(this, 1) -- hide interface

			Popup_Busy.fnCheckDone = ifs_mp_sessionlist_buddymatch_fnCheckDone
			Popup_Busy.fnOnSuccess = ifs_mp_sessionlist_buddymatch_fnOnSuccess
			Popup_Busy.fnOnFail = ifs_mp_sessionlist_buddymatch_fnOnFail
			Popup_Busy.fnOnCancel = ifs_mp_sessionlist_buddymatch_fnOnCancel
			Popup_Busy.bNoCancel = nil
			Popup_Busy.fTimeout = 15 -- seconds
			Popup_Busy.bCallerSetsString = nil -- we'll manage the text ourselves

--			IFText_fnSetString(Popup_Busy.title,"ifs.subHardDrive.busy")
			IFText_fnSetString(Popup_Busy.title,"common.mp.joining")
			Popup_Busy:fnActivate(1)
--			print(" ** Special join - popup open")

			this.bJoinIPOnEntry = nil
		end
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
				IFText_fnSetString(this.serverinfo[4],NewStr)
			end
			if(gCurHiliteButton) then
				IFButton_fnSelect(gCurHiliteButton,nil)
			end			
			ifelm_shellscreen_fnPlaySound(this.exitSound)
		end
	end,

	LastPasswordStr = "",
	Input_Accept = function(this)

		-- If the tab manager handled this event, then we're done
		if((gPlatformStr == "PC") and
		   ( ifelem_tabmanager_HandleInputAccept(this, gPCMainTabsLayout) or
		     ifelem_tabmanager_HandleInputAccept(this, gPCMultiPlayerTabsLayout, 1) ) ) then
			return
		end
		
		-- input accept for source buttons
		ifs_mp_sessionlist_fnClickSourceButtons( this )
		
		-- Function test added NM 2/15/05. Remove after about a week
		if((gMouseOverImage) and (ScriptCB_SetAsFavorite)) then
			local EntryCursor = mpsessionlist_listbox_layout.CursorIdx
			mpsessionlist_listbox_layout.SelectedIdx = mpsessionlist_listbox_layout.CursorIdx
			local Selection = mpsessionlist_listbox_contents[mpsessionlist_listbox_layout.CursorIdx]
			if(Selection) then
				ScriptCB_SetAsFavorite(EntryCursor, not Selection.bFavorite)
				mpsessionlist_listbox_layout.CursorIdx = EntryCursor
				mpsessionlist_listbox_layout.SelectedIdx = EntryCursor
				return
			end
		end

		if((not this.CurButton) and gMouseOverButtonWindow) then
			this.CurButton = gMouseOverButtonWindow.tag
		end
		print("Input_Accept CurButton=", this.CurButton, gMouseOverImage)

		if((this.bDropBoxesOpen) and (not gMouseListBox)) then
			ifs_mp_sessionlist_fnShowDropbox(this, nil) -- click outside of boxes cancels them
		end

		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then

			if(this.bDropBoxesOpen) then
				ifs_mp_sessionlist_fnShowDropbox(this, nil) -- click inside of boxes applies selection
				return
			end

			if(gMouseListBox) then
				--ScriptCB_SndPlaySound("shell_select_change")
				if( gMouseListBox.Layout.SelectedIdx == gMouseListBox.Layout.CursorIdx and this.lastDoubleClickTime and ScriptCB_GetMissionTime()<this.lastDoubleClickTime+0.4) then
--					print("doing shortcut")
					this.lastDoubleClickTime = nil
					this.CurButton = "_ok"
				else
					this.lastDoubleClickTime = ScriptCB_GetMissionTime()
					gMouseListBox.Layout.SelectedIdx = gMouseListBox.Layout.CursorIdx
					return -- note we did all the work
				end
			else
				return
			end
		end

		if((this.CurButton == "_passback") or (this.CurButton == "_passok")) then
			this.bPasswordMode = nil
			ifs_mp_sessionlist_fnShowHideInterface(this, nil)
			IFObj_fnSetVis(this.PassBox, nil)
			this.PassBox.passedit.bKeepsFocus = nil
			gCurEditbox = nil
			if(this.CurButton == "_passok") then
				this.LastPasswordStr = IFEditbox_fnGetString(this.PassBox.passedit)
				if(this.bSpecialJoinPass) then
					ScriptCB_LaunchQuickmatch(this.LastPasswordStr)
					ifs_movietrans_PushScreen(ifs_mp_lobby_quick)
				else
					ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
				end
				this.bSpecialJoinPass = nil
			end
			return
		end

		if(this.CurButton == "lan" ) then
			ScriptCB_CancelSessionList()
			gOnlineServiceStr = "LAN"
			ScriptCB_SetConnectType("lan")
			this:Enter(1)
			this:Input_Misc()
		elseif (this.CurButton == "gamespy") then
			ScriptCB_CancelSessionList()
			gOnlineServiceStr = "GameSpy"
			ScriptCB_SetConnectType("wan")
			this:Enter(1)
		elseif (this.CurButton == "filter_mapname") then
			ifs_mp_sessionlist_fnShowDropbox(this,"map")
		elseif (this.CurButton == "filter_servertypeLabel") then
			ifs_mp_sessionlist_fnShowDropbox(this,"servertype")
		elseif (this.CurButton == "filter_era") then
			ifs_mp_sessionlist_fnShowDropbox(this,"era")
		elseif (this.CurButton == "filter_gamemode") then
			ifs_mp_sessionlist_fnShowDropbox(this,"gamemode")			
		elseif (this.CurButton == "filter_favorite") then
			ifs_mp_sessionlist_fnShowDropbox(this,"favorite")			
		elseif (this.CurButton == "_refresh") then
			ifs_mp_sessionlist_fnDoRefresh(this) -- this:Input_Misc()
			
--	1 = sort by num players
--  2 = sort by game name
--  3 = sort by server type
--  4 = sort by ping
--  5 = mapname
--  6 = era
		elseif (this.CurButton == "numplayers") then
			ScriptCB_SetSessionSortMode(1)
			ScriptCB_GetSessionList()
			--this:Input_Misc()
			this:RepaintListbox()
		elseif (this.CurButton == "ping") then
			ScriptCB_SetSessionSortMode(4)
			ScriptCB_GetSessionList()
			--this:Input_Misc()
			this:RepaintListbox()
		elseif (this.CurButton == "gamename") then
			ScriptCB_SetSessionSortMode(2)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		elseif (this.CurButton == "servertypeLabel") then	
			ScriptCB_SetSessionSortMode(3)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		elseif (this.CurButton == "mapname") then	
			ScriptCB_SetSessionSortMode(5)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		elseif (this.CurButton == "era") then	
			ScriptCB_SetSessionSortMode(6)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		elseif (this.CurButton == "gamemode") then	
			ScriptCB_SetSessionSortMode(7)
			ScriptCB_GetSessionList()
			this:RepaintListbox()
		elseif (this.CurButton == "_ok") then

			ScriptCB_SetAmHost(nil)
			ScriptCB_SetDedicated(nil)
			
			if( this.source_value == 3 ) then
				ifs_mp_sessionlist_fnDirectConnect( this )
			elseif(table.getn(mpsessionlist_listbox_contents) > 0) then
				-- Can join only when the list has data in it.			
				if (ScriptCB_IsSessionReady()) then
					ifelm_shellscreen_fnPlaySound(this.acceptSound)

					local Selection = mpsessionlist_listbox_contents[mpsessionlist_listbox_layout.SelectedIdx]
					if (Selection.bWrongVer) then
						-- Wrong version. Can never join
						ifs_mp_sessionlist_fnShowHideInterface(this,1)
						Popup_Ok.fnDone = ifs_mp_sessionlist_fnWrongVerOk
						Popup_Ok:fnActivate(1)
						gPopup_fnSetTitleStr(Popup_Ok,"ifs.onlinelobby.wrongver")

					elseif (Selection.bLocked) then
						this.bPasswordMode = 1
						ifs_mp_sessionlist_fnShowHideInterface(this,1)
						IFObj_fnSetVis(this.PassBox, 1)
						this.PassBox.passedit.bKeepsFocus = 1
						gCurEditbox = this.PassBox.passedit
					else
						
						if(ScriptCB_IsCurProfileDirty()) then
							ifs_saveop.doOp = "SaveProfile"
							ifs_saveop.OnSuccess = ifs_mp_sessionlist_fwd_fnSaveProfileSuccess
							ifs_saveop.OnCancel = ifs_mp_sessionlist_fwd_fnSaveProfileCancel
							ifs_saveop.saveName = ScriptCB_GetProfileName(1)
							ifs_saveop.saveProfileNum = 1
							ifs_movietrans_PushScreen(ifs_saveop)
						else
							ifs_mp_sessionlist_fnStartJoin(this)
						end
					end
				else
					ifelm_shellscreen_fnPlaySound(this.errorSound)
					-- 				print("SessionNotReady")
				end
				-- 		else
				-- 			print("Session listbox contents too short")
			end
--		elseif (this.CurButton == "_source") then
--			print( "+++CurButton = _source" )
--			ifs_mp_sessionlist_fnSourceButtonClickUpdate( this )
		end
	end,

	Input_Back = function(this)
		if(this.bPasswordMode) then
			ifs_mp_sessionlist_fnShowHideInterface(this,nil)
			IFObj_fnSetVis(this.PassBox, nil)
			this.PassBox.passedit.bKeepsFocus = nil
			gCurEditbox = nil
			this.bPasswordMode = nil
		else
			if(ScriptCB_IsCurProfileDirty()) then
				ifs_saveop.doOp = "SaveProfile"
				ifs_saveop.OnSuccess = ifs_mp_sessionlist_back_fnSaveProfileSuccess
				ifs_saveop.OnCancel = ifs_mp_sessionlist_back_fnSaveProfileCancel
				ifs_saveop.saveName = ScriptCB_GetProfileName(1)
				ifs_saveop.saveProfileNum = 1
				ifs_movietrans_PushScreen(ifs_saveop)
			else
				if(gPlatformStr == "PC") then			
					ScriptCB_PopScreen("ifs_main") -- default action
				else				
					ScriptCB_PopScreen() -- just go back a screen
				end
			end
		end
	end,

	Input_KeyDown = function(this, iKey)
		if(gCurEditbox) then
			this.bKeyPressed = 1
			if((iKey == 10) or (iKey == 13)) then -- handle Enter different
				if(this.bPasswordMode) then
					this.CurButton = "_passok"
					this:Input_Accept(1)

					ifs_mp_sessionlist_fnShowHideInterface(this,nil)
					IFObj_fnSetVis(this.PassBox, nil)
					this.PassBox.passedit.bKeepsFocus = nil
					gCurEditbox = nil
					this.bPasswordMode = nil

					this.LastPasswordStr = IFEditbox_fnGetString(this.PassBox.passedit)
					ifs_mp_sessionlist_fnStartJoin(this,this.LastPasswordStr)
				else
					-- not password mode
					ifs_mp_sessionlist_fnApplyFilters(this)
				end

--				gCurEditbox = nil
			else
				IFEditbox_fnAddChar(gCurEditbox, iKey)
			end
		end

		-- Hitting F5  refreshes
		if(iKey == -63) then
			ifs_mp_sessionlist_fnDoRefresh(this) -- this:Input_Misc()
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
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end
		if(gPlatformStr ~= "PC") then
			ListManager_fnNavUp(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		end
	end,

	Input_GeneralDown = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputDown(this)) then
			return
		end
		if(gPlatformStr ~= "PC") then
			ListManager_fnNavDown(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		end
	end,

	Input_LTrigger = function(this)
		if(table.getn(mpsessionlist_listbox_contents) > 0) then
			ListManager_fnPageUp(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		end
	end,

	Input_RTrigger = function(this)
		if(table.getn(mpsessionlist_listbox_contents) > 0) then
			ListManager_fnPageDown(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		end
	end,

	-- No L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,

	fExtraInfoTimer = 1.0,
	Update = function(this, fDt)
		-- Call default base class's update function (make button bounce)
		gIFShellScreenTemplate_fnUpdate(this,fDt)
		
		-- update session list when not in direct connect mode
		if( not(this.source_value == 3) ) then
			ScriptCB_UpdateSessionList()
		end

		-- If the user moves off an edit box they typed in, then apply things
		local bLastEdit = this.bOverEdit
		if(gCurEditbox) then
			this.bOverEdit = 1
		else
			this.bOverEdit = nil
		end
		if(bLastEdit and this.bKeyPressed and (not this.bOverEdit)) then
			ifs_mp_sessionlist_fnApplyFilters(this)
			this.bKeyPressed = nil
		end

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

		ifs_mp_sessionlist_fnShowStats(this)

		gBlankListbox = nil
		mpsessionlist_listbox_contents = {} -- clear out completely.
	end,

	-- Callback from C to repaint the listbox. Done when the game notices
	-- the contents of that listbox have changed and it needs to trigger
	-- a repaint. The contents should be in the lua global
	-- mpsessionlist_listbox_contents
	RepaintListbox = function(this)
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

		if(this.bInOptiSearch) then
			ifs_sessionlist_optisearch_fnOnSuccess()
			this.bInOptiSearch = nil
		end

		mpsessionlist_listbox_layout.CursorIdx = mpsessionlist_listbox_layout.SelectedIdx
		ListManager_fnFillContents(this.listbox,mpsessionlist_listbox_contents,mpsessionlist_listbox_layout)
		ifs_mp_sessionlist_fnShowStats(this)
	end,

	-- Callback from C to repaint the extra session info about the selected
	-- session
	RepaintExtraInfo = function(this)
		NumEntries = table.getn(mpsessionlist_serverinfo_contents)
		if(not mpsessionlist_serverinfo_layout.SelectedIdx) then
			if(NumEntries > 0) then
				mpsessionlist_serverinfo_layout.SelectedIdx = 1
			end
		else
			if(NumEntries < 1) then
				mpsessionlist_serverinfo_layout.SelectedIdx = nil
			end
		end
		mpsessionlist_serverinfo_layout.CursorIdx = mpsessionlist_serverinfo_layout.SelectedIdx
		ListManager_fnFillContents(this.serverinfo,mpsessionlist_serverinfo_contents,mpsessionlist_serverinfo_layout)

		NumEntries = table.getn(mpsessionlist_playerlist_contents)
		if(not mpsessionlist_playerlist_layout.SelectedIdx) then
			if(NumEntries > 0) then
				mpsessionlist_playerlist_layout.SelectedIdx = 1
			end
		else
			if(NumEntries < 1) then
				mpsessionlist_playerlist_layout.SelectedIdx = nil
			end
		end
		mpsessionlist_playerlist_layout.CursorIdx = mpsessionlist_playerlist_layout.SelectedIdx
		ListManager_fnFillContents(this.playerlist,mpsessionlist_playerlist_contents,mpsessionlist_playerlist_layout)
	end,

	fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
		print("ifs_mp_sessionlist fnPostError(..,",bUserHitYes,ErrorLevel)
		if(ErrorLevel >= 6) then
			-- ignore for PC
			ScriptCB_ClearError()
			--ScriptCB_PopScreen()
		end

		if((ErrorLevel == 5) and (bUserHitYes) and (gPlatformStr == "XBox")) then
			ScriptCB_XB_Reboot("XLD_LAUNCH_DASHBOARD_ACCOUNT_MANAGEMENT")
		end

	end,
}

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
sourcelist_content = {
	{ string = "ifs.mp.join.internet" },
	{ string = "ifs.mp.join.lan" },
}

function Sourcelist_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local tinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y,
	}

	local YPos = layout.height * -0.5 + 3
	Temp.text = NewIFText {
		x = 10, y = YPos,
		textw = layout.width - 20, texth = layout.height,
		halign = "left", font = "gamefont_tiny", nocreatebackground=1,
	}

	return Temp
end

function Sourcelist_PopulateItem(Dest,Data)
	if (Data) then
		IFText_fnSetString(Dest.text,Data.string)
		IFObj_fnSetVis(Dest.text,1)
	else
		IFObj_fnSetVis(Dest.text,nil)
	end
end

sourcelist_layout = {
	showcount = 2,
	width = 170,
	totalheight = 0,
	yHeight = 15,
	ySpacing = 2,
	x = 0,
	y = -5,
	slider = nil, -- not with 2 items
	CreateFn = Sourcelist_CreateItem,
	PopulateFn = Sourcelist_PopulateItem,
}

function ifs_mp_sessionlist_fnAddSourceList( this )	
	-- source button
	local source_x = 80
	local source_y = 40
	local source_btn_width = 190
	
	this.source_value = 1
	this.source_value_max = 2	
--	this.source_button =	NewIFContainer
--	{
--		ScreenRelativeX = 0,
--		ScreenRelativeY = 0,
--		y = source_y,
--		x = source_x,
--		btn = NewClickableIFButton -- NewRoundIFButton
--		{
--			btnw = source_btn_width, -- made wider to fix 9173 - NM 8/25/04
--			btnh = 10,
--			font = "gamefont_small",
--			halign = "hcenter",
--			--bg_width = BackButtonW,
--			--bg_xflipped = 1,
--			tag = "_source",
--			--nocreatebackground=1,
--			bStyleTabbed = 1,
--			bg_width = source_btn_width - 40,			
--		}, -- end of btn
--		
--		btn_dropdown = NewIFImage {
--			x = 82, y = -9,
--			texture = "window_arrow",
--			localpos_l = 0, localpos_t = 0,
--			localpos_r = 18, localpos_b = 18,
--			AutoHotspot = 1, tag = "_btn_dropdown",
--			bIsFlashObj = 1, flash_alpha = 1.0,
--		},		
--	}
--	RoundIFButtonLabel_fnSetString( this.source_button.btn, "ifs.mp.join.internet" )

	this.source_button = NewPCDropDownButton {
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		y = source_y,
		x = source_x,
		btnw = source_btn_width, -- made wider to fix 9173 - NM 8/25/04
		btnh = 20,
		font = "gamefont_small",
		tag = "_source",
		string = "ifs.mp.join.internet",
	}
	
	-- source listbox
	this.source_listbox = NewButtonWindow { ZPos = 0, x=60, y = 75,
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = sourcelist_layout.width,
		height = sourcelist_layout.totalheight + 50,
	}
	ListManager_fnInitList(this.source_listbox,sourcelist_layout)

	ListManager_fnFillContents(this.source_listbox,sourcelist_content,sourcelist_layout)
end

function ifs_mp_sessionlist_fnAddGamespyLogin(this)
	-- set gamespy icon's position
	local new_shell_gamespy_x = 0
	local new_shell_offset_x = 240		
	local new_shell_gamespy_x = -663
	local gamespy_icon_y = 567

	local login_as_x = 100
	local login_as_y = 535	

	--if( ( this == ifs_missionselect_pcMulti ) )then
		login_as_x = -35
		login_as_y = 510
	--end
	
	this.Gamespy_IconL = NewIFImage {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 0.0, -- top
		x = -30 + new_shell_gamespy_x,
		y = gamespy_icon_y,
		texture = "gamespy_logo_128x32l",
		localpos_l = -64,
		localpos_t = -32,
		localpos_r = 0,
		localpos_b = 0,
	}

	this.Gamespy_IconR = NewIFImage {
		ScreenRelativeX = 1.0, -- center
		ScreenRelativeY = 0.0, -- bottom
		x = -30 + new_shell_gamespy_x,
		y = gamespy_icon_y,
		texture = "gamespy_logo_128x32r",
		localpos_l = 0,
		localpos_t = -32,
		localpos_r = 64,
		localpos_b = 0,
	}

	-- login as text	
	this.LoginAsText1 = NewIFText {
		string = "ifs.mp.join.login_as",
		font = "gamefont_tiny",
		x = login_as_x,
		y = login_as_y,
		textw = 200,
		halign = "left",
		ScreenRelativeX = 0, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	}
	
	this.LoginAsText2 = NewIFText {
--		string = "blackfox",
		font = "gamefont_tiny",
		x = login_as_x,
		y = login_as_y + 12,
		textw = 200,
		halign = "left",
		ScreenRelativeX = 0, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	}
end

function ifs_mp_sessionlist_fnShowSourceDropbox( this, enable )	
	IFObj_fnSetVis(this.source_listbox, enable)
	if( this.DropBoxes ) then
		IFObj_fnSetVis(this.DropBoxes, not enable) -- flip visibility on dropboxes
	end
	this.bSourceDropBoxesOpen = enable
end

function ifs_mp_sessionlist_fnClickSourceButtons( this )
	--print( "this.bSourceDropBoxesOpen =", this.bSourceDropBoxesOpen )
	--print( "this.CurButton =", this.CurButton )
	
	if( this.bSourceDropBoxesOpen ) then
		--print( "gMouseListBox =", gMouseListBox )
		--print( "this.source_listbox =", this.source_listbox )
		if( gMouseListBox == this.source_listbox ) then
			if( sourcelist_layout.CursorIdx ) then
				this.source_value = sourcelist_layout.CursorIdx
			end
			print( "this.source_value = ", this.source_value )
			ifs_mp_sessionlist_fnShowSourceDropbox( this, nil )		
			ifs_mp_sessionlist_fnDoRefresh( this )
		else
			ifs_mp_sessionlist_fnShowSourceDropbox( this, nil )
		end
	else
		-- open the drop box
		if( this.CurButton == "_source" ) then
			ifs_mp_sessionlist_fnShowSourceDropbox( this, 1 )
		end
	end
end
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

--LAN_GameSpy_Button_Layout = {
--	yTop = 0 ,
--	xWidth = 200,
--	xSpacing  = 0,	
--	--font = "gamefont_medium",
--	RightJustify = 1,
--	xLeft = 0,
--	Flashy =1,
--	flashy = 1,
--	buttonlist =
--	{
--		{ tag = "lan", string = "ifs.mp.lan", }, 
--		{ tag = "gamespy", string = "ifs.mp.gamespy", },
--	},
--}

-- Do programatic work to set up this screen
function ifs_mp_sessionlist_fnBuildScreen(this)
	local i
	local XPos
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	local DropBoxH = 30
	local DropBoxTotalH = DropBoxH + 10 -- space, including gutters

	this.title.textw = w
	this.title.x = w * -0.5

	-- add pc profile & title version text
	AddPCTitleText( this )
	
	local fTinyH=ScriptCB_GetFontHeight("gamefont_tiny")
	local fSuperTinyH=ScriptCB_GetFontHeight("gamefont_super_tiny")

	local BoxW = w * 0.98
	if(gPlatformStr == "PC") then
		BoxW = w * 1.08
	end

--	-- set gamespy icon's position
--	local 	gamespy_icon_y = 30
--	this.Gamespy_IconL.y = gamespy_icon_y
--	this.Gamespy_IconR.y = gamespy_icon_y
	
	-- filter title
	local 	filter_title_y = 45
	local 	filter_boxes_y = filter_title_y + 25
--	this.filtertitle.y = filter_title_y	- 5
--	this.filtertitle.x = -30

	local	player_name_y = 2
	-- player name text	
	this.ProfileNameText = NewIFText {
		string = "ifs.mp.join.profile_name",
		font = "gamefont_small",
		y = player_name_y,
		textw = 400,
		halign = "right",
		ScreenRelativeX = 0, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	}
	
--	local	login_as_y = 0
--	-- login as text	
--	this.LoginAsText1 = NewIFText {
--		string = "ifs.mp.join.login_as",
--		font = "gamefont_tiny",
--		y = login_as_y,
--		textw = 200,
--		halign = "right",
--		ScreenRelativeX = 0.58, -- center
--		ScreenRelativeY = 0, -- top
--		nocreatebackground = 1,
--	}
	
--	this.LoginAsText2 = NewIFText {
--		string = "blackfox",
--		font = "gamefont_tiny",
--		y = login_as_y + 13,
--		textw = 200,
--		halign = "right",
--		ScreenRelativeX = 0.58, -- center
--		ScreenRelativeY = 0, -- top
--		nocreatebackground = 1,
--	}

	local	source_y = 30
--	-- source text	
--	this.SourceText = NewIFText {
--		string = "ifs.mp.join.source",
--		font = "gamefont_small",
--		y = source_y - 5,
--		textw = 200,
--		halign = "right",
--		ScreenRelativeX = -0.22, -- center
--		ScreenRelativeY = 0, -- top
--		nocreatebackground = 1,
--	}

	-- ip text	
	this.IPText = NewIFText {
		string = "ifs.mp.join.ip",
		font = "gamefont_small",
		y = source_y,
		textw = 200,
		halign = "right",
		ScreenRelativeX = 0.1, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	}

	-- edit box: IP
	this.IPEdit = NewEditbox {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.0,
		y = source_y + 10,
		width = 175,
		height = 25,
		font = "gamefont_small",
		string = "192.168.123.123",
--		MaxLen = EditBoxW,
		MaxChars = 15,
	}
	
	-- gamepassword text	
	this.GamePwdText = NewIFText {
		string = "ifs.mp.join.password",
		font = "gamefont_small",
		y = source_y,
		textw = 200,
		halign = "right",
		ScreenRelativeX = 0.58, -- center
		ScreenRelativeY = 0, -- top
		nocreatebackground = 1,
	}

 	-- edit box: password
 	this.PasswordEdit = NewEditbox {
 		ScreenRelativeX = 0.95,
 		ScreenRelativeY = 0.0,
 		y = source_y + 10,
 		width = 130,
 		height = 25,
 		font = "gamefont_small",
 		string = "",
 --		MaxLen = EditBoxW,
 		MaxChars = 8,
 		bPasswordMode = 1,
 	}

	-- era filter image
	local	icon_height = 18
	this.Era_Filter_Image = NewIFContainer { 		
		ScreenRelativeX = 0, -- left side of screen
		ScreenRelativeY = 0, -- top
		x = 485 + 30,
		y = 62,
		ZPos = 0, 

		Icon1_Era = NewIFImage {
			ZPos = 240, 
			localpos_l = 0,
			localpos_r = icon_height,
			localpos_t = 0,
			localpos_b = icon_height,
			--ColorR = 32,
			--ColorG = 240,
			--ColorB = 32,
			texture = "cis_icon", 
		},
		
		Icon2_Era = NewIFImage {
			ZPos = 240, 
			localpos_l = icon_height,
			localpos_r = 2 * icon_height,
			localpos_t = 0,
			localpos_b = icon_height,
 			--ColorR = 240,
 			--ColorG = 32,
 			--ColorB = 32,
			texture = "rep_icon", 
		}
	}

	this.GameMode_Filter_Image = NewIFContainer { 		
		ScreenRelativeX = 0, -- left side of screen
		ScreenRelativeY = 0, -- top
		x = 410 + 40,
		y = 62,
		ZPos = 0, 

		Icon1_Mode = NewIFImage {
			ZPos = 240, 
			localpos_l = 0,
			localpos_r = icon_height,
			localpos_t = 0,
			localpos_b = icon_height,
			--ColorR = 240,
			--ColorG = 32,
			--ColorB = 32,
			texture = "cis_icon", 
		},		
	}
	
	-- game mode filter image

--	-- source button
--	this.source_value = 1
--	this.source_value_max = 3
--	this.source_button =	NewIFContainer
--	{
--		ScreenRelativeX = 0.17,
--		ScreenRelativeY = 0,
--		y = source_y + 5,
--		x = 0,
--		btn = NewClickableIFButton -- NewRoundIFButton
--		{
--			btnw = 150, -- made wider to fix 9173 - NM 8/25/04
--			btnh = 10,
--			font = "gamefont_small",
--			halign = "hcenter",
--			--bg_width = BackButtonW,
--			--bg_xflipped = 1,
--			tag = "_source",
--			nocreatebackground=1,
--			
--		}, -- end of btn
--	}
--	RoundIFButtonLabel_fnSetString( this.source_button.btn, "ifs.mp.join.internet" )

	-- Calculate widths of columns for main list

	gMPSessionList_Listbox_ColumnInfo[1].width = 32 -- Favorite checkbox
	gMPSessionList_Listbox_ColumnInfo[2].width = 0.27*BoxW - 5 -- Server name --
	gMPSessionList_Listbox_ColumnInfo[3].width = 60 -- # players -- 50
	gMPSessionList_Listbox_ColumnInfo[4].width = 130 -- mapname --
	gMPSessionList_Listbox_ColumnInfo[5].width = 100 -- gamemode --
 	gMPSessionList_Listbox_ColumnInfo[6].width = 50 -- era --
	gMPSessionList_Listbox_ColumnInfo[7].width = 60 -- ping -- 30

	--
	-- Make main listbox
	--

	mpsessionlist_listbox_layout.yHeight = fSuperTinyH + 2
	mpsessionlist_listbox_layout.showcount = math.floor( (h*.35) / (mpsessionlist_listbox_layout.yHeight + mpsessionlist_listbox_layout.ySpacing) ) - 1
	local SessionBoxH = mpsessionlist_listbox_layout.showcount * (mpsessionlist_listbox_layout.yHeight + mpsessionlist_listbox_layout.ySpacing) + 40
	mpsessionlist_listbox_layout.showcount = mpsessionlist_listbox_layout.showcount + 1
	
	local listbox_y = 210
	local smallH = ScriptCB_GetFontHeight("gamefont_small")
	this.listbox = NewButtonWindow {
		ZPos = 200, x=0, y = listbox_y,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		width = BoxW, height = SessionBoxH,
		titleText = " ",
		font = "gamefont_super_tiny",
	}
	mpsessionlist_listbox_layout.width = BoxW - 35	
	ListManager_fnInitList(this.listbox,mpsessionlist_listbox_layout)

--	-- Attach stats items to listbox
--	this.listbox.SessionCount = NewIFText {
--		x = 10 + BoxW * -0.5, y = SessionBoxH * 0.5 - 2,
--		textw = BoxW * 0.5, texth = 15,
--		halign = "left", valign = "top",
--		font = "gamefont_super_tiny", nocreatebackground=1,
--	}

--	-- Attach stats items to listbox
--	this.listbox.PlayerCount = NewIFText {
--		x = 30, y = SessionBoxH * 0.5 - 2,
--		textw = BoxW * 0.5, texth = 15,
--		halign = "left", valign = "top",
--		font = "gamefont_super_tiny", nocreatebackground=1,
--	}

	--
	-- Make drop-listboxes (will be attached later)
	--

	-- Copy over maplist, with an 'all' as the first entry
	for i=1,table.getn(mp_missionselect_listbox_contents) do
		mpsessionlist_maplist_contents[i+1] = mp_missionselect_listbox_contents[i]
	end

	mpsessionlist_maplist_layout.showcount = math.min(25,table.getn(mp_missionselect_listbox_contents) + 1)
	mpsessionlist_maplist_layout.width = gMPSessionList_Listbox_ColumnInfo[4].width + 50
	mpsessionlist_maplist_layout.totalheight = mpsessionlist_maplist_layout.showcount * (mpsessionlist_maplist_layout.yHeight + mpsessionlist_maplist_layout.ySpacing) + 30
	this.maplistbox = NewButtonWindow { ZPos = 0, x=0, y = 30,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = mpsessionlist_maplist_layout.width + 35,
		height = mpsessionlist_maplist_layout.totalheight,
	}
	ListManager_fnInitList(this.maplistbox,mpsessionlist_maplist_layout)

	mpsessionlist_eratypelist_layout.width = gMPSessionList_Listbox_ColumnInfo[6].width + 150
	mpsessionlist_eratypelist_layout.totalheight = mpsessionlist_eratypelist_layout.showcount * (mpsessionlist_eratypelist_layout.yHeight + mpsessionlist_eratypelist_layout.ySpacing) + 30
	this.eralistbox = NewButtonWindow { ZPos = 0, x=0, y = 80,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = mpsessionlist_eratypelist_layout.width + 15,
		height = mpsessionlist_eratypelist_layout.totalheight,
	}
	ListManager_fnInitList(this.eralistbox,mpsessionlist_eratypelist_layout)

	mpsessionlist_gamemodelist_layout.width = gMPSessionList_Listbox_ColumnInfo[5].width + 50
	mpsessionlist_gamemodelist_layout.totalheight = mpsessionlist_gamemodelist_layout.showcount * (mpsessionlist_gamemodelist_layout.yHeight + mpsessionlist_gamemodelist_layout.ySpacing) + 30
	this.gamemode_listbox = NewButtonWindow { ZPos = 0, x=0, y = 30,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.08,
		bg_texture = "border_dropdown",
		width = mpsessionlist_gamemodelist_layout.width + 15,
		height = mpsessionlist_gamemodelist_layout.totalheight,
	}
	ListManager_fnInitList(this.gamemode_listbox,mpsessionlist_gamemodelist_layout)

	mpsessionlist_favlist_layout.width = gMPSessionList_Listbox_ColumnInfo[1].width + 50
	mpsessionlist_favlist_layout.totalheight = mpsessionlist_favlist_layout.showcount * (mpsessionlist_favlist_layout.yHeight + mpsessionlist_favlist_layout.ySpacing) + 30
	this.fav_listbox = NewButtonWindow { ZPos = 0, x=0, y = 30,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.08,
		width = mpsessionlist_favlist_layout.width + 15,
		height = mpsessionlist_favlist_layout.totalheight,
	}
	ListManager_fnInitList(this.fav_listbox,mpsessionlist_favlist_layout)

	-- Must make main listbox first, to calculate width
	mpsessionlist_servertypelist_layout.width = gMPSessionList_Listbox_ColumnInfo[8].width + 50
	mpsessionlist_servertypelist_layout.totalheight = mpsessionlist_servertypelist_layout.showcount * (mpsessionlist_servertypelist_layout.yHeight + mpsessionlist_servertypelist_layout.ySpacing) + 30
	this.serverlistbox = NewButtonWindow { ZPos = 0, x=0, y = 30,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0,
		bg_texture = "border_dropdown",
		width = mpsessionlist_servertypelist_layout.width + 15,
		height = mpsessionlist_servertypelist_layout.totalheight,
	}
	ListManager_fnInitList(this.serverlistbox,mpsessionlist_servertypelist_layout)

	--
	-- Make dropboxes
	--

	this.DropBoxes = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.0,
		y = filter_boxes_y,
	}
	XPos = BoxW * -0.5 + 10

	for i=1,table.getn(gMPSessionList_Listbox_ColumnInfo) do
		local NewLabel = "filter_" .. gMPSessionList_Listbox_ColumnInfo[i].tag
		if(i ~= 1) then
			if(gMPSessionList_Listbox_ColumnInfo[i].maxchars > 0) then
				local box_width = gMPSessionList_Listbox_ColumnInfo[i].width + 4
				if(gMPSessionList_Listbox_ColumnInfo[i].tag == "gamename") then
					box_width = box_width - 4
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "numplayers") then
					box_width = box_width - 2
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "gamemode") then
					box_width = box_width - 6
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "era") then
					box_width = box_width - 12
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "ping") then
					box_width = box_width - 4
				end
				this.DropBoxes[NewLabel] = NewEditbox {
					width = box_width,
					height = DropBoxH,
					font = "gamefont_super_tiny",
					--				string = gMPSessionList_Listbox_ColumnInfo[i].tag,
					MaxLen = gMPSessionList_Listbox_ColumnInfo[i].width - 6,
					MaxChars = gMPSessionList_Listbox_ColumnInfo[i].maxchars,
				}
				this.DropBoxes[NewLabel].x = XPos + gMPSessionList_Listbox_ColumnInfo[i].width * 0.5				
				if(gMPSessionList_Listbox_ColumnInfo[i].tag == "gamename") then
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x - 2
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "numplayers") then
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x - 1
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "gamemode") then
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x - 3
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "era") then
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x - 5
				elseif(gMPSessionList_Listbox_ColumnInfo[i].tag == "ping") then
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x
				end				
			else
				-- Make button w/ text field. Attach listbox
				local list_width = gMPSessionList_Listbox_ColumnInfo[i].width
				if (gMPSessionList_Listbox_ColumnInfo[i].tag == "servertypeLabel") then
					list_width = list_width + 30
				end
				this.DropBoxes[NewLabel] = NewButtonWindow {
					width = list_width, height = DropBoxH,
					tag = NewLabel,

					showtext = NewIFText {
						x = 0, y = -6,
						string = gMPSessionList_Listbox_ColumnInfo[i].tag,
						font = "gamefont_super_tiny",
						textw = list_width - 10,
						texth = DropBoxH,
						nocreatebackground = 1,
						halign = "left",
					},
				}
				this.DropBoxes[NewLabel].x = XPos + gMPSessionList_Listbox_ColumnInfo[i].width * 0.5
				this.DropBoxes[NewLabel].showtext.x = gMPSessionList_Listbox_ColumnInfo[i].width * -0.5 + 10

				this.DropBoxes[NewLabel].bHotspot = 1
				this.DropBoxes[NewLabel].fHotspotW = gMPSessionList_Listbox_ColumnInfo[i].width
				this.DropBoxes[NewLabel].fHotspotH = DropBoxH
				this.DropBoxes[NewLabel].fHotspotX = gMPSessionList_Listbox_ColumnInfo[i].width * -0.5
				this.DropBoxes[NewLabel].fHotspotY = DropBoxH * -0.5

				if (gMPSessionList_Listbox_ColumnInfo[i].tag == "era") then
					this.eralistbox.x = this.DropBoxes[NewLabel].x - 80
					this.eralistbox.y = this.DropBoxes.y + mpsessionlist_eratypelist_layout.totalheight * 0.5 + 13
				elseif (gMPSessionList_Listbox_ColumnInfo[i].tag == "mapname") then
					this.maplistbox.x = this.DropBoxes[NewLabel].x - 40
					this.maplistbox.y = this.DropBoxes.y + mpsessionlist_maplist_layout.totalheight * 0.5 + 13
					--this.DropBoxes[NewLabel].showtext.y = this.DropBoxes[NewLabel].showtext.y - 7
				elseif (gMPSessionList_Listbox_ColumnInfo[i].tag == "servertypeLabel") then
					this.serverlistbox.x = this.DropBoxes[NewLabel].x
					this.serverlistbox.y = this.DropBoxes.y + mpsessionlist_servertypelist_layout.totalheight * 0.5 + 13
					this.DropBoxes[NewLabel].x = this.DropBoxes[NewLabel].x + 15
					this.DropBoxes[NewLabel].showtext.x = this.DropBoxes[NewLabel].showtext.x - 15
				elseif( gMPSessionList_Listbox_ColumnInfo[i].tag == "gamemode" ) then
					this.gamemode_listbox.x = this.DropBoxes[NewLabel].x - 30
					this.gamemode_listbox.y = this.DropBoxes.y + mpsessionlist_eratypelist_layout.totalheight * 0.5	- 8
				elseif( gMPSessionList_Listbox_ColumnInfo[i].tag == "favorite" ) then
					this.fav_listbox.x = this.DropBoxes[NewLabel].x - 40
					this.fav_listbox.y = this.DropBoxes.y + mpsessionlist_favlist_layout.totalheight * 0.5 + 13 
				end

			end
		end
		XPos = XPos + gMPSessionList_Listbox_ColumnInfo[i].width
	end
	
	--
	-- Make clickable buttons to sort server list
	--

	local labelY = this.listbox.y-0.5*SessionBoxH-smallH-5
	this.ResortButtons = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.0,
		y = 7,
	}
 
	-- And all of the buttons, now
	XPos = BoxW * -0.5 + 10
	for i=1,table.getn(gMPSessionList_Listbox_ColumnInfo) do
		local NewLabel = gMPSessionList_Listbox_ColumnInfo[i].tag .. "Label"
		this.ResortButtons[NewLabel] = NewClickableIFButton {
			x = XPos,
			y = labelY + 3,
			btnw = gMPSessionList_Listbox_ColumnInfo[i].width,
			btnh = 25,
			tag = gMPSessionList_Listbox_ColumnInfo[i].tag,
			font = "gamefont_super_tiny",
			string = gMPSessionList_Listbox_ColumnInfo[i].string,
			nocreatebackground=1,
		}
		this.ResortButtons[NewLabel].x = XPos + 5
		this.ResortButtons[NewLabel].label.x = 0
		this.ResortButtons[NewLabel].label.halign ="left"

		--if (gMPSessionList_Listbox_ColumnInfo[i].tag == "ping") then
		--	this.ResortButtons[NewLabel].x = XPos + 10
		--end
		
		XPos = XPos + gMPSessionList_Listbox_ColumnInfo[i].width
	end


	--
	-- Build up ServerInfo listbox
	--

	mpsessionlist_serverinfo_layout.yHeight = fSuperTinyH + 2
	mpsessionlist_serverinfo_layout.showcount = math.floor( (h*.27) / (mpsessionlist_serverinfo_layout.yHeight + mpsessionlist_serverinfo_layout.ySpacing) )
	local InfoBoxH = mpsessionlist_serverinfo_layout.showcount * (mpsessionlist_serverinfo_layout.yHeight + mpsessionlist_serverinfo_layout.ySpacing) + 30
	local InfoBoxW = w * 0.5 + 35
	mpsessionlist_serverinfo_layout.width = InfoBoxW - 35

	local server_info_y = 423
	this.serverinfo = NewButtonWindow {
		ZPos = 200,
		x=InfoBoxW * -0.5 + 6, y = server_info_y,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		width = InfoBoxW, height = InfoBoxH,
		font = "gamefont_super_tiny",
		titleText = "ifs.mp.sessionlist.gameinfo",
	}
	ListManager_fnInitList(this.serverinfo,mpsessionlist_serverinfo_layout)

	local TopBoxHeight = 20
	local bar_y = 338
	local bar_x = -29

--	this.bar_listbox = NewIFContainer { 
--		ScreenRelativeX = 0, -- left side of screen
--		ScreenRelativeY = 0, -- top
--		x = -28,
--		y = 85,
--		ZPos = 240,
--
--		bg = NewIFImage {
--			ZPos = 240, 
--			localpos_l = 0,
--			localpos_r = BoxW - 1,
--			localpos_b = TopBoxHeight,
--			texture = "white_rect",
--			ColorR = 128,
--			ColorG = 128,
--			ColorB = 128,
--		},
--	}

--	this.bar_serverinfo = NewIFContainer { 
--		ScreenRelativeX = 0, -- left side of screen
--		ScreenRelativeY = 0, -- top
--		x = bar_x,
--		y = bar_y,
--		ZPos = 240,
--
--		bg = NewIFImage {
--			ZPos = 240, 
--			localpos_l = 0,
--			localpos_r = InfoBoxW,
--			localpos_b = TopBoxHeight,
--			texture = "white_rect",
--			ColorR = 128,
--			ColorG = 128,
--			ColorB = 128,
--		},

--		Text1 = NewIFText { 
--			x = 10,
--			y = 1,
--			halign = "left", valign = "vcenter",
--			font = "gamefont_small", 
--			textw = InfoBoxW, texth = TopBoxHeight,
--			startdelay=math.random()*0.5, nocreatebackground=1, 
--			ColorR = 0,
--			ColorG = 0,
--			ColorB = 0,
--			string = "ifs.mp.sessionlist.gameinfo",
--		},
--	}

--	this.bar_playerinfo = NewIFContainer { 
--		ScreenRelativeX = 0, -- left side of screen
--		ScreenRelativeY = 0, -- top
--		x = bar_x + InfoBoxW + 8,
--		y = bar_y,
--		ZPos = 240,
--
--		bg = NewIFImage {
--			ZPos = 240, 
--			localpos_l = 0,
--			localpos_r = InfoBoxW - 20,
--			localpos_b = TopBoxHeight,
--			texture = "white_rect",
--			ColorR = 128,
--			ColorG = 128,
--			ColorB = 128,
--		},
--
--		Text1 = NewIFText { 
--			x = 10,
--			y = 1,
--			halign = "left", valign = "vcenter",
--			font = "gamefont_small", 
--			textw = InfoBoxW, texth = TopBoxHeight,
--			startdelay=math.random()*0.5, nocreatebackground=1, 
--			ColorR = 0,
--			ColorG = 0,
--			ColorB = 0,
--			string = "ifs.onlinelobby.players",
--		},
--	}

	-- Pre-init stats
	this.iNumSessions = 0
	this.iNumPlayers = 0
	this.iMaxPlayers = 0

	--
	-- Build up Playerlist listbox
	--

	mpsessionlist_playerlist_layout.yHeight = fSuperTinyH + 2
	mpsessionlist_playerlist_layout.showcount = math.floor( (h*.27) / (mpsessionlist_playerlist_layout.yHeight + mpsessionlist_playerlist_layout.ySpacing) )
	local InfoBoxH = mpsessionlist_playerlist_layout.showcount * (mpsessionlist_playerlist_layout.yHeight + mpsessionlist_playerlist_layout.ySpacing) + 30
	local InfoBoxW = w * 0.5 + 15
	mpsessionlist_playerlist_layout.width = InfoBoxW - 35

	this.playerlist = NewButtonWindow {
		ZPos = 100,
--		yTop = 20,  -- auto-calc'd now
		x=InfoBoxW * 0.5 + 14, y = server_info_y,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.0, -- top of screen
		width = InfoBoxW, height = InfoBoxH,
		font = "gamefont_super_tiny",
		titleText = "ifs.onlinelobby.players",
	}
	ListManager_fnInitList(this.playerlist,mpsessionlist_playerlist_layout)
	local icon_width = 10
	local icon_x = 10 + icon_width*0.5 + 8 --InfoBoxW * 0.025 + 2
	local icon_offset = mpsessionlist_playerlist_layout.width * 0.1  --35
	local icon_offset_y = 18
	this.playerlist.iconpoints = NewIFImage {
		ZPos = 0,
		texture = "points",
		x = icon_x,
		y = InfoBoxH * -0.5 + icon_offset_y,
		localpos_l = 0,
		localpos_t = -icon_width,
		localpos_r = icon_width,
		localpos_b = 0,
	}

	this.playerlist.iconkills = NewIFImage {
		ZPos = 0,
		texture = "stats_kills",
		x = icon_x + icon_offset,
		y = InfoBoxH * -0.5 + icon_offset_y,
		localpos_l = 0,
		localpos_t = -icon_width,
		localpos_r = icon_width,
		localpos_b = 0,
	}

	this.playerlist.icondeaths = NewIFImage {
		ZPos = 0,
		texture = "stats_deaths",
		x = icon_x + 2 * icon_offset,
		y = InfoBoxH * -0.5 + icon_offset_y,
		localpos_l = 0,
		localpos_t = -icon_width,
		localpos_r = icon_width,
		localpos_b = 0,
	}

	this.playerlist.iconheropoints = NewIFImage {
		ZPos = 0,
		texture = "hero_points",
		x = icon_x + 3 * icon_offset,
		y = InfoBoxH * -0.5 + icon_offset_y,
		localpos_l = 0,
		localpos_t = -icon_width,
		localpos_r = icon_width,
		localpos_b = 0,
	}
	
	local launch_button_y = 15
	--this.Helptext_Back.y = launch_button_y
	
	local BackButtonW = 180
	local BackButtonH = ScriptCB_GetFontHeight("gamefont_medium")
	this.donebutton =	NewPCIFButton
	{
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bottom
		y = launch_button_y, -- just above bottom
		x = -BackButtonW + 120,
		btnw = BackButtonW,
		btnh = BackButtonH,
		font = "gamefont_medium",
		tag = "_ok",
		string = "common.join",
	}

	--
	-- Build up Edit box for password
	--

	if(gPlatformStr == "PC") then
		local EditBoxW = 500
		
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
			passbackbutton = NewPCIFButton {
				y = 35,
				btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
				btnh = BackButtonH,
				font = "gamefont_medium",
				tag = "_passback",
				string = "common.cancel",
			},

		}
		this.PassBox.passokbutton.x = (EditBoxW - BackButtonW - 16) * 0.5 
		this.PassBox.passbackbutton.x = (EditBoxW - BackButtonW - 16) * -0.5
		this.PassBox.title.x = EditBoxW * -0.5
	end
	
	this.refreshbutton =	NewPCIFButton
	{
		ScreenRelativeX = 0.65, -- left
		ScreenRelativeY = 1.0, -- bottom
		y = launch_button_y, -- just above bottom
		x = -10,
		btnw = BackButtonW, -- made wider to fix 9173 - NM 8/25/04
		btnh = BackButtonH,
		font = "gamefont_medium",
		tag = "_refresh",
		string = "ifs.mp.sessionlist.refresh",
	}

	mpsessionlist_serverinfo_layout.FirstShownIdx = 1
	mpsessionlist_serverinfo_layout.SelectedIdx = 1
	mpsessionlist_serverinfo_layout.CursorIdx = 1
	mpsessionlist_playerlist_layout.FirstShownIdx = 1
	mpsessionlist_playerlist_layout.SelectedIdx = 1
	mpsessionlist_playerlist_layout.CursorIdx = 1
	mpsessionlist_maplist_layout.FirstShownIdx = 1
	mpsessionlist_maplist_layout.SelectedIdx = 1
	mpsessionlist_maplist_layout.CursorIdx = 1
	mpsessionlist_eratypelist_layout.FirstShownIdx = 1
	mpsessionlist_eratypelist_layout.SelectedIdx = 1
	mpsessionlist_eratypelist_layout.CursorIdx = 1
	mpsessionlist_servertypelist_layout.FirstShownIdx = 1
	mpsessionlist_servertypelist_layout.SelectedIdx = 1
	mpsessionlist_servertypelist_layout.CursorIdx = 1

	mpsessionlist_gamemodelist_layout.FirstShownIdx = 1
	mpsessionlist_gamemodelist_layout.SelectedIdx = 1
	mpsessionlist_gamemodelist_layout.CursorIdx = 1

	if(gPlatformStr == "PC") then
--		print(" +++add tabs")
		-- Add tabs to screen
		ifelem_tabmanager_Create(this, gPCMainTabsLayout, gPCMultiPlayerTabsLayout)
	end

	-- add source listbox
	ifs_mp_sessionlist_fnAddSourceList( this )	
	
	-- add gamespy logo & login
	ifs_mp_sessionlist_fnAddGamespyLogin( this )
end

ifs_mp_sessionlist_fnBuildScreen(ifs_mp_sessionlist)
ifs_mp_sessionlist_fnBuildScreen = nil

AddIFScreen(ifs_mp_sessionlist,"ifs_mp_sessionlist")
