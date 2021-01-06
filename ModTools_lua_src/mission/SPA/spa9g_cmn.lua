--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA9 - Naboo
-- Common script that shares all setup information 
--

ScriptCB_DoFile("setup_teams")

--  Republic Attacking (attacker is always #1)
IMP = 1
ALL = 2
--  These variables do not change
ATT = 1
DEF = 2

-- this needs to be defined with the proper gmae mode
-- if additional layers need to be loaded
--~ myGameMode = "spa7_ctf"
function SetupUnits()
    ReadDataFile("SIDE\\all.lvl",
        "all_inf_pilot",
        "all_inf_marine",
        "all_fly_xwing_sc",
        "all_fly_ywing_sc",
        "all_fly_awing",
        "all_fly_gunship_sc",
        "all_veh_remote_terminal")
     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_pilot",
        "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor",
        "imp_fly_trooptrans",
        "imp_veh_remote_terminal")
        
    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_all_beam",
        "tur_bldg_spa_all_recoilless",
        "tur_bldg_spa_all_chaingun",
        "tur_bldg_spa_imp_beam",
        "tur_bldg_spa_imp_recoilless",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_chaingun_roof"
    )
end

myTeamConfig = {
     all = {
        team = ALL,
        units = 32,
        reinforcements = -1,
        pilot    = { "all_inf_pilot",26},
        marine   = { "all_inf_marine",6},
    },

    imp = {
        team = IMP,
        units = 32,
        reinforcements = -1,
        pilot    = { "imp_inf_pilot",26},
        marine   = { "imp_inf_marine",6},
    }
}

-- LockHangarWarsDoors
-- ARGS: bLock - true to lock the doors, false to unlock
-- assumes this will only be run once on start
-- if you wish to toggle, make sure to handle all 3 lists!
function LockHangarWarsDoors( bLock )
    local barrierList = {
        "all_cap1_bar1",
        "all_cap1_bar2",
        "all_cap1_bar3",
        "imp_cap1_bar1",
        "imp_cap1_bar2",
        "imp_cap1_bar3",
    }
    
    local connectionList = {
        "connection43",  -- all connections are in one group, so only need to disable one
    }
    
    local doorList = {
        "all1_door3",
        "all1_door4",
        "all1_door5",
        "imp1_door3",
        "imp1_door4",
        "imp1_door5",
    }
    
    if bLock then
        for i, door in pairs(doorList) do
            SetProperty(door, "isLocked", 1)
        end
        
        for j, connection in pairs(connectionList) do
            BlockPlanningGraphArcs(connection);
        end
    else
        for k, bar in pairs(barrierList) do
            DisableBarriers(bar);
        end 
    end
    
    LockHangarWarsDoors = nil
end


function SetupFrigateDeaths()
    local PlayFrigateDeathAnim = function ( aObj )
        local objName = GetEntityName( aObj )
        -- kill turrets
        for i=1,2 do
            local turName = objName .. "_tur" .. i
            KillObject( turName )
--~             DeleteEntity( turName )
            SetProperty( turName, "IsVisible", 0)
            SetProperty( turName, "IsCollidable ", 0)
            SetProperty( turName, "PhysicsActive", 0)
            SetProperty( turName, "Team", 0)
        end
    end
    
    OnObjectKillName(PlayFrigateDeathAnim, "imp_frig1");
    OnObjectKillName(PlayFrigateDeathAnim, "imp_frig2");
    OnObjectKillName(PlayFrigateDeathAnim, "imp_frig3");
    OnObjectKillName(PlayFrigateDeathAnim, "all_frig1");
    OnObjectKillName(PlayFrigateDeathAnim, "all_frig2");
end

ScriptCB_DoFile("LinkedTurrets")
function SetupTurrets() 
    --ALL turrets
    turretLinkageALL = LinkedTurrets:New{ team = ALL, mainframe = "all_cap1_autodefense", 
		turrets = {"all_cap1_autotur1", "all_cap1_autotur2", "all_cap1_autotur3", "all_cap1_autotur4", "all_cap1_autotur5", "all_cap1_autotur6",
		"all_cap1_bigtur1", "all_cap1_bigtur2" } }
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
    turretLinkageIMP = LinkedTurrets:New{ team = IMP, mainframe = "imp_cap1_autodefense", 
		turrets = {"imp_cap1_autotur1", "imp_cap1_autotur2", "imp_cap1_autotur3", "imp_cap1_autotur4", "imp_cap1_autotur5", "imp_cap1_autotur6",
		"imp_cap1_bigtur1", "imp_cap1_bigtur2" } }
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

-- adjust extents to fit cap ship
function ScriptPreInit()
   SetWorldExtents(2650)
   ScriptPreInit = nil
end


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
    if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1124*1024)  -- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4800000)
    ReadDataFile("ingame.lvl")
   
    SetMinFlyHeight(-1800)
    SetMaxFlyHeight(1800)
    SetMinPlayerFlyHeight(-1800)
    SetMaxPlayerFlyHeight(1800)
    SetAIVehicleNotifyRadius(100)
    
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
         
    SetupUnits()
    SetupTeams(myTeamConfig)

    --  Level Stats
    ClearWalkers()
    local weaponCnt = 250
    local guyCnt = 32
    SetMemoryPoolSize("Aimer", 190)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 89)
    SetMemoryPoolSize("Combo::DamageSample", 0)
    SetMemoryPoolSize("CommandFlyer", 2)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityDefenseGridTurret", 0)
    SetMemoryPoolSize("EntityFlyer", guyCnt+8)
    SetMemoryPoolSize("EntityLight", 115)
    SetMemoryPoolSize("EntityRemoteTerminal", 12)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 180)
    SetMemoryPoolSize("MountedTurret", 56)
	SetMemoryPoolSize("EntityPortableTurret", 20)
    SetMemoryPoolSize("Navigator", guyCnt)
    SetMemoryPoolSize("Obstacle", 135)
    SetMemoryPoolSize("PathNode", 80)
    SetMemoryPoolSize("PathFollower", guyCnt)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 240)
    SetMemoryPoolSize("UnitAgent", 65)  -- guyCnt*2
    SetMemoryPoolSize("UnitController", 65)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    -- asteroids
    local kNumAstLrg = 32
    SetMemoryPoolSize("Asteroid", 2*kNumAstLrg)
--    SetMemoryPoolSize("TreeGridStack", 4*kNumAstLrg)

    SetSpawnDelay(10.0, 0.25)
    
    -- do any pool allocations, custom loading here
    if myScriptInit then
        myScriptInit()
        myScriptInit = nil
    end
    
    -- load sky dome
    local world = "tat"
    if ScriptCB_IsMissionSetupSaved() then
        local missionSetup = ScriptCB_LoadMissionSetup()
        world = missionSetup.world or world
    end
    ReadDataFile("SPA\\spa_sky.lvl", world)

    ReadDataFile("spa\\spa9.lvl", myGameMode)
    
    SetDenseEnvironment("false")

    SetParticleLODBias(15000)
    
--~     FillAsteroidRegion("wreckField", "spa_prop_jagged_asteroid_large", kNumAstLrg, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
    FillAsteroidRegion("wreckField", "spa_prop_debris1", kNumAstLrg, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
    FillAsteroidRegion("wreckField", "spa_prop_debris2", kNumAstLrg, 3.0,1.0,1.0, 0.0,-1.0,-1.0);

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
   
    --  Camera Stats  Battle over Naboo  Again, the following line was here, it's legacy, FUSCO!
    SetAttackingTeam(IMP)
    -- Internal Alliance hangar
    -- this shot is bad, needs to be fixed
    AddCameraShot(-0.049495, 0.003922, -0.995646, -0.078892, 24.992880, -22.995819, -1025.940186);
    --Flag shot
    AddCameraShot(0.546201, 0.047743, 0.833116, -0.072822, 402.610260, -105.474068, -55.044727);
    --Internal Imperial hangar
    AddCameraShot(0.988295, -0.091070, 0.121873, 0.011230, 33.932011, 10.868500, 1567.624146);
    -- Imperial ship overall
    AddCameraShot(-0.380690, 0.021761, -0.922940, -0.052756, 1351.167236, 188.651230, -10.971837);
    -- Alliance ship overall
    AddCameraShot(0.941014, -0.051715, 0.333887, 0.018349, 1053.546143, 188.651230, -51.276745);
    
    AddLandingRegion("imp_hangar1")
    AddLandingRegion("all_hangar1")
    
    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end       
end
