--Extracted\fel1c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ATT = 1
DEF = 2
REP = ATT
CIS = DEF

function ScriptPostLoad()
    EnableSPHeroRules()
    SoundEvent_SetupTeams(REP,"rep",CIS,"cis")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "flag_capture1", captureRegionDEF = "flag_capture2", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true, hideCPs = true })
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
    ReadDataFile("sound\\fel.lvl;fel1cw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight(53)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper_felucia","rep_hero_aalya","rep_inf_ep3_officer","REP_walk_atte")
    ReadDataFile("SIDE\\cis.lvl","cis_hover_aat","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_hero_jangofett","cis_inf_officer","cis_inf_droideka")
    SetAttackingTeam(ATT)
    SetupTeams({ 
        rep =         { team = REP, units = 20, reinforcements = -1, 
          soldier =           { "rep_inf_ep3_rifleman", 9, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper_felucia", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }
       })
    SetupTeams({ 
        cis =         { team = CIS, units = 20, reinforcements = -1, 
          soldier =           { "CIS_inf_rifleman", 9, 16 }, 
          assault =           { "CIS_inf_rocketeer", 1, 4 }, 
          engineer =           { "CIS_inf_engineer", 1, 4 }, 
          sniper =           { "CIS_inf_sniper", 1, 4 }, 
          officer =           { "CIS_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(REP,"rep_hero_aalya")
    SetHeroClass(CIS,"cis_hero_jangofett")
    ClearWalkers()
    AddWalkerType(3,1)
    SetMemoryPoolSize("CommandWalker",2)
    SetMemoryPoolSize("EntityHover",5)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("Aimer",75)
    SetMemoryPoolSize("TreeGridStack",280)
    SetMemoryPoolSize("BaseHint",101)
    SetMemoryPoolSize("Obstacle",340)
    SetMemoryPoolSize("FlagItem",2)
    SetSpawnDelay(10,0.25)
    ReadDataFile("fel\\fel1.lvl","fel1_1ctf")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.64999997615814)
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetOutOfBoundsVoiceOver(1,"Repleaving")
    SetOutOfBoundsVoiceOver(2,"Cisleaving")
    SetAmbientMusic(REP,1,"rep_fel_amb_start",0,1)
    SetAmbientMusic(REP,0.89999997615814,"rep_fel_amb_middle",1,1)
    SetAmbientMusic(REP,0.10000000149012,"rep_fel_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_fel_amb_start",0,1)
    SetAmbientMusic(CIS,0.89999997615814,"cis_fel_amb_middle",1,1)
    SetAmbientMusic(CIS,0.10000000149012,"cis_fel_amb_end",2,1)
    SetVictoryMusic(REP,"rep_fel_amb_victory")
    SetDefeatMusic(REP,"rep_fel_amb_defeat")
    SetVictoryMusic(CIS,"cis_fel_amb_victory")
    SetDefeatMusic(CIS,"cis_fel_amb_defeat")
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

