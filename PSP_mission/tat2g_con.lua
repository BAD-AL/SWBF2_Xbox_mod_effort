--Extracted\tat2g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    SetProperty("FDL-2","IsLocked",1)
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp6 = CommandPost:New({ name = "cp6" })
    cp7 = CommandPost:New({ name = "cp7" })
    cp8 = CommandPost:New({ name = "cp8" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    conquest:Start()
    AddAIGoal(1,"conquest",1000)
    AddAIGoal(2,"conquest",1000)
    AddAIGoal(3,"conquest",1000)
    EnableSPHeroRules()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3073233)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    AddMissionObjective(1,"red","level.tat2.objectives.1")
    AddMissionObjective(2,"green","level.tat2.objectives.1b")
    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_inf_wookiee","all_hero_hansolo_tat")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett","imp_fly_destroyer_dome","imp_walk_atst")
    ReadDataFile("SIDE\\des.lvl","tat_inf_jawa")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = 2, units = 10, reinforcements = 75, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = 1, units = 10, reinforcements = 75, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
else
        SetupTeams({ 
            all =             { team = 2, units = 25, reinforcements = 150, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = 1, units = 25, reinforcements = 150, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(2,"all_hero_hansolo_tat")
    SetHeroClass(1,"imp_hero_bobafett")
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",14)
    SetMemoryPoolSize("EntityCloth",25)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("MountedTurret",14)
    SetMemoryPoolSize("Obstacle",664)
    SetMemoryPoolSize("PathNode",384)
    SetMemoryPoolSize("TreeGridStack",500)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat2.lvl","tat2_con")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(2,1,"all_tat_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"all_tat_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"all_tat_amb_end",2,1)
    SetAmbientMusic(1,1,"imp_tat_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"imp_tat_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"imp_tat_amb_end",2,1)
    SetVictoryMusic(2,"all_tat_amb_victory")
    SetDefeatMusic(2,"all_tat_amb_defeat")
    SetVictoryMusic(1,"imp_tat_amb_victory")
    SetDefeatMusic(1,"imp_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(1)
    AddCameraShot(0.97433799505234,-0.22217999398708,0.035172000527382,0.0080199996009469,-82.664649963379,23.668300628662,43.955680847168)
    AddCameraShot(0.39019700884819,-0.089729003608227,-0.89304000139236,-0.2053620070219,23.563562393188,12.914884567261,-101.46556091309)
    AddCameraShot(0.16975900530815,0.0022249999456108,-0.98539799451828,0.012915999628603,126.97280883789,4.0396280288696,-22.020612716675)
    AddCameraShot(0.67745298147202,-0.041535001248121,0.73301601409912,0.044941999018192,97.517807006836,4.0396280288696,36.853477478027)
    AddCameraShot(0.86602902412415,-0.15650600194931,0.46729901432991,0.084449000656605,7.6856398582458,7.1306881904602,-10.895234107971)
end

