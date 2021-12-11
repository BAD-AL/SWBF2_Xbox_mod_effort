--Extracted\tan1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    AddDeathRegion("turbinedeath")
    DisableBarriers("barracks")
    KillObject("blastdoor")
    DisableBarriers("liea")
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine,"turbineconsole")
    OnObjectRespawnName(returbine,"turbineconsole")
    SetMapNorthAngle(180)
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "1flag_team1_capture", captureRegionATT = "1flag_team1_capture", captureRegionDEF = "1flag_team2_capture", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true })
    ctf:Start()
    EnableSPHeroRules()
end

function destturbine()
    UnblockPlanningGraphArcs("turbine")
    PauseAnimation("Turbine Animation")
    RemoveRegion("turbinedeath")
end

function returbine()
    BlockPlanningGraphArcs("turbine")
    PlayAnimation("Turbine Animation")
    AddDeathRegion("turbinedeath")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4351537)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4500000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\tan.lvl;tan1gcw")
    AISnipeSuitabilityDist(30)
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_fleet","all_inf_rocketeer_fleet","all_inf_sniper_fleet","all_inf_engineer_fleet","all_inf_officer","all_hero_leia","all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_officer","imp_inf_sniper","imp_inf_engineer","imp_inf_dark_trooper","imp_hero_darthvader")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_fleet" }, 
              assault =               { "all_inf_rocketeer_fleet" }, 
              engineer =               { "all_inf_engineer_fleet" }, 
              sniper =               { "all_inf_sniper_fleet" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper", 1, 4 }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 18, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_fleet" }, 
              assault =               { "all_inf_rocketeer_fleet" }, 
              engineer =               { "all_inf_engineer_fleet" }, 
              sniper =               { "all_inf_sniper_fleet" }, 
              officer =               { "all_inf_officer" }, 
              special =               { "all_inf_wookiee" }
             }, 
            imp =             { team = IMP, units = 18, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman" }, 
              assault =               { "imp_inf_rocketeer" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper", 1, 4 }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_darthvader")
    SetHeroClass(ALL,"all_hero_leia")
    ClearWalkers()
    SetMemoryPoolSize("EntityCloth",34)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("Obstacle",209)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("SoundSpaceRegion",15)
    SetMemoryPoolSize("Weapon",260)
    SetSpawnDelay(10,0.25)
    ReadDataFile("tan\\tan1.lvl","tan1_1flag")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_tan_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_tan_amb_start",0,1)
    SetVictoryMusic(ALL,"all_tan_amb_victory")
    SetDefeatMusic(ALL,"all_tan_amb_defeat")
    SetVictoryMusic(IMP,"imp_tan_amb_victory")
    SetDefeatMusic(IMP,"imp_tan_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.23319900035858,-0.019440999254584,-0.96887397766113,-0.080770999193192,-240.75592041016,11.457644462585,105.94417572021)
    AddCameraShot(-0.39556100964546,0.079428002238274,-0.89709198474884,-0.18013499677181,-264.02227783203,6.7458729743958,122.71575164795)
    AddCameraShot(0.54670298099518,-0.041547000408173,-0.83389097452164,-0.063371002674103,-309.70989990234,5.1683039665222,145.33438110352)
end

