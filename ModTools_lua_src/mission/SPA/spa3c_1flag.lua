-- SPACE 3 Battle over Kashyyyk
--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
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

    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2
    
function ScriptPostLoad()
    --This makes sure the flag is colorized when it has been dropped on the ground
    SetClassProperty("com_item_flag", "DroppedColorize", 1)
    
    --This is all the actual ctf objective setup
    ctf = ObjectiveOneFlagCTF:New{
        teamATT = REP, teamDEF = CIS,
        -- need new text
        textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", flag = "cmn_flag",
        homeRegion = "home_1flag", captureRegionATT = "Team1capture", captureRegionDEF = "Team2capture",
        capRegionDummyObjectATT = "rep_cap_marker", capRegionDummyObjectDEF = "cis_cap_marker",
        multiplayerRules = true, hideCPs = true,
        AIGoalWeight = 0.0,
    }
    SoundEvent_SetupTeams( REP, 'rep', CIS, 'cis' )
    
    ctf:Start()
    SetupTurrets()
    
--    DisableSmallMapMiniMap()
    
    -- get them going?
    AddAIGoal(REP, "Deathmatch", 100)
    AddAIGoal(CIS, "Deathmatch", 100)

    -- Lock doors
    
    SetProperty("rep_eng_door", "IsLocked", 1)
    SetProperty("rep_shi_door", "IsLocked", 1)
    SetProperty("rep_lif_door", "IsLocked", 1)
    
    SetProperty("cis_eng_door", "IsLocked", 1)
    SetProperty("cis_shi_door", "IsLocked", 1)
    SetProperty("cis_lif_door", "IsLocked", 1)
    
    -- Show lights
    
    SetProperty( "rep_eng_lightg", "IsVisible", 0)
    SetProperty( "rep_shi_lightg", "IsVisible", 0)
    SetProperty( "rep_lif_lightg", "IsVisible", 0)
    
    SetProperty( "cis_eng_lightg", "IsVisible", 0)
    SetProperty( "cis_shi_lightg", "IsVisible", 0)
    SetProperty( "cis_lif_lightg", "IsVisible", 0)
    
    -- cis side is closed
    BlockPlanningGraphArcs("cis_blk01","cis_blk02")
    --DisableBarriers("cis_blk01")
    --DisableBarriers("cis_blk02")
    
    -- rep side is closed
    BlockPlanningGraphArcs("rep_blk01","rep_blk02")
    --DisableBarriers("rep_blk01")
    --DisableBarriers("rep_blk02")
    
	SetProperty("cap_box01", "IsVisible", 0)
	SetProperty("cap_box01", "IsCollidible ", 0)
end
        
function SetupTurrets() 
    --CIS turrets
    LinkedTurretsCIS = LinkedTurrets:New{ team = CIS, mainframe = "cis_main", 
                                          turrets = {"cis_obj01","cis_obj02", "cis_obj03", "cis_obj04", "cis_obj05"} }
    LinkedTurretsCIS:Init()
    function LinkedTurretsCIS:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.down", CIS)
        
        BroadcastVoiceOver( "ROSMP_obj_20", REP )
        BroadcastVoiceOver( "COSMP_obj_21", CIS )

    end
    function LinkedTurretsCIS:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", REP)
        ShowMessageText("level.spa.hangar.mainframe.def.up", CIS)
        
        BroadcastVoiceOver( "ROSMP_obj_22", REP )
        BroadcastVoiceOver( "COSMP_obj_23", CIS )

    end
    
    --REP turrets
    LinkedTurretsREP = LinkedTurrets:New{ team = REP, mainframe = "rep_main",
                                          turrets = {"rep_at01","rep_at02", "rep_at03", "rep_at04", "rep_at05", "rep_at06"} }
    LinkedTurretsREP:Init()
    function LinkedTurretsREP:OnDisableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.down", CIS)
        ShowMessageText("level.spa.hangar.mainframe.def.down", REP)
        
        BroadcastVoiceOver( "ROSMP_obj_21", REP )
        BroadcastVoiceOver( "COSMP_obj_20", CIS )

    end
    function LinkedTurretsREP:OnEnableMainframe()
        ShowMessageText("level.spa.hangar.mainframe.atk.up", CIS)
        ShowMessageText("level.spa.hangar.mainframe.def.up", REP)

        BroadcastVoiceOver( "ROSMP_obj_23", REP )
        BroadcastVoiceOver( "COSMP_obj_22", CIS )

    end
    
end
        
function ScriptPreInit()
    SetWorldExtents(1900)
end
        
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(500 * 1024)
    SetPS2ModelMemory(4680000)
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl", "kas")        

     SetMinFlyHeight(-1900)
     SetMaxFlyHeight(2000)
     SetMinPlayerFlyHeight(-1900)
     SetMaxPlayerFlyHeight(2000)
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
                  
    ReadDataFile("SIDE\\rep.lvl",   
        "rep_inf_ep3_pilot",
        "rep_inf_ep3_marine",
        "rep_fly_assault_dome",
        "rep_fly_anakinstarfighter_sc",
        "rep_fly_arc170fighter_sc",        
        "rep_veh_remote_terminal",
--        "rep_fly_gunship_sc",        
        "rep_fly_arc170fighter_dome",
        "rep_fly_vwing")
        
    ReadDataFile("SIDE\\cis.lvl",
        "cis_inf_pilot",
        "cis_inf_marine",
        "cis_fly_fedlander_dome",
        "cis_fly_droidfighter_sc",  
        "cis_fly_droidfighter_dome",
        "cis_fly_greviousfighter",
--        "cis_fly_droidgunship",
        "cis_fly_tridroidfighter")

    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_spa_rep_beam",
        "tur_bldg_spa_rep_chaingun",
        "tur_bldg_spa_cis_chaingun",
        "tur_bldg_spa_cis_recoilless",
        "tur_bldg_chaingun_roof")

SetupTeams{

         rep = {
            team = REP,
            units = 32,
            reinforcements = -1,
            pilot    = { "rep_inf_ep3_pilot",32},
--            marine   = { "rep_inf_ep3_marine",6},
        },
           cis = {
            team = CIS,
            units = 32,
            reinforcements = -1,
            pilot    = { "cis_inf_pilot",32},
--            marine   = { "cis_inf_marine",6},
        }
     }
     
    --  Level Stats
    local weaponCnt = 240
    ClearWalkers()
    SetMemoryPoolSize ("Aimer",350)
    SetMemoryPoolSize ("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("BaseHint",100)
--    SetMemoryPoolSize ("CommandFlyer",2)
    SetMemoryPoolSize ("EnergyBar", weaponCnt)
    SetMemoryPoolSize ("EntityDroid",0)
    SetMemoryPoolSize ("EntityFlyer", 32)
    SetMemoryPoolSize ("EntityLight", 90)
    SetMemoryPoolSize ("EntityMine", 32)
    SetMemoryPoolSize ("EntityRemoteTerminal",12)
    SetMemoryPoolSize ("EntitySoundStream",48)
    SetMemoryPoolSize ("FLEffectObject::OffsetMatrix", 100)
    SetMemoryPoolSize ("FlagItem", 1)
    SetMemoryPoolSize ("Obstacle",120)
    SetMemoryPoolSize ("PathNode",48)
    SetMemoryPoolSize ("TreeGridStack",200)
    SetMemoryPoolSize ("UnitController",90)
    SetMemoryPoolSize ("UnitAgent",90)
    SetMemoryPoolSize ("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("spa\\spa3.lvl", "spa3_ctf")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregionrep")
    AddDeathRegion("deathregioncis")

    SetParticleLODBias(15000)


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
   

    --  Camera Stats
    --Space Combat: Battle Over Kashyyyk
	AddCameraShot(0.961253, -0.041344, -0.272296, -0.011712, 846.781738, 42.129261, 1632.990479);
	AddCameraShot(0.950207, 0.025974, 0.310420, -0.008485, 919.840332, 42.129261, 1735.540771);
	AddCameraShot(0.948213, -0.126931, -0.288596, -0.038632, -753.106201, 743.622070, 2686.222900);
	AddCameraShot(-0.325839, 0.049463, -0.933437, -0.141696, 2249.083496, 743.622070, -1105.532593);
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")


    if (gPlatformStr == "PS2") then
        ScriptCB_DisableFlyerShadows()
    end     

end



    
