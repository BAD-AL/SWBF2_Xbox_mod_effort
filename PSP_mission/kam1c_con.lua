--Extracted\kam1c_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
local local_2 = 1
local local_3 = 2

function ScriptPostLoad()
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("camp")
    UnblockPlanningGraphArcs("connection71")
    SetProperty("cp1","Team","1")
    SetProperty("cp2","Team","2")
    SetProperty("cp3","Team","2")
    SetProperty("cp4","Team","2")
    SetProperty("cp5","Team","1")
    SetProperty("cp6","Team","1")
    SetAIDamageThreshold("Comp1",0)
    SetAIDamageThreshold("Comp2",0)
    SetAIDamageThreshold("Comp3",0)
    SetAIDamageThreshold("Comp4",0)
    SetAIDamageThreshold("Comp5",0)
    SetAIDamageThreshold("Comp6",0)
    SetAIDamageThreshold("Comp7",0)
    SetAIDamageThreshold("Comp8",0)
    SetAIDamageThreshold("Comp9",0)
    SetAIDamageThreshold("Comp10",0)
    SetProperty("Kam_Bldg_Podroom_Door32","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door33","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door32","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door34","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door35","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door27","Islocked",0)
    SetProperty("Kam_Bldg_Podroom_Door28","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door36","Islocked",1)
    SetProperty("Kam_Bldg_Podroom_Door20","Islocked",0)
    UnblockPlanningGraphArcs("connection71")
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("open")
    UnblockPlanningGraphArcs("connection194")
    UnblockPlanningGraphArcs("connection200")
    UnblockPlanningGraphArcs("connection118")
    DisableBarriers("FRONTDOOR2-3")
    DisableBarriers("FRONTDOOR2-1")
    DisableBarriers("FRONTDOOR2-2")
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
    DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")
    DisableBarriers("FRONTDOOR1-2")
    cp1 = CommandPost:New({ name = "cp1" })
    cp2 = CommandPost:New({ name = "cp2" })
    cp3 = CommandPost:New({ name = "cp3" })
    cp4 = CommandPost:New({ name = "cp4" })
    cp5 = CommandPost:New({ name = "cp5" })
    cp6 = CommandPost:New({ name = "cp6" })
    conquest = ObjectiveConquest:New({ teamATT = local_2, teamDEF = local_3, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:Start()
    EnableSPHeroRules()
    SetProperty("cp2","spawnpath","cp2_spawn")
    SetProperty("cp2","captureregion","cp2_capture")
    BlockPlanningGraphArcs("group1")
    BlockPlanningGraphArcs("connection165")
    BlockPlanningGraphArcs("connection162")
    BlockPlanningGraphArcs("connection160")
    BlockPlanningGraphArcs("connection225")
end
local local_0 = 2
local local_1 = 1

function ScriptInit()
    StealArtistHeap(40 * 1024)
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3000000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\kam.lvl;kam1cw")
    ReadDataFile("SIDE\\rep.lvl","rep_inf_ep3_rifleman","rep_inf_ep3_rocketeer","rep_inf_ep3_engineer","rep_inf_ep3_sniper","rep_inf_ep3_jettrooper","rep_inf_ep3_officer","rep_hero_obiwan")
    ReadDataFile("SIDE\\cis.lvl","cis_inf_rifleman","cis_inf_rocketeer","cis_inf_engineer","cis_inf_sniper","cis_inf_droideka","CIS_inf_officer","cis_hero_jangofett")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_chaingun_roof","tur_weap_built_gunturret")
    SetAttackingTeam(local_2)
    SetupTeams({ 
        rep =         { team = local_0, units = 20, reinforcements = 150, 
          soldier =           { "rep_inf_ep3_rifleman", 9, 16 }, 
          assault =           { "rep_inf_ep3_rocketeer", 1, 4 }, 
          engineer =           { "rep_inf_ep3_engineer", 1, 4 }, 
          sniper =           { "rep_inf_ep3_sniper", 1, 4 }, 
          officer =           { "rep_inf_ep3_officer", 1, 4 }, 
          special =           { "rep_inf_ep3_jettrooper", 1, 4 }
         }, 
        cis =         { team = local_1, units = 20, reinforcements = 150, 
          soldier =           { "CIS_inf_rifleman", 9, 16 }, 
          assault =           { "CIS_inf_rocketeer", 1, 4 }, 
          engineer =           { "CIS_inf_engineer", 1, 4 }, 
          sniper =           { "CIS_inf_sniper", 1, 4 }, 
          officer =           { "CIS_inf_officer", 1, 4 }, 
          special =           { "cis_inf_droideka", 1, 4 }
         }
       })
    SetHeroClass(local_0,"rep_hero_obiwan")
    SetHeroClass(local_1,"cis_hero_jangofett")
    ClearWalkers()
    AddWalkerType(0,12)
    SetMemoryPoolSize("Aimer",39)
    SetMemoryPoolSize("AmmoCounter",215)
    SetMemoryPoolSize("BaseHint",210)
    SetMemoryPoolSize("EnergyBar",215)
    SetMemoryPoolSize("EntityCloth",18)
    SetMemoryPoolSize("EntityLight",70)
    SetMemoryPoolSize("EntitySoundStream",3)
    SetMemoryPoolSize("EntitySoundStatic",80)
    SetMemoryPoolSize("MountedTurret",22)
    SetMemoryPoolSize("Navigator",50)
    SetMemoryPoolSize("Obstacle",800)
    SetMemoryPoolSize("PathFollower",50)
    SetMemoryPoolSize("PathNode",256)
    SetMemoryPoolSize("SoundSpaceRegion",36)
    SetMemoryPoolSize("TentacleSimulator",0)
    SetMemoryPoolSize("TreeGridStack",338)
    SetMemoryPoolSize("UnitAgent",50)
    SetMemoryPoolSize("EntityFlyer",6)
    SetMemoryPoolSize("UnitController",50)
    SetMemoryPoolSize("Weapon",215)
    SetSpawnDelay(10,0.25)
    ReadDataFile("kam\\kam1.lvl","kamino1_conquest")
    SetDenseEnvironment("false")
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
    SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
    OpenAudioStream("sound\\global.lvl","cw_music")
    SetBleedingVoiceOver(local_0,local_0,"rep_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(local_0,local_1,"rep_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(local_1,local_0,"cis_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(local_1,local_1,"cis_off_com_report_us_overwhelmed",1)
    SetLowReinforcementsVoiceOver(local_0,local_0,"rep_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(local_0,local_1,"rep_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(local_1,local_0,"cis_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(local_1,local_1,"cis_off_victory_im",0.10000000149012,1)
    SetAmbientMusic(local_0,1,"rep_kam_amb_start",0,1)
    SetAmbientMusic(local_0,0.99000000953674,"rep_kam_amb_middle",1,1)
    SetAmbientMusic(local_0,0.10000000149012,"rep_kam_amb_end",2,1)
    SetAmbientMusic(local_1,1,"cis_kam_amb_start",0,1)
    SetAmbientMusic(local_1,0.99000000953674,"cis_kam_amb_middle",1,1)
    SetAmbientMusic(local_1,0.10000000149012,"cis_kam_amb_end",2,1)
    SetVictoryMusic(local_0,"rep_kam_amb_victory")
    SetDefeatMusic(local_0,"rep_kam_amb_defeat")
    SetVictoryMusic(local_1,"cis_kam_amb_victory")
    SetDefeatMusic(local_1,"cis_kam_amb_defeat")
    SetOutOfBoundsVoiceOver(2,"repleaving")
    SetOutOfBoundsVoiceOver(1,"cisleaving")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(local_2)
    AddDeathRegion("deathregion")
    AddCameraShot(0.19047799706459,-0.010944999754429,-0.98001402616501,-0.056311998516321,-26.091287612915,55.96501159668,159.45809936523)
end

