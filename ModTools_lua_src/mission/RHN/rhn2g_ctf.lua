----
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")
     
     --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2

function ScriptPostLoad()
 SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
 
    EnableSPHeroRules()
    
    SetProperty("flag1", "GeometryName", "com_icon_imperial_flag")
    SetProperty("flag1", "CarriedGeometryName", "com_icon_imperial_flag_carried")

    SetProperty("flag2", "GeometryName", "com_icon_alliance_flag")
    SetProperty("flag2", "CarriedGeometryName", "com_icon_alliance_flag_carried")
    
     ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "flag2_capture", captureRegion = "flag1_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "flag1_capture", captureRegion = "flag2_capture",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:Start()
    
 end

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
    
     --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2

    --SetAttackingTeam(ATT)


    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_inf_rifleman_snow",
                             "all_inf_rocketeer_snow",
                             "all_inf_engineer_snow",
                             "all_inf_sniper_snow",
                             "all_inf_officer_snow",
                             "all_hero_hansolo_tat",
                             "all_inf_wookiee_snow",
                             "all_hover_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_rifleman_snow",
                             "imp_inf_rocketeer_snow",
                             "imp_inf_sniper_snow",
                             "imp_inf_dark_trooper",
                             "imp_inf_engineer_snow",
                             "imp_inf_officer",
                             "imp_hero_bobafett",
                             "imp_walk_atat",
                             "imp_hover_fightertank")
                             
    ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_laser")

    SetupTeams{

        all={
            team = ALL,
            units = 19,
            reinforcements = 150,
            soldier = {"all_inf_rifleman_snow",9, 25},
            assault = {"all_inf_rocketeer_snow",1, 4},
            engineer   = {"all_inf_engineer_snow",1, 4},
            sniper  = {"all_inf_sniper_snow",1, 4},
            officer = {"all_inf_officer_snow",1, 4},
            special = {"all_inf_wookiee_snow",1, 4},
            
        },
        
        imp={
            team = IMP,
            units = 19,
            reinforcements = 150,
            soldier = {"imp_inf_rifleman_snow",9, 25},
            assault = {"imp_inf_rocketeer_snow",1, 4},
            engineer   = {"imp_inf_engineer_snow",1, 4},
            sniper  = {"imp_inf_sniper_snow",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = {"imp_inf_dark_trooper",1, 4},
        }
    }


--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_bobafett")
    SetHeroClass(ALL, "all_hero_hansolo_tat")
    
   

       --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4) -- 0 droidekas
    AddWalkerType(1, 5) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 221
	SetMemoryPoolSize("Aimer", 80)
	SetMemoryPoolSize("FlagItem", 2)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 175)
	SetMemoryPoolSize("CommandWalker", 2)
	SetMemoryPoolSize("ConnectivityGraphFollower", 56)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 41)
	SetMemoryPoolSize("EntityFlyer", 10)
	SetMemoryPoolSize("EntityLight", 110)
	SetMemoryPoolSize("EntitySoundStatic", 16)
	SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
	SetMemoryPoolSize("MountedTurret", 30)
	SetMemoryPoolSize("Navigator", 63)
	SetMemoryPoolSize("Obstacle", 400)
	SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 160)
	SetMemoryPoolSize("ShieldEffect", 4)
	SetMemoryPoolSize("TreeGridStack", 300)
	SetMemoryPoolSize("UnitController", 63)
	SetMemoryPoolSize("UnitAgent", 63)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    ReadDataFile("dc:RHN\\RHN2.lvl", "rhenvar2_ctf")
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

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_hot_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_hot_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_hot_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_hot_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_hot_amb_end",    2,1)

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
    AddCameraShot(0.850539, -0.178900, 0.483958, 0.101795, -86.326027, 38.517925, -183.721451);
    AddCameraShot(0.078627, 0.003820, -0.995723, 0.048374, -135.321716, 2.409995, -158.555069);
    AddCameraShot(-0.432350, -0.026158, -0.899681, 0.054432, -138.089264, 1.509995, -162.385651);
    AddCameraShot(0.874938, -0.187268, -0.436674, -0.093464, -130.031357, 14.409952, -172.028503);
    AddCameraShot(0.613865, 0.061538, 0.783086, -0.078502, -164.633469, 13.809918, -190.793167);
    AddCameraShot(0.549734, 0.042634, 0.831758, -0.064506, -165.800034, -4.890137, -104.951469);
    AddCameraShot(0.244958, -0.063782, -0.936218, -0.243771, -215.116898, 22.709845, -115.634239);
    AddCameraShot(-0.476847, 0.088768, -0.859726, -0.160043, -224.667496, 22.309845, -159.444931);
    AddCameraShot(-0.190140, -0.010898, -0.980090, 0.056176, -265.228210, 17.909718, -187.942444);
    AddCameraShot(0.983706, 0.100783, -0.148109, 0.015174, -211.531509, 14.309622, -100.224144);
    AddCameraShot(-0.227841, 0.044175, -0.954916, -0.185145, -231.722168, 17.509619, -244.996063);
    AddCameraShot(0.838563, -0.125579, 0.524294, 0.078516, -209.093506, 20.309616, -182.654617);
    AddCameraShot(0.832984, -0.151353, -0.523626, -0.095142, -207.452240, 5.509625, -234.406769);


end
