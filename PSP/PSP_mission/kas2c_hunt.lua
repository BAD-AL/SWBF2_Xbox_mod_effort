--Extracted\kas2c_hunt.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    hunt = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, pointsPerKillATT = 2, pointsPerKillDEF = 1, textATT = "level.kas2.hunt.ATT", textDEF = "level.kas2.hunt.DEF", multiplayerRules = true })
    hunt:Start()
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme")
    KillObject("ctfbase1")
    KillObject("ctfbase2")
    SetProperty("woodl","MaxHealth",15000)
    SetProperty("woodl","CurHealth",15000)
    SetProperty("woodr","MaxHealth",15000)
    SetProperty("woodr","CurHealth",15000)
    SetProperty("woodc","MaxHealth",15000)
    SetProperty("woodc","CurHealth",15000)
    SetProperty("gatepanel","MaxHealth",1000)
    SetProperty("gatepanel","CurHealth",1000)
    OnObjectKillName(PlayAnimDown,"gatepanel")
    OnObjectRespawnName(PlayAnimUp,"gatepanel")
    OnObjectKillName(woodl,"woodl")
    OnObjectKillName(woodc,"woodc")
    OnObjectKillName(woodr,"woodr")
    OnObjectRespawnName(woodlr,"woodl")
    OnObjectRespawnName(woodcr,"woodc")
    OnObjectRespawnName(woodrr,"woodr")
end

function PlayAnimDown()
    PauseAnimation("thegateup")
    RewindAnimation("thegatedown")
    PlayAnimation("thegatedown")
    ShowMessageText("level.kas2.objectives.gateopen",1)
    ScriptCB_SndPlaySound("KAS_obj_13")
    SetProperty("gatepanel","MaxHealth",2200)
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
    SetProperty("gatepanel","MaxHealth",1000)
    SetProperty("gatepanel","CurHealth",1000)
end

function woodl()
    UnblockPlanningGraphArcs("woodl")
    DisableBarriers("woodl")
    SetProperty("woodl","MaxHealth",1800)
end

function woodc()
    UnblockPlanningGraphArcs("woodc")
    DisableBarriers("woodc")
    SetProperty("woodc","MaxHealth",1800)
end

function woodr()
    UnblockPlanningGraphArcs("woodr")
    DisableBarriers("woodr")
    SetProperty("woodr","MaxHealth",1800)
end

function woodlr()
    BlockPlanningGraphArcs("woodl")
    EnableBarriers("woodl")
    SetProperty("woodl","MaxHealth",15000)
    SetProperty("woodl","CurHealth",15000)
end

function woodcr()
    BlockPlanningGraphArcs("woodc")
    EnableBarriers("woodc")
    SetProperty("woodc","MaxHealth",15000)
    SetProperty("woodc","CurHealth",15000)
end

function woodrr()
    BlockPlanningGraphArcs("woodr")
    EnableBarriers("woodr")
    SetProperty("woodr","MaxHealth",15000)
    SetProperty("woodr","CurHealth",15000)
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(1661245)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(3720000)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    ReadDataFile("sound\\kas.lvl;kas2cw")
    ReadDataFile("SIDE\\rep.lvl","rep_fly_cat_dome")
    ReadDataFile("SIDE\\wok.lvl","wok_inf_basic")
    ReadDataFile("SIDE\\cis.lvl","cis_fly_gunship_dome","cis_inf_officer_hunt")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_beam","tur_bldg_recoilless_kas")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = -1, 
              sniper =               { "cis_inf_officer_hunt", 1 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = -1, 
              soldier =               { "wok_inf_mechanic", 2 }, 
              engineer =               { "wok_inf_warrior", 8 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = -1, 
              sniper =               { "cis_inf_officer_hunt", 1 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = -1, 
              soldier =               { "wok_inf_mechanic", 5 }, 
              engineer =               { "wok_inf_warrior", 20 }
             }
           })
end
    SetTeamName(1,"CIS")
    SetTeamName(2,"Wookiees")
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",100)
    SetMemoryPoolSize("BaseHint",150)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityCloth",80)
    SetMemoryPoolSize("EntityHover",15)
    SetMemoryPoolSize("EntityLight",60)
    SetMemoryPoolSize("MountedTurret",20)
    SetMemoryPoolSize("Obstacle",590)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TentacleSimulator",22)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("Weapon",265)
    SetSpawnDelay(10,0.25)
    ReadDataFile("KAS\\kas2.lvl","kas2_hunt")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    SetNumFishTypes(1)
    SetFishType(0,0.80000001192093,"fish")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_kas_amb_hunt",0,1)
    SetAmbientMusic(CIS,1,"cis_kas_amb_hunt",0,1)
    SetVictoryMusic(REP,"rep_kas_amb_victory")
    SetDefeatMusic(REP,"rep_kas_amb_defeat")
    SetVictoryMusic(CIS,"cis_kas_amb_victory")
    SetDefeatMusic(CIS,"cis_kas_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.97764199972153,-0.052163001149893,-0.20341399312019,-0.010852999985218,66.539520263672,21.86496925354,168.5984954834)
    AddCameraShot(0.9694550037384,-0.011915000155568,0.24495999515057,0.0030110001098365,219.55294799805,21.86496925354,177.67567443848)
    AddCameraShot(0.99503999948502,-0.013446999713778,0.098558001220226,0.0013320000143722,133.5712890625,16.216758728027,121.57123565674)
    AddCameraShot(0.35043299198151,-0.049724999815226,-0.92599099874496,-0.13139399886131,30.085187911987,32.105236053467,-105.32526397705)
    AddCameraShot(0.16336899995804,-0.029668999835849,-0.97024899721146,-0.17620299756527,85.474830627441,47.313362121582,-156.34562683105)
    AddCameraShot(0.09111200273037,-0.011521000415087,-0.98790699243546,-0.12492000311613,97.554061889648,53.690967559814,-179.34707641602)
    AddCameraShot(0.96495300531387,-0.059962000697851,0.25498801469803,0.015845000743866,246.47100830078,20.362142562866,153.70104980469)
end

function OnStart(OnStartParam0)
    AddAIGoal(ATT,"Deathmatch",1000)
    AddAIGoal(DEF,"Deathmatch",1000)
end

