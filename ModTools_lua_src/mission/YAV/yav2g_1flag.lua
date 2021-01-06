--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script	
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

--  These variables do not change
ATT = 1
DEF = 2

--  Alliance Attacking (attacker is always #1)
ALL = DEF
IMP = ATT

 ---------------------------------------------------------------------------
 -- FUNCTION:    ScriptInit
 -- PURPOSE:     This function is only run once
 -- INPUT:
 -- OUTPUT:
 -- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
 --              mission script must contain a version of this function, as
 --              it is called from C to start the mission.
 ---------------------------------------------------------------------------
 
 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
	
	KillObject ("TempleBlastDoor")

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 8, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_capture1",
                           captureRegionATT = "flag_capture1", captureRegionDEF = "flag_capture2",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}
    ctf:Start()

    
    EnableSPHeroRules()


        
end

function ScriptInit()
    StealArtistHeap(300*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2500000)
    ReadDataFile("ingame.lvl")

   
    SetTeamAggressiveness(ALL, 1.0)
    SetTeamAggressiveness(IMP, 1.0)
    SetMaxFlyHeight(-22)
    SetMaxPlayerFlyHeight (-22)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",20)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",300)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",300) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",300)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",150)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",1800)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",50)
   
    ReadDataFile("sound\\yav.lvl;yav1gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_jungle",
                    "all_inf_rocketeer_jungle",
                    "all_inf_sniper_jungle",
                    "all_inf_engineer_jungle",
                    "all_hero_luke_jedi",
                    "all_inf_officer_jungle",
                    "all_inf_wookiee",
                    "all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_hover_speederbike",
                             "imp_inf_rifleman",
                             "imp_inf_rocketeer",
                             "imp_inf_engineer",
                             "imp_inf_sniper",
                             "imp_inf_dark_trooper",
                             "imp_hero_bobafett",
                             "imp_inf_officer",
                             "imp_hover_fightertank")
                             
                             
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser",
    			"tur_bldg_tower")          
                             
                             

       -- set up teams
SetupTeams{
       all = {
            team = ALL,
            units = 32,
            reinforcements = -1,
            soldier  = { "all_inf_rifleman_jungle",9, 25},
            assault  = { "all_inf_rocketeer_jungle",1, 4},
            engineer = { "all_inf_engineer_jungle",1, 4},
            sniper   = { "all_inf_sniper_jungle",1, 4},
            officer = {"all_inf_officer_jungle",1, 4},
            special = { "all_inf_wookiee",1, 4},
        },
          
        imp = {
            team = IMP,
            units = 32,
            reinforcements = -1,
            soldier  = { "imp_inf_rifleman",9, 25},
            assault  = { "imp_inf_rocketeer",1, 4},
            engineer = { "imp_inf_engineer",1, 4},
            sniper   = { "imp_inf_sniper",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
            
        }
        
     }
    SetHeroClass(ALL, "all_hero_luke_jedi")
    
    SetHeroClass(IMP, "imp_hero_bobafett")
   
       
    
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 214
    SetMemoryPoolSize("Aimer", 13)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("EntityLight", 38)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("MountedTurret", 13)
	SetMemoryPoolSize("Navigator", 46)
    SetMemoryPoolSize("Obstacle", 750)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoundSpaceRegion", 48)
    SetMemoryPoolSize("TreeGridStack", 500)
	SetMemoryPoolSize("UnitAgent", 46)
	SetMemoryPoolSize("UnitController", 46)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 7)   
    SetMemoryPoolSize ("EntityHover",2)

    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:YAV\\yav2.lvl","yav2_1flag")
    SetDenseEnvironment("false")

    --  Birdies
    SetNumBirdTypes(2)
    SetBirdType(0,1.0,"bird")
    SetBirdType(1,1.5,"bird2")

   

    --  Sound

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)

    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")

    SetAmbientMusic(ALL, 1.0, "all_yav_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.9, "all_yav_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1, "all_yav_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_yav_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.9, "imp_yav_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1, "imp_yav_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_yav_amb_victory")
    SetDefeatMusic (ALL, "all_yav_amb_defeat")
    SetVictoryMusic(IMP, "imp_yav_amb_victory")
    SetDefeatMusic (IMP, "imp_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    --SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    --SetSoundEffect("WeaponUnableSelect",      "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--OpeningSateliteShot
    AddCameraShot(0.908386, -0.209095, -0.352873, -0.081226, -45.922508, -19.114113, 77.022636);

    AddCameraShot(-0.481173, 0.024248, -0.875181, -0.044103, 14.767292, -30.602322, -144.506851);
    AddCameraShot(0.999914, -0.012495, -0.004416, -0.000055, 1.143253, -33.602314, -76.884430);
    AddCameraShot(0.839161, 0.012048, -0.543698, 0.007806, 19.152437, -49.802273, 24.337317);
    AddCameraShot(0.467324, 0.006709, -0.883972, 0.012691, 11.825212, -49.802273, -7.000720);
    AddCameraShot(0.861797, 0.001786, -0.507253, 0.001051, -11.986043, -59.702248, 23.263165);
    AddCameraShot(0.628546, -0.042609, -0.774831, -0.052525, 20.429928, -48.302277, 9.771714);
    AddCameraShot(0.765213, -0.051873, 0.640215, 0.043400, 57.692474, -48.302277, 16.540724);
    AddCameraShot(0.264032, -0.015285, -0.962782, -0.055734, -16.681797, -42.902290, 129.553268);
    AddCameraShot(-0.382320, 0.022132, -0.922222, -0.053386, 20.670977, -42.902290, 135.513001);
    
end

