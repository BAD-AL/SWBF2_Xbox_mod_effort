--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Online options

-- Helper functions for determining if the Gamespy login can be set to
-- 'always' (i.e. the info looks valid)

-- Returns 1 if the specifed string starts with valid chars, nil if
-- not.
function ifs_opt_mp_fnCheckGamespyString(Str)
    local FirstChar = string.sub(Str,1,1)
    if((FirstChar == "@") or (FirstChar == "+") or (FirstChar == ":") or (FirstChar == "#")) then
        return nil
    end

    return 1
end

-- Returns true if the login info looks ok (to allow the 'always'
-- login type)
function ifs_opt_mp_fnLoginInfoLooksOk(NickStr,EmailStr,PasswordStr)
    return ScriptCB_IsLegalGamespyString(NickStr,EmailStr,PasswordStr)
end

-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_opt_mp_CreateItem(layout)
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
function ifs_opt_mp_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
    -- Well, no, it's technically not. But, acting like it makes things
    -- more consistent
    local this = ifs_opt_mp

    local ShowStr = Tag
    local ShowUStr = nil
    local ValUStr

    -- Cache some common items
    local OnStr = ScriptCB_getlocalizestr("common.on")
    local OffStr = ScriptCB_getlocalizestr("common.off")
    local YesStr = ScriptCB_getlocalizestr("common.yes")
    local NoStr = ScriptCB_getlocalizestr("common.no")

    if (Tag == "appear") then
--  { tag = "appear",    title = "ifs.onlineopt.appear", string = "ifs.onlineopt.online" },
    if(this.OnlinePrefs.bAppearOffline) then
            ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.offline")
    else
            ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.online")
    end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.appear2", ValUStr)

    elseif (Tag == "voicemask") then
--  { tag = "voicemask", title = "ifs.onlineopt.voicemask", string = "common.no" },
    if(this.OnlinePrefs.bVoiceMask) then
            ValUStr = YesStr
    else
            ValUStr = NoStr
    end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.voicemask2", ValUStr)

    elseif (Tag == "voicevol") then
        --  { tag = "voicevol",  title = "ifs.onlineopt.voicetotvvolume", string = "10" },
    if (this.OnlinePrefs.iTVVoiceVol == 0) then
            ValUStr = OffStr
        else
            ValUStr = OnStr
        end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.voicetotvvolume2", ValUStr)

    elseif (Tag == "prompt") then
--  { tag = "prompt",  title = "ifs.onlineopt.autologin", string = "" },
    if(this.iPromptType == 0) then
            ValUStr = ScriptCB_getlocalizestr("ifs.gsprofile.prompt")
    elseif (this.iPromptType == 1) then
            ValUStr = ScriptCB_getlocalizestr("ifs.gsprofile.always")
    else
            ValUStr = ScriptCB_getlocalizestr("ifs.gsprofile.never")
        end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.autologin2", ValUStr)

    elseif (Tag == "players") then
--  { tag = "players", title = "ifs.onlineopt.hostbandwidth", string = "128k"},
    if(gPlatformStr == "XBox") then
            if(this.OnlinePrefs.iPlayersSupported<1) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth1")
            elseif (this.OnlinePrefs.iPlayersSupported<2) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth2")
            elseif (this.OnlinePrefs.iPlayersSupported<3) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth3")
            elseif (this.OnlinePrefs.iPlayersSupported<4) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth4")
            elseif (this.OnlinePrefs.iPlayersSupported<5) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth5")
            elseif (this.OnlinePrefs.iPlayersSupported<6) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth6")
            elseif (this.OnlinePrefs.iPlayersSupported<7) then
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth7")
            else
                ValUStr = ScriptCB_getlocalizestr("ifs.onlineopt.bandwidth8")
            end
    else
            if (this.OnlinePrefs.iPlayersSupported<1) then
                ValUStr = ScriptCB_tounicode("128k")
            elseif (this.OnlinePrefs.iPlayersSupported<2) then
                ValUStr = ScriptCB_tounicode("256k")
            elseif (this.OnlinePrefs.iPlayersSupported<3) then
                ValUStr = ScriptCB_tounicode("384k")
            elseif (this.OnlinePrefs.iPlayersSupported<4) then
                ValUStr = ScriptCB_tounicode("512k")
            elseif (this.OnlinePrefs.iPlayersSupported<5) then
                ValUStr = ScriptCB_tounicode("768k")
            elseif (this.OnlinePrefs.iPlayersSupported<6) then
                ValUStr = ScriptCB_tounicode("1024k")
            elseif (this.OnlinePrefs.iPlayersSupported<7) then
                ValUStr = ScriptCB_tounicode("1536k")
            else
                ValUStr = ScriptCB_tounicode("3072k")
            end
    end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.hostbandwidth2", ValUStr)

    elseif (Tag == "icon") then
--  { tag = "icon", title = "ifs.onlineopt.icon", string = "common.off"},   -- display network performance icon 
    if( this.OnlinePrefs.iOnlineIcon == 1 ) then
            ValUStr = OnStr
    else
            ValUStr = OffStr
    end 
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.icon2", ValUStr)

    elseif (Tag == "voicerecord") then
--  { tag = "voicerecord",   title = "ifs.onlineopt.voicerecordvol", string = "10" },
        ValUStr = ScriptCB_tounicode(string.format("%d",this.OnlinePrefs.iVoiceRecordVol))
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.voicerecordvol2", ValUStr)

    elseif (Tag == "voiceplayback") then
--  { tag = "voiceplayback", title = "ifs.onlineopt.voiceplaybackvol", string = "10" },
        ValUStr = ScriptCB_tounicode(string.format("%d",this.OnlinePrefs.iVoicePlayVol))
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.voiceplaybackvol2", ValUStr)

    elseif (Tag == "voiceenable") then
--  { tag = "voiceenable",   title = "ifs.onlineopt.voiceenable", string = "common.off" },
    if (ScriptCB_GetVoiceEnable()) then
            ValUStr = YesStr
    else
            ValUStr = NoStr
    end
        ShowUStr = ScriptCB_usprintf("ifs.onlineopt.voiceenable2", ValUStr)
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

ifs_opt_mp_layout = {
    showcount = 10,
    --  yTop = -130 + 13, -- auto-calc'd now
    yHeight = 20,
    ySpacing  = 0,
    --  width = 260,
    x = 0,
    slider = 1,
    CreateFn = ifs_opt_mp_CreateItem,
    PopulateFn = ifs_opt_mp_PopulateItem,
}

function ifs_mp_opt_fnBadHostPopupDone(bResult)
    local this = ifs_opt_mp
    
    IFObj_fnSetVis(this.listbox, 1)

    if(bResult) then
        ifs_opt_mp_SaveAndPop()
    end
end

-- Shows one of a set of listboxes depending on various heroes options
function ifs_opt_mp_fnSetListboxContents(this)
    local NewTags = ifs_opt_mp_listtags

	if((gPlatformStr == "PS2") and (ScriptCB_GetConnectType() == "LAN")) then
		NewTags = ifs_opt_mp_listtags_LAN
	end

    this.CurTags = NewTags
    this.OnlinePrefs = ScriptCB_GetOnlineOpts()
    ListManager_fnFillContents(this.listbox,NewTags,ifs_opt_mp_layout)
    ListManager_fnSetFocus(this.listbox)
end

-- Adjusts one option, with its name in the Tag. iDir is +1 (right) or
-- -1 (left)
function ifs_opt_mp_fnAdjustOption(this, Tag, iDir)
    ifelm_shellscreen_fnPlaySound(this.acceptSound)

    if (Tag == "appear") then
        this.OnlinePrefs.bAppearOffline = not this.OnlinePrefs.bAppearOffline
    elseif (Tag == "voicemask") then
        this.OnlinePrefs.bVoiceMask = not this.OnlinePrefs.bVoiceMask
    elseif (Tag == "voicevol") then
        this.OnlinePrefs.iTVVoiceVol = 10 - this.OnlinePrefs.iTVVoiceVol
        if (this.OnlinePrefs.iTVVoiceVol > 0) then
            ScriptCB_VoiceEnable(1)
        elseif (not ScriptCB_GetVoiceCaptureConnected()) then
            ScriptCB_VoiceEnable(nil)
        end
    elseif (Tag == "prompt") then
        this.iPromptType = this.iPromptType + iDir
        if(this.iPromptType > 2) then
            this.iPromptType = 0
        elseif (this.iPromptType < 0) then
            this.iPromptType = 2
        end
        
        -- Only show 'always' if the parameters look valid
        if((this.iPromptType == 1) and (not ifs_opt_mp_fnLoginInfoLooksOk(NickStr,EmailStr,PasswordStr))) then
            if(iDir > 0) then
                this.iPromptType = 2 -- skip to never
            else
                this.iPromptType = 0 -- skip to never
            end
        end
    elseif (Tag == "players") then
        this.OnlinePrefs.iPlayersSupported = math.min(8, math.max(0, this.OnlinePrefs.iPlayersSupported + iDir))
    elseif (Tag == "icon") then
        this.OnlinePrefs.iOnlineIcon = 1 - this.OnlinePrefs.iOnlineIcon
    elseif (Tag == "voicerecord") then
        this.OnlinePrefs.iVoiceRecordVol = math.min(10, math.max(0, this.OnlinePrefs.iVoiceRecordVol + iDir))
    elseif (Tag == "voiceplayback") then
        this.OnlinePrefs.iVoicePlayVol = math.min(10, math.max(0, this.OnlinePrefs.iVoicePlayVol + iDir))
    elseif (Tag == "voiceenable") then
        ScriptCB_VoiceEnable(not ScriptCB_GetVoiceEnable())
    end

    -- Punch changes thru to game
    ScriptCB_SetGSProfileInfo(this.NickStr,this.EmailStr,this.PasswordStr,this.iSaveType,this.iPromptType)
    ScriptCB_SetOnlineOpts(this.OnlinePrefs)

    -- Repaint screen w/ latest selections
    ifs_opt_mp_fnSetListboxContents(this)
end


ifs_opt_mp = NewIFShellScreen {

    nologo = 1,
    movieIntro      = nil, -- played before the screen is displayed
    movieBackground = nil, -- played while the screen is displayed
    bNohelptext_backPC = 1,
    bNohelptext_accept = 1,
	bDimBackdrop = 1,
    --bg_texture = "iface_bgmeta_space",

    -- display network performance icon 
    icon = 0,
    bAllRegions = true,
    iNumPlayers = 0,
    iTurnsPerSecond = 20,
    pollProfileTime = 2,

    -- Do any adjustments necessary on entering this screen
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
--      print("Enter Top, this.CurButton = ",this.CurButton)

        if(this.PopOnEnter) then
            this.PopOnEnter = nil
            ScriptCB_PopScreen()
        end

        -- Added chunk for error handling...
        if(not bFwd) then
            local ErrorLevel,ErrorMessage = ScriptCB_GetError()
            if(ErrorLevel >= 6) then -- session or login error, must keep going further
                ScriptCB_PopScreen()
            end
        end

        -- enable local voice echo for test / auditioning
        ScriptCB_SetVoiceLocalEchoEnable(1)

        this.NickStr,this.EmailStr,this.PasswordStr,this.iSaveType,this.iPromptType = ScriptCB_GetGSProfileInfo()

        -- Repaint screen w/ latest selections
        ifs_opt_mp_fnSetListboxContents(this)
    end,
    
    Exit = function(this, bFwd)
        -- disable local voice echo 
        ScriptCB_SetVoiceLocalEchoEnable(0)
        print("ifs_opt_mp - Exit. Reload = ", this.bReloadProfile)
        if(gCurHiliteButton) then
            IFButton_fnSelect(gCurHiliteButton,nil)
        end
    end,

    Update = function(this, fDt)
        -- Call default base class's update function (make button bounce)
        gIFShellScreenTemplate_fnUpdate(this,fDt)

        -- Lobby might be active (if we entered thru it). Update it.
        ScriptCB_UpdateLobby(nil)
        
        -- handle TV voice gain changes
        this.pollProfileTime = this.pollProfileTime - fDt

        if (this.pollProfileTime < 0) then
            local voiceTVGain    = ScriptCB_GetVoiceTVGain()
            this.pollProfileTime = 2
                        
            -- if the TV voice is turned off and headset is disconnected
            if (this.OnlinePrefs.iTVVoiceVol == 0 and 
                    voiceTVGain                  == 0 and
                        not ScriptCB_GetVoiceCaptureConnected()) then
                ScriptCB_VoiceEnable(nil) -- disable voice
                ifs_opt_mp_fnSetListboxContents(this)
            end

            -- if the TV gain has changed (due to headset insertion / removal) 
            -- update profile
            if (this.OnlinePrefs.iTVVoiceVol ~= voiceTVGain) then
                this.OnlinePrefs.iTVVoiceVol = voiceTVGain
                ScriptCB_SetOnlineOpts(this.OnlinePrefs)
                ifs_opt_mp_fnSetListboxContents(this)
            end
        end
    end,

    Input_Accept = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputAccept(this)) then
            return
        end

    end,
    
    Input_Back = function(this)
		if (gPlatformStr == "XBox") then
            -- don't reload profile when we leave
            this.bReloadProfile = nil
            if(not ScriptCB_CanSupportMaxPlayers(this.OnlinePrefs.iPlayersSupported)) then
                IFObj_fnSetVis(this.listbox, nil)
                
                Popup_AB.CurButton = "no" -- default
                Popup_AB.fnDone = ifs_mp_opt_fnBadHostPopupDone
                Popup_AB:fnActivate(1)
								gPopup_fnSetTitleStr(Popup_AB, "ifs.mp.badhost")
            else
                print("Can support the players...")
                ifs_opt_mp_SaveAndPop()
            end
        else
            -- don't reload profile when we leave
            this.bReloadProfile = nil
            ifs_opt_mp_SaveAndPop()
        end
    end,

    Input_GeneralLeft = function(this)
        local Tag = this.CurTags[ifs_opt_mp_layout.SelectedIdx]
        ifs_opt_mp_fnAdjustOption(this, Tag, -1)
    end,

    Input_GeneralRight = function(this)
        local Tag = this.CurTags[ifs_opt_mp_layout.SelectedIdx]
        ifs_opt_mp_fnAdjustOption(this, Tag, 1)
    end,

    Input_GeneralUp = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputUp(this)) then
            return
        end

        local CurListbox = ListManager_fnGetFocus()
        if(CurListbox) then
            ListManager_fnNavUp(CurListbox)
            ifs_opt_mp_fnSetListboxContents(this)
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
            ifs_opt_mp_fnSetListboxContents(this)
        end
    end,
}


----------------------------------------------------------------------------------------
-- when we're done with this screen, save any dirty profiles
----------------------------------------------------------------------------------------

function ifs_opt_mp_SaveAndPop()
--  print("ifs_opt_mp_SaveAndPop")
    local this = ifs_opt_mp
    
    -- if we're in the game, or a subscreen of the options tree, don't try to save
    if((not ifs_saveop) or (ScriptCB_IsScreenInStack("ifs_opt_top"))) then
        ScriptCB_PopScreen()
        return
    end
    
    ifs_saveop.doOp = "SaveProfile"
    ifs_saveop.OnSuccess = ifs_opt_mp_SaveProfile1Success
    ifs_saveop.OnCancel = ifs_opt_mp_SaveProfile1Cancel
    local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
    ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
    ifs_saveop.saveProfileNum = iProfileIdx
    ifs_movietrans_PushScreen(ifs_saveop)   
end

function ifs_opt_mp_SaveProfile1Success()
--  print("ifs_opt_mp_SaveProfile1Success")
    -- exit once we reenter
    ifs_opt_mp.PopOnEnter = 1
    ScriptCB_PopScreen()
end

function ifs_opt_mp_SaveProfile1Cancel()
--  print("ifs_opt_mp_SaveProfile1Cancel")
    -- exit once we reenter
    ifs_opt_mp.PopOnEnter = 1
    ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- done profile save
----------------------------------------------------------------------------------------


function ifs_opt_mp_fnBuildScreen(this)
    local w
    local h
    w,h = ScriptCB_GetSafeScreenInfo()
    
    -- Don't use all of the screen for the listbox
    local BottomIconsHeight = 0
    local BotBoxHeight = 0
    local YPadding = 100 -- amount of space to reserve for titlebar, helptext, whitespace, etc

    -- Get usable screen area for listbox
    h = h - BottomIconsHeight - BotBoxHeight - YPadding

    -- Calc height of listbox row, use that to figure out how many rows will fit.
    ifs_opt_mp_layout.FontStr = gListboxItemFont
    ifs_opt_mp_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_opt_mp_layout.FontStr)
    ifs_opt_mp_layout.yHeight = ifs_opt_mp_layout.iFontHeight + 2
    if(1) then -- (gLangStr ~= "english") and (gLangStr ~= "uk_english")) then
        ifs_opt_mp_layout.yHeight = 2 * ifs_opt_mp_layout.yHeight
    else
        ifs_opt_mp_layout.yHeight = math.floor(1.3 * ifs_opt_mp_layout.yHeight)
    end

    local RowHeight = ifs_opt_mp_layout.yHeight + ifs_opt_mp_layout.ySpacing
    ifs_opt_mp_layout.showcount = math.min(math.floor(h / RowHeight) , table.getn(ifs_opt_mp_listtags))

    local listWidth = w * 0.85

		if(gPlatformStr == "PS2") then
			if((gLangStr == "english") or (gLangStr == "uk_english")) then
				listWidth = w * 0.9 -- fix for 6664
			end
		end

    local ListboxHeight = ifs_opt_mp_layout.showcount * RowHeight + 30

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
        y = 0, -- ListboxHeight * 0.5 + 30,
        width = listWidth,
        height = ListboxHeight,
        titleText = "ifs.onlineopt.title",
    }
    ifs_opt_mp_layout.width = listWidth - 40
    ifs_opt_mp_layout.x = 0

    ListManager_fnInitList(this.listbox,ifs_opt_mp_layout)
end

ifs_opt_mp_fnBuildScreen(ifs_opt_mp)
ifs_opt_mp_fnBuildScreen = nil
AddIFScreen(ifs_opt_mp, "ifs_opt_mp")

ifs_opt_mp = DoPostDelete(ifs_opt_mp)
