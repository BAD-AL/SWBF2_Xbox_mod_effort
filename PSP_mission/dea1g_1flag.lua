--Extracted\dea1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
ATT = 1
DEF = 2
ALL = ATT
IMP = DEF

function ScriptPostLoad()
    SetProperty("Dr-LeftMain","IsLocked",1)
    SetProperty("dea1_prop_door_blast0","IsLocked",1)
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    PlayAnimExtend()
    PlayAnimTakExtend()
    BlockPlanningGraphArcs("compactor")
    OnObjectKillName(CompactorConnectionOn,"grate01")
    DisableBarriers("start_room_barrier")
    DisableBarriers("dr_left")
    DisableBarriers("circle_bar1")
    DisableBarriers("circle_bar2")
    OnObjectRespawnName(PlayAnimExtend,"Panel-Chasm")
    OnObjectKillName(PlayAnimRetract,"Panel-Chasm")
    OnObjectRespawnName(PlayAnimTakExtend,"Panel-Tak")
    OnObjectKillName(PlayAnimTakRetract,"Panel-Tak")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "Flag_Home", captureRegionATT = "Team2Cap", captureRegionDEF = "Team1Cap", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true, hideCPs = true })
    ctf:Start()
    EnableSPHeroRules()
end

function CompactorConnectionOn()
    UnblockPlanningGraphArcs("compactor")
end

function PlayAnimExtend()
    PauseAnimation("bridgeclose")
    RewindAnimation("bridgeopen")
    PlayAnimation("bridgeopen")
    UnblockPlanningGraphArcs("Connection122")
    DisableBarriers("BridgeBarrier")
end

function PlayAnimRetract()
    PauseAnimation("bridgeopen")
    RewindAnimation("bridgeclose")
    PlayAnimation("bridgeclose")
    BlockPlanningGraphArcs("Connection122")
    EnableBarriers("BridgeBarrier")
end

function PlayAnimTakExtend()
    PauseAnimation("TakBridgeOpen")
    RewindAnimation("TakBridgeClose")
    PlayAnimation("TakBridgeClose")
    UnblockPlanningGraphArcs("Connection128")
    DisableBarriers("Barrier222")
end

function PlayAnimTakRetract()
    PauseAnimation("TakBridgeClose")
    RewindAnimation("TakBridgeOpen")
    PlayAnimation("TakBridgeOpen")
    BlockPlanningGraphArcs("Connection128")
    EnableBarriers("Barrier222")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4000000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dea.lvl;dea1gcw")
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight(72)
    AISnipeSuitabilityDist(30)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_fleet","all_inf_rocketeer_fleet","all_inf_engineer_fleet","all_inf_sniper_fleet","all_inf_officer","all_hero_luke_jedi","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper")
    ReadDataFile("SIDE\\imp.lvl","imp_hero_emperor")
    SetupTeams({ 
        all =         { team = ALL, units = 16, reinforcements = -1, 
          soldier =           { "all_inf_rifleman_fleet", 7, 16 }, 
          assault =           { "all_inf_rocketeer_fleet", 1, 4 }, 
          engineer =           { "all_inf_engineer_fleet", 1, 4 }, 
          sniper =           { "all_inf_sniper_fleet", 1, 4 }, 
          officer =           { "all_inf_officer", 1, 4 }, 
          special =           { "all_inf_wookiee", 1, 4 }
         }, 
        imp =         { team = IMP, units = 16, reinforcements = -1, 
          soldier =           { "imp_inf_rifleman", 7, 16 }, 
          assault =           { "imp_inf_rocketeer", 1, 4 }, 
          engineer =           { "imp_inf_engineer", 1, 4 }, 
          sniper =           { "imp_inf_sniper", 1, 4 }, 
          officer =           { "imp_inf_officer", 1, 4 }, 
          special =           { "imp_inf_dark_trooper", 1, 4 }
         }
       })
    SetHeroClass(ALL,"all_hero_luke_jedi")
    SetHeroClass(IMP,"imp_hero_emperor")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",2)
    SetMemoryPoolSize("AmmoCounter",260)
    SetMemoryPoolSize("BaseHint",300)
    SetMemoryPoolSize("EnergyBar",260)
    SetMemoryPoolSize("EntityCloth",21)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",170)
    SetMemoryPoolSize("EntitySoundStream",8)
    SetMemoryPoolSize("EntitySoundStatic",12)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("MountedTurret",2)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",270)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("RedOmniLight",130)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("SoundSpaceRegion",105)
    SetMemoryPoolSize("TentacleSimulator",8)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("dea\\dea1.lvl","dea1_CTF-SingleFlag")
    SetDenseEnvironment("true")
    AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetOutOfBoundsVoiceOver(1,"allleaving")
    SetOutOfBoundsVoiceOver(2,"impleaving")
    SetAmbientMusic(ALL,1,"all_dea_amb_start",0,1)
    SetAmbientMusic(ALL,0.89999997615814,"all_dea_amb_middle",1,1)
    SetAmbientMusic(ALL,0.10000000149012,"all_dea_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_dea_amb_start",0,1)
    SetAmbientMusic(IMP,0.89999997615814,"imp_dea_amb_middle",1,1)
    SetAmbientMusic(IMP,0.10000000149012,"imp_dea_amb_end",2,1)
    SetVictoryMusic(ALL,"all_dea_amb_victory")
    SetDefeatMusic(ALL,"all_dea_amb_defeat")
    SetVictoryMusic(IMP,"imp_dea_amb_victory")
    SetDefeatMusic(IMP,"imp_dea_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.99765402078629,0.066982001066208,0.014139000326395,-0.00094900000840425,155.1371307373,0.91150498390198,-138.07707214355)
    AddCameraShot(0.72976100444794,0.019262000918388,0.68319398164749,-0.018032999709249,-98.584869384766,0.29528400301933,263.23928833008)
    AddCameraShot(0.69427698850632,0.0051000001840293,0.71967101097107,-0.0052869999781251,-11.105946540833,-2.7532069683075,67.982200622559)
end

