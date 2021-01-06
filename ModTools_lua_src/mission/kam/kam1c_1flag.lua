--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")


---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptPostLoad()
KillObject("cp2")
KillObject("cp1")

     SetProperty("cp11", "Team", "2")
    SetProperty("cp22", "Team", "1")        
    SetProperty("cp22", "SpawnPath", "NEW")
    SetProperty("cp22", "captureregion", "death")
    SetProperty("cp11", "captureregion", "death")
    SetProperty("CP4", "HUDIndexDisplay", 0)
    KillObject("cp3")
    KillObject("CP4")
    KillObject("CP5")
    --SetProperty("FDL-2", "IsLocked", 1)
    --SetProperty("cp4", "IsVisible", 0)
   
    SetProperty("cp6", "Team", "2")
    SetProperty("cp7", "Team", "1")


    SetProperty("Kam_Bldg_Podroom_Door33", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door34", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door35", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door27", "Islocked", 0)       
    SetProperty("Kam_Bldg_Podroom_Door28", "Islocked", 1)       
    SetProperty("Kam_Bldg_Podroom_Door36", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door20", "Islocked", 0)
    UnblockPlanningGraphArcs("connection71")
        
   --Objective1
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("open")
        
    --blocking Locked Doors
    UnblockPlanningGraphArcs("connection194");
    UnblockPlanningGraphArcs("connection200");
    UnblockPlanningGraphArcs("connection118");
    DisableBarriers("FRONTDOOR2-3");
    DisableBarriers("FRONTDOOR2-1");  
    DisableBarriers("FRONTDOOR2-2");  

    --Lower cloning facility
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
    DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")  
    DisableBarriers("FRONTDOOR1-2")
    
    SetAIDamageThreshold("Comp1", 0 )
    SetAIDamageThreshold("Comp2", 0 )
    SetAIDamageThreshold("Comp3", 0 )
    SetAIDamageThreshold("Comp4", 0 )
    SetAIDamageThreshold("Comp5", 0 )



    
    UnblockPlanningGraphArcs("connection71")
        
    --Objective1
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("open")

    --blocking Locked Doors
    UnblockPlanningGraphArcs("connection194");
    UnblockPlanningGraphArcs("connection200");
    UnblockPlanningGraphArcs("connection118");
    DisableBarriers("FRONTDOOR2-3");
    DisableBarriers("FRONTDOOR2-1");  
    DisableBarriers("FRONTDOOR2-2");  

    --Lower cloning facility
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
    DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")  
    DisableBarriers("FRONTDOOR1-2")
    
   EnableSPHeroRules()
   SoundEvent_SetupTeams( 1, 'rep', 2, 'cis' )
        --This is the actual objective setup
    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", 
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "lag_capture2", captureRegionDEF = "lag_capture1",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, hideCPs = true, multiplayerRules = true}
    ctf:Start()

  
end





function ScriptInit()

    StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3000000)
    ReadDataFile("ingame.lvl")

    --  REP Attacking (attacker is always #1)
    local REP = 1;
    local CIS = 2;
    --  These variables do not change
    local ATT = 1;
    local DEF = 2;


    ReadDataFile("sound\\kam.lvl;kam1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_jettrooper",
                             "rep_hero_obiwan",
                             "rep_inf_ep3_officer")
                             
                             --"rep_bldg_defensegridturret")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_fly_fedlander_dome",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_hero_jangofett",
                             "cis_inf_droideka",
                             "CIS_inf_officer")
                             --"cis_bldg_defensegridturret")
ReadDataFile("SIDE\\tur.lvl",
                        "tur_bldg_chaingun_roof",
                        "tur_weap_built_gunturret") 

   SetAttackingTeam(ATT)
SetupTeams{
    REP = {
        team = REP,
        units = 32,
        reinforcements = -1,
        soldier = { "rep_inf_ep3_rifleman",9, 25},
        assault = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer", 1, 4},
        sniper  = { "rep_inf_ep3_sniper",1, 4},
        officer = { "rep_inf_ep3_officer",1, 4},
        special = { "rep_inf_ep3_jettrooper",1,4},
                     --   turret = "rep_bldg_defensegridturret",
            
    },

}   

SetupTeams{
    CIS = {
        team = CIS,
        units = 32,
        reinforcements = -1,
        soldier = { "CIS_inf_rifleman",9, 25},
        assault = { "CIS_inf_rocketeer",1, 4},
        engineer = { "CIS_inf_engineer", 1, 4},
        sniper  = { "CIS_inf_sniper",1, 4},
        officer = { "CIS_inf_officer",1, 4},
        special = { "cis_inf_droideka",1,4},
                       -- turret = "cis_bldg_defensegridturret",
      
    },

}
    SetHeroClass(REP, "rep_hero_obiwan")
    SetHeroClass(CIS, "cis_hero_jangofett")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4) -- droidekas
    local weaponCnt = 240
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntityLight", 74)
    SetMemoryPoolSize("EntitySoundStream", 3)
    SetMemoryPoolSize("EntitySoundStatic", 85)
    SetMemoryPoolSize("FlagItem", 3)
    SetMemoryPoolSize("MountedTurret", 22)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 800)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("SoundSpaceRegion", 36)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("TreeGridStack", 338)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAM\\kam1.lvl", "kamino1_1CTF")
    SetDenseEnvironment("false")

    --  AI
        SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
       SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
    SetAllowBlindJetJumps(0)

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")


    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetAmbientMusic(REP, 1.0, "rep_kam_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_kam_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_kam_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kam_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_kam_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_kam_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_kam_amb_victory")
    SetDefeatMusic (REP, "rep_kam_amb_defeat")
    SetVictoryMusic(CIS, "cis_kam_amb_victory")
    SetDefeatMusic (CIS, "cis_kam_amb_defeat")

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)
    AddDeathRegion("deathregion")


		    AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922);

            AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774);

            AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919);

            AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421);

            AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089);

            AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552);

end
