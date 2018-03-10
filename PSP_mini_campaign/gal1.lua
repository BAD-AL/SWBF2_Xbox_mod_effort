-- gal1.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("gametype_conquest")

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2173525)
    else
        SetPS2ModelMemory(2097152 + 65536 * 0)
    end
    ReadDataFile("ingame.lvl")

    local alliance = 1
    local empire = 2
    local attackers = 1
    local defenders = 2

    AddMissionObjective(empire, "red", "level.cor1.objectives.1")
    AddMissionObjective(empire, "orange", "level.cor1.objectives.3")
    AddMissionObjective(alliance, "red", "level.cor1.objectives.1")
    AddMissionObjective(alliance, "orange", "level.cor1.objectives.2")

    ReadDataFile("sound\\gal.lvl;gal_vo")
    ReadDataFile("SIDE\\all.lvl", "all_inf_basicjungle", "all_hero_luke_jedi", "all_inf_smuggler")
    ReadDataFile("SIDE\\imp.lvl", "imp_inf_basic", "imp_inf_dark_trooper", "imp_hero_darthvader")
    ClearWalkers()

    SetMemoryPoolSize("EntityHover", 0)
    SetMemoryPoolSize("EntityFlyer", 0)
    SetMemoryPoolSize("EntityDroid", 10)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("Obstacle", 50)
    SetMemoryPoolSize("Weapon", 260)

    SetTeamName(alliance, "Alliance")
    SetTeamIcon(alliance, "all_icon")
    AddUnitClass(alliance, "all_inf_soldierjungle", 11)
    AddUnitClass(alliance, "all_inf_vanguardjungle", 3)
    AddUnitClass(alliance, "all_inf_pilot", 4)
    AddUnitClass(alliance, "all_inf_marksmanjungle", 4)
    AddUnitClass(alliance, "all_inf_smuggler", 3)
    SetHeroClass(alliance, "all_hero_luke_jedi")

    SetTeamName(empire, "Empire")
    SetTeamIcon(empire, "imp_icon")

    AddUnitClass(empire, "imp_inf_storm_trooper", 11)
    AddUnitClass(empire, "imp_inf_shock_trooper", 3)
    AddUnitClass(empire, "imp_inf_pilotatst", 4)
    AddUnitClass(empire, "imp_inf_scout_trooper", 4)
    AddUnitClass(empire, "imp_inf_dark_trooper", 3)
    SetHeroClass(empire, "imp_hero_darthvader")

    SetUnitCount(attackers, 25)
    SetReinforcementCount(attackers, 200)

    teamATT = ConquestTeam:New({team = attackers})
    teamATT:AddBleedThreshold(21, 0)
    teamATT:AddBleedThreshold(11, 0)
    teamATT:AddBleedThreshold(1, 0)
    teamATT:Init()

    SetUnitCount(defenders, 25)
    SetReinforcementCount(defenders, 200)

    teamDEF = ConquestTeam:New({team = defenders})
    teamDEF:AddBleedThreshold(21, 0)
    teamDEF:AddBleedThreshold(11, 0)
    teamDEF:AddBleedThreshold(1, 0)
    teamDEF:Init()

    SetSpawnDelay(10, 0.25)
    ReadDataFile("gal\\gal1.lvl")
    SetDenseEnvironment("false")

    SetAmbientMusic(alliance, 1, "all_mus_amb_start", 0, 1)
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")

    SetPlanetaryBonusVoiceOver(alliance, alliance, 3, "all_bonus_all_hero")
    SetPlanetaryBonusVoiceOver(alliance, empire, 3, "all_bonus_imp_hero")

    SetAttackingTeam(attackers)

    AddCameraShot(
        0.99765402078629,
        0.066982001066208,
        0.014139000326395,
        -0.00094900000840425,
        155.1371307373,
        0.91150498390198,
        -138.07707214355
    )
    AddCameraShot(
        0.72976100444794,
        0.019262000918388,
        0.68319398164749,
        -0.018032999709249,
        -98.584869384766,
        0.29528400301933,
        263.23928833008
    )
    AddCameraShot(
        0.69427698850632,
        0.0051000001840293,
        0.71967101097107,
        -0.0052869999781251,
        -11.105946540833,
        -2.7532069683075,
        67.982200622559
    )
end

-- INFO 0x1 0x0 0x0 0x0 0x1 0x0 0x0 0x0
