--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

    --  Empire Attacking (attacker is always #1)
    ALL = 1
    IMP = 2
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
    
    hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, pointsPerKillATT = 3, pointsPerKillDEF = 1, textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true}
    
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

    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    
    ReadDataFile("SIDE\\all.lvl",
	"all_inf_rifleman_snow",
	"all_inf_rocketeer_snow",
	"all_inf_engineer_snow",
	"all_inf_sniper_snow",
	"all_inf_officer_snow",
	"all_inf_wookiee_snow")
                             
    ReadDataFile("SIDE\\snw.lvl",
                             "snw_inf_wampa")
                             
    ReadDataFile("SIDE\\tur.lvl",
			"tur_bldg_laser")

   SetupTeams{

        all={
            team = ALL,
            units = 20,
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
            units = 8,
            reinforcements = -1,
            soldier = {"snw_inf_wampa", 8},
        }
    }
    
    SetTeamName(2, "wampa")


--Setting up Heros--

   
       --  Level Stats
	ClearWalkers()
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
	SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 268)
	SetMemoryPoolSize("RedOmniLight", 240)
	SetMemoryPoolSize("TreeGridStack", 329)
	SetMemoryPoolSize("UnitController", 63)
	SetMemoryPoolSize("UnitAgent", 63)
	SetMemoryPoolSize("Weapon", 269)

    ReadDataFile("dc:RHN\\RHN1.lvl","RhenVar1_Hunt")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("true")
    SetDefenderSnipeRange(170)


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
