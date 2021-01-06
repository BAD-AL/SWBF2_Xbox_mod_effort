--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveOneFlagCTF")

    --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
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
	SoundEvent_SetupTeams( IMP, 'imp', ALL, 'all' )
	
	AddDeathRegion("fall")
    EnableSPHeroRules()
    
    
--CP SETUP for CONQUEST
    --SetObjectTeam("CP3", 1)
    
   KillObject("CP7OBJ")
   KillObject("shieldgen")
   KillObject("CP7OBJ")
   KillObject("hangarcp")
   KillObject("enemyspawn")
   KillObject("enemyspawn2")
   KillObject("echoback2")
   KillObject("echoback1")
   KillObject("shield")	
   DisableBarriers("conquestbar")
   DisableBarriers("bombbar")
   
  SetProperty("ship", "MaxHealth", 1e+37)
  SetProperty("ship", "CurHealth", 1e+37)
  SetProperty("ship2", "MaxHealth", 1e+37)
  SetProperty("ship2", "CurHealth", 1e+37)
  SetProperty("ship3", "MaxHealth", 1e+37)
  SetProperty("ship3", "CurHealth", 1e+37)
    
    

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2", hideCPs = true, multiplayerRules = true, 
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "HomeRegion",
                           captureRegionATT = "Team2Capture", captureRegionDEF = "Team1Capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0}             
                           
    ctf:Start()
    

end

function ScriptInit()
	StealArtistHeap(1280*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4000000)
    ReadDataFile("ingame.lvl")
    


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
--    SetGroundFlyerMap(1);

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_inf_rifleman_snow",
                             "all_inf_rocketeer_snow",
                             "all_inf_engineer_snow",
                             "all_inf_sniper_snow",
                             "all_inf_officer_snow",
                             "all_hero_luke_pilot",
                             "all_inf_wookiee_snow")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_rifleman_snow",
                             "imp_inf_rocketeer_snow",
                             "imp_inf_sniper_snow",
                             "imp_inf_dark_trooper",
                             "imp_inf_engineer_snow",
                             "imp_inf_officer",
                             "imp_hero_darthvader")
ReadDataFile("SIDE\\tur.lvl",
    					"tur_bldg_hoth_dishturret",
						"tur_bldg_hoth_lasermortar",
						"tur_bldg_chaingun_tripod",
						--	"tur_bldg_chaingun",
						"tur_bldg_chaingun_roof")

    SetupTeams{

        all={
            team = ALL,
            units = 32,
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
            units = 32,
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

    SetHeroClass(IMP, "imp_hero_darthvader")
    SetHeroClass(ALL, "all_hero_luke_pilot")
    
   
    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", 0)
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 0) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 0) -- 2 atats with 2 leg pairs each
    
    local weaponCnt = 260
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 300)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 44)
    SetMemoryPoolSize("EntityLight", 240)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 5)
    SetMemoryPoolSize("EntitySoundStatic", 13)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 90)
    SetMemoryPoolSize("MountedTurret", 50)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathNode", 180)
    SetMemoryPoolSize("RedOmniLight", 250)
    SetMemoryPoolSize("TreeGridStack", 350)
    SetMemoryPoolSize("UnitAgent", 46)
    SetMemoryPoolSize("UnitController", 46)
    SetMemoryPoolSize("Weapon", weaponCnt)

    ReadDataFile("HOT\\hot1.lvl", "hoth_ctf")
    --ReadDataFile("tan\\tan1.lvl", "tan1_obj")
    SetSpawnDelay(15.0, 0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    AddDeathRegion("Death")


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
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)


end
