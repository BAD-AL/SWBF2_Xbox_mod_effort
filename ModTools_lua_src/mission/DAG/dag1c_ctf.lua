--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

--  Republic Attacking (attacker is always #1)
REP = 1
CIS = 2
--  These variables do not change
ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
 function ScriptPostLoad()
    --Switch the flag appearance(s) for CW vs GCW
    SetProperty("ctf_flag1", "GeometryName", "com_icon_republic_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")

    SetProperty("ctf_flag2", "GeometryName", "com_icon_cis_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

    SetProperty ("flag2_effect","Team",2) -- Kludge because the effect objects are shared with 1flag
    SetProperty ("flag1_effect","Team",1) -- Kludge because the effect objects are shared with 1flag

    --This is all the actual ctf objective setup
    ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

    SoundEvent_SetupTeams( 1, 'rep', 2, 'cis' )

    ctf:Start()

    EnableSPHeroRules()
     
 end
 
 function ScriptInit()
    StealArtistHeap(1500*1024)
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
    AddWalkerType(0, 3) -- 3 droidekas (special case: 0 leg pairs)
    --  AddWalkerType(1, 3)
    --  AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --  AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 9)-- *****
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 80)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize ("EntitySoundStream", 2)
    SetMemoryPoolSize ("EntitySoundStatic", 1)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 0)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 157)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)-- *****
    
    SetupTeams{
            
        rep = {
            team = REP,
            units = 32,
            reinforcements = -1,
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
            reinforcements = -1,
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

    --  Local Stats
    --SetTeamName (3, "locals")
    --AddUnitClass (3, "ewk_inf_trooper", 4)
    --AddUnitClass (3, "ewk_inf_repair", 6)
    --SetUnitCount (3, 14)
    --SetTeamAsFriend(3,ATT)
    --SetTeamAsEnemy(3,DEF)

    --  Attacker Stats
    SetUnitCount(ATT, 25)
    SetReinforcementCount(ATT, -1)-- *****
    --SetTeamAsFriend(ATT, 3)

    --  Defender Stats
    SetUnitCount(DEF, 25)
    SetReinforcementCount(DEF, -1)-- *****
    --SetTeamAsEnemy(DEF, 3)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dag\\dag1.lvl", "dag1_ctf", "dag1_cw")-- *****
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
    --SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    --SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing", 1)
    --SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing", 1)
    --SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    --SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    --SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    --SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    --SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)
    -- *****

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_dag_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_dag_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_dag_amb_end", 2,1)
    SetAmbientMusic(CIS, 1.0, "cis_dag_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_dag_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_dag_amb_end", 2,1)

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