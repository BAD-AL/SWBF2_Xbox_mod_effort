-- kas2g_dcm.lua
-- PSP 'Imperial Enforcer' Kashyyyk mission
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("MultiObjectiveContainer")
ALL = 2
IMP = 1
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    ShowAllUnitsOnMinimap(true)
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 480)
    sevenminremains = CreateTimer("sevenminremains")
    SetTimerValue(sevenminremains, 60)
    sixminremains = CreateTimer("sixminremains")
    SetTimerValue(sixminremains, 120)
    fiveminremains = CreateTimer("fiveminremains")
    SetTimerValue(fiveminremains, 180)
    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 240)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 300)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 360)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 420)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 450)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 470)
    StartTimer(missiontimer)
    StartTimer(sevenminremains)
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
            popupText = "level.kas2g_d.objectives.detail",
            text = "level.kas2g_d.objectives.1"
        }
    )

    Objective1.OnStart =
        function(self)
        Objective1WookieKill =
            OnObjectKill(
            function(object)
                if GetObjectTeam(object) == DEF then
                    wookie_count = GetReinforcementCount(DEF) - 1
                    if wookie_count == 40 then
                        ShowMessageText("level.kas2g_d.objectives.2")
                    end
                    if wookie_count == 30 then
                        ShowMessageText("level.kas2g_d.objectives.3")
                    end
                    if wookie_count == 25 then
                        ShowMessageText("level.kas2g_d.objectives.4")
                    end
                    if wookie_count == 20 then
                        ShowMessageText("level.kas2g_d.objectives.5")
                    end
                    if wookie_count == 15 then
                        ShowMessageText("level.kas2g_d.objectives.6")
                    end
                    if wookie_count == 10 then
                        ShowMessageText("level.kas2g_d.objectives.7")
                    end
                    if wookie_count == 5 then
                        ShowMessageText("level.kas2g_d.objectives.8")
                    end
                    if wookie_count == 3 then
                        ShowMessageText("level.kas2g_d.objectives.9")
                    end
                    if wookie_count == 2 then
                        ShowMessageText("level.kas2g_d.objectives.10")
                    end
                    if wookie_count == 1 then
                        ShowMessageText("level.kas2g_d.objectives.11")
                    end
                    if wookie_count == 0 then
                        Objective1:Complete(ATT)
                        ShowMessageText("level.kas2g_d.objectvies.12")
                        ReleaseObjectKill(Objective1WookieKill)
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
            ShowMessageText("level.common.time.7min")
        end,
        "sevenminremains"
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
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    OnObjectKillName(PlayAnimDown, "gatepanel")
    OnObjectRespawnName(PlayAnimUp, "gatepanel")
    OnObjectKillName(woodl, "woodl")
    OnObjectKillName(woodc, "woodc")
    OnObjectKillName(woodr, "woodr")
end

function PlayAnimDown()
    PauseAnimation("thegateup")
    RewindAnimation("thegatedown")
    PlayAnimation("thegatedown")
    ShowMessageText("level.kas2.objectives.gateopen", 1)
    ScriptCB_SndPlaySound("KAS_obj_13")
    PlayAnimation("gatepanel")
    UnblockPlanningGraphArcs("seawall1")
    DisableBarriers("seawalldoor1")
    DisableBarriers("vehicleblocker")
end

function PlayAnimUp()
    PauseAnimation("thegatedown")
    RewindAnimation("thegateup")
    PlayAnimation("thegateup")
    BlockPlanningGraphArcs("seawall1")
    EnableBarriers("seawalldoor1")
    EnableBarriers("vehicleblocker")
end

function woodl()
    UnblockPlanningGraphArcs("woodl")
    DisableBarriers("woodl")
end

function woodc()
    UnblockPlanningGraphArcs("woodc")
    DisableBarriers("woodc")
end

function woodr()
    UnblockPlanningGraphArcs("woodr")
    DisableBarriers("woodr")
end

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2947837)
        SetPSPClipper(0)
    else
        SetPS2ModelMemory(3550000)
    end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    ReadDataFile("sound\\kas.lvl;kas2gcw")
    ReadDataFile("SIDE\\all.lvl", "all_hover_combatspeeder", "all_inf_wookiee")
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_rocketeer",
        "imp_inf_engineer",
        "imp_inf_sniper",
        "imp_inf_officer",
        "imp_inf_dark_trooper",
        "imp_hover_fightertank",
        "imp_hover_speederbike",
        "imp_hero_bobafett"
    )
    ReadDataFile("SIDE\\wok.lvl", "wok_inf_basic")
    ReadDataFile("SIDE\\tur.lvl", "tur_bldg_recoilless_lg")
    SetupTeams(
        {
            all = {
                team = ALL,
                units = 25,
                reinforcements = 50,
                soldier = {"wok_inf_mechanic", 5},
                engineer = {"wok_inf_warrior", 20}
            },
            imp = {
                team = IMP,
                units = 4,
                reinforcements = -1,
                soldier = {"imp_inf_rifleman"},
                assault = {"imp_inf_rocketeer"},
                engineer = {"imp_inf_engineer"},
                sniper = {"imp_inf_sniper"},
                officer = {"imp_inf_officer"},
                special = {"imp_inf_dark_trooper"}
            }
        }
    )
    AddAIGoal(1, "Deathmatch", 1000)
    AddAIGoal(2, "Deathmatch", 1000)
    SetTeamName(1, "Empire")
    SetTeamName(2, "Wookiees")
    ForceHumansOntoTeam1()
    SetAIDifficulty(2, 1)
    SetHeroClass(IMP, "imp_hero_bobafett")
    ClearWalkers()
    AddWalkerType(0, 0)
    AddWalkerType(1, 0)
    AddWalkerType(2, 3)
    AddWalkerType(3, 0)
    SetMemoryPoolSize("EntityLight", 44)
    SetMemoryPoolSize("CommandWalker", 0)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("EntityHover", 9)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("EntityBuildingArmedDynamic", 0)
    SetMemoryPoolSize("PowerupItem", 30)
    SetMemoryPoolSize("EntityMine", 30)
    SetMemoryPoolSize("Aimer", 100)
    SetMemoryPoolSize("Obstacle", 600)
    SetMemoryPoolSize("Weapon", 265)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetSpawnDelay(3, 0.25)
    ReadDataFile("KAS\\kas2.lvl", "kas2_Sniper")
    SetDenseEnvironment("false")
    SetNumBirdTypes(1)
    SetBirdType(0, 1, "bird")
    SetNumFishTypes(1)
    SetFishType(0, 0.80000001192093, "fish")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(ALL, 1, "all_kas_amb_start", 0, 1)
    SetAmbientMusic(IMP, 1, "imp_kas_amb_start", 0, 1)
    SetVictoryMusic(ALL, "all_kas_amb_victory")
    SetDefeatMusic(ALL, "all_kas_amb_defeat")
    SetVictoryMusic(IMP, "imp_kas_amb_victory")
    SetDefeatMusic(IMP, "imp_kas_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.99366897344589,
        -0.09961000084877,
        -0.051708001643419,
        -0.0051830001175404,
        109.47354888916,
        34.506076812744,
        272.88922119141
    )
    AddCameraShot(
        -0.13082699477673,
        0.02471400052309,
        -0.97387301921844,
        -0.18396799266338,
        146.41287231445,
        60.191699981689,
        -191.87882995605
    )
    AddCameraShot(
        0.94083100557327,
        -0.10825499892235,
        -0.31901299953461,
        -0.036706998944283,
        -65.793930053711,
        66.455177307129,
        289.43267822266
    )
    AddCameraShot(
        0.52312701940536,
        -0.055344998836517,
        -0.84573602676392,
        -0.089475996792316,
        -170.51907348633,
        66.455177307129,
        -248.87753295898
    )
end
