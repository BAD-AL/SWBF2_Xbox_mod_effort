--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Interface screen for the metagame. Going to get kinda big, as it
-- does most of the work

-- Helper function. Builds the chunks for this screen programatically
-- (i.e. based on screensize). It makes and shoves things into the
-- 'this.Info' block, which is a container aligned to the right-middle
-- of the screen. Thus, within its space, x=0 is the right edge,
-- x=-100 is to its left. y=0 is the middle of the screen, y=-100 is
-- above that, y=100 is below.

function ifs_mapselect_fnBuildScreen(this, mode)
    local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen

    -- Make a box that's aligned to the right-middle of the screen
    -- to shove our stuff into
    this.Info = NewIFContainer {
        ScreenRelativeX = 1.0,
        ScreenRelativeY = 0.5,
        inert = 1, -- delete from Lua memory once pushed to C
    }

    
    this.Info.MapGroup = NewIFContainer 
    {
        x = 0, -- optional, relative to parent
        y = 0,
    }


    local boxw,boxh
    local yoffset1, yoffset2, yoffset3 --magical y offsets for the splitscreen mode (currently xbox demo garbage
    if ( mode == 0 ) then
        boxw = w * 0.30
        boxh = h * 0.6
        yoffset1 = 16 -- for the main tetx
        yoffset2  = 24 --title text
        yoffset3 = 8   --overall box height?
    else
        boxw = w * 0.30
        boxh = h * 0.4
        yoffset1 = 24
        yoffset2 = 16
        yoffset3 = 0
    end
    
    
    
    -- Scale a box based on screensize

    -- Upped from 0.5 to 0.54 to give German & Italian more space - NM 7/9/04
    local windowWidth = w*0.54
    local vehicleWindowHeight = 60
    local spawnpointWindowHeight = 30
    local windowSpacing = 10
    local titleBarHeight = 30
    local spawnpointWindowY = 0.12*h

    if(mode == 1) then
        windowSpacing = 4
        if(ScriptCB_GetNumCameras() <= 2) then
            windowWidth = w * 0.55
        else
            windowWidth = w * 0.4
        end
    end

    local windowX = -windowWidth*0.5 + 10
    if (mode == 1 and ScriptCB_IsHorizontalSplitScreen()) then
        windowX = 0.0
    end
    if (mode == 1) then
        spawnpointWindowY = 0.08*h
        windowSpacing = 4
    end

    local vehicleWindowY = spawnpointWindowY + spawnpointWindowHeight + windowSpacing + titleBarHeight

    local dividableArea = h - (vehicleWindowY + vehicleWindowHeight + 2*windowSpacing + 2*titleBarHeight)

    if (mode == 1 and ScriptCB_IsHorizontalSplitScreen()) then
        this.SideBar = NewIFContainer {
            ScreenRelativeX = 0.5,
            ScreenRelativeY = 0.5,
            x = 0.0, y =-10.0, z = -110,
        }
    else
        this.SideBar = NewIFContainer {
            ScreenRelativeX = 1.0,
            ScreenRelativeY = 0.0,
        }
    end
    
    local BoxTitleFont
    if(gLangStr ~= "english") then
        BoxTitleFont = "gamefont_tiny"
    else
        BoxTitleFont = "gamefont_small"
    end 

--OLD CODE - BradR - the decision has been made to entirely get rid of the CP name and vehicle list, so i'm commenting it out
--  if (ScriptCB_GetNumCameras() <= 2) then
--      --only show the spawnpoint and vehicle boxes if there's 2 or fewer players
--      this.SideBar.Spawnpoint = NewButtonWindow { ZPos = 200, 
--          x=windowX, y =spawnpointWindowHeight*0.5 + spawnpointWindowY,
--          width = windowWidth,
--          height = spawnpointWindowHeight,
--          titleText = "game.spawndisplay.spawnpointtitle"
--      }
--      this.SideBar.Spawnpoint.titleBarElement.font = BoxTitleFont
--  
--      this.SideBar.Vehicle = NewButtonWindow { ZPos = 200, 
--          x=windowX, y =vehicleWindowHeight*0.5 + vehicleWindowY,
--          width = windowWidth,
--          height = vehicleWindowHeight,
--          titleText = "game.spawndisplay.vehiclelist"
--      }
--      this.SideBar.Vehicle.titleBarElement.font = BoxTitleFont
--  end
    
    if (this.Helptext_Accept) then
        if ( mode == 0 ) then
            this.Helptext_Accept.helpstr.font = "gamefont_small"
        elseif (ScriptCB_IsHorizontalSplitScreen()) then
            this.Helptext_Accept.helpstr.font = "gamefont_tiny"
        else
            this.Helptext_Accept.helpstr.font = "gamefont_tiny"

            -- When rotated, it takes up less space.
            local RotWindowWidth = windowWidth - 40
            if(ScriptCB_GetNumCameras() <= 2) then
                this.Helptext_Accept.x = this.Helptext_Accept.x - RotWindowWidth
            end
            if (gLangStr == "french") then
                -- scale down
                this.Helptext_Accept.helpstr.HScale = 0.75
                this.Helptext_Accept.helpstr.VScale = 1.0
--              local newtextw = w - RotWindowWidth - 20;
--              this.Helptext_Accept.helpstr.x = this.Helptext_Accept.helpstr.x + this.Helptext_Accept.helpstr.textw - newtextw
--              this.Helptext_Accept.helpstr.textw = newtextw
--              this.Helptext_Accept.helpstr.texth = 60
--              this.Helptext_Accept.helpstr.halign = "right"
--              this.Helptext_Accept.y = this.Helptext_Accept.y - 20
            end
        end
        IFText_fnSetString(this.Helptext_Accept.helpstr, "game.spawndisplay.spawndisplay.promptnext")
        IFObj_fnSetVis(this.Helptext_Accept.helpstr, nil)
    end 
end

ifs_mapselect1 = NewIFShellScreen {
    nologo = 1,
    bNohelptext_back = 1,
    bNohelptext_accept = 1,

    -- Actual contents are created in ifs_mapselect_fnBuildScreen

    -- Note: for now, the exe is handling all the inputs/events, so this
    -- screen has no Enter/Exit/Update/Input handlers. It does have an
    -- Input_Back handler to override the base class's default functionality
    -- (go to previous screen)
    Input_Back = function(this)
    end,
    Input_GeneralLeft = function(this,bFromAI)
    end,
    Input_GeneralRight = function(this,bFromAI)
    end,
    Input_GeneralUp = function(this,bFromAI)
    end,
    Input_GeneralDown = function(this,bFromAI)
    end,
    
}

ifs_mapselect2 = NewIFShellScreen {
    nologo = 1,
    bNohelptext_back = 1, 
    bNohelptext_accept = 1,

    -- Actual contents are created in ifs_mapselect_fnBuildScreen

    -- Note: for now, the exe is handling all the inputs/events, so this
    -- screen has no Enter/Exit/Update/Input handlers. It does have an
    -- Input_Back handler to override the base class's default functionality
    -- (go to previous screen)
    Input_Back = function(this)
    end,
    Input_GeneralLeft = function(this,bFromAI)
    end,
    Input_GeneralRight = function(this,bFromAI)
    end,
    Input_GeneralUp = function(this,bFromAI)
    end,
    Input_GeneralDown = function(this,bFromAI)
    end,
    
}

ifs_mapselect3 = NewIFShellScreen {
    nologo = 1,
    bNohelptext_back = 1, 
    bNohelptext_accept = 1,

    -- Actual contents are created in ifs_mapselect_fnBuildScreen

    -- Note: for now, the exe is handling all the inputs/events, so this
    -- screen has no Enter/Exit/Update/Input handlers. It does have an
    -- Input_Back handler to override the base class's default functionality
    -- (go to previous screen)
    Input_Back = function(this)
    end,
    Input_GeneralLeft = function(this,bFromAI)
    end,
    Input_GeneralRight = function(this,bFromAI)
    end,
    Input_GeneralUp = function(this,bFromAI)
    end,
    Input_GeneralDown = function(this,bFromAI)
    end,
    
}

ifs_mapselect4 = NewIFShellScreen {
    nologo = 1,
    bNohelptext_back = 1, 
    bNohelptext_accept = 1,

    -- Actual contents are created in ifs_mapselect_fnBuildScreen

    -- Note: for now, the exe is handling all the inputs/events, so this
    -- screen has no Enter/Exit/Update/Input handlers. It does have an
    -- Input_Back handler to override the base class's default functionality
    -- (go to previous screen)
    Input_Back = function(this)
    end,
    Input_GeneralLeft = function(this,bFromAI)
    end,
    Input_GeneralRight = function(this,bFromAI)
    end,
    Input_GeneralUp = function(this,bFromAI)
    end,
    Input_GeneralDown = function(this,bFromAI)
    end,
    
}


if(not ScriptCB_IsSplitscreen()) then

--  print("SingleScreen")
    --its not splitscreen do it normally
    ifs_mapselect_fnBuildScreen(ifs_mapselect1, 0)
    AddIFScreen(ifs_mapselect1,"ifs_mapselect1")
    ifs_mapselect2 = nil -- flush from memory
    ifs_mapselect3 = nil -- flush from memory
    ifs_mapselect4 = nil -- flush from memory
    
else
    -- is splitscreen. Rearrange things
--  print("Splitscreen")
    
    ifs_mapselect_fnBuildScreen(ifs_mapselect1, 1)
    ifs_mapselect1.Viewport = 0
    AddIFScreen(ifs_mapselect1,"ifs_mapselect1")

    ifs_mapselect_fnBuildScreen(ifs_mapselect2, 1)
    ifs_mapselect2.Viewport = 1
    AddIFScreen(ifs_mapselect2,"ifs_mapselect2")
    ifs_mapselect2 = DoPostDelete(ifs_mapselect2)

    if(gPlatformStr == "XBox") then 
        ifs_mapselect_fnBuildScreen(ifs_mapselect3, 1)
        ifs_mapselect3.Viewport = 2
        AddIFScreen(ifs_mapselect3,"ifs_mapselect3")
        ifs_mapselect3 = DoPostDelete(ifs_mapselect3)

        ifs_mapselect_fnBuildScreen(ifs_mapselect4, 1)
        ifs_mapselect4.Viewport = 3
        AddIFScreen(ifs_mapselect4,"ifs_mapselect4")
        ifs_mapselect4 = DoPostDelete(ifs_mapselect4)
    else
        ifs_mapselect3 = nil -- flush from memory
        ifs_mapselect4 = nil -- flush from memory
    end
end

ifs_mapselect_fnBuildScreen = nil -- free up memory
ifs_mapselect1 = DoPostDelete(ifs_mapselect1)
