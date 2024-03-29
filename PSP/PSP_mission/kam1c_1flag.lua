--Extracted\kam1c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")

function ScriptPostLoad()
    KillObject("cp2")
    KillObject("cp1")
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
    SetAIDamageThreshold("Comp1",0)
    SetAIDamageThreshold("Comp2",0)
    SetAIDamageThreshold("Comp3",0)
    SetAIDamageThreshold("Comp4",0)
    SetAIDamageThreshold("Comp5",0)
    SetProperty("Kam_Bldg_Podroom_Door32","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door33","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door32","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door34","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door35","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door27","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door28","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door36","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door20","Islocked",1)
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
    EnableSPHeroRules()
    SoundEvent_SetupTeams(1,"rep",2,"cis")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "lag_capture2", captureRegionDEF = "lag_capture1", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, hideCPs = true, multiplayerRules = true })
    ctf:Start()
end

function ScriptInit()
    StealArtistHeap(256 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3000000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\kam.lvl;kam1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_jettrooper","rep_hero_obiwan","rep_inf_ep3_officer")
    ReadDataFile("SIDE\\cis.lvl","cis_fly_fedlander_dome","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hero_jangofett","cis_inf_droideka","CIS_inf_officer")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_chaingun_roof","tur_weap_built_gunturret")
    SetAttackingTeam(1)
    SetupTeams({ 
        REP =         { team = 1, units = 20, reinforcements = -1, 
          soldier =           { "rep_inf_ep3_rifleman", 9, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }
       })
    SetupTeams({ 
        CIS =         { team = 2, units = 20, reinforcements = -1, 
          soldier =           { "CIS_inf_rifleman", 9, 16 }, 
          assault =           { "CIS_inf_rocketeer", 1, 4 }, 
          engineer =           { "CIS_inf_engineer", 1, 4 }, 
          sniper =           { "CIS_inf_sniper", 1, 4 }, 
          officer =           { "CIS_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(1,"rep_hero_obiwan")
    SetHeroClass(2,"cis_hero_jangofett")
    ClearWalkers()
    AddWalkerType(0,4)
    SetMemoryPoolSize("Aimer",50)
    SetMemoryPoolSize("AmmoCounter",240)
    SetMemoryPoolSize("BaseHint",250)
    SetMemoryPoolSize("EnergyBar",240)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntityLight",74)
    SetMemoryPoolSize("EntitySoundStream",3)
    SetMemoryPoolSize("EntitySoundStatic",80)
    SetMemoryPoolSize("FlagItem",3)
    SetMemoryPoolSize("MountedTurret",22)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",800)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("SoundSpaceRegion",36)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("TreeGridStack",338)
    SetMemoryPoolSize("Weapon",240)
    SetSpawnDelay(10,0.25)
    ReadDataFile("KAM\\kam1.lvl","kamino1_1CTF")
    SetDenseEnvironment("false")
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
    SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
    SetAllowBlindJetJumps(0)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(1,1,"rep_kam_amb_start",0,1)
    SetAmbientMusic(1,0.89999997615814,"rep_kam_amb_middle",1,1)
    SetAmbientMusic(1,0.10000000149012,"rep_kam_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_kam_amb_start",0,1)
    SetAmbientMusic(2,0.89999997615814,"cis_kam_amb_middle",1,1)
    SetAmbientMusic(2,0.10000000149012,"cis_kam_amb_end",2,1)
    SetVictoryMusic(1,"rep_kam_amb_victory")
    SetDefeatMusic(1,"rep_kam_amb_defeat")
    SetVictoryMusic(2,"cis_kam_amb_victory")
    SetDefeatMusic(2,"cis_kam_amb_defeat")
    SetOutOfBoundsVoiceOver(1,"repleaving")
    SetOutOfBoundsVoiceOver(2,"cisleaving")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(1)
    AddDeathRegion("deathregion")
    AddCameraShot(0.19047799706459,-0.010944999754429,-0.98001402616501,-0.056311998516321,-26.091287612915,55.96501159668,159.45809936523)
end

