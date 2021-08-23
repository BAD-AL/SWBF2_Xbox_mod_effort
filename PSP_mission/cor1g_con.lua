--Extracted\cor1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    AddDeathRegion("Death")
    AddDeathRegion("Death1")
    AddDeathRegion("Death2")
    AddDeathRegion("Death3")
    AddDeathRegion("Death4")
    SetProperty("LibCase1","MaxHealth",1000)
    SetProperty("LibCase2","MaxHealth",1000)
    SetProperty("LibCase3","MaxHealth",1000)
    SetProperty("LibCase4","MaxHealth",1000)
    SetProperty("LibCase5","MaxHealth",1000)
    SetProperty("LibCase6","MaxHealth",1000)
    SetProperty("LibCase7","MaxHealth",1000)
    SetProperty("LibCase8","MaxHealth",1000)
    SetProperty("LibCase9","MaxHealth",1000)
    SetProperty("LibCase10","MaxHealth",1000)
    SetProperty("LibCase11","MaxHealth",1000)
    SetProperty("LibCase12","MaxHealth",1000)
    SetProperty("LibCase13","MaxHealth",1000)
    SetProperty("LibCase14","MaxHealth",1000)
    SetProperty("LibCase1","CurHealth",1000)
    SetProperty("LibCase2","CurHealth",1000)
    SetProperty("LibCase3","CurHealth",1000)
    SetProperty("LibCase4","CurHealth",1000)
    SetProperty("LibCase5","CurHealth",1000)
    SetProperty("LibCase6","CurHealth",1000)
    SetProperty("LibCase7","CurHealth",1000)
    SetProperty("LibCase8","CurHealth",1000)
    SetProperty("LibCase9","CurHealth",1000)
    SetProperty("LibCase10","CurHealth",1000)
    SetProperty("LibCase11","CurHealth",1000)
    SetProperty("LibCase12","CurHealth",1000)
    SetProperty("LibCase13","CurHealth",1000)
    SetProperty("LibCase14","CurHealth",1000)
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
    cp1 = CommandPost:New({ name = "CP1" })
    cp2 = CommandPost:New({ name = "CP2" })
    cp3 = CommandPost:New({ name = "CP3" })
    cp4 = CommandPost:New({ name = "CP4" })
    cp5 = CommandPost:New({ name = "CP5" })
    cp6 = CommandPost:New({ name = "CP6" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "level.yavin1.con.att", textDEF = "level.yavin1.con.def", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4174513)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4000000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\cor.lvl;cor1gcw")
    SetMapNorthAngle(0)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight(25)
    AISnipeSuitabilityDist(30)
    ReadDataFile("SIDE\\all.lvl","all_bldg_defensegridturret","all_inf_rifleman","all_inf_rocketeer","all_inf_engineer","all_inf_sniper","all_inf_officer","all_inf_wookiee","all_hero_luke_jedi")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_emperor")
    ReadDataFile("SIDE\\rep.lvl","rep_fly_assault_DOME","rep_fly_gunship_DOME")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser")
    ReadDataFile("SIDE\\cis.lvl","cis_fly_droidfighter_DOME")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            imp =             { team = IMP, units = 10, reinforcements = 200, turret = "all_bldg_defensegridturret", 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }, 
            all =             { team = ALL, units = 10, reinforcements = 200, turret = "all_bldg_defensegridturret", 
              soldier =               { "all_inf_rifleman", 4 }, 
              assault =               { "all_inf_rocketeer", 2 }, 
              engineer =               { "all_inf_engineer", 1 }, 
              sniper =               { "all_inf_sniper", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }
           })
else
        SetupTeams({ 
            imp =             { team = IMP, units = 25, reinforcements = 200, turret = "all_bldg_defensegridturret", 
              soldier =               { "imp_inf_rifleman", 11 }, 
              assault =               { "imp_inf_rocketeer", 4 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }, 
            all =             { team = ALL, units = 25, reinforcements = 200, turret = "all_bldg_defensegridturret", 
              soldier =               { "all_inf_rifleman", 11 }, 
              assault =               { "all_inf_rocketeer", 4 }, 
              engineer =               { "all_inf_engineer", 3 }, 
              sniper =               { "all_inf_sniper", 2 }, 
              officer =               { "all_inf_officer", 2 }, 
              special =               { "all_inf_wookiee", 3 }
             }
           })
end
    SetHeroClass(ALL,"all_hero_luke_jedi")
    SetHeroClass(IMP,"imp_hero_emperor")
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",13)
    SetMemoryPoolSize("AmmoCounter",154)
    SetMemoryPoolSize("EnergyBar",154)
    SetMemoryPoolSize("EntityCloth",21)
    SetMemoryPoolSize("EntityLight",96)
    SetMemoryPoolSize("MountedTurret",13)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("SoundSpaceRegion",38)
    SetMemoryPoolSize("TreeGridStack",256)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",154)
    SetMemoryPoolSize("EntityFlyer",4)
    SetSpawnDelay(10,0.25)
    ReadDataFile("cor\\cor1.lvl","cor1_Conquest")
    SetDenseEnvironment("True")
    AddDeathRegion("DeathRegion1")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_cor_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_cor_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_cor_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_cor_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_cor_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_cor_amb_end",2,1)
    SetVictoryMusic(ALL,"all_cor_amb_victory")
    SetDefeatMusic(ALL,"all_cor_amb_defeat")
    SetVictoryMusic(IMP,"imp_cor_amb_victory")
    SetDefeatMusic(IMP,"imp_cor_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.41993799805641,0.0022350000217557,-0.90753698348999,0.0048299999907613,-15.639357566833,5.4999799728394,-176.91117858887)
    AddCameraShot(0.99450600147247,0.1044630035758,-0.0067389998584986,0.00070799997774884,1.7452510595322,5.4999799728394,-118.70066833496)
    AddCameraShot(0.008929000236094,-0.001103000016883,-0.99242299795151,-0.12253800034523,1.3667680025101,16.818105697632,-114.42217254639)
    AddCameraShot(0.76175099611282,-0.1178729981184,-0.62956500053406,-0.097419001162052,59.861904144287,16.818105697632,-81.607772827148)
    AddCameraShot(0.71710997819901,-0.013582999818027,0.69670301675797,0.013197000138462,98.053314208984,11.354496955872,-85.857856750488)
    AddCameraShot(0.36095800995827,-0.0010529999854043,-0.93257701396942,-0.0027209999971092,69.017578125,18.145807266235,-56.992412567139)
    AddCameraShot(-0.38597598671913,0.014031000435352,-0.92179298400879,-0.033507999032736,93.111061096191,18.145807266235,-20.164375305176)
    AddCameraShot(0.69546800851822,-0.12956899404526,-0.6948230266571,-0.12944799661636,27.284357070923,18.145807266235,-12.377695083618)
    AddCameraShot(0.0090020000934601,-0.00079499999992549,-0.99608397483826,-0.087944999337196,1.9313199520111,13.356331825256,-16.410583496094)
    AddCameraShot(0.94771999120712,-0.14531800150871,0.28081399202347,0.043058000504971,11.650737762451,16.955814361572,28.359180450439)
    AddCameraShot(0.68638002872467,-0.12755000591278,0.70391899347305,0.1308099925518,-30.096384048462,11.152356147766,-63.235145568848)
    AddCameraShot(0.93794500827789,-0.10840799659491,0.32722398638725,0.037820998579264,-43.701198577881,8.7561378479004,-49.974788665771)
    AddCameraShot(0.53123599290848,-0.079466000199318,-0.83420699834824,-0.1247870028019,-62.491230010986,10.305247306824,-120.10298919678)
    AddCameraShot(0.45228600502014,-0.17903099954128,-0.81239002943039,-0.32157200574875,-50.015197753906,15.394645690918,-114.87937927246)
    AddCameraShot(0.92756301164627,-0.24375100433826,0.27391800284386,0.071981996297836,26.149965286255,26.947923660278,-46.834148406982)
end

