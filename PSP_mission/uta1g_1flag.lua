--Extracted\uta1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
local local_0 = 1
local local_1 = 2

function ScriptPostLoad()
    SoundEvent_SetupTeams(local_0,"imp",local_1,"all")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "Flag_capture1", captureRegionDEF = "Flag_capture2", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true, hideCPs = true })
    ctf:Start()
    EnableSPHeroRules()
    DisableBarriers("Barrier445")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3889105)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4880000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\uta.lvl;uta1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_inf_wookiee","all_hero_hansolo_tat")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = local_1, units = 10, reinforcements = 100, 
              soldier =               { "all_inf_rifleman", 4 }, 
              assault =               { "all_inf_rocketeer", 2 }, 
              engineer =               { "all_inf_engineer", 2 }, 
              sniper =               { "all_inf_sniper", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }
           })
        SetupTeams({ 
            imp =             { team = local_0, units = 10, reinforcements = 100, 
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
            all =             { team = local_1, units = 20, reinforcements = 100, 
              soldier =               { "all_inf_rifleman", 8 }, 
              assault =               { "all_inf_rocketeer", 3 }, 
              engineer =               { "all_inf_engineer", 4 }, 
              sniper =               { "all_inf_sniper", 2 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 2 }
             }
           })
        SetupTeams({ 
            imp =             { team = local_0, units = 20, reinforcements = 100, 
              soldier =               { "imp_inf_rifleman", 8 }, 
              assault =               { "imp_inf_rocketeer", 3 }, 
              engineer =               { "imp_inf_engineer", 4 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 2 }
             }
           })
end
    SetHeroClass(local_0,"imp_hero_bobafett")
    SetHeroClass(local_1,"all_hero_hansolo_tat")
    ClearWalkers()
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("EntityHover",4)
    SetMemoryPoolSize("EntityFlyer",8)
    SetMemoryPoolSize("EntityLight",80)
    SetMemoryPoolSize("Obstacle",400)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("uta\\uta1.lvl","uta1_1flag")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(local_1,1,"all_uta_amb_start",0,1)
    SetAmbientMusic(local_0,1,"imp_uta_amb_start",0,1)
    SetVictoryMusic(local_1,"all_uta_amb_victory")
    SetDefeatMusic(local_1,"all_uta_amb_defeat")
    SetVictoryMusic(local_0,"imp_uta_amb_victory")
    SetDefeatMusic(local_0,"imp_uta_amb_defeat")
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

