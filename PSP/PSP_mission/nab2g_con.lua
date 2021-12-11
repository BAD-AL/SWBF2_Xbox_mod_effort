--Extracted\nab2g_con.lua
-- Decompiled with SWBF2CodeHelper
Conquest = ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")
ALL = 2
IMP = 1
GAR = 3
ATT = 1
DEF = 2

function ScriptPostLoad()
    DisableBarriers("camveh")
    DisableBarriers("turbar1")
    DisableBarriers("turbar2")
    DisableBarriers("turbar3")
    DisableBarriers("cambar1")
    DisableBarriers("cambar2")
    DisableBarriers("cambar3")
    SetMapNorthAngle(180,1)
    AICanCaptureCP("CP1",GAR,false)
    AICanCaptureCP("CP2",GAR,false)
    AICanCaptureCP("CP3",GAR,false)
    AICanCaptureCP("CP4",GAR,false)
    AICanCaptureCP("CP5",GAR,false)
    AICanCaptureCP("CP6",GAR,false)
    AddAIGoal(GAR,"Deathmatch",100)
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
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(384 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2876237)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\nab.lvl;nab2gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_engineer","all_inf_sniper","all_inf_officer","all_inf_wookiee","all_hero_leia")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_emperor","imp_hover_fightertank")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            imp =             { team = IMP, units = 10, reinforcements = 75, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }, 
            all =             { team = ALL, units = 10, reinforcements = 75, 
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
            imp =             { team = IMP, units = 25, reinforcements = 200, 
              soldier =               { "imp_inf_rifleman", 11 }, 
              assault =               { "imp_inf_rocketeer", 4 }, 
              engineer =               { "imp_inf_engineer", 4 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }, 
            all =             { team = ALL, units = 25, reinforcements = 200, 
              soldier =               { "all_inf_rifleman", 11 }, 
              assault =               { "all_inf_rocketeer", 4 }, 
              engineer =               { "all_inf_engineer", 3 }, 
              sniper =               { "all_inf_sniper", 2 }, 
              officer =               { "all_inf_officer", 2 }, 
              special =               { "all_inf_wookiee", 3 }
             }
           })
end
    SetHeroClass(ALL,"all_hero_leia")
    SetHeroClass(IMP,"imp_hero_emperor")
    ClearWalkers()
    AddWalkerType(1,0)
    SetMemoryPoolSize("Aimer",23)
    SetMemoryPoolSize("AmmoCounter",220)
    SetMemoryPoolSize("BaseHint",128)
    SetMemoryPoolSize("EnergyBar",220)
    SetMemoryPoolSize("EntityCloth",24)
    SetMemoryPoolSize("EntityHover",4)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",45)
    SetMemoryPoolSize("MountedTurret",12)
    SetMemoryPoolSize("Navigator",55)
    SetMemoryPoolSize("Obstacle",450)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TentacleSimulator",8)
    SetMemoryPoolSize("TreeGridStack",325)
    SetMemoryPoolSize("UnitAgent",55)
    SetMemoryPoolSize("UnitController",55)
    SetMemoryPoolSize("Weapon",220)
    SetMemoryPoolSize("EntityFlyer",6)
    SetSpawnDelay(10,0.25)
    ReadDataFile("NAB\\nab2.lvl","naboo2_Conquest")
    SetDenseEnvironment("true")
    AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_nab_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_nab_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_nab_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_nab_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_nab_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_nab_amb_end",2,1)
    SetVictoryMusic(ALL,"all_nab_amb_victory")
    SetDefeatMusic(ALL,"all_nab_amb_defeat")
    SetVictoryMusic(IMP,"imp_nab_amb_victory")
    SetDefeatMusic(IMP,"imp_nab_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.038176998496056,-0.0055979997850955,-0.98868298530579,-0.14497299492359,-0.98553502559662,18.617458343506,-123.31650543213)
    AddCameraShot(0.99310600757599,-0.10938899964094,0.041873000562191,0.0046120001934469,6.5769319534302,24.040697097778,-25.576217651367)
    AddCameraShot(0.85150897502899,-0.17047999799252,0.48620200157166,0.097341999411583,158.7677154541,22.913860321045,-0.4386579990387)
    AddCameraShot(0.95737099647522,-0.12965500354767,-0.25579300522804,-0.034641001373529,136.93354797363,20.207420349121,99.608245849609)
    AddCameraShot(0.9303640127182,-0.2061969935894,0.29597899317741,0.065598003566265,102.19185638428,22.665433883667,92.389434814453)
    AddCameraShot(0.99766498804092,-0.06827100366354,0.0020860000513494,0.00014299999747891,88.042350769043,13.869274139404,93.643898010254)
    AddCameraShot(0.9689000248909,-0.10062199831009,0.22486199438572,0.02335200086236,4.2452630996704,13.869274139404,97.208541870117)
    AddCameraShot(0.0070910002104938,-0.0003629999991972,-0.99866902828217,-0.051088999956846,-1.3099900484085,16.247049331665,15.925866127014)
    AddCameraShot(-0.27481600642204,0.042768001556396,-0.94912099838257,-0.14770500361919,-55.505107879639,25.990821838379,86.987533569336)
    AddCameraShot(0.85965102910995,-0.22922499477863,0.44115599989891,0.11763399839401,-62.493007659912,31.040746688843,117.99536895752)
    AddCameraShot(0.7038379907608,-0.055939000099897,0.70592802762985,0.056106001138687,-120.40105438232,23.573558807373,-15.484946250916)
    AddCameraShot(0.83547401428223,-0.18131799995899,-0.5069540143013,-0.11002100259066,-166.31477355957,27.687097549438,-6.7157969474792)
    AddCameraShot(0.32757300138474,-0.024827999994159,-0.94179797172546,-0.071382001042366,-109.70018005371,15.415475845337,-84.413604736328)
    AddCameraShot(-0.40050500631332,0.030208000913262,-0.91320300102234,-0.068878002464771,82.372711181641,15.415475845337,-42.439548492432)
end

