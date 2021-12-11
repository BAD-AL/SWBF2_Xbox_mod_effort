--Extracted\fel1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    cp1 = CommandPost:New({ name = "cp1-1" })
    cp2 = CommandPost:New({ name = "cp2-1" })
    cp3 = CommandPost:New({ name = "cp3-1" })
    cp4 = CommandPost:New({ name = "cp4-1" })
    cp5 = CommandPost:New({ name = "cp5-1" })
    cp6 = CommandPost:New({ name = "cp6-1" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
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
    StealArtistHeap(132 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3200000)
end
    ReadDataFile("ingame.lvl")
    SetMemoryPoolSize("Music",39)
    ReadDataFile("sound\\fel.lvl;fel1cw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight(53)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper_felucia","rep_inf_ep3_jettrooper","rep_inf_ep3_officer","rep_hero_aalya","rep_walk_oneman_atst")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","CIS_inf_officer","cis_inf_droideka","cis_hero_jangofett","cis_tread_snailtank")
    SetAttackingTeam(1)
    SetupTeams({ 
        rep =         { team = 1, units = 20, reinforcements = 150, 
          soldier =           { "rep_inf_ep3_rifleman", 9, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper_felucia", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }, 
        cis =         { team = 2, units = 20, reinforcements = 150, 
          soldier =           { "CIS_inf_rifleman", 9, 16 }, 
          assault =           { "CIS_inf_rocketeer", 1, 4 }, 
          engineer =           { "CIS_inf_engineer", 1, 4 }, 
          sniper =           { "CIS_inf_sniper", 1, 4 }, 
          officer =           { "CIS_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(1,"rep_HERO_aalya")
    SetHeroClass(2,"cis_hero_jangofett")
    ClearWalkers()
    AddWalkerType(1,2)
    AddWalkerType(0,4)
    SetMemoryPoolSize("Aimer",20)
    SetMemoryPoolSize("AmmoCounter",260)
    SetMemoryPoolSize("BaseHint",200)
    SetMemoryPoolSize("EnergyBar",260)
    SetMemoryPoolSize("EntityHover",3)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("EntityWalker",5)
    SetMemoryPoolSize("MountedTurret",6)
    SetMemoryPoolSize("Obstacle",400)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TreeGridStack",280)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("fel\\fel1.lvl","fel1_conquest")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.64999997615814)
    SetNumBirdTypes(1)
    SetBirdType(0,1,"bird")
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetBleedingVoiceOver(1,1,"rep_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(1,2,"rep_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(2,1,"cis_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(2,2,"cis_off_com_report_us_overwhelmed",1)
    SetOutOfBoundsVoiceOver(1,"Repleaving")
    SetOutOfBoundsVoiceOver(2,"Cisleaving")
    SetAmbientMusic(1,1,"rep_fel_amb_start",0,1)
    SetAmbientMusic(1,0.89999997615814,"rep_fel_amb_middle",1,1)
    SetAmbientMusic(1,0.10000000149012,"rep_fel_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_fel_amb_start",0,1)
    SetAmbientMusic(2,0.89999997615814,"cis_fel_amb_middle",1,1)
    SetAmbientMusic(2,0.10000000149012,"cis_fel_amb_end",2,1)
    SetVictoryMusic(1,"rep_fel_amb_victory")
    SetDefeatMusic(1,"rep_fel_amb_defeat")
    SetVictoryMusic(2,"cis_fel_amb_victory")
    SetDefeatMusic(2,"cis_fel_amb_defeat")
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

