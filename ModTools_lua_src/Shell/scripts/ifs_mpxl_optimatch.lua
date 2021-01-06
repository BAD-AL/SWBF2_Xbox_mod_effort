--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Generalized mission select screen. Done to unify the varions
-- screens 

ifs_mpxl_optimatch_vbutton_layout = {
	--  yTop = 40, -- auto-calc'd now to be centered vertically
	ySpacing  = 5,
	--  width = 350,    -- Calculated below as a % of screen size
	font = "gamefont_medium",
	buttonlist = { 
		{ tag = "players", string2 = "ifs.mp.createopts.maxplayers", },
		{ tag = "bots", string2 = "ifs.mp.createopts.numbots", },
		{ tag = "teamdmg", string2 = "ifs.mp.createopts.teamdamage", },
		{ tag = "autoaim", string2 = "ifs.mp.createopts.autoaim", },
		{ tag = "shownames", string2 = "ifs.mp.createopts.shownames", },
		{ tag = "hero", string2 = "ifs.mp.createopts.heroes", },
		{ tag = "autoassign", string2 = "ifs.mp.createopts.autoassign_on", },
		{ tag = "difficulty", string2 = "ifs.difficulty.title", },
		{ tag = "dedicated", string2 = "ifs.mp.createopts.dedicated" },
		{ tag = "era", string2 = "ifs.mp.optimatch.era" },
	},
	title = "ifs.mp.optimatch.title",
	-- rotY = 40,
}

-- Options for when we're in the shell and the net is off
ifs_mpxl_optimatch_listtags = {
	"players",
	"bots",
	"teamdmg",
	"autoaim",
	"shownames",
	"hero",
	"autoassign",
	"difficulty",
	"dedicated",
	"era",
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_mpxl_optimatch_CreateItem(layout)
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
function ifs_mpxl_optimatch_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
	-- Well, no, it's technically not. But, acting like it makes things
	-- more consistent
	local this = ifs_mpxl_optimatch

	local ShowStr = Tag
	local ShowUStr = nil
	local ValUStr
	local TempUStr

	-- Cache some common items
	local AnyUStr = ScriptCB_getlocalizestr("ifs.mp.optimatch.any")
	local OnUStr = ScriptCB_getlocalizestr("common.on")
	local OffUStr = ScriptCB_getlocalizestr("common.off")
--	local YesStr = ScriptCB_getlocalizestr("common.yes")
--	local NoStr = ScriptCB_getlocalizestr("common.no")

	if(Tag == "players") then
    if(gOptiOpts.iNumPlayers >= 0) then
        TempUStr = ScriptCB_tounicode(string.format("%d",gOptiOpts.iNumPlayers))
    else
        TempUStr = AnyUStr
    end
    ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.maxplayers",TempUStr)
	elseif (Tag == "bots") then
    if(gOptiOpts.iNumBots >= 0) then
        TempUStr = ScriptCB_tounicode(string.format("%d",gOptiOpts.iNumBots))
    else
        TempUStr = AnyUStr
    end
    ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",TempUStr)
	elseif (Tag == "teamdmg") then
    if(gOptiOpts.iTeamDmg < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iTeamDmg < 1) then
			ValUStr = OffUStr
    else
			ValUStr = OnUStr
		end
		ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage", ValUStr)
	elseif (Tag == "autoaim") then
    if(gOptiOpts.iAutoAim < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iAutoAim < 1) then
			ValUStr = OffUStr
    else
			ValUStr = OnUStr
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim", ValUStr)
	elseif (Tag == "shownames") then
    if(gOptiOpts.iShowNames < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iShowNames < 1) then
			ValUStr = OffUStr
    else
			ValUStr = OnUStr
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.shownames", ValUStr)
	elseif (Tag == "hero") then
    if(gOptiOpts.iHeroesEnabled < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iHeroesEnabled < 1) then
			ValUStr = OffUStr
    else
			ValUStr = OnUStr
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.optimatch.heroes", ValUStr)
	elseif (Tag == "autoassign") then
    if(gOptiOpts.iAutoAssignTeams < 0) then
			ShowUStr = ScriptCB_getlocalizestr("ifs.mp.optimatch.autoassign_any")
    elseif (gOptiOpts.iAutoAssignTeams < 1) then
			ShowUStr = ScriptCB_getlocalizestr("ifs.mp.createopts.autoassign_off")
    else
			ShowUStr = ScriptCB_getlocalizestr("ifs.mp.createopts.autoassign_on")
    end
	elseif (Tag == "difficulty") then
    if(gOptiOpts.iDifficulty < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iDifficulty==1) then
			ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.easy")
    elseif (gOptiOpts.iDifficulty==2) then
			ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.medium")
    else
			ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.hard")
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty", ValUStr)
	elseif (Tag == "dedicated") then
    if(gOptiOpts.iDedicated < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iDedicated < 1) then
			ValUStr = OffUStr
    else
			ValUStr = OnUStr
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.dedicated", ValUStr)
	elseif (Tag == "era") then
    if(gOptiOpts.iEra < 0) then
			ValUStr = AnyUStr
    elseif (gOptiOpts.iEra==0) then
			ValUStr = ScriptCB_getlocalizestr("common.era.cw")
    elseif (gOptiOpts.iEra==1) then
			ValUStr = ScriptCB_getlocalizestr("common.era.gcw")
    else
			ValUStr = ScriptCB_getlocalizestr("ifs.mp.optimatch.both")
    end
		ShowUStr = ScriptCB_usprintf("ifs.mp.optimatch.era", ValUStr)
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

ifs_mpxl_optimatch_layout = {
	showcount = 10,
	--  yTop = -130 + 13, -- auto-calc'd now
	yHeight = 20,
	ySpacing  = 0,
	--  width = 260,
	x = 0,
	slider = 1,
	CreateFn = ifs_mpxl_optimatch_CreateItem,
	PopulateFn = ifs_mpxl_optimatch_PopulateItem,
}

-- Shows one of a set of listboxes depending on various heroes options
function ifs_mpxl_optimatch_fnSetListboxContents(this)
	local NewTags = ifs_mpxl_optimatch_listtags

	this.CurTags = NewTags
	this.OnlinePrefs = ScriptCB_GetOnlineOpts()
	ListManager_fnFillContents(this.listbox,NewTags,ifs_mpxl_optimatch_layout)
	ListManager_fnSetFocus(this.listbox)
end

-- Moves a tri-stated value one position left (in -1, 0, Max). Returns
-- the new value.
function ifs_mpxl_optimatch_fnTriValLeft(Cur,Max)
    local New
    if(Cur > 0) then
        New = 0
    elseif (Cur == 0) then
        New = -1
    else
        New = Max
    end

    return New
end

-- Moves a tri-stated value one position left (in -1, 0, Max). Returns
-- the new value.
function ifs_mpxl_optimatch_fnTriValRight(Cur,Max)
    local New
    if(Cur == -1) then
        New = 0
    elseif (Cur == 0) then
        New = Max
    else
        New = -1
    end

    return New
end


ifs_mpxl_optimatch = NewIFShellScreen {
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

    fnDone = nil, -- Callback function to do something when the user is done
    -- Sub-mode for full/era switch is on.
    bMapMode = nil,
    iMaxPlayers = 32,
    iVoiceMode = 2,
    
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class

        ifs_mpxl_optimatch.bAutoLaunch = nil
        
        -- Added chunk for error handling...
        if(not bFwd) then
            local ErrorLevel,ErrorMessage = ScriptCB_GetError()
            if(ErrorLevel >= 6) then -- session or login error, must keep going further
                ScriptCB_PopScreen()
            end
        end

        if(bFwd) then
            this.SelectedMap = nil -- clear this

            ScriptCB_XL_GetOptiOpts()

            -- Also read in max players & bots
						local GamePrefs = ScriptCB_GetNetGameDefaults()
						this.iMaxPlayers = GamePrefs.iMaxPlayers
						this.iMaxBots = GamePrefs.iMaxBots
            this.SelectedMap = nil -- clear this
        end
        ifs_mpxl_optimatch_fnSetListboxContents(this)
    end,

    Exit = function(this, bFwd)
        if(not bFwd) then
            this.SelectedMap = nil -- clear this
        end
    end,

    Input_Accept = function(this)
        ScriptCB_SndPlaySound("shell_menu_enter")

        ScriptCB_XL_SetOptiOpts()
        ifs_movietrans_PushScreen(ifs_mp_sessionlist)
    end, -- end of Input_Accept

    Input_Back = function(this)
        ScriptCB_PopScreen()
    end,

    Input_GeneralUp = function(this)
        gDefault_Input_GeneralUp(this)
    end,

    Input_GeneralDown = function(this)
        gDefault_Input_GeneralDown(this)
    end,

    Input_LTrigger = function(this)
        if(this.CurButton == "players") then
            gOptiOpts.iNumPlayers = math.max(2,gOptiOpts.iNumPlayers - 10)
            ifelm_shellscreen_fnPlaySound(this.selectSound)
        elseif (this.CurButton == "bots") then
            gOptiOpts.iNumBots = math.max(0,gOptiOpts.iNumBots - 10)
            ifelm_shellscreen_fnPlaySound(this.selectSound)
        end
        ifs_mpxl_optimatch_fnSetListboxContents(this)
    end,

    Input_RTrigger = function(this)
        if(this.CurButton == "players") then
            gOptiOpts.iNumPlayers = math.min(gOptiOpts.iNumPlayers+10,this.iMaxPlayers)
            ifelm_shellscreen_fnPlaySound(this.selectSound)
        elseif (this.CurButton == "bots") then
            gOptiOpts.iNumBots = math.min(gOptiOpts.iNumBots+10,this.iMaxBots)
            ifelm_shellscreen_fnPlaySound(this.selectSound)
        end
        ifs_mpxl_optimatch_fnSetListboxContents(this)
    end,

	Input_GeneralLeft = function(this)
		local Tag = this.CurTags[ifs_mpxl_optimatch_layout.SelectedIdx]
		if(Tag == "players") then
			if(gOptiOpts.iNumPlayers > 2) then
				gOptiOpts.iNumPlayers = gOptiOpts.iNumPlayers - 1
			elseif (gOptiOpts.iNumPlayers > 0) then
				gOptiOpts.iNumPlayers = -1
			else
				gOptiOpts.iNumPlayers = this.iMaxPlayers
			end
		elseif (Tag == "bots") then
			if(gOptiOpts.iNumBots > 0) then
				gOptiOpts.iNumBots = gOptiOpts.iNumBots -1
			elseif (gOptiOpts.iNumBots == 0) then
				gOptiOpts.iNumBots = -1
			else
				gOptiOpts.iNumBots = this.iMaxBots
			end
		elseif (Tag == "teamdmg") then
			gOptiOpts.iTeamDmg = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iTeamDmg, 100)
		elseif (Tag == "autoaim") then
			gOptiOpts.iAutoAim = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iAutoAim, 100)
		elseif (Tag == "shownames") then
			gOptiOpts.iShowNames = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iShowNames, 1)
		elseif (Tag == "hero") then
			gOptiOpts.iHeroesEnabled = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iHeroesEnabled, 1)
		elseif (Tag == "autoassign") then
			gOptiOpts.iAutoAssignTeams = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iAutoAssignTeams, 1)
		elseif (Tag == "dedicated") then
			gOptiOpts.iDedicated = ifs_mpxl_optimatch_fnTriValLeft(gOptiOpts.iDedicated, 1)
		elseif (Tag == "era") then
			gOptiOpts.iEra = gOptiOpts.iEra - 1
			if(gOptiOpts.iEra < -1) then
				gOptiOpts.iEra = 1
			end
		elseif (Tag == "difficulty") then
			gOptiOpts.iDifficulty = gOptiOpts.iDifficulty-1
			if(gOptiOpts.iDifficulty == 1) then
				gOptiOpts.iDifficulty = -1
			elseif (gOptiOpts.iDifficulty == -2) then
				gOptiOpts.iDifficulty = 3
			end
		end
		ifelm_shellscreen_fnPlaySound(this.selectSound)
		ifs_mpxl_optimatch_fnSetListboxContents(this)
	end,

	Input_GeneralRight = function(this)
		local Tag = this.CurTags[ifs_mpxl_optimatch_layout.SelectedIdx]
		if(Tag == "players") then
			if(gOptiOpts.iNumPlayers < 0) then
				gOptiOpts.iNumPlayers = 2
			elseif (gOptiOpts.iNumPlayers == this.iMaxPlayers) then
				gOptiOpts.iNumPlayers = -1
			else
				gOptiOpts.iNumPlayers = gOptiOpts.iNumPlayers+1
			end
		elseif (Tag == "bots") then
			if(gOptiOpts.iNumBots < this.iMaxBots) then
				gOptiOpts.iNumBots = gOptiOpts.iNumBots+1
			elseif (gOptiOpts.iNumBots == this.iMaxBots) then
				gOptiOpts.iNumBots = -1
			end
		elseif (Tag == "teamdmg") then
			gOptiOpts.iTeamDmg = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iTeamDmg, 100)
		elseif (Tag == "autoaim") then
			gOptiOpts.iAutoAim = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iAutoAim, 100)
		elseif (Tag == "shownames") then
			gOptiOpts.iShowNames = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iShowNames, 1)
		elseif (Tag == "hero") then
			gOptiOpts.iHeroesEnabled = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iHeroesEnabled, 1)
		elseif (Tag == "autoassign") then
			gOptiOpts.iAutoAssignTeams = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iAutoAssignTeams, 1)
		elseif (Tag == "dedicated") then
			gOptiOpts.iDedicated = ifs_mpxl_optimatch_fnTriValRight(gOptiOpts.iDedicated, 1)
		elseif (Tag == "era") then
			gOptiOpts.iEra = gOptiOpts.iEra + 1
			if(gOptiOpts.iEra > 1) then
				gOptiOpts.iEra = -1
			end
		elseif (Tag == "difficulty") then
			gOptiOpts.iDifficulty = gOptiOpts.iDifficulty + 1
			if(gOptiOpts.iDifficulty > 3) then
				gOptiOpts.iDifficulty = -1
			elseif (gOptiOpts.iDifficulty == 0) then
				gOptiOpts.iDifficulty = 2
			end
		end
		ifelm_shellscreen_fnPlaySound(this.selectSound)
		ifs_mpxl_optimatch_fnSetListboxContents(this)
	end,

	Input_GeneralUp = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputUp(this)) then
			return
		end

		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavUp(CurListbox)
			ifs_mpxl_optimatch_fnSetListboxContents(this)
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
			ifs_mpxl_optimatch_fnSetListboxContents(this)
		end
	end,
}

-- Helper function, builds this screen.
function ifs_mpxl_optimatch_fnBuildScreen(this)
	local w
	local h
	w,h,widescreen = ScriptCB_GetSafeScreenInfo()
	
	this.Background = NewIFImage 
	{
		ZPos = 255, 
		x = w/2 * widescreen,  --centered on the x
		y = h/2, -- inertUVs = 1,
		alpha = 10,
		localpos_l = -w/1.5*widescreen, localpos_t = -h/1.5,
		localpos_r = w/1.5*widescreen, localpos_b =  h/1.5,
		texture = "opaque_black",
		ColorR = 0, ColorG = 0, ColorB = 0,
	}

	-- Don't use all of the screen for the listbox
	local BottomIconsHeight = 0
	local BotBoxHeight = 0
	local YPadding = 100 -- amount of space to reserve for titlebar, helptext, whitespace, etc

	-- Get usable screen area for listbox
	h = h - BottomIconsHeight - BotBoxHeight - YPadding

	-- Calc height of listbox row, use that to figure out how many rows will fit.
	ifs_mpxl_optimatch_layout.FontStr = "gamefont_medium"
	ifs_mpxl_optimatch_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_mpxl_optimatch_layout.FontStr)
	ifs_mpxl_optimatch_layout.yHeight = ifs_mpxl_optimatch_layout.iFontHeight + 2
	if((gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
		ifs_mpxl_optimatch_layout.yHeight = 2 * ifs_mpxl_optimatch_layout.yHeight
	else
		ifs_mpxl_optimatch_layout.yHeight = math.floor(1.3 * ifs_mpxl_optimatch_layout.yHeight)
	end

	local RowHeight = ifs_mpxl_optimatch_layout.yHeight + ifs_mpxl_optimatch_layout.ySpacing
	ifs_mpxl_optimatch_layout.showcount = math.min(math.floor(h / RowHeight) , table.getn(ifs_mpxl_optimatch_listtags))

	local listWidth = w * 0.85
	local ListboxHeight = ifs_mpxl_optimatch_layout.showcount * RowHeight + 30
	this.listbox = NewButtonWindow { 
		ZPos = 200, 
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
		y = 0,-- ListboxHeight * 0.5 + 30,
		width = listWidth,
		height = ListboxHeight,
		titleText = "ifs.mp.optimatch.title",
	}
	ifs_mpxl_optimatch_layout.width = listWidth - 40
	ifs_mpxl_optimatch_layout.x = 0

	ListManager_fnInitList(this.listbox,ifs_mpxl_optimatch_layout)
end


ifs_mpxl_optimatch_fnBuildScreen(ifs_mpxl_optimatch)
ifs_mpxl_optimatch_fnBuildScreen = nil -- clear out of memory to save space
AddIFScreen(ifs_mpxl_optimatch,"ifs_mpxl_optimatch")
