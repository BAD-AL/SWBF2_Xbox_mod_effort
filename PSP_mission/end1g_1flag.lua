--Extracted\end1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

function ScriptPostLoad()
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "team1_capture", capRegionWorldATT = "com_bldg_ctfbase", capRegionWorldDEF = "com_bldg_ctfbase1", captureRegionATT = "team1_capture", captureRegionDEF = "team2_capture", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true, hideCPs = true })
    SoundEvent_SetupTeams(2,"imp",1,"all")
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(768 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2887805)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(2460000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\end.lvl;end1gcw")
    SetTeamAggressiveness(1,1)
    SetTeamAggressiveness(2,0.69999998807907)
    SetMaxFlyHeight(43)
    SetMaxPlayerFlyHeight(43)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_jungle","all_inf_rocketeer_jungle","all_inf_engineer_jungle","all_inf_sniper_jungle","all_inf_officer_jungle","all_hero_hansolo_tat","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_darthvader","imp_hover_speederbike","imp_walk_atst_jungle")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_laser")
    ReadDataFile("SIDE\\ewk.lvl","ewk_inf_basic")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = 1, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_jungle", 4 }, 
              assault =               { "all_inf_rocketeer_jungle", 2 }, 
              engineer =               { "all_inf_engineer_jungle", 1 }, 
              sniper =               { "all_inf_sniper_jungle", 1 }, 
              officer =               { "all_inf_officer_jungle", 1 }, 
              special =               { "all_inf_wookiee", 1 }
             }, 
            imp =             { team = 2, units = 10, reinforcements = -1, 
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
            all =             { team = 1, units = 21, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_jungle", 9 }, 
              assault =               { "all_inf_rocketeer_jungle", 3 }, 
              engineer =               { "all_inf_engineer_jungle", 3 }, 
              sniper =               { "all_inf_sniper_jungle", 2 }, 
              officer =               { "all_inf_officer_jungle", 2 }, 
              special =               { "all_inf_wookiee", 2 }
             }, 
            imp =             { team = 2, units = 21, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman", 9 }, 
              assault =               { "imp_inf_rocketeer", 3 }, 
              engineer =               { "imp_inf_engineer", 3 }, 
              sniper =               { "imp_inf_sniper", 2 }, 
              officer =               { "imp_inf_officer", 2 }, 
              special =               { "imp_inf_dark_trooper", 2 }
             }
           })
end
    SetHeroClass(1,"all_hero_hansolo_tat")
    SetHeroClass(2,"imp_hero_darthvader")
    SetTeamName(3,"locals")
    AddUnitClass(3,"ewk_inf_trooper",3)
    AddUnitClass(3,"ewk_inf_repair",3)
    SetUnitCount(3,6)
    SetTeamAsFriend(3,1)
    SetTeamAsEnemy(3,2)
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,3)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("ActiveRegion",4)
    SetMemoryPoolSize("Aimer",27)
    SetMemoryPoolSize("AmmoCounter",165)
    SetMemoryPoolSize("BaseHint",100)
    SetMemoryPoolSize("EnergyBar",165)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityHover",9)
    SetMemoryPoolSize("EntityLight",20)
    SetMemoryPoolSize("EntitySoundStatic",95)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("MountedTurret",6)
    SetMemoryPoolSize("Navigator",39)
    SetMemoryPoolSize("Obstacle",745)
    SetMemoryPoolSize("PathFollower",39)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("RedOmniLight",9)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("SoundSpaceRegion",6)
    SetMemoryPoolSize("TreeGridStack",587)
    SetMemoryPoolSize("UnitAgent",39)
    SetMemoryPoolSize("UnitController",39)
    SetMemoryPoolSize("Weapon",165)
    SetMemoryPoolSize("FlagItem",1)
    SetTeamAsFriend(1,3)
    SetTeamAsEnemy(2,3)
    SetSpawnDelay(10,0.25)
    ReadDataFile("end\\end1.lvl","end1_1flag")
    SetDenseEnvironment("true")
    AddDeathRegion("deathregion")
    SetStayInTurrets(1)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(1,1,"all_end_amb_start",0,1)
    SetAmbientMusic(2,1,"imp_end_amb_start",0,1)
    SetVictoryMusic(1,"all_end_amb_victory")
    SetDefeatMusic(1,"all_end_amb_defeat")
    SetVictoryMusic(2,"imp_end_amb_victory")
    SetDefeatMusic(2,"imp_end_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(1)
    AddCameraShot(0.99765402078629,0.066982001066208,0.014139000326395,-0.00094900000840425,155.1371307373,0.91150498390198,-138.07707214355)
    AddCameraShot(0.72976100444794,0.019262000918388,0.68319398164749,-0.018032999709249,-98.584869384766,0.29528400301933,263.23928833008)
    AddCameraShot(0.69427698850632,0.0051000001840293,0.71967101097107,-0.0052869999781251,-11.105946540833,-2.7532069683075,67.982200622559)
end

