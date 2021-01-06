--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("gametype_conquest")

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
 
    EnableSPHeroRules()
    
 end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2097152 + 65536 * 18)
    ReadDataFile("ingame.lvl")
    
    --  Attacker is always #1
    local ALL = 1
    local IMP = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    SetTeamAggressiveness(IMP, 0.95)
    SetTeamAggressiveness(ALL, 0.95)

    SetMaxFlyHeight(-10)

    AddMissionObjective(IMP, "orange", "level.bespin2.objectives.1")
    AddMissionObjective(IMP, "red", "level.bespin2.objectives.2")
    AddMissionObjective(ALL, "orange", "level.bespin2.objectives.1")
    AddMissionObjective(ALL, "red", "level.bespin2.objectives.2")

    ReadDataFile("sound\\bes.lvl;bes2gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_inf_basicurban",
                             "all_inf_smuggler",
                             "all_inf_spy",
                             "all_hero_hansolo_tat")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_basic_tie",
                             "imp_inf_dark_trooper",
                             "imp_inf_officer",
                             "imp_hero_bobafett")

    -- set up teams
    SetupTeams{
        all = {
            team = ALL,
            units = 25,
            reinforcements = 200,
            soldier  = { "all_inf_soldierurban", 10 },
            assault  = { "all_inf_vanguard", 3 },
            engineer = { "all_inf_pilot", 4 },
            sniper   = { "all_inf_marksman", 4 },
            special1 = { "all_inf_smuggler", 3 },
            special2 = { "all_inf_spy", 1 },
            hero     = "all_hero_hansolo_tat"
        },
        imp = {
            team = IMP,
            units = 25,
            reinforcements = 200,
            soldier  = { "imp_inf_storm_trooper", 10 },
            assault  = { "imp_inf_shock_trooper", 3 },
            engineer = { "imp_inf_pilottie", 4 },
            sniper   = { "imp_inf_scout_trooper", 4 },
            special1 = { "imp_inf_dark_trooper", 3 },
            special2 = { "imp_inf_officer", 1 },
            hero     = "imp_hero_bobafett"
        }
    }

    --  Attacker Stats
    teamATT = ConquestTeam:New{team = ATT}
    teamATT:AddBleedThreshold(21, 0.75)
    teamATT:AddBleedThreshold(11, 2.25)
    teamATT:AddBleedThreshold(1, 3.0)
    teamATT:Init()

    --  Defender Stats
    teamDEF = ConquestTeam:New{team = DEF}
    teamDEF:AddBleedThreshold(21, 0.75)
    teamDEF:AddBleedThreshold(11, 2.25)
    teamDEF:AddBleedThreshold(1, 3.0)
    teamDEF:Init()

    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("Obstacle", 514)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("BES\\bes2.lvl")
    SetDenseEnvironment("true")


    --  Birdies
  --  SetNumBirdTypes(1)
  --  SetBirdType(0,1.0,"bird")
  --  SetBirdFlockMinHeight(-28.0)

    AddDeathRegion("DeathRegion")
    AddDeathRegion("DeathRegion2")

    --  Sound
    OpenAudioStream("sound\\bes.lvl",  "bes2gcw_music")
    OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\bes.lvl",  "bes2")
    OpenAudioStream("sound\\bes.lvl",  "bes2")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "Allleaving")
    SetOutOfBoundsVoiceOver(2, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_bes_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.99, "all_bes_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1,"all_bes_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_bes_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.99, "imp_bes_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1,"imp_bes_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_bes_amb_victory")
    SetDefeatMusic (ALL, "all_bes_amb_defeat")
    SetVictoryMusic(IMP, "imp_bes_amb_victory")
    SetDefeatMusic (IMP, "imp_bes_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    --SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetPlanetaryBonusVoiceOver(IMP, IMP, 0, "imp_bonus_imp_medical")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 0, "imp_bonus_all_medical")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 1, "")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 1, "")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 2, "imp_bonus_imp_sensors")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 2, "imp_bonus_all_sensors")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 3, "imp_bonus_imp_hero")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 3, "imp_bonus_all_hero")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 4, "imp_bonus_imp_reserves")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 4, "imp_bonus_all_reserves")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 5, "imp_bonus_imp_sabotage")--sabotage
    SetPlanetaryBonusVoiceOver(IMP, ALL, 5, "imp_bonus_all_sabotage")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 6, "")
    SetPlanetaryBonusVoiceOver(IMP, ALL, 6, "")
    SetPlanetaryBonusVoiceOver(IMP, IMP, 7, "imp_bonus_imp_training")--advanced training
    SetPlanetaryBonusVoiceOver(IMP, ALL, 7, "imp_bonus_all_training")--advanced training

    SetPlanetaryBonusVoiceOver(ALL, ALL, 0, "all_bonus_all_medical")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 0, "all_bonus_imp_medical")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 1, "")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 1, "")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 2, "all_bonus_all_sensors")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 2, "all_bonus_imp_sensors")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 3, "all_bonus_all_hero")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 3, "all_bonus_imp_hero")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 4, "all_bonus_all_reserves")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 4, "all_bonus_imp_reserves")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 5, "all_bonus_all_sabotage")--sabotage
    SetPlanetaryBonusVoiceOver(ALL, IMP, 5, "all_bonus_imp_sabotage")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 6, "")
    SetPlanetaryBonusVoiceOver(ALL, IMP, 6, "")
    SetPlanetaryBonusVoiceOver(ALL, ALL, 7, "all_bonus_all_training")--advanced training
    SetPlanetaryBonusVoiceOver(ALL, IMP, 7, "all_bonus_imp_training")--advanced training


    --  Camera Stats
    --Bespin 2
    --Courtyard 
    AddCameraShot(0.364258, -0.004224, -0.931226, -0.010797, -206.270294, -44.204708, 88.837059)
    --Carbon Chamber
    AddCameraShot(0.327508, 0.002799, -0.944810, 0.008076, -184.781006, -59.802036, -28.118919)
    --Wind Tunnel
    AddCameraShot(0.572544, -0.013560, -0.819532, -0.019410, -244.788055, -61.541622, -44.260509)
end
