    --
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
    
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

  --  Empire Attacking (attacker is always #1)
ALL = 1;
IMP = 2;
     --  These variables do not change
ATT = 1;
DEF = 2;

 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
 function ScriptPostLoad()
    SetProperty("cp1", "Team", "1")
    SetProperty("cp2", "Team", "2")
    SetProperty("cp3", "Team", "2")
    SetProperty("cp4", "Team", "2")
    SetProperty("cp5", "Team", "1")
    SetProperty("cp6", "Team", "1")
    DisableBarriers("camp")
    SetAIDamageThreshold("Comp1", 0 )
    SetAIDamageThreshold("Comp2", 0 )
    SetAIDamageThreshold("Comp3", 0 )
    SetAIDamageThreshold("Comp4", 0 )
    SetAIDamageThreshold("Comp5", 0 )
    SetAIDamageThreshold("Comp6", 0 )
    SetAIDamageThreshold("Comp7", 0 )
    SetAIDamageThreshold("Comp8", 0 )
    SetAIDamageThreshold("Comp9", 0 )
    SetAIDamageThreshold("Comp10", 0 )

        SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)

    SetProperty("Kam_Bldg_Podroom_Door33", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door32", "Islocked", 1)
                SetProperty("Kam_Bldg_Podroom_Door34", "Islocked", 1)
    SetProperty("Kam_Bldg_Podroom_Door35", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door27", "Islocked", 0)       
            SetProperty("Kam_Bldg_Podroom_Door28", "Islocked", 1)       
    SetProperty("Kam_Bldg_Podroom_Door36", "Islocked", 1)
        SetProperty("Kam_Bldg_Podroom_Door20", "Islocked", 0)
    UnblockPlanningGraphArcs("connection71")
      
    --Objective1
    UnblockPlanningGraphArcs("connection85")
    UnblockPlanningGraphArcs("connection48")
    UnblockPlanningGraphArcs("connection63")
    UnblockPlanningGraphArcs("connection59")
    UnblockPlanningGraphArcs("close")
    UnblockPlanningGraphArcs("open")
    DisableBarriers("frog")
    DisableBarriers("close")
    DisableBarriers("open")
    
    --blocking Locked Doors
    UnblockPlanningGraphArcs("connection194");
    UnblockPlanningGraphArcs("connection200");
    UnblockPlanningGraphArcs("connection118");
    DisableBarriers("FRONTDOOR2-3");
    DisableBarriers("FRONTDOOR2-1");  
    DisableBarriers("FRONTDOOR2-2");  
    
    --Lower cloning facility
    UnblockPlanningGraphArcs("connection10")
    UnblockPlanningGraphArcs("connection159")
    UnblockPlanningGraphArcs("connection31")
    DisableBarriers("FRONTDOOR1-3")
    DisableBarriers("FRONTDOOR1-1")  
    DisableBarriers("FRONTDOOR1-2")
    
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
conquest:Start()
    EnableSPHeroRules()
    
    SetProperty("cp2", "spawnpath", "cp2_spawn")
    SetProperty("cp2", "captureregion", "cp2_capture")
 
  end
  
 --START BRIDGEWORK!

-- OPEN

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
        SetPS2ModelMemory(3600000)
     ReadDataFile("ingame.lvl")

   
     
   
     ReadDataFile("sound\\kam.lvl;kam1gcw")


     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_urban",
                    "all_inf_rocketeer_fleet",
                    "all_inf_sniper_fleet",
                    "all_inf_engineer_fleet",
                    "all_hero_hansolo_tat",
                    "all_inf_wookiee",
                    "all_inf_officer")
                               
     ReadDataFile("SIDE\\imp.lvl",
                                "imp_inf_rifleman",
                                "imp_inf_rocketeer",
                                "imp_inf_engineer",
                                "imp_inf_sniper",
                                "imp_inf_officer",
                                "imp_inf_dark_trooper",
                                "imp_hero_bobafett")

ReadDataFile("SIDE\\tur.lvl",
                        "tur_bldg_chaingun_roof",
                        "tur_weap_built_gunturret") 

     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     SetMemoryPoolSize ("EntityCloth", 33)
     SetMemoryPoolSize ("EntityLight", 64)  
     SetMemoryPoolSize ("Obstacle", 800)
    SetMemoryPoolSize("EntitySoundStream", 3)
     SetMemoryPoolSize ("SoundSpaceRegion", 36)
    SetMemoryPoolSize("EntitySoundStatic", 85)
     SetMemoryPoolSize ("Weapon", 260)

   SetupTeams{
    all = {
        team = ALL,
        units = 32,
        reinforcements = 150,
        soldier = { "all_inf_rifleman_urban",9, 25},
        assault = { "all_inf_rocketeer_fleet",1, 4},
        engineer = { "all_inf_engineer_fleet",1, 4},
        sniper  = { "all_inf_sniper_fleet",1, 4},
        officer = { "all_inf_officer",1, 4},
        special = { "all_inf_wookiee",1,4},
    },

}   

SetupTeams{
    imp = {
        team = IMP,
        units = 32,
        reinforcements = 150,
        soldier = { "imp_inf_rifleman",9, 25},
        assault = { "imp_inf_rocketeer",1, 4},
        engineer = { "imp_inf_engineer", 1, 4},
        sniper  = { "imp_inf_sniper",1, 4},
        officer = { "imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
      
    },

}
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    SetHeroClass(IMP, "imp_hero_bobafett")
    
     SetSpawnDelay(10.0, 0.25)
     --  AddDeathRegion("deathregion")
     ReadDataFile("KAM\\kam1.lvl", "kamino1_conquest")
         SetMemoryPoolSize("EntityFlyer", 6)
     SetDenseEnvironment("false")
         SetMinFlyHeight(60)
    SetAllowBlindJetJumps(0)
       SetMaxFlyHeight(102)
    SetMaxPlayerFlyHeight(102)
     --SetStayInTurrets(1)


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
     
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    OpenAudioStream("sound\\kam.lvl",  "kam1")
    -- OpenAudioStream("sound\\mus.lvl",  "kamino1_emt")

     SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(1, "allleaving")
     SetOutOfBoundsVoiceOver(2, "impleaving")

     SetAmbientMusic(ALL, 1.0, "all_kam_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.8, "all_kam_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.2, "all_kam_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_kam_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.8, "imp_kam_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.2, "imp_kam_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_kam_amb_victory")
     SetDefeatMusic (ALL, "all_kam_amb_defeat")
     SetVictoryMusic(IMP, "imp_kam_amb_victory")
     SetDefeatMusic (IMP, "imp_kam_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


     SetAttackingTeam(ATT)
    AddDeathRegion("deathregion")


   		    AddCameraShot(0.564619, -0.121047, 0.798288, 0.171142, 68.198814, 79.137611, 110.850922);

            AddCameraShot(-0.281100, 0.066889, -0.931340, -0.221616, 10.076019, 82.958336, -26.261774);

            AddCameraShot(0.209553, -0.039036, -0.960495, -0.178923, 92.558563, 58.820618, 130.675919);

            AddCameraShot(0.968794, 0.154227, 0.191627, -0.030506, -173.914413, 69.858940, 52.532421);

            AddCameraShot(0.744389, 0.123539, 0.647364, -0.107437, 97.475639, 53.216236, 76.477089);

            AddCameraShot(-0.344152, 0.086702, -0.906575, -0.228393, 95.062233, 105.285820, -37.661552);
 end
