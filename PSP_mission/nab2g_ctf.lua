--Extracted\nab2g_ctf.lua
-- Decompiled with SWBF2CodeHelper
CTF = ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

function ScriptPostLoad()
    DisableBarriers("camveh")
    DisableBarriers("turbar1")
    DisableBarriers("turbar2")
    DisableBarriers("turbar3")
    DisableBarriers("cambar1")
    DisableBarriers("cambar2")
    DisableBarriers("cambar3")
    SetMapNorthAngle(180,1)
    SoundEvent_SetupTeams(ALL,"all",IMP,"imp")
    SetProperty("flag1","GeometryName","com_icon_alliance_flag")
    SetProperty("flag1","CarriedGeometryName","com_icon_alliance_flag_carried")
    SetProperty("flag2","GeometryName","com_icon_imperial_flag")
    SetProperty("flag2","CarriedGeometryName","com_icon_imperial_flag_carried")
    SetClassProperty("com_item_flag_carried","DroppedColorize",1)
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "flag1", homeRegion = "FlagHome1", captureRegion = "FlagHome2" })
    ctf:AddFlag({ name = "flag2", homeRegion = "FlagHome2", captureRegion = "FlagHome1" })
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(384 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3163533)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    ATT = 1
    DEF = 2
    ALL = ATT
    IMP = DEF
    ReadDataFile("sound\\nab.lvl;nab2gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_engineer","all_inf_sniper","all_inf_officer","all_inf_wookiee","all_hero_leia","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_emperor","imp_hover_fightertank")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 4 }, 
              assault =               { "imp_inf_rocketeer", 2 }, 
              engineer =               { "imp_inf_engineer", 1 }, 
              sniper =               { "imp_inf_sniper", 1 }, 
              officer =               { "imp_inf_officer", 1 }, 
              special =               { "imp_inf_dark_trooper", 1 }
             }, 
            all =             { team = ALL, units = 10, reinforcements = -1, 
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
            imp =             { team = IMP, units = 25, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 11 }, 
              assault =               { "imp_inf_rocketeer", 4 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 3 }
             }, 
            all =             { team = ALL, units = 25, reinforcements = -1, 
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
    SetMemoryPoolSize("Aimer",50)
    SetMemoryPoolSize("AmmoCounter",230)
    SetMemoryPoolSize("BaseHint",150)
    SetMemoryPoolSize("EnergyBar",230)
    SetMemoryPoolSize("EntityCloth",18)
    SetMemoryPoolSize("EntityHover",4)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",43)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",13)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",450)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",300)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TentacleSimulator",8)
    SetMemoryPoolSize("TreeGridStack",350)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",230)
    SetMemoryPoolSize("EntityFlyer",6)
    SetSpawnDelay(10,0.25)
    ReadDataFile("NAB\\nab2.lvl","naboo2_CTF")
    SetDenseEnvironment("true")
    AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    SetBirdFlockMinHeight(-28)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_nab_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_nab_amb_start",0,1)
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

