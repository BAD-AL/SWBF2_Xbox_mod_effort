-- tat2g_dcm.lua
-- PSP 'Imperial Enforcer' Tatooine mission
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("MultiObjectiveContainer")
ATT = 1
DEF = 2

function ScriptPostLoad()
    KillObject("ctf_cp1")
    KillObject("ctf_cp2")
    KillObject("ctf_cp3")
    KillObject("ctf_cp4")
    ShowAllUnitsOnMinimap(true)
    EnableSPHeroRules()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 390)
    sixminremains = CreateTimer("sixminremains")
    SetTimerValue(sixminremains, 30)
    fiveminremains = CreateTimer("fiveminremains")
    SetTimerValue(fiveminremains, 90)
    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 150)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 210)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 270)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 330)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 360)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 380)
    StartTimer(missiontimer)
    StartTimer(sixminremains)
    StartTimer(fiveminremains)
    StartTimer(fourminremains)
    StartTimer(threeminremains)
    StartTimer(twominremains)
    StartTimer(oneminremains)
    StartTimer(thirtysecremains)
    StartTimer(tensecremains)
    ShowTimer(missiontimer)
    Objective1 =
        Objective:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            popupText = "level.tat2g_d.objectives.detail",
            text = "level.tat2g_d.objectives.1"
        }
    )

    Objective1.OnStart =
        function(self)
        Objective1JawaKill =
            OnObjectKill(
            function(object)
                if GetObjectTeam(object) == DEF then
                    jawa_count = GetReinforcementCount(DEF) - 1
                    if jawa_count == 30 then
                        ShowMessageText("level.tat2g_d.objectives.2")
                    end
                    if jawa_count == 20 then
                        ShowMessageText("level.tat2g_d.objectives.3")
                    end
                    if jawa_count == 15 then
                        ShowMessageText("level.tat2g_d.objectives.4")
                    end
                    if jawa_count == 10 then
                        ShowMessageText("level.tat2g_d.objectives.5")
                    end
                    if jawa_count == 5 then
                        ShowMessageText("level.tat2g_d.objectives.6")
                    end
                    if jawa_count == 3 then
                        ShowMessageText("level.tat2g_d.objectives.7")
                    end
                    if jawa_count == 2 then
                        ShowMessageText("level.tat2g_d.objectives.8")
                    end
                    if jawa_count == 1 then
                        ShowMessageText("level.tat2g_d.objectives.9")
                    end
                    if jawa_count == 0 then
                        Objective1:Complete(ATT)
                        ShowMessageText("level.tat2g_d.objectvies.10")
                        ReleaseObjectKill(Objective1JawaKill)
                    end
                end
            end
        )
    end

    OnTimerElapse(
        function()
            MissionVictory(DEF)
        end,
        "missiontimer"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.6min")
        end,
        "sixminremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.5min")
        end,
        "fiveminremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.4min")
        end,
        "fourminremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.3min")
        end,
        "threeminremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.2min")
        end,
        "twominremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.1min")
        end,
        "oneminremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.30sec")
        end,
        "thirtysecremains"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.10sec")
        end,
        "tensecremains"
    )

    objectiveSequence = MultiObjectiveContainer:New({})
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:Start()
end

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(1571153)
    else
        SetPS2ModelMemory(2097152 + 65536 * 10)
    end
    ReadDataFile("ingame.lvl")

    local jawas = 2
    local badDudes = 1

    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\imp.lvl", "imp_inf_sniper", "imp_inf_rifleman", "imp_hero_bobafett")
    ReadDataFile("SIDE\\des.lvl", "tat_inf_jawa")
    SetupTeams(
        {
            all = {
                team = jawas,
                units = 25,
                reinforcements = 35,
                soldier = {"tat_inf_jawa"}
            }
        }
    )
    SetupTeams(
        {
            imp = {
                team = badDudes,
                units = 4,
                reinforcements = -1,
                soldier = {"imp_inf_rifleman", 2},
                sniper = {"imp_inf_sniper", 2}
            }
        }
    )
    ForceHumansOntoTeam1()
    SetTeamName(1, "Empire")
    SetTeamName(2, "Jawas")
    SetAIDifficulty(2, -3)
    SetHeroClass(badDudes, "imp_hero_bobafett")
    AddAIGoal(1, "Deathmatch", 1000)
    AddAIGoal(2, "Deathmatch", 1000)
    ClearWalkers()
    AddWalkerType(0, 0)
    AddWalkerType(1, 0)
    AddWalkerType(2, 0)
    AddWalkerType(3, 0)
    SetMemoryPoolSize("Aimer", 14)
    SetMemoryPoolSize("EntityDroid", 8)
    SetMemoryPoolSize("EntityMine", 30)
    SetMemoryPoolSize("MountedTurret", 14)
    SetMemoryPoolSize("Obstacle", 653)
    SetMemoryPoolSize("Ordnance", 60)
    SetMemoryPoolSize("ParticleEmitter", 256)
    SetMemoryPoolSize("ParticleEmitterInfoData", 256)
    SetMemoryPoolSize("ParticleEmitterObject", 128)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("PathNode", 384)
    SetMemoryPoolSize("TreeGridStack", 500)
    SetSpawnDelay(3, 0.25)
    ReadDataFile("TAT\\tat2.lvl", "tat2_hunt")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(jawas, 1, "all_tat_amb_start", 0, 1)
    SetAmbientMusic(badDudes, 1, "imp_tat_amb_start", 0, 1)
    SetVictoryMusic(jawas, "all_tat_amb_victory")
    SetDefeatMusic(jawas, "all_tat_amb_defeat")
    SetVictoryMusic(badDudes, "imp_tat_amb_victory")
    SetDefeatMusic(badDudes, "imp_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.51487797498703,
        -0.14333200454712,
        -0.81423497200012,
        -0.22666700184345,
        -351.05249023438,
        31.599720001221,
        -71.300521850586
    )
    AddCameraShot(
        0.89931601285934,
        0.0074450001120567,
        0.43722000718117,
        -0.00362000009045,
        -212.96699523926,
        20.173393249512,
        56.179828643799
    )
    AddCameraShot(
        0.90299302339554,
        -0.019974999129772,
        -0.42908498644829,
        -0.0094919996336102,
        -205.00177001953,
        17.679758071899,
        77.177253723145
    )
end
