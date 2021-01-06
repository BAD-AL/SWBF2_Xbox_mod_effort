--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("setup_teams")

--  Alliance Attacking (attacker is always #1)
ALL = 1
IMP = 2
--  These variables do not change
ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptPostLoad()
    --Switch the flag appearance(s) for CW vs GCW
    SetProperty("ctf_flag1", "GeometryName", "com_icon_alliance_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_alliance_flag_carried")

    SetProperty("ctf_flag2", "GeometryName", "com_icon_imperial_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_imperial_flag_carried")

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

    SoundEvent_SetupTeams(  2, 'imp', 1, 'all' )

    ctf:Start()

    EnableSPHeroRules()
    
 end
 
 function ScriptInit()
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(2500000)
    ReadDataFile("ingame.lvl")
    
    ReadDataFile("sound\\dag.lvl;dag1gcw")

    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight (20)

    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_jungle",
                    "all_inf_rocketeer_jungle",
                    "all_inf_engineer",
                    "all_inf_sniper_jungle",
                    "all_inf_officer",
                    "all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",                 
                    "imp_hero_darthvader")

    ReadDataFile("SIDE\\rep.lvl",
                "rep_hero_yoda")


    --  Level Stats
    ClearWalkers()
    --    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(1, 3) -- 8 droidekas (special case: 0 leg pairs)
    --    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    --    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 140
    SetMemoryPoolSize("Aimer", 0)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 70)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
     SetMemoryPoolSize ("EntitySoundStream", 2)
     SetMemoryPoolSize ("EntitySoundStatic", 1)
    SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 0)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 157)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetupTeams{

        all={
            team = ALL,
            units = 32,
            reinforcements = -1,
            soldier = {"all_inf_rifleman_jungle",9, 25},
            assault = {"all_inf_rocketeer_jungle",1,4},
            engineer = {"all_inf_engineer",1,4},
            sniper  = {"all_inf_sniper_jungle",1,4},
            officer = {"all_inf_officer",1,4},
            special = {"all_inf_wookiee",1,4},
            
        },
        
        imp={
            team = IMP,
            units = 32,
            reinforcements = -1,
            soldier = {"imp_inf_rifleman",9, 25},
            assault = {"imp_inf_rocketeer",1,4},
            engineer = {"imp_inf_engineer",1,4},
            sniper  = {"imp_inf_sniper",1,4},
            officer = {"imp_inf_officer",1,4},
            special = {"imp_inf_dark_trooper",1,4},
        }
    }

    
    SetHeroClass(ALL, "rep_hero_yoda")
    SetHeroClass(IMP, "imp_hero_darthvader")
    

    --  Local Stats
    --SetTeamName (3, "locals")
    --AddUnitClass (3, "ewk_inf_trooper", 4)
    --AddUnitClass (3, "ewk_inf_repair", 6)
    --SetUnitCount (3, 14)
    --SetTeamAsFriend(3,ATT)
    --SetTeamAsEnemy(3,DEF)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dag\\dag1.lvl", "dag1_ctf", "dag1_gcw")
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
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",   "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",    "gcw_music")
    -- OpenAudioStream("sound\\global.lvl", "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl", "global_vo_slow")
    OpenAudioStream("sound\\dag.lvl",   "dag1")
    OpenAudioStream("sound\\dag.lvl",   "dag1")
    -- OpenAudioStream("sound\\dag.lvl",    "dag1_emt")

    --SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    --SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing", 1)
    --SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing", 1)
    --SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "allleaving")
    SetOutOfBoundsVoiceOver(2, "impleaving")

    SetAmbientMusic(ALL, 1.0, "all_dag_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.9, "all_dag_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1,"all_dag_amb_end", 2,1)
    SetAmbientMusic(IMP, 1.0, "imp_dag_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.9, "imp_dag_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1,"imp_dag_amb_end", 2,1)

    SetVictoryMusic(ALL, "all_dag_amb_victory")
    SetDefeatMusic (ALL, "all_dag_amb_defeat")
    SetVictoryMusic(IMP, "imp_dag_amb_victory")
    SetDefeatMusic (IMP, "imp_dag_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",    "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",       "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",        "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",        "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",          "shell_menu_exit")

    SetAttackingTeam(ATT)

    --  Camera Stats
    AddCameraShot(0.953415, -0.062787, 0.294418, 0.019389, 20.468771, 3.780040, -110.412453);
    AddCameraShot(0.646125, -0.080365, 0.753185, 0.093682, 41.348438, 5.688061, -52.695042);
    AddCameraShot(-0.442911, 0.055229, -0.887986, -0.110728, 39.894440, 9.234127, -59.177147);
    AddCameraShot(-0.038618, 0.006041, -0.987228, -0.154444, 28.671711, 10.001163, 128.892181);
--  AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
--  AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
--  AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
 end

