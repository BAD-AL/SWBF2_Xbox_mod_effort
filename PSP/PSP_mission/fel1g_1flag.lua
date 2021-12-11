--Extracted\fel1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ATT = 1
DEF = 2
IMP = ATT
ALL = DEF

function ScriptPostLoad()
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "flag_capture1", captureRegionDEF = "flag_capture2", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, hideCPs = true, multiplayerRules = true })
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3200000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\fel.lvl;fel1gcw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight(53)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_jungle","all_inf_rocketeer_jungle","all_inf_sniper_jungle","all_inf_engineer_jungle","all_inf_officer_jungle","all_inf_wookiee","all_hero_chewbacca","all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_dark_trooper","imp_inf_officer","imp_walk_atst_jungle","imp_hero_bobafett")
    SetupTeams({ 
        all =         { team = ALL, units = 20, reinforcements = -1, 
          soldier =           { "all_inf_rifleman_jungle", 9, 16 }, 
          assault =           { "all_inf_rocketeer_jungle", 1, 4 }, 
          engineer =           { "all_inf_engineer_jungle", 1, 4 }, 
          sniper =           { "all_inf_sniper_jungle", 1, 4 }, 
          officer =           { "all_inf_officer_jungle", 1, 4 }, 
          special =           { "all_inf_wookiee", 1, 4 }
         }, 
        imp =         { team = IMP, units = 20, reinforcements = -1, 
          soldier =           { "imp_inf_rifleman", 9, 16 }, 
          assault =           { "imp_inf_rocketeer", 1, 4 }, 
          engineer =           { "imp_inf_engineer", 1, 4 }, 
          sniper =           { "imp_inf_sniper", 1, 4 }, 
          officer =           { "imp_inf_officer", 1, 4 }, 
          special =           { "imp_inf_dark_trooper", 1, 4 }
         }
       })
    SetHeroClass(ALL,"all_hero_chewbacca")
    SetHeroClass(IMP,"imp_hero_bobafett")
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker",3)
    AddWalkerType(2,2)
    SetMemoryPoolSize("Aimer",75)
    SetMemoryPoolSize("EntityCloth",38)
    SetMemoryPoolSize("EntityHover",4)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("Obstacle",340)
    SetMemoryPoolSize("TreeGridStack",261)
    SetMemoryPoolSize("Weapon",230)
    SetMemoryPoolSize("EntityFlyer",6)
    SetSpawnDelay(10,0.25)
    ReadDataFile("fel\\fel1.lvl","fel1_1ctf")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.64999997615814)
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetOutOfBoundsVoiceOver(1,"impleaving")
    SetOutOfBoundsVoiceOver(2,"allleaving")
    SetAmbientMusic(ALL,1,"all_fel_amb_start",0,1)
    SetAmbientMusic(ALL,0.89999997615814,"all_fel_amb_middle",1,1)
    SetAmbientMusic(ALL,0.10000000149012,"all_fel_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_fel_amb_start",0,1)
    SetAmbientMusic(IMP,0.89999997615814,"imp_fel_amb_middle",1,1)
    SetAmbientMusic(IMP,0.10000000149012,"imp_fel_amb_end",2,1)
    SetVictoryMusic(ALL,"all_fel_amb_victory")
    SetDefeatMusic(ALL,"all_fel_amb_defeat")
    SetVictoryMusic(IMP,"imp_fel_amb_victory")
    SetDefeatMusic(IMP,"imp_fel_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.89630699157715,-0.17134800553322,-0.40171599388123,-0.076796002686024,-116.30693054199,31.039505004883,20.757469177246)
    AddCameraShot(0.90934300422668,-0.2019670009613,-0.35508298873901,-0.078864999115467,-116.30693054199,31.039505004883,20.757469177246)
    AddCameraShot(0.54319900274277,0.11552099883556,-0.81342798471451,0.17298999428749,-108.37818908691,13.564240455627,-40.644149780273)
    AddCameraShot(0.97061002254486,0.13565899431705,0.1968660056591,-0.027514999732375,-3.2143459320068,11.924586296082,-44.687294006348)
    AddCameraShot(0.34613001346588,0.046310998499393,-0.92876601219177,0.12426699697971,87.431060791016,20.881387710571,13.070729255676)
    AddCameraShot(0.4680840075016,0.095610998570919,-0.86072397232056,0.1758120059967,18.063482284546,19.360580444336,18.178157806396)
end

