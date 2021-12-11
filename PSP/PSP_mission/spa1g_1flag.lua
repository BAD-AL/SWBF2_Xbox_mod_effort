--Extracted\spa1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    ctf = ObjectiveOneFlagCTF:New({ teamATT = IMP, teamDEF = ALL, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag", homeRegion = "home_1flag", captureRegionATT = "Team1capture", captureRegionDEF = "Team2capture", capRegionDummyObjectATT = "imp_cap_marker", capRegionDummyObjectDEF = "all_cap_marker", multiplayerRules = true, hideCPs = true, AIGoalWeight = 0 })
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    ctf:Start()
    AddAIGoal(ALL,"Deathmatch",100)
    AddAIGoal(IMP,"Deathmatch",100)
    SetProperty("MP_cp2","SpawnPath","CAM_CP2Spawn")
    SetProperty("MP_cp1","SpawnPath","CAM_CP1Spawn")
    DisableBarriers("impblock")
    BlockPlanningGraphArcs(1)
    SetProperty("ALL_Door01","IsLocked",1)
    SetProperty("ALL_Door02","IsLocked",1)
    SetProperty("spa1_prop_impDoor2","IsLocked",1)
    SetProperty("spa1_prop_impDoor3","IsLocked",1)
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2796341)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4850000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl","yav")
    ReadDataFile("sound\\spa.lvl;spa1gcw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("explosion","MaxDistance",15)
    ScaleSoundParameter("explosion","MuteDistance",15)
    SetMinFlyHeight(-490)
    SetMaxFlyHeight(1400)
    SetMinPlayerFlyHeight(-490)
    SetMaxPlayerFlyHeight(1400)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("SIDE\\all.lvl","all_inf_pilot","all_fly_xwing_sc","all_fly_ywing_sc","all_fly_awing")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_pilot","imp_fly_tiefighter_sc","imp_fly_tiebomber_sc","imp_fly_tieinterceptor")
    ClearWalkers()
    SetMemoryPoolSize("Aimer",170)
    SetMemoryPoolSize("AmmoCounter",218)
    SetMemoryPoolSize("BaseHint",25)
    SetMemoryPoolSize("Combo::DamageSample",128)
    SetMemoryPoolSize("EnergyBar",218)
    SetMemoryPoolSize("EntityFlyer",16)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityLight",106)
    SetMemoryPoolSize("EntityMine",8)
    SetMemoryPoolSize("EntitySoundStream",10)
    SetMemoryPoolSize("EntitySoundStatic",3)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",95)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",100)
    SetMemoryPoolSize("UnitAgent",74)
    SetMemoryPoolSize("UnitController",74)
    SetMemoryPoolSize("Weapon",218)
    SetupTeams({ 
        all =         { team = ALL, units = 10, reinforcements = -1, 
          pilot =           { "all_inf_pilot", 10 }
         }, 
        imp =         { team = IMP, units = 10, reinforcements = -1, 
          pilot =           { "imp_inf_pilot", 10 }
         }
       })
    SetSpawnDelay(10,0.25)
    ReadDataFile("spa\\spa1.lvl","spa1_CTF")
    SetDenseEnvironment("false")
    SetParticleLODBias(3000)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_spa_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_spa_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_spa_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_spa_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_spa_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_spa_amb_end",2,1)
    SetVictoryMusic(ALL,"all_spa_amb_victory")
    SetDefeatMusic(ALL,"all_spa_amb_defeat")
    SetVictoryMusic(IMP,"imp_spa_amb_victory")
    SetDefeatMusic(IMP,"imp_spa_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(IMP)
    AddCameraShot(0.60127598047256,0.010906999930739,-0.79883599281311,0.014491000212729,-2234.3544921875,-88.271575927734,-456.20977783203)
    AddCameraShot(0.82673400640488,-0.18764999508858,0.51721900701523,0.1173970028758,3129.375,1362.2141113281,1175.9616699219)
    AddCameraShot(0.80746299028397,-0.15978699922562,-0.55706399679184,-0.11023599654436,-3033.0405273438,1086.6322021484,1174.1828613281)
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")
if gPlatformStr == "PS2" then
end
    ScriptCB_DisableFlyerShadows()
end

