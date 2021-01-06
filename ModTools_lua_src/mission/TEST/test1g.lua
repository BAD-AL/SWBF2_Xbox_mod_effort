--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
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

    EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}

    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    
    conquest:Start()

end

 function ScriptInit()
     -- Designers, these two lines *MUST* be first!
     SetPS2ModelMemory(2097152 + 65536 * 0)
     ReadDataFile("ingame.lvl")

     --  Empire Attacking (attacker is always #1)
     local ALL = 1
     local IMP = 2
     --  These variables do not change
     local ATT = 1
     local DEF = 2
     
     ReadDataFile("sound\\tat.lvl;tat2gcw")

     --SetTeamAggressiveness(ALL, 1.0)
     --SetTeamAggressiveness(IMP, 0.7)

     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)

     ReadDataFile("SIDE\\all.lvl",
                                "all_inf_rifleman_jungle",
                                "all_inf_rocketeer_jungle",
                                "all_inf_pilot",
                                "all_inf_sniper_jungle",
                                "all_inf_wookiee",
                                "all_hero_leia")
     ReadDataFile("SIDE\\imp.lvl",
                                "imp_inf_rifleman",
                                "imp_inf_rocketeer",
                                "imp_inf_pilot_atst",
                                "imp_inf_sniper",
                                "imp_inf_dark_trooper",
                                "imp_hero_bobafett",
                                "imp_hero_darthvader")
     --ReadDataFile("SIDE\\geo.lvl",
     --                           "geo_walk_acklay")



     --  Level Stats
     ClearWalkers()
     --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     AddWalkerType(2, 2) -- 2 acklays with 2 leg pairs each
     SetMemoryPoolSize ("EntityWalker",1)
     --  SetMemoryPoolSize ("MountedTurret",20)
     --  SetMemoryPoolSize ("EntityTauntaun",0)
     --  SetMemoryPoolSize ("EntitySoldier",0)
     SetMemoryPoolSize ("EntityHover",0)
     SetMemoryPoolSize ("EntityFlyer",5)
     SetMemoryPoolSize ("EntityDroid",10)
     SetMemoryPoolSize ("EntityCarrier",0)
     SetMemoryPoolSize("Obstacle", 50)
     SetMemoryPoolSize ("Weapon", 260)



     --  Alliance Stats
     SetTeamName(ALL, "Alliance")
     SetTeamIcon(ALL, "all_icon")
     AddUnitClass(ALL, "all_inf_rifleman_jungle",2)   --add 1 for hero class
     AddUnitClass(ALL, "all_inf_rocketeer_jungle",0)
     AddUnitClass(ALL, "all_inf_pilot",1)
     AddUnitClass(ALL, "all_inf_sniper_jungle",0)
     AddUnitClass(ALL, "all_inf_wookiee",0)
     SetHeroClass(ALL, "all_hero_luke_jedi")

     --  Imperial Stats
     SetTeamName(IMP, "Empire")
     SetTeamIcon(IMP, "imp_icon")
     AddUnitClass(IMP, "imp_inf_rifleman",2)   --add 1 for hero class
     AddUnitClass(IMP, "imp_inf_rocketeer",0)
     AddUnitClass(IMP, "imp_inf_pilot_atst",1)
     AddUnitClass(IMP, "imp_inf_sniper",0)
     AddUnitClass(IMP, "imp_hero_bobafett",0)
     SetHeroClass(IMP, "imp_hero_darthvader")

	--  Local Stats
	SetTeamName(3, "locals")
	--AddUnitClass(3, "gam_inf_gamorreanguard",3)
	--SetUnitCount(3, 3)
	SetTeamAsEnemy(3, ATT)
	SetTeamAsEnemy(3, DEF) 

     --  Attacker Stats
     SetUnitCount(ATT, 3)
     SetReinforcementCount(ATT, 1000)
     --teamATT = ConquestTeam:New{team = ATT}
     --teamATT:AddBleedThreshold(21, 0.0)
     --teamATT:AddBleedThreshold(11, 0.0)
     --teamATT:AddBleedThreshold(1, 0.0)
     --teamATT:Init()
     --SetTeamAsFriend(ATT, 3)


     --  Defender Stats
     SetUnitCount(DEF, 3)
     SetReinforcementCount(DEF, 1000)
     --teamDEF = ConquestTeam:New{team = DEF}
     --teamDEF:AddBleedThreshold(21, 0.0)
     --teamDEF:AddBleedThreshold(11, 0.0)
     --teamDEF:AddBleedThreshold(1, 0.0)
     --teamDEF:Init()


     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("test\\test1.lvl")
     SetDenseEnvironment("false")
     --AddDeathRegion("deathregion")
     --SetStayInTurrets(1)


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     OpenAudioStream("sound\\tat.lvl",  "tatgcw_music")
     OpenAudioStream("sound\\gcw.lvl",  "gcw_vo")
     OpenAudioStream("sound\\gcw.lvl",  "gcw_tac_vo")
   -- OpenAudioStream("sound\\cor.lvl",  "cor1gcw")
   -- OpenAudioStream("sound\\cor.lvl",  "cor1gcw")
   -- OpenAudioStream("sound\\cor.lvl",  "cor1gcw_emt")

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

     SetAmbientMusic(ALL, 1.0, "all_bes_amb_start",  0,1)
     SetAmbientMusic(ALL, 0.99, "all_bes_amb_middle", 1,1)
     SetAmbientMusic(ALL, 0.1,"all_bes_amb_end",    2,1)
     SetAmbientMusic(IMP, 1.0, "imp_bes_amb_start",  0,1)
     SetAmbientMusic(IMP, 0.99, "imp_bes_amb_middle", 1,1)
     SetAmbientMusic(IMP, 0.1,"imp_bes_amb_end",    2,1)

     SetVictoryMusic(ALL, "all_bes_amb_victory")
     SetDefeatMusic (ALL, "all_bes_amb_defeat")
     SetVictoryMusic(IMP, "imp_bes_amb_victory")
     SetDefeatMusic (IMP, "imp_bes_amb_defeat")

     SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
     SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
     --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
     SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
     SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
     SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
     SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
     SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 0, "imp_bonus_imp_medical")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 0, "imp_bonus_all_medical")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 1, "")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 1, "")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 2, "imp_bonus_imp_sensors")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 2, "imp_bonus_all_sensors")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 3, "imp_bonus_imp_hero")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 3, "imp_bonus_all_hero")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 4, "imp_bonus_imp_reserves")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 4, "imp_bonus_all_reserves")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 5, "imp_bonus_imp_sabotage")--sabotage
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 5, "imp_bonus_all_sabotage")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 6, "")
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 6, "")
     --  SetPlanetaryBonusVoiceOver(IMP, IMP, 7, "imp_bonus_imp_training")--advanced training
     --  SetPlanetaryBonusVoiceOver(IMP, ALL, 7, "imp_bonus_all_training")--advanced training

     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 0, "all_bonus_all_medical")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 0, "all_bonus_imp_medical")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 1, "")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 1, "")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 2, "all_bonus_all_sensors")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 2, "all_bonus_imp_sensors")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 3, "all_bonus_all_hero")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 3, "all_bonus_imp_hero")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 4, "all_bonus_all_reserves")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 4, "all_bonus_imp_reserves")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 5, "all_bonus_all_sabotage")--sabotage
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 5, "all_bonus_imp_sabotage")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 6, "")
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 6, "")
     --  SetPlanetaryBonusVoiceOver(ALL, ALL, 7, "all_bonus_all_training")--advanced training
     --  SetPlanetaryBonusVoiceOver(ALL, IMP, 7, "all_bonus_imp_training")--advanced training

     SetAttackingTeam(ATT)



     AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)

     AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)

     AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
 end

