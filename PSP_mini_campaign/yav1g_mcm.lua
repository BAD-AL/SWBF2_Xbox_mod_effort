-- yav1g_mcm
-- PSP Mission Script; 'Rogue Assassin' Yavin level
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("Ambush")
REP = 2
IMP = 1
locals = 3
ATT = 1
DEF = 2
EnableSPHeroRules()

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

    TDM = ObjectiveTDM:New({teamATT = 1, teamDEF = 2, multiplayerRules = true})
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

    AAB_count = 3
    AAB = TargetType:New({classname = "rep_inf_ep3_officer", killLimit = 3})

    AAB.OnDestroy = function(param1, param2)
        AAB_count = AAB_count - 1
        ShowMessageText("level.cor1c_m.merc.2-" .. AAB_count, ATT)
    end

    Objective1 =
        ObjectiveAssault:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            AIGoalWeight = 1,
            textATT = "level.cor1c_m.merc.end",
            popupText = "level.cor1c_m.merc.popup"
        }
    )

    Objective1:AddTarget(AAB)

    Objective1.OnComplete = function(param0)
        StartTimer(missiontimer3)
        StopTimer(fiveminremains)
        StopTimer(fourminremains)
        StopTimer(threeminremains)
        StopTimer(twominremains)
        StopTimer(oneminremains)
        StopTimer(thirtysecremains)
        StopTimer(tensecremains)
    end

    AAT_count = 3
    AAT = TargetType:New({classname = "rep_inf_ep3_officer", killLimit = 3})

    AAT.OnDestroy = function(param1, param2)
        AAT_count = AAT_count - 1
        ShowMessageText("level.cor1c_m.merc.1-" .. AAT_count, ATT)
    end

    Objective2 =
        ObjectiveAssault:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            AIGoalWeight = 1,
            textATT = "level.cor1c_m.merc.end2",
            textDEF = "level.dag1.objectives.1"
        }
    )
    Objective2:AddTarget(AAT)
    Objective2.OnComplete = function(OnCompleteParam0)
        ShowMessageText("level.cor1.merc.1", ATT)
        MissionVictory(ATT)
    end

    missiontimer2 = CreateTimer("missiontimer2")
    SetTimerValue(missiontimer2, 1)
    StartTimer(missiontimer2)
    OnTimerElapse(
        function()
            Ambush("target1", 3, 3)
            AddAIGoal(locals, "Deathmatch", 9999)
            AddAIGoal(2, "Deathmatch", 1)
            followguy1 = GetTeamMember(3, 0)
            followthatguy1 = AddAIGoal(2, "Follow", 3, followguy1)
            followguy2 = GetTeamMember(3, 1)
            followthatguy2 = AddAIGoal(2, "Follow", 3, followguy2)
            followguy3 = GetTeamMember(3, 2)
            followthatguy3 = AddAIGoal(2, "Follow", 3, followguy3)
            SetAIDifficulty(2, 1, "medium")
            SetAIDifficulty(3, 2, "medium")
        end,
        "missiontimer2"
    )
    missiontimer3 = CreateTimer("missiontimer3")
    SetTimerValue(missiontimer3, 1)
    OnTimerElapse(
        function()
            Ambush("target2", 3, 3)
            AddAIGoal(locals, "Deathmatch", 9999)
            AddAIGoal(2, "Deathmatch", 1)
            followguy4 = GetTeamMember(3, 3)
            followthatguy4 = AddAIGoal(2, "Follow", 3, followguy4)
            followguy5 = GetTeamMember(3, 4)
            followthatguy5 = AddAIGoal(2, "Follow", 3, followguy5)
            followguy6 = GetTeamMember(3, 5)
            followthatguy6 = AddAIGoal(2, "Follow", 3, followguy6)
            SetTimerValue(missiontimer, 300)
            StartTimer(fourminremains1)
            StartTimer(threeminremains1)
            StartTimer(twominremains1)
            StartTimer(oneminremains1)
            StartTimer(thirtysecremains1)
            StartTimer(tensecremains1)
            SetAIDifficulty(2, 1, "medium")
            SetAIDifficulty(3, 2, "medium")
        end,
        "missiontimer3"
    )
    objectiveSequence = MultiObjectiveContainer:New({})
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(TDM)
    objectiveSequence:Start()
end

function ScriptInit()
    StealArtistHeap(300 * 1024)
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2222777)
        SetPSPClipper(1)
    else
        SetPS2ModelMemory(2500000)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\yav.lvl;yav1gcw")
    SetMaxFlyHeight(14)
    SetMaxPlayerFlyHeight(14)
    ReadDataFile(
        "SIDE\\rep.lvl",
        "rep_inf_ep3_rifleman",
        "rep_inf_ep3_engineer",
        "rep_inf_ep3_rocketeer",
        "rep_inf_ep3_jettrooper",
        "rep_inf_ep3_sniper",
        "rep_inf_ep3_officer",
        "rep_inf_ep2_pilot",
        "rep_inf_ep2_jettrooper_rifleman2"
    )
    ReadDataFile("SIDE\\cis.lvl", "cis_hero_jangofett")
    ReadDataFile("SIDE\\tur.lvl", "tur_bldg_laser", "tur_bldg_tower")
    SetUnitCount(ATT, 4)
    SetReinforcementCount(ATT, -1)
    SetTeamName(IMP, "IMP")
    SetTeamIcon(IMP, "IMP_icon")
    AddUnitClass(IMP, "rep_inf_ep2_jettrooper_rifleman2", 1)
    SetUnitCount(DEF, 12)
    SetReinforcementCount(DEF, -1)
    SetTeamName(REP, "Republic")
    SetTeamIcon(REP, "rep_icon")
    AddUnitClass(REP, "rep_inf_ep3_rifleman", 3)
    AddUnitClass(REP, "rep_inf_ep3_engineer", 2)
    AddUnitClass(REP, "rep_inf_ep3_rocketeer", 3)
    AddUnitClass(REP, "rep_inf_ep3_jettrooper", 2)
    AddUnitClass(REP, "rep_inf_ep3_sniper", 2)
    SetHeroClass(IMP, "cis_hero_jangofett")
    ForceHumansOntoTeam1()
    SetTeamName(locals, "rep")
    AddUnitClass(locals, "rep_inf_ep3_officer", 6)
    SetUnitCount(locals, 12)
    SetTeamAsFriend(locals, REP)
    SetTeamAsFriend(REP, locals)
    SetTeamAsEnemy(locals, IMP)
    SetTeamAsEnemy(IMP, locals)
    SetReinforcementCount(locals, 6)
    AddWalkerType(0, 0)
    AddWalkerType(1, 0)
    AddWalkerType(2, 0)
    AddWalkerType(3, 0)
    local weaponCnt = 214
    SetMemoryPoolSize("Aimer", 13)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("EntityLight", 38)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("MountedTurret", 13)
    SetMemoryPoolSize("Navigator", 46)
    SetMemoryPoolSize("Obstacle", 750)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoundSpaceRegion", 48)
    SetMemoryPoolSize("TreeGridStack", 500)
    SetMemoryPoolSize("UnitAgent", 46)
    SetMemoryPoolSize("UnitController", 46)
    SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 7)
    SetMemoryPoolSize("EntityHover", 2)
    SetSpawnDelay(10, 0.25)
    ReadDataFile("YAV\\yav1.lvl", "Yavin1_merc")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.5)
    SetNumBirdTypes(2)
    SetBirdType(0, 1, "bird")
    SetBirdType(1, 1.5, "bird2")
    SetNumFishTypes(1)
    SetFishType(0, 0.80000001192093, "fish")
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(1, 1, "imp_yav_amb_start", 0, 1)
    SetVictoryMusic(1, "imp_yav_amb_victory")
    SetDefeatMusic(1, "imp_yav_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(
        0.66039997339249,
        -0.059877000749111,
        -0.74546498060226,
        -0.067589998245239,
        143.73443603516,
        -55.725387573242,
        7.7619972229004
    )
    AddCameraShot(
        0.83073300123215,
        -0.14438499510288,
        0.52967900037766,
        0.092060998082161,
        111.79679870605,
        -42.959831237793,
        75.199142456055
    )
    AddCameraShot(
        0.47567600011826,
        -0.064657002687454,
        -0.86924701929092,
        -0.11815399676561,
        13.451732635498,
        -47.76989364624,
        13.242495536804
    )
    AddCameraShot(
        -0.16883300244808,
        0.020623000338674,
        -0.97815799713135,
        -0.11948300153017,
        58.080200195313,
        -50.858741760254,
        -62.2080078125
    )
    AddCameraShot(
        0.88096100091934,
        -0.44082000851631,
        -0.15382400155067,
        -0.076971001923084,
        101.7777633667,
        -46.775646209717,
        -29.683767318726
    )
    AddCameraShot(
        0.89382302761078,
        -0.18383799493313,
        0.4006179869175,
        0.082397997379303,
        130.71482849121,
        -60.244068145752,
        -27.587791442871
    )
    AddCameraShot(
        0.99953401088715,
        0.0040600001811981,
        0.030244000256062,
        -0.00012300000526011,
        222.20913696289,
        -61.220325469971,
        -18.061191558838
    )
    AddCameraShot(
        0.91263699531555,
        -0.057865999639034,
        0.403843998909,
        0.02560600079596,
        236.69334411621,
        -49.829277038574,
        -116.15098571777
    )
    AddCameraShot(
        0.43073201179504,
        -0.016397999599576,
        -0.9016780257225,
        -0.034327998757362,
        180.69206237793,
        -54.148796081543,
        -159.85664367676
    )
    AddCameraShot(
        0.83211898803711,
        -0.063785001635551,
        0.54930597543716,
        0.042107000946999,
        160.69940185547,
        -54.148796081543,
        -130.99069213867
    )
    AddCameraShot(
        0.40419998764992,
        -0.037992000579834,
        -0.9098709821701,
        -0.085519999265671,
        68.815330505371,
        -54.148796081543,
        -160.83758544922
    )
    AddCameraShot(
        -0.43884500861168,
        0.053442001342773,
        -0.89039397239685,
        -0.10843099653721,
        116.56224060059,
        -52.504405975342,
        -197.68600463867
    )
    AddCameraShot(
        0.38934901356697,
        -0.11339999735355,
        -0.87761700153351,
        -0.25560900568962,
        29.177610397339,
        -23.974962234497,
        -288.06167602539
    )
    AddCameraShot(
        0.49993801116943,
        -0.081055998802185,
        -0.85114598274231,
        -0.13799799978733,
        90.32691192627,
        -28.060659408569,
        -283.3293762207
    )
    AddCameraShot(
        -0.21700599789619,
        0.015115999616683,
        -0.97369402647018,
        -0.067827001214027,
        202.0567779541,
        -37.476913452148,
        -181.44566345215
    )
    AddCameraShot(
        0.9906399846077,
        -0.082509003579617,
        0.10836700350046,
        0.0090260002762079,
        206.26695251465,
        -37.476913452148,
        -225.15824890137
    )
    AddCameraShot(
        -0.38658899068832,
        0.12639999389648,
        -0.86831402778625,
        -0.28390699625015,
        224.94203186035,
        -17.820135116577,
        -269.5322265625
    )
    AddCameraShot(
        0.96749299764633,
        0.054297998547554,
        0.24661099910736,
        -0.013840000145137,
        155.98445129395,
        -30.781782150269,
        -324.83697509766
    )
    AddCameraShot(
        -0.45314699411392,
        0.14048500359058,
        -0.84081602096558,
        -0.26067200303078,
        164.64895629883,
        -0.0024309998843819,
        -378.48706054688
    )
    AddCameraShot(
        0.59273099899292,
        -0.1825709939003,
        -0.74967801570892,
        -0.23091299831867,
        99.326835632324,
        -13.029744148254,
        -414.84619140625
    )
    AddCameraShot(
        0.86575001478195,
        -0.18435199558735,
        0.45508399605751,
        0.096905000507832,
        137.22135925293,
        -19.694858551025,
        -436.05755615234
    )
    AddCameraShot(
        0.026915000751615,
        -0.0026090000756085,
        -0.99496901035309,
        -0.096460998058319,
        128.39794921875,
        -30.249139785767,
        -428.44741821289
    )
end

-- INFO 0x1 0x0 0x0 0x0 0x1 0x0 0x0 0x0
