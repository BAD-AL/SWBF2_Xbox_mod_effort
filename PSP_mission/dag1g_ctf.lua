--Extracted\dag1g_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetProperty("ctf_flag1","GeometryName","com_icon_alliance_flag")
    SetProperty("ctf_flag1","CarriedGeometryName","com_icon_alliance_flag_carried")
    SetProperty("ctf_flag2","GeometryName","com_icon_imperial_flag")
    SetProperty("ctf_flag2","CarriedGeometryName","com_icon_imperial_flag_carried")
    SetProperty("flag2_effect","Team",2)
    SetProperty("flag1_effect","Team",1)
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    SoundEvent_SetupTeams(2,"imp",1,"all")
    ctf:Start()
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
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_jungle","all_inf_rocketeer_jungle","all_inf_engineer","all_inf_sniper_jungle","all_inf_officer","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_darthvader")
    ReadDataFile("SIDE\\rep.lvl","rep_hero_yoda")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",0)
    SetMemoryPoolSize("AmmoCounter",140)
    SetMemoryPoolSize("BaseHint",70)
    SetMemoryPoolSize("EnergyBar",140)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",1)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",157)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",140)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_jungle", 4 }, 
              assault =               { "all_inf_rocketeer_jungle", 2 }, 
              engineer =               { "all_inf_engineer", 1 }, 
              sniper =               { "all_inf_sniper_jungle", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = 250, 
              soldier =               { "all_inf_rifleman_jungle", 10 }, 
              assault =               { "all_inf_rocketeer_jungle", 3 }, 
              engineer =               { "all_inf_engineer", 3 }, 
              sniper =               { "all_inf_sniper_jungle", 3 }, 
              officer =               { "all_inf_officer", 3 }, 
              special =               { "all_inf_wookiee", 3 }
             }, 
            imp =             { team = IMP, units = 25, reinforcements = 250, 
              soldier =               { "imp_inf_rifleman", 10 }, 
              assault =               { "imp_inf_rocketeer", 3 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 3 }, 
              officer =               { "imp_inf_officer", 3 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }
           })
end
    SetHeroClass(ALL,"rep_hero_yoda")
    SetHeroClass(IMP,"imp_hero_darthvader")
    SetSpawnDelay(10,0.25)
    ReadDataFile("dag\\dag1.lvl","dag1_ctf","dag1_gcw")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.34999999403954)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_dag_amb_start",0,1)
    SetAmbientMusic(ALL,0.89999997615814,"all_dag_amb_middle",1,1)
    SetAmbientMusic(ALL,0.10000000149012,"all_dag_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_dag_amb_start",0,1)
    SetAmbientMusic(IMP,0.89999997615814,"imp_dag_amb_middle",1,1)
    SetAmbientMusic(IMP,0.10000000149012,"imp_dag_amb_end",2,1)
    SetVictoryMusic(ALL,"all_dag_amb_victory")
    SetDefeatMusic(ALL,"all_dag_amb_defeat")
    SetVictoryMusic(IMP,"imp_dag_amb_victory")
    SetDefeatMusic(IMP,"imp_dag_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.95341497659683,-0.062786996364594,0.29441800713539,0.019388999789953,20.468770980835,3.7800400257111,-110.41245269775)
    AddCameraShot(0.64612501859665,-0.080365002155304,0.75318497419357,0.093681998550892,41.348438262939,5.6880612373352,-52.695041656494)
    AddCameraShot(-0.44291099905968,0.055229000747204,-0.88798600435257,-0.11072800308466,39.894439697266,9.2341270446777,-59.177146911621)
    AddCameraShot(-0.038617998361588,0.0060410001315176,-0.98722797632217,-0.15444399416447,28.671710968018,10.001162528992,128.89218139648)
end

