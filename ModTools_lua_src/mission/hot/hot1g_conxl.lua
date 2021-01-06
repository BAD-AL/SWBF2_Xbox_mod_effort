--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

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
	DisableBarriers("atat")
	DisableBarriers("bombbar")

    --CP SETUP for CONQUEST
--    SetProperty("shield", "MaxHealth", 222600.0)
--  	SetProperty("shield", "CurHealth", 222600.0)
    SetObjectTeam("CP3", 1)
    SetObjectTeam("CP6", 1)
    KillObject("CP7")
 
    EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP3"}
    cp2 = CommandPost:New{name = "CP4"}
    cp3 = CommandPost:New{name = "CP5"}
    cp4 = CommandPost:New{name = "CP6"}
--    cp5 = CommandPost:New{name = "CP7"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
--    conquest:AddCommandPost(cp5)
    
    conquest:Start()
    
--    KillObject("shield");
    
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
                             "all_hero_luke_pilot",
                             "all_inf_wookiee_snow",
                             "all_walk_tauntaun")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_rifleman_snow",
                             "imp_inf_rocketeer_snow",
                             "imp_inf_sniper_snow",
                             "imp_inf_dark_trooper",
                             "imp_inf_engineer_snow",
                             "imp_inf_officer",
                             "imp_hero_darthvader",
                             "imp_walk_atat",
                             "imp_walk_atst_snow")
                             
    ReadDataFile("SIDE\\tur.lvl",
						     "tur_bldg_hoth_dishturret",
						     "tur_bldg_hoth_lasermortar")

    SetupTeams{

        all={
            team = ALL,
            units = 32,
            reinforcements = 150,
            soldier = {"all_inf_rifleman_snow",15, 45},
            assault = {"all_inf_rocketeer_snow",3, 6},
            engineer   = {"all_inf_engineer_snow",3, 6},
            sniper  = {"all_inf_sniper_snow",3, 6},
            officer = {"all_inf_officer_snow",3, 6},
            special = {"all_inf_wookiee_snow",3, 6},
            
        },
        
        imp={
            team = IMP,
            units = 32,
            reinforcements = 150,
            soldier = {"imp_inf_rifleman_snow",15, 45},
            assault = {"imp_inf_rocketeer_snow",3, 6},
            engineer   = {"imp_inf_engineer_snow",3, 6},
            sniper  = {"imp_inf_sniper_snow",3, 6},
            officer = {"imp_inf_officer",3, 6},
            special = {"imp_inf_dark_trooper",3, 6},
        }
    }


--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_darthvader")
    SetHeroClass(ALL, "all_hero_luke_pilot")
    
   
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
    SetMemoryPoolSize("EntityLight", 110)
    SetMemoryPoolSize("EntitySoundStatic", 16)
    SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 30)
    SetMemoryPoolSize("Navigator", 63)
    SetMemoryPoolSize("Obstacle", 400)
	SetMemoryPoolSize("OrdnanceTowCable", 4) -- need extra for wrapped/fallen cables
    SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 128)
	SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitController", 63)
    SetMemoryPoolSize("UnitAgent", 63)
    SetMemoryPoolSize("Weapon", weaponCnt)

    ReadDataFile("HOT\\hot1.lvl", "hoth_conquest")
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
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Battlefield
    AddCameraShot(0.927083, 0.020456, -0.374206, 0.008257, -333.221558, 0.676043, -14.027348)


end
