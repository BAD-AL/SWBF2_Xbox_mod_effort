--Extracted\tat3g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp4 = CommandPost:New({ name = "cp4" })
    cp5 = CommandPost:New({ name = "cp5" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(140 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4470513)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(3897152)
end
    ReadDataFile("ingame.lvl")
    SetMemoryPoolSize("Combo::Transition",75)
    SetMemoryPoolSize("Aimer",0)
    SetMemoryPoolSize("AmmoCounter",220)
    SetMemoryPoolSize("BaseHint",105)
    SetMemoryPoolSize("EnergyBar",220)
    SetMemoryPoolSize("EntityCloth",22)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",145)
    SetMemoryPoolSize("EntitySoundStream",2)
    SetMemoryPoolSize("EntitySoundStatic",3)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",35)
    SetMemoryPoolSize("Obstacle",202)
    SetMemoryPoolSize("PathFollower",35)
    SetMemoryPoolSize("RedOmniLight",150)
    SetMemoryPoolSize("PathNode",256)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("SoundSpaceRegion",80)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",80)
    SetMemoryPoolSize("UnitAgent",35)
    ReadDataFile("sound\\tat.lvl;tat3gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_engineer","all_inf_sniper","all_inf_officer","all_inf_wookiee","all_hero_luke_jedi")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett")
    ReadDataFile("SIDE\\gam.lvl","gam_inf_gamorreanguard")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = 200, 
              soldier =               { "all_inf_rifleman", 4 }, 
              assault =               { "all_inf_rocketeer", 2 }, 
              engineer =               { "all_inf_engineer", 1 }, 
              sniper =               { "all_inf_sniper", 1 }, 
              officer =               { "all_inf_officer", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = 200, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = 200, 
              soldier =               { "all_inf_rifleman", 11 }, 
              assault =               { "all_inf_rocketeer", 4 }, 
              engineer =               { "all_inf_engineer", 3 }, 
              sniper =               { "all_inf_sniper", 2 }, 
              officer =               { "all_inf_officer", 2 }, 
              special =               { "all_inf_wookiee", 3 }
             }, 
            imp =             { team = IMP, units = 25, reinforcements = 200, 
              soldier =               { "imp_inf_rifleman", 11 }, 
              assault =               { "imp_inf_rocketeer", 4 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }
           })
end
    SetHeroClass(ALL,"all_hero_luke_jedi")
    SetHeroClass(IMP,"imp_hero_bobafett")
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat3.lvl","tat3_con")
    SetDenseEnvironment("true")
    SetMaxFlyHeight(90)
    SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_tat_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_tat_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_tat_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_tat_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_tat_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_tat_amb_end",2,1)
    SetVictoryMusic(ALL,"all_tat_amb_victory")
    SetDefeatMusic(ALL,"all_tat_amb_defeat")
    SetVictoryMusic(IMP,"imp_tat_amb_victory")
    SetDefeatMusic(IMP,"imp_tat_amb_defeat")
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

