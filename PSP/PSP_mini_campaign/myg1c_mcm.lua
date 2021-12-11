--myg1c_mcm.lua
-- PSP Mission Script; 'Rogue Assassin' Mygeeto level
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

    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
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
            AddAIGoal(3, "Deathmatch", 9999)
            AddAIGoal(2, "Deathmatch", 1)
            followguy1 = GetTeamMember(3, 0)
            followthatguy1 = AddAIGoal(2, "Follow", 3, followguy1)
            followguy2 = GetTeamMember(3, 1)
            followthatguy2 = AddAIGoal(2, "Follow", 3, followguy2)
            followguy3 = GetTeamMember(3, 2)
            followthatguy3 = AddAIGoal(2, "Follow", 3, followguy3)
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
    StealArtistHeap(135 * 1024)
    if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2978689)
        SetPSPClipper(0)
    else
        SetPS2ModelMemory(4880000)
    end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\myg.lvl;myg1gcw")
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
    ReadDataFile("SIDE\\tur.lvl", "tur_bldg_recoilless_lg")
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
    ReadDataFile("myg\\myg1.lvl", "myg1_merc")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
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
    OpenAudioStream("sound\\global.lvl", "gcw_music")
    SetAmbientMusic(1, 1, "all_myg_amb_start", 0, 1)
    SetAmbientMusic(1, 0.80000001192093, "all_myg_amb_middle", 1, 1)
    SetAmbientMusic(1, 0.20000000298023, "all_myg_amb_end", 2, 1)
    SetAmbientMusic(IMP, 1, "imp_myg_amb_start", 0, 1)
    SetAmbientMusic(IMP, 0.80000001192093, "imp_myg_amb_middle", 1, 1)
    SetAmbientMusic(IMP, 0.20000000298023, "imp_myg_amb_end", 2, 1)
    SetVictoryMusic(1, "all_myg_amb_victory")
    SetDefeatMusic(1, "all_myg_amb_defeat")
    SetVictoryMusic(IMP, "imp_myg_amb_victory")
    SetDefeatMusic(IMP, "imp_myg_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn", "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange", "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack", "shell_menu_exit")
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
