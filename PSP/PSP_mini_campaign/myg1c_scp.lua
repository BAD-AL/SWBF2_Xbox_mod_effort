-- myg1c_scp.lua
-- Rebel Raider Competitive Multiplayer level
-- Verified

ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
ALL = 1
IMP = 2
ATT = ALL
DEF = IMP

function ScriptPostLoad()
    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 360)
    timelimit = 360
    fiveminremains = CreateTimer("fiveminremains")
    SetTimerValue(fiveminremains, 60)
    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 120)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 180)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 240)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 300)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 330)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 350)
    StartTimer(missiontimer)
    StartTimer(fiveminremains)
    StartTimer(fourminremains)
    StartTimer(threeminremains)
    StartTimer(twominremains)
    StartTimer(oneminremains)
    StartTimer(thirtysecremains)
    StartTimer(tensecremains)
    ShowTimer(missiontimer)
    SetProperty("flag1", "GeometryName", "myg1_prop_shield_generator")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag1", "AllowAIPickup", 0)
    SetProperty("flag2", "GeometryName", "myg1_prop_shield_generator")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag2", "AllowAIPickup", 0)
    SetProperty("flag3", "GeometryName", "myg1_prop_shield_generator")
    SetProperty("flag3", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag3", "AllowAIPickup", 0)
    SetProperty("flag4", "GeometryName", "myg1_prop_shield_generator")
    SetProperty("flag4", "CarriedGeometryName", "com_icon_alliance_contraband_carried")
    SetProperty("flag4", "AllowAIPickup", 0)
    SetClassProperty("myg1_prop_shield_generator", "DroppedColorize", 1)
    ctf =
        ObjectiveCTF:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            captureLimit = 3,
            popupText = "level.myg1c_s.objectives.detail",
            text = "level.myg1c_s.objectives.1",
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
    object_count = 3
    ctf:Start()

    ctf.OnCapture = function(arg1, arg2)
        object_count = object_count - 1
        if 0 < object_count then
            if object_count == 2 then
                ShowMessageText("level.myg1c_s.objectives.4")
            end
            if object_count == 1 then
                ShowMessageText("level.myg1c_s.objectives.5")
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
    AICanCaptureCP("CP1_CON", 2, false)
    AICanCaptureCP("CP2_CON", 2, false)
    AICanCaptureCP("CP4_CON", 2, false)
    SetAIDifficulty(-7, 2, "medium")
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
end

function ScriptInit()
    StealArtistHeap(135 * 1024)
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3996881)
        SetPSPClipper(0)
    else
        SetPS2ModelMemory(4880000)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1gcw")
    ReadDataFile("SIDE\\all.lvl", "all_inf_engineer_jungle", "all_hero_hansolo_tat", "all_hover_combatspeeder")
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_rocketeer",
        "imp_inf_officer",
        "imp_inf_sniper",
        "imp_inf_engineer",
        "imp_inf_dark_trooper",
        "imp_hero_bobafett",
        "imp_hover_fightertank",
        "imp_hover_speederbike",
        "imp_walk_atst"
    )
    if ScriptCB_GetPlatform() == "PSP" then
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
                    units = 25,
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
                    units = 25,
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
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("CommandWalker", 5)
    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("PowerupItem", 40)
    SetMemoryPoolSize("EntityMine", 30)
    SetMemoryPoolSize("EntityDroid", 12)
    SetMemoryPoolSize("Aimer", 100)
    SetMemoryPoolSize("Obstacle", 500)
    SetMemoryPoolSize("Decal", 0)
    SetMemoryPoolSize("PassengerSlot", 0)
    SetMemoryPoolSize("ParticleEmitter", 350)
    SetMemoryPoolSize("ParticleEmitterInfoData", 800)
    SetMemoryPoolSize("ParticleEmitterObject", 256)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Ordnance", 70)
    SetMemoryPoolSize("FlagItem", 5)
    SetMemoryPoolSize("EntityCloth", 24)
    SetSpawnDelay(10, 0.25)
    ReadDataFile("myg\\myg1.lvl", "myg1_Smuggler")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(ALL, 1, "all_myg_amb_start", 0, 1)
    SetAmbientMusic(ALL, 0.80000001192093, "all_myg_amb_middle", 1, 1)
    SetAmbientMusic(ALL, 0.20000000298023, "all_myg_amb_end", 2, 1)
    SetAmbientMusic(IMP, 1, "imp_myg_amb_start", 0, 1)
    SetAmbientMusic(IMP, 0.80000001192093, "imp_myg_amb_middle", 1, 1)
    SetAmbientMusic(IMP, 0.20000000298023, "imp_myg_amb_end", 2, 1)
    SetVictoryMusic(ALL, "all_myg_amb_victory")
    SetDefeatMusic(ALL, "all_myg_amb_defeat")
    SetVictoryMusic(IMP, "imp_myg_amb_victory")
    SetDefeatMusic(IMP, "imp_myg_amb_defeat")
    SetSoundEffect("CaptureFlag", "sfx_start_beep")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.94799000024796,
        -0.029190000146627,
        0.31680798530579,
        0.0097549995407462,
        -88.997039794922,
        14.15385055542,
        -17.227827072144
    )
    AddCameraShot(
        0.96342700719833,
        -0.26038599014282,
        -0.061110001057386,
        -0.016516000032425,
        -118.96892547607,
        39.055625915527,
        124.03238677979
    )
    AddCameraShot(
        0.73388397693634,
        -0.18114300072193,
        0.63560098409653,
        0.15688399970531,
        67.597633361816,
        39.055625915527,
        55.312774658203
    )
    AddCameraShot(
        0.0083149997517467,
        9.9999999747524e-007,
        -0.99996501207352,
        7.4000003223773e-005,
        -64.894348144531,
        5.541570186615,
        201.71109008789
    )
end
