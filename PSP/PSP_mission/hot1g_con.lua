--Extracted\hot1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ALL = 2
IMP = 1
ATT = 1
DEF = 2

function ScriptPostLoad()
    AddDeathRegion("fall")
    SetObjectTeam("CP3",1)
    SetObjectTeam("CP6",1)
    KillObject("CP7")
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CP3" })
    cp2 = CommandPost:New({ name = "CP4" })
    cp3 = CommandPost:New({ name = "CP5" })
    cp4 = CommandPost:New({ name = "CP6" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:Start()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PS2" then
end
    StealArtistHeap(1024 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(3306257)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(3300000)
end
    ReadDataFile("ingame.lvl")
    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1)
    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl","all_fly_snowspeeder","all_inf_rifleman_snow","all_inf_rocketeer_snow","all_inf_engineer_snow","all_inf_sniper_snow","all_inf_officer_snow","all_hero_luke_pilot","all_inf_wookiee_snow","all_walk_tauntaun")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman_snow","imp_inf_rocketeer_snow","imp_inf_sniper_snow","imp_inf_dark_trooper","imp_inf_engineer_snow","imp_inf_officer","imp_hero_darthvader","imp_walk_atat","imp_walk_atst_snow")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_hoth_dishturret","tur_bldg_hoth_lasermortar")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            all =             { team = ALL, units = 10, reinforcements = 75, 
              soldier =               { "all_inf_rifleman_snow" }, 
              assault =               { "all_inf_rocketeer_snow" }, 
              engineer =               { "all_inf_engineer_snow" }, 
              sniper =               { "all_inf_sniper_snow" }, 
              officer =               { "all_inf_officer_snow" }, 
              special =               { "all_inf_wookiee_snow" }
             }, 
            imp =             { team = IMP, units = 10, reinforcements = 75, 
              soldier =               { "imp_inf_rifleman_snow" }, 
              assault =               { "imp_inf_rocketeer_snow" }, 
              engineer =               { "imp_inf_engineer_snow" }, 
              sniper =               { "imp_inf_sniper_snow" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
else
        SetupTeams({ 
            all =             { team = ALL, units = 20, reinforcements = 160, 
              soldier =               { "all_inf_rifleman_snow" }, 
              assault =               { "all_inf_rocketeer_snow" }, 
              engineer =               { "all_inf_engineer_snow" }, 
              sniper =               { "all_inf_sniper_snow" }, 
              officer =               { "all_inf_officer_snow" }, 
              special =               { "all_inf_wookiee_snow" }
             }, 
            imp =             { team = IMP, units = 20, reinforcements = 160, 
              soldier =               { "imp_inf_rifleman_snow" }, 
              assault =               { "imp_inf_rocketeer_snow" }, 
              engineer =               { "imp_inf_engineer_snow" }, 
              sniper =               { "imp_inf_sniper_snow" }, 
              officer =               { "imp_inf_officer" }, 
              special =               { "imp_inf_dark_trooper" }
             }
           })
end
    SetHeroClass(IMP,"imp_hero_darthvader")
    SetHeroClass(ALL,"all_hero_luke_pilot")
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,5)
    AddWalkerType(2,2)
    SetMemoryPoolSize("Aimer",80)
    SetMemoryPoolSize("AmmoCounter",221)
    SetMemoryPoolSize("BaseHint",175)
    SetMemoryPoolSize("CommandWalker",2)
    SetMemoryPoolSize("ConnectivityGraphFollower",56)
    SetMemoryPoolSize("EnergyBar",221)
    SetMemoryPoolSize("EntityCloth",41)
    SetMemoryPoolSize("EntityFlyer",10)
    SetMemoryPoolSize("EntityLight",100)
    SetMemoryPoolSize("EntitySoundStatic",16)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix",54)
    SetMemoryPoolSize("MountedTurret",30)
    SetMemoryPoolSize("Navigator",63)
    SetMemoryPoolSize("Obstacle",375)
    SetMemoryPoolSize("OrdnanceTowCable",4)
    SetMemoryPoolSize("PathFollower",63)
    SetMemoryPoolSize("PathNode",128)
    SetMemoryPoolSize("ShieldEffect",0)
    SetMemoryPoolSize("TentacleSimulator",8)
    SetMemoryPoolSize("TreeGridStack",300)
    SetMemoryPoolSize("UnitController",63)
    SetMemoryPoolSize("UnitAgent",63)
    SetMemoryPoolSize("Weapon",221)
    ReadDataFile("HOT\\hot1.lvl","hoth_conquest")
    SetSpawnDelay(10,0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_hot_amb_start",0,1)
    SetAmbientMusic(ALL,0.80000001192093,"all_hot_amb_middle",1,1)
    SetAmbientMusic(ALL,0.20000000298023,"all_hot_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_hot_amb_start",0,1)
    SetAmbientMusic(IMP,0.80000001192093,"imp_hot_amb_middle",1,1)
    SetAmbientMusic(IMP,0.20000000298023,"imp_hot_amb_end",2,1)
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

