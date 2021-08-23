--Extracted\dag1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")

function ScriptPostLoad()
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp4 = CommandPost:New({ name = "cp4" })
    cp5 = CommandPost:New({ name = "cp5" })
    cp6 = CommandPost:New({ name = "cp6" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    EnableSPHeroRules()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2605129)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(2500000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dag.lvl;dag1gcw")
    SetNumBirdTypes(2)
    SetBirdType(0,1,"bird")
    SetBirdType(1,1.5,"bird2")
    SetNumFishTypes(1)
    SetFishType(0,0.80000001192093,"fish")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_jungle","all_inf_rocketeer_jungle","all_inf_engineer","all_inf_sniper_jungle","all_inf_officer","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_darthvader")
    ReadDataFile("SIDE\\rep.lvl","rep_hero_yoda")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",0)
    SetMemoryPoolSize("AmmoCounter",150)
    SetMemoryPoolSize("BaseHint",55)
    SetMemoryPoolSize("EnergyBar",150)
    SetMemoryPoolSize("EntityCloth",20)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",1)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",157)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",150)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = 1, units = 10, reinforcements = 125, 
              soldier =               { "all_inf_rifleman_jungle", 4 }, 
              assault =               { "all_inf_rocketeer_jungle", 2 }, 
              engineer =               { "all_inf_engineer", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              sniper =               { "all_inf_sniper_jungle", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }, 
            imp =             { team = 2, units = 10, reinforcements = 125, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }
           })
else
        SetupTeams({ 
            all =             { team = 1, units = 25, reinforcements = 250, 
              soldier =               { "all_inf_rifleman_jungle", 10 }, 
              assault =               { "all_inf_rocketeer_jungle", 3 }, 
              engineer =               { "all_inf_engineer", 3 }, 
              sniper =               { "all_inf_sniper_jungle", 3 }, 
              officer =               { "all_inf_officer", 3 }, 
              special =               { "all_inf_wookiee", 3 }
             }, 
            imp =             { team = 2, units = 25, reinforcements = 250, 
              soldier =               { "imp_inf_rifleman", 10 }, 
              assault =               { "imp_inf_rocketeer", 3 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 3 }, 
              officer =               { "imp_inf_officer", 3 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }
           })
end
    SetHeroClass(1,"rep_hero_yoda")
    SetHeroClass(2,"imp_hero_darthvader")
    SetSpawnDelay(10,0.25)
    ReadDataFile("dag\\dag1.lvl","dag1_conquest","dag1_gcw")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.34999999403954)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(1,1,"all_dag_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"all_dag_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"all_dag_amb_end",2,1)
    SetAmbientMusic(2,1,"imp_dag_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"imp_dag_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"imp_dag_amb_end",2,1)
    SetVictoryMusic(1,"all_dag_amb_victory")
    SetDefeatMusic(1,"all_dag_amb_defeat")
    SetVictoryMusic(2,"imp_dag_amb_victory")
    SetDefeatMusic(2,"imp_dag_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(1)
    AddCameraShot(0.95341497659683,-0.062786996364594,0.29441800713539,0.019388999789953,20.468770980835,3.7800400257111,-110.41245269775)
    AddCameraShot(0.64612501859665,-0.080365002155304,0.75318497419357,0.093681998550892,41.348438262939,5.6880612373352,-52.695041656494)
    AddCameraShot(-0.44291099905968,0.055229000747204,-0.88798600435257,-0.11072800308466,39.894439697266,9.2341270446777,-59.177146911621)
    AddCameraShot(-0.038617998361588,0.0060410001315176,-0.98722797632217,-0.15444399416447,28.671710968018,10.001162528992,128.89218139648)
end

