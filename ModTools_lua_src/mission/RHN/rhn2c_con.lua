--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
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
    SetPS2ModelMemory(2097152 + 65536 * 4)
    ReadDataFile("ingame.lvl")

    --  REP Attacking (attacker is always #1)
    local REP = 2;
    local CIS = 1;
    --  These variables do not change
    local ATT = 1;
    local DEF = 2;

    ReadDataFile("sound\\rhn.lvl;rhn2cw")
    ReadDataFile("SIDE\\rep.lvl",
                               "rep_inf_rifleman",
                               "rep_inf_rocketeer",
                               "rep_inf_sniper",
                               "rep_inf_engineer",
                               "rep_inf_officer",
                               "rep_inf_jet_trooper")
    ReadDataFile("SIDE\\cis.lvl",
                               "cis_inf_rifleman",
                               "cis_inf_rocketeer",
                               "cis_inf_sniper",
                               "cis_inf_engineer",
                               "cis_inf_officer",
                               "cis_inf_droideka")

    SetAttackingTeam(ATT)

    AddMissionObjective(REP, "orange", "level.rhenvar2.objectives.1")
    AddMissionObjective(REP, "red", "level.rhenvar2.objectives.2")
    AddMissionObjective(CIS, "orange", "level.rhenvar2.objectives.1")
    AddMissionObjective(CIS, "red", "level.rhenvar2.objectives.2")

    if(ScriptCB_GetPlatform() == "PS2") then
        AddMissionObjective(REP, "red", "level.rhenvar2.objectives.3")
        AddMissionObjective(CIS, "red", "level.rhenvar2.objectives.3")
    end

    SetTeamAggressiveness(CIS, 0.9)

    --  Republic Stats
    SetTeamName(REP, "Republic")
    SetTeamIcon(REP, "rep_icon")

    if(ScriptCB_GetPlatform() == "PS2") then
        AddUnitClass(REP, "rep_inf_rifleman",11)
    else
        AddUnitClass(REP, "rep_inf_rifleman",11)

    end
    AddUnitClass(REP, "rep_inf_sniper",3)
    AddUnitClass(REP, "rep_inf_rocketeer",3)
    AddUnitClass(REP, "rep_inf_engineer",3)
    AddUnitClass(REP, "rep_inf_officer",3)
    AddUnitClass(REP, "rep_inf_jet_trooper",2)
    --SetHeroClass(REP, "rep_hero_macewindu")

    --  CIS Stats
    SetTeamName(CIS, "CIS")
    SetTeamIcon(CIS, "cis_icon")

    if(ScriptCB_GetPlatform() == "PS2") then
        AddUnitClass(CIS, "cis_inf_rifleman",11)
    else
        AddUnitClass(CIS, "cis_inf_rifleman",11)
    end

    AddUnitClass(CIS, "cis_inf_engineer",3)
    AddUnitClass(CIS, "cis_inf_officer",3)
    AddUnitClass(CIS, "cis_inf_rocketeer",3)
    AddUnitClass(CIS, "cis_inf_droideka",3)
    AddUnitClass(CIS, "cis_inf_sniper",2)

    --SetHeroClass(CIS, "cis_hero_jangofett")

    --  Attacker Stats

    if(ScriptCB_GetPlatform() == "PS2") then
        SetUnitCount(ATT, 25)
    else
        SetUnitCount(ATT, 25)
    end

    SetReinforcementCount(ATT, 200)
    teamATT = ConquestTeam:New{team = ATT}
    teamATT:AddBleedThreshold(21, 0.75)
    teamATT:AddBleedThreshold(11, 2.25)
    teamATT:AddBleedThreshold(1, 3.0)
    teamATT:Init()

    --  Defender Stats

    if(ScriptCB_GetPlatform() == "PS2") then
        SetUnitCount(DEF, 23)
    else
        SetUnitCount(DEF, 25)
    end

    SetReinforcementCount(DEF, 200)
    teamDEF = ConquestTeam:New{team = DEF}
    teamDEF:AddBleedThreshold(21, 0.75)
    teamDEF:AddBleedThreshold(11, 2.25)
    teamDEF:AddBleedThreshold(1, 3.0)
    teamDEF:Init()

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- 16 droidekas
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("RHN\\RHN2.lvl")
    SetDenseEnvironment("true")
    AddDeathRegion("FalltoDeath")
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)   

    --  Sound
    OpenAudioStream("sound\\rhn.lvl",  "rhncw_music")
    OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    if(ScriptCB_GetPlatform() == "PS2") then
        OpenAudioStream("sound\\rhn.lvl",  "rhn2")
        OpenAudioStream("sound\\rhn.lvl",  "rhn2")
    else
        OpenAudioStream("sound\\rhn.lvl",  "rhn")
        OpenAudioStream("sound\\rhn.lvl",  "rhn")
    end

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "Repleaving")
    SetOutOfBoundsVoiceOver(1, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_RHN_amb_start",  0,1)
    SetAmbientMusic(REP, 0.99, "rep_RHN_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_RHN_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_RHN_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.99, "cis_RHN_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_RHN_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_rhn_amb_victory")
    SetDefeatMusic (REP, "rep_rhn_amb_defeat")
    SetVictoryMusic(CIS, "cis_rhn_amb_victory")
    SetDefeatMusic (CIS, "cis_rhn_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    SetPlanetaryBonusVoiceOver(CIS, CIS, 0, "CIS_bonus_CIS_medical")
    SetPlanetaryBonusVoiceOver(CIS, REP, 0, "CIS_bonus_REP_medical")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 1, "")
    SetPlanetaryBonusVoiceOver(CIS, REP, 1, "")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 2, "CIS_bonus_CIS_sensors")
    SetPlanetaryBonusVoiceOver(CIS, REP, 2, "CIS_bonus_REP_sensors")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 3, "CIS_bonus_CIS_hero")
    SetPlanetaryBonusVoiceOver(CIS, REP, 3, "CIS_bonus_REP_hero")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 4, "CIS_bonus_CIS_reserves")
    SetPlanetaryBonusVoiceOver(CIS, REP, 4, "CIS_bonus_REP_reserves")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 5, "CIS_bonus_CIS_sabotage")--sabotage
    SetPlanetaryBonusVoiceOver(CIS, REP, 5, "CIS_bonus_REP_sabotage")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 6, "")
    SetPlanetaryBonusVoiceOver(CIS, REP, 6, "")
    SetPlanetaryBonusVoiceOver(CIS, CIS, 7, "CIS_bonus_CIS_training")--advanced training
    SetPlanetaryBonusVoiceOver(CIS, REP, 7, "CIS_bonus_REP_training")--advanced training

    SetPlanetaryBonusVoiceOver(REP, REP, 0, "REP_bonus_REP_medical")
    SetPlanetaryBonusVoiceOver(REP, CIS, 0, "REP_bonus_CIS_medical")
    SetPlanetaryBonusVoiceOver(REP, REP, 1, "")
    SetPlanetaryBonusVoiceOver(REP, CIS, 1, "")
    SetPlanetaryBonusVoiceOver(REP, REP, 2, "REP_bonus_REP_sensors")
    SetPlanetaryBonusVoiceOver(REP, CIS, 2, "REP_bonus_CIS_sensors")
    SetPlanetaryBonusVoiceOver(REP, REP, 3, "REP_bonus_REP_hero")
    SetPlanetaryBonusVoiceOver(REP, CIS, 3, "REP_bonus_CIS_hero")
    SetPlanetaryBonusVoiceOver(REP, REP, 4, "REP_bonus_REP_reserves")
    SetPlanetaryBonusVoiceOver(REP, CIS, 4, "REP_bonus_CIS_reserves")
    SetPlanetaryBonusVoiceOver(REP, REP, 5, "REP_bonus_REP_sabotage")--sabotage
    SetPlanetaryBonusVoiceOver(REP, CIS, 5, "REP_bonus_CIS_sabotage")
    SetPlanetaryBonusVoiceOver(REP, REP, 6, "")
    SetPlanetaryBonusVoiceOver(REP, CIS, 6, "")
    SetPlanetaryBonusVoiceOver(REP, REP, 7, "REP_bonus_REP_training")--advanced training
    SetPlanetaryBonusVoiceOver(REP, CIS, 7, "REP_bonus_CIS_training")--advanced training

    --  Camera Stats
    --Rhen Var 2 Citadel
    --Statue
    AddCameraShot(0.994005, -0.109073, 0.007486, 0.000821, -203.097900, 26.624817, -101.682487)
    --Steps
    AddCameraShot(0.104328, -0.022317, -0.972296, -0.207984, -266.398132, 24.953222, -251.513596)
    --Terrace
    AddCameraShot(0.908227, 0.026135, 0.417489, -0.012014, -101.176414, 12.784149, -199.053940)


end


