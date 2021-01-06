--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams")

--  Empire Attacking (attacker is always #1)
     REP = 1
     CIS = 2
     --  These variables do not change
     ATT = 1
     DEF = 2

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
 
 	cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "Capture all the CPs!", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)

     EnableSPHeroRules()
     
 end
 
 function ScriptInit()
     -- Designers, these two lines *MUST* be first.
     SetPS2ModelMemory(2497152 + 65536 * 0)
     ReadDataFile("ingame.lvl")
    
     
     
    
     ReadDataFile("sound\\dag.lvl;dag1cw")


     --SetMaxFlyHeight(43)
     --SetMaxPlayerFlyHeight (43)

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper", 
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_hero_yoda")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_officer",
                "cis_inf_sniper",
                "cis_inf_droideka",
                "cis_hero_countdooku")



     --  Level Stats
     ClearWalkers()
         AddWalkerType(0, 4) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
     --  SetMemoryPoolSize ("MountedTurret",20)
     --  SetMemoryPoolSize ("EntityTauntaun",0)
     --  SetMemoryPoolSize ("EntitySoldier",0)
     SetMemoryPoolSize ("EntityHover",0)
     SetMemoryPoolSize ("EntityFlyer",0)
     SetMemoryPoolSize ("EntityDroid",10)
     SetMemoryPoolSize ("EntityCarrier",0)
     SetMemoryPoolSize("Obstacle", 118)
     SetMemoryPoolSize ("Weapon", 260)

	SetupTeams{
             
        rep = {
            team = REP,
            units = 25,
            reinforcements = -1,
            soldier  = { "rep_inf_ep3_rifleman",11},
            assault  = { "rep_inf_ep3_rocketeer",4},
            pilot    = { "rep_inf_ep3_engineer",3},
            sniper   = { "rep_inf_ep3_sniper",2},
            officer = {"rep_inf_ep3_officer",2},
            special = { "rep_inf_ep3_jettrooper",3},
            
        },
        cis = {
            team = CIS,
            units = 25,
            reinforcements = -1,
           	soldier  = { "cis_inf_rifleman",11},
            assault  = { "cis_inf_rocketeer",4},
            pilot    = { "cis_inf_engineer",3},
            sniper   = { "cis_inf_sniper",2},
            officer = {"cis_inf_officer",2},
            special = { "cis_inf_droideka",3},
        }
     }

     
        SetHeroClass(REP, "rep_hero_yoda")
        SetHeroClass(CIS, "cis_hero_countdooku")

     --  Local Stats
     --SetTeamName (3, "locals")
     --AddUnitClass (3, "ewk_inf_trooper", 4)
     --AddUnitClass (3, "ewk_inf_repair", 6)
     --SetUnitCount (3, 14)
     --SetTeamAsFriend(3,ATT)
     --SetTeamAsEnemy(3,DEF)

     --  Attacker Stats
     SetUnitCount(ATT, 25)
     SetReinforcementCount(ATT, 200)
     

     --SetTeamAsFriend(ATT, 3)


     --  Defender Stats
     SetUnitCount(DEF, 25)
     SetReinforcementCount(DEF, 200)
     

     --SetTeamAsEnemy(DEF, 3)

     SetSpawnDelay(10.0, 0.25)
     ReadDataFile("dag\\dag1.lvl", "dag1_conquest", "dag1_cw")
     SetDenseEnvironment("false")
     SetAIViewMultiplier(0.35)
     --AddDeathRegion("deathregion")
     --SetStayInTurrets(1)


     --  Movies
     --  SetVictoryMovie(ALL, "all_end_victory")
     --  SetDefeatMovie(ALL, "imp_end_victory")
     --  SetVictoryMovie(IMP, "imp_end_victory")
     --  SetDefeatMovie(IMP, "all_end_victory")

     --  Sound
     OpenAudioStream("sound\\dag.lvl",  "dagcw_music")
    OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
     OpenAudioStream("sound\\dag.lvl",  "dag1")
     OpenAudioStream("sound\\dag.lvl",  "dag1")
     -- OpenAudioStream("sound\\dag.lvl",  "dag1_emt")

     SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_myg_amb_start",  0,1)
    SetAmbientMusic(REP, 0.99, "rep_myg_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_myg_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.99, "cis_myg_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_myg_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 0, "CIS_bonus_CIS_medical")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 0, "CIS_bonus_REP_medical")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 1, "")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 1, "")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 2, "CIS_bonus_CIS_sensors")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 2, "CIS_bonus_REP_sensors")
      SetPlanetaryBonusVoiceOver(CIS, CIS, 3, "CIS_bonus_CIS_hero")
      SetPlanetaryBonusVoiceOver(CIS, REP, 3, "CIS_bonus_REP_hero")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 4, "CIS_bonus_CIS_reserves")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 4, "CIS_bonus_REP_reserves")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 5, "CIS_bonus_CIS_sabotage")--sabotage
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 5, "CIS_bonus_REP_sabotage")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 6, "")
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 6, "")
  --  SetPlanetaryBonusVoiceOver(CIS, CIS, 7, "CIS_bonus_CIS_training")--advanced training
  --  SetPlanetaryBonusVoiceOver(CIS, REP, 7, "CIS_bonus_REP_training")--advanced training

  --  SetPlanetaryBonusVoiceOver(REP, REP, 0, "REP_bonus_REP_medical")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 0, "REP_bonus_CIS_medical")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 1, "")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 1, "")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 2, "REP_bonus_REP_sensors")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 2, "REP_bonus_CIS_sensors")
      SetPlanetaryBonusVoiceOver(REP, REP, 3, "REP_bonus_REP_hero")
      SetPlanetaryBonusVoiceOver(REP, CIS, 3, "REP_bonus_CIS_hero")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 4, "REP_bonus_REP_reserves")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 4, "REP_bonus_CIS_reserves")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 5, "REP_bonus_REP_sabotage")--sabotage
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 5, "REP_bonus_CIS_sabotage")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 6, "")
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 6, "")
  --  SetPlanetaryBonusVoiceOver(REP, REP, 7, "REP_bonus_REP_training")--advanced training
  --  SetPlanetaryBonusVoiceOver(REP, CIS, 7, "REP_bonus_CIS_training")--advanced training

    --  Camera Stats
    --Tat 1 - Dune Sea
    --Crawler
    AddCameraShot(-0.404895, 0.000992, -0.914360, -0.002240, -85.539894, 20.536297, 141.699493)
    --Homestead
    AddCameraShot(0.040922, 0.004049, -0.994299, 0.098381, -139.729523, 17.546598, -34.360893)
    --Sarlac Pit
    AddCameraShot(-0.312360, 0.016223, -0.948547, -0.049263, -217.381485, 20.150953, 54.514324)

 end

