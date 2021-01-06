--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Generalized mission select screen. Done to unify the varions
-- screens 

-- *****WARNING - THIS IS NO LONGER USED, EVERYTHING IS IN ifs_instant_options.lua INSTEAD!!!!!******

function ifs_mp_gameopts_fnSetupDefaults(this)

    -- Get defaults first time thru
    --  if(not this.bGotDefaults) then
    --      this.bGotDefaults = 1

--  this.Prefs.iNumPlayers,
--  this.Prefs.iMaxPlayers,
--  this.Prefs.iWarmUp,
--  this.Prefs.iVote,
--  this.Prefs.iNumBots,
--  this.Prefs.iMaxBots,
--  this.Prefs.iTeamDmg,
--  this.Prefs.iAutoAim,
--  this.Prefs.bShowNames,
--  this.Prefs.bAutoAssignTeams,
--  this.Prefs.iStartCnt,
--  this.Prefs.bHeroesEnabled,
--  this.Prefs.iDifficulty,
--  this.Prefs.iMaxDedicatedPlayers,
--  this.Prefs.iMaxDedicatedBots,
--  this.Prefs.iVoiceMode,
--  this.Prefs.iVoiceModeMin,
--  this.Prefs.iVoiceModeMax,
--  this.Prefs.iVoiceModeDedicatedMax = ScriptCB_GetNetGameDefaults()
    
    this.Prefs = ScriptCB_GetNetGameDefaults()

    this.Prefs.bIsPrivate = nil -- default: public
    this.bIsRankedGame = 1
    this.iRankMin = 200
    this.iRankMax = 2000
    this.EntryDedicated = this.bDedicated
    this.Prefs.iWarmUpMax = 120
    this.Prefs.iWarmUpMin = 0
    this.Prefs.iVoteMax = 75
    this.Prefs.iVoteMin = 0
    
    if(not this.bFirstTime) then
        this.bFirstTime = 1
        this.Prefs.iNumPlayers = this.Prefs.iMaxPlayers
        this.Prefs.iNumBots = this.Prefs.iMaxBots
    end
    this.Prefs.iNumPlayers = math.max(this.Prefs.iNumPlayers , ScriptCB_GetNumCameras())

    --  end
end

-- Sets up the screen for the Era mode, or not.
function ifs_mp_gameopts_fnSetMapMode(this,v)
    this.bMapMode = v

    IFObj_fnSetVis(this.buttons, not v)

    gCurHiliteListbox = nil -- cancel hilight in listbox
    gCurHiliteButton = this.buttons[this.CurButton]
end

-- Sets the the text for the options.
function ifs_mp_gameopts_fnSetOptionText(this)
    
    -- show/hide some buttons
    --this.buttons.startcnt.hidden = not this.bDedicated
    --ShowHideVerticalButtons(this.buttons,ifs_mp_gameopts_vbutton_layout)
    
    --set the text  
    local NewStr = ""
    local OnStr = ScriptCB_getlocalizestr("common.on")
    local OffStr = ScriptCB_getlocalizestr("common.off")

    NewStr = ScriptCB_usprintf("ifs.mp.createopts.maxplayers",
                                                         ScriptCB_tounicode(string.format("%d",this.Prefs.iNumPlayers)))
    RoundIFButtonLabel_fnSetUString(this.buttons.players,NewStr)

    NewStr = ScriptCB_usprintf("ifs.mp.createopts.warmup",
                                                         ScriptCB_tounicode(string.format("%d",this.Prefs.iWarmUp)))
    RoundIFButtonLabel_fnSetUString(this.buttons.warmup,NewStr)

    if( this.Prefs.iVote == 0 ) then
        RoundIFButtonLabel_fnSetString(this.buttons.vote,"ifs.mp.createopts.vote0")
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.vote",
                                                             ScriptCB_tounicode(string.format("%d",this.Prefs.iVote)))
        RoundIFButtonLabel_fnSetUString(this.buttons.vote,NewStr)
    end

    NewStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                                                         ScriptCB_tounicode(string.format("%d",this.Prefs.iNumBots)))
    RoundIFButtonLabel_fnSetUString(this.buttons.bots,NewStr)

    NewStr = ScriptCB_usprintf("ifs.mp.createopts.startcnt",
                                                         ScriptCB_tounicode(string.format("%d",this.Prefs.iStartCnt)))
    RoundIFButtonLabel_fnSetUString(this.buttons.startcnt,NewStr)

    --  NewStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage",
    --              ScriptCB_tounicode(string.format("%d",this.Prefs.iTeamDmg)))
    --  RoundIFButtonLabel_fnSetUString(this.buttons.teamdmg,NewStr)
    if(this.Prefs.iTeamDmg < 1) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage",OffStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage",OnStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.teamdmg,NewStr)

    --  NewStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim",
    --              ScriptCB_tounicode(string.format("%d",this.Prefs.iAutoAim)))
    --  RoundIFButtonLabel_fnSetUString(this.buttons.autoaim,NewStr)
    if(this.Prefs.iAutoAim < 1) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim",OffStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim",OnStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.autoaim,NewStr)
    
    if(this.Prefs.bIsPrivate) then
        RoundIFButtonLabel_fnSetString(this.buttons.pubpriv,"ifs.mp.createopts.pubpriv_priv")
    else
        RoundIFButtonLabel_fnSetString(this.buttons.pubpriv,"ifs.mp.createopts.pubpriv_pub")
    end

    if(this.Prefs.PasswordStr) then
        local i
        local ShowStr = ""
        for i=1,string.len(this.Prefs.PasswordStr) do
            ShowStr = ShowStr .. "*"
        end
        local ShowUStr = ScriptCB_tounicode(ShowStr)
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.password",ShowUStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.password",OffStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.pass,NewStr)

    if(this.Prefs.bShowNames) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.shownames",OnStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.shownames",OffStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.shownames,NewStr)

    if(this.Prefs.bHeroesEnabled) then
        RoundIFButtonLabel_fnSetString(this.buttons.hero,"ifs.mp.createopts.heroenable")
    else
        RoundIFButtonLabel_fnSetString(this.buttons.hero,"ifs.mp.createopts.herodisable")
    end

    if(this.Prefs.bAutoAssignTeams) then
        RoundIFButtonLabel_fnSetString(this.buttons.autoassign,"ifs.mp.createopts.autoassign_on")
    else
        RoundIFButtonLabel_fnSetString(this.buttons.autoassign,"ifs.mp.createopts.autoassign_off")
    end

    if(this.bDedicated) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.dedicated",OnStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.dedicated",OffStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.dedicated,NewStr)

    --  NewStr = ScriptCB_usprintf("ifs.mp.createopts.minrank",
    --              ScriptCB_tounicode(string.format("%d",this.iRankMin)))
    --  RoundIFButtonLabel_fnSetUString(this.buttons.rankmin,NewStr)

    --  NewStr = ScriptCB_usprintf("ifs.mp.createopts.maxrank",
    --              ScriptCB_tounicode(string.format("%d",this.iRankMax)))
    --  RoundIFButtonLabel_fnSetUString(this.buttons.rankmax,NewStr)

    --  if(this.bIsRankedGame) then
    --      NewStr = ScriptCB_usprintf("ifs.mp.createopts.rankedgame",OnStr)
    --  else
    --      NewStr = ScriptCB_usprintf("ifs.mp.createopts.rankedgame",OffStr)
    --  end
    --  RoundIFButtonLabel_fnSetUString(this.buttons.rankedgame,NewStr)

    local EasyStr = ScriptCB_getlocalizestr("ifs.difficulty.easy")
    local MediumStr = ScriptCB_getlocalizestr("ifs.difficulty.medium")
    local HardStr = ScriptCB_getlocalizestr("ifs.difficulty.hard")
    if(this.Prefs.iDifficulty==1) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",EasyStr)
    elseif(this.Prefs.iDifficulty==2) then
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",MediumStr)
    else
        NewStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",HardStr)
    end
    RoundIFButtonLabel_fnSetUString(this.buttons.difficulty,NewStr)
    
    
    -- voice transport method
    if (gPlatformStr ~= "XBox") then
        local disabled    = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.disabled")
        local peerToPeer  = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.peertopeer")
        local peerRelay   = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.peerrelay")
        local serverRelay = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.serverrelay")

        if     (this.Prefs.iVoiceMode == 1) then
            NewStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", disabled)
        elseif (this.Prefs.iVoiceMode == 2) then
            NewStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", peerToPeer)
        elseif (this.Prefs.iVoiceMode == 3) then
            NewStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", peerRelay)
        elseif (this.Prefs.iVoiceMode == 4) then
            NewStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", serverRelay)
        else
            NewStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", "Invalid!")
        end
        RoundIFButtonLabel_fnSetUString(this.buttons.voicemode, NewStr)
    end
end

-- Callback function when the virtual keyboard is done
function ifs_mp_gameopts_fnKeyboardDone()
    --  print("ifs_mp_gameopts_fnKeyboardDone()")
    local this = ifs_mp_gameopts
    this.Prefs.PasswordStr = ScriptCB_ununicode(ifs_vkeyboard.CurString)
    ScriptCB_PopScreen()
    ifs_mp_gameopts_fnSetOptionText(this)
    
    --  vkeyboard_specs.fnDone = nil -- clear our registration there
end

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_mp_gameopts_fnIsAcceptable()
    --  print("ifs_mp_gameopts_fnIsAcceptable()")
    return 1,""
end

-- Helper function, updates helptext
function ifs_mp_gameopts_fnUpdateHelptext(this)
    if(this.Helptext_Accept) then
        if (this.CurButton == "pass") then
            IFText_fnSetString(this.Helptext_Accept.helpstr,"common.change")
        else
            IFText_fnSetString(this.Helptext_Accept.helpstr,"ifs.onlinelobby.launch")
        end

        gHelptext_fnMoveIcon(this.Helptext_Accept)
    end
end

ifs_mp_gameopts = NewIFShellScreen {
    nologo = 1,
    bg_texture = "iface_bgmeta_space",
    movieIntro      = nil,
    movieBackground = nil,
    bNohelptext_backPC = 1,
    -- auto launch game server
    bAutoLaunch = nil,
	bAcceptIsSelect = 1,
    
    -- the limits on the math.min/math.max rank values  
    rankLimitsMin = 200,
    rankLimitsMax = 2000,

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
        ScreenRelativeY = gDefaultButtonScreenRelativeY,
    },

    fnDone = nil, -- Callback function to do something when the user is done
    -- Sub-mode for full/era switch is on.
    bMapMode = nil,
    
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call base class
        
        ifs_mp_gameopts_fnSetupDefaults(this)

        if(gPlatformStr == "PC") then
            ifs_mp_gameopts.bAutoLaunch = nil
            this.buttons.autoaim.hidden = 1
        end
        
        -- Added chunk for error handling...
        if(not bFwd) then
            local ErrorLevel,ErrorMessage = ScriptCB_GetError()
            if(ErrorLevel >= 6) then -- session or login error, must keep going further
                ScriptCB_PopScreen()
            end
        end

        if(bFwd) then
            ifs_mp_gameopts.bAutoLaunch = nil
            this.SelectedMap = nil -- clear this

            local bForXLive = (gOnlineServiceStr == "XLive")
            this.buttons.pubpriv.hidden = not bForXLive
            local bPS2orPC = (gPlatformStr == "PS2") or (gPlatformStr == "PC")
            this.buttons.pass.hidden = not bPS2orPC

            this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_mp_gameopts_vbutton_layout)
            SetCurButton(this.CurButton)
            ifs_mp_gameopts_fnUpdateHelptext(this)

            this.Prefs.PasswordStr = nil -- none          
            ifs_mp_gameopts_fnSetOptionText(this)
            
            ifs_mp_gameopts_fnSetMapMode(this,nil) -- default internal mode.
            this.SelectedMap = nil -- clear this
        end
    end,

    Exit = function(this, bFwd)
        if(not bFwd) then
            this.SelectedMap = nil -- clear this
        end
        if(gCurHiliteButton) then
            IFButton_fnSelect(gCurHiliteButton,nil)
        end
    end,

    Input_Accept = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputAccept(this)) then
            return
        end

        ScriptCB_SndPlaySound("shell_menu_enter")

        -- "pass" button only exists on console
        if (this.CurButton == "pass") then
            if(this.Prefs.PasswordStr) then
                ifs_vkeyboard.CurString = ScriptCB_tounicode(this.Prefs.PasswordStr)
            else
                ifs_vkeyboard.CurString = ScriptCB_tounicode("")
            end

            ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
            vkeyboard_specs.bPasswordMode = 1

            IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
            ifs_movietrans_PushScreen(ifs_vkeyboard)
            vkeyboard_specs.fnDone = ifs_mp_gameopts_fnKeyboardDone
            vkeyboard_specs.fnIsOk = ifs_mp_gameopts_fnIsAcceptable
            
            local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
            vkeyboard_specs.MaxWidth = (w * 0.5)
            vkeyboard_specs.MaxLen = 16
        elseif ((gPlatformStr ~= "PC") or ( this.CurButton == "_ok")) then
            
            ScriptCB_SetNetGameDefaults(this.Prefs) 
            -- this.Prefs.iNumPlayers,
            -- this.Prefs.iWarmUp,
            -- this.Prefs.iVote,
            -- this.Prefs.iNumBots,
            -- this.Prefs.iTeamDmg,
            -- this.Prefs.iAutoAim,
            -- this.Prefs.bIsPrivate,
            -- this.Prefs.bShowNames,
            -- this.Prefs.bAutoAssignTeams,
            -- this.Prefs.iStartCnt,
            -- this.Prefs.bHeroesEnabled,
            -- this.Prefs.iDifficulty,
            -- this.Prefs.PasswordStr,
            -- this.Prefs.iVoiceMode)
            
            ScriptCB_SetDedicated(this.bDedicated)
            ScriptCB_SetCanSwitchSides( not this.Prefs.bAutoAssignTeams )
            print("Trying to pop back to mission select")
            if (gPlatformStr ~= "PC") then
                if (this.Prefs.bHeroesEnabled) then
                    ifs_movietrans_PushScreen(ifs_mp_heroopts)
                else
                    ifs_mp_gameopts.bAutoLaunch = 1
                    ScriptCB_BeginLobby()
                end
            else
                if (this.Prefs.bHeroesEnabled) then
                    ScriptCB_SetIFScreen("ifs_mp_heroopts")
                    --                  ifs_movietrans_PushScreen(ifs_mp_heroopts)
                else
                    ScriptCB_PopScreen()
                end
            end
        elseif ( this.CurButton == "_back") then
            print("Trying to pop back to mission select")
            this:Input_Back(this)
        else
            this:Input_GeneralRight(1)
        end
    end, -- end of Input_Accept

    Update = function(this, fDt)
        -- Call default base class's update function (make button bounce)
        gIFShellScreenTemplate_fnUpdate(this,fDt)
        
        if( ifs_mp_gameopts.bAutoLaunch ) then
            ScriptCB_UpdateLobby(nil)
            
            --          print("Autolaunching...")
            ScriptCB_LaunchLobby()
        end
    end,

    Input_Misc = function(this)
        this:Input_GeneralLeft(1)
    end,

    Input_Back = function(this)
        this.bDedicated = this.EntryDedicated
        ScriptCB_PopScreen()
    end,

    Input_GeneralUp = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputUp(this)) then
            return
        end

        gDefault_Input_GeneralUp(this)
        ifs_mp_gameopts_fnUpdateHelptext(this)
    end,

    Input_GeneralDown = function(this)
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputDown(this)) then
            return
        end

        gDefault_Input_GeneralDown(this)
        ifs_mp_gameopts_fnUpdateHelptext(this)
    end,

    Input_LTrigger = function(this)
        if(this.CurButton == "players") then
            if(this.Prefs.iNumPlayers > 10 + math.max(2, ScriptCB_GetNumCameras())) then
                this.Prefs.iNumPlayers = this.Prefs.iNumPlayers - 10;
            else
                this.Prefs.iNumPlayers = math.max(2, ScriptCB_GetNumCameras());
            end
        elseif (this.CurButton == "warmup") then
            this.Prefs.iWarmUp = math.max( this.Prefs.iWarmUpMin, this.Prefs.iWarmUp - 30 )
        elseif (this.CurButton == "bots") then
            this.Prefs.iNumBots = math.max(0,this.Prefs.iNumBots - 10)
            --      elseif (this.CurButton == "teamdmg") then
            --          this.Prefs.iTeamDmg = math.max(0,this.Prefs.iTeamDmg - 100)
            --      elseif (this.CurButton == "autoaim") then
            --          this.Prefs.iAutoAim = math.max(0,this.Prefs.iAutoAim - 100)
        elseif (this.CurButton == "rankmin") then
            this.iRankMin = math.max(this.rankLimitsMin,this.iRankMin - 100)
        elseif (this.CurButton == "rankmax") then
            this.iRankMax = math.max(this.rankLimitsMin,this.iRankMax - 100)
            this.iRankMin = math.min(this.iRankMin,this.iRankMax)
        end
        ifs_mp_gameopts_fnSetOptionText(this)
    end,

    Input_RTrigger = function(this)
        if(this.CurButton == "players") then
            if(this.bDedicated) then
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers+10,this.Prefs.iMaxDedicatedPlayers)
            else
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers+10,this.Prefs.iMaxPlayers)
            end
        elseif (this.CurButton == "warmup") then
            this.Prefs.iWarmUp = math.min( this.Prefs.iWarmUpMax, this.Prefs.iWarmUp + 30 )
        elseif (this.CurButton == "bots") then
            if(this.bDedicated) then
                this.Prefs.iNumBots = math.min(this.Prefs.iNumBots+10,this.Prefs.iMaxDedicatedBots)
            else
                this.Prefs.iNumBots = math.min(this.Prefs.iNumBots+10,this.Prefs.iMaxBots)
            end
            --      elseif (this.CurButton == "teamdmg") then
            --          this.Prefs.iTeamDmg = math.min(250,this.Prefs.iTeamDmg + 100)
            --      elseif (this.CurButton == "autoaim") then
            --          this.Prefs.iAutoAim = math.min(250,this.Prefs.iAutoAim + 100)
        elseif (this.CurButton == "rankmin") then
            this.iRankMin = math.min(this.rankLimitsMax,this.iRankMin + 100)
            this.iRankMax = math.max(this.iRankMin,this.iRankMax)
        elseif (this.CurButton == "rankmax") then
            this.iRankMax = math.min(this.rankLimitsMax,this.iRankMax + 100)
        end
        ifs_mp_gameopts_fnSetOptionText(this)
    end,

    Input_GeneralLeft = function(this)
        if(this.CurButton == "players") then
            --this.Prefs.iNumPlayers = math.max(2,this.Prefs.iNumPlayers - 1)
            if(this.Prefs.iNumPlayers == math.max(2, ScriptCB_GetNumCameras())) then
                if( this.bDedicated ) then
                    this.Prefs.iNumPlayers = this.Prefs.iMaxDedicatedPlayers
                else
                    this.Prefs.iNumPlayers = this.Prefs.iMaxPlayers
                end 
            else
                this.Prefs.iNumPlayers= this.Prefs.iNumPlayers - 1
            end
            
            
            this.Prefs.iStartCnt = math.min(this.Prefs.iNumPlayers,this.Prefs.iStartCnt)
        elseif (this.CurButton == "warmup") then            
            if(this.Prefs.iWarmUp == this.Prefs.iWarmUpMin) then
                this.Prefs.iWarmUp = this.Prefs.iWarmUpMax
            else
                this.Prefs.iWarmUp = math.max( this.Prefs.iWarmUpMin, this.Prefs.iWarmUp - 10 )
            end
        elseif (this.CurButton == "vote") then            
            if(this.Prefs.iVote == this.Prefs.iVoteMin) then
                this.Prefs.iVote = this.Prefs.iVoteMax
            else
                this.Prefs.iVote = math.max( this.Prefs.iVoteMin, this.Prefs.iVote - 25 )
            end
        elseif (this.CurButton == "bots") then
            --this.Prefs.iNumBots = math.max(0,this.Prefs.iNumBots - 1)
            if(this.Prefs.iNumBots == 0) then
                if(this.bDedicated) then
                    this.Prefs.iNumBots =this.Prefs.iMaxDedicatedBots
                else
                    this.Prefs.iNumBots =this.Prefs.iMaxBots
                end
            else
                this.Prefs.iNumBots = this.Prefs.iNumBots - 1
            end
            
            
        elseif (this.CurButton == "teamdmg") then
            --this.Prefs.iTeamDmg = math.max(0,this.Prefs.iTeamDmg - 10)
            this.Prefs.iTeamDmg = 100 - this.Prefs.iTeamDmg
        elseif (this.CurButton == "autoaim") then
            --this.Prefs.iAutoAim = math.max(0,this.Prefs.iAutoAim - 10)
            this.Prefs.iAutoAim = 100 - this.Prefs.iAutoAim
        elseif (this.CurButton == "pubpriv") then
            this.Prefs.bIsPrivate = not this.Prefs.bIsPrivate
        elseif (this.CurButton == "shownames") then
            this.Prefs.bShowNames = not this.Prefs.bShowNames
        elseif (this.CurButton == "hero") then
            this.Prefs.bHeroesEnabled = not this.Prefs.bHeroesEnabled
        elseif (this.CurButton == "autoassign") then
            this.Prefs.bAutoAssignTeams = not this.Prefs.bAutoAssignTeams
        elseif (this.CurButton == "difficulty") then
            this.Prefs.iDifficulty = this.Prefs.iDifficulty-1
            if(this.Prefs.iDifficulty<=0) then
                this.Prefs.iDifficulty = 3
            end
        elseif (this.CurButton == "dedicated") then
            this.bDedicated = not this.bDedicated
            if(this.bDedicated) then
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers,this.Prefs.iMaxDedicatedPlayers)
                this.Prefs.iNumBots    = math.min(this.Prefs.iNumBots,this.Prefs.iMaxDedicatedBots)
                this.Prefs.iVoiceMode  = math.min(this.Prefs.iVoiceMode, this.Prefs.iVoiceModeDedicatedMax)
            else
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers,this.Prefs.iMaxPlayers)
                this.Prefs.iNumBots    = math.min(this.Prefs.iNumBots,this.Prefs.iMaxBots)
                this.Prefs.iVoiceMode  = math.min(this.Prefs.iVoiceMode, this.Prefs.iVoiceModeMax)
            end
            ifs_mp_gameopts_fnSetOptionText(this)
        elseif (this.CurButton == "startcnt") then
            this.Prefs.iStartCnt = math.max(0,this.Prefs.iStartCnt - 1)
        elseif (this.CurButton == "rankmin") then
            this.iRankMin = math.max(this.rankLimitsMin,this.iRankMin - 10)
        elseif (this.CurButton == "rankmax") then
            this.iRankMax = math.max(this.rankLimitsMin,this.iRankMax - 10)
            this.iRankMin = math.min(this.iRankMin,this.iRankMax)
        elseif (this.CurButton == "rankedgame") then
            this.bIsRankedGame = not this.bIsRankedGame
        elseif (this.CurButton == "voicemode") then
            this.Prefs.iVoiceMode = this.Prefs.iVoiceMode - 1
            if (this.Prefs.iVoiceMode < this.Prefs.iVoiceModeMin) then
                if (this.bDedicated) then
                    this.Prefs.iVoiceMode = this.Prefs.iVoiceModeDedicatedMax
                else
                    this.Prefs.iVoiceMode = this.Prefs.iVoiceModeMax
                end
            end
        end
        ifelm_shellscreen_fnPlaySound(this.selectSound)
        ifs_mp_gameopts_fnSetOptionText(this)
    end,

    Input_GeneralRight = function(this)
        if(this.CurButton == "players") then
            if(this.bDedicated) then
                --this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers+1,this.Prefs.iMaxDedicatedPlayers)
                if( this.Prefs.iNumPlayers == this.Prefs.iMaxDedicatedPlayers ) then
                    this.Prefs.iNumPlayers = math.max(2, ScriptCB_GetNumCameras())
                else
                    this.Prefs.iNumPlayers = this.Prefs.iNumPlayers + 1
                end
            else
                --this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers+1,this.Prefs.iMaxPlayers)
                if(this.Prefs.iNumPlayers ==  this.Prefs.iMaxPlayers ) then
                    this.Prefs.iNumPlayers = math.max(2, ScriptCB_GetNumCameras())
                else
                    this.Prefs.iNumPlayers = this.Prefs.iNumPlayers + 1
                end
                
            end
            elseif(this.CurButton == "warmup") then            
            if(this.Prefs.iWarmUp == this.Prefs.iWarmUpMax) then
                this.Prefs.iWarmUp = this.Prefs.iWarmUpMin
            else
                this.Prefs.iWarmUp = math.min( this.Prefs.iWarmUpMax, this.Prefs.iWarmUp + 10 )
            end
            elseif(this.CurButton == "vote") then            
            if(this.Prefs.iVote == this.Prefs.iVoteMax) then
                this.Prefs.iVote = this.Prefs.iVoteMin
            else
                this.Prefs.iVote = math.min( this.Prefs.iVoteMax, this.Prefs.iVote + 25 )
            end
        elseif (this.CurButton == "bots") then
            if(this.bDedicated) then
                --              print("setting dedicated bots")
                --  this.Prefs.iNumBots = math.min(this.Prefs.iNumBots+1,this.Prefs.iMaxDedicatedBots)
                if( this.Prefs.iNumBots == this.Prefs.iMaxDedicatedBots ) then
                    this.Prefs.iNumBots = 0
                else
                    this.Prefs.iNumBots = this.Prefs.iNumBots + 1
                end
            else
                --              print("setting non-dedicated bots")
                --  this.Prefs.iNumBots = math.min(this.Prefs.iNumBots+1,this.Prefs.iMaxBots)
                if(this.Prefs.iNumBots == this.Prefs.iMaxBots ) then
                    this.Prefs.iNumBots = 0
                else
                    this.Prefs.iNumBots = this.Prefs.iNumBots + 1
                end
                
            end
        elseif (this.CurButton == "teamdmg") then
            --this.Prefs.iTeamDmg = math.min(250,this.Prefs.iTeamDmg + 10)
            this.Prefs.iTeamDmg = 100 - this.Prefs.iTeamDmg
        elseif (this.CurButton == "autoaim") then
            --this.Prefs.iAutoAim = math.min(250,this.Prefs.iAutoAim + 10)
            this.Prefs.iAutoAim = 100 - this.Prefs.iAutoAim
        elseif (this.CurButton == "pubpriv") then
            this.Prefs.bIsPrivate = not this.Prefs.bIsPrivate
        elseif (this.CurButton == "shownames") then
            this.Prefs.bShowNames = not this.Prefs.bShowNames
        elseif (this.CurButton == "hero") then
            this.Prefs.bHeroesEnabled = not this.Prefs.bHeroesEnabled
        elseif (this.CurButton == "autoassign") then
            this.Prefs.bAutoAssignTeams = not this.Prefs.bAutoAssignTeams
        elseif (this.CurButton == "difficulty") then
            this.Prefs.iDifficulty = this.Prefs.iDifficulty+1
            if(this.Prefs.iDifficulty>3) then
                this.Prefs.iDifficulty = 1
            end
        elseif (this.CurButton == "dedicated") then
            this.bDedicated = not this.bDedicated
            if(this.bDedicated) then
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers,this.Prefs.iMaxDedicatedPlayers)
                this.Prefs.iNumBots    = math.min(this.Prefs.iNumBots,this.Prefs.iMaxDedicatedBots)
                this.Prefs.iVoiceMode  = math.min(this.Prefs.iVoiceMode, this.Prefs.iVoiceModeDedicatedMax)
            else
                this.Prefs.iNumPlayers = math.min(this.Prefs.iNumPlayers,this.Prefs.iMaxPlayers)
                this.Prefs.iNumBots    = math.min(this.Prefs.iNumBots,this.Prefs.iMaxBots)
                this.Prefs.iVoiceMode  = math.min(this.Prefs.iVoiceMode, this.Prefs.iVoiceModeMax)
            end
            ifs_mp_gameopts_fnSetOptionText(this)
        elseif (this.CurButton == "startcnt") then
            this.Prefs.iStartCnt = math.min(this.Prefs.iNumPlayers,this.Prefs.iStartCnt + 1)
        elseif (this.CurButton == "rankmin") then
            this.iRankMin = math.min(this.rankLimitsMax,this.iRankMin + 10)
            this.iRankMax = math.max(this.iRankMin,this.iRankMax)
        elseif (this.CurButton == "rankmax") then
            this.iRankMax = math.min(this.rankLimitsMax,this.iRankMax + 10)
        elseif (this.CurButton == "rankedgame") then
            this.bIsRankedGame = not this.bIsRankedGame
        elseif (this.CurButton == "voicemode") then
            this.Prefs.iVoiceMode = this.Prefs.iVoiceMode + 1
            if ((this.bDedicated and 
                 this.Prefs.iVoiceMode > this.Prefs.iVoiceModeDedicatedMax) or
                 this.Prefs.iVoiceMode > this.Prefs.iVoiceModeMax) then
                this.Prefs.iVoiceMode = this.Prefs.iVoiceModeMin            
            end
        end
        ifelm_shellscreen_fnPlaySound(this.selectSound)
        ifs_mp_gameopts_fnSetOptionText(this)
    end,
}

ifs_mp_gameopts_vbutton_layout = {
    --  yTop = 40, -- auto-calc'd now to be centered vertically
    ySpacing  = 5,
    --  width = 350,    -- Calculated below as a % of screen size
    font = gMenuButtonFont,
    buttonlist = { 
        { tag = "dedicated", string2 = "ifs.mp.createopts.dedicated" },
        { tag = "players", string2 = "ifs.mp.createopts.maxplayers", },
        { tag = "warmup", string2 = "ifs.mp.createopts.warmup", },
        { tag = "vote", string2 = "ifs.mp.createopts.vote", },
        { tag = "bots", string2 = "ifs.mp.createopts.numbots", },
        { tag = "teamdmg", string2 = "ifs.mp.createopts.teamdamage", },
        { tag = "autoaim", string2 = "ifs.mp.createopts.autoaim", },
        { tag = "shownames", string2 = "ifs.mp.createopts.shownames", },
        { tag = "hero", string2 = "ifs.mp.createopts.heroes", },
        { tag = "autoassign", string2 = "ifs.mp.createopts.autoassign_on", },
        { tag = "difficulty", string2 = "ifs.difficulty.title", },
        { tag = "startcnt", string2 = "ifs.mp.createopts.startcnt", },

        { tag = "voicemode", string2 = "ifs.mp.createopts.voicemode", },
        
        --      { tag = "rankmin", string2 = "ifs.mp.createopts.rankmin" },
        --      { tag = "rankmax", string2 = "ifs.mp.createopts.rankmax" },
        --      { tag = "rankedgame", string2 = "ifs.mp.createopts.rankedgame" },
        { tag = "pubpriv", string2 = "ifs.mp.createopts.pubpriv_pub", },
        { tag = "pass", string2 = "", }, --No password for PC version
        
    },
    title = "ifs.mp.createopts.title",
    rotY = 40,
}

-- Helper function, builds this screen.
function ifs_mp_gameopts_fnBuildScreen(this)
    local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

    if(gLangStr ~= "english") then
        ifs_mp_gameopts_vbutton_layout.font = "gamefont_small"
    end

    ifs_mp_gameopts_vbutton_layout.width = w * 0.85
    this.CurButton = AddVerticalButtons(this.buttons,ifs_mp_gameopts_vbutton_layout)
    
    if(gPlatformStr == "PC") then

        local BackButtonW = 100
        local BackButtonH = 25
        this.donebutton =   NewClickableIFButton
        {
            ScreenRelativeX = 1.0, -- right
            ScreenRelativeY = 1.0, -- bottom
            y = -15, -- just above bottom
            x = -BackButtonW,
            btnw = BackButtonW, 
            btnh = BackButtonH,
            font = "gamefont_medium", 
            bg_width = BackButtonW, 
            tag = "_ok",
            bg_xflipped = 1,
            nocreatebackground=1,           
        }
        RoundIFButtonLabel_fnSetString(this.donebutton,"common.accept")
        
        this.cancelbutton = NewClickableIFButton
        {
            ScreenRelativeX = 0.0, -- right
            ScreenRelativeY = 1.0, -- bottom
            y = -15, -- just above bottom
            x = BackButtonW,
            btnw = BackButtonW, 
            btnh = BackButtonH,
            font = "gamefont_medium", 
            bg_width = BackButtonW, 
                
            tag = "_back",
            nocreatebackground=1,           
        }
        RoundIFButtonLabel_fnSetString(this.cancelbutton,"common.cancel")
    end
end


ifs_mp_gameopts_fnBuildScreen(ifs_mp_gameopts)
ifs_mp_gameopts_fnBuildScreen = nil -- clear out of memory to save space
AddIFScreen(ifs_mp_gameopts,"ifs_mp_gameopts")

