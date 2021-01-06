--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--
-- -------------------------------------------------------------------
--

-- 'Lobby popups for  picked a player' popup

-- GameVoiceChat::Transport::Mask enumeration from GameVoiceChatTransport.h
gVoicePresets = 
{
    friend   = 1,
    enemy    = 2,
    buddies  = 3,
    everyone = 4,
    noone    = 5,
    custom   = 6
}

gVoicePresetsMin = gVoicePresets.friend
gVoicePresetsMax = gVoicePresets.noone

gVoicePresetStrings = 
{
    [gVoicePresets.friend] = {
        talktostr   = "ifs.onlinelobby.voicepreset.talktofriendteam",
        listentostr = "ifs.onlinelobby.voicepreset.listentofriendteam",
    },
    [gVoicePresets.enemy] = { 
        talktostr   = "ifs.onlinelobby.voicepreset.talktoenemyteam",
        listentostr = "ifs.onlinelobby.voicepreset.listentoenemyteam",
    },
    [gVoicePresets.buddies] = {
        talktostr   = "ifs.onlinelobby.voicepreset.talktobuddies",
        listentostr = "ifs.onlinelobby.voicepreset.listentobuddies",
    },
    [gVoicePresets.everyone] = { 
        talktostr   = "ifs.onlinelobby.voicepreset.talktoeveryone",
        listentostr = "ifs.onlinelobby.voicepreset.listentoeveryone",
    },    
    [gVoicePresets.noone] = { 
        talktostr   = "ifs.onlinelobby.voicepreset.talktonoone",
        listentostr = "ifs.onlinelobby.voicepreset.listentonoone",
    },
    [gVoicePresets.custom] = { 
        talktostr   = "ifs.onlinelobby.voicepreset.talktocustom",
        listentostr = "ifs.onlinelobby.voicepreset.listentocustom",
    },
}


LobbyOpts_layout = {
    --  yTop     = -25, -- auto-calc'd now.
    width    = 450,
    ySpacing = 0,
    font     = gPopupButtonFont,
    
    buttonlist = { 
        -- Options for the session as a whole
        --      { tag = "launch",   string = "common.mp.launch", },
        --      { tag = "friends",  string = "ifs.onlinelobby.friendslist", },
        --      { tag = "recent",   string = "ifs.onlinelobby.recentlist", },
        --      { tag = "options",  string = "ifs.onlinelobby.gameoptions", },
        --      { tag = "leave",    string = "ifs.onlinelobby.leave", },
        --      { tag = "lock",     string = "ifs.onlinelobby.locksession", },

        { tag = "talktopreset",   string = "ifs.onlinelobby.voicepreset.talktofriendteam" },
        { tag = "listentopreset", string = "ifs.onlinelobby.voicepreset.listentofriendteam" }, 

        -- Options for just the selected player (which must have bOnlyForPlayer =
        -- 1 in them)
        { bOnlyForPlayer = 1, tag = "friend",         string = "ifs.onlinelobby.addfriend", },
        { bOnlyForPlayer = 1, tag = "friendvoice",    string = "ifs.onlinelobby.addfriendvoice", font = "gamefont_tiny", yAdd = 8 },
        { bOnlyForPlayer = 1, tag = "delfriend",      string = "ifs.mp.friends.remove", },
        { bOnlyForPlayer = 1, tag = "feedback",       string = "ifs.onlinelobby.sendfeedback", },
        { bOnlyForPlayer = 1, tag = "team",           string = "ifs.onlinelobby.changeteam", },
        { bOnlyForPlayer = 1, tag = "boot",           string = "ifs.onlinelobby.boot", },
        { bOnlyForPlayer = 1, tag = "talktoplayer",   string = "ifs.onlinelobby.voicetalktodisabled", },
        { bOnlyForPlayer = 1, tag = "listentoplayer", string = "ifs.onlinelobby.voicelistentodisabled", },
        -- XLive only option
        { bOnlyForPlayer = 1, tag = "mute",           string = "ifs.onlinelobby.voiceunmuted", },

        --{ tag = "back", string = "common.back", },
        { bOnlyForPlayer = 1, tag = "back2",     string = "common.back", }, -- Cannot have 2 buttons w/ same tag. NM 4/27/04
    },
    nocreatebackground = 1,
}


-- enable / disable voice buttons
function gPopup_LobbyOpts_fnUpdateVoiceButtons(this)
    local XLive = (gOnlineServiceStr == "XLive") and ScriptCB_IsLoggedIn()
    
    -- determine whether voice render / capture devices are connected
    this.voiceRenderDevice  = ScriptCB_GetVoiceCaptureConnected()
    this.voiceCaptureDevice = ScriptCB_GetVoiceRenderConnected()
    
    -- hide preset buttons if a chat device isn't connected
    this.buttons.talktopreset.hidden   = not this.voiceRenderDevice
    this.buttons.listentopreset.hidden = not this.voiceCaptureDevice
    
    -- hide talk to player buttons if current selection is the local player, xlive is enabled or 
    -- the voice device isn't connected
    this.buttons.talktoplayer.hidden   = XLive or this.bIsMe or this.buttons.talktopreset.hidden
    this.buttons.listentoplayer.hidden = XLive or this.bIsMe or this.buttons.listentopreset.hidden
    
    -- hide add to mute list button if it's not an xlive game or voice render device is not present
    this.buttons.mute.hidden = not XLive or this.bIsMe -- or this.buttons.listentopreset.hidden 
    
    -- friend request with voice attachment 
    this.buttons.friendvoice.hidden = not XLive or this.bIsMe or this.bIsFriend or this.bIsGuest or
                                      this.buttons.talktopreset.hidden
end


-- resize the window to fit the enabled buttons
function gPopup_LobbyOpts_fnResize(this)
    local NumButtons = table.getn(LobbyOpts_layout.buttonlist)
    -- Now, clear hilighting of buttons to default, count how many are visible
    local tag
    local VisCount = 0
    for i = 1,NumButtons do
        IFButton_fnSelect(this.buttons[LobbyOpts_layout.buttonlist[i].tag], nil)
        if(not this.buttons[LobbyOpts_layout.buttonlist[i].tag].hidden) then
            VisCount = VisCount + 1
        end
    end

    local HeightPer = (LobbyOpts_layout.yHeight + LobbyOpts_layout.ySpacing)
    local TotalHeight = (HeightPer * VisCount) + 90

		-- Hack for bug 7233 - make popup biger for insanely long XLive strings
		if(gOnlineServiceStr == "XLive") then
			this.width = 475
		end

    gButtonWindow_fnSetSize(this, this.width, TotalHeight)

    LobbyOpts_layout.yTop = (this.height * 0.5) - (HeightPer * VisCount) -- bottom aligned

		LobbyOpts_layout.HardWidthMax = this.width - 48
    this.CurButton = ShowHideVerticalButtons(this.buttons,LobbyOpts_layout)
    SetCurButton(this.CurButton)
    IFObj_fnSetPos(this.title,this.title.x2,(TotalHeight * -0.5) + 15)

    -- Move friends icon if appropriate
    if (XLive and (not this.bOnlyForPlayer)) then
        local XPos = (IFText_fnGetExtent(this.buttons.friends.label) * 0.5) + 20
        local YPos = this.buttons.friends.y - 12
        IFObj_fnSetPos(this.buttons.FriendIcon,XPos,YPos)
        IFObj_fnSetVis(this.buttons.FriendIcon, 1) -- visible
    else
        IFObj_fnSetVis(this.buttons.FriendIcon, nil) -- just hide it.
    end
end


-- Does any work to activate this
function gPopup_LobbyOpts_fnActivate(this,vis)
    --  ifs_meta_main:fnActivateInfoWindow(not vis)
    this:fnDefaultActivate(vis)

    this.bIsActivated = vis

    local A1,A2
    local XLive = (gOnlineServiceStr == "XLive")

    if(vis) then
        A1,A2 = 1.0,0.0
        ScriptCB_BeginFriends()

        -- Turn buttons on/off as appropriate.
        -- First step: turn on/off items based on Player/Global mode. Will
        -- adjust individual ones below.

        -- Now, adjust buttons present only for the per-player menu
        if(this.bOnlyForPlayer) then

            if(ScriptCB_GetAmHost()) then
                this.buttons.boot.hidden = this.bIsMe -- can't kick self
                --this.buttons.team.hidden = nil
            else
                -- Not host. Set client options
                this.buttons.boot.hidden = ScriptCB_IsInShell()
                
                --this.buttons.boot.hidden = not this.bIsMe -- can only adjust for self
                this.buttons.boot.string = "ifs.onlinelobby.vote"
                
                if( this.bIsMe ) then
                    this.buttons.boot.hidden = 1  -- can't kick self
                end

                -- won't boot if players are different team
                if( not Popup_LobbyOpts.bIsSameTeam ) then
                    this.buttons.boot.hidden = 1  -- can't kick other team
                end             
            end
            
            -- can you boot this person?
            if(not this.bCanBoot) then
                this.buttons.boot.hidden = 1
            end

            -- temp allow boot self.
            -- this.buttons.boot.hidden = nil
            
            
            -- boot was moved onto the main screen.  leave all the logic
            -- here though since they're going to change their minds.
            this.buttons.boot.hidden = 1
            --
            --
            
            -- can only adjust for self
            this.buttons.team.hidden = not this.bIsMe
            if(ScriptCB_GetAutoAssignTeams()) then
                this.buttons.team.hidden = 1
            end

            -- Giz wants team selection hidden 100% of the time - NM 7/5/04
            -- Don't undo this without looking at bug 6094
            this.buttons.team.hidden = 1

            -- update voice chat buttons
            gPopup_LobbyOpts_fnUpdateVoiceButtons(this)

            -- Add to Friends, Feedback available for non-me in XLive
            -- [If already a friend, separate option is available]
            local FriendsDisabled = (gOnlineServiceStr == "LAN") or (not ScriptCB_IsLoggedIn())

            this.buttons.friend.hidden      = FriendsDisabled or this.bIsMe or this.bIsFriend or this.bIsGuest or (not this.bCanAddFriend)
						-- Fix for 12131 - can't delete GS buddies from here. Must do it from
						-- buddy list screen.
            this.buttons.delfriend.hidden   = FriendsDisabled or this.bIsMe or (not this.bIsFriend) or this.bIsGuest or (ScriptCB_GetOnlineService() == "GameSpy")

            -- Not quite the same as a friend.
            this.buttons.feedback.hidden = not XLive or this.bIsMe or this.bIsGuest

            -- Adjust mute text depending on setting
            if (this.bIsMuted) then
                RoundIFButtonLabel_fnSetString(this.buttons.mute, "ifs.onlinelobby.delmute")
            else
                RoundIFButtonLabel_fnSetString(this.buttons.mute, "ifs.onlinelobby.addmute")
            end
            
            -- voice send / receive status           
            this.voiceSendPlayer    = ScriptCB_GetVoiceSendStatus   (this.playerIndex) >= 3
            this.voiceReceivePlayer = ScriptCB_GetVoiceReceiveStatus(this.playerIndex) >= 3

            
        else
            -- Must be in the session options. Adjust buttons as needed
            this.buttons.launch.hidden = (not ScriptCB_GetShellActive()) or 
                ((not ScriptCB_GetAmHost()) and (not ScriptCB_HasServerLaunched()))
            this.buttons.lock.hidden = (not ScriptCB_GetShellActive()) or (not ScriptCB_GetAmHost())

            this.buttons.friends.hidden = not XLive or gE3Build
            --          this.buttons.recent.hidden = (gOnlineServiceStr ~= "XLive") or gE3Build

            if(this.bE3Mode) then
                this.buttons.lock.hidden = 1
                this.buttons.options.hidden = 1
            end

        end

        gPopup_LobbyOpts_fnResize(this)

        if(ifs_mp_lobby.Helptext_Accept) then
            IFText_fnSetString(ifs_mp_lobby.Helptext_Accept.helpstr,"common.accept")
            gHelptext_fnMoveIcon(ifs_mp_lobby.Helptext_Accept)
        end
        
        this.voiceSendPreset    = ScriptCB_GetVoiceSendPreset()
        this.voiceReceivePreset = ScriptCB_GetVoiceReceivePreset()
    else
        -- vis = false. Back to the original mode
        ScriptCB_CancelFriends()
        A1,A2 = 0.0,1.0
        if(ifs_mp_lobby.Helptext_Accept) then
            IFText_fnSetString(ifs_mp_lobby.Helptext_Accept.helpstr,"ifs.onlinelobby.playeropts")
            gHelptext_fnMoveIcon(ifs_mp_lobby.Helptext_Accept)
        end
    end

    -- Animation on the "Session Options" vs "Accept" text
    local fAnimTime = 0.25


    --  AnimationMgr_AddAnimation(ifs_mp_lobby.Helptext_Misc2, { fTotalTime = fAnimTime, fStartAlpha = A1, fEndAlpha = A2,})
    AnimationMgr_AddAnimation(ifs_mp_lobby.Helptext_Misc, { fTotalTime = fAnimTime, fStartAlpha = A1, fEndAlpha = A2,})
end



-- Handle the user hitting accept (back uses defaults). Close this popup,
-- let main gameplay decide what to do next.
function gPopup_LobbyOpts_fnInput_Accept(this)
    local callDone = 1
    -- Cancel it before we do anything else
    this:fnActivate(nil)

    if (this.CurButton == "back" or this.CurButton == "back2") then
        ifelm_shellscreen_fnPlaySound("shell_menu_exit")
    end

    if((this.CurButton ~= "back") and (this.CurButton ~= "back2")) then
        local Selection = ifs_mp_lobby_listbox_contents[lobby_listbox_layout.SelectedIdx]
        
        if(this.CurButton == "launch") then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
            ScriptCB_LaunchLobby()
            
        elseif (this.CurButton == "friends") then
            if(gOnlineServiceStr == "XLive") then 
                ifelm_shellscreen_fnPlaySound("shell_menu_accept")
                ifs_mpxl_friends.bRecentMode = nil
                ifs_movietrans_PushScreen(ifs_mpxl_friends)
            end

        elseif (this.CurButton == "friendvoice") then
            if(gOnlineServiceStr == "XLive") then 
                ifelm_shellscreen_fnPlaySound("shell_menu_accept")
                ifs_mpxl_voicemail.bRecordOnly = 1
                ifs_mpxl_voicemail.bInviteMode = nil
                ifs_mpxl_voicemail.bFriendMode = 1
				ifs_mpxl_voicemail.iTargetIdx = Selection.indexstr
                ifs_mpxl_voicemail.TargetStr = Selection.namestr 
                ifs_movietrans_PushScreen(ifs_mpxl_voicemail)
            end
            
        elseif (this.CurButton == "recent") then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")    
            ifs_mpxl_friends.bRecentMode = 1
            ifs_movietrans_PushScreen(ifs_mpxl_friends)
            
        elseif (this.CurButton == "options") then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
            ifs_movietrans_PushScreen(ifs_opt_mp)
            
        elseif (this.CurButton == "feedback") then
            ifelm_shellscreen_fnPlaySound("shell_menu_accept")
            ifs_mpxl_feedback.TargetName = Selection.namestr
            ifs_mpxl_feedback.bVoicemailOnly = nil
            ifs_movietrans_PushScreen(ifs_mpxl_feedback)
            
        elseif (gPlatformStr == "PC" and 
                        (this.CurButton == "talktopreset" or
                         this.CurButton == "listentopreset" or
                             this.CurButton == "talktoplayer" or
                             this.CurButton == "listentoplayer")) then
            gPopup_LobbyOpts_fnInput_Right(this)
            callDone = nil
            
        else
            ifelm_shellscreen_fnPlaySound("shell_select_change")
            ScriptCB_LobbyAction(Selection.indexstr, Selection.namestr, this.CurButton)
        end
    end

    -- finished callback function   
    if(this.fnDone and callDone) then
        this.fnDone()
        fnDone = nil;
    end
end


-- update voice display text
function gPopup_LobbyOpts_fnVoiceUpdate(this)
    -- talk to / listen to preset
    RoundIFButtonLabel_fnSetString(this.buttons.talktopreset, 
        gVoicePresetStrings[this.voiceSendPreset].talktostr)    
    RoundIFButtonLabel_fnSetString(this.buttons.listentopreset, 
        gVoicePresetStrings[this.voiceReceivePreset].listentostr)

    -- talk to / listen to player
    local displayString
    if (this.voiceSendPlayer) then
        displayString = "ifs.onlinelobby.voicetalktoenabled"
    else
        displayString = "ifs.onlinelobby.voicetalktodisabled"
    end
    RoundIFButtonLabel_fnSetString(this.buttons.talktoplayer, displayString) 
    
    if (this.voiceReceivePlayer) then
        displayString = "ifs.onlinelobby.voicelistentoenabled"
    else
        displayString = "ifs.onlinelobby.voicelistentodisabled"
    end
    RoundIFButtonLabel_fnSetString(this.buttons.listentoplayer, displayString)
end


-- update voice transport settings
function gPopup_LobbyOpts_fnVoiceApply(this)

    if (this.CurButton == "talktopreset") then
        ScriptCB_SetVoiceSendPreset(this.voiceSendPreset)
        ScriptCB_SetVoiceReceivePreset(this.voiceReceivePreset)
        this.voiceSendPreset    = ScriptCB_GetVoiceSendPreset()
        this.voiceReceivePreset = ScriptCB_GetVoiceReceivePreset()
        this.voiceSendPlayer    = ScriptCB_GetVoiceSendStatus(this.playerIndex) >= 3
        this.voiceReceivePlayer = ScriptCB_GetVoiceReceiveStatus(this.playerIndex) >= 3
        
    elseif (this.CurButton == "listentopreset") then
        ScriptCB_SetVoiceSendPreset(this.voiceSendPreset)
        ScriptCB_SetVoiceReceivePreset(this.voiceReceivePreset)
        this.voiceSendPreset    = ScriptCB_GetVoiceSendPreset()
        this.voiceReceivePreset = ScriptCB_GetVoiceReceivePreset()
        this.voiceSendPlayer    = ScriptCB_GetVoiceSendStatus(this.playerIndex) >= 3
        this.voiceReceivePlayer = ScriptCB_GetVoiceReceiveStatus(this.playerIndex) >= 3
        
    elseif (this.CurButton == "talktoplayer") then
        ScriptCB_SetVoiceSendPreset(gVoicePresets.custom)
        this.voiceSendPreset = ScriptCB_GetVoiceSendPreset()
        if (this.voiceSendPreset == gVoicePresets.custom) then
            ScriptCB_SetVoiceSendEnable(this.playerIndex, this.voiceSendPlayer)
        end
        

    elseif (this.CurButton == "listentoplayer") then
        ScriptCB_SetVoiceReceivePreset(gVoicePresets.custom)
        this.voiceReceivePreset = ScriptCB_GetVoiceReceivePreset()
        if (this.voiceReceivePreset == gVoicePresets.custom) then
            ScriptCB_SetVoiceReceiveEnable(this.playerIndex, this.voiceReceivePlayer)
        end

    end
    
    gPopup_LobbyOpts_fnVoiceUpdate(this)
    ifelm_shellscreen_fnPlaySound("shell_select_change")
end


-- handles silly preset combinations 
function gPopup_LobbyOpts_fnVoiceSendPresetValidate(this, increased)
    local lanGame = gOnlineServiceStr == "LAN"
    
    if (gVoicePresets.friend == this.voiceSendPreset and
        gVoicePresets.enemy  == this.voiceReceivePreset) then        
        this.voiceReceivePreset = gVoicePresets.friend
        
    elseif (gVoicePresets.enemy  == this.voiceSendPreset and
            gVoicePresets.friend == this.voiceReceivePreset) then            
        this.voiceReceivePreset = gVoicePresets.enemy

    elseif ((gPlatformStr ~= "XBox" or not ScriptCB_IsLoggedIn()) and lanGame and 
            gVoicePresets.buddies == this.voiceSendPreset) then
        if (increased) then
            this.voiceSendPreset = gVoicePresets.everyone
        else
            this.voiceSendPreset = gVoicePresets.enemy
        end
    end
end


-- handles silly preset combinations 
function gPopup_LobbyOpts_fnVoiceReceivePresetValidate(this, increased)
    local lanGame = gOnlineServiceStr == "LAN"

    if (gVoicePresets.friend == this.voiceSendPreset and
            gVoicePresets.enemy  == this.voiceReceivePreset) then
        this.voiceSendPreset = gVoicePresets.enemy
        
    elseif (gVoicePresets.enemy  == this.voiceSendPreset and
                    gVoicePresets.friend == this.voiceReceivePreset) then            
        this.voiceSendPreset = gVoicePresets.friend
        
    elseif ((gPlatformStr ~= "XBox" or not ScriptCB_IsLoggedIn()) and lanGame and 
            gVoicePresets.buddies == this.voiceReceivePreset) then
        if (increased) then
            this.voiceReceivePreset = gVoicePresets.everyone
        else
            this.voiceReceivePreset = gVoicePresets.enemy
        end
    end
end


-- handle left button
function gPopup_LobbyOpts_fnInput_Left(this)
    if (this.CurButton == "talktopreset") then
        this.voiceSendPreset = this.voiceSendPreset - 1
        if (this.voiceSendPreset < gVoicePresetsMin) then
            this.voiceSendPreset = gVoicePresetsMax
        end
        
        gPopup_LobbyOpts_fnVoiceSendPresetValidate(this, nil)
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    elseif (this.CurButton == "listentopreset") then
        this.voiceReceivePreset = this.voiceReceivePreset - 1
        if (this.voiceReceivePreset < gVoicePresetsMin) then
            this.voiceReceivePreset = gVoicePresetsMax
        end

        gPopup_LobbyOpts_fnVoiceReceivePresetValidate(this, nil)
        gPopup_LobbyOpts_fnVoiceApply(this)

    elseif (this.CurButton == "talktoplayer") then
        this.voiceSendPlayer = not this.voiceSendPlayer
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    elseif (this.CurButton == "listentoplayer") then
        this.voiceReceivePlayer = not this.voiceReceivePlayer   
        gPopup_LobbyOpts_fnVoiceApply(this)
    
    else
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
    end   
end


-- handle right button
function gPopup_LobbyOpts_fnInput_Right(this)
    if (this.CurButton == "talktopreset") then
        this.voiceSendPreset = this.voiceSendPreset + 1
        if (this.voiceSendPreset > gVoicePresetsMax) then
            this.voiceSendPreset = gVoicePresetsMin
        end
        
        gPopup_LobbyOpts_fnVoiceSendPresetValidate(this, 1)
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    elseif (this.CurButton == "listentopreset") then
        this.voiceReceivePreset = this.voiceReceivePreset + 1
        if (this.voiceReceivePreset > gVoicePresetsMax) then
            this.voiceReceivePreset = gVoicePresetsMin
        end
        
        gPopup_LobbyOpts_fnVoiceReceivePresetValidate(this, 1)
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    elseif (this.CurButton == "talktoplayer") then
        this.voiceSendPlayer = not this.voiceSendPlayer
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    elseif (this.CurButton == "listentoplayer") then
        this.voiceReceivePlayer = not this.voiceReceivePlayer
        gPopup_LobbyOpts_fnVoiceApply(this)
        
    else
        ifelm_shellscreen_fnPlaySound("shell_menu_error")
    end
end


function gPopup_LobbyOpts_fnUpdate(this,fDt)

    -- Call base class
    gIFShellScreenTemplate_fnUpdate(this,fDt)
    
    gPopup_LobbyOpts_fnVoiceUpdate(this)
    
    this.fHeadsetTimer = this.fHeadsetTimer - fDt
    if (this.fHeadsetTimer < 0) then
        this.fHeadsetTimer = 0.15
        
        -- save previous chat device's state
        local voiceCaptureDevice = this.voiceCaptureDevice
        local voiceRenderDevice  = this.voiceRenderDevice
        
        -- update chat buttons
        gPopup_LobbyOpts_fnUpdateVoiceButtons(this)
        
        -- has the chat device state changed ? 
        if ((voiceRenderDevice      and not this.voiceRenderDevice) or 
            (not voiceRenderDevice  and this.voiceRenderDevice) or
            (voiceCaptureDevice     and not this.voiceCaptureDevice) or
            (not voiceCaptureDevice and this.voiceCaptureDevice)) then
            
					LobbyOpts_layout.HardWidthMax = this.width - 48
            this.CurButton = ShowHideVerticalButtons(this.buttons,LobbyOpts_layout)
            SetCurButton(this.CurButton)
            gPopup_LobbyOpts_fnResize(this)
            
        end        
    end
end


Popup_LobbyOpts = NewPopup {
    ScreenRelativeX = 0.5, -- centered onscreen
    ScreenRelativeY = 0.4,
    height = 240,
	width = 400, -- XLive overrides this in gPopup_LobbyOpts_fnResize()
    ZPos = 50,

    title = NewIFText {
        string = "ifs.onlinelobby.options",
        font = "gamefont_medium",
        texth = 40,
        textw = 300,
        --      y = -110,
        nocreatebackground = 1,
    },

    buttons = NewIFContainer {
			y = -30,
    },

    fnActivate         = gPopup_LobbyOpts_fnActivate,
    Input_Accept       = gPopup_LobbyOpts_fnInput_Accept,
    Input_GeneralLeft  = gPopup_LobbyOpts_fnInput_Left,
    Input_GeneralRight = gPopup_LobbyOpts_fnInput_Right,
    
    Input_Back         = function(this)
        ifelm_shellscreen_fnPlaySound("shell_menu_exit")
        gPopup_fnInput_Back(this)
    end,
    
    fHeadsetTimer      = 0,
    Update             = gPopup_LobbyOpts_fnUpdate,
    
    voiceSendPreset    = gVoicePresets.friend,
    voiceReceivePreset = gVoicePresets.friend,
    voiceRenderDevice  = nil,
    voiceCaptureDevice = nil,
}

-- Helper function, makes items
function Popup_LobbyOpts_fnBuildPopup(this)
    this.title.x2 = this.title.x
    --  this.title.y = (this.height * -0.5) + 16 -- done on entry now
    gButtonWindow_fnSetTexture(this,"opaque_rect")
    
        LobbyOpts_layout.yHeight = ScriptCB_GetFontHeight(LobbyOpts_layout.font)
    LobbyOpts_layout.yTop = (this.height * 0.5) - 
        ((LobbyOpts_layout.yHeight + LobbyOpts_layout.ySpacing) * table.getn(LobbyOpts_layout.buttonlist))

    AddVerticalButtons(this.buttons,LobbyOpts_layout)

    local IconSize = 32
    this.buttons.FriendIcon = NewIFImage { 
        texture = "lobby_icons", 
        localpos_l = 0, localpos_t = 0, 
        localpos_b = IconSize, localpos_r = IconSize,
        bInertPos = 1,
        ZPos = 10, -- on top of almost everything
    }
    this.nextFriendIconUpdate = 0 -- update ASAP on entry
    
    if (gPlatformStr == "XBox") then
        gVoicePresetStrings[gVoicePresets.buddies].talktostr   = 
            "ifs.onlinelobby.voicepreset.talktofriends"
        gVoicePresetStrings[gVoicePresets.buddies].listentostr = 
            "ifs.onlinelobby.voicepreset.listentofriends"
    end
end

Popup_LobbyOpts_fnBuildPopup(Popup_LobbyOpts)
Popup_LobbyOpts_fnBuildPopup = nil -- dump out of memory
CreatePopupInC(Popup_LobbyOpts,"Popup_LobbyOpts")

Popup_LobbyOpts = DoPostDelete(Popup_LobbyOpts)