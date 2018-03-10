-- cor1c_mcm.lua
-- PSP Mission file; 'Rogue Assassin' Coruscant mission
-- Seems to be an unused 'Rogue Assassin' level that shipped with the PSP version
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
    ForceHumansOntoTeam1()
    EnableSPHeroRules()
    DisableBarriers("SideDoor1")
    DisableBarriers("MainLibraryDoors")
    DisableBarriers("SideDoor2")
    DisableBarriers("SIdeDoor3")
    DisableBarriers("ComputerRoomDoor1")
    DisableBarriers("StarChamberDoor1")
    DisableBarriers("StarChamberDoor2")
    DisableBarriers("WarRoomDoor1")
    DisableBarriers("WarRoomDoor2")
    DisableBarriers("WarRoomDoor3")
    PlayAnimation("DoorOpen01")
    PlayAnimation("DoorOpen02")
    PlayAnimation("DoorOpen01")
    PlayAnimation("DoorOpen02")
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer, 420)
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
    OnTimerElapse(
        function()
            MissionVictory(DEF)
        end,
        "missiontimer"
    )

    TDM = ObjectiveTDM:New({teamATT = 1, teamDEF = 2, multiplayerRules = true})
    AAB_count = 3
    AAB = TargetType:New({classname = "rep_inf_ep3_officer", killLimit = 3})
    AAB.OnDestroy = function(OnDestroyParam0, OnDestroyParam1)
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
            popupText = "level.cor1c_m.merc.end"
        }
    )
    Objective1:AddTarget(AAB)
    Objective1.OnComplete = function(OnCompleteParam0)
        StartTimer(missiontimer3)
    end

    AAT_count = 3
    AAT = TargetType:New({classname = "rep_inf_ep3_officer", killLimit = 3})
    AAT.OnDestroy = function(OnDestroyParam0, OnDestroyParam1)
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
            followguy1 = GetTeamMember(3, 0)
            followthatguy1 = AddAIGoal(2, "Follow", 3, followguy1)
            followguy2 = GetTeamMember(3, 1)
            followthatguy2 = AddAIGoal(2, "Follow", 3, followguy2)
            followguy3 = GetTeamMember(3, 2)
            followthatguy3 = AddAIGoal(2, "Follow", 3, followguy3)
        end,
        "missiontimer2"
    )

    missiontimer3 = CreateTimer("missiontimer3")
    SetTimerValue(missiontimer3, 1)
    OnTimerElapse(
        function()
            Ambush("target2", 3, 3)
            AddAIGoal(locals, "Deathmatch", 9999)
            followguy4 = GetTeamMember(3, 3)
            followthatguy4 = AddAIGoal(2, "Follow", 3, followguy4)
            followguy5 = GetTeamMember(3, 4)
            followthatguy5 = AddAIGoal(2, "Follow", 3, followguy5)
            followguy6 = GetTeamMember(3, 5)
            followthatguy6 = AddAIGoal(2, "Follow", 3, followguy6)
            SetTimerValue(missiontimer, 300)
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
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3755505)
        SetPSPClipper(1)
    else
        SetPS2ModelMemory(4100000)
    end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(REP, 0.5)
    ReadDataFile("sound\\cor.lvl;cor1gcw")
    SetMapNorthAngle(0)
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
    ReadDataFile("SIDE\\tur.lvl", "tur_bldg_laser")

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
    SetTeamName(locals, "locals")

    AddUnitClass(locals, "rep_inf_ep3_officer", 6)
    SetUnitCount(locals, 12)
    SetTeamAsFriend(locals, REP)
    SetTeamAsFriend(REP, locals)
    SetTeamAsEnemy(locals, IMP)
    SetTeamAsEnemy(IMP, locals)

    SetReinforcementCount(locals, 6)
    ClearWalkers()
    AddWalkerType(0, 0)
    AddWalkerType(1, 0)
    AddWalkerType(2, 0)
    AddWalkerType(3, 0)

    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("EntityFlyer", 0)
    SetMemoryPoolSize("EntityDroid", 10)
    SetMemoryPoolSize("EntityCarrier", 0)
    SetMemoryPoolSize("EntityLight", 96)
    SetMemoryPoolSize("SoundSpaceRegion", 38)

    SetSpawnDelay(10, 0.25)
    ReadDataFile("cor\\cor1.lvl", "cor1_merc")

    SetDenseEnvironment("True")
    AddDeathRegion("DeathRegion1")

    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(2, 1, "all_cor_amb_start", 0, 1)
    SetAmbientMusic(2, 0.80000001192093, "all_cor_amb_middle", 1, 1)
    SetAmbientMusic(2, 0.20000000298023, "all_cor_amb_end", 2, 1)
    SetAmbientMusic(1, 1, "imp_cor_amb_start", 0, 1)
    SetAmbientMusic(1, 0.80000001192093, "imp_cor_amb_middle", 1, 1)
    SetAmbientMusic(1, 0.20000000298023, "imp_cor_amb_end", 2, 1)

    SetVictoryMusic(2, "all_cor_amb_victory")
    SetDefeatMusic(2, "all_cor_amb_defeat")
    SetVictoryMusic(1, "imp_cor_amb_victory")
    SetDefeatMusic(1, "imp_cor_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")

    SetAttackingTeam(ATT)

    AddCameraShot(
        0.99765402078629,
        0.066982001066208,
        0.014139000326395,
        -0.00094900000840425,
        155.1371307373,
        0.91150498390198,
        -138.07707214355
    )
    AddCameraShot(
        0.72976100444794,
        0.019262000918388,
        0.68319398164749,
        -0.018032999709249,
        -98.584869384766,
        0.29528400301933,
        263.23928833008
    )
    AddCameraShot(
        0.69427698850632,
        0.0051000001840293,
        0.71967101097107,
        -0.0052869999781251,
        -11.105946540833,
        -2.7532069683075,
        67.982200622559
    )
end
