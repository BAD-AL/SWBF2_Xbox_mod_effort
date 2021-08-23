--Extracted\dag1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

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
    StealArtistHeap(256 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2852881)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(2497152 + 65536 * 0)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dag.lvl;dag1cw")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_officer","cis_inf_sniper","cis_inf_droideka","cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,3)
    SetMemoryPoolSize("Aimer",9)
    SetMemoryPoolSize("AmmoCounter",203)
    SetMemoryPoolSize("BaseHint",100)
    SetMemoryPoolSize("EnergyBar",203)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",1)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",157)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",203)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman", 4 }, 
              assault =               { "rep_inf_ep3_rocketeer", 2 }, 
              engineer =               { "rep_inf_ep3_engineer", 1 }, 
              sniper =               { "rep_inf_ep3_sniper", 1 }, 
              officer =               { "rep_inf_ep3_officer", 1 }, 
              special =               { "rep_inf_ep3_jettrooper", 1 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = 75, 
              soldier =               { "cis_inf_rifleman", 4 }, 
              assault =               { "cis_inf_rocketeer", 2 }, 
              engineer =               { "cis_inf_engineer", 1 }, 
              sniper =               { "cis_inf_sniper", 1 }, 
              officer =               { "cis_inf_officer", 1 }, 
              special =               { "cis_inf_droideka", 1 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = 150, 
              soldier =               { "rep_inf_ep3_rifleman", 11 }, 
              assault =               { "rep_inf_ep3_rocketeer", 4 }, 
              engineer =               { "rep_inf_ep3_engineer", 3 }, 
              sniper =               { "rep_inf_ep3_sniper", 2 }, 
              officer =               { "rep_inf_ep3_officer", 2 }, 
              special =               { "rep_inf_ep3_jettrooper", 3 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = 150, 
              soldier =               { "cis_inf_rifleman", 11 }, 
              assault =               { "cis_inf_rocketeer", 4 }, 
              engineer =               { "cis_inf_engineer", 3 }, 
              sniper =               { "cis_inf_sniper", 2 }, 
              officer =               { "cis_inf_officer", 2 }, 
              special =               { "cis_inf_droideka", 3 }
             }
           })
end
    SetHeroClass(REP,"rep_hero_yoda")
    SetHeroClass(CIS,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,3)
    SetSpawnDelay(10,0.25)
    ReadDataFile("dag\\dag1.lvl","dag1_conquest","dag1_cw")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.34999999403954)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_dag_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_dag_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_dag_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_dag_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_dag_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_dag_amb_end",2,1)
    SetVictoryMusic(REP,"rep_dag_amb_victory")
    SetDefeatMusic(REP,"rep_dag_amb_defeat")
    SetVictoryMusic(CIS,"cis_dag_amb_victory")
    SetDefeatMusic(CIS,"cis_dag_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.95341497659683,-0.062786996364594,0.29441800713539,0.019388999789953,20.468770980835,3.7800400257111,-110.41245269775)
    AddCameraShot(0.64612501859665,-0.080365002155304,0.75318497419357,0.093681998550892,41.348438262939,5.6880612373352,-52.695041656494)
    AddCameraShot(-0.44291099905968,0.055229000747204,-0.88798600435257,-0.11072800308466,39.894439697266,9.2341270446777,-59.177146911621)
    AddCameraShot(-0.038617998361588,0.0060410001315176,-0.98722797632217,-0.15444399416447,28.671710968018,10.001162528992,128.89218139648)
end

