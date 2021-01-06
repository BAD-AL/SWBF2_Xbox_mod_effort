--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

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
    SetPS2ModelMemory(2097152 + 65536 * 0)
    ReadDataFile("ingame.lvl")

    --  Republic Attacking (attacker is always #1)
    local REP = 1
    local CIS = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    AddMissionObjective(REP, "orange", "level.tat1.objectives.1")
    AddMissionObjective(REP, "red", "level.tat1.objectives.2")
    AddMissionObjective(CIS, "orange", "level.tat1.objectives.1")
    AddMissionObjective(CIS, "red", "level.tat1.objectives.2")

    SetTeamAggressiveness(REP, 0.95)
    SetTeamAggressiveness(CIS, 0.95)

     ReadDataFile("sound\\tat.lvl;tat1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             "rep_fly_assault_dome",
"rep_inf_basic",
"rep_inf_jet_trooper",
"rep_inf_macewindu",
"rep_fly_arc170fighter",
"rep_fly_anakinstarfighter",
"rep_fly_vwing",
"rep_fly_shuttleproto",
"rep_fly_jedifighter",
"rep_hover_swampspeeder",
"rep_walk_oneman_atst")

    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_basic",
                             "cis_inf_countdooku",
                             "cis_inf_droideka",
                   "cis_fly_greviousfighter",
                                         "cis_fly_tridroidfighter")

    SetAttackingTeam(ATT)

    --          Republic Stats
    SetTeamName(REP, "Republic")
    SetTeamIcon(REP, "rep_icon")
    AddUnitClass(REP, "rep_inf_clone_trooper",1)
    AddUnitClass(REP, "rep_inf_arc_trooper",0)
    AddUnitClass(REP, "rep_inf_clone_pilot",1)
    AddUnitClass(REP, "rep_inf_clone_sharpshooter",0)
    AddUnitClass(REP, "rep_inf_jet_trooper",0)
    SetHeroClass(REP, "rep_inf_macewindu")

    --          CIS Stats
    SetTeamName(CIS, "CIS")
    SetTeamIcon(CIS, "cis_icon")
    AddUnitClass(CIS, "cis_inf_battledroid",1)
    AddUnitClass(CIS, "cis_inf_assault",0)
    AddUnitClass(CIS, "cis_inf_pilotdroid",1)
    AddUnitClass(CIS, "cis_inf_assassindroid",0)
    AddUnitClass(CIS, "cis_inf_droideka",0)
    SetHeroClass(CIS, "cis_inf_countdooku")

    --  Attacker Stats
    SetUnitCount(ATT, 2)
    SetReinforcementCount(ATT, 1000)
    --teamATT = ConquestTeam:New{team = ATT}
    --teamATT:AddBleedThreshold(21, 0.75)
    --teamATT:AddBleedThreshold(11, 2.25)
    --teamATT:AddBleedThreshold(1, 3.0)
    --teamATT:Init()

    --  Defender Stats
    SetUnitCount(DEF, 2)
    SetReinforcementCount(DEF, 1000)
    --teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    --teamDEF:Init()

    --  Local Stats
    --SetTeamName(3, "locals")
    --AddUnitClass(3, "tat_inf_tuskenraider", 5)
    --AddUnitClass(3, "tat_inf_tuskenhunter", 2)
    --SetUnitCount(3, 14)

    --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 0) -- 8 droidekas (special case: 0 leg pairs)
AddWalkerType(2, 1) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
SetMemoryPoolSize("EntityHover", 5)
SetMemoryPoolSize("EntityFlyer", 7)
    --  SetMemoryPoolSize("EntityBuildingArmedDynamic", 16)
    --  SetMemoryPoolSize("EntityTauntaun", 0)
  --  SetMemoryPoolSize("MountedTurret", 25)
    SetMemoryPoolSize("PowerupItem", 60)
    SetMemoryPoolSize("EntityMine", 40)
    SetMemoryPoolSize("Aimer", 200)
  --  SetMemoryPoolSize("Obstacle", 725)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("test\\test1.lvl")
    SetDenseEnvironment("false")
    --AddDeathRegion("Sarlac01")
    -- SetMaxFlyHeight(90)
    -- SetMaxPlayerFlyHeight(90)

    --  Sound Stats
    OpenAudioStream("sound\\tat.lvl",  "tatcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat1")
    OpenAudioStream("sound\\tat.lvl",  "tat1")
    OpenAudioStream("sound\\cw.lvl",  "cw_vo")
    OpenAudioStream("sound\\cw.lvl",  "cw_tac_vo")
    -- OpenAudioStream("sound\\tat.lvl",  "tat1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_tat_amb_start",  0,1)
    SetAmbientMusic(REP, 0.99, "rep_tat_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_tat_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tat_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.99, "cis_tat_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_tat_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_tat_amb_victory")
    SetDefeatMusic (REP, "rep_tat_amb_defeat")
    SetVictoryMusic(CIS, "cis_tat_amb_victory")
    SetDefeatMusic (CIS, "cis_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 0, "CIS_bonus_CIS_medical")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 0, "CIS_bonus_REP_medical")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 1, "")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 1, "")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 2, "CIS_bonus_CIS_sensors")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 2, "CIS_bonus_REP_sensors")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 3, "CIS_bonus_CIS_hero")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 3, "CIS_bonus_REP_hero")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 4, "CIS_bonus_CIS_reserves")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 4, "CIS_bonus_REP_reserves")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 5, "CIS_bonus_CIS_sabotage")--sabotage
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 5, "CIS_bonus_REP_sabotage")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 6, "")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 6, "")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 7, "CIS_bonus_CIS_training")--advanced training
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 7, "CIS_bonus_REP_training")--advanced training

  --  SetPlanetaryBonusVoiceOver(REP, REP, 0, "REP_bonus_REP_medical")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 0, "REP_bonus_CIS_medical")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 1, "")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 1, "")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 2, "REP_bonus_REP_sensors")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 2, "REP_bonus_CIS_sensors")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 3, "REP_bonus_REP_hero")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 3, "REP_bonus_CIS_hero")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 4, "REP_bonus_REP_reserves")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 4, "REP_bonus_CIS_reserves")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 5, "REP_bonus_REP_sabotage")--sabotage
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 5, "REP_bonus_CIS_sabotage")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 6, "")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 6, "")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 7, "REP_bonus_REP_training")--advanced training
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 7, "REP_bonus_CIS_training")--advanced training

    --  Camera Stats
    --Tat 1 - Dune Sea
    --Crawler
    AddCameraShot(-0.404895, 0.000992, -0.914360, -0.002240, -85.539894, 20.536297, 141.699493)
    --Homestead
    AddCameraShot(0.040922, 0.004049, -0.994299, 0.098381, -139.729523, 17.546598, -34.360893)
    --Sarlac Pit
    AddCameraShot(-0.312360, 0.016223, -0.948547, -0.049263, -217.381485, 20.150953, 54.514324)

end


