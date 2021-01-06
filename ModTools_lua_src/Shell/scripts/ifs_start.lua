--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_start = NewIFShellScreen {
    -- # of seconds before we go into demomode. XBox TCR C1-6 says
    -- this must be no larger than 120 seconds. 
    Demomode_Delay_DEFAULT_XBOX = 100,
    -- PS2 wants a 30-second timeout. BF2 bug 3951 - NM 7/6/05
    Demomode_Delay_DEFAULT_PS2 = 30,

    -- Current value for the delay. This is reset to Demomode_Delay_DEFAULT on
    -- screen entry, and when it hits zero, it launches
    Demomode_Delay = 10, -- Stub value, replaced in :Enter()
 

    movieIntro      = nil,         -- played before the screen is displayed
    movieBackground = "shell_main", -- WAS "ifs_start", -- played while the screen is displayed
    music           = "shell_soundtrack",
    enterSound      = "",

    bNohelptext = 1, -- turn off the bottom buttons

    logo_temp = NewIFImage {
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0, -- top
        y = -38, -- Texture has about 44 pixels of dead space at the top
--      texture = "check", -- set below
        localpos_l = -256, localpos_t = 0,
        localpos_r = 256, localpos_b = 256,
        texture = "logo",
    },

    title = NewIFText {
        string = "ifs.start.press_start",
        font = "gamefont_large",
        textw = 460,
        texth = 200,
			y = -210,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 1.0, -- bottom
        startdelay = 0.4,
        valign = "bottom",
        nocreatebackground = 1,
    },

    invitetitle = NewIFText {
        string = "ifs.Start.gotinvite",
        font = "gamefont_medium",
        textw = 460,
        texth = 200,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0.75, -- top
        flashy = 0,
    },

--  titlebg = NewIFText {
 --     string = "ifs.start.press_start",
 --     font = "gamefont_large",
 --     textw = 460,
--      texth = 200,
 --     ScreenRelativeX = 0.5, -- center
 --     ScreenRelativeY = 0.5, -- top
--      ColorR = 0, ColorG = 0, ColorB = 0,
 --     startdelay = 0.4,
--  },

    Enter = function(this, bFwd)
        -- Always call base class functionality
        gIFShellScreenTemplate_fnEnter(this, bFwd)

        -- Always reset demo timer
        if(gPlatformStr == "PS2") then
            this.Demomode_Delay = this.Demomode_Delay_DEFAULT_PS2
        else
            this.Demomode_Delay = this.Demomode_Delay_DEFAULT_XBOX
        end
				-- Make 
				if((not gMovieAttractMode) and (not gFinalBuild)) then
					this.Demomode_Delay = 10
				end


        -- Off by default
        IFObj_fnSetVis(this.invitetitle,nil)
        
        -- If we're entering this, and no players are logged in, then make
        -- sure all controllers are unbound. This fixes BF2 bug 107 where
        -- start was hit in attract mode, and that controller immediately
        -- removed. The check about the error box below needs to not care
        -- about that.
        if(bFwd and (not ScriptCB_IsPlayerLoggedIn())) then
            -- Unbind all controllers.
            if(ScriptCB_SkipToNTGUI()) then
                ScriptCB_UnbindController(-2) -- all controllers, except primary
            else
                ScriptCB_UnbindController(-1) -- all controllers
            end
            -- Whine if controllers go missing
            ScriptCB_SetIgnoreControllerRemoval(nil)
        end

        -- if the error box is open, don't do anything until its gone,
        -- otherwise it'll mess up just about everything.
        if(ScriptCB_IsErrorBoxOpen()) then
            IFObj_fnSetVis(this.title,nil)      
            return
        end

        ScriptCB_srand() -- no params == off HW clock

        --if we're ps2, do the initial check for space      
        if( (gPlatformStr == "PS2") and ScriptCB_DoInitialMemcardCheck() ) then
        
            -- allow all controllers
            ScriptCB_SetAutoAcquireControllers(1)
            ScriptCB_ReadAllControllers(1)
            
            -- do the check
            ifs_saveop.doOp = "InitialMemcardCheck"
            ifs_saveop.OnSuccess = ifs_start_InitialMemcardCheckSuccessPS2
            ifs_saveop.OnCancel = ifs_start_InitialMemcardCheckCancelPS2
            ifs_movietrans_PushScreen(ifs_saveop)
            return
        end
        
        -- Off by default
        IFObj_fnSetVis(this.invitetitle,nil)

        -- Start movie entering this screen, always.
        if(bFwd) then
            ScriptCB_OpenNetShell(0) -- 0 == login access only

            if(gOnlineServiceStr == "XLive") then
                this.bInvitePending = ScriptCB_IsBootInvitePending()
                IFObj_fnSetVis(this.invitetitle,this.bInvitePending)
            end
        end

        if(ScriptCB_IsAutoNet()) then
            ScriptCB_PushScreen("ifs_mp_autonet")
        elseif(gPlatformStr == "PC") then
            -- if we're PC, just skip this entire screen by going one more
            -- screen in the direction we entered.
            if(bFwd) then
                --ifs_movietrans_PushScreen(ifs_main)
                ifs_start_OnDone()
            else
                ScriptCB_PopScreen()
            end     
        else --XBOX or PS2
            -- If player has already logged in, and the shell is just starting
            -- up, jump forward to main menu
            if(bFwd and ScriptCB_IsPlayerLoggedIn()) then
                --ifs_movietrans_PushScreen(ifs_main)
                -- Whine if controllers go missing
                ScriptCB_SetIgnoreControllerRemoval(nil)
                ifs_start_OnDone()
            else
                -- Unbind all controllers.
                if(ScriptCB_SkipToNTGUI()) then
                    ScriptCB_UnbindController(-2) -- all controllers, except primary
                else
                    ScriptCB_UnbindController(-1) -- all controllers
                end
                -- Whine if controllers go missing
                ScriptCB_SetIgnoreControllerRemoval(nil)
            end
        end
        
        -- if we're booting from NTGUI, skip forward
        if(ScriptCB_SkipToNTGUI()) then
            this.bWantSkipToNTGUI = 1
        end     
    end,

    -- Do nothing on this screen
    Input_Back = function(this)
    end,

    TitleAlpha = 1.0,
    TitleDir = -1.0,
    fControllerCheck = -1, -- force an update asap
    iLastControllers = -1,

    Update = function(this, fDt)
        -- Call base class functionality
        gIFShellScreenTemplate_fnUpdate(this, fDt)
        
        -- don't update if the error box is open
        if(ScriptCB_IsErrorBoxOpen()) then
            return
        end

        -- Do periodic check if controllers are present.
        this.fControllerCheck = this.fControllerCheck - fDt
        if(this.fControllerCheck < 0) then
            this.fControllerCheck = 0.25

            local iNumControllers = ScriptCB_GetNumControllers()
            if(this.iLastControllers ~= iNumControllers) then
                this.iLastControllers = iNumControllers

                if((iNumControllers > 0) or (gPlatformStr ~= "PS2")) then
                    IFText_fnSetString(this.title,"ifs.start.press_start")
                else
                    IFText_fnSetString(this.title,"ifs.start.nocontroller")
                end
            end
        end

        -- If we're booting from NTGUI, skip forward once we know how many
        -- controllers are present. Fixes bug 1404 
        if((this.iLastControllers > 0) and this.bWantSkipToNTGUI) then
            this.bWantSkipToNTGUI = nil -- clear flag
            --ifs_movietrans_PushScreen(ifs_main)
            ifs_start_OnDone()
        end     

        this.TitleAlpha = this.TitleAlpha + this.TitleDir * (fDt * 0.5)
        if(this.TitleAlpha < 0.4) then
            this.TitleAlpha = 0.4
            this.TitleDir = 1.0
        end
        if(this.TitleAlpha > 1.0) then
            this.TitleAlpha = 1.0
            this.TitleDir = -1.0
        end
        IFObj_fnSetAlpha(this.title,this.TitleAlpha)

        fDt = math.min(fDt, 0.5)
        this.Demomode_Delay = this.Demomode_Delay - fDt
        if(this.Demomode_Delay < 0) then
            ifs_start_fnStartAttractMode(this)
        end
    end,

    -- Overrides for most input handlers, as we want to do nothing
    -- when this happens on this screen.
    Input_Accept = function(this) 
        -- Functionality REMOVED NM 7/5/04 - it caused bug 6192 to appear. Do
        -- NOT check this in re-enabled.
--      ifs_start_fnStartAttractMode(this)
    end,
    Input_GeneralLeft = function(this,bFromAI)
    end,
    Input_GeneralRight = function(this,bFromAI)
    end,
    Input_GeneralUp = function(this,bFromAI)
    end,
    Input_GeneralDown = function(this,bFromAI)
    end,

    Input_Start = function(this)
        -- if this is the first time through, do the initial memcard check
        -- ps2 does this on enter
        if( (gPlatformStr ~= "PS2") and ScriptCB_DoInitialMemcardCheck() ) then
            ifs_saveop.doOp = "InitialMemcardCheck"
            ifs_saveop.OnSuccess = ifs_start_InitialMemcardCheckSuccessXBOX
            ifs_saveop.OnCancel = ifs_start_InitialMemcardCheckCancelXBOX
            ifs_movietrans_PushScreen(ifs_saveop)
        else
            -- no check.  go right to main
            ifs_start_InitialMemcardCheckSuccessXBOX()
        end
        ifelm_shellscreen_fnPlaySound(this.acceptSound);
    end,
    
    fnPostError = function(this,bUserHitYes,ErrorLevel,ErrorMessage)
        print("ifs_start.fnPostError")
        -- reenter this screen
        IFObj_fnSetVis(this.title,1)
        ifs_start.Enter(ifs_start,1)
    end,
}

function ifs_start_OnLoginDone( )
	if(gPlatformStr == "PC") then	
		if ( ScriptCB_IsCmdlineJoinPending() or		-- Gamespy Arcade/Auto login
			 ScriptCB_IsSpecialJoinPending() ) then
			if( ifs_main ) then
				ifs_main.option_mp = 1		-- set to multiplayer 
			end
			ScriptCB_SetGameRules("mp")
			ifs_movietrans_PushScreen(ifs_mpgs_login)
		elseif (ScriptCB_InMultiplayer()) then
			if( ifs_main ) then
				ifs_main.option_mp = 1		-- set to multiplayer 
			end
			ScriptCB_SetGameRules("mp")
			if(ScriptCB_GetWasHost()) then
				ifs_movietrans_PushScreen(ifs_missionselect_pcMulti)
			else
				ifs_movietrans_PushScreen(ifs_mp_sessionlist)
			end
		elseif (ScriptCB_IsMetagameStateSaved()) then
			ifs_movietrans_PushScreen(ifs_freeform_main)			
		elseif (ScriptCB_IsCampaignStateSaved()) then
			ifs_movietrans_PushScreen(ifs_campaign_main)
		elseif (ifs_login.bGoToSP or ScriptCB_GetInTrainingMission()) then
			ifs_login.bGoToSP = nil
			ifs_movietrans_PushScreen(ifs_sp_campaign)
		else
			if( ifs_main ) then
				ifs_main.option_mp = 1		-- set to multiplayer 
			end
			ScriptCB_SetGameRules("mp")
			if( ScriptCB_IsLoggedIn() ) then
				if(ScriptCB_GetWasHost()) then
					ifs_movietrans_PushScreen(ifs_missionselect_pcMulti)
				else
					ifs_movietrans_PushScreen(ifs_mp_sessionlist)
				end
			else
				ifs_mpgs_login.enable_autologin = 1
				ifs_movietrans_PushScreen(ifs_mpgs_login)
			end
		end
	else
		ifs_movietrans_PushScreen(ifs_main)
	end    
end

function ifs_start_OnDone()
    --ifs_movietrans_PushScreen(ifs_main)
    
    ifs_login.fnDone = ifs_start_OnLoginDone
    ifs_movietrans_PushScreen(ifs_login)
end

----------------------------------------------------------------------------------------
-- initial hd space check (on accept)
----------------------------------------------------------------------------------------

function ifs_start_InitialMemcardCheckSuccessXBOX()
--  print("ifs_start_InitialMemcardCheckSuccessXBOX")
    if(gOnlineServiceStr == "XLive") then
        ifs_mpxl_silentlogin.OnDone = ifs_start_OnDone
        ifs_movietrans_PushScreen(ifs_mpxl_silentlogin)
    else
        ifs_start_OnDone()
    end
end

function ifs_start_InitialMemcardCheckCancelXBOX()
--  print("ifs_start_InitialMemcardCheckCancelXBOX")
--  ScriptCB_SetMemoryProfileMode(1)
    ifs_start_InitialMemcardCheckSuccessXBOX()
end

----------------------------------------------------------------------------------------
-- initial memcard check (on enter)
----------------------------------------------------------------------------------------

function ifs_start_InitialMemcardCheckSuccessPS2()
--  print("ifs_start_InitialMemcardCheckSuccessPS2")
    
    -- disallow all controllers
    ScriptCB_SetAutoAcquireControllers(nil)
    ScriptCB_ReadAllControllers(nil)
    if(ScriptCB_SkipToNTGUI()) then
        ScriptCB_UnbindController(-2) -- all controllers, except primary
    else
        ScriptCB_UnbindController(-1) -- all controllers
    end

    -- pop the ifs_saveop screen
    ScriptCB_PopScreen()
end

function ifs_start_InitialMemcardCheckCancelPS2()
--  print("ifs_start_InitialMemcardCheckCancelPS2")
    
    -- disallow all controllers
    ScriptCB_SetAutoAcquireControllers(nil)
    ScriptCB_ReadAllControllers(nil)
    if(ScriptCB_SkipToNTGUI()) then
        ScriptCB_UnbindController(-2) -- all controllers, except primary
    else
        ScriptCB_UnbindController(-1) -- all controllers
    end
    
    print("cancel jumpToNTGUI")
    ScriptCB_ResetSkipToNTGUI()
    
    ifs_start_InitialMemcardCheckSuccessPS2()
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

function ifs_start_fnPickAttractMap(this)
    -- Pick a math.random attact mode map to launch 
    local NumSections = table.getn(attract_mode_maps)
    local MapIdx = math.min(math.random(NumSections+1),NumSections)

    local MapNameStr = attract_mode_maps[MapIdx]
    local RaceChar = string.sub(MapNameStr,5,5) -- e.g. "end1a" -> 'a'

    if(RaceChar == "g") then
        ScriptCB_SetTeamNames("common.sides.all.name", "common.sides.imp.name")
    elseif (RaceChar == "c") then
        ScriptCB_SetTeamNames("common.sides.rep.name", "common.sides.cis.name")
    else
    end
    return MapNameStr
end

function ifs_start_fnStartAttractMode(this)
    
    --ifelem_shellscreen_fnStopMovie()

    if (gMovieAttractMode) then
        ifs_movietrans_PushScreen(ifs_attract)
    else
        local MapNameStr = ifs_start_fnPickAttractMap()

        ScriptCB_LaunchDemo(MapNameStr)
        this.Demomode_Delay = 9999999
    end
end


AddIFScreen(ifs_start,"ifs_start")