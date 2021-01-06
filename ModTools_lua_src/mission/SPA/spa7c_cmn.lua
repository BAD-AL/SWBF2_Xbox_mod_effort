--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA7 - Felucia
-- Common script that shares all setup information 
--

ScriptCB_DoFile("setup_teams")

--  Republic Attacking (attacker is always #1)
REP = 1
CIS = 2
--  These variables do not change
ATT = 1
DEF = 2

-- this needs to be defined with the proper gmae mode
-- if additional layers need to be loaded
--~ myGameMode = "spa7_ctf"
function SetupUnits()
    ReadDataFile("SIDE\\rep.lvl",   
        "rep_inf_ep3_pilot",
        "rep_inf_ep3_marine",
        "rep_fly_assault_dome",
        "rep_fly_anakinstarfighter_sc",
        "rep_fly_arc170fighter_sc",        
        "rep_veh_remote_terminal",
        "rep_fly_gunship_sc",
--~         "rep_fly_arc170fighter_dome",
        "rep_fly_vwing")
        
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
        "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
--~         "cis_fly_droidfighter_dome",
        "cis_fly_droidgunship",
        "cis_fly_greviousfighter",
        "cis_fly_tridroidfighter")
        
    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_cis_beam",
--~         "tur_bldg_spa_cis_cannon",
        "tur_bldg_spa_cis_chaingun",
        "tur_bldg_spa_rep_beam",
--~         "tur_bldg_spa_rep_cannon",
        "tur_bldg_spa_rep_chaingun",
        "tur_bldg_chaingun_roof"
    )
end

myTeamConfig = {
    rep = {
        team = REP,
        units = 32,
        reinforcements = -1,
        pilot    = { "rep_inf_ep3_pilot",26},
        marine   = { "rep_inf_ep3_marine",6},
    },
    cis = {
        team = CIS,
        units = 32,
        reinforcements = -1,
        pilot    = { "cis_inf_pilot",26},
        marine   = { "cis_inf_marine",6},
    }
}

function LockHangarWarsDoors( bLock )
    local barrierList = {
        "cis_cap1_bar1",
        "cis_cap1_bar2",
        "cis_cap1_bar3",
        "rep_cap1_bar1",
        "rep_cap1_bar2",
        "rep_cap1_bar3",
    }
    
    local connectionList = {
        "connection54",  -- all connections are in one group, so only need to disable one
    }
    
    local doorList = {
        "cis_cap1_door3",
        "cis_cap1_door4",
        "cis_cap1_door5",
        "rep_cap1_door1",
        "rep_cap1_door2",
        "rep_cap1_door3",
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
        -- randomly pick list anim?
        local objName = GetEntityName( aObj )
        -- kill turrets
        for i=1,4 do
            local turName = objName .. "_tur" .. i
            KillObject( turName )
--~             DeleteEntity( turName )
            SetProperty( turName, "IsVisible", 0)
            SetProperty( turName, "IsCollidable ", 0)
            SetProperty( turName, "PhysicsActive", 0)
            SetProperty( turName, "Team", 0)
        end
    end
    
	local frigList = {
		"cis_frig1",
		"cis_frig2",
		"rep_frig1",
		"rep_frig2",
	}
	
	for i, frigate in pairs(frigList) do
		OnObjectKillName(PlayFrigateDeathAnim, frigate)
		SetAIDamageThreshold(frigate, .33)
	end	
end

ScriptCB_DoFile("LinkedTurrets")
function SetupTurrets() 
    --CIS turrets
    turretLinkageCIS = LinkedTurrets:New{ team = CIS, mainframe = "cis_liquidgen",
		turrets = {"cis_cruiser_tur1", "cis_cruiser_tur2", "cis_cruiser_tur3", "cis_cruiser_tur4", "cis_biggun1", "cis_biggun2", "cis_biggun3", "cis_biggun4"} }
    turretLinkageCIS:Init()
    
    function turretLinkageCIS:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.down", CIS)
        
        BroadcastVoiceOver( "ROSMP_obj_20", REP )
        BroadcastVoiceOver( "COSMP_obj_21", CIS )
    end
    function turretLinkageCIS:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.up", CIS)

        BroadcastVoiceOver( "ROSMP_obj_22", REP )
        BroadcastVoiceOver( "COSMP_obj_23", CIS )
    end
    
    --REP turrets
    turretLinkageREP = LinkedTurrets:New{ team = REP, mainframe = "rep_liquidgen", 
        turrets = {"rep_assault_tur1", "rep_assault_tur2", "rep_assault_tur3", "rep_assault_tur4", "rep_assault_tur5", "rep_biggun1", "rep_biggun2"} }
    turretLinkageREP:Init()
    
    function turretLinkageREP:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", CIS)
        ShowMessageText("level.spa.hangar.mainframe.def.down", REP)

        BroadcastVoiceOver( "ROSMP_obj_21", REP )
        BroadcastVoiceOver( "COSMP_obj_20", CIS )
    end
    function turretLinkageREP:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", CIS)
        ShowMessageText("level.spa.hangar.mainframe.def.up", REP)

        BroadcastVoiceOver( "ROSMP_obj_23", REP )
        BroadcastVoiceOver( "COSMP_obj_22", CIS )       
    end
end

function ScriptPreInit()
   SetWorldExtents(2500)
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
        StealArtistHeap(456*1024)   -- steal 1MB from art heap
    end
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4800000)
    ReadDataFile("ingame.lvl")
    
    SetMinFlyHeight(-1800)
    SetMaxFlyHeight(1800)
    SetMinPlayerFlyHeight(-1800)
    SetMaxPlayerFlyHeight(1800)
    SetAIVehicleNotifyRadius(100)
    
    ReadDataFile("sound\\spa.lvl;spa2cw")
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
    local units = 72
    SetMemoryPoolSize("Aimer", 200)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 73)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 0)
    SetMemoryPoolSize("EntityDroideka",0)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("EntityHover", 0)
    SetMemoryPoolSize("EntityFlyer", 36)
    SetMemoryPoolSize("EntityLight", 100)
    SetMemoryPoolSize("EntityRemoteTerminal", 12)
    SetMemoryPoolSize("EntitySoldier",guyCnt)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 120)
    SetMemoryPoolSize("MountedTurret", 70)
    SetMemoryPoolSize("Navigator", guyCnt)
    SetMemoryPoolSize("Obstacle", 150)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("PathNode", 92)
    SetMemoryPoolSize("UnitAgent", units)
    SetMemoryPoolSize("UnitController", units)
    SetMemoryPoolSize("Weapon", weaponCnt)  
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("Combo::DamageSample", 0)

    -- asteroids
    local kNumAstLrg = 80
    SetMemoryPoolSize("Asteroid", kNumAstLrg)
    SetMemoryPoolSize("TreeGridStack", 250)--kNumAstLrg*2.75)
    
    SetSpawnDelay(10.0, 0.25)
    
    -- do any pool allocations, custom loading here
    if myScriptInit then
        myScriptInit()
        myScriptInit = nil
    end
    
    -- load sky dome
    local world = "fel"
    if ScriptCB_IsMissionSetupSaved() then
        local missionSetup = ScriptCB_LoadMissionSetup()
        world = missionSetup.world or world
    end
    ReadDataFile("SPA\\spa_sky.lvl", world)
    
    ReadDataFile("spa\\spa7.lvl", myGameMode)
    
    SetDenseEnvironment("false")

    SetParticleLODBias(15000)   

    FillAsteroidRegion("Ast_02", "spa_prop_jagged_asteroid_large", kNumAstLrg, 3.0,1.0,1.0, 0.0,-1.0,-1.0); 
    
    --  Sound Stats
    local voiceSlow = OpenAudioStream("sound\\global.lvl", "spa1_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
 
    local voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\spa.lvl",  "spa")
    OpenAudioStream("sound\\spa.lvl",  "spa")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\tat.lvl",  "tat1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1) 
    
    SetOutOfBoundsVoiceOver(REP, "Repleaving")
    SetOutOfBoundsVoiceOver(CIS, "Cisleaving")
    
    SetAmbientMusic(REP, 1.0, "rep_spa_amb_start",  0,1)
    SetAmbientMusic(REP, 0.99, "rep_spa_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_spa_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_spa_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.99, "cis_spa_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_spa_amb_end",    2,1)
    
    SetVictoryMusic(REP, "rep_spa_amb_victory")
    SetDefeatMusic (REP, "rep_spa_amb_defeat")
    SetVictoryMusic(CIS, "cis_spa_amb_victory")
    SetDefeatMusic (CIS, "cis_spa_amb_defeat")

   SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
   SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
   --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
   --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
   SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
   SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
   SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
   SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
   SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
   
    --  Camera Stats  Battle over Felucia
    -- Rep ship from behind  Rawr!
    AddCameraShot(0.998795, -0.041143, -0.026739, -0.001101, -720.435303, 809.024963, 2779.057129);
    -- CIS ship from behind
    AddCameraShot(0.028389, -0.001117, -0.998823, -0.039312, -629.853760, 809.024963, -2050.946289);
    -- Overall from right side of map
    AddCameraShot(-0.335210, 0.057062, -0.927078, -0.157814, 1372.964233, 1940.014038, -2266.423828);
    -- Overall from left side of map
    AddCameraShot(0.911880, -0.246677, -0.316680, -0.085667, -2183.282471, 1940.014038, 2760.666748);


    AddLandingRegion("cp1Control")
    AddLandingRegion("cp2control")

    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end     
end



    
