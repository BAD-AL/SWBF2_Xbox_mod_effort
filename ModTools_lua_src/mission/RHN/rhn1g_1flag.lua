--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

     --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2

 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "t2_home", captureRegionDEF = "t1_home",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}

    ctf:Start()
    
    EnableSPHeroRules()
        
end
---
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------

function ScriptInit()
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(4500000)
    SetPS2ModelMemory(3300000)
    ReadDataFile("ingame.lvl")

	SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",20)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",300)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",300) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",300)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",150)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",1800)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",50)
    
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_inf_rifleman_snow",
                             "all_inf_rocketeer_snow",
                             "all_inf_engineer_snow",
                             "all_inf_sniper_snow",
                             "all_inf_officer_snow",
                             "all_hero_chewbacca",
                             "all_inf_wookiee_snow",
                             "all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_rifleman_snow",
                             "imp_inf_rocketeer_snow",
                             "imp_inf_sniper_snow",
                             "imp_inf_dark_trooper",
                             "imp_inf_engineer_snow",
                             "imp_inf_officer",
                             "imp_hero_emperor",
                             "imp_walk_atat",
                             "imp_hover_fightertank")
                             
    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_laser")

    SetupTeams{

        all={
            team = ALL,
            units = 20,
            reinforcements = -1,
            soldier = {"all_inf_rifleman_snow",9, 25},
            assault = {"all_inf_rocketeer_snow",1, 4},
            engineer   = {"all_inf_engineer_snow",1, 4},
            sniper  = {"all_inf_sniper_snow",1, 4},
            officer = {"all_inf_officer_snow",1, 4},
            special = {"all_inf_wookiee_snow",1, 4},
            
        },
        
        imp={
            team = IMP,
            units = 20,
            reinforcements = -1,
            soldier = {"imp_inf_rifleman_snow",9, 25},
            assault = {"imp_inf_rocketeer_snow",1, 4},
            engineer   = {"imp_inf_engineer_snow",1, 4},
            sniper  = {"imp_inf_sniper_snow",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = {"imp_inf_dark_trooper",1, 4},
        }
    }


--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_emperor")
    SetHeroClass(ALL, "all_hero_chewbacca")
    
   
       --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 5) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 221
	SetMemoryPoolSize("Aimer", 80)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 175)
	SetMemoryPoolSize("CommandWalker", 2)
	SetMemoryPoolSize("ConnectivityGraphFollower", 56)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 41)
	SetMemoryPoolSize("EntityFlyer", 10)
	SetMemoryPoolSize("EntityHover",4)
	SetMemoryPoolSize("EntityLight", 110)
	SetMemoryPoolSize("EntitySoundStatic", 16)
	SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
	SetMemoryPoolSize("MountedTurret", 30)
	SetMemoryPoolSize("FlagItem", 1)
	SetMemoryPoolSize("Navigator", 63)
	SetMemoryPoolSize("Obstacle", 400)
	SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("TreeGridStack", 300)
	SetMemoryPoolSize("UnitController", 63)
	SetMemoryPoolSize("UnitAgent", 63)
	SetMemoryPoolSize("Weapon", weaponCnt)

     ReadDataFile("dc:RHN\\RHN1.lvl", "RhenVar1_CTF")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("true")
    SetDefenderSnipeRange(170)
    AddDeathRegion("FalltoDeath")
        
    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .75, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .5, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .25, 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_hot_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.5, "all_hot_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.25,"all_hot_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.5, "imp_hot_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.25,"imp_hot_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")
    
--  Camera Stats

--  Top Down
    AddCameraShot(0.876900, -0.442794, 0.166961, 0.084308, -92.842827, 91.021690, 161.355850);
--  CP3
    AddCameraShot(0.931816, -0.181206, -0.308678, -0.060027, -147.396545, 25.021837, 128.233185);
    AddCameraShot(0.909842, -0.262073, 0.309156, 0.089050, -91.736038, 34.621788, 163.739639);
--  CP5
    AddCameraShot(0.813412, -0.193748, -0.533549, -0.127087, -70.256043, 25.621792, 115.028290);
    AddCameraShot(0.968388, -0.181738, -0.167961, -0.031521, -27.984699, 17.221787, 142.233933);
--  CP6
    AddCameraShot(0.985705, -0.078090, -0.148826, -0.011790, -35.218330, 15.421706, 16.465012);
    AddCameraShot(0.559177, -0.053046, -0.823652, -0.078135, -71.415993, 16.921690, -12.113598);
--  CP7
    AddCameraShot(0.146996, -0.058009, -0.918500, -0.362469, -220.067062, 26.905960, 28.651220);
    AddCameraShot(0.982701, -0.135933, -0.124598, -0.017235, -222.859299, 18.505959, 68.993172);
--  CP2
    AddCameraShot(0.800503, -0.205155, -0.545494, -0.139800, -352.629608, 23.605942, 117.735550);
    AddCameraShot(0.882701, -0.040039, -0.467747, -0.021217, -318.316254, 3.505955, 125.752930);
--  Pretty
    AddCameraShot(0.563676, -0.109911, 0.803518, 0.156678, -231.592621, 22.405914, 223.867676);
    AddCameraShot(0.938392, 0.112758, 0.324325, -0.038971, -251.608917, 1.105925, 266.066315);
    AddCameraShot(0.723019, 0.100555, 0.676954, -0.094148, -39.843826, 0.805894, 111.416893);
    AddCameraShot(0.968209, 0.021490, -0.249156, 0.005530, -75.747406, 12.505874, 75.078301);
    AddCameraShot(0.264429, -0.053655, -0.943684, -0.191482, -125.556999, 26.605818, 48.874596);
end

