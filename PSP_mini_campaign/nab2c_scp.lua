-- nab2c_scp.lua
-- Rebel Raider Competitive Multiplayer level
-- Verified

ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
ALL = 1
IMP = 2
ATT = ALL
DEF = IMP

function ScriptPostLoad()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 330)
    timelimit = 330
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
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
    SetProperty("flag1", "GeometryName", "tan4_prop_console")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag1", "AllowAIPickup", 0)
    SetProperty("flag2", "GeometryName", "tan4_prop_console")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag2", "AllowAIPickup", 0)
    SetProperty("flag3", "GeometryName", "tan4_prop_console")
    SetProperty("flag3", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag3", "AllowAIPickup", 0)
    SetProperty("flag4", "GeometryName", "tan4_prop_console")
    SetProperty("flag4", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag4", "AllowAIPickup", 0)
    SetProperty("flag5", "GeometryName", "tan4_prop_console")
    SetProperty("flag5", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag5", "AllowAIPickup", 0)
    SetProperty("flag6", "GeometryName", "tan4_prop_console")
    SetProperty("flag6", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag6", "AllowAIPickup", 0)
    SetProperty("flag7", "GeometryName", "tan4_prop_console")
    SetProperty("flag7", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag7", "AllowAIPickup", 0)
    SetClassProperty("myg1_prop_shield_generator", "DroppedColorize", 1)
    ctf =
        ObjectiveCTF:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            captureLimit = 4,
            popupText = "level.nab2c_s.objectives.detail",
            text = "level.nab2c_s.objectives.1",
            hideCPs = false,
            multiplayerRules = true
        }
    )
    ctf:AddFlag(
        {
            name = "flag1",
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
    ctf:AddFlag(
        {
            name = "flag6",
            homeRegion = "",
            captureRegion = "togozone6",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen2",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag7",
            homeRegion = "",
            captureRegion = "togozone7",
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
                ShowMessageText("level.nab2c_s.objectives.5")
            end
            if object_count == 2 then
                ShowMessageText("level.nab2c_s.objectives.6")
            end
            if object_count == 1 then
                ShowMessageText("level.nab2c_s.objectives.7")
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
    AICanCaptureCP("CP1", 2, false)
    AICanCaptureCP("CP2", 2, false)
    AICanCaptureCP("CP4", 2, false)
    SetAIDifficulty(-1, 2, "medium")
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
end

function ScriptInit()
    StealArtistHeap(135 * 1024)
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(1979297)
        SetPSPClipper(1)
    else
        SetPS2ModelMemory(4880000)
    end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(ALL, 0.75)
    SetTeamAggressiveness(IMP, 1)
    SetMaxFlyHeight(40)
    SetMaxPlayerFlyHeight(40)
    ReadDataFile("sound\\nab.lvl;nab2gcw")
    ReadDataFile("SIDE\\all.lvl", "all_inf_engineer_jungle", "all_hero_hansolo_tat")
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_rocketeer",
        "imp_inf_engineer",
        "imp_inf_sniper",
        "imp_inf_officer",
        "imp_inf_dark_trooper"
    )
    ClearWalkers()
    AddWalkerType(0, 8)
    AddWalkerType(1, 0)
    AddWalkerType(2, 0)
    AddWalkerType(3, 4)
    SetMemoryPoolSize("Weapon", 280)
    SetMemoryPoolSize("CommandWalker", 0)
    SetMemoryPoolSize("MountedTurret", 55)
    SetMemoryPoolSize("EntityFlyer", 1)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("PowerupItem", 40)
    SetMemoryPoolSize("EntityMine", 40)
    SetMemoryPoolSize("Aimer", 220)
    SetMemoryPoolSize("FlagItem", 7)
    if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams(
            {
                all = {
                    team = ALL,
                    units = 6,
                    reinforcements = -1,
                    engineer = {"all_inf_engineer_jungle"}
                },
                imp = {
                    team = IMP,
                    units = 8,
                    reinforcements = -1,
                    soldier = {"imp_inf_rifleman"},
                    assault = {"imp_inf_rocketeer"},
                    engineer = {"imp_inf_engineer"},
                    sniper = {"imp_inf_sniper"},
                    officer = {"imp_inf_officer"},
                    special = {"imp_inf_dark_trooper", 1, 4}
                }
            }
        )
    else
        SetupTeams(
            {
                all = {
                    team = ALL,
                    units = 4,
                    reinforcements = -1,
                    engineer = {"all_inf_engineer_jungle"}
                },
                imp = {
                    team = IMP,
                    units = 15,
                    reinforcements = -1,
                    soldier = {"imp_inf_rifleman"},
                    assault = {"imp_inf_rocketeer"},
                    engineer = {"imp_inf_engineer"},
                    sniper = {"imp_inf_sniper"},
                    officer = {"imp_inf_officer"},
                    special = {"imp_inf_dark_trooper", 1, 4}
                }
            }
        )
    end
    ForceHumansOntoTeam1()
    SetUnitCount(ATT, 4)
    SetReinforcementCount(ATT, -1)
    SetUnitCount(DEF, 15)
    SetReinforcementCount(DEF, -1)
    AddAIGoal(ATT, "Deathmatch", 100)
    AddAIGoal(DEF, "Deathmatch", 100)
    SetSpawnDelay(10, 0.25)
    ReadDataFile("NAB\\nab2.lvl", "naboo2_Smuggler")
    SetDenseEnvironment("true")
    AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    SetNumBirdTypes(1)
    SetBirdType(0, 1, "bird")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(ALL, 1, "all_nab_amb_start", 0, 1)
    SetAmbientMusic(ALL, 0.80000001192093, "all_nab_amb_middle", 1, 1)
    SetAmbientMusic(ALL, 0.20000000298023, "all_nab_amb_end", 2, 1)
    SetAmbientMusic(IMP, 1, "imp_nab_amb_start", 0, 1)
    SetAmbientMusic(IMP, 0.80000001192093, "imp_nab_amb_middle", 1, 1)
    SetAmbientMusic(IMP, 0.20000000298023, "imp_nab_amb_end", 2, 1)
    SetVictoryMusic(IMP, "imp_nab_amb_victory")
    SetDefeatMusic(IMP, "imp_nab_amb_defeat")
    SetVictoryMusic(ALL, "all_nab_amb_victory")
    SetDefeatMusic(ALL, "all_nab_amb_defeat")
    SetSoundEffect("CaptureFlag", "sfx_start_beep")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.98306602239609,
        -0.039190001785755,
        0.17886799573898,
        0.0071310000494123,
        44.779041290283,
        -92.555015563965,
        223.60920715332
    )
    AddCameraShot(
        0.55807101726532,
        -0.0048639997839928,
        -0.82974702119827,
        -0.0072320001199841,
        -99.522422790527,
        -104.18943786621,
        102.9930267334
    )
    AddCameraShot(
        -0.18034499883652,
        0.002299000043422,
        -0.98352098464966,
        -0.012535000219941,
        38.772453308105,
        -105.3145980835,
        24.777696609497
    )
end
