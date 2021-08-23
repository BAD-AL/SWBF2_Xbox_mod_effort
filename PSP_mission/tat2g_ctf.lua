--Extracted\tat2g_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
ATT = 1
DEF = 2
IMP = ATT
ALL = DEF

function ScriptPostLoad()
    SetProperty("ctf_flag1","GeometryName","com_icon_imperial_flag")
    SetProperty("ctf_flag1","CarriedGeometryName","com_icon_imperial_flag_carried")
    SetProperty("ctf_flag2","GeometryName","com_icon_alliance_flag")
    SetProperty("ctf_flag2","CarriedGeometryName","com_icon_alliance_flag_carried")
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", multiplayerRules = true, hideCPs = true })
    ctf:AddFlag({ name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    SoundEvent_SetupTeams(1,"imp",2,"all")
    ctf:Start()
    KillObject("CP1")
    KillObject("CP2")
    KillObject("CP3")
    KillObject("CP4")
    KillObject("CP5")
    KillObject("CP6")
    KillObject("CP7")
    KillObject("CP8")
    AddAIGoal(3,"Deathmatch",1000)
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2896785)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman","all_inf_rocketeer","all_inf_sniper","all_inf_engineer","all_inf_officer","all_inf_wookiee","all_hero_hansolo_tat")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett")
    ReadDataFile("SIDE\\des.lvl","tat_inf_jawa")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 25, reinforcements = 250, 
              soldier =               { "all_inf_rifleman" }, 
              assault =               { "all_inf_rocketeer" }, 
              engineer =               { "all_inf_engineer" }, 
              sniper =               { "all_inf_sniper" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }
           })
        SetupTeams({ 
            imp =             { team = IMP, units = 25, reinforcements = 250, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_bobafett")
    SetTeamName(3,"locals")
    AddUnitClass(3,"tat_inf_jawa",7)
    SetUnitCount(3,7)
    SetTeamAsFriend(3,ATT)
    SetTeamAsFriend(3,DEF)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(DEF,3)
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",14)
    SetMemoryPoolSize("EntityCloth",27)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",40)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",7)
    SetMemoryPoolSize("Obstacle",664)
    SetMemoryPoolSize("PathNode",384)
    SetMemoryPoolSize("TreeGridStack",450)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat2.lvl","tat2_ctf")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_tat_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_tat_amb_start",0,1)
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
    SetAttackingTeam(ATT)
    AddCameraShot(0.97433799505234,-0.22217999398708,0.035172000527382,0.0080199996009469,-82.664649963379,23.668300628662,43.955680847168)
    AddCameraShot(0.39019700884819,-0.089729003608227,-0.89304000139236,-0.2053620070219,23.563562393188,12.914884567261,-101.46556091309)
    AddCameraShot(0.16975900530815,0.0022249999456108,-0.98539799451828,0.012915999628603,126.97280883789,4.0396280288696,-22.020612716675)
    AddCameraShot(0.67745298147202,-0.041535001248121,0.73301601409912,0.044941999018192,97.517807006836,4.0396280288696,36.853477478027)
    AddCameraShot(0.86602902412415,-0.15650600194931,0.46729901432991,0.084449000656605,7.6856398582458,7.1306881904602,-10.895234107971)
end

