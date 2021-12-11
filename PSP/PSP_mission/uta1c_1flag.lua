--Extracted\uta1c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = REP
DEF = CIS

function ScriptPostLoad()
    SoundEvent_SetupTeams(CIS,"cis",REP,"rep")
    ctf = ObjectiveOneFlagCTF:New({ teamATT = 1, teamDEF = 2, textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", captureLimit = 5, flag = "flag", flagIcon = "flag_icon", flagIconScale = 3, homeRegion = "flag_home", captureRegionATT = "Flag_capture1", captureRegionDEF = "Flag_capture2", capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle", capRegionMarkerScaleATT = 3, capRegionMarkerScaleDEF = 3, multiplayerRules = true, hideCPs = true })
    ctf:Start()
    EnableSPHeroRules()
    DisableBarriers("Barrier445")
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4128721)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4880000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\uta.lvl;uta1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_officer","cis_inf_droideka","cis_hero_grievous")
    SetupTeams({ 
        rep =         { team = REP, units = 20, reinforcements = -1, 
          soldier =           { "rep_inf_ep3_rifleman", 9, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }, 
        cis =         { team = CIS, units = 20, reinforcements = -1, 
          soldier =           { "cis_inf_rifleman", 9, 16 }, 
          assault =           { "cis_inf_rocketeer", 1, 4 }, 
          engineer =           { "cis_inf_engineer", 1, 4 }, 
          sniper =           { "cis_inf_sniper", 1, 4 }, 
          officer =           { "cis_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(REP,"rep_hero_obiwan")
    SetHeroClass(CIS,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,2)
    AddWalkerType(1,0)
    SetMemoryPoolSize("Aimer",5)
    SetMemoryPoolSize("AmmoCounter",150)
    SetMemoryPoolSize("BaseHint",200)
    SetMemoryPoolSize("Combo::DamageSample",610)
    SetMemoryPoolSize("EnergyBar",150)
    SetMemoryPoolSize("EntityLight",80)
    SetMemoryPoolSize("EntityFlyer",8)
    SetMemoryPoolSize("EntitySoundStream",8)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",40)
    SetMemoryPoolSize("Obstacle",400)
    SetMemoryPoolSize("PathFollower",40)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("TreeGridStack",256)
    SetMemoryPoolSize("UnitAgent",40)
    SetMemoryPoolSize("UnitController",40)
    SetMemoryPoolSize("Weapon",150)
    AddUnitClass(4,"rep_inf_ep3_rifleman",1)
    SetUnitCount(4,1)
    SetSpawnDelay(10,0.25)
    ReadDataFile("uta\\uta1.lvl","uta1_1flag")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_uta_amb_start",0,1)
    SetAmbientMusic(CIS,1,"cis_uta_amb_start",0,1)
    SetVictoryMusic(REP,"rep_uta_amb_victory")
    SetDefeatMusic(REP,"rep_uta_amb_defeat")
    SetVictoryMusic(CIS,"cis_uta_amb_victory")
    SetDefeatMusic(CIS,"cis_uta_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(-0.42809098958969,0.045648999512196,-0.89749401807785,-0.09570299834013,162.71495056152,45.857063293457,40.647117614746)
    AddCameraShot(-0.19486099481583,-0.0015999999595806,-0.98079597949982,0.0080549996346235,-126.17978668213,16.113788604736,70.012893676758)
    AddCameraShot(-0.46254798769951,-0.020921999588609,-0.88544201850891,0.040049999952316,-16.947637557983,4.5617961883545,156.92695617676)
    AddCameraShot(0.99531000852585,0.0245820004493,-0.093534998595715,0.0023099998943508,38.288612365723,4.5617961883545,243.29850769043)
    AddCameraShot(0.82706999778748,0.017092999070883,0.56171900033951,-0.01160900015384,-24.457637786865,8.8341455459595,296.54458618164)
    AddCameraShot(0.99887502193451,0.0049120001494884,-0.047173999249935,0.00023200000578072,-45.868236541748,2.9782149791718,216.21788024902)
end

