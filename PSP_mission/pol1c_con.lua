--Extracted\pol1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
CIS = 1
REP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    cp1 = CommandPost:New({ name = "CP1Con" })
    cp2 = CommandPost:New({ name = "CP2Con" })
    cp3 = CommandPost:New({ name = "CP3Con" })
    cp4 = CommandPost:New({ name = "CP4Con" })
    cp5 = CommandPost:New({ name = "CP5Con" })
    cp6 = CommandPost:New({ name = "CP6Con" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "level.yavin1.con.att", textDEF = "level.yavin1.con.def", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    OnObjectRespawnName(PlayAnimLock01Open,"LockCon01")
    OnObjectKillName(PlayAnimLock01Close,"LockCon01")
    EnableSPHeroRules()
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
        SetPSPModelMemory(3730673)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4100000)
end
    ReadDataFile("ingame.lvl")
    CIS = ATT
    REP = DEF
    SetMapNorthAngle(0)
    SetMaxFlyHeight(55)
    SetMaxPlayerFlyHeight(55)
    AISnipeSuitabilityDist(30)
    ReadDataFile("sound\\pol.lvl;pol1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_officer","cis_inf_droideka","cis_hero_darthmaul","cis_hover_aat")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman", 4 }, 
              assault =               { "rep_inf_ep3_rocketeer", 2 }, 
              engineer =               { "rep_inf_ep3_engineer", 1 }, 
              sniper =               { "rep_inf_ep3_sniper", 1 }, 
              officer =               { "rep_inf_ep3_officer", 1 }, 
              special =               { "rep_inf_ep3_jettrooper", 1 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = 75, 
              soldier =               { "cis_inf_rifleman", 4 }, 
              assault =               { "cis_inf_rocketeer", 2 }, 
              engineer =               { "cis_inf_engineer", 1 }, 
              sniper =               { "cis_inf_sniper", 1 }, 
              officer =               { "cis_inf_officer", 1 }, 
              special =               { "cis_inf_droideka", 1 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = 200, 
              soldier =               { "rep_inf_ep3_rifleman", 11 }, 
              assault =               { "rep_inf_ep3_rocketeer", 4 }, 
              engineer =               { "rep_inf_ep3_engineer", 3 }, 
              sniper =               { "rep_inf_ep3_sniper", 2 }, 
              officer =               { "rep_inf_ep3_officer", 2 }, 
              special =               { "rep_inf_ep3_jettrooper", 3 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = 200, 
              soldier =               { "cis_inf_rifleman", 11 }, 
              assault =               { "cis_inf_rocketeer", 4 }, 
              engineer =               { "cis_inf_engineer", 3 }, 
              sniper =               { "cis_inf_sniper", 2 }, 
              officer =               { "cis_inf_officer", 2 }, 
              special =               { "cis_inf_droideka", 3 }
             }
           })
end
    SetHeroClass(CIS,"cis_hero_darthmaul")
    SetHeroClass(REP,"rep_hero_yoda")
    ClearWalkers()
    AddWalkerType(0,3)
    SetMemoryPoolSize("Aimer",60)
    SetMemoryPoolSize("AmmoCounter",200)
    SetMemoryPoolSize("BaseHint",245)
    SetMemoryPoolSize("EnergyBar",200)
    SetMemoryPoolSize("EntityCloth",17)
    SetMemoryPoolSize("EntityHover",5)
    SetMemoryPoolSize("EntitySoundStatic",9)
    SetMemoryPoolSize("MountedTurret",5)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",390)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("SoundSpaceRegion",34)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",180)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",200)
    SetMemoryPoolSize("EntityFlyer",4)
    SetMemoryPoolSize("Asteroid",100)
    SetSpawnDelay(10,0.25)
    ReadDataFile("pol\\pol1.lvl","pol1_Conquest")
    SetDenseEnvironment("True")
    AddDeathRegion("deathregion1")
    SetParticleLODBias(3000)
    SetMaxCollisionDistance(1500)
    FillAsteroidPath("pathas01",10,"pol1_prop_asteroid_01",20,1,0,0,-1,0,0)
    FillAsteroidPath("pathas01",20,"pol1_prop_asteroid_02",40,1,0,0,-1,0,0)
    FillAsteroidPath("pathas02",10,"pol1_prop_asteroid_01",10,1,0,0,-1,0,0)
    FillAsteroidPath("pathas03",10,"pol1_prop_asteroid_02",20,1,0,0,-1,0,0)
    FillAsteroidPath("pathas04",5,"pol1_prop_asteroid_02",2,1,0,0,-1,0,0)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetOutOfBoundsVoiceOver(2,"repleaving")
    SetAmbientMusic(REP,1,"rep_pol_amb_start",0,1)
    SetAmbientMusic(REP,0.80000001192093,"rep_pol_amb_middle",1,1)
    SetAmbientMusic(REP,0.20000000298023,"rep_pol_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_pol_amb_start",0,1)
    SetAmbientMusic(CIS,0.80000001192093,"cis_pol_amb_middle",1,1)
    SetAmbientMusic(CIS,0.20000000298023,"cis_pol_amb_end",2,1)
    SetVictoryMusic(REP,"rep_pol_amb_victory")
    SetDefeatMusic(REP,"rep_pol_amb_defeat")
    SetVictoryMusic(CIS,"cis_pol_amb_victory")
    SetDefeatMusic(CIS,"cis_pol_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.46118900179863,-0.077838003635406,-0.87155497074127,-0.14709800481796,85.974006652832,30.694353103638,-66.90079498291)
    AddCameraShot(0.99494600296021,-0.1003800034523,-0.0022980000358075,-0.00023200000578072,109.07640075684,27.636383056641,-10.23578453064)
    AddCameraShot(0.76038300991058,0.046401999890804,0.64661198854446,-0.039459001272917,111.26169586182,27.636383056641,46.468048095703)
    AddCameraShot(-0.25494900345802,0.066384002566338,-0.93354600667953,-0.24307799339294,73.647552490234,32.764030456543,50.283027648926)
    AddCameraShot(-0.33190101385117,0.016248000785708,-0.94204598665237,-0.04611599817872,111.00356292725,28.975282669067,7.0514578819275)
    AddCameraShot(0.29545199871063,-0.038139998912811,-0.94673997163773,-0.12221699953079,19.85668182373,36.399085998535,-9.8903608322144)
    AddCameraShot(0.9580500125885,-0.11583700031042,-0.26025399565697,-0.031466998159885,-35.103736877441,37.551651000977,109.46657562256)
    AddCameraShot(-0.37248799204826,0.036892000585794,-0.92278897762299,-0.091393999755383,-77.487892150879,37.551651000977,40.861831665039)
    AddCameraShot(0.71714401245117,-0.084844999015331,-0.68695002794266,-0.08127299696207,-106.04769134521,36.238494873047,60.770439147949)
    AddCameraShot(0.45295798778534,-0.1047480031848,-0.86259198188782,-0.19947800040245,-110.55347442627,40.972583770752,37.320777893066)
    AddCameraShot(-0.009243999607861,0.0016189999878407,-0.98495602607727,-0.17254999279976,-57.010257720947,30.395561218262,5.6382508277893)
    AddCameraShot(0.42695799469948,-0.040550000965595,-0.89931499958038,-0.085412003099918,-87.005966186523,30.395561218262,19.625087738037)
    AddCameraShot(0.15363200008869,-0.041448000818491,-0.95317900180817,-0.25715601444244,-111.95505523682,36.058708190918,-23.915500640869)
    AddCameraShot(0.2727510035038,-0.0020550000481308,-0.96205502748489,-0.0072470000013709,-117.45273590088,17.298250198364,-58.572723388672)
    AddCameraShot(0.53709697723389,-0.057966001331806,-0.83666801452637,-0.090296998620033,-126.74666595459,30.472835540771,-148.35333251953)
    AddCameraShot(-0.44218799471855,0.081142000854015,-0.87857502698898,-0.16121999919415,-85.660972595215,29.013374328613,-144.10221862793)
    AddCameraShot(-0.065408997237682,0.011040000244975,-0.98388302326202,-0.16605600714684,-84.789031982422,29.013374328613,-139.56878662109)
    AddCameraShot(0.43090599775314,-0.034722998738289,-0.89881497621536,-0.072428002953529,-98.03800201416,47.662624359131,-128.64326477051)
    AddCameraShot(-0.40146198868752,0.047049999237061,-0.9084489941597,-0.10646600276232,77.586563110352,47.662624359131,-147.51736450195)
    AddCameraShot(-0.26950299739838,0.031284000724554,-0.95607101917267,-0.11098299920559,111.2603302002,16.927541732788,-114.04571533203)
    AddCameraShot(-0.33811900019646,0.041636001318693,-0.93313401937485,-0.11490599811077,134.97016906738,26.441255569458,-82.282081604004)
end

