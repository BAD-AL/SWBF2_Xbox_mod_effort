--Extracted\tan1c_1flag.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ATT = 1
DEF = 2
REP = ATT
CIS = DEF

function ScriptPostLoad()
    SoundEvent_SetupTeams(CIS,"cis",REP,"rep")
    AddDeathRegion("turbinedeath")
    KillObject("blastdoor")
    DisableBarriers("barracks")
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
        SetPSPModelMemory(4832817)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(4800000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\tan.lvl;tan1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_jettrooper","rep_inf_ep3_sniper","rep_inf_ep3_officer","rep_hero_yoda")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_officer","cis_inf_droideka","cis_hero_grievous")
if ScriptCB_GetPlatform() == "PSP" then
        SetupTeams({ 
            rep =             { team = REP, units = 10, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }, 
            cis =             { team = CIS, units = 10, reinforcements = -1, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 1, 4 }
             }
           })
else
        SetupTeams({ 
            rep =             { team = REP, units = 18, reinforcements = -1, 
              soldier =               { "rep_inf_ep3_rifleman" }, 
              assault =               { "rep_inf_ep3_rocketeer" }, 
              engineer =               { "rep_inf_ep3_engineer" }, 
              sniper =               { "rep_inf_ep3_sniper" }, 
              officer =               { "rep_inf_ep3_officer" }, 
              special =               { "rep_inf_ep3_jettrooper" }
             }, 
            cis =             { team = CIS, units = 18, reinforcements = -1, 
              soldier =               { "cis_inf_rifleman" }, 
              assault =               { "cis_inf_rocketeer" }, 
              engineer =               { "cis_inf_engineer" }, 
              sniper =               { "cis_inf_sniper" }, 
              officer =               { "cis_inf_officer" }, 
              special =               { "cis_inf_droideka", 1, 4 }
             }
           })
end
    SetHeroClass(REP,"rep_hero_yoda")
    SetHeroClass(CIS,"cis_hero_grievous")
    ClearWalkers()
    AddWalkerType(0,5)
    SetMemoryPoolSize("FlagItem",1)
    SetMemoryPoolSize("Aimer",15)
    SetMemoryPoolSize("AmmoCounter",177)
    SetMemoryPoolSize("EnergyBar",177)
    SetMemoryPoolSize("EntityCloth",18)
    SetMemoryPoolSize("EntitySoundStream",14)
    SetMemoryPoolSize("EntitySoundStatic",28)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("MountedTurret",0)
    SetMemoryPoolSize("Navigator",32)
    SetMemoryPoolSize("Obstacle",300)
    SetMemoryPoolSize("PathFollower",32)
    SetMemoryPoolSize("PathNode",384)
    SetMemoryPoolSize("SoundspaceRegion",15)
    SetMemoryPoolSize("TreeGridStack",200)
    SetMemoryPoolSize("UnitAgent",32)
    SetMemoryPoolSize("UnitController",32)
    SetMemoryPoolSize("Weapon",177)
    SetSpawnDelay(10,0.25)
    ReadDataFile("tan\\tan1.lvl","tan1_1flag")
    SetDenseEnvironment("false")
    AISnipeSuitabilityDist(30)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetAmbientMusic(REP,1,"rep_tan_amb_start",0,1)
    SetAmbientMusic(CIS,1,"cis_tan_amb_start",0,1)
    SetVictoryMusic(REP,"rep_tan_amb_victory")
    SetDefeatMusic(REP,"rep_tan_amb_defeat")
    SetVictoryMusic(CIS,"cis_tan_amb_victory")
    SetDefeatMusic(CIS,"cis_tan_amb_defeat")
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

