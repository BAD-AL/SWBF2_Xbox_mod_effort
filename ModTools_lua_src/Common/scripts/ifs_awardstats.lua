--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Multiplayer game name screen.

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function AwardStats_Listbox_CreateItem(layout)
	-- Make a coordinate system pegged to the top-left of where the cursor would go.
	local Temp = NewIFContainer {
		x = layout.x - 0.5 * layout.width, y=layout.y - 10
	}
	Temp.labelstr = NewIFText{
		x = -10, y = 0, textw = 0.5 * layout.width, halign = "left", font = "gamefont_medium",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	Temp.contentsstr = NewIFText{ 
		x = layout.width + 10 - 0.8 * layout.width, y = 0, 
		textw = 0.8 * layout.width, halign = "right", font = "gamefont_medium",
		ColorR= 255, ColorG = 255, ColorB = 255,
		style = "normal",
		nocreatebackground = 1,
		startdelay = math.random() * 0.25,
	}
	return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with data, which may be nil (==blank it)
function AwardStats_Listbox_PopulateItem(Dest,Data)
	if(Data) then
		-- Contents to show. Do so.
		IFText_fnSetUString(Dest.labelstr,Data.labelustr)
		if(Data.contentsustr) then
			IFText_fnSetUString(Dest.contentsstr,Data.contentsustr)
		else
			IFText_fnSetString(Dest.contentsstr,Data.contentsstr)
		end
	end

	IFObj_fnSetVis(Dest,Data) -- Show if there are contents
end

AwardStats_listbox_layout = {
	showcount = 20,
--	yTop = -130 + 13,
	yHeight = 22,
	ySpacing  = 6,
	width = 430,
	x = 0,
--	slider = 1,
	CreateFn = AwardStats_Listbox_CreateItem,
	PopulateFn = AwardStats_Listbox_PopulateItem,
}

stats_listbox_contents = {
	-- Filled in from C++
	-- Stubbed to show the string.format it wants.
--	{ labelustr = "Player 1", contentsstr = "5"},
-- **OR**
--	{ labelustr = " Favorite Vehicle", contentsustr = "AT-ST"}, 
}

-- Helper function, blanks out the onscreen contents. Used to keep the
-- glyphcache from overloading.
function ifs_awardstats_fnBlankContents(this)
	local i,Max

	local BlankUStr = ScriptCB_tounicode("")

	Max = table.getn(stats_listbox_contents)
	for i=1,Max do
		stats_listbox_contents[i].labelustr = BlankUStr
		if(stats_listbox_contents[i].contentsustr) then
			stats_listbox_contents[i].contentsustr = BlankUStr
		else
			stats_listbox_contents[i].contentsstr = ""
		end
	end

	ListManager_fnFillContents(this.listbox,stats_listbox_contents,AwardStats_listbox_layout)
end

ifs_awardstats = NewIFShellScreen {
	nologo = 1,
	fMAX_IDLE_TIME = 30.0,
	fCurIdleTime = 0,
	bAcceptIsSelect = 1,

	title = NewIFText {
		string = "ifs.stats.awardstatstitle",
		font = "gamefont_large",
		y = 0,
		textw = 460, -- center on screen. Fixme: do real centering!
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0, -- top
		ColorR= 255, ColorG = 255, ColorB = 255, -- Something that's readable!
		style = "normal",
		nocreatebackground=1,
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
	
		this.fCurIdleTime = this.fMAX_IDLE_TIME 
		-- Reset listbox, show it. [Remember, Lua starts at 1!]
		AwardStats_listbox_layout.FirstShownIdx = 1
		AwardStats_listbox_layout.SelectedIdx = nil -- not on anything
		AwardStats_listbox_layout.CursorIdx = nil

		ScriptCB_GetAwardStats()
		ListManager_fnFillContents(this.listbox,stats_listbox_contents,AwardStats_listbox_layout)

		if((ScriptCB_InNetGame()) and (ScriptCB_GetGameRules() == "metagame") and (ScriptCB_GetAmHost())) then
			this.fCurIdleTime = 0
			gE3StatsTimeout = 0
		end
	end,

	-- Reduce lua memory, glyphcache usage
	Exit = function(this, bFwd)
		ifs_awardstats_fnBlankContents(this)
		stats_listbox_contents = nil
	end,

	-- Accept button calls done
	Input_Accept = function(this)
		this.fCurIdleTime = this.fMAX_IDLE_TIME
		if(not gE3StatsTimeout or gE3StatsTimeout < 0) then
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
		else
			gE3StatsTimeout = 1 -- keep clients from leaving
		end

		if(gE3StatsTimeout) then
			gE3StatsTimeout = gE3StatsTimeout - fDt
		end

		-- if we've been sitting here for a while, bail to the teaser screen
		this.fCurIdleTime = this.fCurIdleTime - fDt
		if((this.fCurIdleTime < 0) and (not gE3StatsTimeout or gE3StatsTimeout < 0)) then
			this.fCurIdleTime = 100
			ScriptCB_QuitFromStats()
			ScriptCB_SndPlaySound("shell_menu_enter")
		end
 	end,

	-- Callback (from C++) to repaint the listbox with the current contents
	-- in the global stats_listbox_contents
-- 	RepaintListbox = function(this)
-- 		ListManager_fnFillContents(this.listbox,stats_listbox_contents,AwardStats_listbox_layout)
--	end,
}

-- Helper function, sets up parts of this screen that need any
-- programmatic work (i.e. scaling to screensize)
function ifs_awardstats_fnBuildScreen(this)
	-- Ask game for screen size, fill in values
	local r,b,v,widescreen=ScriptCB_GetScreenInfo()
	this.bgTexture.localpos_l = 0
	this.bgTexture.localpos_t = 0
	this.bgTexture.localpos_r = r*widescreen
	this.bgTexture.localpos_b = b
	this.bgTexture.uvs_b = v

	if(this.Helptext_Back) then
		IFText_fnSetString(this.Helptext_Back.helpstr,"ifs.stats.back")
		IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.stats.done")
	end

	-- Inset slightly from fulls screen size
	local w,h = ScriptCB_GetSafeScreenInfo()
--	w = w * 0.95
	h = h * 0.82

	this.listbox = NewButtonWindow { ZPos = 200, x=0, y = 0,
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.50, -- middle of screen
		width = w,
		height = h,
	}

	AwardStats_listbox_layout.width = w - 50
	AwardStats_listbox_layout.showcount = math.floor(h / (AwardStats_listbox_layout.yHeight + AwardStats_listbox_layout.ySpacing)) - 1

	ListManager_fnInitList(ifs_awardstats.listbox,AwardStats_listbox_layout)
end

ifs_awardstats_fnBuildScreen(ifs_awardstats) -- programatic chunks
ifs_awardstats_fnBuildScreen = nil

AddIFScreen(ifs_awardstats,"ifs_awardstats")
ifs_awardstats = DoPostDelete(ifs_awardstats)
