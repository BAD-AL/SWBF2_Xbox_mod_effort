-- SPACE 1 Battle over Yavin
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")
ScriptCB_DoFile("LinkedTurrets")

--  Empire Attacking (attacker is always #1)
IMP = 1
ALL = 2
--  These variables do not change
ATT = 1
DEF = 2
    
function ScriptPostLoad()
    SetupObjectives()
    DisableSmallMapMiniMap()
    DisableBarriers("allblock");
    DisableBarriers("impblock");
    SetupShields()
    SetupDestroyables()
    SetupTurrets()  
    
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
    
        -- Show lights
    
    SetProperty( "imp_eng_lightr", "IsVisible", 0)
    SetProperty( "imp_shi_lightr", "IsVisible", 0)
    SetProperty( "imp_lif_lightr", "IsVisible", 0)
    
    SetProperty( "all_eng_lightr", "IsVisible", 0)
    SetProperty( "all_shi_lightr", "IsVisible", 0)
    SetProperty( "all_lif_lightr", "IsVisible", 0)  
	-- Frigate work
	OnObjectKillName(IMPM1_turr, "IMP_mini01");
	OnObjectKillName(ALLM2_turr, "cor01");
end

function SetupObjectives()
    assault = ObjectiveSpaceAssault:New{
        teamATT = IMP, teamDEF = ALL, 
        multiplayerRules = true
    }
    
    local impTargets = {
        engines     = {"Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05", "Engine_a06"},
        lifesupport = "life_ext_all",
        bridge      = "bridge_all",
        comm        = "comms_all",
        sensors     = "sensors_all",
        frigates    = "cor01",
        internalSys = { "life_int_all", "engines_all" },
    }
    
    local allTargets = {
        engines     = { "engine_l", "engine_c", "engine_r" },
        lifesupport = "life_ext_imp",
        bridge      = "bridge_imp",
        comm        = "comms_imp",
        sensors     = "sensors_imp",
        frigates    = "imp_mini01",
        internalSys = { "life_int_imp", "engines_imp" },
    }
    
    assault:SetupAllCriticalSystems( "imp", impTargets, true )
    assault:SetupAllCriticalSystems( "all", allTargets, false )
    
    assault:Start()
end

function SetupShields()
    -- ALL Shielded objects    
    linkedShieldObjectsALL = { "rebelcruiser", "all_cap_rebelcruiser3", "Engine_a01", "Engine_a02", "Engine_a03",
                               "Engine_a04", "Engine_a05", "Engine_a06", "sensors_all",
                               "sensors_spin", "comms_all", "bridge_all", "life_ext_all"}
    shieldStuffALL = LinkedShields:New{objs = linkedShieldObjectsALL, maxShield = 500000, addShield = 1000,
                                              controllerObject = "shieldgenALL"}
    shieldStuffALL:Init()
    
    function shieldStuffALL:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", IMP)
        ShowMessageText("level.spa.hangar.shields.def.down", ALL)
		
		BroadcastVoiceOver( "IOSMP_obj_16", IMP )
		BroadcastVoiceOver( "AOSMP_obj_17", ALL )

        EnableLockOn({"Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05",
                      "Engine_a06", "sensors_all", "sensors_spin", "comms_all", "bridge_all",
                      "life_ext_all"}, true)
    end
    
    function shieldStuffALL:OnAllShieldsUp()
        ShowMessageText("level.spa.hangar.shields.atk.up", IMP)
        ShowMessageText("level.spa.hangar.shields.def.up", ALL)
		
		BroadcastVoiceOver( "IOSMP_obj_18", IMP )
		BroadcastVoiceOver( "AOSMP_obj_19", ALL )    
    
        EnableLockOn({"Engine_a01", "Engine_a02", "Engine_a03", "Engine_a04", "Engine_a05",
                      "Engine_a06", "sensors_all", "sensors_spin", "comms_all", "bridge_all",
                      "life_ext_all"}, false)
    end
    
    -- IMP Shielded objects    
    linkedShieldObjectsIMP = { "imp_cap_stardestroyer10", "imp_cap_stardestroyer2", "imp_cap_stardestroyer3", 
                               "imp_cap_stardestroyer4", "engine_l", "engine_c", "engine_r", "bridge_imp",
                               "comms_imp", "sensors_spin0", "sensors_imp", "life_ext_imp", "shield_r", "shield_l",
                               "imp_cap_stardestroyer_shield1"}
    shieldStuffIMP = LinkedShields:New{objs = linkedShieldObjectsIMP, maxShield = 500000, addShield = 1000,
                                              controllerObject = "shieldgenIMP"}    
    shieldStuffIMP:Init()
    
    function shieldStuffIMP:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", ALL)
        ShowMessageText("level.spa.hangar.shields.def.down", IMP)
		
		BroadcastVoiceOver( "IOSMP_obj_17", IMP )
		BroadcastVoiceOver( "AOSMP_obj_16", ALL )
        EnableLockOn({ "engine_l", "engine_c", "engine_r", "bridge_imp", "comms_imp", "sensors_spin0", "sensors_imp",
                       "life_ext_imp"}, true)
    end 
    
    function shieldStuffIMP:OnAllShieldsUp()
		ShowMessageText("level.spa.hangar.shields.atk.up", ALL)
		ShowMessageText("level.spa.hangar.shields.def.up", IMP)
		
		BroadcastVoiceOver( "IOSMP_obj_19", IMP )
		BroadcastVoiceOver( "AOSMP_obj_18", ALL )
        EnableLockOn({ "engine_l", "engine_c", "engine_r", "bridge_imp", "comms_imp", "sensors_spin0", "sensors_imp",
                       "life_ext_imp"}, false)
    end
end


function SetupDestroyables()
    --ALL destroyables
    lifeSupportLinkageALL = LinkedDestroyables:New{ objectSets = {{"life_int_all"}, {"life_ext_all"}} }
    lifeSupportLinkageALL:Init()
        
    engineLinkageALL = LinkedDestroyables:New{ objectSets = {{"Engine_a01", "Engine_a02", "Engine_a03",
                                                              "Engine_a04", "Engine_a05", "Engine_a06"}, {"engines_all"}} }
    engineLinkageALL:Init()
    
    --IMP destroyables
    lifeSupportLinkageIMP = LinkedDestroyables:New{ objectSets = {{"life_int_imp"}, {"life_ext_imp"}} }
    lifeSupportLinkageIMP:Init()    
    
    engineLinkageIMP = LinkedDestroyables:New{ objectSets = {{"engine_l", "engine_c", "engine_r"}, {"engines_imp"}} }
    engineLinkageIMP:Init()
    
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

-- Frigates Listing

function IMPM1_turr()
	KillObject("mpit10");
	KillObject("mpit11");
	KillObject("mpit12");
	
	SetProperty( "mpit10", "IsVisible", 0)
	SetProperty( "mpit10", "IsCollidable ", 0)
	SetProperty( "mpit10", "PhysicsActive", 0)
	SetProperty( "mpit10", "Team", 0)
	
	SetProperty( "mpit11", "IsVisible", 0)
	SetProperty( "mpit11", "IsCollidable ", 0)
	SetProperty( "mpit11", "PhysicsActive", 0)
	SetProperty( "mpit11", "Team", 0)
	
	SetProperty( "mpit12", "IsVisible", 0)
	SetProperty( "mpit12", "IsCollidable ", 0)
	SetProperty( "mpit12", "PhysicsActive", 0)
	SetProperty( "mpit12", "Team", 0)

end

function ALLM2_turr()
	KillObject("mpat10");
	KillObject("mpat11");
	KillObject("mpat12");
	
	SetProperty( "mpat10", "IsVisible", 0)
	SetProperty( "mpat10", "IsCollidable ", 0)
	SetProperty( "mpat10", "PhysicsActive", 0)
	SetProperty( "mpat10", "Team", 0)
	
	SetProperty( "mpat11", "IsVisible", 0)
	SetProperty( "mpat11", "IsCollidable ", 0)
	SetProperty( "mpat11", "PhysicsActive", 0)
	SetProperty( "mpat11", "Team", 0)
	
	SetProperty( "mpat12", "IsVisible", 0)
	SetProperty( "mpat12", "IsCollidable ", 0)
	SetProperty( "mpat12", "PhysicsActive", 0)
	SetProperty( "mpat12", "Team", 0)
end

function ScriptPreInit()
   SetWorldExtents(2060)
end

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     StealArtistHeap(1084*1024)
     SetPS2ModelMemory(4730000)
     ReadDataFile("ingame.lvl")
     
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
        "all_fly_awing",
        "all_fly_gunship_sc")
        
     ReadDataFile("SIDE\\imp.lvl",
        "imp_inf_pilot",
        "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor",
        "imp_fly_trooptrans")

     ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_all_recoilless",
        "tur_bldg_spa_all_beam",
        "tur_bldg_spa_imp_recoilless",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_chaingun_roof")


    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize ("Aimer", 200)
    SetMemoryPoolSize ("BaseHint",60)
    SetMemoryPoolSize ("Combo::DamageSample", 64)
    SetMemoryPoolSize ("CommandFlyer",2)
    SetMemoryPoolSize ("EntityFlyer",32)
    SetMemoryPoolSize ("EntityDroid",0)
    SetMemoryPoolSize ("EntityLight",120)
    SetMemoryPoolSize ("EntityRemoteTerminal",12)
    SetMemoryPoolSize ("EntitySoundStream", 12)
    SetMemoryPoolSize ("EntitySoundStatic", 3)
    SetMemoryPoolSize ("FLEffectObject::OffsetMatrix", 100)
    SetMemoryPoolSize ("MountedTurret",70)
    SetMemoryPoolSize ("Navigator", 32)
    SetMemoryPoolSize ("Obstacle", 100)
    SetMemoryPoolSize ("PassengerSlot", 0)
    SetMemoryPoolSize ("PathFollower", 32)
    SetMemoryPoolSize ("PathNode", 72)
    SetMemoryPoolSize ("TentacleSimulator", 0)
    SetMemoryPoolSize ("TreeGridStack", 230)
    SetMemoryPoolSize ("UnitAgent",74)
    SetMemoryPoolSize ("UnitController",74)
    SetMemoryPoolSize ("Weapon", 260)
     
    --if(gPlatformStr == "XBox") then 
    --    SetMemoryPoolSize ("Asteroid", 400)
    --elseif( gPlatformStr == "PS2") then
        SetMemoryPoolSize ("Asteroid", 50)
    --else -- PC
    --    SetMemoryPoolSize ("Asteroid", 600)
    --end

SetupTeams{

         all = {
            team = ALL,
            units = 32,
            reinforcements = -1,
            pilot    = { "all_inf_pilot",25},
            marine   = { "all_inf_marine",8},
        },

        imp = {
            team = IMP,
            units = 32,
            reinforcements = -1,
            pilot    = { "imp_inf_pilot",25},
            marine   = { "imp_inf_marine",8},

        }
     }

     SetSpawnDelay(10.0, 0.25)
     
     -- load sky dome
     local world = "yav"
     if ScriptCB_IsMissionSetupSaved() then
         local missionSetup = ScriptCB_LoadMissionSetup()
         world = missionSetup.world or world
     end
     ReadDataFile("SPA\\spa_sky.lvl", world)

     ReadDataFile("spa\\spa1.lvl", "spa1_Assault")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregionimp")
     AddDeathRegion("deathregionall")
     --SetStayInTurrets(1)
     
     
    SetParticleLODBias(3000)
     
    --if(gPlatformStr == "XBox") then 
         --SetMaxCollisionDistance(1500)
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 50, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 100, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 50, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 100, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 

    --elseif( gPlatformStr == "PS2") then
         SetMaxCollisionDistance(1000)
        FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 25, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
        FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 25, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 25, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 25, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 50, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 
    --else -- PC
         --SetMaxCollisionDistance(2000)
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_medium_stop", 50, 2.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidRegion("asteroid_region1", "spa_prop_jagged_asteroid_large_stop", 200, 3.0,1.0,1.0, 0.0,-1.0,-1.0);
        --FillAsteroidPath("asteroid_path1", 120, "spa_prop_jagged_asteroid_large", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path1", 60, "spa_prop_jagged_asteroid_medium", 50, 1.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 120, "spa_prop_jagged_asteroid_large_stop", 50, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
        --FillAsteroidPath("asteroid_path2", 60, "spa_prop_jagged_asteroid_medium_stop", 200, 2.0,1.0,1.0, 0.0,-1.0,-1.0); 
    
    --end
     
    

     --  Sound
     
     musicStream = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
     AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", musicStream)
     AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", musicStream)
     AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", musicStream)      
     
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

     SetOutOfBoundsVoiceOver(1, "impleaving")
     SetOutOfBoundsVoiceOver(2, "allleaving")

     SetAmbientMusic(ALL, 1.0, "all_spa_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.9, "all_spa_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.1,"all_spa_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_spa_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.9, "imp_spa_amb_middle", 1,1)
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
