--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- attract mode screen, plays a series of movies 

-- Helper function, stops movie, returns
function ifs_attract_fnStopAndReturn(this)
    if(this.bMoviePlaying) then
        this.bMoviePlaying = nil
        --ifelem_shellscreen_fnStopMovie()
        ScriptCB_PopScreen()
    end
end


ifs_attract = NewIFShellScreen {
    
    nextScreen       = nil, -- screen to push after the intro movie is completed
    introEffects     = nil, -- transition sound effects
    whooshSound      = 1,
    bNohelptext      = 1,
    movieBackground  = "attractmovie",
    enterSound       = "",
    exitSound        = "",    
    bg_texture       = nil,
    fControllerCheck = -1, -- force an update asap
    iLastControllers = -1,
    timeout          = 138,
    
    title = NewIFText {
        string = "game.attractmode.title",
        font = "gamefont_large",
        textw = 460,
        texth = 200,
        ScreenRelativeX = 0.5, -- center
        ScreenRelativeY = 0.9, -- bottom
        startdelay = 0.4,
        valign = "vcenter",
        nocreatebackground = 1,
    },
    
    Enter = function(this, bFwd)
        -- Always call base class functionality
        gIFShellScreenTemplate_fnEnter(this, bFwd)
    
        if(this.Helptext_Accept) then
            gHelptext_fnMoveIcon(this.Helptext_Accept)
        end
        
        local wScreen,hScreen = ScriptCB_GetScreenInfo()

        --if(gPlatformStr == "XBox") then
        --  ScriptCB_CloseMovie();
        --  ScriptCB_OpenMovie("movies\\fly.mvs", "")
        --end       
        
        --ifelem_shellscreen_fnStartMovie("attractfly", 1, nil, 1)
        this.bMoviePlaying = 1
        this.timeout       = 180
        ScriptCB_ReadAllControllers(1, nil, 1)
    end,

    Exit = function(this, bFwd) 
        ScriptCB_ReadAllControllers(nil)
        
        if(gPlatformStr == "XBox") then
            ScriptCB_CloseMovie();
            ScriptCB_OpenMovie(gMovieStream, "");
        end     
    end,
    
    Input_Accept = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_Back = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_Misc = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_Misc2 = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_DPadUp = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_DPadDown = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_DPadLeft = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_DPadRight = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_Start = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_Select = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_LTrigger = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_RTrigger = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_LTrigger2 = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_RTrigger2 = function(this)
        ifs_attract_fnStopAndReturn(this)
    end,
    Input_LTrigger3 = function(this)
        if(gPlatformStr == "PS2") then
            ifs_attract_fnStopAndReturn(this)
        end
    end,
    Input_RTrigger3 = function(this)
        if(gPlatformStr == "PS2") then
            ifs_attract_fnStopAndReturn(this)
        end
    end,

    -- Don't do anything on general inputs (stick *OR* dpad). DPad is handled
    -- in a special case above.
    Input_GeneralUp = function(this)
    end,
    Input_GeneralDown = function(this)
    end,
    Input_GeneralLeft = function(this)
    end,
    Input_GeneralRight = function(this)
    end,

    Update = function(this, fDt)
        -- Call base class functionality
        gIFShellScreenTemplate_fnUpdate(this, fDt)
    
        this.timeout = this.timeout - fDt
        if (this.timeout < 0) then
            ifs_attract_fnStopAndReturn(this)
        end
        
        -- Do periodic check if controllers are present.
        this.fControllerCheck = this.fControllerCheck - fDt
        if(this.fControllerCheck < 0) then
            this.fControllerCheck = 0.25

            local iNumControllers = ScriptCB_GetNumControllers()
            if(this.iLastControllers ~= iNumControllers) then
                this.iLastControllers = iNumControllers

                if((iNumControllers > 0) or (gPlatformStr ~= "PS2")) then
                    IFText_fnSetString(this.title,"game.attractmode.title")
                else
                    IFText_fnSetString(this.title,"ifs.start.nocontroller")
                end
            end
        end
    end,
}

-- add screen to GUI manager
AddIFScreen(ifs_attract, "ifs_attract")