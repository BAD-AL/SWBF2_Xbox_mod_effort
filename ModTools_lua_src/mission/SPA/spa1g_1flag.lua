-- SPACE 1 Battle over Yavin
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("LinkedTurrets")
 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
  

--  Empire Attacking (attacker is always #1)
IMP = 1
ALL = 2
--  These variables do not change
ATT = 1
DEF = 2

function ScriptPostLoad()
    PlayAnimation("CTF_circle")
    SetupTurrets()
--    DisableSmallMapMiniMap()
    ctf = ObjectiveOneFlagCTF:New{
        teamATT = IMP, teamDEF = ALL,
        -- need new text
        textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag", 
        homeRegion = "home_1flag", captureRegionATT = "Team1capture", captureRegionDEF = "Team2capture",
        capRegionDummyObjectATT = "imp_cap_marker", capRegionDummyObjectDEF = "all_cap_marker",
        multiplayerRules = true, hideCPs = true,
        AIGoalWeight = 0.0,
    }
    SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
    ctf:Start()
    
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)        
    SetProperty("MP_cp2", "SpawnPath", "CAM_CP2Spawn")
    SetProperty("MP_cp1", "SpawnPath", "CAM_CP1Spawn") 
    DisableBarriers("impblock")
    BlockPlanningGraphArcs (1)
    
    	-- Lock doors
	
	SetProperty("ALL_Door3", "IsLocked", 1)
	SetProperty("ALL_Door4", "IsLocked", 1)
	SetProperty("ALL_Door5", "IsLocked", 1)
	
	SetProperty("Impdoor01", "IsLocked", 1)
	SetProperty("Impdoor02", "IsLocked", 1)
	SetProperty("Impdoor03", "IsLocked", 1)
	
		-- Show lights
	
	SetProperty( "imp_eng_lightg", "IsVisible", 0)
	SetProperty( "imp_shi_lightg", "IsVisible", 0)
	SetProperty( "imp_lif_lightg", "IsVisible", 0)
	
	SetProperty( "all_eng_lightg", "IsVisible", 0)
	SetProperty( "all_shi_lightg", "IsVisible", 0)
	SetProperty( "all_lif_lightg", "IsVisible", 0)    
	
		-- Frigate work
	OnObjectKillName(IMPM1_turr, "IMP_mini01");
	OnObjectKillName(ALLM2_turr, "cor01");    
end
 
-- Frigates Listing

function IMPM1_turr()
	KillObject("mpit10");
	KillObject("mpit11");
	KillObject("mpit12");
	DeleteEntity("mpit10");
	DeleteEntity("mpit11");
	DeleteEntity("mpit12");
end

function ALLM2_turr()
	KillObject("mpat10");
	KillObject("mpat11");
	KillObject("mpat12");
	DeleteEntity("mpat10");
	DeleteEntity("mpat11");
	DeleteEntity("mpat12");
end

function ScriptPreInit()
   SetWorldExtents(2060)
end
 
function SetupTurrets() 
    --ALL turrets
    turretLinkageALL = LinkedTurrets:New{ team = ALL, mainframe = "autodefense_all", 
                                          turrets = {"mpat1","mpat3", "mpat5",
                                                     "mpat6", "mpat7", "mpat8"} }
    turretLinkageALL:Init()
    function turretLinkageALL:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", IMP)
        ShowMessageText("level.spa.hangar.mainframe.def.down", ALL)
        
        BroadcastVoiceOver( "IOSMP_obj_20", IMP )
        BroadcastVoiceOver( "AOSMP_obj_21", ALL )
    end
    function turretLinkageALL:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", IMP)
        ShowMessageText("level.spa.hangar.mainframe.def.up", ALL)
        
		BroadcastVoiceOver( "IOSMP_obj_22", IMP )
		BroadcastVoiceOver( "AOSMP_obj_23", ALL )

    end
    
    --IMP turrets
    turretLinkageIMP = LinkedTurrets:New{ team = IMP, mainframe = "autodefense_imp",
                                          turrets = {"mpit1","mpit3", "mpit4",
                                                     "mpit5", "mpit7", "mpit9"} }
    turretLinkageIMP:Init()
  function turretLinkageIMP:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", ALL)
        ShowMessageText("level.spa.hangar.mainframe.def.down", IMP)
		
		BroadcastVoiceOver( "IOSMP_obj_21", IMP )
		BroadcastVoiceOver( "AOSMP_obj_20", ALL )

    end
    function turretLinkageIMP:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", ALL)
        ShowMessageText("level.spa.hangar.mainframe.def.up", IMP)
        
        BroadcastVoiceOver( "IOSMP_obj_23", IMP )
        BroadcastVoiceOver( "AOSMP_obj_22", ALL )
    end
end

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     StealArtistHeap(1024*1024)
     SetPS2ModelMemory(4850000)
     ReadDataFile("ingame.lvl")
     ReadDataFile("SPA\\spa_sky.lvl", "yav")     

     ReadDataFile("sound\\spa.lvl;spa1gcw")
     ScriptCB_SetDopplerFactor(0.4)
     ScaleSoundParameter("tur_weapons",   "MinDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MaxDistance",   3.0);
     ScaleSoundParameter("tur_weapons",   "MuteDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MinDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MaxDistance",   3.0);
     ScaleSoundParameter("Ordnance_Large",   "MuteDistance",   3.0);
     ScaleSoundParameter("explosion",   "MaxDistance",   5.0);
     ScaleSoundParameter("explosion",   "MuteDistance",  5.0);

     SetMinFlyHeight(-1900)
     SetMaxFlyHeight(2000)
     SetMinPlayerFlyHeight(-1900)
     SetMaxPlayerFlyHeight(2000)
     SetAIVehicleNotifyRadius(100)

     ReadDataFile("SIDE\\all.lvl",
        "all_inf_pilot",
        "all_inf_marine",
        "all_fly_xwing_sc",
        "all_fly_ywing_sc",
        "all_fly_awing")
     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_pilot",
        "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor")
        
     ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_all_recoilless",
        "tur_bldg_spa_all_beam",
        "tur_bldg_spa_imp_recoilless",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_chaingun_roof")

     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     local weaponCnt = 260
     SetMemoryPoolSize ("Aimer", 200)
     SetMemoryPoolSize ("AmmoCounter", weaponCnt)
     SetMemoryPoolSize ("BaseHint", 60)
     SetMemoryPoolSize ("Combo::DamageSample", 128)
--     SetMemoryPoolSize ("CommandFlyer",2)
     SetMemoryPoolSize ("EnergyBar", weaponCnt)
     SetMemoryPoolSize ("EntityFlyer",32)
     SetMemoryPoolSize ("EntityDroid",0)
     SetMemoryPoolSize ("EntityLight",110)
     SetMemoryPoolSize ("EntityMine", 16)
     SetMemoryPoolSize ("EntityRemoteTerminal",12)
     SetMemoryPoolSize ("EntitySoundStream", 12)
     SetMemoryPoolSize ("EntitySoundStatic", 3)
     SetMemoryPoolSize ("FLEffectObject::OffsetMatrix", 100)
     SetMemoryPoolSize ("FlagItem", 1)
     SetMemoryPoolSize ("MountedTurret",65)
     SetMemoryPoolSize ("Navigator", 32)
     SetMemoryPoolSize ("Obstacle", 120)
     SetMemoryPoolSize ("PathFollower", 32)
     SetMemoryPoolSize ("PathNode", 128)
     SetMemoryPoolSize ("TentacleSimulator", 0)
     SetMemoryPoolSize ("TreeGridStack", 200)
     SetMemoryPoolSize ("UnitAgent",74)
     SetMemoryPoolSize ("UnitController",74)
     SetMemoryPoolSize ("Weapon", weaponCnt)
     
    --if(gPlatformStr == "XBox") then 
    --     SetMemoryPoolSize ("Asteroid", 264)
    --elseif( gPlatformStr == "PS2") then
--         SetMemoryPoolSize ("Asteroid", 109)
    --else -- PC
    --     SetMemoryPoolSize ("Asteroid", 204)
    --end

SetupTeams{

         all = {
            team = ALL,
            units = 32,
            reinforcements = -1,
            pilot    = { "all_inf_pilot",32},
--            marine   = { "all_inf_marine",4},
        },

        imp = {
            team = IMP,
            units = 32,
            reinforcements = -1,
            pilot    = { "imp_inf_pilot",32},
--            marine   = { "imp_inf_marine",4},

        }
     }

     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("spa\\spa1.lvl", "spa1_CTF")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregionimp")
     AddDeathRegion("deathregionall")
     --SetStayInTurrets(1)
     
     
    SetParticleLODBias(3000)
     
    --if(gPlatformStr == "XBox") then 
         --SetMaxCollisionDistance(1500)
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_01", 40, 1.0,0.0,0.0, -1.0,0.0,0.0);
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_02", 60, 1.0,0.0,0.0, -1.0,0.0,0.0);
        ----FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_03", 10, 1.0,0.0,0.0, 1.0,0.0,0.0);
        --FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01a", 50, 1.0,0.0,0.0, -1.0,0.0,0.0);
        --FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01", 100, 1.0,0.0,0.0, -1.0,0.0,0.0);    
    --elseif( gPlatformStr == "PS2") then
         SetMaxCollisionDistance(1000)
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_01", 20, 1.0,0.0,0.0, -1.0,0.0,0.0);
        FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_02", 30, 1.0,0.0,0.0, -1.0,0.0,0.0);
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_03", 10, 1.0,0.0,0.0, 1.0,0.0,0.0);
        --FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01a", 50, 1.0,0.0,0.0, -1.0,0.0,0.0);
        FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01", 75, 1.0,0.0,0.0, -1.0,0.0,0.0); 
    --else -- PC
         --SetMaxCollisionDistance(2000)
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_01", 40, 1.0,0.0,0.0, -1.0,0.0,0.0);
        --FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_02", 30, 1.0,0.0,0.0, -1.0,0.0,0.0);
        ----FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_03", 10, 1.0,0.0,0.0, 1.0,0.0,0.0);
        --FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01a", 50, 1.0,0.0,0.0, 1.0,0.0,0.0);
        --FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01", 80, 1.0,0.0,0.0, -1.0,0.0,0.0);
    
    --end
     
    
    

     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

    --  Sound Stats
    local voiceSlow = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    local voiceQuick = OpenAudioStream("sound\\global.lvl", "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_quick", voiceQuick)    
    
    -- OpenAudioStream("sound\\spa.lvl",  "spa1_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\spa.lvl",  "spa")
    OpenAudioStream("sound\\spa.lvl",  "spa")
    
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)
    
    SetOutOfBoundsVoiceOver(ALL, "allleaving")
    SetOutOfBoundsVoiceOver(IMP, "impleaving")
    
    SetAmbientMusic(ALL, 1.0, "all_spa_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.99, "all_spa_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1,"all_spa_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_spa_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.99, "imp_spa_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1,"imp_spa_amb_end",    2,1)
    
    SetVictoryMusic(ALL, "all_spa_amb_victory")
    SetDefeatMusic (ALL, "all_spa_amb_defeat")
    SetVictoryMusic(IMP, "imp_spa_amb_victory")
    SetDefeatMusic (IMP, "imp_spa_amb_defeat")
    
    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
    
    SetAttackingTeam(IMP)

    --Star Dest far
	AddCameraShot(0.792356, 0.005380, -0.610022, 0.004142, -1083.259766, 205.730942, 524.492249);
	--All Cru far
	AddCameraShot(-0.362954, -0.002066, -0.931790, 0.005304, -149.122910, -97.288933, -1759.549927);
	--All Cru Angle
	AddCameraShot(0.599707, -0.046312, 0.796507, 0.061510, 544.123230, 93.926430, -522.673523);
	--Star Dest Angle
    AddCameraShot(0.181770, -0.005491, -0.982877, -0.029689, -16.614826, 307.607605, -2127.639648);
    
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")
     
    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end
 end
