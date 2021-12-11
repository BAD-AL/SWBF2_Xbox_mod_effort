--Extracted\kas2c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
REP = 1
CIS = 2
ATT = 1
DEF = 2
WookieTeam = 3

function ScriptPostLoad()
    AddDeathRegion("deathregion")
    AddDeathRegion("deathregion2")
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CP1CON" })
    cp3 = CommandPost:New({ name = "CP3CON" })
    cp4 = CommandPost:New({ name = "CP4CON" })
    cp5 = CommandPost:New({ name = "CP5CON" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:Start()
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme")
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
        SetPSPModelMemory(3930173)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(3700000)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    ReadDataFile("sound\\kas.lvl;kas2cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_sniper_felucia","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_officer","rep_hero_yoda","rep_hover_fightertank","rep_fly_cat_dome","rep_hover_barcspeeder")
    ReadDataFile("SIDE\\cis.lvl","cis_tread_snailtank","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hover_stap","cis_inf_officer","cis_hero_jangofett","cis_inf_droideka")
    ReadDataFile("SIDE\\wok.lvl","wok_inf_basic")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_beam","tur_bldg_recoilless_kas")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 9, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper_felucia" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 9, reinforcements = 75, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 0 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = 160, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper_felucia" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper", 1, 4 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = 160, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 0 }
             }
           })
end
    SetHeroClass(REP,"rep_hero_yoda")
    SetHeroClass(CIS,"cis_hero_jangofett")
    SetTeamName(3,"locals")
    SetTeamIcon(3,"all_icon")
    AddUnitClass(3,"wok_inf_warrior",2)
    AddUnitClass(3,"wok_inf_rocketeer",2)
    AddUnitClass(3,"wok_inf_mechanic",1)
    SetUnitCount(3,5)
    AddAIGoal(WookieTeam,"Deathmatch",100)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(3,ATT)
    SetTeamAsEnemy(DEF,3)
    SetTeamAsEnemy(3,DEF)
    ClearWalkers()
    AddWalkerType(0,6)
    AddWalkerType(1,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",70)
    SetMemoryPoolSize("AmmoCounter",230)
    SetMemoryPoolSize("BaseHint",210)
    SetMemoryPoolSize("EnergyBar",230)
    SetMemoryPoolSize("EntityHover",11)
    SetMemoryPoolSize("EntityLight",40)
    SetMemoryPoolSize("EntityCloth",58)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",3)
    SetMemoryPoolSize("EntitySoundStatic",120)
    SetMemoryPoolSize("MountedTurret",15)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",300)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TentacleSimulator",8)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",230)
    SetSpawnDelay(10,0.25)
    ReadDataFile("KAS\\kas2.lvl","kas2_con")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    SetNumFishTypes(1)
    SetFishType(0,0.80000001192093,"fish")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_kas_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_kas_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_kas_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_kas_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_kas_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_kas_amb_end",2,1)
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
end

