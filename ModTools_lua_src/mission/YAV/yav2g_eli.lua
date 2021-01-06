--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
Conquest = ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams") 
	KillObject ("TempleBlastDoor")
--  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
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
	
	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()
	
	EnableSPHeroRules()
    
 end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!

	StealArtistHeap(1200*1024)

    SetPS2ModelMemory(2600000)
    ReadDataFile("ingame.lvl")
    
   
    SetMaxFlyHeight(-22)
    SetMaxPlayerFlyHeight (-22)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",700)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",700) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",700)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",600)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    
     ReadDataFile("dc:sound\\hero.lvl;herogcw")
     ReadDataFile("sound\\tat.lvl;tat2gcw")
     ReadDataFile("SIDE\\all.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat",
                "all_hero_leia")
                    
    ReadDataFile("SIDE\\imp.lvl",
                "imp_hero_darthvader",
                "imp_hero_emperor",
                "imp_hero_bobafett")
                
    ReadDataFile("SIDE\\rep.lvl",
                "rep_hero_yoda",
                "rep_hero_macewindu",
                "rep_hero_anakin",
                "rep_hero_aalya",
                "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_hero_countdooku",
                "cis_hero_darthmaul",
                "cis_hero_jangofett")
                
    ReadDataFile("dc:SIDE\\dlc.lvl",
                "dlc_hero_fisto",
                "dlc_hero_ventress")    
                    
    ReadDataFile("SIDE\\tur.lvl", 
                "tur_bldg_laser") 
                


--    ReadDataFile("SIDE\\gar.lvl", 
--    			"gar_inf_soldier", 
--    			"gar_inf_vanguard") 

     
     
             

   -- set up teams
    SetupTeams{
        hero = {
            team = ALL,
            units = 12,
                reinforcements = -1,
                soldier = { "all_hero_hansolo_tat",1,2},
                assault = { "all_hero_leia",   1,2},
                engineer= { "all_hero_luke_jedi",   1,2},
                sniper  = { "rep_hero_obiwan",  1,2},
                officer = { "rep_hero_yoda",        1,2},
                special = { "rep_hero_macewindu",   1,2},           
        },
    }   

    AddUnitClass(ALL,"rep_hero_aalya",  1,2)
    AddUnitClass(ALL,"dlc_hero_fisto",1,2)

    SetupTeams{
        villain = {
            team = IMP,
            units = 12,
            reinforcements = -1,
                soldier = { "imp_hero_bobafett",    1,2},
                assault = { "imp_hero_darthvader",1,2},
                engineer= { "cis_hero_darthmaul", 1,2},
                sniper  = { "cis_hero_jangofett", 1,2},
                officer = { "cis_hero_countdooku",    1,2},
                special = { "imp_hero_emperor", 1,2},

        },
    }   
    AddUnitClass(IMP, "rep_hero_anakin",1,2)
    AddUnitClass(IMP, "dlc_hero_ventress",1,2)
   

    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 240
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 7)
    SetMemoryPoolSize("EntityLight", 50)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("MountedTurret", 25)
    SetMemoryPoolSize("Obstacle", 760)
	SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("SoundSpaceRegion", 46)
	SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetMemoryPoolSize("Aimer", 1)
    SetMemoryPoolSize("ConnectivityGraphFollower", 23)
    SetMemoryPoolSize("EntityCloth",41)
    SetMemoryPoolSize("EntityDefenseGridTurret", 0)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityPortableTurret", 0) -- nobody has autoturrets AFAIK - MZ
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 120)
    SetMemoryPoolSize("Navigator", 23)
    SetMemoryPoolSize("Ordnance", 80)	-- not much ordnance going on in the level
    SetMemoryPoolSize("ParticleEmitter", 512)
    SetMemoryPoolSize("ParticleEmitterInfoData", 512)
    SetMemoryPoolSize("PathFollower", 23)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 24)
    SetMemoryPoolSize("TreeGridStack", 290)
    SetMemoryPoolSize("UnitAgent", 23)
    SetMemoryPoolSize("UnitController", 23)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:YAV\\yav2.lvl", "yav2_eli")
    SetDenseEnvironment("false")

    --  Birdies
    SetNumBirdTypes(2)
    SetBirdType(0,1.0,"bird")
    SetBirdType(1,1.5,"bird2")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_tat_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2, "all_tat_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_tat_amb_victory")
    SetDefeatMusic (ALL, "all_tat_amb_defeat")
    SetVictoryMusic(IMP, "imp_tat_amb_victory")
    SetDefeatMusic (IMP, "imp_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
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

