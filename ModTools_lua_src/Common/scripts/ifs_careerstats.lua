--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
-------------------
-- Create functions
-------------------
-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.

function CareerStats_Statbox_CreateItem(layout)
	--print ("CareerStats_Statbox_CreateItem")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y = layout.y - 10
	}

	Temp.labelstr = NewIFText {
		x = 5, y = -3,
		textw = layout.width * 0.9, halign = "left", valign = "vcenter",
		font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.contentsstr = NewIFText {
		x = 0.65 * layout.width - 5, y = -3, 
		textw = layout.width * 0.35, halign = "right", valign = "vcenter",
		font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 0,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	return Temp
end

function CareerStats_Medalbox_CreateItem(layout)
	--print ("CareerStats_Medalbox_CreateItem")
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y = layout.y - 10
	}

	Temp.labelustr = NewIFText {
		x = 7, y = -4, textw = 0.8 * layout.width, halign = "left", valign = "vcenter",
		font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.val1str = NewIFText {
		x = 0.5 * layout.width, y = -4, 
		textw = 0.15 * layout.width, halign = "right", valign = "vcenter",
		font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 0,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.val2str = NewIFText {
		x = 0.6 * layout.width - 5, y = -4, 
		textw = 0.4 * layout.width, halign = "right", valign = "vcenter",
		font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	
	return Temp
end

---------------------
-- Populate functions
---------------------
-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function CareerStats_Statbox_PopulateItem(Dest, Data)
	--print ("CareerStats_Statbox_PopulateItem")
	if (Data) then
		--IFText_fnSetUString(Dest.labelstr, Data.labelustr)
		ifs_careerstats_fnShrinkToFit(Dest.labelstr, Data.labelustr, CareerStats_statbox_leftcolumn_layout.width * 0.70 - 5)
		if ( Data.contentsstr ) then
			IFText_fnSetString(Dest.contentsstr, Data.contentsstr)
		else
		--	IFText_fnSetUString(Dest.contentsstr, Data.contentsustr)
			ifs_careerstats_fnShrinkToFit(Dest.contentsstr, Data.contentsustr, CareerStats_statbox_leftcolumn_layout.width * 0.3 - 5)
		end
	end

	IFObj_fnSetVis(Dest, Data)
end

function ifs_careerstats_fnShrinkToFit(deststr, datastr, nameWidth)
	--print ( ScriptCB_ununicode( datastr ) )
	local TextHScale = 1.0
	IFText_fnSetScale(deststr, TextHScale, 1.0)
	IFText_fnSetUString(deststr, datastr)
	local fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(deststr)
	local TextW = fRight - fLeft
	-- Initial guess at scale: a very close fit
	TextHScale = math.min(1.0, nameWidth / TextW)
	--	print("Initial TextHScale = ", TextHScale)
	while ( TextW > nameWidth ) do
		IFText_fnSetScale(deststr, TextHScale, 1.0)
		IFText_fnSetUString(deststr, datastr)
		fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(deststr)
		TextW = fRight - fLeft
		TextHScale = TextHScale * 0.95 -- shrink over time
	--		print("Shrunk TextHScale to ", TextHScale)
	end --until (TextW < nameWidth)
end

function CareerStats_Medalbox_PopulateItem(Dest, Data, bSelected, r, g, b, a)
	--print ("CareerStats_Medalbox_PopulateItem")
	if (Data) then
		-- medal
		--IFText_fnSetUString(Dest.labelustr, Data.labelustr)
		ifs_careerstats_fnShrinkToFit(Dest.labelustr, Data.labelustr, CareerStats_medalbox_leftcolumn_layout.width * 0.55 - 7)

		-- number
		if ( Data.val1str ) then
			IFText_fnSetString(Dest.val1str, Data.val1str)
		end

		-- skill -- shrink below
		--if ( Data.val2str ) then
		--	IFText_fnSetUString(Dest.val2str, ifs_careerstats_fnGetLevelStr(Data.val2str))
		--end
		
		ifs_careerstats_fnShrinkToFit(Dest.val2str, ifs_careerstats_fnGetLevelStr(Data.val2str),
			CareerStats_medalbox_leftcolumn_layout.width * 0.35 - 5)
	end
	IFObj_fnSetVis(Dest, Data)
end

----------
-- layouts
----------
CareerStats_statbox_leftcolumn_layout = {
	showcount = 4,
	yHeight = 20,
	ySpacing  = 2,
	width = 250,
	x = 0,
	font = "gamefont_tiny",
	CreateFn = CareerStats_Statbox_CreateItem,
	PopulateFn = CareerStats_Statbox_PopulateItem,
}
CareerStats_statbox_rightcolumn_layout = {
	showcount = 4,
	yHeight = 20,
	ySpacing  = 2,
	width = 250,
	x = 0,
	font = "gamefont_tiny",
	CreateFn = CareerStats_Statbox_CreateItem,
	PopulateFn = CareerStats_Statbox_PopulateItem,
}

CareerStats_medalbox_leftcolumn_layout = {
	showcount = 5,
	yHeight = 26,
	ySpacing  = -3,
	yTop = -48,
	width = 250,
	x = 0,
	font = "gamefont_tiny",
	CreateFn = CareerStats_Medalbox_CreateItem,
	PopulateFn = CareerStats_Medalbox_PopulateItem,
}
CareerStats_medalbox_rightcolumn_layout = {
	showcount = 4,
	yHeight = 26,
	ySpacing  = -3,
	yTop = -37,
	width = 250,
	x = 0,
	font = "gamefont_tiny",
	CreateFn = CareerStats_Medalbox_CreateItem,
	PopulateFn = CareerStats_Medalbox_PopulateItem,
}

-------------------------------------------
-- where the c++ calls dump all their stuff
-------------------------------------------
stats_listbox_contents = {}
stats_medalbox_left_contents = {}
stats_medalbox_right_contents = {}


-- Helper function, blanks out the onscreen contents. Used to keep the
-- glyphcache from overloading.
function ifs_careerstats_fnBlankContents(this)
	local i, Max

	local BlankUStr = ScriptCB_tounicode("")

	Max = table.getn(stats_listbox_contents)
	for i = 1, Max do
		stats_listbox_contents[i].labelustr = BlankUStr
		if(stats_listbox_contents[i].contentsustr) then
			stats_listbox_contents[i].contentsustr = BlankUStr
		else
			stats_listbox_contents[i].contentsstr = BlankUStr
		end
	end
	Max = table.getn(stats_medalbox_left_contents)
	for i = 1, Max do
		stats_medalbox_left_contents[i].labelustr = BlankUStr
		stats_medalbox_left_contents[i].val1str = ""
		stats_medalbox_left_contents[i].val2str = ""
	end
	Max = table.getn(stats_medalbox_right_contents)
	for i = 1, Max do
		stats_medalbox_right_contents[i].labelustr = BlankUStr
		stats_medalbox_right_contents[i].val1str = ""
		stats_medalbox_right_contents[i].val2str = ""
	end

	ListManager_fnFillContents(this.statBox.leftColumn, stats_listbox_contents, CareerStats_statbox_leftcolumn_layout)
	ListManager_fnFillContents(this.statBox.rightColumn, stats_listbox_contents, CareerStats_statbox_rightcolumn_layout)
	ListManager_fnFillContents(this.medalBox.leftColumn, stats_medalbox_contents_left, CareerStats_medalbox_leftcolumn_layout)
	ListManager_fnFillContents(this.medalBox.rightColumn, stats_medalbox_contents_right, CareerStats_medalbox_rightcolumn_layout)
end

function ifs_careerstats_fnGetLevelStr(idx)
	local str = ""
	if ( idx == "0" ) then
		str = "ifs.stats.medallevel.green"
	elseif ( idx == "1" ) then
		str = "ifs.stats.medallevel.veteran"
	elseif ( idx == "2" ) then
		str = "ifs.stats.medallevel.elite"
	elseif ( idx == "3" ) then
		str = "ifs.stats.medallevel.legendary"
	end
	return ScriptCB_getlocalizestr(str)
end

function ifs_careerstats_fnGetRankStr(idx)
	local str = ""
	if ( idx == 0 ) then
		str = "ifs.stats.playertitle.private"
	elseif ( idx == 1 ) then
		str = "ifs.stats.playertitle.sergeant"
	elseif ( idx == 2 ) then
		str = "ifs.stats.playertitle.captain"
	elseif ( idx == 3 ) then
		str = "ifs.stats.playertitle.general"
	end
	return ScriptCB_getlocalizestr(str)
end

-- ifs.stats.Rank == "Rank"
function ifs_careerstats_fnSetRankStr(this, idx)
	local rank = ifs_careerstats_fnGetRankStr(idx)
	local info = ""
	if ( idx == 0 ) then
		info = "ifs.stats.playertitleinfo.private"
	elseif ( idx == 1 ) then
		info = "ifs.stats.playertitleinfo.sergeant"
	elseif ( idx == 2 ) then
		info = "ifs.stats.playertitleinfo.captain"
	elseif ( idx == 3 ) then
		info = "ifs.stats.playertitleinfo.general"
	end
	info = ScriptCB_getlocalizestr(info)
	IFText_fnSetUString(this.medalBox.rank, ScriptCB_getlocalizestr("ifs.stats.rank") .. ScriptCB_tounicode(": ") .. rank .. " " .. info)
end

function ifs_careerstats_fnUpdateMedalSelection(this)
	local str = "game.awards.medalinfo."
	-- be all ghetto like this because i don't know how to get the string back out of the text object
	local infoleft = {"gunslinger", "demolition", "regulator", "guardian", "frenzy",}
	local inforight = {"technician", "marksman", "endurance", "warhero"}
	local enumOrder = {0, 2, 5, 7, 1, 3, 4, 6, 8}	-- matches enum in medalsmgr.h!
	local countleft = { {6, 4}, {4, 3}, {8, 6}, {24, 18}, {12, 9} }
	local countright = { {1, 1}, {6, 4}, {12, 9}, {36, 27}, }
	if ( this.bCursorOnLeft ) then
		local selection = CareerStats_medalbox_leftcolumn_layout.SelectedIdx
		local level = ScriptCB_GetCareerMedalLevel(-1, enumOrder[selection])
		--print ("countleft:", level, countleft[selection][level+1])
		if level > 1 then level = 2 else level = 1 end
		local infostr = ScriptCB_usprintf(str .. infoleft[selection],
			ScriptCB_tounicode(string.format("%d", countleft[selection][level])))
		IFText_fnSetUString(this.infoBox.text, infostr)
	else
		local selection = CareerStats_medalbox_rightcolumn_layout.SelectedIdx
		local level = ScriptCB_GetCareerMedalLevel(-1, enumOrder[selection + 5])
		if level > 1 then level = 2 else level = 1 end
		local infostr = ScriptCB_usprintf(str .. inforight[selection],
			ScriptCB_tounicode(string.format("%d", countright[selection][level])))
		IFText_fnSetUString(this.infoBox.text, infostr)
		--IFText_fnSetUString(this.infoBox.text, 
		--	ScriptCB_getlocalizestr(str .. inforight[selection]))
	end

	-- left column
	-- recolorize this stuff
	local layouts = { CareerStats_medalbox_leftcolumn_layout, CareerStats_medalbox_rightcolumn_layout }
	local columns = { this.medalBox.leftColumn, this.medalBox.rightColumn }
	local onThisSide = { this.bCursorOnLeft, not this.bCursorOnLeft }
	for i = 1, 2 do
		for row = 1, layouts[i].showcount do
			local color = gUnselectedTextColor
			local color2 = {255, 255, 0}
			if ( onThisSide[i] and layouts[i].SelectedIdx == row ) then
				color = gSelectedTextColor
				color2 = gSelectedTextColor
			end
			IFObj_fnSetColor(columns[i][row].labelustr, color[1], color[2], color[3])
			IFObj_fnSetColor(columns[i][row].val1str, color2[1], color2[2], color2[3])
			IFObj_fnSetColor(columns[i][row].val2str, color[1], color[2], color[3])
		end
	end
end

function ifs_careerstats_fnFlipLeftRight(this)
	this.bCursorOnLeft = not this.bCursorOnLeft

	-- Flip the selections/cursor positions
	if(this.bCursorOnLeft) then
		-- Was just on the right, now on left
		local Pos = CareerStats_medalbox_rightcolumn_layout.SelectedIdx

		-- make sure the position isn't off the bottom of the listbox
		-- Pos = ScriptCB_CareerStatsValidatePos( 0, Pos );
		Pos = ifs_careerstats_fnValidateMedalCursorPos( 0, Pos )
		
		CareerStats_medalbox_leftcolumn_layout.CursorIdx = Pos
		CareerStats_medalbox_rightcolumn_layout.CursorIdx = nil
		CareerStats_medalbox_leftcolumn_layout.SelectedIdx = Pos
		CareerStats_medalbox_rightcolumn_layout.SelectedIdx = Pos

		ListManager_fnFillContents(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		-- Just move cursor on side that's now dim
		ListManager_fnMoveCursor(this.medalBox.rightColumn, CareerStats_medalbox_rightcolumn_layout)
	else
		-- Was just on the left, now on right
		local Pos = CareerStats_medalbox_rightcolumn_layout.SelectedIdx

		-- make sure the position isn't off the bottom of the listbox
		--Pos = ScriptCB_TeamStatsValidatePos( 1, Pos );
		Pos = ifs_careerstats_fnValidateMedalCursorPos(1, Pos)

		CareerStats_medalbox_rightcolumn_layout.CursorIdx = Pos
		CareerStats_medalbox_leftcolumn_layout.CursorIdx = nil
		CareerStats_medalbox_rightcolumn_layout.SelectedIdx = Pos
		CareerStats_medalbox_leftcolumn_layout.SelectedIdx = Pos

		ListManager_fnFillContents(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
		-- Just move cursor on side that's now dim
		ListManager_fnMoveCursor(this.medalBox.leftColumn, CareerStats_medalbox_leftcolumn_layout)
	end
end

--validate the cursor position (make sure we're not on a null entry)
function ifs_careerstats_fnValidateMedalCursor(this)
	local Pos = CareerStats_medalbox_leftcolumn_layout.SelectedIdx
	if(this.bCursorOnLeft) then
		Pos = ifs_careerstats_fnValidateMedalCursorPos( 0, CareerStats_medalbox_leftcolumn_layout.SelectedIdx );
	else
		Pos = ifs_careerstats_fnValidateMedalCursorPos( 1, CareerStats_medalbox_rightcolumn_layout.SelectedIdx );
	end
	
	CareerStats_medalbox_leftcolumn_layout.SelectedIdx = Pos
	CareerStats_medalbox_rightcolumn_layout.SelectedIdx = Pos

	--set the cursor to the validated position
	if(this.bCursorOnLeft) then		
		CareerStats_medalbox_leftcolumn_layout.CursorIdx = Pos
		CareerStats_medalbox_rightcolumn_layout.CursorIdx = nil
	else
		CareerStats_medalbox_leftcolumn_layout.CursorIdx = nil
		CareerStats_medalbox_rightcolumn_layout.CursorIdx = Pos
	end
	ListManager_fnMoveCursor(this.medalBox.leftColumn, CareerStats_medalbox_leftcolumn_layout)
	ListManager_fnMoveCursor(this.medalBox.rightColumn, CareerStats_medalbox_rightcolumn_layout)
end

function ifs_careerstats_fnValidateMedalCursorPos(col, pos)
	local layout = CareerStats_medalbox_leftcolumn_layout
	if ( col == 1 ) then
		layout = CareerStats_medalbox_rightcolumn_layout
	end
	local idx = pos
	if ( pos < 1 ) then idx = 1 end
	if ( pos > layout.showcount ) then idx = layout.showcount end
	return idx
end

ifs_careerstats = NewIFShellScreen {
	nologo = 1,
	fMAX_IDLE_TIME = 30.0,
	fCurIdleTime = 0,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = shell_sub_left, -- played while the screen is displayed
	bDimBackdrop = 1,

	title = NewIFText {
		string = "ifs.stats.careerstatstitle",
		font = "gamefont_medium",
		y = 0,
		textw = 460,
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.017,
		ColorR= gTitleTextColor[1], ColorG = gTitleTextColor[2], ColorB = gTitleTextColor[3], -- Something that's readable!
		style = "normal",
		--nocreatebackground = 1,
		halign = "hcenter",
		bgleft = "bf2_buttons_topleft",
		bgmid = "bf2_buttons_title_center",
		bgright = "bf2_buttons_topright",
		bg_width = 460, 
	},

	--bgTexture = NewIFImage { 
	--	ZPos = 250,
	--	ScreenRelativeX = 0,
	--	ScreenRelativeY = 0,
	--	UseSafezone = 0,
	--	texture = "statsscreens_bg", 
	--	localpos_l = 0,
	--	localpos_t = 0,
	--	-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	--},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		
		if ( ScriptCB_GetShellActive() ) then
			IFObj_fnSetVis(this.Helptext_Accept, nil)
		end
	
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		CareerStats_statbox_leftcolumn_layout.FirstShownIdx = 1
		CareerStats_statbox_leftcolumn_layout.SelectedIdx = nil -- not on anything
		CareerStats_statbox_leftcolumn_layout.CursorIdx = nil
		CareerStats_statbox_rightcolumn_layout.FirstShownIdx = 1
		CareerStats_statbox_rightcolumn_layout.SelectedIdx = nil -- not on anything
		CareerStats_statbox_rightcolumn_layout.CursorIdx = nil
		
		CareerStats_medalbox_leftcolumn_layout.FirstShownIdx = 1
		CareerStats_medalbox_leftcolumn_layout.SelectedIdx = 1
		CareerStats_medalbox_leftcolumn_layout.CursorIdx = 1
		CareerStats_medalbox_rightcolumn_layout.FirstShownIdx = 1
		CareerStats_medalbox_rightcolumn_layout.SelectedIdx = 1
		CareerStats_medalbox_rightcolumn_layout.CursorIdx = nil
		
		-- -1 to mean get local player
		local charIdx = -1
		if ( ScriptCB_GetShellActive() ~= true ) then
			charIdx = ScriptCB_GetPlayerIDAtRank(this.fTeam, this.fIdx)
		end

		this.bCursorOnLeft = 0

		ScriptCB_GetCareerPersonalStats(charIdx, 0)
		ListManager_fnFillContents(this.statBox.leftColumn, stats_listbox_contents, CareerStats_statbox_leftcolumn_layout)
		ScriptCB_GetCareerPersonalStats(charIdx, 1)
		ListManager_fnFillContents(this.statBox.rightColumn, stats_listbox_contents, CareerStats_statbox_rightcolumn_layout)

		-- fill in rank stuff
		--local rankIdx = ScriptCB_GetCareerRank(charIdx)
		--ifs_careerstats_fnSetRankStr(this, rankIdx)

		ScriptCB_GetCareerMedals(charIdx, 0)
		ListManager_fnFillContents(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		ScriptCB_GetCareerMedals(charIdx, 1)
		ListManager_fnFillContents(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)

		-- turn things blue, fill in the info text, etc.
		ifs_careerstats_fnUpdateMedalSelection(this)
		
		if((ScriptCB_InNetGame()) and (ScriptCB_GetGameRules() == "metagame") and (ScriptCB_GetAmHost())) then
			this.fCurIdleTime = 0
			gE3StatsTimeout = 0
		end
	end,

	-- Reduce lua memory, glyphcache usage
	Exit = function(this, bFwd)
		ifs_careerstats_fnBlankContents(this)
		stats_listbox_contents = nil
		stats_medalbox_left_contents = nil
		stats_medalbox_right_contents = nil
	end,

	-- Accept button calls done
	Input_Accept = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME
		if ( ScriptCB_GetShellActive() ) then
			--ScriptCB_PopScreen();
			--ScriptCB_SndPlaySound("shell_menu_exit");
		elseif (not gE3StatsTimeout or gE3StatsTimeout < 0) then
			if(ScriptCB_CanClientLeaveStats()) then
				ScriptCB_QuitFromStats()
				ScriptCB_SndPlaySound("shell_menu_enter")
			end
		end
	end,

	-- Back button goes to personal stat screen
	Input_Back = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ScriptCB_PopScreen();
		ScriptCB_SndPlaySound("shell_menu_exit");
		--ifs_careerstats_fnUpdateMedalSelection(this)
	end,

	Input_GeneralUp = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ListManager_fnNavUp(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		ListManager_fnNavUp(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
		ifs_careerstats_fnValidateMedalCursor(this)
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,

	Input_GeneralDown = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ListManager_fnNavDown(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		ListManager_fnNavDown(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
		--validate the cursor position (make sure we're not on a null entry)
		ifs_careerstats_fnValidateMedalCursor(this)
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,

	Input_LTrigger = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ListManager_fnPageUp(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		ListManager_fnPageUp(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
		ifs_careerstats_fnValidateMedalCursor(this)
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,

	Input_RTrigger = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ListManager_fnPageDown(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
		ListManager_fnPageDown(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
		--validate the cursor position (make sure we're not on a null entry)
		ifs_careerstats_fnValidateMedalCursor(this)
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,

	Input_GeneralLeft = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ifs_careerstats_fnFlipLeftRight(this)
		ScriptCB_SndPlaySound("shell_select_change");
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,
	Input_GeneralRight = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ifs_careerstats_fnFlipLeftRight(this)
		ScriptCB_SndPlaySound("shell_select_change");
		ifs_careerstats_fnUpdateMedalSelection(this)
	end,

 	Update = function(this, fDt)
 		-- Call default base class's update function (make button bounce)
 		gIFShellScreenTemplate_fnUpdate(this,fDt)

		-- If the host is busy, then wait on this screen
		if(fDt > 0.5) then
			fDt = 0.5 -- clamp this to sane values
		end

		if(ScriptCB_CanClientLeaveStats()) then
			gE3StatsTimeout = 0 -- allow quit now
		else
			gE3StatsTimeout = 1 -- keep clients from leaving
		end

		if(gE3StatsTimeout) then
			gE3StatsTimeout = gE3StatsTimeout - fDt
		end

		-- if we've been sitting here for a while, bail to the teaser screen
		this.fCurIdleTime = this.fCurIdleTime - fDt
		if((this.fCurIdleTime < 0) and (not gE3StatsTimeout or gE3StatsTimeout < 0 or ScriptCB_GetShellActive())) then
			this.fCurIdleTime = 100
			ScriptCB_QuitFromStats()
			ScriptCB_SndPlaySound("shell_menu_enter")
		end
 	end,

	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global stats_listbox_contents
 	RepaintListbox = function(this)
 		ListManager_fnFillContents(this.medalBox.leftColumn, stats_medalbox_left_contents, CareerStats_medalbox_leftcolumn_layout)
 		ListManager_fnFillContents(this.medalBox.rightColumn, stats_medalbox_right_contents, CareerStats_medalbox_rightcolumn_layout)
	end,
}

-- Helper function, sets up parts of this screen that need any
-- programmatic work (i.e. scaling to screensize)
function ifs_careerstats_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r,b,v,widescreen=ScriptCB_GetScreenInfo()
	--this.bgTexture.localpos_l = 0
	--this.bgTexture.localpos_t = 0
	--this.bgTexture.localpos_r = r*widescreen
	--this.bgTexture.localpos_b = b
	--this.bgTexture.uvs_b = v

	if(this.Helptext_Back) then
		IFText_fnSetString(this.Helptext_Back.helpstr, "ifs.stats.back")
	end
	if(this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr, "ifs.stats.done")
	end

	-- Inset slightly from fulls screen size
	local w,h = ScriptCB_GetSafeScreenInfo()
--	w = w * 0.95
	--h = h * 0.82

	this.title.bg_width = w * 0.945
	this.title.bgoffsetx = w * -0.009
	this.title.bgexpandy = 6

	-- stat window
	this.statBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.20,
		width = w,
		height = h * 0.25,
		zPos = 200,
	}
	this.statBox.window = NewButtonWindow { ZPos = 200,
		x = 0, y = 0,
		width = this.statBox.width,
		height = this.statBox.height,
	}
	this.statBox.leftColumn = NewIFContainer {
		x = this.statBox.width * -0.25, y = 0,
		width = this.statBox.width * 0.45,
		height = this.statBox.height,
	}
	this.statBox.rightColumn = NewIFContainer {
		x = this.statBox.width * 0.25, y = 0,
		width = this.statBox.width * 0.45,
		height = this.statBox.height,
	}

	
	-- medals window
	this.medalBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.51,
		width = w,
		height = h * 0.39,
		zPos = 200,
	}
	this.medalBox.window = NewButtonWindow { ZPos = 200,
		x = 0, y = 0,
		width = this.medalBox.width,
		height = this.medalBox.height,
	}

	this.medalBox.label = NewIFText {
		x = this.medalBox.width * -0.5 + 10,
		y = this.medalBox.height * -0.5 + 20,
		textw = this.medalBox.width - 10, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 0,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
		string = "ifs.stats.CareerMedals",
	}
	this.medalBox.leftColumn = NewIFContainer {
		x = this.medalBox.width * -0.25, y = 18,
		width = this.medalBox.width * 0.45,
		height = this.medalBox.height,
	}
	this.medalBox.rightColumn = NewIFContainer {
		x = this.medalBox.width * 0.25, y = 7,	-- raise this because there are fewer elements in this container
		width = this.medalBox.width * 0.45,
		height = this.medalBox.height,
	}
	
	-- info window
	this.infoBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.81,
		width = w,
		height = h * 0.215,
	}
	
	this.infoBox.window = NewButtonWindow { ZPos = 200,
		x = 0, y = 0,
		width = this.infoBox.width,
		height = this.infoBox.height,
	}
	this.infoBox.text = NewIFText {
		x = -0.5 * this.infoBox.width + 10, y = -0.5 * this.infoBox.height + 10,
		textw = 0.95 * this.infoBox.width, texth = this.infoBox.height * 0.8,
		halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}

	--CareerStats_listbox_layout.width = w - 50
	--CareerStats_listbox_layout.showcount = math.floor(h / (CareerStats_listbox_layout.yHeight + CareerStats_listbox_layout.ySpacing)) - 1

	--ListManager_fnInitList(ifs_careerstats.listbox,CareerStats_listbox_layout)
	
	CareerStats_statbox_leftcolumn_layout.width = 0.49 * w
	CareerStats_statbox_rightcolumn_layout.width = 0.49 * w
	CareerStats_medalbox_leftcolumn_layout.width = 0.49 * w
	CareerStats_medalbox_rightcolumn_layout.width = 0.49 * w

	ListManager_fnInitList(ifs_careerstats.statBox.leftColumn, CareerStats_statbox_leftcolumn_layout)
	ListManager_fnInitList(ifs_careerstats.statBox.rightColumn, CareerStats_statbox_rightcolumn_layout)
	ListManager_fnInitList(ifs_careerstats.medalBox.leftColumn, CareerStats_medalbox_leftcolumn_layout)
	ListManager_fnInitList(ifs_careerstats.medalBox.rightColumn, CareerStats_medalbox_rightcolumn_layout)
end

ifs_careerstats_fnBuildScreen(ifs_careerstats) -- programatic chunks
ifs_careerstats_fnBuildScreen = nil

AddIFScreen(ifs_careerstats,"ifs_careerstats")
ifs_careerstats = DoPostDelete(ifs_careerstats)
