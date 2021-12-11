--Extracted\tan1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
    AddDeathRegion("turbinedeath")
    KillObject("blastdoor")
    DisableBarriers("barracks")
    DisableBarriers("liea")
    SetMapNorthAngle(180)
    BlockPlanningGraphArcs("turbine")
    OnObjectKillName(destturbine,"turbineconsole")
    OnObjectRespawnName(returbine,"turbineconsole")
    cp4 = CommandPost:New({ name = "CP4CON" })
    cp5 = CommandPost:New({ name = "CP5CON" })
    cp6 = CommandPost:New({ name = "CP6CON" })
    cp7 = CommandPost:New({ name = "CP7CON" })
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:Start()
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
        SetPSPModelMemory(4832817)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4800000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\tan.lvl;tan1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_officer","cis_inf_sniper","cis_inf_engineer","cis_inf_droideka","cis_hero_grievous")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = 1, units = 10, reinforcements = 75, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }, 
            cis =             { team = 2, units = 10, reinforcements = 75, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_pilot" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka" }
             }
           })
else
        SetupTeams({ 
            rep =             { team = 1, units = 18, reinforcements = 150, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }, 
            cis =             { team = 2, units = 18, reinforcements = 150, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_pilot" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka" }
             }
           })
end
    SetHeroClass(1,"rep_hero_yoda")
    SetHeroClass(2,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,5)
    SetMemoryPoolSize("Aimer",17)
    SetMemoryPoolSize("AmmoCounter",177)
    SetMemoryPoolSize("BaseHint",250)
    SetMemoryPoolSize("EnergyBar",177)
    SetMemoryPoolSize("EntityCloth",18)
    SetMemoryPoolSize("EntitySoundStream",14)
    SetMemoryPoolSize("EntitySoundStatic",28)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("MountedTurret",2)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",250)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",384)
    SetMemoryPoolSize("SoundspaceRegion",15)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",150)
    SetMemoryPoolSize("UnitAgent",32)
    SetMemoryPoolSize("UnitController",32)
    SetMemoryPoolSize("Weapon",177)
    SetSpawnDelay(10,0.25)
    ReadDataFile("tan\\tan1.lvl","tan1_conquest")
    SetDenseEnvironment("false")
    AISnipeSuitabilityDist(30)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(1,1,"rep_tan_amb_start",0,1)
    SetAmbientMusic(1,0.80000001192093,"rep_tan_amb_middle",1,1)
    SetAmbientMusic(1,0.20000000298023,"rep_tan_amb_end",2,1)
    SetAmbientMusic(2,1,"cis_tan_amb_start",0,1)
    SetAmbientMusic(2,0.80000001192093,"cis_tan_amb_middle",1,1)
    SetAmbientMusic(2,0.20000000298023,"cis_tan_amb_end",2,1)
    SetVictoryMusic(1,"rep_tan_amb_victory")
    SetDefeatMusic(1,"rep_tan_amb_defeat")
    SetVictoryMusic(2,"cis_tan_amb_victory")
    SetDefeatMusic(2,"cis_tan_amb_defeat")
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

