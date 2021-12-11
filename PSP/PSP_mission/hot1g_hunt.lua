--Extracted\hot1g_hunt.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")
ALL = 2
IMP = 1
ATT = 1
DEF = 2

function ScriptPostLoad()
    AddDeathRegion("fall")
    DisableBarriers("conquestbar")
    KillObject("CP7OBJ")
    KillObject("shieldgen")
    KillObject("CP7OBJ")
    KillObject("hangarcp")
    KillObject("enemyspawn")
    KillObject("enemyspawn2")
    KillObject("echoback2")
    KillObject("echoback1")
    KillObject("shield")
    hunt = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 3, textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true })
    hunt:Start()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PS2" then
end
    StealArtistHeap(1024 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2525713)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(3300000)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1)
    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl","all_fly_snowspeeder","all_inf_rifleman_snow","all_inf_rocketeer_snow","all_inf_engineer_snow","all_inf_sniper_snow","all_inf_officer_snow","all_inf_wookiee_snow","all_walk_tauntaun")
    ReadDataFile("SIDE\\snw.lvl","snw_inf_wampa")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_hoth_dishturret","tur_bldg_hoth_lasermortar","tur_bldg_chaingun_tripod","tur_bldg_chaingun_roof")
    SetupTeams({ 
        all =         { team = ALL, units = 20, reinforcements = -1, 
          soldier =           { "all_inf_rifleman_snow" }, 
          assault =           { "all_inf_rocketeer_snow" }, 
          engineer =           { "all_inf_engineer_snow" }, 
          sniper =           { "all_inf_sniper_snow" }, 
          officer =           { "all_inf_officer_snow" }, 
          special =           { "all_inf_wookiee_snow" }
         }, 
        wampa =         { team = IMP, units = 8, reinforcements = -1, 
          soldier =           { "snw_inf_wampa", 8 }
         }
       })
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker",-2)
    AddWalkerType(0,0)
    AddWalkerType(1,5)
    AddWalkerType(2,2)
    SetMemoryPoolSize("Aimer",90)
    SetMemoryPoolSize("AmmoCounter",269)
    SetMemoryPoolSize("BaseHint",250)
    SetMemoryPoolSize("CommandWalker",2)
    SetMemoryPoolSize("ConnectivityGraphFollower",56)
    SetMemoryPoolSize("EnergyBar",269)
    SetMemoryPoolSize("EntityCloth",28)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntityLight",218)
    SetMemoryPoolSize("EntitySoundStatic",16)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",54)
    SetMemoryPoolSize("MountedTurret",46)
    SetMemoryPoolSize("Navigator",63)
    SetMemoryPoolSize("Obstacle",360)
    SetMemoryPoolSize("OrdnanceTowCable",4)
    SetMemoryPoolSize("PathFollower",63)
    SetMemoryPoolSize("PathNode",268)
    SetMemoryPoolSize("RedOmniLight",223)
    SetMemoryPoolSize("TreeGridStack",329)
    SetMemoryPoolSize("UnitController",63)
    SetMemoryPoolSize("UnitAgent",63)
    SetMemoryPoolSize("Weapon",269)
    ReadDataFile("HOT\\hot1.lvl","hoth_hunt")
    SetSpawnDelay(10,0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetBleedingVoiceOver(ALL,ALL,"all_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(ALL,IMP,"all_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(IMP,ALL,"imp_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(IMP,IMP,"imp_off_com_report_us_overwhelmed",1)
    SetLowReinforcementsVoiceOver(ALL,ALL,"all_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(ALL,IMP,"all_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(IMP,IMP,"imp_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(IMP,ALL,"imp_off_victory_im",0.10000000149012,1)
    SetOutOfBoundsVoiceOver(2,"Allleaving")
    SetOutOfBoundsVoiceOver(1,"Impleaving")
    SetAmbientMusic(ALL,1,"all_hot_amb_hunt",0,1)
    SetAmbientMusic(IMP,1,"imp_hot_amb_hunt",0,1)
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

function OnStart(OnStartParam0)
    AddAIGoal(ATT,"Deathmatch",1000)
    AddAIGoal(DEF,"Deathmatch",1000)
end

