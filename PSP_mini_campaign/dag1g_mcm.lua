-- dag1g_mcm.lua
-- PSP Mission Script; 'Rogue Assassin' Dagobah level
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("Ambush")
REP = 1
IMP = 2
locals = 3
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 300)
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
    OnTimerElapse(
        function()
            MissionVictory(DEF)
        end,
        "missiontimer"
    )

    fourminremains = CreateTimer("fourminremains")
    SetTimerValue(fourminremains, 60)
    threeminremains = CreateTimer("threeminremains")
    SetTimerValue(threeminremains, 120)
    twominremains = CreateTimer("twominremains")
    SetTimerValue(twominremains, 180)
    oneminremains = CreateTimer("oneminremains")
    SetTimerValue(oneminremains, 240)
    thirtysecremains = CreateTimer("thirtysecremains")
    SetTimerValue(thirtysecremains, 270)
    tensecremains = CreateTimer("tensecremains")
    SetTimerValue(tensecremains, 290)
    StartTimer(fourminremains)
    StartTimer(threeminremains)
    StartTimer(twominremains)
    StartTimer(oneminremains)
    StartTimer(thirtysecremains)
    StartTimer(tensecremains)
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
    AAT_count = 3
    AAT = TargetType:New({classname = "imp_inf_officer", killLimit = 3})

    AAT.OnDestroy = function(self, objectPtr)
        AAT_count = AAT_count - 1
        ShowMessageText("level.dag1g_m.merc.2-" .. AAT_count, ATT)
    end

    Objective2 =
        ObjectiveAssault:New(
        {
            teamATT = ATT,
            teamDEF = DEF,
            AIGoalWeight = 1,
            textATT = "level.dag1g_m.merc.end",
            popupText = "level.dag1g_m.merc.popup"
        }
    )

    Objective2:AddTarget(AAT)
    Objective2.OnComplete = function(param0)
        MissionVictory(ATT)
    end
    TDM = ObjectiveTDM:New({teamATT = 1, teamDEF = 2, textATT = "level.dag1g_m.merc.merc1", multiplayerRules = true})
    missiontimer2 = CreateTimer("missiontimer2")
    SetTimerValue(missiontimer2, 1)
    StartTimer(missiontimer2)
    OnTimerElapse(
        function()
            Ambush("off_path", 3, 3)
            AddAIGoal(locals, "Deathmatch", 9999)
            followguy1 = GetTeamMember(3, 0)
            AddAIGoal(followguy1, "defend", 100, x1)
            followthatguy1 = AddAIGoal(2, "defend", 100, followguy1)
            followguy2 = GetTeamMember(3, 1)
            AddAIGoal(followguy2, "defend", 100, x2)
            followthatguy2 = AddAIGoal(2, "defend", 100, followguy2)
            followguy3 = GetTeamMember(3, 2)
            AddAIGoal(followguy3, "defend", 100, x3)
            followthatguy3 = AddAIGoal(2, "defend", 100, followguy3)
            SetAIDifficulty(2, 3, "medium")
            SetAIDifficulty(3, 3, "medium")
        end,
        "missiontimer2"
    )
    objectiveSequence = MultiObjectiveContainer:New({})
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(TDM)
    objectiveSequence:Start()
end

function ScriptInit()
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(1616077)
        SetPSPClipper(0)
    else
        SetPS2ModelMemory(2497152 + 65536 * 0)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dag.lvl;dag1gcw")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\rep.lvl", "rep_inf_ep2_jettrooper_rifleman2")
    ReadDataFile(
        "SIDE\\imp.lvl",
        "imp_inf_rifleman",
        "imp_inf_sniper",
        "imp_inf_dark_trooper",
        "imp_inf_officer",
        "imp_hero_bobafett"
    )
    ClearWalkers()
    AddWalkerType(0, 4)
    SetMemoryPoolSize("EntityHover", 0)
    SetMemoryPoolSize("EntityFlyer", 0)
    SetMemoryPoolSize("EntityDroid", 10)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("Obstacle", 118)
    SetMemoryPoolSize("Weapon", 260)
    SetTeamName(REP, "Republic")
    SetTeamIcon(REP, "rep_icon")
    AddUnitClass(REP, "rep_inf_ep2_jettrooper_rifleman2", 1)
    SetHeroClass(REP, "imp_hero_bobafett")
    SetTeamName(IMP, "IMP")
    SetTeamIcon(IMP, "IMP_icon")
    AddUnitClass(IMP, "imp_inf_rifleman", 6)
    AddUnitClass(IMP, "imp_inf_sniper", 3)
    AddUnitClass(IMP, "imp_inf_dark_trooper", 3)
    SetUnitCount(ATT, 4)
    SetReinforcementCount(ATT, -1)
    SetUnitCount(DEF, 12)
    SetReinforcementCount(DEF, -1)
    ForceHumansOntoTeam1()
    SetTeamName(locals, "IMP")
    AddUnitClass(locals, "imp_inf_officer", 3)
    SetUnitCount(locals, 10)
    SetTeamAsFriend(locals, IMP)
    SetTeamAsFriend(IMP, locals)
    SetTeamAsEnemy(locals, REP)
    SetTeamAsEnemy(REP, locals)
    SetReinforcementCount(locals, 3)
    SetSpawnDelay(10, 0.25)
    ReadDataFile("dag\\dag1.lvl", "dag1_merc")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.34999999403954)
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(1, 1, "all_dag_amb_start", 0, 1)
    SetAmbientMusic(1, 0.80000001192093, "all_dag_amb_middle", 1, 1)
    SetAmbientMusic(1, 0.20000000298023, "all_dag_amb_end", 2, 1)
    SetAmbientMusic(2, 1, "imp_dag_amb_start", 0, 1)
    SetAmbientMusic(2, 0.80000001192093, "imp_dag_amb_middle", 1, 1)
    SetAmbientMusic(2, 0.20000000298023, "imp_dag_amb_end", 2, 1)
    SetVictoryMusic(1, "all_dag_amb_victory")
    SetDefeatMusic(1, "all_dag_amb_defeat")
    SetVictoryMusic(2, "imp_dag_amb_victory")
    SetDefeatMusic(2, "imp_dag_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
    AddCameraShot(
        -0.40489500761032,
        0.0009919999865815,
        -0.91435998678207,
        -0.0022400000598282,
        -85.539894104004,
        20.536296844482,
        141.6994934082
    )
    AddCameraShot(
        0.040922001004219,
        0.004048999864608,
        -0.99429899454117,
        0.098380997776985,
        -139.72952270508,
        17.546598434448,
        -34.360893249512
    )
    AddCameraShot(
        -0.31235998868942,
        0.016223000362515,
        -0.94854700565338,
        -0.049263000488281,
        -217.38148498535,
        20.150953292847,
        54.514324188232
    )
end
