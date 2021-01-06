--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Multiplayer game name screen.

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function PersonalStats_ListboxGameStats_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}
	Temp.labelstr = NewIFText{
		x = -10, y = 0, textw = 0.5 * layout.width, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.contentsstr = NewIFText{ 
		x = 0.2 * layout.width + 10, y = 0, 
		textw = 0.8 * layout.width, halign = "right", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function PersonalStats_ListboxGameStats_PopulateItem(Dest,Data)
	if(Data) then
		-- Contents to show. Do so.
		--IFText_fnSetUString(Dest.labelstr,Data.labelustr)
		if ( Data.labelustr ) then
			ifs_careerstats_fnShrinkToFit(Dest.labelstr, Data.labelustr, PersonalStats_listboxGameStats_layout.width * 0.4 - 10)
		end
		if(Data.contentsustr) then
--			IFText_fnSetUString(Dest.contentsstr,Data.contentsustr)
			ifs_careerstats_fnShrinkToFit(Dest.contentsstr, Data.contentsustr, PersonalStats_listboxGameStats_layout.width * 0.6 - 10)
		else
			IFText_fnSetString(Dest.contentsstr,Data.contentsstr)
		end
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end


function PersonalStats_ListboxMedals_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}
	
	Temp.leftStr = NewIFText{
		x = 0, y = 0, textw = 0.4 * layout.width, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.leftStrCount = NewIFText {
		x = 0.4 * layout.width, y = 0, textw = 0.1 * layout.width, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	
	Temp.rightStr = NewIFText{ 
		x = 0.5 * layout.width, y = 0, 
		textw = 0.4 * layout.width, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.rightStrCount = NewIFText {
		x = 0.9 * layout.width, y = 0, textw = 0.1 * layout.width, halign = "left", font = "gamefont_tiny",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function PersonalStats_ListboxMedals_PopulateItem(Dest,Data)
	-- populate each column
	if (Data) then
		IFText_fnSetUString(Dest.leftStr, Data.leftStr)
		IFText_fnSetUString(Dest.rightStr, Data.rightStr)
		
		local countStr = " (" .. Data.leftStrCount .. ")"
		IFText_fnSetString(Dest.leftStrCount, countStr)
		countStr = " (" .. Data.rightStrCount .. ")"
		IFText_fnSetString(Dest.rightStrCount, countStr)
	end
	
	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

function ifs_personalstats_fnSetUpListboxMedals(this)
	local y_spacing = 15
	for i = 1, 5 do
		-- left
		this.listboxMedals[2*i - 1] = NewIFText {
			x = -0.465 * this.listboxMedals.width,
			y = -0.45 * this.listboxMedals.height + y_spacing * (i - 1),
			textw = 0.5 * this.listboxMedals.width,
			halign = "left",
			font = "gamefont_tiny",
			ColorR = 255, ColorG = 255, ColorB = 255,
			style = "normal",
			nocreatebackground = 1,
			startdelay = math.random() * 0.25,
		}
		-- right
		this.listboxMedals[2*i] = NewIFText {
			x = 0,
			y = -0.465 * this.listboxMedals.height + y_spacing * (i - 1),
			textw = 0.5 * this.listboxMedals.width,
			halign = "left",
			font = "gamefont_tiny",
			ColorR = 255, ColorG = 255, ColorB = 255,
			style = "normal",
			nocreatebackground = 1,
			startdelay = math.random() * 0.25,
		}
	end
end

-- same order as medalsmgr.h
function ifs_personalstats_fnGetMedalName(i)
	local medalnames = {
		"gunslinger",
		"frenzy",
		"demolition",
		"technician",
		"marksman",
		"regulator",
		"endurance",
		"guardian",
		"warhero",
	}
	return medalnames[i]
end
function ifs_personalstats_fnFillInListboxMedals(dest, source)
	local n = table.getn(dest)
	local curIdx = 1
	for i = 1, n do
		-- populate each column
		if (source[i]) then
			local count = source[i].medaltype
			-- only display medals that were acquired
			if ( count > 0 ) then
				-- Note: NEVER ununicode strings out of the localizedb. Will lose
				-- all accents! NM 8/5/05
				local MedalUStr = ScriptCB_getlocalizestr("game.awards.medal." .. ifs_personalstats_fnGetMedalName(i))
				count = ScriptCB_tounicode(" (" .. string.format("%d", count) .. ")")

				--print ("ifs_personalstats_fnFillInListboxMedals:", ScriptCB_ununicode(medal), ScriptCB_ununicode(count), medal .. count)
				-- This is how to append 2 unicode strings - NM 8/5/05
				local ShowUStr = ScriptCB_usprintf("common.pctspcts", MedalUStr, count)
				IFText_fnSetUString(dest[curIdx], ShowUStr)
				curIdx = curIdx + 1
			end
		end
		
		--IFObj_fnSetVis(dest[i], source[i]) -- Show if there are contents
	end
	for i = curIdx, n do
		IFText_fnSetUString(dest[i], ScriptCB_tounicode(""))
	end
end

PersonalStats_listboxGameStats_layout = {
	showcount = 20,
--	yTop = -130 + 13,
	yHeight = 11,
	ySpacing  = 5,
	width = 430,
	x = 0,
--	slider = 1,
	CreateFn = PersonalStats_ListboxGameStats_CreateItem,
	PopulateFn = PersonalStats_ListboxGameStats_PopulateItem,
}

PersonalStats_listboxMedals_layout = {
	showcount = 5,
--	yTop = -130 + 13,
	yHeight = 13,
	ySpacing  = 5,
	width = 430,
	x = 0,
--	slider = 1,
	CreateFn = PersonalStats_ListboxMedals_CreateItem,
	PopulateFn = PersonalStats_ListboxMedals_PopulateItem,
}
stats_listbox_contents = {
	-- Filled in from C++
	-- Stubbed to show the string.format it wants.
--	{ labelustr = "Player 1", contentsstr = "5"},
-- **OR**
--	{ labelustr = " Favorite Vehicle", contentsustr = "AT-ST"}, 
}

medal_contents = {}

-- Helper function, blanks out the onscreen contents. Used to keep the
-- glyphcache from overloading.
function ifs_personalstats_fnBlankContents(this)
	local i,Max

	local BlankUStr = ScriptCB_tounicode("")

	Max = table.getn(stats_listbox_contents)
	for i=1,Max do
		if (stats_listbox_contents[i].labelustr) then
			stats_listbox_contents[i].labelustr = BlankUStr
		else
			stats_listbox_contents[i].labelstr = BlankUStr
		end
		if(stats_listbox_contents[i].contentsustr) then
			stats_listbox_contents[i].contentsustr = BlankUStr
		else
			stats_listbox_contents[i].contentsstr = ""
		end
		stats_listbox_contents[i].leftStr = BlankUStr
		stats_listbox_contents[i].rightStr = BlankUStr
		stats_listbox_contents[i].leftStrCount = ""
		stats_listbox_contents[i].rightStrCount = ""
	end

	ListManager_fnFillContents(this.listboxGameStats,stats_listbox_contents,PersonalStats_listboxGameStats_layout)
	--ListManager_fnFillContents(this.listboxMedals,stats_listbox_contents,PersonalStats_listboxMedals_layout)
	-- fix me.
	-- omg don't squish medal_contents until we're truly quitting from the stats screens.
	-- in fact, you know, it's just nine shorts, so i'm fine with leaving it around forever and ever. =p
	--ifs_personalstats_fnFillInListboxMedals(this.listboxMedals, medal_contents)
end

ifs_personalstats = NewIFShellScreen {
	nologo = 1,
	fMAX_IDLE_TIME = 30.0,
	fCurIdleTime = 0,
	movieIntro      = nil, -- played before the screen is displayed
	movieBackground = nil, -- played while the screen is displayed
	--bNohelptext_back = 1, -- We use PS2-Square/XBox-X to exit this screen.
	bAcceptIsSelect = 1,

	titlePersonalStats = NewIFText {
		string = "ifs.stats.personalstatstitle",
		font = "gamefont_medium",
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.017,
		textw = 450,
		ColorR= gTitleTextColor[1], ColorG = gTitleTextColor[2], ColorB = gTitleTextColor[3], -- Something that's readable!
		style = "normal",
		--nocreatebackground = 1,
		halign = "hcenter",
		bgleft = "bf2_buttons_topleft",
		bgmid = "bf2_buttons_title_center",
		bgright = "bf2_buttons_topright",
		bg_width = 460, 
	},

	titleMedals = NewIFText {
		string = "ifs.stats.medals",
		font = "gamefont_medium",
		y = 0,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, 
		ScreenRelativeY = 0.539, 
		ColorR= gTitleTextColor[1], ColorG = gTitleTextColor[2], ColorB = gTitleTextColor[3], -- Something that's readable!
		style = "normal",
		--nocreatebackground = 1,
		halign = "hcenter",
		bgleft = "bf2_buttons_topleft",
		bgmid = "bf2_buttons_title_center",
		bgright = "bf2_buttons_topright",
		bg_width = 460, 
	},
	
	bgTexture = NewIFImage { 
		ZPos = 250,
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		UseSafezone = 0,
		texture = "statsscreens_bg", 
		localpos_l = 0,
		localpos_t = 0,
		-- Size, UVs aren't fully specified here, but in NewIFShellScreen()
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
	
		if(this.Helptext_Back) then
			IFText_fnSetString(this.Helptext_Back.helpstr, "ifs.stats.back")
			gHelptext_fnMoveIcon(this.Helptext_Back)
		end

		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		PersonalStats_listboxGameStats_layout.FirstShownIdx = 1
		PersonalStats_listboxGameStats_layout.SelectedIdx = nil -- not on anything
		PersonalStats_listboxGameStats_layout.CursorIdx = nil

		PersonalStats_listboxMedals_layout.FirstShownIdx = 1
		PersonalStats_listboxMedals_layout.SelectedIdx = nil -- not on anything
		PersonalStats_listboxMedals_layout.CursorIdx = nil

		-- !? temp ?! --
		-- find the top player's team and index (top as in, if there's splitscreen, the guy's on top.
		-- hopefully, that's the guy on top...)
		--this.fTeam = GetCharacterTeam(0)
		--this.fIdx = -1 --ScriptCB_GetRank(this.fTeam, 0)  -- -1 : get local player

		ScriptCB_GetPersonalStats(this.fTeam, this.fIdx) 
		ListManager_fnFillContents(this.listboxGameStats,stats_listbox_contents,PersonalStats_listboxGameStats_layout)
		ScriptCB_GetMedalStats(ifs_personalstats.fTeam, ifs_personalstats.fIdx)
		--ListManager_fnFillContents(this.listboxMedals,stats_listbox_contents,PersonalStats_listboxMedals_layout)
		ifs_personalstats_fnFillInListboxMedals(this.listboxMedals, stats_listbox_contents)--medal_contents)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 

		if((ScriptCB_InNetGame()) and (ScriptCB_GetGameRules() == "metagame") and (ScriptCB_GetAmHost())) then
			this.fCurIdleTime = 0
			gE3StatsTimeout = 0
		end
		
		-- if this is a human player, set help buttons to indicate next screen as career screen
		if ( ScriptCB_GetPlayerIDAtRank(this.fTeam, this.fIdx) >= 0 ) then
			IFObj_fnSetVis(this.Helptext_Accept, 1)
			IFObj_fnSetVis(this.Helptext_Done, nil)
			this.bCanShowDone = nil -- Update() also modifies Helptext_Done.
		else	-- else set next button to say square to exit
			--IFText_fnSetString(this.Helptext_Accept, "ifs.stats.done")
			IFObj_fnSetVis(this.Helptext_Accept, nil)
			IFObj_fnSetVis(this.Helptext_Done, 1)
			this.bCanShowDone = 1 -- Update() also modifies Helptext_Done.
		end
	end,

	Exit = function(this, bFwd)
		-- Reduce lua memory, glyphcache usage
		ifs_personalstats_fnBlankContents(this)
		teamstats_listbox_contents = nil
	end,

	-- Accept button goes to team stats screen
	Input_Accept = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		-- only go to the careerstats page if the player is a human player
		ifs_careerstats.fTeam = this.fTeam
		ifs_careerstats.fIdx = this.fIdx
		if ( ScriptCB_GetPlayerIDAtRank(this.fTeam, this.fIdx) >= 0 ) then
			ifs_movietrans_PushScreen(ifs_careerstats) 
			ScriptCB_SndPlaySound("shell_menu_enter")
		end
	end,

	-- Misc ( == PS2-Square/XBox-X) button quits stats
	Input_Misc = function(this)
		if(ScriptCB_CanClientLeaveStats()) then
			this.fCurIdleTime = this.fMAX_IDLE_TIME
			if(not gE3StatsTimeout or gE3StatsTimeout < 0) then
				-- now it should be safe to squish the medal_contents box
				medal_contents = nil
				
				ScriptCB_QuitFromStats()
				ScriptCB_SndPlaySound("shell_menu_exit");
			end
		end
	end,
	
	Input_Back = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		ScriptCB_PopScreen()
		ScriptCB_SndPlaySound("shell_menu_exit");
	end,

	-- No U/D/L/R functionality possible on this screen (gotta have stubs
	-- here, or the base class will override)

	Input_GeneralUp = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
	end,
	Input_GeneralDown = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
	end,
	Input_GeneralLeft = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
	end,
	Input_GeneralRight = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
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
			if(this.Helptext_Done) then
				IFObj_fnSetVis(this.Helptext_Done, this.bCanShowDone) -- show helptext depending on screen state
			end
		else
			gE3StatsTimeout = 1 -- keep clients from leaving
			if(this.Helptext_Done) then
				IFObj_fnSetVis(this.Helptext_Done, nil) -- hide helptext
			end
		end

		if(gE3StatsTimeout) then
			gE3StatsTimeout = gE3StatsTimeout - fDt
		end

		-- if we've been sitting here for a while, bail to the teaser screen
		this.fCurIdleTime = this.fCurIdleTime - fDt
		if((this.fCurIdleTime < 0) and (not gE3StatsTimeout or gE3StatsTimeout < 0)) then
			this.fCurIdleTime = 100
			ScriptCB_QuitFromStats()
			ScriptCB_SndPlaySound("shell_menu_exit");
		end
 	end,

	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global stats_listbox_contents
-- 	RepaintListbox = function(this)
-- 		ListManager_fnFillContents(this.listboxGameStats,stats_listbox_contents,PersonalStats_listboxGameStats_layout)
-- 		ListManager_fnFillContents(this.listboxMedals,stats_listbox_contents,PersonalStats_listboxMedals_layout)
--	end,
}

-- Helper function, sets up parts of this screen that need any
-- programmatic work (i.e. scaling to screensize)
function ifs_personalstats_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r,b,v,widescreen=ScriptCB_GetScreenInfo()
	this.bgTexture.localpos_l = 0
	this.bgTexture.localpos_t = 0
	this.bgTexture.localpos_r = r*widescreen
	this.bgTexture.localpos_b = b
	this.bgTexture.uvs_b = v

	if(this.Helptext_Accept) then
		IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.stats.careerstatstitle")
	end

	if(gPlatformStr ~= "PC") then
		this.Helptext_Done = NewHelptext {
			ScreenRelativeX = 1.0, -- right
			ScreenRelativeY = 1.0, -- bottom
			y = -15, -- just above bottom
			x = 0,
			bRightJustify = 1,
			buttonicon = "btnmisc",
			string = "ifs.stats.done",
		}
	end

	-- Inset slightly from fulls screen size
	local w,h = ScriptCB_GetSafeScreenInfo()
--	w = w * 0.95
	hGameStats = h * 0.44 -- 0.82
	hMedals = h * 0.3

	this.listboxGameStats = NewButtonWindow { ZPos = 200, x=0, y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.295, -- top part of screen
		width = w,
		height = hGameStats,
	}

	this.listboxMedals = NewButtonWindow { ZPos = 200, x=0, y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.745, -- bottom part of screen
		width = w,
		height = hMedals,
	}
	ifs_personalstats_fnSetUpListboxMedals(this)

	this.titlePersonalStats.bg_width = w * 0.945
	this.titlePersonalStats.bgoffsetx = w * -0.009
	this.titlePersonalStats.bgexpandy = 6
	this.titleMedals.bg_width = w * 0.945
	this.titleMedals.bgoffsetx = w * -0.009
	this.titleMedals.bgexpandy = 6

	PersonalStats_listboxGameStats_layout.width = w - 50
	PersonalStats_listboxGameStats_layout.showcount = math.floor(hGameStats / (PersonalStats_listboxGameStats_layout.yHeight + PersonalStats_listboxGameStats_layout.ySpacing)) - 1

	PersonalStats_listboxMedals_layout.width = w - 50
	PersonalStats_listboxMedals_layout.showcount = math.floor(hMedals / (PersonalStats_listboxMedals_layout.yHeight + PersonalStats_listboxMedals_layout.ySpacing)) - 1
	ListManager_fnInitList(ifs_personalstats.listboxGameStats,PersonalStats_listboxGameStats_layout)
--	ListManager_fnInitList(ifs_personalstats.listboxMedals,PersonalStats_listboxMedals_layout)
end

ifs_personalstats_fnBuildScreen(ifs_personalstats) -- programatic chunks
ifs_personalstats_fnBuildScreen = nil

AddIFScreen(ifs_personalstats,"ifs_personalstats")
ifs_personalstats = DoPostDelete(ifs_personalstats)
