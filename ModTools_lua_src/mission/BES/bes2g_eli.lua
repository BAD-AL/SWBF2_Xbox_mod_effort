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
 
    
function ScriptPostLoad()
		EnableSPHeroRules()
		
		-- This is the actual objective setup
	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()
               
--EntityFlyerInitAsFlying("Cloudy")
--EntityFlyerInitAsFlying("Cloudy1")
--EntityFlyerInitAsFlying("Cloudy4")
 end
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(4030000)
    ReadDataFile("ingame.lvl")
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",30)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",500)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",500) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",500)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",400)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",4000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",88)     -- should be ~1x #combo
   
    
    ReadDataFile("dc:sound\\hero.lvl;herogcw")
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    SetMapNorthAngle(180, 1)
    SetMaxFlyHeight(-5)
    SetMaxPlayerFlyHeight(-5)
    AISnipeSuitabilityDist(30)
    
     ReadDataFile("SIDE\\all.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat")
                --"all_hero_leia")
                    
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
                "cis_hero_grievous",
                "cis_hero_darthmaul",
                "cis_hero_jangofett")
                
    ReadDataFile("dc:SIDE\\dlc.lvl",
                "dlc_hero_fisto",
                "dlc_hero_ventress")    
                    
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser")          

   -- set up teams
    SetupTeams{
        hero = {
            team = ALL,
            units = 12,
                reinforcements = -1,
                soldier = { "all_hero_hansolo_tat",1,2},
                --assault = { "all_hero_leia",   1,2},
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
                officer = { "cis_hero_grievous",    1,2},
                special = { "imp_hero_emperor", 1,2},

        },
    }   
    AddUnitClass(IMP, "rep_hero_anakin",1,2)
    AddUnitClass(IMP, "dlc_hero_ventress",1,2)
    

    -- SetTeamAsEnemy(DEF, 3)

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) -- 
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local guyCnt = 50
    
	local weaponCnt = 96
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityLight", 96)
    SetMemoryPoolSize("MountedTurret", 13)
    SetMemoryPoolSize("PathFollower", guyCnt)
    SetMemoryPoolSize("Navigator", guyCnt)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetMemoryPoolSize("TreeGridStack", 256)
    SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("Aimer", 1)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 320)
    SetMemoryPoolSize("ConnectivityGraphFollower", 23)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
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
    SetMemoryPoolSize("UnitAgent", 23)
    SetMemoryPoolSize("UnitController", 23)
    SetMemoryPoolSize("Weapon", weaponCnt)  

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("dc:bes\\bes2.lvl","bespin2_Celeb")
    SetDenseEnvironment("True")
      -- SetMaxFlyHeight(25)
     --SetMaxPlayerFlyHeight (25)
    AddDeathRegion("DeathRegion")
    AddDeathRegion("DeathRegion2")



    --  Movies
    --  SetVictoryMovie(ALL, "all_end_victory")
    --  SetDefeatMovie(ALL, "imp_end_victory")
    --  SetVictoryMovie(IMP, "imp_end_victory")
    --  SetDefeatMovie(IMP, "all_end_victory")

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

