-- ifs_instant_options.lua  (PSP)
-- verified (cbadal)
-- 
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Screen for Instant Action options

-- Internal set of pages:
-- this.iColumn == 0   -> general game options
-- this.iColumn == 1   -> [reserved for host options]
-- this.iColumn == 2   -> Edit Playlist button at bottom
-- this.iColumn == 3   -> Launch Game button at bottom
-- this.iColumn == 4   -> Set Password button at bottom (if this.bCanEditPass is true)

-- Tags for the various items in the listboxes. Note: this is what is
-- passed in as the 'Data' parameter to ifs_instant_options_PopulateItem.

function ifs_instant_options_SetOptionGroup(group)

   ifs_io_nexttags = ifs_io_listtags[group]
end

ifs_io_nexttags = nil

ifs_io_listtags = {
   global      = ifs_io_listtags_global,
   host        = ifs_io_listtags_host,
   hero        = ifs_io_listtags_hero,
   conquest    = ifs_io_listtags_conquest,
   ctf         = ifs_io_listtags_ctf,
   elimination = ifs_io_listtags_elimination,
   hunt        = ifs_io_listtags_hunt,
   assault     = ifs_io_listtags_assault,
}

ifs_instant_options_listtags_noheroes = {
    "numbots",
    "aidifficulty",
--    "dm_mult", -- Fix for 5107 - no DM maps anymore - NM 7/21/05
    "con_mult",
    "ctf_score",
    "heroes_onoff",
}

-- Has no hero_unlock_2 field, no respawn_val field
ifs_instant_options_listtags_A = {
    "numbots",
    "aidifficulty",
    "dm_mult",
    "con_mult",
    "ctf_score",
    "heroes_onoff",
    "hero_unlock_1",
    "hero_assign",
    "hero_unlockfor",
    "hero_respawn",
}

-- Has hero_unlock_2 field, no respawn_val field
ifs_instant_options_listtags_B = {
    "numbots",
    "aidifficulty",
    "dm_mult",
    "con_mult",
    "ctf_score",
    "heroes_onoff",
    "hero_unlock_1",
    "hero_unlock_2",
    "hero_assign",
    "hero_unlockfor",
    "hero_respawn",
}

-- Has no hero_unlock_2 field, respawn_val field
ifs_instant_options_listtags_C = {
    "numbots",
    "aidifficulty",
    "dm_mult",
    "con_mult",
    "ctf_score",
    "heroes_onoff",
    "hero_unlock_1",
    "hero_assign",
    "hero_unlockfor",
    "hero_respawn",
    "hero_respawn_val",
}


ifs_instant_options_listtags_all = {
    "numbots",
    "aidifficulty",
    "dm_mult",
    "con_mult",
    "ctf_score",
	"heroes_onoff",
    "hero_unlock_1",
    "hero_unlock_2",
    "hero_assign",
    "hero_unlockfor",
    "hero_respawn",
    "hero_respawn_val",
}


-- Helper function. Given a layout (x,y,width, height), returns a
-- fully-built item.
function ifs_instant_options_CreateItem(layout)
    -- Make a coordinate system pegged to the top-left of where the cursor would go.
    local Temp = NewIFContainer { 
        x = layout.x - 0.5 * layout.width, 
        y = layout.y,
    }

    Temp.textitem = NewIFText { 
        x = 10,
        y = layout.height * -0.5 + 2,
        halign = "left", valign = "vcenter",
        font = ifs_instant_options_layout.FontStr,
        textw = layout.width - 20, texth = layout.height,
        startdelay=math.random()*0.5, nocreatebackground=1, 
    }

    return Temp
end

-- Helper function. For a destination item (previously created w/
-- CreateItem), fills it in with appropriate values given a Tag, which
-- may be nil (==blank it) Note: the Tag is an entry out of
-- ifs_instant_options_listtags.
function ifs_instant_options_PopulateItem(Dest, Tag, bSelected, iColorR, iColorG, iColorB, fAlpha)
    -- Well, no, it's technically not. But, acting like it makes things
    -- more consistent
    local this = ifs_instant_options
    local ShowStr = Tag
    local ShowUStr = nil

    local OnStr = ScriptCB_getlocalizestr("common.on")
    local OffStr = ScriptCB_getlocalizestr("common.off")

    if(Tag == "numbots") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iNumBots)))
    elseif (Tag == "aidifficulty") then
        local EasyStr = ScriptCB_getlocalizestr("ifs.difficulty.easy")
        local MediumStr = ScriptCB_getlocalizestr("ifs.difficulty.medium")
        local HardStr = ScriptCB_getlocalizestr("ifs.difficulty.hard")
        if(this.GamePrefs.iDifficulty==1) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",EasyStr)
        elseif (this.GamePrefs.iDifficulty==2) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",MediumStr)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.difficulty",HardStr)
        end
    elseif (Tag == "dm_mult") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.dm",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iDMMult)))
    elseif(Tag == "con_numbots") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCONNumBots)))
    elseif (Tag == "con_mult") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.reinforcements",
                         ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCONMult)))
    elseif (Tag == "con_timer") then
       local time
       if ( this.GamePrefs.iCONTimer and this.GamePrefs.iCONTimer == 0 ) then
          time = ScriptCB_getlocalizestr("ifs.mp.create.opt.off")
       else
          time = ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCONTimer))
       end
       ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.timer", time)
    elseif(Tag == "ctf_numbots") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCTFNumBots)))
    elseif (Tag == "ctf_score") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.ctf",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCTFScore)))
    elseif (Tag == "ctf_timer") then
       local time
       if ( this.GamePrefs.iCTFTimer == 0 ) then
          time = ScriptCB_getlocalizestr("ifs.mp.create.opt.off")
       else
          time = ScriptCB_tounicode(string.format("%d",this.GamePrefs.iCTFTimer))
       end
       ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.timer", time)
    elseif(Tag == "eli_numbots") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iELINumBots)))
    elseif (Tag == "eli_mult") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.reinforcements",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iELIMult)))
    elseif (Tag == "eli_timer") then
       local time
       if ( this.GamePrefs.iELITimer == 0 ) then
          time = ScriptCB_getlocalizestr("ifs.mp.create.opt.off")
       else
          time = ScriptCB_tounicode(string.format("%d",this.GamePrefs.iELITimer))
       end
       ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.timer", time)
    elseif (Tag == "hun_timer") then
       local time
       if ( this.GamePrefs.iHUNTimer == 0 ) then
          time = ScriptCB_getlocalizestr("ifs.mp.create.opt.off")
       else
          time = ScriptCB_tounicode(string.format("%d",this.GamePrefs.iHUNTimer))
       end
       ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.timer", time)
	elseif (Tag == "hun_score") then
	   ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.scorelimit", 
					ScriptCB_tounicode(string.format("%d", this.GamePrefs.iHUNTScoreLimit)))		--TODO: LOCALIZE THIS CRAPOLA!!!!!!Q!
    elseif(Tag == "ass_numbots") then
       ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iASSNumBots)))
	elseif(Tag == "ass_score") then
		ShowUStr = ScriptCB_usprintf("ifs.mp.create.opt.scorelimit",
                    ScriptCB_tounicode(string.format("%d",this.GamePrefs.iASSScoreLimit)))
    elseif (Tag == "heroes_onoff") then
        if(this.GamePrefs.bHeroesEnabled) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.heroes",
                                                                     ScriptCB_getlocalizestr("common.on"))
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.heroes",
                                                                     ScriptCB_getlocalizestr("common.off"))
        end
        --          IFText_fnSetString(Dest.textitem,"")
    elseif (Tag == "hero_unlock_1") then
       if ( this.GamePrefs.bHeroesEnabled ) then
          if(this.HeroPrefs.iHeroUnlock == 1) then
         ShowStr = "ifs.mp.heroopts.herounlock1"
         --              this.buttons.herounlockval.hidden = 1
          elseif (this.HeroPrefs.iHeroUnlock == 2) then
         ShowStr = "ifs.mp.heroopts.herounlock2"
          elseif (this.HeroPrefs.iHeroUnlock == 3) then
         ShowStr = "ifs.mp.heroopts.herounlock3"
          elseif (this.HeroPrefs.iHeroUnlock == 4) then
         ShowStr = "ifs.mp.heroopts.herounlock4"
          elseif (this.HeroPrefs.iHeroUnlock == 5) then
         ShowStr = "ifs.mp.heroopts.herounlock5"
          elseif (this.HeroPrefs.iHeroUnlock == 6) then
         ShowStr = "ifs.mp.heroopts.herounlock6"
          end
       else
          ShowStr = ""
       end
    elseif (Tag == "hero_unlock_2") then
       if ( this.GamePrefs.bHeroesEnabled ) then
          if(this.HeroPrefs.iHeroUnlock == 1) then
         ShowStr = ""
          elseif (this.HeroPrefs.iHeroUnlock == 2) then
         ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.reinforcements",
                          ScriptCB_tounicode(string.format("%d",this.HeroPrefs.iHeroUnlockVal)))
          elseif (this.HeroPrefs.iHeroUnlock == 3) then
         ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.numpoints",
                          ScriptCB_tounicode(string.format("%d",this.HeroPrefs.iHeroUnlockVal)))
          elseif (this.HeroPrefs.iHeroUnlock == 4) then
         ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.numkills",
                          ScriptCB_tounicode(string.format("%d",this.HeroPrefs.iHeroUnlockVal)))
          elseif (this.HeroPrefs.iHeroUnlock == 5) then
         ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.numseconds",
                          ScriptCB_tounicode(string.format("%d",this.HeroPrefs.iHeroUnlockVal)))
          elseif (this.HeroPrefs.iHeroUnlock == 6) then
         ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.numcaptures",
                          ScriptCB_tounicode(string.format("%d",this.HeroPrefs.iHeroUnlockVal)))
          end
       else
          ShowStr = ""
       end
    elseif (Tag == "hero_assign") then
       if ( this.GamePrefs.bHeroesEnabled ) then
          if(this.HeroPrefs.iHeroPlayer == 1) then
         ShowStr = "ifs.mp.heroopts.heroplayer1"
          elseif (this.HeroPrefs.iHeroPlayer == 2) then
         ShowStr = "ifs.mp.heroopts.heroplayer2"
          elseif (this.HeroPrefs.iHeroPlayer == 3) then
         ShowStr = "ifs.mp.heroopts.heroplayer3"
          elseif (this.HeroPrefs.iHeroPlayer == 4) then
         ShowStr = "ifs.mp.heroopts.heroplayer4"
          elseif (this.HeroPrefs.iHeroPlayer == 5) then
         ShowStr = "ifs.mp.heroopts.heroplayer5"
          elseif (this.HeroPrefs.iHeroPlayer == 6) then
         ShowStr = "ifs.mp.heroopts.heroplayer6"
          elseif (this.HeroPrefs.iHeroPlayer == 7) then
         ShowStr = "ifs.mp.heroopts.heroplayer7"
          elseif (this.HeroPrefs.iHeroPlayer == 8) then
         ShowStr = "ifs.mp.heroopts.heroplayer8"
          end
       else
          ShowStr = ""
       end
    elseif (Tag == "hero_unlockfor") then
        if(this.HeroPrefs.iHeroTeam == 1) then
            ShowStr = "ifs.mp.heroopts.heroteam1"
        elseif (this.HeroPrefs.iHeroTeam == 2) then
            ShowStr = "ifs.mp.heroopts.heroteam2"
        elseif (this.HeroPrefs.iHeroTeam == 3) then
            ShowStr = "ifs.mp.heroopts.heroteam3"
        elseif (this.HeroPrefs.iHeroTeam == 4) then
            ShowStr = "ifs.mp.heroopts.heroteam4"
        end
    elseif (Tag == "hero_respawn") then
        if(this.HeroPrefs.iHeroRespawn == 1) then
            ShowStr = "ifs.mp.heroopts.herorespawn1"
        elseif (this.HeroPrefs.iHeroRespawn == 2) then
            ShowStr = "ifs.mp.heroopts.herorespawn2"
        end
    elseif (Tag == "hero_respawn_val") then
       if ( this.GamePrefs.bHeroesEnabled ) then
	  local timer = this.HeroPrefs.iHeroRespawnVal

	  local value
	  if ( timer < 0 ) then
	     value = ScriptCB_getlocalizestr("common.never")
	  elseif ( timer == 0 ) then
	     value = ScriptCB_getlocalizestr("common.always")
	  else
	     value = ScriptCB_tounicode( string.format("%d", timer) )
	  end

	  local unit
	  if ( timer < 1 ) then
	     unit = ScriptCB_tounicode("")
	  elseif ( timer == 1 ) then
	     unit = ScriptCB_getlocalizestr("ifs.mp.heroopts.second")
	  else
	     unit = ScriptCB_getlocalizestr("ifs.mp.heroopts.seconds")
	  end
	  
          ShowUStr = ScriptCB_usprintf("ifs.mp.heroopts.respawntimer", value, unit)
       else
          ShowStr = ""
       end

        -- Host options tags
    elseif (Tag == "playlistorder") then
       local order
       if ( ifs_missionselect_GetPlayListOrder() ) then
          order = ScriptCB_getlocalizestr("ifs.missionselect.random")
       else
          order = ScriptCB_getlocalizestr("ifs.missionselect.inorder")
       end
       ShowUStr = ScriptCB_usprintf( "ifs.missionselect.playlistorder", order )
       print("ifs_instant_options: ", order, " ", ShowUStr )
    elseif (Tag == "dedicated") then
        if(this.bDedicated) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.dedicated",OnStr)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.dedicated",OffStr)
        end
    elseif (Tag == "players") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.maxplayers",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iNumPlayers)))
    elseif (Tag == "warmup") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.warmup",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iWarmUp)))
    elseif (Tag == "vote") then
        if( this.GamePrefs.iVote == 0 ) then
            ShowStr = "ifs.mp.createopts.vote0"
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.vote",
                                                                     ScriptCB_tounicode(string.format("%d",this.GamePrefs.iVote)))
        end
    elseif (Tag == "bots") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.numbots",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iNumBots)))
    elseif (Tag == "teamdmg") then

       if(this.GamePrefs.iTeamDmg < 1) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage",OffStr)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.teamdamage",OnStr)
        end
    elseif (Tag == "autoaim") then
        if(this.GamePrefs.iAutoAim < 1) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim",OffStr)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.autoaim",OnStr)
        end
    elseif (Tag == "shownames") then
        if(this.GamePrefs.bShowNames) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.shownames",OnStr)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.shownames",OffStr)
        end
    elseif (Tag == "autoassign") then
        if(this.GamePrefs.bAutoAssignTeams) then
            ShowStr = "ifs.mp.createopts.autoassign_on"
        else
            ShowStr = "ifs.mp.createopts.autoassign_off"
        end
    elseif (Tag == "startcnt") then
        ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.startcnt",
                                                                 ScriptCB_tounicode(string.format("%d",this.GamePrefs.iStartCnt)))
    elseif (Tag == "voicemode") then
        local disabled    = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.disabled")
        local peerToPeer  = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.peertopeer")
        local peerRelay   = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.peerrelay")
        local serverRelay = ScriptCB_getlocalizestr("ifs.mp.voicechat.mode.serverrelay")
        if     (this.GamePrefs.iVoiceMode == 1) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", disabled)
        elseif (this.GamePrefs.iVoiceMode == 2) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", peerToPeer)
        elseif (this.GamePrefs.iVoiceMode == 3) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", peerRelay)
        elseif (this.GamePrefs.iVoiceMode == 4) then
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", serverRelay)
        else
            ShowUStr = ScriptCB_usprintf("ifs.mp.createopts.voicemode", "Invalid!")
        end
    elseif (Tag == "pubpriv") then
        if(this.GamePrefs.bIsPrivate) then
            ShowStr = "ifs.mp.createopts.pubpriv_priv"
        else
            ShowStr = "ifs.mp.createopts.pubpriv_pub"
        end
    elseif (not Tag) then
        ShowStr = "" -- reduce glyphcache usage
    else
        IFText_fnSetString(Dest.textitem,Tag)
    end

    if (ShowUStr) then
        IFText_fnSetUString(Dest.textitem,ShowUStr)
    elseif (ShowStr) then
        IFText_fnSetString(Dest.textitem,ShowStr)
    end

    if ( Tag ) then
       IFObj_fnSetColor(Dest.textitem, iColorR, iColorG, iColorB)
       IFObj_fnSetAlpha(Dest.textitem, fAlpha)
    end

    IFObj_fnSetVis(Dest.textitem,Tag)
end

ifs_instant_options_layout = {
    showcount = 10,
--  yTop = -130 + 13, -- auto-calc'd now
    yHeight = 20,
    ySpacing  = 0,
--  width = 260,
    x = 0,
    slider = 1,
    CreateFn = ifs_instant_options_CreateItem,
    PopulateFn = ifs_instant_options_PopulateItem,
}

-- Callback function from VK - returns 2 values, whether the current
-- string is allowed to be entered, and a localize database key string
-- as to why it's not acceptable.
function ifs_instant_options_fnIsAcceptable()
    --  print("ifs_mp_gameopts_fnIsAcceptable()")
    return 1,""
end

-- Callback function when the virtual keyboard is done
function ifs_instant_options_fnKeyboardDone()
    --  print("ifs_mp_gameopts_fnKeyboardDone()")
    local this = ifs_instant_options
    this.GamePrefs.PasswordStr = ScriptCB_ununicode(ifs_vkeyboard.CurString)
    ScriptCB_PopScreen()
    --  vkeyboard_specs.fnDone = nil -- clear our registration there
end

-- Clamps a value between a min & max value. Returns the updated value
function Clamp(Val, Min, Max)
    if(Val < Min) then
        return Min
    elseif (Val > Max) then
        return Max
    else
        return Val -- value is sane
    end
end



-- Adjusts one item (specified in the Tag) by the specified Adjust value.
-- iAdjust will be < 0 if going left, > 0 if going right. +1/-1 if going
-- a short distance, +10/-10 if going a big distance
function ifs_instant_options_fnAdjustItem(this, Tag, iAdjust)
--  print("ifs_instant_options_fnAdjustItem, tag = ", Tag)

    if(Tag == "numbots") then
        this.GamePrefs.iNumBots = Clamp(this.GamePrefs.iNumBots + iAdjust, 0, this.GamePrefs.iMaxBots)
    if ( iAdjust ~= 0 ) then
       this.GamePrefs.iCONNumBots = this.GamePrefs.iNumBots
       this.GamePrefs.iCTFNumBots = this.GamePrefs.iNumBots
       this.GamePrefs.iELINumBots = this.GamePrefs.iNumBots
       this.GamePrefs.iASSNumBots = this.GamePrefs.iNumBots
    end
    elseif (Tag == "aidifficulty") then
        -- Toggle between 2 & 3 for now.
        this.GamePrefs.iDifficulty = 5 - this.GamePrefs.iDifficulty
--        print("Diff "..this.GamePrefs.iDifficulty)
--      this.GamePrefs.iDifficulty = Clamp(this.GamePrefs.iDifficulty + iAdjust, 2, 3)
    elseif (Tag == "dm_mult") then
        this.GamePrefs.iDMMult = Clamp(this.GamePrefs.iDMMult + 5 * iAdjust, 10, 1000)
    elseif(Tag == "con_numbots") then
        this.GamePrefs.iCONNumBots = Clamp(this.GamePrefs.iCONNumBots + iAdjust, 0, this.GamePrefs.iMaxBots)
    elseif (Tag == "con_mult") then
        this.GamePrefs.iCONMult = Clamp(this.GamePrefs.iCONMult + 10 * iAdjust, 10, 500)
    elseif (Tag == "con_timer") then
        this.GamePrefs.iCONTimer = Clamp(this.GamePrefs.iCONTimer + 5 * iAdjust, 0, 60)
    elseif(Tag == "ctf_numbots") then
        this.GamePrefs.iCTFNumBots = Clamp(this.GamePrefs.iCTFNumBots + iAdjust, 0, this.GamePrefs.iMaxBots)
    elseif (Tag == "ctf_score") then
        this.GamePrefs.iCTFScore = Clamp(this.GamePrefs.iCTFScore + iAdjust, 1, 15)
    elseif (Tag == "ctf_timer") then
        this.GamePrefs.iCTFTimer = Clamp(this.GamePrefs.iCTFTimer + 5 * iAdjust, 0, 60)
    elseif(Tag == "eli_numbots") then
        this.GamePrefs.iELINumBots = Clamp(this.GamePrefs.iELINumBots + iAdjust, 0, this.GamePrefs.iMaxBots)
    elseif (Tag == "eli_mult") then
        this.GamePrefs.iELIMult = Clamp(this.GamePrefs.iELIMult + 10 * iAdjust, 10, 500)
    elseif (Tag == "eli_timer") then
        this.GamePrefs.iELITimer = Clamp(this.GamePrefs.iELITimer + 5 * iAdjust, 0, 60)
    elseif (Tag == "hun_timer") then
        this.GamePrefs.iHUNTimer = Clamp(this.GamePrefs.iHUNTimer + 5 * iAdjust, 5, 60)
	elseif (Tag == "hun_score") then
		this.GamePrefs.iHUNTScoreLimit = Clamp(this.GamePrefs.iHUNTScoreLimit + 10 * iAdjust, 10, 100000)
    elseif(Tag == "ass_numbots") then
        this.GamePrefs.iASSNumBots = Clamp(this.GamePrefs.iASSNumBots + iAdjust, 0, this.GamePrefs.iMaxBots)
	elseif(Tag == "ass_score") then
		this.GamePrefs.iASSScoreLimit = Clamp(this.GamePrefs.iASSScoreLimit + 10*iAdjust, 50, 100000)
    elseif (Tag == "heroes_onoff") then
        this.GamePrefs.bHeroesEnabled = not this.GamePrefs.bHeroesEnabled
    elseif (Tag == "hero_unlock_1") then
       if ( this.HeroPrefs.iHeroUnlock == 3 ) then
      this.HeroPrefs.iHeroUnlock = 5
       else
      this.HeroPrefs.iHeroUnlock = 3
       end
    elseif (Tag == "hero_unlock_2") then
        this.HeroPrefs.iHeroUnlockVal = Clamp(this.HeroPrefs.iHeroUnlockVal + iAdjust, 1, 120)
    elseif (Tag == "hero_assign") then
       if ( this.HeroPrefs.iHeroPlayer == 1 ) then
      if ( iAdjust > 0 ) then
         this.HeroPrefs.iHeroPlayer = 4
      end
       elseif (this.HeroPrefs.iHeroPlayer == 4 ) then
      if ( iAdjust > 0 ) then
         this.HeroPrefs.iHeroPlayer = 7
      else
         this.HeroPrefs.iHeroPlayer = 1
      end
       else
      if ( iAdjust < 0 ) then
         this.HeroPrefs.iHeroPlayer = 4
      end
       end       
    elseif (Tag == "hero_unlockfor") then
        this.HeroPrefs.iHeroTeam = Clamp(this.HeroPrefs.iHeroTeam + iAdjust, 1, 4)
    elseif (Tag == "hero_respawn") then
        -- toggle values between 1 and 2
        this.HeroPrefs.iHeroRespawn = 3 - this.HeroPrefs.iHeroRespawn
    elseif (Tag == "hero_respawn_val") then
       --we want this to range from 0,1,2,...,119,120,-1
       local value = this.HeroPrefs.iHeroRespawnVal
       if ( value == -1 ) then
	  value = 121
       end

       value = Clamp(value + iAdjust, 10, 121)

       if ( value == 121 ) then
	  this.HeroPrefs.iHeroRespawnVal = -1
       else
	  this.HeroPrefs.iHeroRespawnVal = value
       end

	  -- Host options tags
    elseif (Tag == "playlistorder") then
	   ifs_missionselect_TogglePlaylistOrder()
    elseif (Tag == "dedicated") then
        this.bDedicated = not this.bDedicated
        -- refresh dependent items
        ifs_instant_options_fnAdjustItem(this, "players", 0)
        ifs_instant_options_fnAdjustItem(this, "numbots", 0)
        ifs_instant_options_fnAdjustItem(this, "voicemode", 0)
    elseif (Tag == "players") then
        if (this.bDedicated) then
            this.GamePrefs.iNumPlayers = Clamp(this.GamePrefs.iNumPlayers + iAdjust, this.iMinPlayers, this.GamePrefs.iMaxDedicatedPlayers)
        else
            this.GamePrefs.iNumPlayers = Clamp(this.GamePrefs.iNumPlayers + iAdjust, this.iMinPlayers, this.GamePrefs.iMaxPlayers)
        end

        -- Also ensure this is clamped
        this.GamePrefs.iStartCnt = Clamp(this.GamePrefs.iStartCnt, 0, this.GamePrefs.iNumPlayers)
    elseif (Tag == "warmup") then
        this.GamePrefs.iWarmUp = Clamp(this.GamePrefs.iWarmUp + 5 * iAdjust, this.GamePrefs.iWarmUpMin,this.GamePrefs.iWarmUpMax)
    elseif (Tag == "vote") then
        this.GamePrefs.iVote = Clamp(this.GamePrefs.iVote + 5 * iAdjust, this.GamePrefs.iVoteMin, this.GamePrefs.iVoteMax)
--  elseif (Tag == "bots") then
    elseif (Tag == "teamdmg") then
        this.GamePrefs.iTeamDmg = 100 - this.GamePrefs.iTeamDmg
    elseif (Tag == "autoaim") then
        this.GamePrefs.iAutoAim = 100 - this.GamePrefs.iAutoAim
    elseif (Tag == "shownames") then
        this.GamePrefs.bShowNames = not this.GamePrefs.bShowNames
--  elseif (Tag == "hero") then
    elseif (Tag == "autoassign") then
        this.GamePrefs.bAutoAssignTeams = not this.GamePrefs.bAutoAssignTeams
--  elseif (Tag == "difficulty") then
    elseif (Tag == "startcnt") then
        this.GamePrefs.iStartCnt = Clamp(this.GamePrefs.iStartCnt + iAdjust, 0, this.GamePrefs.iNumPlayers)
    elseif (Tag == "voicemode") then
        local modeMax
        if (this.bDedicated) then
            modeMax = this.GamePrefs.iVoiceModeDedicatedMax
        else
            modeMax = this.GamePrefs.iVoiceModeMax
        end
        this.GamePrefs.iVoiceMode = Clamp(this.GamePrefs.iVoiceMode + iAdjust, 
            this.GamePrefs.iVoiceModeMin, modeMax)
    elseif (Tag == "pubpriv") then
        this.GamePrefs.bIsPrivate = not this.GamePrefs.bIsPrivate
    end
end

-- Fills the helptext box with info based on what is currently selected
function ifs_instant_options_fnSetHelptext(this)


    local CurTag = this.CurTags[ifs_instant_options_layout.SelectedIdx]
    if ( CurTag ) then
       local NewKey = string.format("ifs.mp.createopts.helptext.%s", CurTag)
       IFText_fnSetString(this.InfoboxBot.Text,NewKey)
    end
end

-- Shows one of a set of listboxes depending on various heroes options
function ifs_instant_options_fnSetListboxContents(this)
    local NewTags

--     if (this.iColumn == 0) then
--         -- Game options listbox
--         if(not this.GamePrefs.bHeroesEnabled) then
--             NewTags = ifs_instant_options_listtags_noheroes
--         else
--             if((this.HeroPrefs.iHeroUnlock == 1) and (this.HeroPrefs.iHeroRespawn == 1)) then
--                 -- No unlock val, no hero val
--                 NewTags = ifs_instant_options_listtags_A
--             elseif ((this.HeroPrefs.iHeroUnlock ~= 1) and (this.HeroPrefs.iHeroRespawn == 1)) then
--                 -- Yes unlock val, no hero val
--                 NewTags = ifs_instant_options_listtags_B
--             elseif ((this.HeroPrefs.iHeroUnlock == 1) and (this.HeroPrefs.iHeroRespawn ~= 1)) then
--                 -- No unlock val, yes hero val
--                 NewTags = ifs_instant_options_listtags_C
--             else
--                 NewTags = ifs_instant_options_listtags_all
--             end
--         end
--     elseif (this.iColumn == 1) then
--         if(gOnlineServiceStr == "LAN") then
--             NewTags =   ifs_instant_options_listtags_host_LAN 
--         else
--             NewTags =   ifs_instant_options_listtags_host 
--         end
--     end

   if ( ifs_io_nexttags == ifs_io_listtags_hero and not this.GamePrefs.bHeroesEnabled ) then
      NewTags = ifs_io_listtags_hero_no_heroes.tags
--   elseif ( ifs_io_nexttags == ifs_io_listtags_host and gOnlineServiceStr == "XLive" ) then
--      NewTags = ifs_io_listtags_host_xlive.tags
   else
      NewTags = ifs_io_nexttags.tags
   end

    local bListboxChanged
    if(NewTags and (this.CurTags ~= NewTags)) then
        -- Bit of a UI hack -- if we're changing the list, and we were on the last
        -- item, try and re-center it so that people see what just got
        -- added. Listmanager will clamp us to valid values if this pushes it
        -- out of bounds
        if(ifs_instant_options_layout.SelectedIdx >=
             (ifs_instant_options_layout.FirstShownIdx + ifs_instant_options_layout.showcount - 2)) then
            ifs_instant_options_layout.FirstShownIdx = ifs_instant_options_layout.FirstShownIdx
                +   math.floor(ifs_instant_options_layout.showcount * 0.5)          
        end

        this.CurTags = NewTags
        bListboxChanged = 1
    end

    IFText_fnSetString(this.listbox.titleBarElement, ifs_io_nexttags.title)
    assert(NewTags)
    ifs_instant_options_layout.CursorIdx = ifs_instant_options_layout.SelectedIdx
    ListManager_fnFillContents(this.listbox,NewTags,ifs_instant_options_layout)
    ListManager_fnSetFocus(this.listbox)

	if (bListboxChanged) then 
		ifs_instant_options_fnSetHelptext(this)
	end 

end


ifs_instant_options = NewIFShellScreen {
--	bg_texture = option_bg_texture,
--  movieIntro      = nil,
--  movieBackground = nil,
    music           = "shell_soundtrack",
    

    Helptext_Defaults = NewHelptext {
      ScreenRelativeX = 1.0,
      ScreenRelativeY = 1.0,
      y = -5,
      x = 0,
      bRightJustify = 1,
      buttonicon = "btnmisc",
      string = "ifs.mp.create.reset",
   },
   Helptext_Password = NewHelptext {
      ScreenRelativeX = 1.0,
      ScreenRelativeY = 1.0,
      y = -5,
      x = 0,
      bRightJustify = 1,
      buttonicon = "btnmisc",
      string = "ifs.mp.createopts.setpassword",
   },
   
   DefaultHeroPrefs = nil,
   DefaultGamePrefs = nil,


    -- On entry, fill the strings with items
    Enter = function(this, bFwd)
    
    
		-- clear help text
    
        gIFShellScreenTemplate_fnEnter(this, bFwd)
        gHelptext_fnMoveIcon(this.Helptext_Defaults)
		


        gHelptext_fnMoveIcon(this.Helptext_Password)
		
        if(bFwd) then
            this.iColumn = 0
            this.iLastColumn = 0
        end

		this.GamePrefs =  this.GamePrefs or  { }
		local r2 = this.GamePrefs.PasswordStr
		
		this:set_defaults()




        local w,h = ScriptCB_GetSafeScreenInfo()
        -- Determine if we support passwords, then use that to reposition bottom
        -- buttons
        if(ifs_missionselect.bForMP) then
			this.bCanEditPass = ((ScriptCB_GetOnlineService() == "GameSpy") )
        else
            this.bCanEditPass = nil -- SP can never set passwords. Unless you're REALLY paranoid.
        end

--      if(this.bCanEditPass) then
--          IFObj_fnSetPos(this.PlaylistContainer, w * 1 / 6)
--          IFObj_fnSetPos(this.LaunchContainer, w * 3/6)
--          IFObj_fnSetPos(this.PasswordContainer, w * 5/6)
--      else
--          IFObj_fnSetPos(this.PlaylistContainer, w * 0.33333)
--          IFObj_fnSetPos(this.LaunchContainer, w * 0.66667)
--          -- PasswordContainer is hidden in SP, no need to reposition.
--      end

        -- And, show/hide some 
		
		IFObj_fnSetVis(this.Helptext_Accept, nil)
		IFObj_fnSetVis(this.Helptext_Defaults, 1)
		IFObj_fnSetVis(this.Helptext_Password, this.bCanEditPass)
    end,

    Input_Back = function(this)
-- 		    this:push_prefs()
		    ScriptCB_SetNetGameDefaults(this.GamePrefs)
		    this.HeroPrefs.iHeroTeam = 3 
			
		    ScriptCB_SetNetHeroDefaults(this.HeroPrefs)
		    ScriptCB_SetDedicated(this.bDedicated)
			
		    ScriptCB_PopScreen()
		 end,

    Input_Misc = function(this)
		if( gPlatformStr == "PSP" ) then 
			this:reset_defaults()
		elseif ( this.bCanEditPass ) then
		   if(this.GamePrefs.PasswordStr) then
			  ifs_vkeyboard.CurString = ScriptCB_tounicode(this.GamePrefs.PasswordStr)
		   else
			  ifs_vkeyboard.CurString = ScriptCB_tounicode("")
		   end

		   ifs_vkeyboard.bCursorOnLetters = 1 -- start cursor in top-left
		   vkeyboard_specs.bPasswordMode = 1

		   IFText_fnSetString(ifs_vkeyboard.title,"ifs.vkeyboard.title_password")
		   vkeyboard_specs.fnDone = ifs_instant_options_fnKeyboardDone
		   vkeyboard_specs.fnIsOk = ifs_instant_options_fnIsAcceptable
		   
		   local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
		   vkeyboard_specs.MaxWidth = (w * 0.5)
		   vkeyboard_specs.MaxLen = 16
		   ifs_movietrans_PushScreen(ifs_vkeyboard)
		end
	 end,
	 
    Input_Misc2 = function(this)
		if( gPlatformStr ~= "PSP") then 
			this:reset_defaults()
		end 
	 end,

    Input_GeneralUp = function(this)
		local CurListbox = ListManager_fnGetFocus()
		if(CurListbox) then
			ListManager_fnNavUp(CurListbox)
			ifs_instant_options_fnSetHelptext(this)
		end
    end,

    Input_GeneralDown = function(this)
	   local CurListbox = ListManager_fnGetFocus()
	   if(CurListbox) then
		  ListManager_fnNavDown(CurListbox)
		  ifs_instant_options_fnSetHelptext(this)
	   end
	end,

    Input_GeneralLeft = function(this)
	   local CurItem = this.CurTags[ifs_instant_options_layout.SelectedIdx]
	   ifs_instant_options_fnAdjustItem(this, CurItem, -1)
	   ifs_instant_options_fnSetListboxContents(this)
	   ifelm_shellscreen_fnPlaySound("shell_select_change")
	end,

    Input_GeneralRight = function(this)
		local CurItem = this.CurTags[ifs_instant_options_layout.SelectedIdx]
		ifs_instant_options_fnAdjustItem(this, CurItem, 1)
		ifs_instant_options_fnSetListboxContents(this)
		ifelm_shellscreen_fnPlaySound("shell_select_change")
	end,

    Input_LTrigger = function(this)
            local CurItem = this.CurTags[ifs_instant_options_layout.SelectedIdx]
			ifs_instant_options_fnAdjustItem(this, CurItem, -10)
            ifs_instant_options_fnSetListboxContents(this)
            ifelm_shellscreen_fnPlaySound("shell_select_change")
             end,

    Input_RTrigger = function(this)
            local CurItem = this.CurTags[ifs_instant_options_layout.SelectedIdx]
			ifs_instant_options_fnAdjustItem(this, CurItem, 10)
            ifs_instant_options_fnSetListboxContents(this)
            ifelm_shellscreen_fnPlaySound("shell_select_change")
             end,

    Update = function(this, fDt)
        -- Call base class functionality
        gIFShellScreenTemplate_fnUpdate(this, fDt)
        

    end,


    set_defaults = function(this)
		-- Read all the params as a table now - NM 5/2/05
		this.HeroPrefs = ScriptCB_GetNetHeroDefaults()
		this.GamePrefs = this.GamePrefs or {}
		-- GetNetGameDefaults loses passwordstr, so cache value.
		local EntryPass = this.GamePrefs.PasswordStr
		this.GamePrefs = ScriptCB_GetNetGameDefaults()
		
		this.GamePrefs.PasswordStr = EntryPass
		this.GamePrefs.PasswordStr = EntryPass

		this.iMinPlayers = math.max(2, ScriptCB_GetNumCameras()) -- cache this
		this.GamePrefs.iWarmUpMax = 120
		this.GamePrefs.iWarmUpMin = 0
		this.GamePrefs.iVoteMax = 75
		this.GamePrefs.iVoteMin = 0

		if(not this.bEverEntered) then
			this.bEverEntered = 1
			this.GamePrefs.bIsPrivate = nil 
			this.EntryDedicated = this.bDedicated 
			this.GamePrefs.iNumBots = math.min(this.GamePrefs.iNumBots, this.GamePrefs.iMaxBots)
			
			this.GamePrefs.iNumPlayers = this.GamePrefs.iMaxPlayers
			
			this.GamePrefs.iNumPlayers = math.max(this.GamePrefs.iNumPlayers, this.iMinPlayers)
			this.GamePrefs.PasswordStr = nil -- none
		end


		this.GamePrefs.iDMMult = this.GamePrefs.iDMMult or 100
		this.GamePrefs.iCONNumBots = this.GamePrefs.iCONNumBots or this.GamePrefs.iNumBots
		this.GamePrefs.iCONMult = this.GamePrefs.iCONMult or 100
		this.GamePrefs.iCONTimer = this.GamePrefs.iCONTimer or 60
		this.GamePrefs.iCTFNumBots = this.GamePrefs.iCTFNumBots or this.GamePrefs.iNumBots
		this.GamePrefs.iCTFScore = this.GamePrefs.iCTFScore or 5
		this.GamePrefs.iCTFTimer = this.GamePrefs.iCTFTimer or 60
		this.GamePrefs.iELINumBots = this.GamePrefs.iELINumBots or this.GamePrefs.iNumBots
		this.GamePrefs.iELIMult = this.GamePrefs.iELIMult or 100
		this.GamePrefs.iELITimer = this.GamePrefs.iELITimer or 60
		this.GamePrefs.iHUNTimer = this.GamePrefs.iHUNTimer or 5
		this.GamePrefs.iHUNTScoreLimit = this.GamePrefs.iHUNTScoreLimit or 50
		this.GamePrefs.iASSNumBots = this.GamePrefs.iASSNumBots or this.GamePrefs.iNumBots

		--this.GamePrefs.iASSScoreLimit = this.GamePrefs.iASSScoreLimit or 180
		
		-- this part is a bit off 
		--this.DefaultGamePrefs = this.DefaultGamePrefs or ifs_ia_table_shallow_copy(this.GamePrefs)
		--this.DefaultHeroPrefs = this.DefaultHeroPrefs or ifs_ia_table_shallow_copy(this.HeroPrefs)
		if(not this.DefaultGamePrefs) then this.DefaultGamePrefs = ifs_ia_table_shallow_copy(this.GamePrefs) end 
		if(not this.DefaultHeroPrefs ) then this.DefaultHeroPrefs = ifs_ia_table_shallow_copy(this.HeroPrefs) end 
		--
		
		ifs_instant_options_fnSetListboxContents(this)

   end,
		   

	reset_defaults = function(this) 
		ifs_missionselect_SetPlaylistOrderDefault()
		this.HeroPrefs = ifs_ia_table_shallow_copy(this.DefaultHeroPrefs)
		this.GamePrefs =  ifs_ia_table_shallow_copy(this.DefaultGamePrefs)
		ifs_instant_options_fnSetListboxContents(this)
	end 
 }



function ifs_ia_table_shallow_copy( tab  )
	dst = {}
	for prop, val in pairs(tab) do 
		dst[prop] = val
	end 
	return dst 
end 


function ifs_instant_options_fnBuildScreen( this ) 
    if(gPlatformStr == "PC") then

    end

    local w,h = ScriptCB_GetSafeScreenInfo()

    -- Don't use all of the screen for the listbox
--     local BottomIconsHeight = 64
    local BotBoxHeight = 65
    local YPadding = 90 -- amount of space to reserve for titlebar, helptext, whitespace, etc

	if( gPlatformStr == "PSP" ) then 
		this.listboxfont = "gamefont_tiny"
		BotBoxHeight = (ScriptCB_GetFontHeight(this.listboxfont) + 2) * 3 + 5
		YPadding = 65 
	end 
	
	h = (h - BotBoxHeight) - YPadding
	
	if( gPlatformStr == "PSP" ) then 
		ifs_instant_options_layout.FontStr = "gamefont_tiny"
	else 
		ifs_instant_options_layout.FontStr = "gamefont_small"
	end 
    -- Get usable screen area for listbox

    -- Calc height of listbox row, use that to figure out how many rows will fit.
    ifs_instant_options_layout.iFontHeight = ScriptCB_GetFontHeight(ifs_instant_options_layout.FontStr)
    ifs_instant_options_layout.yHeight = 2 * (ifs_instant_options_layout.iFontHeight + 2)

    local RowHeight = ifs_instant_options_layout.yHeight + ifs_instant_options_layout.ySpacing
    ifs_instant_options_layout.showcount = math.floor(h / RowHeight)

    local listWidth = w * 0.85
    local ListboxHeight = ifs_instant_options_layout.showcount * RowHeight + 30
	
    this.listbox = NewButtonWindow { 
        ZPos = 200, 
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0  , -- top
        y = ListboxHeight * 0.5 + 30,
        width = listWidth,
        height = ListboxHeight,
        titleText = "common.mp.options"
    }
    ifs_instant_options_layout.width = listWidth - 40
    ifs_instant_options_layout.x = 0

    ListManager_fnInitList(this.listbox,ifs_instant_options_layout)


    this.InfoboxBot = NewIFContainer { 
        ScreenRelativeX = 0, -- left side of screen
        ScreenRelativeY = 0, -- top
        x = 0,
        y = ListboxHeight + (BotBoxHeight * 0.5) + 5, -- Below listbox

        bg = NewIFImage {
            ZPos = 240,
            localpos_l = 4,
            localpos_r = w - 8,
            localpos_b = BotBoxHeight,
            texture = "white_rect",
            ColorR = 128,
            ColorG = 128,
            ColorB = 128,
            alpha = 0.5,
        },

        Text = NewIFText { 
            x = 10, 
            y = BotBoxHeight * 0.25 - 10,
            halign = "left", valign = "top",
            font = this.listboxfont, 
            textw = w - 20,  
            texth = BotBoxHeight,
            startdelay=math.random()*0.5, nocreatebackground=1, 
        },
    }

--     this.PlaylistContainer = NewIconButton { 
--         ScreenRelativeX = 0, -- left side of screen (repositioned on this:Enter())
--         ScreenRelativeY = 0, -- top
--         x = 0,
--         y = ListboxHeight + BotBoxHeight + 40 + (BottomIconsHeight * 0.5), -- Below main listboxes
--         texture = "mapselect_icon_sessionoptions",
--         textw = w * 0.333 - 10,
--         font = "gamefont_medium",
--         string = "ifs.onlinelobby.editplaylist",
--     }

--     this.LaunchContainer = NewIconButton { 
--         ScreenRelativeX = 0, -- left side of screen (repositioned on this:Enter())
--         ScreenRelativeY = 0, -- top
--         x = 0,
--         y = ListboxHeight + BotBoxHeight + 40 + (BottomIconsHeight * 0.5), -- Below main listboxes
--         texture = "mapselect_icon_launch",
--         textw = w * 0.3333 - 10,
--         font = "gamefont_medium",
--         string = "ifs.onlinelobby.launch",
--     }

--     this.PasswordContainer = NewIconButton { 
--         ScreenRelativeX = 0, -- left side of screen (repositioned on this:Enter())
--         ScreenRelativeY = 0, -- top
--         x = 0,
--         y = ListboxHeight + BotBoxHeight + 40 + (BottomIconsHeight * 0.5), -- Below main listboxes
--         texture = "mapselect_icon_launch",
--         textw = w * 0.3333 - 10,
--         font = "gamefont_medium",
--         string = "ifs.mp.createopts.setpassword",
--     }

	-- need default values to get min/max

end

ifs_instant_options_fnBuildScreen( ifs_instant_options )
ifs_instant_options_fnBuildScreen = nil

AddIFScreen(ifs_instant_options,"ifs_instant_options")

