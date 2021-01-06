--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("objectivectf")

--  These variables do not change
ATT = 1
DEF = 2

--  Empire Attacking (attacker is always #1)
IMP = ATT
ALL = DEF
 
 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
    UnblockPlanningGraphArcs("Connection74")
        DisableBarriers("1")
    PlayAnimRise()
    DisableBarriers("BALCONEY")
    DisableBarriers("bALCONEY2")
    DisableBarriers("hallway_f")
    DisableBarriers("hackdoor")
    DisableBarriers("outside")
     
    OnObjectRespawnName(PlayAnimRise, "DingDong");
    OnObjectKillName(PlayAnimRise, "DingDong");
    
--This is all the flag capture objective stuff
 --Capture the Flag for stand-alone multiplayer
                -- These set the flags geometry names.
                --GeometryName sets the geometry when hte flag is on the ground
                --CarriedGeometryName sets the geometry that appears over a player's head that is carrying the flag
        SetProperty("FLAG1", "GeometryName", "com_icon_alliance_flag")
        SetProperty("FLAG1", "CarriedGeometryName", "com_icon_alliance_flag_carried")
        SetProperty("FLAG2", "GeometryName", "com_icon_imperial_flag")
        SetProperty("FLAG2", "CarriedGeometryName", "com_icon_imperial_flag_carried")

                --This makes sure the flag is colorized when it has been dropped on the ground
        SetClassProperty("com_item_flag", "DroppedColorize", 1)
    SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,  textATT = "level.Kamino1.objectives.ctf.get", textDEF = "level.Kamino1.objectives.ctf.get1", multiplayerRules = true}
    ctf:AddFlag{name = "FLAG1", homeRegion = "FLAG1_HOME", captureRegion = "FLAG2_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "FLAG2", homeRegion = "FLAG2_HOME", captureRegion = "FLAG1_HOME",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:Start()
    EnableSPHeroRules()
end
  --START BRIDGEWORK!

-- OPEN
function PlayAnimDrop()
      PauseAnimation("lava_bridge_raise");    
      RewindAnimation("lava_bridge_drop");
      PlayAnimation("lava_bridge_drop");
        
    -- prevent the AI from running across it
    BlockPlanningGraphArcs("Connection82");
    BlockPlanningGraphArcs("Connection83");
    EnableBarriers("Bridge");
    
end
-- CLOSE
function PlayAnimRise()
      PauseAnimation("lava_bridge_drop");
      RewindAnimation("lava_bridge_raise");
      PlayAnimation("lava_bridge_raise");
            

        -- allow the AI to run across it
    UnblockPlanningGraphArcs("Connection82");
    UnblockPlanningGraphArcs("Connection83");
    DisableBarriers("Bridge");
 end


 function ScriptInit()
  StealArtistHeap(64*1024)
     -- Designers, these two lines *MUST* be first!
        SetPS2ModelMemory(3600000)
     ReadDataFile("ingame.lvl")

  

     ReadDataFile("sound\\mus.lvl;mus1gcw")


     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)

     ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_wookiee",
                    "all_inf_officer")
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_dark_trooper",
                    "imp_inf_officer")

    ReadDataFile("SIDE\\rep.lvl",
                            "rep_hero_obiwan",
                            "rep_hero_anakin")

     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     SetMemoryPoolSize("EntityCloth", 29)
     SetMemoryPoolSize("EntitySoundStatic", 133)
     SetMemoryPoolSize("FlagItem", 2) 
     SetMemoryPoolSize("Obstacle", 320)
     SetMemoryPoolSize("TentacleSimulator", 12)
     SetMemoryPoolSize("EntityFlyer", 4)
     SetMemoryPoolSize("Weapon", 260)

   SetupTeams{
    all = {
        team = ALL,
        units = 32,
        reinforcements = -1,
        soldier = { "all_inf_rifleman",7, 25},
        assault = { "all_inf_rocketeer",1, 4},
        engineer = { "all_inf_engineer",1, 4},
        sniper  = { "all_inf_sniper",1, 4},
        officer = { "all_inf_officer",1, 4},
        special = { "all_inf_wookiee",1, 4},
            
    },

}   

SetupTeams{
    imp = {
        team = IMP,
        units = 32,
        reinforcements = -1,
        soldier = { "imp_inf_rifleman",7, 25},
        assault = { "imp_inf_rocketeer",1, 4},
        engineer = { "imp_inf_engineer",1,4},
        sniper  = { "imp_inf_sniper",1, 4},
        officer = { "imp_inf_officer",1, 4},
        special = { "imp_inf_dark_trooper",1, 4},
      
    },

}
     
     SetHeroClass(ALL, "rep_hero_obiwan")
     SetHeroClass(IMP, "rep_hero_anakin")  
     
     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("mus\\mus1.lvl", "mus1_ctf")
     SetDenseEnvironment("false")
     --  AddDeathRegion("deathregion")
     --SetStayInTurrets(1)
   SetMaxFlyHeight(84.16)
    SetMaxPlayerFlyHeight(84.16)
    AISnipeSuitabilityDist(30)

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
     OpenAudioStream("sound\\mus.lvl",  "mus1")
     OpenAudioStream("sound\\mus.lvl",  "mus1")
     -- OpenAudioStream("sound\\mus.lvl",  "mus1_emt")

     -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
     -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
     -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

     -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
     -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

     SetOutOfBoundsVoiceOver(2, "allleaving")
     SetOutOfBoundsVoiceOver(1, "impleaving")

     SetAmbientMusic(ALL, 1.0, "all_mus_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.9, "all_mus_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.1,"all_mus_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_mus_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.9, "imp_mus_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.1,"imp_mus_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_mus_amb_victory")
     SetDefeatMusic (ALL, "all_mus_amb_defeat")
     SetVictoryMusic(IMP, "imp_mus_amb_victory")
     SetDefeatMusic (IMP, "imp_mus_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


     SetAttackingTeam(ATT)


   	AddCameraShot(0.446393, -0.064402, -0.883371, -0.127445, -93.406929, 72.953865, -35.479401);
	
	AddCameraShot(-0.297655, 0.057972, -0.935337, -0.182169, -2.384067, 71.165306, 18.453350);
	
	AddCameraShot(0.972488, -0.098362, 0.210097, 0.021250, -42.577881, 69.453072, 4.454691);
	
	AddCameraShot(0.951592, -0.190766, -0.236300, -0.047371, -44.607018, 77.906273, 113.228661);
	
	AddCameraShot(0.841151, -0.105984, 0.526154, 0.066295, 109.567764, 77.906273, 7.873035);
	
	AddCameraShot(0.818472, -0.025863, 0.573678, 0.018127, 125.781593, 61.423031, 9.809184);
	
	AddCameraShot(-0.104764, 0.000163, -0.994496, -0.001550, -13.319855, 70.673264, 63.436607);
	
	AddCameraShot(0.971739, 0.102058, 0.211692, -0.022233, -5.680069, 68.543945, 57.904160);
	
	AddCameraShot(0.178437, 0.004624, -0.983610, 0.025488, -66.947433, 68.543945, 6.745875);

    AddCameraShot(-0.400665, 0.076364, -0896894, -0.170941, 96.201210, 79.913033, -58.604382)
end


