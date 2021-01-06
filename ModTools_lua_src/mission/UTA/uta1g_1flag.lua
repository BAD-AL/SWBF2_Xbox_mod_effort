--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams") 

--  Republic Attacking (attacker is always #1)
local IMP = 1
local ALL = 2
--  These variables do not change
local ATT = 1
local DEF = 2

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


--This is the actual objective setup

    SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )

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
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4880000)
    ReadDataFile("ingame.lvl")

    ReadDataFile("sound\\uta.lvl;uta1gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat")
                    
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",
                    "imp_hero_bobafett")

  SetupTeams{
    all = {
        team = ALL,
        units = 32,
        reinforcements = -1,
        soldier = { "all_inf_rifleman",9, 25},
        assault = { "all_inf_rocketeer",1, 4},
        engineer = { "all_inf_engineer",1, 4},
        sniper  = { "all_inf_sniper",1, 4},
        officer = { "all_inf_officer",1, 4},
        special = { "all_inf_wookiee",1, 4},
    },
}   

SetupTeams{
    imp = {
        team = IMP,
        units = 32,
        reinforcements = -1,
        soldier = { "imp_inf_rifleman",9, 25},
        assault = { "imp_inf_rocketeer",1, 4},
        engineer = { "imp_inf_engineer",1, 4},
        sniper  = { "imp_inf_sniper",1, 4},
        officer = { "imp_inf_officer",1, 4},
        special = { "imp_inf_dark_trooper",1, 4},
     },
}
--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_bobafett")
    SetHeroClass(ALL, "all_hero_hansolo_tat")


     --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize ("FlagItem", 1)   
    SetMemoryPoolSize ("EntityHover",4)
    SetMemoryPoolSize("EntitySoundStatic", 27)      
    SetMemoryPoolSize("EntityFlyer", 8)
    SetMemoryPoolSize ("EntityLight",80)
    SetMemoryPoolSize ("Obstacle", 400)
    SetMemoryPoolSize ("Weapon", 260)

     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("uta\\uta1.lvl", "uta1_1flag")
     SetDenseEnvironment("false")
     AddDeathRegion("deathregion")
     SetMaxFlyHeight(29.5)
     SetMaxPlayerFlyHeight(29.5)
     
     --SetStayInTurrets(1)


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)     
     
     OpenAudioStream("sound\\global.lvl",  "gcw_music")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
     -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\uta.lvl",  "uta1")
     OpenAudioStream("sound\\uta.lvl",  "uta1")
     -- OpenAudioStream("sound\\uta.lvl",  "uta1_emt")

     -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(2, "allleaving")
     SetOutOfBoundsVoiceOver(1, "impleaving")

     SetAmbientMusic(ALL, 1.0, "all_uta_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.9, "all_uta_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.1, "all_uta_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_uta_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.9, "imp_uta_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.1, "imp_uta_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_uta_amb_victory")
     SetDefeatMusic (ALL, "all_uta_amb_defeat")
     SetVictoryMusic(IMP, "imp_uta_amb_victory")
     SetDefeatMusic (IMP, "imp_uta_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
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

