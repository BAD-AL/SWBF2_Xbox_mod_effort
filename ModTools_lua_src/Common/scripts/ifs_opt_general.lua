--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Options for when we're in the shell and the net is off
ifs_opt_general_listtags_shell_nonet = {
    "persp",
    "rumble",
    "friendlyfire",
    "autoaim",
    "aimassist",
    "stickyreticule",
    "soldierhints",
--  "hero",
    "diff",
    "ttstate",
    "objectivedetails",
    "moviesubtitles",
}

-- Options for when we're in the shell and the net is on
ifs_opt_general_listtags_shell_net = {
    "persp",
    "rumble",
--  "friendlyfire",
--  "autoaim",
--  "aimassist",
--  "stickyreticule",
--     "soldierhints",
--  "hero",
--  "diff",
    "ttstate",
--  "objectivedetails",
--  "moviesubtitles",
}

-- Options for when we're in the game and the net is off
ifs_opt_general_listtags_noshell_nonet = {
    "persp",
    "rumble",
--  "friendlyfire",
    "autoaim",
    "aimassist",
    "stickyreticule",
    "soldierhints",
--  "hero",
    "diff",
    "ttstate",
    "objectivedetails",
    "moviesubtitles",
}

-- Options for when we're in the game and the net is on
ifs_opt_general_listtags_noshell_net = {
    "persp",
    "rumble",
--  "friendlyfire",
--  "autoaim",
--  "aimassist",
--  "stickyreticule",
--     "soldierhints",
--  "hero",
--  "diff",
    "ttstate",
--  "objectivedetails",
--  "moviesubtitles",
}

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_opt_general_CreateItem(layout)
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp = NewIFContainer { 
        x = layout.x - 0.5 * layout.width, 
        y = layout.y,
    }

    Temp.textitem = NewIFText { 
        x = 10,
        y = layout.height * -0.5 + 2,
        halign = "left", valign = "vcenter",
        font = ifs_opt_general_layout.FontStr,
        textw = layout.width - 20, texth = layout.height,
        startdelay=math.random()*0.5, nocreatebackground=1, 
    }

    return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with appropriate values given a Tag, which
-- may be nil (==blank it) Note: the Tag is an entry out of
-- the ifs_opt_general_listtags_* arrays .
function ifs_opt_general_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
    -- Well, no, it's technically not. But, acting like it makes things
    -- more consistent
    local this = ifs_opt_general

    local ShowStr = Tag
    local ShowUStr = nil
    local ValUStr

    -- Cache some common items
    local OnStr = ScriptCB_getlocalizestr("common.on")
    local OffStr = ScriptCB_getlocalizestr("common.off")

    if (Tag == "persp") then
        if(this.GeneralOpts.bFirstPerson) then
            ValUStr = ScriptCB_getlocalizestr("ifs.GameOpt.cam_cockpit")
        else
            ValUStr = ScriptCB_getlocalizestr("ifs.GameOpt.cam_forward")
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.camera2", ValUStr)
    elseif (Tag == "rumble") then
        if(this.GeneralOpts.bRumble) then
            ValUStr = ScriptCB_getlocalizestr("common.yes")
        else
            ValUStr = ScriptCB_getlocalizestr("common.no")
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.rumble2", ValUStr)
    elseif (Tag == "friendlyfire") then
        local ff = this.GeneralOpts.iFriendlyFire
        if(ff<1) then
            ValUStr = OffStr
        else
            ValUStr = OnStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.friendlyfire2", ValUStr)
    elseif (Tag == "autoaim") then
        if(this.GeneralOpts.bAutoAim) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.autoaim2", ValUStr)
    elseif (Tag == "aimassist") then
        if(this.GeneralOpts.bAimAssist) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.aimassist2", ValUStr)
    elseif (Tag == "stickyreticule") then
        if(this.GeneralOpts.bStickyReticule) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.stickyreticule2", ValUStr)
    elseif (Tag == "hero") then
        if(this.GeneralOpts.bHeroes) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.hero2", ValUStr)
    elseif (Tag == "diff") then
        local CurDiff = this.GeneralOpts.iDifficulty
        if(CurDiff == 1) then
            ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.easy")
            elseif(CurDiff == 2) then
            ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.medium")
        else
            ValUStr = ScriptCB_getlocalizestr("ifs.difficulty.hard")
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.difficulty2", ValUStr)
    elseif (Tag == "ttstate") then
        if(this.GeneralOpts.bToolTips) then
            ValUStr = ScriptCB_getlocalizestr("ifs.GameOpt.tt_on");
        elseif (this.GeneralOpts.bToolTipAuto) then
            ValUStr = ScriptCB_getlocalizestr("ifs.GameOpt.tt_auto");
        else
            ValUStr = ScriptCB_getlocalizestr("ifs.GameOpt.tt_off");
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.ttstate2", ValUStr)        
    elseif (Tag == "objectivedetails") then
        if(this.GeneralOpts.bObjectiveDetails) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.objectivedetails", ValUStr)   
    elseif (Tag == "moviesubtitles") then
        if (this.GeneralOpts.bMovieSubtitles) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.moviesubtitles", ValUStr)
    elseif (Tag == "soldierhints") then
        if (this.GeneralOpts.bSoldierHints) then
            ValUStr = OnStr
        else
            ValUStr = OffStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.gameopt.soldierhint", ValUStr)
    end

    if (ShowUStr) then
        IFText_fnSetUString(Dest.textitem,ShowUStr)
    elseif (ShowStr) then
        IFText_fnSetString(Dest.textitem,ShowStr)
    end

    if(Tag) then
        IFObj_fnSetColor(Dest.textitem, iColorR, iColorG, iColorB)
        IFObj_fnSetAlpha(Dest.textitem, fAlpha)
    end

    IFObj_fnSetVis(Dest.textitem,Tag) -- hide if no tag
end 

ifs_opt_general_layout = {
    showcount = 10,
--  yTop = -130 + 13, -- auto-calc'd now
    yHeight = 20,
    ySpacing  = 0,
--  width = 260,
    x = 0,
    slider = 1,
    CreateFn = ifs_opt_general_CreateItem,
    PopulateFn = ifs_opt_general_PopulateItem,
}

-- Shows one of a set of listboxes depending on various heroes options
function ifs_opt_general_fnSetListboxContents(this)
    local NewTags

    local bInShell = ScriptCB_GetShellActive()
    local bInNetwork = ScriptCB_IsNetworkOn()
    
    if ((bInShell) and (bInNetwork)) then
        NewTags =   ifs_opt_general_listtags_shell_net
    elseif ((bInShell) and (not bInNetwork)) then
        NewTags =   ifs_opt_general_listtags_shell_nonet
    elseif ((not bInShell) and (bInNetwork)) then
        NewTags =   ifs_opt_general_listtags_noshell_net
    elseif ((not bInShell) and (not bInNetwork)) then
        NewTags =   ifs_opt_general_listtags_noshell_nonet
    end

    this.CurTags = NewTags
    this.GeneralOpts = ScriptCB_GetGeneralOptions()
    ListManager_fnFillContents(this.listbox,NewTags,ifs_opt_general_layout)
    ListManager_fnSetFocus(this.listbox)

		-- 'Fix' for 9503 - can't reset tooltips anymore
    IFObj_fnSetVis(this.Helptext_Reset, nil) -- this.GeneralOpts.bToolTipAuto)
end

ifs_opt_general = NewIFShellScreen {
    nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bNohelptext_backPC = 1,
    bNohelptext_accept = 1,
	bDimBackdrop = 1,

    Helptext_Reset = NewHelptext {
        ScreenRelativeX = 0.0, -- Left of center, but not in the normal 'back' position
        ScreenRelativeY = 1.0, -- bot
        y = -40,
        buttonicon = "btnmisc",
        string = "ifs.gameopt.ttreset",
    },

    -- When entering this screen, check if we need to save (triggered
    -- by a subscreen or something). If so, start that process.
    Enter = function(this, bFwd)
        this.bResetProfile = nil --default to not resetting the profile
        ScriptCB_MarkCurrentProfile()

        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        ifs_opt_general_fnSetListboxContents(this)
    end, -- function Enter()
    
    Exit = function(this)
        if( this.bResetProfile ) then
            ScriptCB_ReloadMarkedProfile()
        end
    end,

    Input_Accept = function(this) 
        -- If base class handled this work, then we're done
        --if(gShellScreen_fnDefaultInputAccept(this)) then
        --  return
                                     --end
        if (this.CurButton == "_back") then
            this.bResetProfile = 1
            this:Input_Back(1)
        elseif (this.CurButton == "_ok") then
            this:Input_Back(1)
        elseif (this.CurButton == "reset") then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
            ScriptCB_ResetGameOptionsToDefault()
            ifs_opt_general_fnUpdateStrings(this)
        end
    end,

    Input_GeneralLeft = function(this)
        local CurItem = this.CurTags[ifs_opt_general_layout.SelectedIdx]
        if(CurItem == "persp") then
            this.GeneralOpts.bFirstPerson = not this.GeneralOpts.bFirstPerson
        elseif (CurItem == "rumble") then
            this.GeneralOpts.bRumble = not this.GeneralOpts.bRumble
        elseif (CurItem == "friendlyfire") then
            this.GeneralOpts.iFriendlyFire = 100 - this.GeneralOpts.iFriendlyFire
        elseif (CurItem == "autoaim") then
            this.GeneralOpts.bAutoAim = not this.GeneralOpts.bAutoAim
        elseif (CurItem == "aimassist") then
            this.GeneralOpts.bAimAssist = not this.GeneralOpts.bAimAssist
        elseif (CurItem == "stickyreticule") then
            this.GeneralOpts.bStickyReticule = not this.GeneralOpts.bStickyReticule
        elseif (CurItem == "hero") then
            this.GeneralOpts.bHeroes = not this.GeneralOpts.bHeroes
        elseif (CurItem == "diff") then
            local CurDiff = this.GeneralOpts.iDifficulty
            local NewDiff
            if(CurDiff < 3) then
                NewDiff = 3 -- hard
            else
                NewDiff = 2 -- medium
            end
            this.GeneralOpts.iDifficulty = NewDiff
        elseif (CurItem == "ttstate") then
            ScriptCB_PrevToolTipState();
        elseif (CurItem == "objectivedetails") then
            this.GeneralOpts.bObjectiveDetails = not this.GeneralOpts.bObjectiveDetails
        elseif (CurItem == "moviesubtitles") then
            this.GeneralOpts.bMovieSubtitles = not this.GeneralOpts.bMovieSubtitles
        elseif (CurItem == "soldierhints") then
            this.GeneralOpts.bSoldierHints = not this.GeneralOpts.bSoldierHints
        end
        ScriptCB_SetGeneralOptions(this.GeneralOpts)
        ifs_opt_general_fnSetListboxContents(this)
        
        if (not (CurItem == "ttreset" or 
                 CurItem == "back")) then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
        end
    end,

    Input_Back = function(this)
		if (gPlatformStr == "PC") and ScriptCB_GetShellActive() then
			-- rethink interface state, but don't leave
			this:Exit(false)
			this:Enter(true)
		else
			ScriptCB_PopScreen()
		end
    end,

    Input_GeneralRight = function(this)
        local CurItem = this.CurTags[ifs_opt_general_layout.SelectedIdx]
        if(CurItem == "persp") then
            this.GeneralOpts.bFirstPerson = not this.GeneralOpts.bFirstPerson
        elseif (CurItem == "rumble") then
            this.GeneralOpts.bRumble = not this.GeneralOpts.bRumble
        elseif (CurItem == "friendlyfire") then
            this.GeneralOpts.iFriendlyFire = 100 - this.GeneralOpts.iFriendlyFire
        elseif (CurItem == "autoaim") then
            this.GeneralOpts.bAutoAim = not this.GeneralOpts.bAutoAim
        elseif (CurItem == "aimassist") then
            this.GeneralOpts.bAimAssist = not this.GeneralOpts.bAimAssist
        elseif (CurItem == "stickyreticule") then
            this.GeneralOpts.bStickyReticule = not this.GeneralOpts.bStickyReticule
        elseif (CurItem == "hero") then
            this.GeneralOpts.bHeroes = not this.GeneralOpts.bHeroes
        elseif (CurItem == "moviesubtitles") then
            this.GeneralOpts.bMovieSubtitles = not this.GeneralOpts.bMovieSubtitles
        elseif (CurItem == "soldierhints") then
            this.GeneralOpts.bSoldierHints = not this.GeneralOpts.bSoldierHints
        elseif (CurItem == "objectivedetails") then
            this.GeneralOpts.bObjectiveDetails = not this.GeneralOpts.bObjectiveDetails
        elseif (CurItem == "diff") then
            local CurDiff = this.GeneralOpts.iDifficulty
            local NewDiff
            if(CurDiff < 3) then
                NewDiff = 3 -- hard
            else
                NewDiff = 2 -- medium
            end
            this.GeneralOpts.iDifficulty = NewDiff
        elseif (CurItem == "ttstate") then
            ScriptCB_NextToolTipState();
        end
        ScriptCB_SetGeneralOptions(this.GeneralOpts)
        ifs_opt_general_fnSetListboxContents(this)
        
        if (not (CurItem == "ttreset" or 
                 CurItem == "back")) then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
        end
    end,

    Input_GeneralUp = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputUp(this)) then
            return
        end

        local CurListbox = ListManager_fnGetFocus()
        if(CurListbox) then
            ListManager_fnNavUp(CurListbox)
            ifs_opt_general_fnSetListboxContents(this)
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
            ifs_opt_general_fnSetListboxContents(this)
        end
    end,

		-- 'Fix' for 9503 - can't reset tooltips anymore
--     Input_Misc = function(this)
--         -- Can only reset tooltips when it's in auto mode
--         if(this.GeneralOpts.bToolTipAuto) then
--             ifelm_shellscreen_fnPlaySound(this.acceptSound)
--             ScriptCB_ResetToolTips()
--             ifs_opt_general_fnSetListboxContents(this)
--         end
--     end,
}

function ifs_opt_general_fnBuildScreen(this)
    local w
    local h
    w,h = ScriptCB_GetSafeScreenInfo()

    -- Don't use all of the screen for the listbox
    local BottomIconsHeight = 0
    local BotBoxHeight = 20
    local YPadding = 120 -- amount of space to reserve for titlebar, helptext, whitespace, etc

    -- Get usable screen area for listbox
    h = h - BottomIconsHeight - BotBoxHeight - YPadding

    -- Calc height of listbox row, use that to figure out how many rows will fit.
    ifs_opt_general_layout.FontStr = gListboxItemFont
    ifs_opt_general_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_opt_general_layout.FontStr)
    ifs_opt_general_layout.yHeight = ifs_opt_general_layout.iFontHeight + 2

		-- Always double-height now to fix BF2 bug 5437 - NM 7/22/05
    if(1) then -- (gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
        ifs_opt_general_layout.yHeight = 2 * ifs_opt_general_layout.yHeight
    else
        ifs_opt_general_layout.yHeight = math.floor(1.3 * ifs_opt_general_layout.yHeight)
    end

    local RowHeight = ifs_opt_general_layout.yHeight + ifs_opt_general_layout.ySpacing

        local MaxOptionsShown = math.max(table.getn(ifs_opt_general_listtags_shell_nonet),
                                                                         table.getn(ifs_opt_general_listtags_shell_net),
                                                                         table.getn(ifs_opt_general_listtags_noshell_nonet),
                                                                         table.getn(ifs_opt_general_listtags_noshell_net))

    ifs_opt_general_layout.showcount = math.min(MaxOptionsShown, math.floor(h / RowHeight))

    local listWidth = w * 0.85
    local ListboxHeight = ifs_opt_general_layout.showcount * RowHeight + 30
		
		local BoxRelativeX = 0.5
		local BoxX = 0
		if(ScriptCB_GetShellActive()) then
			BoxRelativeX = 0
			BoxX = listWidth * 0.5
		end

    this.listbox = NewButtonWindow { 
        ZPos = 200, 
			x = BoxX,
        ScreenRelativeX = BoxRelativeX,
        ScreenRelativeY = 0.5, -- center
        width = listWidth,
        height = ListboxHeight,
        titleText = "ifs.GameOpt.title",
    }
    ifs_opt_general_layout.width = listWidth - 40
    ifs_opt_general_layout.x = 0

    ListManager_fnInitList(this.listbox,ifs_opt_general_layout)
end

ifs_opt_general_fnBuildScreen(ifs_opt_general)
ifs_opt_general_fnBuildScreen = nil
AddIFScreen(ifs_opt_general,"ifs_opt_general")
ifs_opt_general = DoPostDelete(ifs_opt_general)
