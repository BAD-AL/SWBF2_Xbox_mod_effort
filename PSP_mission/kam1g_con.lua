--Extracted\kam1g_con.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ALL = 1
IMP = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    SetProperty("cp1","Team","1")
    SetProperty("cp2","Team","2")
    SetProperty("cp3","Team","2")
    SetProperty("cp4","Team","2")
    SetProperty("cp5","Team","1")
    SetProperty("cp6","Team","1")
    DisableBarriers("camp")
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
    conquest = ObjectiveConquest:New({ teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true })
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
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(5.4000000953674 * 1024 * 1024)
else
        SetPS2ModelMemory(3600000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\kam.lvl;kam1gcw")
    ReadDataFile("SIDE\\all.lvl","all_inf_rifleman_urban","all_inf_rocketeer_fleet","all_inf_sniper_fleet","all_inf_engineer_fleet","all_hero_hansolo_tat","all_inf_wookiee","all_inf_officer")
    ReadDataFile("SIDE\\imp.lvl","imp_inf_rifleman","imp_inf_rocketeer","imp_inf_engineer","imp_inf_sniper","imp_inf_officer","imp_inf_dark_trooper","imp_hero_bobafett")
    ReadDataFile("SIDE\\tur.lvl","tur_bldg_chaingun_roof","tur_weap_built_gunturret")
    ClearWalkers()
    SetMemoryPoolSize("EntityCloth",33)
    SetMemoryPoolSize("EntityLight",64)
    SetMemoryPoolSize("Obstacle",800)
    SetMemoryPoolSize("EntitySoundStream",3)
    SetMemoryPoolSize("SoundSpaceRegion",36)
    SetMemoryPoolSize("EntitySoundStatic",80)
    SetMemoryPoolSize("Weapon",260)
    SetupTeams({ 
        all =         { team = ALL, units = 20, reinforcements = 150, 
          soldier =           { "all_inf_rifleman_urban", 9, 16 }, 
          assault =           { "all_inf_rocketeer_fleet", 1, 4 }, 
          engineer =           { "all_inf_engineer_fleet", 1, 4 }, 
          sniper =           { "all_inf_sniper_fleet", 1, 4 }, 
          officer =           { "all_inf_officer", 1, 4 }, 
          special =           { "all_inf_wookiee", 1, 4 }
         }
       })
    SetupTeams({ 
        imp =         { team = IMP, units = 20, reinforcements = 150, 
          soldier =           { "imp_inf_rifleman", 9, 16 }, 
          assault =           { "imp_inf_rocketeer", 1, 4 }, 
          engineer =           { "imp_inf_engineer", 1, 4 }, 
          sniper =           { "imp_inf_sniper", 1, 4 }, 
          officer =           { "imp_inf_officer", 1, 4 }, 
          special =           { "imp_inf_dark_trooper", 1, 4 }
         }
       })
    SetHeroClass(ALL,"all_hero_hansolo_tat")
    SetHeroClass(IMP,"imp_hero_bobafett")
    SetSpawnDelay(10,0.25)
    ReadDataFile("KAM\\kam1.lvl","kamino1_conquest")
    SetMemoryPoolSize("EntityFlyer",6)
    SetDenseEnvironment("false")
    SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
    SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetBleedingVoiceOver(ALL,ALL,"all_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(ALL,IMP,"all_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(IMP,ALL,"imp_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(IMP,IMP,"imp_off_com_report_us_overwhelmed",1)
    SetLowReinforcementsVoiceOver(ALL,ALL,"all_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(ALL,IMP,"all_off_victory_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(IMP,IMP,"imp_off_defeat_im",0.10000000149012,1)
    SetLowReinforcementsVoiceOver(IMP,ALL,"imp_off_victory_im",0.10000000149012,1)
    SetOutOfBoundsVoiceOver(1,"allleaving")
    SetOutOfBoundsVoiceOver(2,"impleaving")
    SetAmbientMusic(ALL,1,"all_mus_amb_start",0,1)
    SetAmbientMusic(ALL,0.89999997615814,"all_mus_amb_middle",1,1)
    SetAmbientMusic(ALL,0.10000000149012,"all_mus_amb_end",2,1)
    SetAmbientMusic(IMP,1,"imp_mus_amb_start",0,1)
    SetAmbientMusic(IMP,0.89999997615814,"imp_mus_amb_middle",1,1)
    SetAmbientMusic(IMP,0.10000000149012,"imp_mus_amb_end",2,1)
    SetVictoryMusic(ALL,"all_mus_amb_victory")
    SetDefeatMusic(ALL,"all_mus_amb_defeat")
    SetVictoryMusic(IMP,"imp_mus_amb_victory")
    SetDefeatMusic(IMP,"imp_mus_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddDeathRegion("deathregion")
    AddCameraShot(0.19047799706459,-0.010944999754429,-0.98001402616501,-0.056311998516321,-26.091287612915,55.96501159668,159.45809936523)
end

