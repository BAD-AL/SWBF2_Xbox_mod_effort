--Extracted\hot1g_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ALL = 2
IMP = 1
ATT = 1
DEF = 2

function ScriptPostLoad()
    SoundEvent_SetupTeams(IMP,"imp",ALL,"all")
    AddDeathRegion("fall")
    EnableSPHeroRules()
    KillObject("CP7OBJ")
    KillObject("shieldgen")
    KillObject("CP7OBJ")
    KillObject("hangarcp")
    KillObject("enemyspawn")
    KillObject("enemyspawn2")
    KillObject("echoback2")
    KillObject("echoback1")
    KillObject("shield")
    DisableBarriers("conquestbar")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", hideCPs = true, multiplayerRules = true, captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "HomeRegion", captureRegionATT = "Team2Capture", captureRegionDEF = "Team1Capture", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3 })
    ctf:Start()
end

function ScriptInit()
    StealArtistHeap(256 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2894545)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4600000)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_snow","all_inf_rocketeer_snow","all_inf_engineer_snow","all_inf_sniper_snow","all_inf_officer_snow","all_hero_luke_pilot","all_inf_wookiee_snow")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman_snow","imp_inf_rocketeer_snow","imp_inf_sniper_snow","imp_inf_dark_trooper","imp_inf_engineer_snow","imp_inf_officer","imp_hero_darthvader")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_hoth_dishturret","tur_bldg_hoth_lasermortar","tur_bldg_chaingun_tripod","tur_bldg_chaingun_roof")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_snow" }, 
              assault =               { "all_inf_rocketeer_snow" }, 
              engineer =               { "all_inf_engineer_snow" }, 
              sniper =               { "all_inf_sniper_snow" }, 
              officer =               { "all_inf_officer_snow" }, 
              special =               { "all_inf_wookiee_snow" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman_snow" }, 
              assault =               { "imp_inf_rocketeer_snow" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper_snow" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 20, reinforcements = -1, 
              soldier =               { "all_inf_rifleman_snow" }, 
              assault =               { "all_inf_rocketeer_snow" }, 
              engineer =               { "all_inf_engineer_snow" }, 
              sniper =               { "all_inf_sniper_snow" }, 
              officer =               { "all_inf_officer_snow" }, 
              special =               { "all_inf_wookiee_snow" }
             }, 
            imp =             { team = IMP, units = 20, reinforcements = -1, 
              soldier =               { "imp_inf_rifleman_snow" }, 
              assault =               { "imp_inf_rocketeer_snow" }, 
              engineer =               { "imp_inf_engineer" }, 
              sniper =               { "imp_inf_sniper_snow" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_darthvader")
    SetHeroClass(ALL,"all_hero_luke_pilot")
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker",0)
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    SetMemoryPoolSize("Aimer",38)
    SetMemoryPoolSize("AmmoCounter",181)
    SetMemoryPoolSize("BaseHint",148)
    SetMemoryPoolSize("EnergyBar",181)
    SetMemoryPoolSize("EntityCloth",44)
    SetMemoryPoolSize("EntityLight",226)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("EntitySoundStatic",13)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("MountedTurret",26)
    SetMemoryPoolSize("Navigator",40)
    SetMemoryPoolSize("Obstacle",337)
    SetMemoryPoolSize("OrdnanceTowCable",4)
    SetMemoryPoolSize("PathNode",180)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("UnitAgent",40)
    SetMemoryPoolSize("UnitController",40)
    SetMemoryPoolSize("Weapon",181)
    ReadDataFile("HOT\\hot1.lvl","hoth_ctf")
    SetSpawnDelay(15,0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_hot_amb_start",0,1)
    SetAmbientMusic(IMP,1,"imp_hot_amb_start",0,1)
    SetVictoryMusic(ALL,"all_hot_amb_victory")
    SetDefeatMusic(ALL,"all_hot_amb_defeat")
    SetVictoryMusic(IMP,"imp_hot_amb_victory")
    SetDefeatMusic(IMP,"imp_hot_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(0.94420999288559,0.065540999174118,0.3219830095768,-0.022350000217557,-500.48983764648,0.79747200012207,-68.773849487305)
    AddCameraShot(0.37119698524475,0.0081900004297495,-0.92829197645187,0.020481999963522,-473.38415527344,-17.880533218384,132.12680053711)
    AddCameraShot(0.92708301544189,0.020455999299884,-0.37420600652695,0.0082569997757673,-333.22155761719,0.67604297399521,-14.027347564697)
end

