-- nab2g_dcp
-- Imperial Enforcer Competitive
-- Verified
Conquest = ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("MultiObjectiveContainer")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    ShowAllUnitsOnMinimap(true)
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 330)
    fiveminremains = CreateTimer("fiveminremains")
    SetTimerValue(fiveminremains, 30)
    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 90)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 150)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 210)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 270)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 300)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 320)
    StartTimer(missiontimer)
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
            teamATT = 1,
            teamDEF = 2,
            popupText = "level.nab2g_d.objectives.coop.detail",
            text = "level.nab2g_d.objectives.1"
        }
    )

    Objective1.OnStart =
        function(self)
        Objective1GunganKill =
            OnObjectKill(
            function(object)
                if GetObjectTeam(object) == DEF then
                    gungan_count = GetReinforcementCount(DEF) - 1

                    if gungan_count == 35 then
                        ShowMessageText("level.nab2g_d.objectives.coop.1")
                    end
                    if gungan_count == 30 then
                        ShowMessageText("level.nab2g_d.objectives.coop.2")
                    end
                    if gungan_count == 25 then
                        ShowMessageText("level.nab2g_d.objectives.coop.3")
                    end
                    if gungan_count == 20 then
                        ShowMessageText("level.nab2g_d.objectives.2")
                    end
                    if gungan_count == 15 then
                        ShowMessageText("level.nab2g_d.objectives.3")
                    end
                    if gungan_count == 10 then
                        ShowMessageText("level.nab2g_d.objectives.4")
                    end
                    if gungan_count == 5 then
                        ShowMessageText("level.nab2g_d.objectives.5")
                    end
                    if gungan_count == 3 then
                        ShowMessageText("level.nab2g_d.objectives.6")
                    end
                    if gungan_count == 2 then
                        ShowMessageText("level.nab2g_d.objectives.7")
                    end
                    if gungan_count == 1 then
                        ShowMessageText("level.nab2g_d.objectives.8")
                    end
                    if gungan_count == 0 then
                        Objective1:Complete(ATT)
                        ShowMessageText("level.nab2g_d.objectives.9")
                        ReleaseObjectKill(Objective1GunganKill)
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
        SetPSPModelMemory(1395277)
        SetPSPClipper(1)
    else
        SetPS2ModelMemory(2097152 + 65536 * 10)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\nab.lvl;nab2gcw")
    ReadDataFile("SIDE\\imp.lvl", "imp_inf_sniper", "imp_hero_bobafett")
    ReadDataFile("SIDE\\gun.lvl", "gun_inf_defender", "gun_inf_soldier")
    if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams(
            {
                imp = {
                    team = IMP,
                    units = 4,
                    reinforcements = -1,
                    sniper = {"imp_inf_sniper", 4}
                },
                all = {
                    team = ALL,
                    units = 25,
                    reinforcements = 40,
                    soldier = {"gun_inf_defender", 12},
                    assault = {"gun_inf_soldier", 13}
                }
            }
        )
    else
        SetupTeams(
            {
                imp = {
                    team = IMP,
                    units = 4,
                    reinforcements = -1,
                    sniper = {"imp_inf_sniper", 4}
                },
                all = {
                    team = ALL,
                    units = 25,
                    reinforcements = 40,
                    soldier = {"gun_inf_defender", 12},
                    assault = {"gun_inf_soldier", 13}
                }
            }
        )
    end
    ForceHumansOntoTeam1()
    SetTeamName(1, "Empire")
    SetTeamName(2, "Gungan")
    SetAIDifficulty(2, 2)
    AddAIGoal(1, "Deathmatch", 1000)
    AddAIGoal(2, "Deathmatch", 1000)
    SetHeroClass(ALL, "all_hero_leia")
    SetHeroClass(IMP, "imp_hero_bobafett")
    ClearWalkers()
    AddWalkerType(1, 0)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("PathNode", 300)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("TreeGridStack", 400)
    SetMemoryPoolSize("Ordnance", 50)
    SetMemoryPoolSize("ParticleEmitter", 300)
    SetMemoryPoolSize("ParticleEmitterObject", 128)
    SetMemoryPoolSize("ParticleEmitterInfoData", 512)
    SetMemoryPoolSize("Obstacle", 450)
    SetSpawnDelay(3, 0.25)
    ReadDataFile("NAB\\nab2.lvl", "naboo2_Sniper")
    SetDenseEnvironment("true")
    AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    SetNumBirdTypes(1)
    SetBirdType(0, 1, "bird")
    SetBirdFlockMinHeight(-28)
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(ALL, 1, "all_nab_amb_start", 0, 1)
    SetAmbientMusic(IMP, 1, "imp_nab_amb_start", 0, 1)
    SetVictoryMusic(ALL, "all_nab_amb_victory")
    SetDefeatMusic(ALL, "all_nab_amb_defeat")
    SetVictoryMusic(IMP, "imp_nab_amb_victory")
    SetDefeatMusic(IMP, "imp_nab_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    AddCameraShot(
        -0.007592000067234,
        -1.9999999949505e-006,
        -0.99997097253799,
        0.00020900000527035,
        -168.55972290039,
        -45.250122070313,
        13.399480819702
    )
    AddCameraShot(
        0.25503298640251,
        0.0037889999803156,
        -0.96681797504425,
        0.014364999718964,
        -45.806968688965,
        -47.785381317139,
        -45.429058074951
    )
    AddCameraShot(
        0.62141698598862,
        -0.11941699683666,
        -0.76041197776794,
        -0.14612799882889,
        -276.06744384766,
        -18.259653091431,
        -77.929229736328
    )
end
