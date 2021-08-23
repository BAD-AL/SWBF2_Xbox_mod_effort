--Extracted\dea1c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
ATT = 1
DEF = 2
REP = ATT
CIS = DEF

function ScriptPostLoad()
    SetProperty("Dr-LeftMain","IsLocked",1)
    SetProperty("dea1_prop_door_blast0","IsLocked",1)
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
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
    StealArtistHeap(12 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(4000000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dea.lvl;dea1cw")
    SetMaxFlyHeight(72)
    SetMaxPlayerFlyHeight(72)
    AISnipeSuitabilityDist(30)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_droideka","cis_inf_officer")
    ReadDataFile("SIDE\\imp.lvl","imp_hero_emperor")
    SetAttackingTeam(ATT)
    SetupTeams({ 
        rep =         { team = REP, units = 16, reinforcements = -1, 
          soldier =           { "rep_inf_ep3_rifleman", 7, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }, 
        cis =         { team = CIS, units = 16, reinforcements = -1, 
          soldier =           { "cis_inf_rifleman", 7, 16 }, 
          assault =           { "cis_inf_rocketeer", 1, 4 }, 
          engineer =           { "cis_inf_engineer", 1, 4 }, 
          sniper =           { "cis_inf_sniper", 1, 4 }, 
          officer =           { "cis_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(REP,"rep_hero_obiwan")
    SetHeroClass(CIS,"imp_hero_emperor")
    ClearWalkers()
    AddWalkerType(0,3)
    SetMemoryPoolSize("Aimer",9)
    SetMemoryPoolSize("AmmoCounter",130)
    SetMemoryPoolSize("EnergyBar",130)
    SetMemoryPoolSize("EntityLight",170)
    SetMemoryPoolSize("EntitySoundStream",55)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",40)
    SetMemoryPoolSize("Obstacle",260)
    SetMemoryPoolSize("PathFollower",40)
    SetMemoryPoolSize("SoundSpaceRegion",105)
    SetMemoryPoolSize("UnitAgent",40)
    SetMemoryPoolSize("UnitController",40)
    SetMemoryPoolSize("Weapon",130)
    SetMemoryPoolSize("EntityFlyer",6)
    SetSpawnDelay(10,0.25)
    ReadDataFile("dea\\dea1.lvl","dea1_CTF-SingleFlag")
    SetDenseEnvironment("true")
    AddDeathRegion("DeathRegion01")
    AddDeathRegion("DeathRegion02")
    AddDeathRegion("DeathRegion03")
    AddDeathRegion("DeathRegion04")
    AddDeathRegion("DeathRegion05")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetOutOfBoundsVoiceOver(1,"Repleaving")
    SetOutOfBoundsVoiceOver(2,"Cisleaving")
    SetAmbientMusic(REP,1,"rep_dea_amb_start",0,1)
    SetAmbientMusic(REP,0.89999997615814,"rep_dea_amb_middle",1,1)
    SetAmbientMusic(REP,0.10000000149012,"rep_dea_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_dea_amb_start",0,1)
    SetAmbientMusic(CIS,0.89999997615814,"cis_dea_amb_middle",1,1)
    SetAmbientMusic(CIS,0.10000000149012,"cis_dea_amb_end",2,1)
    SetVictoryMusic(REP,"rep_dea_amb_victory")
    SetDefeatMusic(REP,"rep_dea_amb_defeat")
    SetVictoryMusic(CIS,"cis_dea_amb_victory")
    SetDefeatMusic(CIS,"cis_dea_amb_defeat")
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

