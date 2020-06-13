-- PSP ifs_minicamp_campselect.lua

-- Originally located (on PSP) at:
--     MainMenu->Singleplayer->Challenges
--     Shows a selection screen for:
--          "Imperial Enforcer"
--          "Rogue Assaaaian" 
--          "Rebel Raider"
-- decompiled by cbadal 
-- verified
-- 
ifs_minicamp_campselect_vbutton_layout = {
    xWidth = 200,
    width = 250,
    xSpacing = 10,
    ySpacing = 5,
    font = "gamefont_medium",
    buttonlist = {
        { tag = "dipl", string = "ifs.sp.minicamp.dipl.title" },
        { tag = "merc", string = "ifs.sp.minicamp.merc.title" },
        { tag = "smug", string = "ifs.sp.minicamp.smug.title" }
    },
    title = "ifs.sp.minicamp.title"
}

ifs_minicamp_campselect = NewIFShellScreen {
    movieIntro = nil,
    movieBackground = "temp_shell",
    music = "shell_soundtrack",
    bg_texture = "psp_submenu_2",
    buttons = NewIFContainer {
        ScreenRelativeX = 0.5,
        ScreenRelativeY = gDefaultButtonScreenRelativeY
    },

    Enter = function(this)
        if gPlatformStr == "PSP" then
            gIFShellScreenTemplate_fnEnter(this, bFwd)
            ShowHideVerticalButtons(this.buttons, ifs_minicamp_campselect_vbutton_layout)
        end
    end,

    Input_Accept = function(this)
        if (gShellScreen_fnDefaultInputAccept(this)) then
            return
        end
        local mapTable = {} -- R1 
        local result = -1     -- R2 
        gPickedMapList = {}
        ifelm_shellscreen_fnPlaySound(this.acceptSound)

        if this.CurButton == "smug" then
            -- Rebel Raider; loads the 'xx_Smuggler' layer
			mapTable = {
                { Map = "Myg1c_scm", Side = 1 },
                { Map = "Nab2c_scm", Side = 1 },
                { Map = "Hot1g_scm", Side = 1 },
                { Map = "Spa1g_scm", Side = 1 }
            }
            gMCMode = "smug"
            result = ScriptCB_GetPSPMCProgress(0)
        elseif this.CurButton == "dipl" then
			-- Imperial Enforcer; loads the 'xxx_Sniper' layer 
            mapTable = {
                { Map = "Nab2g_dcm", Side = 1 },
                { Map = "Tat2g_dcm", Side = 1 },
                { Map = "End1g_dcm", Side = 1 },
                { Map = "Kas2g_dcm", Side = 1 }
            }
            gMCMode = "dipl"
            result = ScriptCB_GetPSPMCProgress(1)
        elseif this.CurButton == "merc" then
            -- Rogue Assassin; loads the 'xxx_merc' layer 
			mapTable = { 
                { Map = "dag1g_mcm", Side = 1 },
                { Map = "myg1c_mcm", Side = 1 },
                { Map = "yav1g_mcm", Side = 1 },
                { Map = "Pol1c_mcm", Side = 1 }
            }
            gMCMode = "merc"
            result = ScriptCB_GetPSPMCProgress(2)
        end
	
		-- this for loop looks like shit (to me), but decompiles exactly correct 
        for r4 in mapTable do 
			if  r4 + result <= table.getn(mapTable) then 
				table.insert(gPickedMapList, mapTable[r4 + result])
			end 
        end 

        if  table.getn(gPickedMapList) == 0 then 
			gPickedMapList = mapTable
		end 
		ScriptCB_SetMissionNames(gPickedMapList, false)
		ScriptCB_NewMiniCamp(1, gMCMode)
		ScriptCB_EnterMission()
    end
}

ifs_minicamp_campselect.CurButton = 
	AddVerticalButtons(ifs_minicamp_campselect.buttons, ifs_minicamp_campselect_vbutton_layout)
AddIFScreen(ifs_minicamp_campselect, "ifs_minicamp_campselect")

--[[
    0: this
    1: mapTable
    2: result 
    3: mapTable
    4: nil 
    5: nil
    6: R(5) +R(2) = result + nil
    7: table.getn(mapTable) (4)
    8: 

]]