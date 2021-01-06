--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

REP = 1
CIS = 2

ATT = REP
DEF = CIS

function ScriptPostLoad()


--This is the actual objective setup

    SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "Flag_capture1", captureRegionDEF = "Flag_capture2",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
    ctf:Start()
    EnableSPHeroRules()
    DisableBarriers("Barrier445");
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
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4880000)
    ReadDataFile("ingame.lvl")

    ReadDataFile("sound\\uta.lvl;uta1cw")

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper",
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_sniper",
                "cis_inf_officer",
                "cis_inf_droideka",
                "cis_hero_grievous")

SetupTeams{
        rep = {
        team = REP,
        units = 32,
        reinforcements = -1,
        soldier  = { "rep_inf_ep3_rifleman", 9, 25},
        assault  = { "rep_inf_ep3_rocketeer",1, 4},
        engineer = { "rep_inf_ep3_engineer",1, 4},
        sniper   = { "rep_inf_ep3_sniper",1, 4},
        officer  = { "rep_inf_ep3_officer",1, 4},
        special  = { "rep_inf_ep3_jettrooper",1, 4},
            
        },
        cis = {
        team = CIS,
        units = 32,
        reinforcements = -1,
        soldier  = { "cis_inf_rifleman", 9, 25},
        assault  = { "cis_inf_rocketeer",1, 4},
        engineer = { "cis_inf_engineer",1, 4},
        sniper   = { "cis_inf_sniper",1, 4},
        officer  = { "cis_inf_officer",1, 4},
        special  = { "cis_inf_droideka",1, 4},
        }
     }

        SetHeroClass(REP, "rep_hero_obiwan")
        SetHeroClass(CIS, "cis_hero_grievous")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 2)     -- droidekas
    AddWalkerType(1, 0) -- ATRTa (special case: 0 leg pairs)
    local weaponCnt = 150
    SetMemoryPoolSize("Aimer", 5)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("Combo::DamageSample", 610)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityLight", 80)
    SetMemoryPoolSize("EntityFlyer", 8)
    SetMemoryPoolSize("EntitySoundStream", 8)
    SetMemoryPoolSize("EntitySoundStatic", 27)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("MountedTurret", 0)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathFollower", 40)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("TreeGridStack", 256)
    SetMemoryPoolSize("UnitAgent", 40)
    SetMemoryPoolSize("UnitController", 40)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    
         --Adding Grievous Pool
     AddUnitClass(4, "rep_inf_ep3_rifleman", 1)
       SetUnitCount(4, 1)
    
    
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("uta\\uta1.lvl", "uta1_1flag")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)     
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\uta.lvl",  "uta1")
    OpenAudioStream("sound\\uta.lvl",  "uta1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\uta.lvl",  "uta1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_uta_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_uta_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1, "rep_uta_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_uta_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_uta_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1, "cis_uta_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_uta_amb_victory")
    SetDefeatMusic (REP, "rep_uta_amb_defeat")
    SetVictoryMusic(CIS, "cis_uta_amb_victory")
    SetDefeatMusic (CIS, "cis_uta_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

--  Camera Stats - Utapau: Sinkhole
    AddCameraShot(-0.428091, 0.045649, -0.897494, -0.095703, 162.714951, 45.857063, 40.647118)
    AddCameraShot(-0.194861, -0.001600, -0.980796, 0.008055, -126.179787, 16.113789, 70.012894);
    AddCameraShot(-0.462548, -0.020922, -0.885442, 0.040050, -16.947638, 4.561796, 156.926956);
    AddCameraShot(0.995310, 0.024582, -0.093535, 0.002310, 38.288612, 4.561796, 243.298508);
    AddCameraShot(0.827070, 0.017093, 0.561719, -0.011609, -24.457638, 8.834146, 296.544586);
    AddCameraShot(0.998875, 0.004912, -0.047174, 0.000232, -45.868237, 2.978215, 216.217880);
end


