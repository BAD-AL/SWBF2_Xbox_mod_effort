--Extracted\yav1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
ATT = 1
DEF = 2
ALL = DEF
IMP = ATT

function ScriptPostLoad()
    KillObject("TempleBlastDoor")
    DisableBarriers("StopTanks")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 8, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "HomeRegion", captureRegionATT = "Team1Capture", captureRegionDEF = "Team2Capture", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true })
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(300 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3261369)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2500000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(ALL,1)
    SetTeamAggressiveness(IMP,1)
    SetMaxFlyHeight(14)
    SetMaxPlayerFlyHeight(14)
    SetMaxFlyHeight(-17)
    ReadDataFile("sound\\yav.lvl;yav1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_jungle","all_inf_rocketeer_jungle","all_inf_sniper_jungle","all_inf_engineer_jungle","all_hero_chewbacca","all_inf_officer_jungle","all_inf_wookiee","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_hover_speederbike","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_dark_trooper","imp_hero_bobafett","imp_inf_officer","imp_hover_fightertank")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser","tur_bldg_tower")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_jungle", 4 }, 
              assault =               { "all_inf_rocketeer_jungle", 2 }, 
              engineer =               { "all_inf_engineer_jungle", 1 }, 
              sniper =               { "all_inf_sniper_jungle", 1 }, 
              officer =               { "all_inf_officer_jungle", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_sniper", 1 }, 
              sniper =               { "imp_inf_engineer", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_jungle", 11 }, 
              assault =               { "all_inf_rocketeer_jungle", 4 }, 
              engineer =               { "all_inf_engineer_jungle", 3 }, 
              sniper =               { "all_inf_sniper_jungle", 2 }, 
              officer =               { "all_inf_officer_jungle", 2 }, 
              special =               { "all_inf_wookiee", 3 }
             }, 
            imp =             { team = IMP, units = 25, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 11 }, 
              assault =               { "imp_inf_rocketeer", 4 }, 
              engineer =               { "imp_inf_sniper", 3 }, 
              sniper =               { "imp_inf_engineer", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }
           })
end
    SetHeroClass(ALL,"all_hero_chewbacca")
    SetHeroClass(IMP,"imp_hero_bobafett")
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",13)
    SetMemoryPoolSize("AmmoCounter",214)
    SetMemoryPoolSize("BaseHint",1000)
    SetMemoryPoolSize("EnergyBar",214)
    SetMemoryPoolSize("EntityCloth",17)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("EntitySoundStatic",20)
    SetMemoryPoolSize("EntityLight",38)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("MountedTurret",13)
    SetMemoryPoolSize("Navigator",46)
    SetMemoryPoolSize("Obstacle",750)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("SoundSpaceRegion",48)
    SetMemoryPoolSize("TreeGridStack",500)
    SetMemoryPoolSize("UnitAgent",46)
    SetMemoryPoolSize("UnitController",46)
    SetMemoryPoolSize("Weapon",214)
    SetMemoryPoolSize("EntityFlyer",7)
    SetMemoryPoolSize("EntityHover",2)
    SetSpawnDelay(10,0.25)
    ReadDataFile("YAV\\yav1.lvl","Yavin1_CTF_CenterFlag")
    SetDenseEnvironment("false")
    SetNumBirdTypes(2)
    SetBirdType(0,1,"bird")
    SetBirdType(1,1.5,"bird2")
    SetNumFishTypes(1)
    SetFishType(0,0.80000001192093,"fish")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_yav_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_yav_amb_start",0,1)
    SetVictoryMusic(ALL,"all_yav_amb_victory")
    SetDefeatMusic(ALL,"all_yav_amb_defeat")
    SetVictoryMusic(IMP,"imp_yav_amb_victory")
    SetDefeatMusic(IMP,"imp_yav_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.66039997339249,-0.059877000749111,-0.74546498060226,-0.067589998245239,143.73443603516,-55.725387573242,7.7619972229004)
    AddCameraShot(0.83073300123215,-0.14438499510288,0.52967900037766,0.092060998082161,111.79679870605,-42.959831237793,75.199142456055)
    AddCameraShot(0.47567600011826,-0.064657002687454,-0.86924701929092,-0.11815399676561,13.451732635498,-47.76989364624,13.242495536804)
    AddCameraShot(-0.16883300244808,0.020623000338674,-0.97815799713135,-0.11948300153017,58.080200195313,-50.858741760254,-62.2080078125)
    AddCameraShot(0.88096100091934,-0.44082000851631,-0.15382400155067,-0.076971001923084,101.7777633667,-46.775646209717,-29.683767318726)
    AddCameraShot(0.89382302761078,-0.18383799493313,0.4006179869175,0.082397997379303,130.71482849121,-60.244068145752,-27.587791442871)
    AddCameraShot(0.99953401088715,0.0040600001811981,0.030244000256062,-0.00012300000526011,222.20913696289,-61.220325469971,-18.061191558838)
    AddCameraShot(0.91263699531555,-0.057865999639034,0.403843998909,0.02560600079596,236.69334411621,-49.829277038574,-116.15098571777)
    AddCameraShot(0.43073201179504,-0.016397999599576,-0.9016780257225,-0.034327998757362,180.69206237793,-54.148796081543,-159.85664367676)
    AddCameraShot(0.83211898803711,-0.063785001635551,0.54930597543716,0.042107000946999,160.69940185547,-54.148796081543,-130.99069213867)
    AddCameraShot(0.40419998764992,-0.037992000579834,-0.9098709821701,-0.085519999265671,68.815330505371,-54.148796081543,-160.83758544922)
    AddCameraShot(-0.43884500861168,0.053442001342773,-0.89039397239685,-0.10843099653721,116.56224060059,-52.504405975342,-197.68600463867)
    AddCameraShot(0.38934901356697,-0.11339999735355,-0.87761700153351,-0.25560900568962,29.177610397339,-23.974962234497,-288.06167602539)
    AddCameraShot(0.49993801116943,-0.081055998802185,-0.85114598274231,-0.13799799978733,90.32691192627,-28.060659408569,-283.3293762207)
    AddCameraShot(-0.21700599789619,0.015115999616683,-0.97369402647018,-0.067827001214027,202.0567779541,-37.476913452148,-181.44566345215)
    AddCameraShot(0.9906399846077,-0.082509003579617,0.10836700350046,0.0090260002762079,206.26695251465,-37.476913452148,-225.15824890137)
    AddCameraShot(-0.38658899068832,0.12639999389648,-0.86831402778625,-0.28390699625015,224.94203186035,-17.820135116577,-269.5322265625)
    AddCameraShot(0.96749299764633,0.054297998547554,0.24661099910736,-0.013840000145137,155.98445129395,-30.781782150269,-324.83697509766)
    AddCameraShot(-0.45314699411392,0.14048500359058,-0.84081602096558,-0.26067200303078,164.64895629883,-0.0024309998843819,-378.48706054688)
    AddCameraShot(0.59273099899292,-0.1825709939003,-0.74967801570892,-0.23091299831867,99.326835632324,-13.029744148254,-414.84619140625)
    AddCameraShot(0.86575001478195,-0.18435199558735,0.45508399605751,0.096905000507832,137.22135925293,-19.694858551025,-436.05755615234)
    AddCameraShot(0.026915000751615,-0.0026090000756085,-0.99496901035309,-0.096460998058319,128.39794921875,-30.249139785767,-428.44741821289)
end

