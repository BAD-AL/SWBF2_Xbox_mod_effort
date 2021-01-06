--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")

--  Republic Attacking (attacker is always #1)
local IMP = 1
local ALL = 2
--  These variables do not change
local ATT = 1
local DEF = 2

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
    EnableSPHeroRules()
    
    SetProperty("ATT_Flag", "GeometryName", "com_icon_imperial_flag")
    SetProperty("ATT_Flag", "CarriedGeometryName", "com_icon_imperial_flag_carried")

    SetProperty("DEF_Flag", "GeometryName", "com_icon_alliance_flag")
    SetProperty("DEF_Flag", "CarriedGeometryName", "com_icon_alliance_flag_carried")
    
	--Set up all the CTF objective stuff 
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,	textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", multiplayerRules = true, hideCPs = true}
	ctf:AddFlag{name = "ATT_Flag", homeRegion = "ATT_home", captureRegion = "DEF_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "DEF_Flag", homeRegion = "DEF_home", captureRegion = "ATT_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

	ctf:Start()

--EntityFlyerInitAsFlying("Cloudy")
--EntityFlyerInitAsFlying("Cloudy1")
--EntityFlyerInitAsFlying("Cloudy4")
  
 end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2097152 + 65536 * 18)
    ReadDataFile("ingame.lvl")

    SetTeamAggressiveness(IMP, 0.95)
    SetTeamAggressiveness(ALL, 0.95)

    SetMaxFlyHeight(-5)
    SetMaxPlayerFlyHeight(-5)

    ReadDataFile("sound\\dea.lvl;dea1gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_urban",
                    "all_inf_rocketeer",
                    "all_inf_engineer",
                    "all_inf_sniper",
                    "all_inf_officer",
                    "all_inf_wookiee",
                    "all_hero_hansolo_tat",
                    "all_hover_combatspeeder")
                
                                
                
     ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_officer",
                    "imp_inf_dark_trooper",                   
                    "imp_hero_bobafett")
                    
	ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser",
    			"tur_bldg_tower")    

    -- set up teams
    SetupTeams{
        imp = {
            team = IMP,
            units = 20,
            reinforcements = 150,
            soldier  = { "imp_inf_rifleman",9, 25},
            assault  = { "imp_inf_rocketeer",1, 4},
            engineer = { "imp_inf_engineer",1, 4},
            sniper   = { "imp_inf_sniper",1, 4},
            officer = {"imp_inf_officer",1, 4},
            special = { "imp_inf_dark_trooper",1, 4},
            
        },
        all = {
            team = ALL,
            units = 20,
            reinforcements = 150,
            soldier  = { "all_inf_rifleman_urban",9, 25},
            assault  = { "all_inf_rocketeer",1, 4},
            engineer = { "all_inf_engineer",1, 4},
            sniper   = { "all_inf_sniper",1, 4},
            officer = {"all_inf_officer",1, 4},
            special = { "all_inf_wookiee",1, 4},
        }
    }

    SetHeroClass(ALL, "all_hero_hansolo_tat")
    
    SetHeroClass(IMP, "imp_hero_bobafett")

   

    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("MountedTurret", 10)
    SetMemoryPoolSize("FlagItem", 2)
--    SetMemoryPoolSize("EntityFlyer", 5)
    SetMemoryPoolSize("Obstacle", 514)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:BES\\bes2.lvl","bespin2_CTF")
    SetDenseEnvironment("true")


    --  Birdies
  --  SetNumBirdTypes(1)
  --  SetBirdType(0,1.0,"bird")
  --  SetBirdFlockMinHeight(-28.0)

    AddDeathRegion("DeathRegion")
    AddDeathRegion("DeathRegion2")

--  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    OpenAudioStream("sound\\dea.lvl",  "dea1")
    -- OpenAudioStream("sound\\cor.lvl",  "dea1gcw_emt")

    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "allleaving")
    SetOutOfBoundsVoiceOver(2, "impleaving")

    SetAmbientMusic(ALL, 1.0, "all_dea_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.9, "all_dea_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.1,"all_dea_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_dea_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.9, "imp_dea_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.1,"imp_dea_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_dea_amb_victory")
    SetDefeatMusic (ALL, "all_dea_amb_defeat")
    SetVictoryMusic(IMP, "imp_dea_amb_victory")
    SetDefeatMusic (IMP, "imp_dea_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --  SetSoundEffect("BirdScatter",         "birdsFlySeq1")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--  Camera Stats
-- Giz Shot
    AddCameraShot(0.879348, -0.142046, 0.448684, 0.072478, -38.413761, 30.986401, 195.879623);
    AddCameraShot(0.755143, 0.032624, 0.654137, -0.028260, -80.924103, -32.534859, 59.805065);
    AddCameraShot(0.596514, -0.068856, -0.794372, -0.091695, -139.203629, -28.934868, 56.316780);
    AddCameraShot(0.073602, -0.011602, -0.985060, -0.155272, -118.288239, -28.934868, 125.938355);
    AddCameraShot(0.902687, 0.001274, 0.430295, -0.000607, -90.957382, -47.834820, 180.831787);
    AddCameraShot(-0.418815, -0.024036, -0.906262, 0.052011, -162.066483, -47.234821, 80.504837);
    AddCameraShot(0.988357, 0.062970, 0.138228, -0.008807, -173.774002, -55.334801, 142.567810);
    AddCameraShot(-0.100554, 0.008160, -0.991639, -0.080476, -246.954437, -31.334862, 153.438812);
    AddCameraShot(0.717164, -0.018075, 0.696449, 0.017553, -216.827194, -31.334862, 186.863648);
    AddCameraShot(0.844850, -0.049702, 0.531770, 0.031284, -247.181458, -45.734825, 29.732487);
    AddCameraShot(0.454881, 0.028302, -0.888384, 0.055273, -291.636658, -48.734818, 21.009203);
    AddCameraShot(0.818322, -0.026150, -0.573874, -0.018339, -193.434647, -58.634792, -12.443044);
    AddCameraShot(0.471109, 0.004691, -0.882018, 0.008783, -192.251679, -61.334786, -32.647247);
end
