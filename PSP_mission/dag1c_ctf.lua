--Extracted\dag1c_ctf.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")
REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetProperty("ctf_flag1","GeometryName","com_icon_republic_flag")
    SetProperty("ctf_flag1","CarriedGeometryName","com_icon_republic_flag_carried")
    SetProperty("ctf_flag2","GeometryName","com_icon_cis_flag")
    SetProperty("ctf_flag2","CarriedGeometryName","com_icon_cis_flag_carried")
    SetProperty("flag2_effect","Team",2)
    SetProperty("flag1_effect","Team",1)
    ctf = ObjectiveCTF:New({ teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true })
    ctf:AddFlag({ name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    ctf:AddFlag({ name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home", capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3, icon = "", mapIcon = "flag_icon", mapIconScale = 3 })
    SoundEvent_SetupTeams(1,"rep",2,"cis")
    ctf:Start()
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(256 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(2852881)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(2497152 + 65536 * 0)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\dag.lvl;dag1cw")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_officer","cis_inf_sniper","cis_inf_droideka","cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,3)
    SetMemoryPoolSize("Aimer",9)
    SetMemoryPoolSize("AmmoCounter",130)
    SetMemoryPoolSize("BaseHint",80)
    SetMemoryPoolSize("EnergyBar",130)
    SetMemoryPoolSize("EntityCloth",19)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("EntitySoundStream",1)
    SetMemoryPoolSize("EntitySoundStatic",1)
    SetMemoryPoolSize("FlagItem",2)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",157)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",512)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",130)
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman", 4 }, 
              assault =               { "rep_inf_ep3_rocketeer", 2 }, 
              engineer =               { "rep_inf_ep3_engineer", 1 }, 
              sniper =               { "rep_inf_ep3_sniper", 1 }, 
              officer =               { "rep_inf_ep3_officer", 1 }, 
              special =               { "rep_inf_ep3_jettrooper", 1 }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = -1, 
              soldier =               { "cis_inf_rifleman", 4 }, 
              assault =               { "cis_inf_rocketeer", 2 }, 
              engineer =               { "cis_inf_engineer", 1 }, 
              sniper =               { "cis_inf_sniper", 1 }, 
              officer =               { "cis_inf_officer", 1 }, 
              special =               { "cis_inf_droideka", 1 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 25, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman", 11 }, 
              assault =               { "rep_inf_ep3_rocketeer", 4 }, 
              engineer =               { "rep_inf_ep3_engineer", 3 }, 
              sniper =               { "rep_inf_ep3_sniper", 2 }, 
              officer =               { "rep_inf_ep3_officer", 2 }, 
              special =               { "rep_inf_ep3_jettrooper", 3 }
             }, 
            cis =             { team = CIS, units = 25, reinforcements = -1, 
              soldier =               { "cis_inf_rifleman", 11 }, 
              assault =               { "cis_inf_rocketeer", 4 }, 
              engineer =               { "cis_inf_engineer", 3 }, 
              sniper =               { "cis_inf_sniper", 2 }, 
              officer =               { "cis_inf_officer", 2 }, 
              special =               { "cis_inf_droideka", 3 }
             }
           })
end
    SetHeroClass(REP,"rep_hero_yoda")
    SetHeroClass(CIS,"cis_hero_grievous")
    SetUnitCount(ATT,25)
    SetReinforcementCount(ATT,-1)
    SetUnitCount(DEF,25)
    SetReinforcementCount(DEF,-1)
    SetSpawnDelay(10,0.25)
    ReadDataFile("dag\\dag1.lvl","dag1_ctf","dag1_cw")
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.34999999403954)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_dag_amb_start",0,1)
    SetAmbientMusic(CIS,1,"cis_dag_amb_start",0,1)
    SetVictoryMusic(REP,"rep_dag_amb_victory")
    SetDefeatMusic(REP,"rep_dag_amb_defeat")
    SetVictoryMusic(CIS,"cis_dag_amb_victory")
    SetDefeatMusic(CIS,"cis_dag_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    AddCameraShot(-0.40489500761032,0.0009919999865815,-0.91435998678207,-0.0022400000598282,-85.539894104004,20.536296844482,141.6994934082)
    AddCameraShot(0.040922001004219,0.004048999864608,-0.99429899454117,0.098380997776985,-139.72952270508,17.546598434448,-34.360893249512)
    AddCameraShot(-0.31235998868942,0.016223000362515,-0.94854700565338,-0.049263000488281,-217.38148498535,20.150953292847,54.514324188232)
end

