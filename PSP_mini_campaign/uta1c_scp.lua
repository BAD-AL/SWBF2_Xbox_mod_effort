-- uta1c_scp.lua
-- Rebel Raider Competitive Multiplayer level

ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
ALL = 1
IMP = 2
ATT = ALL
DEF = IMP

function ScriptPostLoad()
    ForceHumansOntoTeam1()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 600)
    timelimit = 600
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
    SetProperty("Flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("Flag1", "CarriedGeometryName", "com_icon_alliance_flag_carried")
    SetProperty("Flag1", "AllowAIPickup", 0)
    SetProperty("flag2", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_alliance_flag_carried")
    SetProperty("flag2", "AllowAIPickup", 0)
    SetProperty("flag3", "GeometryName", "com_icon_republic_flag")
    SetProperty("flag3", "CarriedGeometryName", "com_icon_alliance_flag_carried")
    SetProperty("flag3", "AllowAIPickup", 0)
    SetClassProperty("com_item_flag", "DroppedColorize", 1)
    ctf =
        ObjectiveCTF:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            captureLimit = 3,
            textATT = "level.uta1c_s.objectives.1",
            textDEF = "level.uta1c_s.objectives.1",
            hideCPs = false,
            multiplayerRules = true
        }
    )
    ctf:AddFlag(
        {
            name = "flag1",
            homeRegion = "",
            captureRegion = "togozone",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag2",
            homeRegion = "",
            captureRegion = "togozone",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen",
            mapIconScale = 3
        }
    )
    ctf:AddFlag(
        {
            name = "flag3",
            homeRegion = "",
            captureRegion = "togozone",
            capRegionMarker = "hud_objective_icon_circle",
            capRegionMarkerScale = 3,
            icon = "",
            mapIcon = "hud_target_flag_onscreen",
            mapIconScale = 3
        }
    )
    object_count = 3
    ctf:Start()

    ctf.OnCapture = function(arg1, arg2)
        object_count = object_count - 1
        if 0 < object_count then
            if object_count == 2 then
                ShowMessageText("level.uta1c_s.objectives.2")
            end
            if object_count == 1 then
                ShowMessageText("level.uta1c_s.objectives.3")
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
    AICanCaptureCP("CON_CP1", 2, false)
    AICanCaptureCP("con_CP1a", 2, false)
    AICanCaptureCP("CON_CP5", 2, false)
    AICanCaptureCP("CON_CP6", 2, false)
    AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
end

function ScriptInit()
    StealArtistHeap(135 * 1024)
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4018257)
    else
        SetPS2ModelMemory(4880000)
    end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)
    ReadDataFile("sound\\uta.lvl;uta1gcw")
    ReadDataFile(
        "SIDE\\all.lvl",
        "all_inf_engineer_jungle",
        "all_inf_sniper_jungle",
        "all_hero_hansolo_tat",
        "all_inf_wookiee2",
        "all_hero_hansolo_tat"
    )
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_rocketeer",
        "imp_inf_engineer",
        "imp_inf_sniper",
        "imp_inf_officer",
        "imp_inf_dark_trooper",
        "imp_hero_bobafett",
        "imp_fly_destroyer_dome",
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
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    SetSpawnDelay(10, 0.25)
    ClearWalkers()
    AddWalkerType(1, 4)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("EntityLight", 80)
    SetMemoryPoolSize("EntityFlyer", 0)
    SetMemoryPoolSize("EntityDroid", 10)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("EntityCloth", 24)
    SetMemoryPoolSize("Weapon", 260)
    SetMemoryPoolSize("FlagItem", 3)
    ReadDataFile("uta\\uta1.lvl", "uta1_Smuggler")
    SetDenseEnvironment("false")
    AddDeathRegion("DeathRegion01")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(ALL, 1, "all_uta_amb_start", 0, 1)
    SetAmbientMusic(IMP, 1, "imp_uta_amb_start", 0, 1)
    SetVictoryMusic(ALL, "all_uta_amb_victory")
    SetDefeatMusic(ALL, "all_uta_amb_defeat")
    SetVictoryMusic(IMP, "imp_uta_amb_victory")
    SetDefeatMusic(IMP, "imp_uta_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetSoundEffect("CaptureFlag", "sfx_start_beep")
    AddCameraShot(
        -0.42809098958969,
        0.045648999512196,
        -0.89749401807785,
        -0.09570299834013,
        162.71495056152,
        45.857063293457,
        40.647117614746
    )
    AddCameraShot(
        -0.19486099481583,
        -0.0015999999595806,
        -0.98079597949982,
        0.0080549996346235,
        -126.17978668213,
        16.113788604736,
        70.012893676758
    )
    AddCameraShot(
        -0.46254798769951,
        -0.020921999588609,
        -0.88544201850891,
        0.040049999952316,
        -16.947637557983,
        4.5617961883545,
        156.92695617676
    )
    AddCameraShot(
        0.99531000852585,
        0.0245820004493,
        -0.093534998595715,
        0.0023099998943508,
        38.288612365723,
        4.5617961883545,
        243.29850769043
    )
    AddCameraShot(
        0.82706999778748,
        0.017092999070883,
        0.56171900033951,
        -0.01160900015384,
        -24.457637786865,
        8.8341455459595,
        296.54458618164
    )
    AddCameraShot(
        0.99887502193451,
        0.0049120001494884,
        -0.047173999249935,
        0.00023200000578072,
        -45.868236541748,
        2.9782149791718,
        216.21788024902
    )
end
