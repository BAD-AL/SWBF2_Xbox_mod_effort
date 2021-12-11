--Extracted\kam1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ATT = 1
DEF = 2
IMP = ATT
ALL = DEF

function ScriptPostLoad()
    KillObject("cp2")
    KillObject("cp1")
    SetProperty("cp11","IsVisible","1")
    SetProperty("cp11","Team","2")
    SetProperty("cp22","Team","1")
    SetProperty("cp22","SpawnPath","NEW")
    SetProperty("cp22","captureregion","death")
    SetProperty("cp11","captureregion","death")
    SetProperty("CP4","HUDIndexDisplay",0)
    KillObject("cp3")
    KillObject("CP4")
    KillObject("CP5")
    SetProperty("FDL-2","IsLocked",1)
    SetProperty("cp6","Team","2")
    SetProperty("cp7","Team","1")
    UnblockPlanningGraphArcs("connection71")
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("open")
    UnblockPlanningGraphArcs("connection194")
    UnblockPlanningGraphArcs("connection200")
    UnblockPlanningGraphArcs("connection118")
    DisableBarriers("FRONTDOOR2-3")
    DisableBarriers("FRONTDOOR2-1")
    DisableBarriers("FRONTDOOR2-2")
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
    DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")
    DisableBarriers("FRONTDOOR1-2")
    SetProperty("flag1","GeometryName","com_icon_alliance")
    SetProperty("flag1","CarriedGeometryName","com_icon_alliance")
    SetProperty("flag2","GeometryName","com_icon_imperial")
    SetProperty("flag2","CarriedGeometryName","com_icon_imperial")
    SetClassProperty("com_item_flag","DroppedColorize",1)
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "lag_capture2", captureRegionDEF = "lag_capture1", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, hideCPs = true, multiplayerRules = true })
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    SetProperty("cp4","IsVisible",0)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3400000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\kam.lvl;kam1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_urban","all_inf_rocketeer_fleet","all_inf_sniper_fleet","all_inf_engineer_fleet","all_hero_hansolo_tat","all_inf_wookiee","all_inf_officer")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_dark_trooper","imp_hero_bobafett","imp_inf_officer")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_chaingun_roof","tur_weap_built_gunturret")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",22)
    SetMemoryPoolSize("AmmoCounter",200)
    SetMemoryPoolSize("EnergyBar",200)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityCloth",34)
    SetMemoryPoolSize("EntityLight",67)
    SetMemoryPoolSize("FlagItem",3)
    SetMemoryPoolSize("MountedTurret",22)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",706)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("EntitySoundStream",3)
    SetMemoryPoolSize("SoundSpaceRegion",36)
    SetMemoryPoolSize("EntitySoundStatic",80)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",400)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",200)
    SetupTeams({ 
        all =         { team = ALL, units = 20, reinforcements = -1, 
          soldier =           { "all_inf_rifleman_urban", 9, 16 }, 
          assault =           { "all_inf_rocketeer_fleet", 1, 4 }, 
          engineer =           { "all_inf_engineer_fleet", 1, 4 }, 
          sniper =           { "all_inf_sniper_fleet", 1, 4 }, 
          officer =           { "all_inf_officer", 1, 4 }, 
          special =           { "all_inf_wookiee", 1, 4 }
         }
       })
    SetupTeams({ 
        imp =         { team = IMP, units = 20, reinforcements = -1, 
          soldier =           { "imp_inf_rifleman", 9, 16 }, 
          assault =           { "imp_inf_rocketeer", 1, 4 }, 
          engineer =           { "imp_inf_engineer", 1, 4 }, 
          sniper =           { "imp_inf_sniper", 1, 4 }, 
          officer =           { "imp_inf_officer", 1, 4 }, 
          special =           { "imp_inf_dark_trooper", 1, 4 }
         }
       })
    SetHeroClass(ALL,"all_hero_hansolo_tat")
    SetHeroClass(IMP,"imp_hero_bobafett")
    SetSpawnDelay(10,0.25)
    ReadDataFile("KAM\\kam1.lvl","KAMINO1_1ctf")
    SetDenseEnvironment("false")
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
    SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetOutOfBoundsVoiceOver(1,"allleaving")
    SetOutOfBoundsVoiceOver(2,"impleaving")
    SetAmbientMusic(ALL,1,"all_mus_amb_start",0,1)
    SetAmbientMusic(ALL,0.89999997615814,"all_mus_amb_middle",1,1)
    SetAmbientMusic(ALL,0.10000000149012,"all_mus_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_mus_amb_start",0,1)
    SetAmbientMusic(IMP,0.89999997615814,"imp_mus_amb_middle",1,1)
    SetAmbientMusic(IMP,0.10000000149012,"imp_mus_amb_end",2,1)
    SetVictoryMusic(ALL,"all_mus_amb_victory")
    SetDefeatMusic(ALL,"all_mus_amb_defeat")
    SetVictoryMusic(IMP,"imp_mus_amb_victory")
    SetDefeatMusic(IMP,"imp_mus_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddDeathRegion("deathregion")
    AddCameraShot(0.19047799706459,-0.010944999754429,-0.98001402616501,-0.056311998516321,-26.091287612915,55.96501159668,159.45809936523)
end

