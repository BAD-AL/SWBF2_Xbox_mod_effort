--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

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

	AddDeathRegion("fall")
	
	DisableBarriers("conquestbar")
	DisableBarriers("bombbar")
   --force all the human players onto the attacking side
   
   KillObject("CP7OBJ")
   KillObject("shieldgen")
   KillObject("CP7OBJ")
   KillObject("hangarcp")
   KillObject("enemyspawn")
   KillObject("enemyspawn2")
   KillObject("echoback2")
   KillObject("echoback1")
   KillObject("shield")
  SetProperty("ship", "MaxHealth", 1e+37)
  SetProperty("ship", "CurHealth", 1e+37)
  SetProperty("ship2", "MaxHealth", 1e+37)
  SetProperty("ship2", "CurHealth", 1e+37)
  SetProperty("ship3", "MaxHealth", 1e+37)
  SetProperty("ship3", "CurHealth", 1e+37)
--   SetProperty("echoback1", "MaxHealth", 1500)
--   SetProperty("echoback1", "CurHealth", 1500)
--   SetProperty("echoback2", "MaxHealth", 1500)
--   SetProperty("echoback2", "CurHealth", 1500)
    
    hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 3, textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true}
    
    hunt.OnStart = function(self)
    	AddAIGoal(ATT, "Deathmatch", 1000)
    	AddAIGoal(DEF, "Deathmatch", 1000)
    end
   

	hunt:Start()
    
 end

function ScriptInit()
	if(ScriptCB_GetPlatform() == "PS2") then
        StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    end
    
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(4500000)
    SetPS2ModelMemory(3300000)
    ReadDataFile("ingame.lvl")
    
    --  Empire Attacking (attacker is always #1)
    --local ALL = 2
    --local IMP = 1
    --  These variables do not change
    --local ATT = 1
    --local DEF = 2

    --SetAttackingTeam(ATT)


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)
    SetGroundFlyerMap(1);

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_fly_snowspeeder",
                             "all_inf_rifleman_snow",
                             "all_inf_rocketeer_snow",
                             "all_inf_engineer_snow",
                             "all_inf_sniper_snow",
                             "all_inf_officer_snow",
                             "all_inf_wookiee_snow",
                             "all_walk_tauntaun")
                             
    ReadDataFile("SIDE\\snw.lvl",
                             "snw_inf_wampa")
                             
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
            soldier = {"all_inf_rifleman_snow"},
            assault = {"all_inf_rocketeer_snow"},
            engineer   = {"all_inf_engineer_snow"},
            sniper  = {"all_inf_sniper_snow"},
            officer = {"all_inf_officer_snow"},
            special = {"all_inf_wookiee_snow"},
            
        },
        
        wampa={
            team = IMP,
            units = 32,
            reinforcements = -1,
            soldier = {"snw_inf_wampa", 8},
        }
    }


--Setting up Heros--

    
   
       --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -2)
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 5) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

    SetMemoryPoolSize("Aimer", 90)
    SetMemoryPoolSize("AmmoCounter", 269)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("CommandWalker", 2)
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", 269)
	SetMemoryPoolSize("EntityCloth", 28)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityLight", 225)
    SetMemoryPoolSize("EntitySoundStatic", 16)
    SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 46)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 400)
  SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 268)
	SetMemoryPoolSize("RedOmniLight", 240)
    SetMemoryPoolSize("TreeGridStack", 329)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", 269)

    ReadDataFile("HOT\\hot1.lvl", "hoth_hunt")
    --ReadDataFile("tan\\tan1.lvl", "tan1_obj")
    SetSpawnDelay(10.0, 0.25)
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

    -- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .75, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .5, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .25, 1)

    -- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    -- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    -- SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_hot_amb_hunt",  0,1)
    -- SetAmbientMusic(ALL, 0.9, "all_hot_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.1, "all_hot_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_hot_amb_hunt",  0,1)
    -- SetAmbientMusic(IMP, 0.9, "imp_hot_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.1, "imp_hot_amb_end",    2,1)

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
