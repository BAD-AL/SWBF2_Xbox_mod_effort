--Extracted\uta1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
local local_2 = 1
local local_3 = 2

function ScriptPostLoad()
    EnableSPHeroRules()
    cp1 = CommandPost:New({ name = "CON_CP1" })
    cp2 = CommandPost:New({ name = "con_CP1a" })
    cp3 = CommandPost:New({ name = "CON_CP2" })
    cp4 = CommandPost:New({ name = "CON_CP5" })
    cp5 = CommandPost:New({ name = "CON_CP6" })
    cp6 = CommandPost:New({ name = "CON_CP7" })
    conquest = ObjectiveConquest:New({ teamATT = local_2, teamDEF = local_3, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    DisableBarriers("Barrier445")
end
local local_1 = 2
local local_0 = 1

function ScriptInit()
    StealArtistHeap(128 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(4620881)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(4880000)
end
    ReadDataFile("ingame.lvl")
    SetTeamAggressiveness(local_1,0.94999998807907)
    SetTeamAggressiveness(local_0,0.94999998807907)
    ReadDataFile("sound\\uta.lvl;uta1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_inf_ep3_jettrooper","rep_hero_obiwan","rep_walk_oneman_atst")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_officer","cis_inf_droideka","cis_hero_grievous","cis_hover_aat")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = local_1, units = 10, reinforcements = 200, 
              soldier =               { "rep_inf_ep3_rifleman", 4 }, 
              assault =               { "rep_inf_ep3_rocketeer", 2 }, 
              engineer =               { "rep_inf_ep3_engineer", 1 }, 
              sniper =               { "rep_inf_ep3_sniper", 1 }, 
              officer =               { "rep_inf_ep3_officer", 1 }, 
              special =               { "rep_inf_ep3_jettrooper", 1 }
             }, 
            cis =             { team = local_0, units = 10, reinforcements = 200, 
              soldier =               { "cis_inf_rifleman", 4 }, 
              assault =               { "cis_inf_rocketeer", 4 }, 
              engineer =               { "cis_inf_engineer", 4 }, 
              sniper =               { "cis_inf_sniper", 4 }, 
              officer =               { "cis_inf_officer", 1 }, 
              special =               { "cis_inf_droideka", 4 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = local_1, units = 20, reinforcements = 200, 
              soldier =               { "rep_inf_ep3_rifleman", 8 }, 
              assault =               { "rep_inf_ep3_rocketeer", 3 }, 
              engineer =               { "rep_inf_ep3_engineer", 4 }, 
              sniper =               { "rep_inf_ep3_sniper", 2 }, 
              officer =               { "rep_inf_ep3_officer", 1 }, 
              special =               { "rep_inf_ep3_jettrooper", 2 }
             }, 
            cis =             { team = local_0, units = 20, reinforcements = 200, 
              soldier =               { "cis_inf_rifleman", 8 }, 
              assault =               { "cis_inf_rocketeer", 3 }, 
              engineer =               { "cis_inf_engineer", 4 }, 
              sniper =               { "cis_inf_sniper", 2 }, 
              officer =               { "cis_inf_officer", 1 }, 
              special =               { "cis_inf_droideka", 2 }
             }
           })
end
    SetHeroClass(local_1,"rep_hero_obiwan")
    SetHeroClass(local_0,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,2)
    AddWalkerType(1,5)
    SetMemoryPoolSize("Aimer",36)
    SetMemoryPoolSize("AmmoCounter",220)
    SetMemoryPoolSize("BaseHint",200)
    SetMemoryPoolSize("Combo::DamageSample",610)
    SetMemoryPoolSize("EnergyBar",220)
    SetMemoryPoolSize("EntityHover",6)
    SetMemoryPoolSize("EntityLight",60)
    SetMemoryPoolSize("EntityFlyer",8)
    SetMemoryPoolSize("EntitySoundStream",8)
    SetMemoryPoolSize("EntitySoundStatic",0)
    SetMemoryPoolSize("MountedTurret",2)
    SetMemoryPoolSize("Navigator",40)
    SetMemoryPoolSize("Obstacle",400)
    SetMemoryPoolSize("PathFollower",40)
    SetMemoryPoolSize("PathNode",150)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",225)
    SetMemoryPoolSize("UnitAgent",40)
    SetMemoryPoolSize("UnitController",40)
    SetMemoryPoolSize("Weapon",220)
    SetSpawnDelay(10,0.25)
    ReadDataFile("uta\\uta1.lvl","uta1_Conquest")
    AddDeathRegion("deathregion")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(29.5)
    SetMaxPlayerFlyHeight(29.5)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(local_1,1,"rep_uta_amb_start",0,1)
    SetAmbientMusic(local_1,0.80000001192093,"rep_uta_amb_middle",1,1)
    SetAmbientMusic(local_1,0.20000000298023,"rep_uta_amb_end",2,1)
    SetAmbientMusic(local_0,1,"cis_uta_amb_start",0,1)
    SetAmbientMusic(local_0,0.80000001192093,"cis_uta_amb_middle",1,1)
    SetAmbientMusic(local_0,0.20000000298023,"cis_uta_amb_end",2,1)
    SetVictoryMusic(local_1,"rep_uta_amb_victory")
    SetDefeatMusic(local_1,"rep_uta_amb_defeat")
    SetVictoryMusic(local_0,"cis_uta_amb_victory")
    SetDefeatMusic(local_0,"cis_uta_amb_defeat")
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

