--Extracted\uta1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
local local_2 = 1
local local_3 = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CON_CP1" })
    cp2 = CommandPost:New({ name = "con_CP1a" })
    cp3 = CommandPost:New({ name = "CON_CP2" })
    cp4 = CommandPost:New({ name = "CON_CP5" })
    cp5 = CommandPost:New({ name = "CON_CP6" })
    cp6 = CommandPost:New({ name = "CON_CP7" })
    conquest = ObjectiveConquest:New({ teamATT = local_2, teamDEF = local_3, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    DisableBarriers("Barrier445")
end
local local_0 = 1
local local_1 = 2

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4333073)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4880000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\uta.lvl;uta1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_inf_wookiee","all_hero_hansolo_tat","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett","imp_fly_destroyer_dome","imp_hover_fightertank")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = local_0, units = 10, reinforcements = 150, 
              soldier =               { "all_inf_rifleman", 4 }, 
              assault =               { "all_inf_rocketeer", 2 }, 
              engineer =               { "all_inf_engineer", 2 }, 
              sniper =               { "all_inf_sniper", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }
           })
        SetupTeams({ 
            imp =             { team = local_1, units = 10, reinforcements = 150, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 2 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }
           })
else
        SetupTeams({ 
            all =             { team = local_0, units = 20, reinforcements = 150, 
              soldier =               { "all_inf_rifleman", 9, 25 }, 
              assault =               { "all_inf_rocketeer", 1, 4 }, 
              engineer =               { "all_inf_engineer", 1, 4 }, 
              sniper =               { "all_inf_sniper", 1, 4 }, 
              officer =               { "all_inf_officer", 1, 4 }, 
              special =               { "all_inf_wookiee", 1, 4 }
             }
           })
        SetupTeams({ 
            imp =             { team = local_1, units = 20, reinforcements = 150, 
              soldier =               { "imp_inf_rifleman", 9, 25 }, 
              assault =               { "imp_inf_rocketeer", 1, 4 }, 
              engineer =               { "imp_inf_engineer", 1, 4 }, 
              sniper =               { "imp_inf_sniper", 1, 4 }, 
              officer =               { "imp_inf_officer", 1, 4 }, 
              special =               { "imp_inf_dark_trooper", 1, 4 }
             }
           })
end
    SetHeroClass(local_1,"imp_hero_bobafett")
    SetHeroClass(local_0,"all_hero_hansolo_tat")
    ClearWalkers()
    SetMemoryPoolSize("EntityHover",6)
    SetMemoryPoolSize("EntityFlyer",8)
    SetMemoryPoolSize("EntityLight",80)
    SetMemoryPoolSize("EntitySoundStatic",27)
    SetMemoryPoolSize("Obstacle",400)
    SetMemoryPoolSize("Weapon",260)
    ReadDataFile("uta\\uta1.lvl","uta1_Conquest")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(local_0,1,"all_uta_amb_start",0,1)
    SetAmbientMusic(local_0,0.80000001192093,"all_uta_amb_middle",1,1)
    SetAmbientMusic(local_0,0.20000000298023,"all_uta_amb_end",2,1)
    SetAmbientMusic(local_1,1,"imp_uta_amb_start",0,1)
    SetAmbientMusic(local_1,0.80000001192093,"imp_uta_amb_middle",1,1)
    SetAmbientMusic(local_1,0.20000000298023,"imp_uta_amb_end",2,1)
    SetVictoryMusic(local_0,"all_uta_amb_victory")
    SetDefeatMusic(local_0,"all_uta_amb_defeat")
    SetVictoryMusic(local_1,"imp_uta_amb_victory")
    SetDefeatMusic(local_1,"imp_uta_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(-0.42809098958969,0.045648999512196,-0.89749401807785,-0.09570299834013,162.71495056152,45.857063293457,40.647117614746)
    AddCameraShot(-0.19486099481583,-0.0015999999595806,-0.98079597949982,0.0080549996346235,-126.17978668213,16.113788604736,70.012893676758)
    AddCameraShot(-0.46254798769951,-0.020921999588609,-0.88544201850891,0.040049999952316,-16.947637557983,4.5617961883545,156.92695617676)
    AddCameraShot(0.99531000852585,0.0245820004493,-0.093534998595715,0.0023099998943508,38.288612365723,4.5617961883545,243.29850769043)
    AddCameraShot(0.82706999778748,0.017092999070883,0.56171900033951,-0.01160900015384,-24.457637786865,8.8341455459595,296.54458618164)
    AddCameraShot(0.99887502193451,0.0049120001494884,-0.047173999249935,0.00023200000578072,-45.868236541748,2.9782149791718,216.21788024902)
end

