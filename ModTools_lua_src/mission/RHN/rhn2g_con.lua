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
    
    --  Alliance Attacking (attacker is always #1)
    local ALL = 1
    local IMP = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2

    AddMissionObjective(IMP, "level.rhenvar2.objectives.1")
    AddMissionObjective(IMP, "level.rhenvar2.objectives.2")
    AddMissionObjective(ALL, "level.rhenvar2.objectives.1")
    AddMissionObjective(ALL, "level.rhenvar2.objectives.2")

    if(ScriptCB_GetPlatform() == "PS2") then
        AddMissionObjective(IMP, "red", "level.rhenvar2.objectives.3")
        AddMissionObjective(ALL, "red", "level.rhenvar2.objectives.3")
    end

    ReadDataFile("sound\\rhn.lvl;rhn2gcw")


    ReadDataFile("SIDE\\all.lvl",
                               "all_inf_rifleman",
                               "all_inf_rocketeer",
                               "all_inf_sniper",
                               "all_inf_engineer",
                               "all_inf_pilot",
                               "all_inf_wookiee",
                               "all_inf_officer")
    ReadDataFile("SIDE\\imp.lvl",
                               "imp_inf_rifleman",
                               "imp_inf_rocketeer",
                               "imp_inf_sniper",
                               "imp_inf_engineer",
                               "imp_inf_pilot",
                               "imp_inf_dark_trooper",
                               "imp_inf_officer")

    --      Alliance Stats
    SetTeamName(ALL, "Alliance")
    SetTeamIcon(ALL, "all_icon")
 if(ScriptCB_GetPlatform() == "PS2") then
        AddUnitClass(ALL, "all_inf_rifleman",11)
    else
        AddUnitClass(ALL, "all_inf_rifleman",11)
    end

    AddUnitClass(ALL, "all_inf_rocketeer",2)
    AddUnitClass(ALL, "all_inf_sniper",2)
    AddUnitClass(ALL, "all_inf_engineer",2)
    AddUnitClass(ALL, "all_inf_officer",2)
    AddUnitClass(ALL, "all_inf_wookiee",2)
    --SetHeroClass(ALL, "all_hero_luke_jedi")

    --      Imperial Stats
    SetTeamName(IMP, "Empire")
    SetTeamIcon(IMP, "imp_icon")

    if(ScriptCB_GetPlatform() == "PS2") then
        AddUnitClass(IMP, "imp_inf_rifleman",11)
    else
        AddUnitClass(IMP, "imp_inf_rifleman",11)
    end

    AddUnitClass(IMP, "imp_inf_rocketeer",2)
    AddUnitClass(IMP, "imp_inf_sniper",2)
    AddUnitClass(IMP, "imp_inf_engineer",2)
    AddUnitClass(IMP, "imp_inf_officer",2)
    AddUnitClass(IMP, "imp_inf_dark_trooper",2)

    --SetHeroClass(IMP, "imp_hero_bobafett")

    --  Attacker Stats

    if(ScriptCB_GetPlatform() == "PS2") then
        SetUnitCount(ATT, 21)
    else
        SetUnitCount(ATT, 21)
    end

    SetReinforcementCount(ATT, 200)

    teamATT = ConquestTeam:New{team = ATT}
    --teamATT:AddBleedThreshold(21, 0.75)
    --teamATT:AddBleedThreshold(11, 2.25)
    --teamATT:AddBleedThreshold(1, 3.0)
    teamATT:Init()
    
    --  Defender Stats

    if(ScriptCB_GetPlatform() == "PS2") then
        SetUnitCount(DEF, 21)
    else
        SetUnitCount(DEF, 21)
    end

    SetReinforcementCount(DEF, 200)

    teamDEF = ConquestTeam:New{team = DEF}
    --teamDEF:AddBleedThreshold(21, 0.75)
    --teamDEF:AddBleedThreshold(11, 2.25)
    --teamDEF:AddBleedThreshold(1, 3.0)
    teamDEF:Init()

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 0 droidekas
    SetMemoryPoolSize("Aimer", 10)
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("FlagItem", 2)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("RHN\\RHN2.lvl")
    SetDenseEnvironment("true")
    AddDeathRegion("FalltoDeath")
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)
    
    --  Sound Stats
    OpenAudioStream("sound\\rhn.lvl",  "rhngcw_music")
    OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    if(ScriptCB_GetPlatform() == "PS2") then
        OpenAudioStream("sound\\rhn.lvl",  "rhn2")
        OpenAudioStream("sound\\rhn.lvl",  "rhn2")
    else
        OpenAudioStream("sound\\rhn.lvl",  "rhn")
        OpenAudioStream("sound\\rhn.lvl",  "rhn")
    end
    
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "allleaving")
    SetOutOfBoundsVoiceOver(2, "impleaving")

    SetAmbientMusic(ALL, 1.0, "all_RHN_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.99, "all_RHN_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1,"all_RHN_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_RHN_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.99, "imp_RHN_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1,"imp_RHN_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_rhn_amb_victory")
    SetDefeatMusic (ALL, "all_rhn_amb_defeat")
    SetVictoryMusic(IMP, "imp_rhn_amb_victory")
    SetDefeatMusic (IMP, "imp_rhn_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
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

    SetAttackingTeam(ATT)

    --  Camera Stats
    --Rhen Var 2 Citadel
    --Statue
    AddCameraShot(0.994005, -0.109073, 0.007486, 0.000821, -203.097900, 26.624817, -101.682487)
    --Steps
    AddCameraShot(0.104328, -0.022317, -0.972296, -0.207984, -266.398132, 24.953222, -251.513596)
    --Terrace
    AddCameraShot(0.908227, 0.026135, 0.417489, -0.012014, -101.176414, 12.784149, -199.053940)
end
