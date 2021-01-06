--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Top page for the options pages hierarchy

ifs_opt_top_vbutton_layout = {
--  yTop = 0,
    ySpacing  = 5,
    width = 360,
    font = gMenuButtonFont,
    buttonlist = { 
        { tag = "general", string = "ifs.GameOpt.title", },
        { tag = "pcvideo", string = "ifs.VideoOpt.title", },  -- PC only!
        { tag = "sound", string = "ifs.SoundOpt.title", },
        { tag = "cveh", string = "ifs.controls.Vehicle_Unit", },  -- XBOX/PS2 only!
        { tag = "pccontrols", string = "ifs.GameOpt.pc_optionstitle", },  -- PC only!
        { tag = "online", string = "ifs.onlineopt.title", },
        
        { tag = "unlock", string = "ifs.unlock.title", },
        { tag = "credits", string = "ifs.credits.title", },
        { tag = "viewstats", string = "ifs.stats.careerstatstitle", },
        { tag = "fonttest", string = "Font Test", },
    },
    title = "ifs.Main.options",
--  rotY = 40,
}

-- Callback (from C++) -- saving is done. Re-enable buttons
--function ifs_opt_top_fnSaveProfileDone(this)
--  Popup_LoadSave:fnActivate(nil)
--  IFObj_fnSetVis(this.buttons,1)
--  
--  -- exit this screen
--  ScriptCB_PopScreen()
--end


----------------------------------------------------------------------------------------
-- save the profile in slot 1
----------------------------------------------------------------------------------------

function ifs_opt_top_StartSaveProfile()
--  print("ifs_opt_top_StartSaveProfile")
    
    ifs_saveop.doOp = "SaveProfile"
    ifs_saveop.OnSuccess = ifs_opt_top_SaveProfileSuccess
    ifs_saveop.OnCancel = ifs_opt_top_SaveProfileCancel
    local iProfileIdx = 1 + ScriptCB_GetPrimaryController()
    ifs_saveop.saveName = ScriptCB_GetProfileName(iProfileIdx)
    ifs_saveop.saveProfileNum = iProfileIdx
    ifs_movietrans_PushScreen(ifs_saveop)
end

function ifs_opt_top_SaveProfileSuccess()
--  print("ifs_opt_top_SaveProfileSuccess")
    local this = ifs_opt_top
    
    -- exit ifs_saveop
    ScriptCB_PopScreen()
    -- exit this screen
    ScriptCB_PopScreen()    
end

function ifs_opt_top_SaveProfileCancel()
--  print("ifs_opt_top_SaveProfileCancel")
    local this = ifs_opt_top
    
    -- exit ifs_saveop
    ScriptCB_PopScreen()
    -- exit this screen
    ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------


ifs_opt_top = NewIFShellScreen {
	nologo = 1,
	bAcceptIsSelect = 1,
	movieIntro      = nil, -- WAS "ifs_opt_top_intro", -- played before the screen is displayed
-- 	movieBackground = "shell_sub_left", -- WAS "ifs_opt_top",       -- played while the screen is displayed
	bDimBackdrop = 1,

--  title = NewIFText {
--      string = "ifs.Main.options",
--      font = "gamefont_large",
--      textw = 460, -- center on screen. Fixme: do real centering!
--      ScreenRelativeX = 0.5, -- center
--      ScreenRelativeY = 0, -- top
--      y = 10,
--      inert = 1, -- delete out of Lua mem when pushed to C
--  },

    buttons = NewIFContainer {
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = gDefaultButtonScreenRelativeY, -- center
    },

    -- When entering this screen, check if we need to save (triggered
    -- by a subscreen or something). If so, start that process.
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
        
        -- Show/hide buttons only when entering from another screen, not backing in
        if(bFwd) then
            -- hide some buttons
					local bShellActive = ScriptCB_GetShellActive()
            this.buttons.pcvideo.hidden = (gPlatformStr ~= "PC")
            this.buttons.pccontrols.hidden = (gPlatformStr ~= "PC")
            this.buttons.cveh.hidden = (gPlatformStr == "PC")
            this.buttons.unlock.hidden = 1 -- (gPlatformStr == "PC") or (not ScriptCB_GetShellActive())
            this.buttons.credits.hidden = not bShellActive
            this.buttons.fonttest.hidden = not bShellActive or gFinalBuild
            this.buttons.viewstats.hidden = not bShellActive

            -- Function test added NM 6/8/05. Remove after about a week.
            if(ScriptCB_PausingIsPrimary) then
                this.buttons.sound.hidden = not ScriptCB_PausingIsPrimary()
            else
                this.buttons.sound.hidden = (ScriptCB_GetPausingViewport() ~= 0)
            end
            if(gDemoBuild) then
                this.buttons.unlock.bDimmed = 1
                this.buttons.online.bDimmed = 1
            end

            this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_opt_top_vbutton_layout)       
            SetCurButton(this.CurButton)
        end
    end, -- function Enter()

    Input_Accept = function(this) 
        -- If base class handled this work, then we're done
        if(gShellScreen_fnDefaultInputAccept(this)) then
            return
        end

        ifelm_shellscreen_fnPlaySound(this.acceptSound)     
        
        --XBOX/PS2 only!
        --XBOX/PS2 only!
        
        if(this.CurButton == "cveh") then
            ifs_opt_controller.bFlyerMode = nil
            if( gPlatformStr == "PC" ) then
                ifs_movietrans_PushScreen(ifs_opt_pccontrols)
            else
                ifs_movietrans_PushScreen(ifs_opt_contmode)
            end
        elseif (this.CurButton == "cfly") then
            ifs_opt_controller.bFlyerMode = 1
            if( gPlatformStr == "PC" ) then
                ifs_movietrans_PushScreen(ifs_opt_pccontrols)
            else
                ifs_movietrans_PushScreen(ifs_opt_contmode)
            end
            --PC only!
        elseif (this.CurButton == "pccontrols") then
            ifs_movietrans_PushScreen(ifs_opt_pccontrols)   
        elseif (this.CurButton == "pcvideo") then
            ifs_movietrans_PushScreen(ifs_opt_pcvideo)
            
            --everybody!    
        elseif (this.CurButton == "general") then
            ifs_movietrans_PushScreen(ifs_opt_general)
        elseif (this.CurButton == "sound") then
            ifs_movietrans_PushScreen(ifs_opt_sound)
        elseif (this.CurButton == "online") then
            ifs_movietrans_PushScreen(ifs_opt_mp)
        elseif (this.CurButton == "unlock") then
            ifs_movietrans_PushScreen(ifs_unlockables)
        elseif (this.CurButton == "credits") then
            ifs_movietrans_PushScreen(ifs_credits)
        elseif (this.CurButton == "fonttest") then
            ifs_movietrans_PushScreen(ifs_fonttest)
        elseif (this.CurButton == "viewstats") then
            ifs_movietrans_PushScreen(ifs_careerstats)
        end
    end,
    
    Input_Back = function(this)
        -- trigger a save if the profile is dirty
        local bCanSave = (gPlatformStr == "PC") or ScriptCB_GetShellActive()

        if(bCanSave and ScriptCB_IsCurProfileDirty()) then
            --IFObj_fnSetVis(this.buttons,nil)
            --Popup_LoadSave:fnActivate(1)
            --ScriptCB_StartSaveProfile()

            ifs_opt_top_StartSaveProfile()
        else
            --otherwise just exit
            ScriptCB_PopScreen()
        end     
        
    end,

--  fnSaveProfileDone = ifs_opt_top_fnSaveProfileDone,
}

function ifs_opt_top_fnBuildScreen(this)
    local w
    local h
    w,h = ScriptCB_GetSafeScreenInfo()

	if(ScriptCB_GetShellActive() and (gPlatformStr ~= "PC")) then
		ifs_opt_top_vbutton_layout.bLeftJustifyButtons = 1
	end

	this.CurButton = AddVerticalButtons(this.buttons,ifs_opt_top_vbutton_layout)
end

ifs_opt_top_fnBuildScreen(ifs_opt_top)
ifs_opt_top_fnBuildScreen = nil

AddIFScreen(ifs_opt_top,"ifs_opt_top")
ifs_opt_top = DoPostDelete(ifs_opt_top)
