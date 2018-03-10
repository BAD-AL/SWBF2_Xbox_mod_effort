-- spa1g_scm.lua
-- PSP Mission Script; 'Rebel Raider' Space level
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
IMP = 1
ALL = 2
ATT = 2
DEF = 1

function ScriptPostLoad()
    PlayAnimation("CTF_circle")
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 900)
    timelimit = 900
    fiveminremains = CreateTimer("fiveminremains")
    SetTimerValue(fiveminremains, 600)
    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 660)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 720)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 780)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 840)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 870)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 890)
    StartTimer(missiontimer)
    StartTimer(fiveminremains)
    StartTimer(fourminremains)
    StartTimer(threeminremains)
    StartTimer(twominremains)
    StartTimer(oneminremains)
    StartTimer(thirtysecremains)
    StartTimer(tensecremains)
    ShowTimer(missiontimer)
    SetProperty("Flag1", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("Flag1", "AllowAIPickup", 0)
    SetProperty("flag2", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag2", "AllowAIPickup", 0)
    SetProperty("flag3", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag3", "AllowAIPickup", 0)
    SetProperty("flag4", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag4", "AllowAIPickup", 0)
    SetProperty("flag5", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag5", "AllowAIPickup", 0)
    SetClassProperty("com_item_flag", "DroppedColorize", 1)
    Objective1 = Objective:New({teamATT = ATT, teamDEF = DEF, popupText = "level.spa1g_s.objectives.detail"})
    Objective1:Start()
    ctf =
        ObjectiveCTF:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            captureLimit = 4,
            popupText = "level.spa1g_s.objectives.detail",
            text = "level.spa1g_s.objectives.1",
            hideCPs = false,
            multiplayerRules = true,
            AIGoalWeight = 0
        }
    )
    ctf:AddFlag(
        {
            name = "Flag1",
            homeRegion = "",
            captureRegion = "togozone1",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag2",
            homeRegion = "",
            captureRegion = "togozone2",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag3",
            homeRegion = "",
            captureRegion = "togozone3",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag4",
            homeRegion = "",
            captureRegion = "togozone4",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag5",
            homeRegion = "",
            captureRegion = "togozone5",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    object_count = 4
    ctf:Start()

    ctf.OnCapture = function(arg1, arg2)
        object_count = object_count - 1
        if 0 < object_count then
            if object_count == 3 then
                ShowMessageText("level.spa1g_s.objectives.7")
            end
            if object_count == 2 then
                ShowMessageText("level.spa1g_s.objectives.8")
            end
            if object_count == 1 then
                ShowMessageText("level.spa1g_s.objectives.9")
            end
        end
        if object_count == 0 then
            MissionVictory(ATT)
        end
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

    SetAIDifficulty(-2, 4, "medium")
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
    ForceFlyerPlayerCentric(true)
    SetProperty("MP_cp2", "SpawnPath", "CAM_CP2Spawn")
    SetProperty("MP_cp1", "SpawnPath", "CAM_CP1Spawn")
    DisableBarriers("impblock")
    BlockPlanningGraphArcs(2)
    SetProperty("ALL_Door01", "IsLocked", 2)
    SetProperty("ALL_Door02", "IsLocked", 2)
    SetProperty("ALL_Door3", "IsLocked", 2)
    SetProperty("ALL_Door4", "IsLocked", 2)
    SetProperty("ALL_Door5", "IsLocked", 2)
    SetProperty("Impdoor01", "IsLocked", 2)
    SetProperty("Impdoor02", "IsLocked", 2)
    SetProperty("Impdoor03", "IsLocked", 2)
    SetProperty("spa1_prop_impDoor2", "IsLocked", 1)
    SetProperty("spa1_prop_impDoor3", "IsLocked", 1)
end

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3554101)
        SetPSPClipper(1)
    else
        SetPS2ModelMemory(4850000)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("SPA\\spa_sky.lvl", "yav")
    ReadDataFile("sound\\spa.lvl;spa1gcw")
    ScriptCB_SetDopplerFactor(0.40000000596046)
    ScaleSoundParameter("explosion", "MaxDistance", 15)
    ScaleSoundParameter("explosion", "MuteDistance", 15)
    ForceFlyerPlayerCentric(true)
    SetMinFlyHeight(-490)
    SetMaxFlyHeight(1400)
    SetMinPlayerFlyHeight(-490)
    SetMaxPlayerFlyHeight(1400)
    SetAIVehicleNotifyRadius(100)
    ReadDataFile(
        "SIDE\\all.lvl",
        "all_inf_pilot",
        "all_inf_marine",
        "all_hero_hansolo_tat",
        "all_fly_xwing_sc",
        "all_fly_ywing_sc",
        "all_fly_awing"
    )
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_pilot",
        "imp_inf_marine",
        "imp_fly_tiefighter_sc",
        "imp_fly_tiebomber_sc",
        "imp_fly_tieinterceptor"
    )
    ReadDataFile(
        "SIDE\\tur.lvl",
        "tur_bldg_spa_all_recoilless",
        "tur_bldg_spa_all_beam",
        "tur_bldg_spa_imp_recoilless",
        "tur_bldg_spa_imp_chaingun",
        "tur_bldg_chaingun_roof"
    )
    ClearWalkers()
    local weaponCnt = 218
    SetMemoryPoolSize("Aimer", 170)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 25)
    SetMemoryPoolSize("Combo::DamageSample", 128)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityLight", 106)
    SetMemoryPoolSize("EntityMine", 16)
    SetMemoryPoolSize("EntityRemoteTerminal", 12)
    SetMemoryPoolSize("EntitySoundStream", 10)
    SetMemoryPoolSize("EntitySoundStatic", 3)
    SetMemoryPoolSize("FlagItem", 9)
    SetMemoryPoolSize("MountedTurret", 50)
    SetMemoryPoolSize("Navigator", 32)
    SetMemoryPoolSize("Obstacle", 95)
    SetMemoryPoolSize("PathFollower", 32)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 100)
    SetMemoryPoolSize("UnitAgent", 74)
    SetMemoryPoolSize("UnitController", 74)
    SetMemoryPoolSize("Weapon", weaponCnt)
    ForceHumansOntoTeam2()
    SetupTeams(
        {
            all = {
                team = ALL,
                units = 4,
                reinforcements = -1,
                pilot = {"all_inf_pilot", 2},
                marine = {"all_inf_marine", 2}
            },
            imp = {
                team = IMP,
                units = 12,
                reinforcements = -1,
                pilot = {"imp_inf_pilot", 10},
                marine = {"imp_inf_marine", 2}
            }
        }
    )
    SetSpawnDelay(10, 0.25)
    ReadDataFile("spa\\spa1.lvl", "spa1_Smuggler")
    SetDenseEnvironment("false")
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    SetParticleLODBias(3000)
    SetMaxCollisionDistance(1000)
    FillAsteroidRegion("asteroid_region1", "spa1_prop_asteroid_02", 30, 1, 0, 0, -1, 0, 0)
    FillAsteroidPath("asteroid_path1", 10, "spa1_prop_asteroid_01", 75, 1, 0, 0, -1, 0, 0)
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)
    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", 0.10000000149012, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", 0.10000000149012, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", 0.10000000149012, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", 0.10000000149012, 1)
    SetOutOfBoundsVoiceOver(ALL, "allleaving")
    SetOutOfBoundsVoiceOver(IMP, "impleaving")
    SetAmbientMusic(ALL, 1, "all_spa_amb_start", 0, 1)
    SetAmbientMusic(ALL, 0.99000000953674, "all_spa_amb_middle", 1, 1)
    SetAmbientMusic(ALL, 0.10000000149012, "all_spa_amb_end", 2, 1)
    SetAmbientMusic(IMP, 1, "imp_spa_amb_start", 0, 1)
    SetAmbientMusic(IMP, 0.99000000953674, "imp_spa_amb_middle", 1, 1)
    SetAmbientMusic(IMP, 0.10000000149012, "imp_spa_amb_end", 2, 1)
    SetVictoryMusic(ALL, "all_spa_amb_victory")
    SetDefeatMusic(ALL, "all_spa_amb_defeat")
    SetVictoryMusic(IMP, "imp_spa_amb_victory")
    SetDefeatMusic(IMP, "imp_spa_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.60127598047256,
        0.010906999930739,
        -0.79883599281311,
        0.014491000212729,
        -2234.3544921875,
        -88.271575927734,
        -456.20977783203
    )
    AddCameraShot(
        0.82673400640488,
        -0.18764999508858,
        0.51721900701523,
        0.1173970028758,
        3129.375,
        1362.2141113281,
        1175.9616699219
    )
    AddCameraShot(
        0.80746299028397,
        -0.15978699922562,
        -0.55706399679184,
        -0.11023599654436,
        -3033.0405273438,
        1086.6322021484,
        1174.1828613281
    )
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2Control")
    if gPlatformStr == "PS2" then
        ScriptCB_DisableFlyerShadows()
    end
end
