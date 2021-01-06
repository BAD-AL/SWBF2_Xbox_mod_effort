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
     
 end
 
 function ScriptInit()
    StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(2497152 + 65536 * 0)
    ReadDataFile("ingame.lvl")
    
    ReadDataFile("sound\\dag.lvl;dag1cw")

    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight (20)

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
                "cis_hero_grievous")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    --  AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
    --  AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --  AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 203
    SetMemoryPoolSize("Aimer", 9)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 100)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize ("EntitySoundStream", 2)
    SetMemoryPoolSize ("EntitySoundStatic", 1)
    SetMemoryPoolSize("MountedTurret", 0)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 157)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetupTeams{
        rep = {
            team = REP,
            units = 32,
            reinforcements = 150,
            soldier = { "rep_inf_ep3_rifleman",9, 25},
            assault = { "rep_inf_ep3_rocketeer",1,4},
            engineer = { "rep_inf_ep3_engineer",1,4},
            sniper  = { "rep_inf_ep3_sniper",1,4},
            officer = {"rep_inf_ep3_officer",1,4},
            special = { "rep_inf_ep3_jettrooper",1,4},
            
        },
        cis = {
            team = CIS,
            units = 32,
            reinforcements = 150,
            soldier = { "cis_inf_rifleman",9, 25},
            assault = { "cis_inf_rocketeer",1,4},
            engineer = { "cis_inf_engineer",1,4},
            sniper  = { "cis_inf_sniper",1,4},
            officer = {"cis_inf_officer",1,4},
            special = { "cis_inf_droideka",1,4},
        }
    }

    SetHeroClass(REP, "rep_hero_yoda")
    SetHeroClass(CIS, "cis_hero_grievous")

     --  Level Stats
     ClearWalkers()
     AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
     --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
     --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each

    --  Attacker Stats
    --SetTeamAsFriend(ATT, 3)

    --  Defender Stats
    --SetTeamAsEnemy(DEF, 3)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dag\\dag1.lvl", "dag1_conquest", "dag1_cw") -- *****
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
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",    "cw_music")
    -- OpenAudioStream("sound\\global.lvl", "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl", "global_vo_slow")
    OpenAudioStream("sound\\dag.lvl",   "dag1")
    OpenAudioStream("sound\\dag.lvl",   "dag1")
    -- OpenAudioStream("sound\\dag.lvl",    "dag1_emt")

    -- *****
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)
    -- *****    

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_dag_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_dag_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_dag_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_dag_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_dag_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_dag_amb_end", 2,1)

    SetVictoryMusic(REP, "rep_dag_amb_victory")
    SetDefeatMusic (REP, "rep_dag_amb_defeat")
    SetVictoryMusic(CIS, "cis_dag_amb_victory")
    SetDefeatMusic (CIS, "cis_dag_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",    "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",        "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",        "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",          "shell_menu_exit")



    --  Camera Stats
    AddCameraShot(0.953415, -0.062787, 0.294418, 0.019389, 20.468771, 3.780040, -110.412453);
    AddCameraShot(0.646125, -0.080365, 0.753185, 0.093682, 41.348438, 5.688061, -52.695042);
    AddCameraShot(-0.442911, 0.055229, -0.887986, -0.110728, 39.894440, 9.234127, -59.177147);
    AddCameraShot(-0.038618, 0.006041, -0.987228, -0.154444, 28.671711, 10.001163, 128.892181);
 end
