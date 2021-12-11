--Extracted\spa3c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetClassProperty("com_item_flag","DroppedColorize",1)
    ctf = ObjectiveOneFlagCTF:New({ teamATT = REP, teamDEF = CIS, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag", homeRegion = "home_1flag", captureRegionATT = "Team1capture", captureRegionDEF = "Team2capture", capRegionDummyObjectATT = "rep_cap_marker", capRegionDummyObjectDEF = "cis_cap_marker", multiplayerRules = true, hideCPs = true, AIGoalWeight = 0 })
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
    ctf:Start()
    AddAIGoal(REP,"Deathmatch",100)
    AddAIGoal(CIS,"Deathmatch",100)
    SetProperty("repdoor01","IsLocked",1)
    SetProperty("repdoor02","IsLocked",1)
    SetProperty("cisdoor01","IsLocked",1)
    SetProperty("cisdoor02","IsLocked",1)
end

function ScriptPreInit()
    SetWorldExtents(1900)
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3398709)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4897152)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl","kas")
    SetMinFlyHeight(-1900)
    SetMaxFlyHeight(2000)
    SetMinPlayerFlyHeight(-1900)
    SetMaxPlayerFlyHeight(2000)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile("sound\\spa.lvl;spa2cw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("tur_weapons","MinDistance",3)
    ScaleSoundParameter("tur_weapons","MaxDistance",3)
    ScaleSoundParameter("tur_weapons","MuteDistance",3)
    ScaleSoundParameter("Ordnance_Large","MinDistance",3)
    ScaleSoundParameter("Ordnance_Large","MaxDistance",3)
    ScaleSoundParameter("Ordnance_Large","MuteDistance",3)
    ScaleSoundParameter("explosion","MaxDistance",5)
    ScaleSoundParameter("explosion","MuteDistance",5)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_pilot","rep_inf_ep3_marine","rep_fly_assault_dome","rep_fly_anakinstarfighter_sc","rep_fly_arc170fighter_sc","rep_fly_arc170fighter_dome","rep_fly_vwing")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_pilot","cis_inf_marine","cis_fly_fedlander_dome","cis_fly_droidfighter_sc","cis_fly_droidfighter_dome","cis_fly_greviousfighter","cis_fly_tridroidfighter")
    SetupTeams({ 
        rep =         { team = REP, units = 10, reinforcements = -1, 
          pilot =           { "rep_inf_ep3_pilot", 10 }
         }, 
        cis =         { team = CIS, units = 10, reinforcements = -1, 
          pilot =           { "cis_inf_pilot", 10 }
         }
       })
    ClearWalkers()
    SetMemoryPoolSize("Aimer",350)
    SetMemoryPoolSize("AmmoCounter",240)
    SetMemoryPoolSize("BaseHint",100)
    SetMemoryPoolSize("EnergyBar",240)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityFlyer",32)
    SetMemoryPoolSize("EntityLight",90)
    SetMemoryPoolSize("EntityMine",32)
    SetMemoryPoolSize("EntitySoundStream",48)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",100)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("Obstacle",120)
    SetMemoryPoolSize("PathNode",48)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitController",90)
    SetMemoryPoolSize("UnitAgent",90)
    SetMemoryPoolSize("Weapon",240)
    SetSpawnDelay(10,0.25)
    ReadDataFile("spa\\spa3.lvl","spa3_ctf")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregionrep")
    AddDeathRegion("deathregioncis")
    SetParticleLODBias(15000)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_spa_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_spa_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_spa_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_spa_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_spa_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_spa_amb_end",2,1)
    SetVictoryMusic(REP,"rep_spa_amb_victory")
    SetDefeatMusic(REP,"rep_spa_amb_defeat")
    SetVictoryMusic(CIS,"cis_spa_amb_victory")
    SetDefeatMusic(CIS,"cis_spa_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.88363897800446,0.016758000478148,0.46778398752213,-0.0088710002601147,1672.0329589844,-31.176574707031,1387.6154785156)
    AddCameraShot(0.35074201226234,-0.091416001319885,-0.90187001228333,-0.23506000638008,-498.75271606445,687.47259521484,-321.35546875)
    AddCameraShot(0.65571999549866,0.027096999809146,0.75387400388718,-0.031153999269009,2194.9572753906,42.904609680176,52.765270233154)
    AddCameraShot(-0.13501699268818,-0.00073099997825921,-0.99082797765732,0.0053630000911653,85.703605651855,172.40002441406,45.056175231934)
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")
if gPlatformStr == "PS2" then
end
    ScriptCB_DisableFlyerShadows()
end

