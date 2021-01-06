--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Does the setup for a custom metagame. Writes values into the
-- following table:

-- ifs_freeform_customsetup.Prefs = {
--   iEra = 1,        -- 1 = Clonewars, 2 = GCW
--   bRandomLayout,   -- true if a random map layout
--   iVictoryType,    -- 1 = Total Conquest, 2 = Base Conquest, 3 = Turns, 4 = Credits
--   iVictoryTurn,    -- Turn limit if iVictoryType==3
--   iVictoryCredits, -- Credits limit if iVictoryType==4
-- }

-- Options for when we have no victory value
ifs_freeform_customsetup_listtags = {
	"era",
	"layout",
	"victory",
--	"victory_val",
}

-- Options for when we have a victory value
ifs_freeform_customsetup_listtags_val = {
	"era",
	"layout",
	"victory",
	"victory_val",
}

-- ifs_freeform_customsetup_vbutton_layout = {
-- 	--  yTop = 40, -- auto-calc'd now to be centered vertically
-- 	ySpacing  = 5,
-- 	--  width = 350,    -- Calculated below as a % of screen size
-- 	font = "gamefont_medium",
-- 	buttonlist = { 
-- 		{ tag = "era", string = "ifs.mp.ps2filters.players", },
-- 		{ tag = "layout", string = "ifs.meta.custom.layout", },
-- 		{ tag = "victory", string = "ifs.meta.custom.victory1", },
-- 		{ tag = "victory_val", string = "ifs.meta.custom.victory2" },
-- 	},
-- 	title = "ifs.meta.custom.title",
-- 	-- rotY = 40,
-- }

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_freeform_customsetup_CreateItem(layout)
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
function ifs_freeform_customsetup_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
	-- Well, no, it's technically not. But, acting like it makes things
	-- more consistent
	local this = ifs_freeform_customsetup

	local ShowStr = Tag
	local ShowUStr = nil
	local ValUStr
	local TempUStr

	-- Cache some common items
	local CWUStr = ScriptCB_getlocalizestr("common.era.cw")
	local GCWUStr = ScriptCB_getlocalizestr("common.era.gcw")

	if(Tag == "era") then
		if(this.Prefs.iEra == 1) then
			ValUStr = CWUStr
		else
			ValUStr = GCWUStr
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.ps2filters.era", ValUStr)
	elseif (Tag == "layout") then
		if(this.Prefs.bRandomLayout) then
			ShowStr = "ifs.meta.custom.layout_random"
		else
			ShowStr = "ifs.meta.custom.layout_fixed"
		end
	elseif (Tag == "victory") then
		if (this.Prefs.iVictoryType == 1) then
			ShowStr = "ifs.meta.custom.victory_total"
		elseif (this.Prefs.iVictoryType == 2) then
			ShowStr = "ifs.meta.custom.victory_base"
		elseif (this.Prefs.iVictoryType == 3) then
			ShowStr = "ifs.meta.custom.victory_turns"
		elseif (this.Prefs.iVictoryType == 4) then
			ShowStr = "ifs.meta.custom.victory_credits"
		end
	elseif (Tag == "victory_val") then
		if (this.Prefs.iVictoryType == 3) then
			ShowUStr = ScriptCB_usprintf("ifs.meta.custom.victory_turns_val",
																	 ScriptCB_tounicode(string.format("%d",this.Prefs.iVictoryTurn)))
		elseif (this.Prefs.iVictoryType == 4) then
			ShowUStr = ScriptCB_usprintf("ifs.meta.custom.victory_credits_val",
																	 ScriptCB_tounicode(string.format("%d",this.Prefs.iVictoryCredits)))
		else
			ShowStr = ""
		end
	end

	if (ShowUStr) then
		IFText_fnSetUString(Dest.textitem,ShowUStr)
	elseif (ShowStr) then
		IFText_fnSetString(Dest.textitem,ShowStr)
	end

	if iColorR and iColorG and iColorB then
		IFObj_fnSetColor(Dest.textitem, iColorR, iColorG, iColorB)
	end
	if fAlpha then
		IFObj_fnSetAlpha(Dest.textitem, fAlpha)
	end

	IFObj_fnSetVis(Dest.textitem,Tag) -- hide if no tag
end

ifs_freeform_customsetup_layout = {
	showcount = 10,
	--  yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
	--  width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_freeform_customsetup_CreateItem,
	PopulateFn = ifs_freeform_customsetup_PopulateItem,
}

-- Shows one of a set of listboxes depending on various heroes options
function ifs_freeform_customsetup_fnSetListboxContents(this)
	local NewTags = ifs_freeform_customsetup_listtags

	if((this.Prefs.iVictoryType == 3) or (this.Prefs.iVictoryType == 4)) then
		NewTags = ifs_freeform_customsetup_listtags_val
	end

	this.CurTags = NewTags
	this.OnlinePrefs = ScriptCB_GetOnlineOpts()
	ListManager_fnFillContents(this.listbox,NewTags,ifs_freeform_customsetup_layout)
	ListManager_fnSetFocus(this.listbox)
	ifs_freeform_customsetup_fnUpdateHelptext(this)
end


-- Helper function, updates helptext
function ifs_freeform_customsetup_fnUpdateHelptext(this)
end

-- Given a tag string (one of the buttons), and a value to adjust by 
-- (-1 = left, +1 = right, *10 for ltrigger/rtrigger), modifies things.
function ifs_freeform_customsetup_fnAdjustValue(this, Tag, iAdjust)
	if (Tag == "era") then
		this.Prefs.iEra = 3 - this.Prefs.iEra
	elseif (Tag == "layout") then
		this.Prefs.bRandomLayout = not this.Prefs.bRandomLayout
	elseif (Tag == "victory") then
		this.Prefs.iVictoryType = Clamp(this.Prefs.iVictoryType + iAdjust, 1, 4)
		-- Fix for 9397 - NM 8/9/05 - Ken says that base conquest no longer
		-- a valid setup type. So, do this again to skip over the option
		if(this.Prefs.iVictoryType == 2) then
			this.Prefs.iVictoryType = Clamp(this.Prefs.iVictoryType + iAdjust, 1, 4)
		end
	elseif (Tag == "victory_val") then
		if (this.Prefs.iVictoryType == 3) then
			this.Prefs.iVictoryTurn = Clamp(this.Prefs.iVictoryTurn + iAdjust, 
																			this.Prefs.iMinTurn, this.Prefs.iMaxTurn)
		elseif (this.Prefs.iVictoryType == 4) then
			this.Prefs.iVictoryCredits = Clamp(this.Prefs.iVictoryCredits + 10 * iAdjust, 
																				 this.Prefs.iMinCredits, this.Prefs.iMaxCredits)
		end
	end

	ifs_freeform_customsetup_fnSetListboxContents(this)
end

ifs_freeform_customsetup = NewIFShellScreen {
	nologo = 1,
	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
	
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


	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5,
	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class

		ifs_freeform_customsetup.bAutoLaunch = nil
		
		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
			if(ErrorLevel >= 6) then -- session or login error, must keep going further
				ScriptCB_PopScreen()
			end
		end

		this.iMaxPlayers = 24 -- or whatever the PS2 math.max is
		this.iMaxPing = 5000 -- math.max we'll ever let anyone search for

		if(not this.bSetDefaults) then
			this.bSetDefaults = 1
			this.Prefs = {
				iEra = 1,        -- 1 = Clonewars, 2 = GCW
				bRandomLayout = true,   -- true if a random map layout
				iVictoryType = 1,    -- 1 = Total Conquest, 2 = Base Conquest, 3 = Turns, 4 = Credits
				iVictoryTurn = 10,    -- Turn limit if iVictoryType==3
				iVictoryCredits = 200, -- Credits limit if iVictoryType==4

				iMinTurn = 5,
				iMaxTurn = 100,
				iMinCredits = 40,
				iMaxCredits = 1000,
			}
		end

		-- Always (re)show params
		ifs_freeform_customsetup_fnSetListboxContents(this)
		ifs_freeform_customsetup_fnUpdateHelptext(this)
	end,

	Input_Accept = function(this)
		ScriptCB_SndPlaySound("shell_menu_enter")
		
		ScriptCB_PopScreen()
		ifs_freeform_start_custom(ifs_freeform_main, this.Prefs)
		ScriptCB_PushScreen("ifs_freeform_main")
	end, -- end of Input_Accept

	Input_Back = function(this)
		--ifs_freeform_customsetup_fnSaveToProfile(this)
		ScriptCB_PopScreen()
	end,

	Input_LTrigger = function(this)
		local Tag = this.CurTags[ifs_freeform_customsetup_layout.SelectedIdx]
		ifs_freeform_customsetup_fnAdjustValue(this, Tag, -10)
	end,

	Input_RTrigger = function(this)
		local Tag = this.CurTags[ifs_freeform_customsetup_layout.SelectedIdx]
		ifs_freeform_customsetup_fnAdjustValue(this, Tag, 10)
	end,

	Input_GeneralLeft = function(this)
		local Tag = this.CurTags[ifs_freeform_customsetup_layout.SelectedIdx]
		ifs_freeform_customsetup_fnAdjustValue(this, Tag, -1)
	end,

	Input_GeneralRight = function(this)
		local Tag = this.CurTags[ifs_freeform_customsetup_layout.SelectedIdx]
		ifs_freeform_customsetup_fnAdjustValue(this, Tag, 1)
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavUp(CurListbox)
			ifs_freeform_customsetup_fnSetListboxContents(this)
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
			ifs_freeform_customsetup_fnSetListboxContents(this)
		end
	end,
}

-- Helper function, builds this screen.
function ifs_freeform_customsetup_fnBuildScreen(this)
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
	ifs_freeform_customsetup_layout.FontStr = "gamefont_medium"
	ifs_freeform_customsetup_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_freeform_customsetup_layout.FontStr)
	ifs_freeform_customsetup_layout.yHeight = ifs_freeform_customsetup_layout.iFontHeight + 2
	if((gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
		ifs_freeform_customsetup_layout.yHeight = 2 * ifs_freeform_customsetup_layout.yHeight
	else
		ifs_freeform_customsetup_layout.yHeight = math.floor(1.3 * ifs_freeform_customsetup_layout.yHeight)
	end

	local RowHeight = ifs_freeform_customsetup_layout.yHeight + ifs_freeform_customsetup_layout.ySpacing
	ifs_freeform_customsetup_layout.showcount = math.min(math.floor(h / RowHeight) , table.getn(ifs_freeform_customsetup_listtags_val))

	local listWidth = w * 0.85
	local ListboxHeight = ifs_freeform_customsetup_layout.showcount * RowHeight + 30
	this.listbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		y = 0, -- ListboxHeight * 0.5 + 30,
		width = listWidth,
		height = ListboxHeight,
		titleText = "ifs.meta.custom.title",
	}
	ifs_freeform_customsetup_layout.width = listWidth - 40
	ifs_freeform_customsetup_layout.x = 0

	ListManager_fnInitList(this.listbox,ifs_freeform_customsetup_layout)

end

ifs_freeform_customsetup_fnBuildScreen(ifs_freeform_customsetup)
ifs_freeform_customsetup_fnBuildScreen = nil -- clear out of memory to save space
AddIFScreen(ifs_freeform_customsetup,"ifs_freeform_customsetup")
