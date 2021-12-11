--pol1c_mcm.lua
-- PSP 'Rogue Assassin' Polis Massa mission
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("Ambush")
REP = 1
CIS = 2
locals = 3
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 360)
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
    OnTimerElapse(
        function()
            MissionVictory(DEF)
        end,
        "missiontimer"
    )

    TDM = ObjectiveTDM:New({teamATT = 1, teamDEF = 2, textATT = "level.pol1c_m.merc.merc1", multiplayerRules = true})
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
    StartTimer(fiveminremains)
    StartTimer(fourminremains)
    StartTimer(threeminremains)
    StartTimer(twominremains)
    StartTimer(oneminremains)
    StartTimer(thirtysecremains)
    StartTimer(tensecremains)

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
    fourminremains1 = CreateTimer("fourminremains1")
    SetTimerValue(fourminremains1, 60)
    threeminremains1 = CreateTimer("threeminremains1")
    SetTimerValue(threeminremains1, 120)
    twominremains1 = CreateTimer("twominremains1")
    SetTimerValue(twominremains1, 180)
    oneminremains1 = CreateTimer("oneminremains1")
    SetTimerValue(oneminremains1, 240)
    thirtysecremains1 = CreateTimer("thirtysecremains1")
    SetTimerValue(thirtysecremains1, 270)
    tensecremains1 = CreateTimer("tensecremains1")
    SetTimerValue(tensecremains1, 290)

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.4min")
        end,
        "fourminremains1"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.3min")
        end,
        "threeminremains1"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.2min")
        end,
        "twominremains1"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.1min")
        end,
        "oneminremains1"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.30sec")
        end,
        "thirtysecremains1"
    )

    OnTimerElapse(
        function()
            ShowMessageText("level.common.time.10sec")
        end,
        "tensecremains1"
    )

    AAT_count = 3
    AAT = TargetType:New({classname = "cis_inf_officer", killLimit = 3})
    AAT.OnDestroy = function(self, objectPtr)
        AAT_count = AAT_count - 1
        ShowMessageText("level.pol1c_m.merc.2-" .. AAT_count, ATT)
    end
    Objective2 =
        ObjectiveAssault:New({teamATT = ATT, teamDEF = DEF, AIGoalWeight = 1, textATT = "level.pol1c_m.merc.end2"})
    Objective2:AddTarget(AAT)

    Objective2.OnComplete = function(self)
        MissionVictory(ATT)
    end

    AAB_count = 3
    AAB = TargetType:New({classname = "cis_inf_officer", killLimit = 3})
    AAB.OnDestroy = function(self, objectPtr)
        AAB_count = AAB_count - 1
        ShowMessageText("level.pol1c_m.merc.1-" .. AAB_count, ATT)
    end
    Objective1 =
        ObjectiveAssault:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            AIGoalWeight = 1,
            textATT = "level.pol1c_m.merc.end",
            popupText = "level.pol1c_m.merc.popup"
        }
    )
    Objective1:AddTarget(AAB)
    Objective1.OnComplete = function(self)
        StartTimer(missiontimer3)
        StopTimer(fiveminremains)
        StopTimer(fourminremains)
        StopTimer(threeminremains)
        StopTimer(twominremains)
        StopTimer(oneminremains)
        StopTimer(thirtysecremains)
        StopTimer(tensecremains)
    end

    missiontimer2 = CreateTimer("missiontimer2")
    SetTimerValue(missiontimer2, 1)
    StartTimer(missiontimer2)
    OnTimerElapse(
        function()
            Ambush("off_path", 3, 3)
            AddAIGoal(3, "Deathmatch", 9999)
            followguy1 = GetTeamMember(3, 0)
            followthatguy1 = AddAIGoal(2, "Follow", 3, followguy1)
            followguy2 = GetTeamMember(3, 1)
            followthatguy2 = AddAIGoal(2, "Follow", 3, followguy2)
            followguy3 = GetTeamMember(3, 2)
            followthatguy3 = AddAIGoal(2, "Follow", 3, followguy3)
            AddAIGoal(2, "Deathmatch", 1)
            SetAIDifficulty(2, 2, "medium")
            SetAIDifficulty(3, 5, "medium")
        end,
        "missiontimer2"
    )
    missiontimer3 = CreateTimer("missiontimer3")
    SetTimerValue(missiontimer3, 2)
    OnTimerElapse(
        function()
            Ambush("off_path2", 2, 3)
            Ambush("off_path3", 1, 3)
            AddAIGoal(3, "Deathmatch", 9999)
            followguy4 = GetTeamMember(3, 3)
            followthatguy4 = AddAIGoal(2, "Follow", 3, followguy4)
            followguy5 = GetTeamMember(3, 4)
            followthatguy5 = AddAIGoal(2, "Follow", 3, followguy5)
            followguy6 = GetTeamMember(3, 5)
            followthatguy6 = AddAIGoal(2, "Follow", 3, followguy6)
            SetTimerValue(missiontimer, 300)
            AddAIGoal(2, "Deathmatch", 1)
            SetTimerValue(missiontimer, 300)
            SetAIDifficulty(2, 2, "medium")
            SetAIDifficulty(3, 5, "medium")
            StartTimer(fourminremains1)
            StartTimer(threeminremains1)
            StartTimer(twominremains1)
            StartTimer(oneminremains1)
            StartTimer(thirtysecremains1)
            StartTimer(tensecremains1)
        end,
        "missiontimer3"
    )
    objectiveSequence = MultiObjectiveContainer:New({})
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(TDM)
    objectiveSequence:Start()
    OnObjectRespawnName(PlayAnimLock01Open, "LockCon01")
    OnObjectKillName(PlayAnimLock01Close, "LockCon01")
end

function PlayAnimLock01Open()
    PauseAnimation("Airlockclose")
    RewindAnimation("Airlockopen")
    PlayAnimation("Airlockopen")
end

function PlayAnimLock01Close()
    PauseAnimation("Airlockopen")
    RewindAnimation("Airlockclose")
    PlayAnimation("Airlockclose")
end

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2598193)
    else
        SetPS2ModelMemory(4090000)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\pol.lvl;pol1cw")
    SetMapNorthAngle(0)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight(25)
    ReadDataFile("SIDE\\cis.lvl", "cis_inf_rifleman", "cis_inf_officer", "cis_hover_aat", "cis_hero_jangofett")
    ReadDataFile("SIDE\\rep.lvl", "rep_inf_ep2_jettrooper_rifleman2")
    ForceHumansOntoTeam1()
    SetTeamName(1, "REP")
    SetTeamIcon(1, "rep_icon")
    AddUnitClass(1, "rep_inf_ep2_jettrooper_rifleman2", 1)
    SetHeroClass(1, "cis_hero_jangofett")
    SetTeamName(2, "cis")
    SetTeamIcon(2, "cis_icon")
    AddUnitClass(2, "cis_inf_rifleman", 4)
    SetUnitCount(ATT, 4)
    SetReinforcementCount(ATT, -1)
    SetUnitCount(DEF, 12)
    SetReinforcementCount(DEF, -1)
    SetTeamName(locals, "cis")
    AddUnitClass(locals, "cis_inf_officer", 6)
    SetUnitCount(locals, 12)
    SetTeamAsFriend(locals, CIS)
    SetTeamAsFriend(CIS, locals)
    SetTeamAsEnemy(locals, 1)
    SetTeamAsEnemy(1, locals)
    SetReinforcementCount(locals, 6)
    ClearWalkers()
    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("EntityFlyer", 0)
    SetMemoryPoolSize("EntityDroid", 10)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("Obstacle", 380)
    SetMemoryPoolSize("Weapon", 260)
    SetMemoryPoolSize("EntityLight", 63)
    if gPlatformStr == "XBox" then
        SetMemoryPoolSize("Asteroid", 100)
    else
        if gPlatformStr == "PS2" then
            SetMemoryPoolSize("Asteroid", 100)
        else
            SetMemoryPoolSize("Asteroid", 100)
        end
    end
    SetSpawnDelay(10, 0.25)
    ReadDataFile("pol\\pol1.lvl", "pol1_merc")
    SetDenseEnvironment("True")
    AddDeathRegion("deathregion1")
    SetParticleLODBias(3000)
    SetMaxCollisionDistance(1500)
    if gPlatformStr == "XBox" then
        FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1, 0, 0, -1, 0, 0)
        FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1, 0, 0, -1, 0, 0)
        FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1, 0, 0, -1, 0, 0)
        FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1, 0, 0, -1, 0, 0)
        FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1, 0, 0, -1, 0, 0)
    else
        if gPlatformStr == "PS2" then
            FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1, 0, 0, -1, 0, 0)
        else
            FillAsteroidPath("pathas01", 10, "pol1_prop_asteroid_01", 20, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas01", 20, "pol1_prop_asteroid_02", 40, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas02", 10, "pol1_prop_asteroid_01", 10, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas03", 10, "pol1_prop_asteroid_02", 20, 1, 0, 0, -1, 0, 0)
            FillAsteroidPath("pathas04", 5, "pol1_prop_asteroid_02", 2, 1, 0, 0, -1, 0, 0)
        end
    end
    OpenAudioStream("sound\\global.lvl", "cw_music")
    SetOutOfBoundsVoiceOver(2, "repleaving")
    SetAmbientMusic(REP, 1, "rep_pol_amb_start", 0, 1)
    SetAmbientMusic(REP, 0.80000001192093, "rep_pol_amb_middle", 1, 1)
    SetAmbientMusic(REP, 0.20000000298023, "rep_pol_amb_end", 2, 1)
    SetAmbientMusic(CIS, 1, "cis_pol_amb_start", 0, 1)
    SetAmbientMusic(CIS, 0.80000001192093, "cis_pol_amb_middle", 1, 1)
    SetAmbientMusic(CIS, 0.20000000298023, "cis_pol_amb_end", 2, 1)
    SetVictoryMusic(REP, "rep_pol_amb_victory")
    SetDefeatMusic(REP, "rep_pol_amb_defeat")
    SetVictoryMusic(CIS, "cis_pol_amb_victory")
    SetDefeatMusic(CIS, "cis_pol_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.85406500101089,
        -0.16903600096703,
        0.48257398605347,
        0.095509998500347,
        128.82421875,
        30.888416290283,
        -38.9797706604
    )
    AddCameraShot(
        -0.41455799341202,
        0.013601000420749,
        -0.90943199396133,
        -0.029836000874639,
        134.57727050781,
        22.840515136719,
        -72.278869628906
    )
    AddCameraShot(
        -0.1275289952755,
        0.0026879999786615,
        -0.99161100387573,
        -0.020903000608087,
        108.37355041504,
        13.554483413696,
        -114.7483291626
    )
    AddCameraShot(
        -0.19772699475288,
        0.01040400005877,
        -0.97884798049927,
        -0.051506999880075,
        79.075950622559,
        29.489900588989,
        35.428806304932
    )
    AddCameraShot(
        -0.22460900247097,
        0.091807000339031,
        -0.89799600839615,
        -0.3670499920845,
        75.250473022461,
        41.861679077148,
        46.076160430908
    )
    AddCameraShot(
        -0.37751001119614,
        0.045922998338938,
        -0.91809797286987,
        -0.11168400198221,
        -89.576377868652,
        36.126071929932,
        53.575286865234
    )
    AddCameraShot(
        0.39623698592186,
        -0.09884300082922,
        -0.88567101955414,
        -0.22093500196934,
        -119.81173706055,
        57.899345397949,
        -11.914485931396
    )
    AddCameraShot(
        0.98426997661591,
        -0.12962199747562,
        -0.11901500076056,
        -0.015674000605941,
        -74.040222167969,
        30.126516342163,
        47.421016693115
    )
    AddCameraShot(
        0.98591601848602,
        -0.14751300215721,
        0.077936001121998,
        0.011660999618471,
        -60.501594543457,
        30.210624694824,
        43.851440429688
    )
    AddCameraShot(
        -0.38474398851395,
        0.037819001823664,
        -0.9178249835968,
        -0.090218998491764,
        -38.854251861572,
        30.210624694824,
        2.0682051181793
    )
    AddCameraShot(
        0.93934601545334,
        0.081541001796722,
        0.33188799023628,
        -0.028810000047088,
        -17.522380828857,
        24.605794906616,
        -37.65604019165
    )
    AddCameraShot(
        0.62286001443863,
        -0.044911000877619,
        -0.77902001142502,
        -0.056171000003815,
        22.677572250366,
        20.374139785767,
        -120.13481140137
    )
    AddCameraShot(
        0.034506998956203,
        -0.0035069999285042,
        -0.99427700042725,
        -0.1010439991951,
        -104.15363311768,
        29.038522720337,
        -153.45225524902
    )
    AddCameraShot(
        0.77926898002625,
        -0.14476400613785,
        -0.59948402643204,
        -0.11136499792337,
        -109.15534973145,
        29.038522720337,
        -126.08100128174
    )
    AddCameraShot(
        0.080113001167774,
        -0.011087999679148,
        -0.98731201887131,
        -0.13664999604225,
        -118.77136993408,
        27.157234191895,
        -143.4631652832
    )
    AddCameraShot(
        0.38907900452614,
        0.014746000058949,
        -0.92042499780655,
        0.034885000437498,
        -114.27289581299,
        16.971555709839,
        -25.945049285889
    )
    AddCameraShot(
        0.98966902494431,
        0.0030610000248998,
        0.14334000647068,
        -0.00044299999717623,
        -99.405647277832,
        17.96580696106,
        -40.161994934082
    )
    AddCameraShot(
        0.95217299461365,
        -0.20846499502659,
        -0.21823400259018,
        -0.047779001295567,
        -63.606155395508,
        56.08479309082,
        32.748664855957
    )
end
