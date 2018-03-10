--tat3g_mcm.lua
-- PSP Mission Script; 'Rogue Assassin' Tatooine mission
-- Seems to be an unused 'Rogue Assassin' level that shipped with the PSP version
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("Ambush")
REP = 1
des = 2
wookiee = 4
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    ForceHumansOntoTeam1()
    missiontimer = CreateTimer("missiontimer")
    SetTimerValue(missiontimer,300)
    StartTimer(missiontimer)
    ShowTimer(missiontimer)
    OnTimerElapse(function missiontimer()
          MissionVictory(DEF)
end,"missiontimer")
    TDM = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, textATT = "level.tat3g_m.merc.merc1", multiplayerRules = true })
    AAT_count = 4
    AAT = TargetType:New({ classname = "all_inf_wookiee_ra", killLimit = 4 })
    Objective2 = ObjectiveAssault:New({ teamATT = ATT, teamDEF = DEF, AIGoalWeight = 1, textATT = "level.tat3g_m.merc.end", popupText = "level.tat3g_m.merc.end" })
    Objective2:AddTarget(AAT)
    missiontimer2 = CreateTimer("missiontimer2")
    SetTimerValue(missiontimer2,1)
    StartTimer(missiontimer2)
    OnTimerElapse(function missiontimer2()
          Ambush("wookies",4,4)
          AddAIGoal(4,"Deathmatch",9999)
end,"missiontimer2")
    objectiveSequence = MultiObjectiveContainer:New({  })
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(TDM)
    objectiveSequence:Start()
end

function ScriptInit()
    StealArtistHeap(295 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2900017)
else
        SetPS2ModelMemory(4050000)
end
    ReadDataFile("ingame.lvl")
    SetMemoryPoolSize("Aimer",9)
    SetMemoryPoolSize("AmmoCounter",164)
    SetMemoryPoolSize("BaseHint",100)
    SetMemoryPoolSize("EnergyBar",164)
    SetMemoryPoolSize("EntityLight",132)
    SetMemoryPoolSize("EntitySoundStatic",3)
    SetMemoryPoolSize("EntitySoundStream",2)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",52)
    SetMemoryPoolSize("Obstacle",200)
    SetMemoryPoolSize("PassengerSlot",0)
    SetMemoryPoolSize("PathFollower",52)
    SetMemoryPoolSize("SoundSpaceRegion",80)
    SetMemoryPoolSize("UnitAgent",52)
    SetMemoryPoolSize("UnitController",52)
    SetMemoryPoolSize("Weapon",164)
    SetMemoryPoolSize("ActiveRegion",8)
    SetMemoryPoolSize("Combo::DamageSample",56)
    SetMemoryPoolSize("EntityDefenseGridTurret",4)
    SetMemoryPoolSize("EntityDroid",1)
    SetMemoryPoolSize("EntityPortableTurret",4)
    SetMemoryPoolSize("EntityMine",8)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",40)
    SetMemoryPoolSize("LightFlash",2)
    SetMemoryPoolSize("LightningBoltEffectObject",2)
    SetMemoryPoolSize("Ordnance",30)
    SetMemoryPoolSize("ParticleEmitter",200)
    SetMemoryPoolSize("ParticleEmitterInfoData",200)
    SetMemoryPoolSize("ParticleEmitterObject",128)
    SetMemoryPoolSize("PathNode",168)
    SetMemoryPoolSize("PowerupItem",12)
    SetMemoryPoolSize("RayRequest",100)
    SetMemoryPoolSize("StickInfo",12)
    SetMemoryPoolSize("TreeGridStack",80)
    ReadDataFile("sound\\tat.lvl;tat3cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep2_jettrooper_rifleman2")
    ReadDataFile("SIDE\\des.lvl","tat_inf_tuskenhunter","tat_inf_tuskenraider")
    ReadDataFile("SIDE\\gam.lvl","gam_inf_gamorreanguard")
    ReadDataFile("SIDE\\imp.lvl","imp_hero_bobafett")
    ReadDataFile("SIDE\\all.lvl","all_inf_wookiee_ra")
    SetTeamName(REP,"Republic")
    SetTeamIcon(REP,"rep_icon")
    AddUnitClass(REP,"rep_inf_ep2_jettrooper_rifleman2",1)
    SetHeroClass(REP,"imp_hero_bobafett")
    SetTeamName(des,"des")
    SetTeamIcon(des,"IMP_icon")
    AddUnitClass(des,"tat_inf_tuskenraider",4)
    AddUnitClass(des,"gam_inf_gamorreanguard",2)
    AddUnitClass(des,"tat_inf_tuskenhunter",3)
    SetUnitCount(ATT,4)
    SetReinforcementCount(ATT,-1)
    SetUnitCount(DEF,9)
    SetReinforcementCount(DEF,-1)
    SetTeamName(4,"wookiee")
    AddUnitClass(4,"all_inf_wookiee_ra",4)
    SetUnitCount(4,10)
    SetTeamAsFriend(4,2)
    SetTeamAsFriend(2,4)
    SetTeamAsEnemy(4,1)
    SetTeamAsEnemy(1,4)
    SetReinforcementCount(4,4)
    ClearWalkers()
    AddWalkerType(0,3)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat3.lvl","tat3_merc")
    SetDenseEnvironment("true")
    SetMaxFlyHeight(90)
    SetMaxPlayerFlyHeight(90)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(1,1,"rep_tat_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"rep_tat_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"rep_tat_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_tat_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"cis_tat_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"cis_tat_amb_end",2,1)
    SetVictoryMusic(1,"rep_tat_amb_victory")
    SetDefeatMusic(1,"rep_tat_amb_defeat")
    SetVictoryMusic(2,"cis_tat_amb_victory")
    SetDefeatMusic(2,"cis_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.68560099601746,-0.25360599160194,-0.63999402523041,-0.2367350012064,-65.939224243164,-0.17655800282955,127.40044403076)
    AddCameraShot(0.78694397211075,0.050287999212742,-0.61371898651123,0.039218001067638,-80.626396179199,1.1751799583435,133.20555114746)
    AddCameraShot(0.99798202514648,0.061864998191595,-0.014248999767005,0.00088299997150898,-65.227897644043,1.3227980136871,123.97698974609)
    AddCameraShot(-0.36786898970604,-0.027819000184536,-0.92681497335434,0.070087000727654,-19.548307418823,-5.736279964447,163.36051940918)
    AddCameraShot(0.77398002147675,-0.10012699663639,-0.62007701396942,-0.080216996371746,-61.123989105225,-0.62928301095963,176.06602478027)
    AddCameraShot(0.97818899154663,0.012076999992132,0.2073500007391,-0.002559999935329,-88.388946533203,5.6749677658081,153.7452545166)
    AddCameraShot(-0.14460599422455,-0.010301000438631,-0.9869350194931,0.070303998887539,-106.8727722168,2.0664689540863,102.78309631348)
    AddCameraShot(0.92675602436066,-0.22857800126076,-0.28944599628448,-0.071390002965927,-60.819583892822,-2.1174819469452,96.400619506836)
    AddCameraShot(0.8730800151825,0.13428500294685,0.4632740020752,-0.071254000067711,-52.07160949707,-8.4307460784912,67.122436523438)
    AddCameraShot(0.77339798212051,-0.022788999602199,-0.63323599100113,-0.018658999353647,-32.738082885742,-7.3793940544128,81.508003234863)
    AddCameraShot(0.090190000832081,0.0056010000407696,-0.99399399757385,0.06173299998045,-15.37969493866,-9.9391145706177,72.110054016113)
    AddCameraShot(0.97173702716827,-0.11873900145292,-0.20252400636673,-0.024746999144554,-16.59129524231,-1.3712359666824,147.9330291748)
    AddCameraShot(0.89491802453995,0.098682001233101,-0.43255999684334,0.047697998583317,-20.577390670776,-10.683214187622,128.75256347656)
end

function OnDestroy(OnDestroyParam0, OnDestroyParam1)
AAT_count = AAT_count - 1
    ShowMessageText("level.tat3g_m.merc.1-" .. AAT_count,ATT)
end

function OnComplete(OnCompleteParam0)
    MissionVictory(ATT)
end

