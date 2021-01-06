----
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
Conquest = ScriptCB_DoFile("ObjectiveTDM")

function ScriptPostLoad()
 
 
 	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()
	
	
    EnableSPHeroRules()
    
    
    
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
    
     --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2

    --SetAttackingTeam(ATT)


    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

	ReadDataFile("dc:sound\\hero.lvl;herogcw")
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  

    ReadDataFile("SIDE\\all.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat")
                --"all_hero_chewbacca")
                    
    ReadDataFile("SIDE\\imp.lvl",
                "imp_hero_darthvader",
--                "imp_hero_emperor",
                "imp_hero_bobafett")
                
    ReadDataFile("SIDE\\rep.lvl",
                "rep_hero_yoda",
                "rep_hero_kiyadimundi",
                "rep_hero_anakin",
                "rep_hero_aalya",
                "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                --"cis_hero_grievous",
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
                --assault = { "all_hero_chewbacca",   1,2},
                engineer= { "all_hero_luke_jedi",   1,2},
                sniper  = { "rep_hero_obiwan",  1,2},
                officer = { "rep_hero_yoda",        1,2},
                special = { "rep_hero_kiyadimundi",   1,2},           
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
                --officer = { "cis_hero_grievous",    1,2},
                --special = { "imp_hero_emperor", 1,2},

        },
    }   
    AddUnitClass(IMP, "rep_hero_anakin",1,2)
    AddUnitClass(IMP, "dlc_hero_ventress",1,2)
    
   

       --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4) -- 0 droidekas
    AddWalkerType(1, 5) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 221
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 175)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 10)
	SetMemoryPoolSize("EntityLight", 110)
	SetMemoryPoolSize("EntitySoundStatic", 16)
	SetMemoryPoolSize("EntitySoundStream", 5)
	SetMemoryPoolSize("MountedTurret", 30)
	SetMemoryPoolSize("Obstacle", 400)
	SetMemoryPoolSize("PathNode", 160)
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
    
    ReadDataFile("dc:RHN\\RHN2.lvl", "rhenvar2_eli")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("true")
    SetDefenderSnipeRange(170)
    AddDeathRegion("FalltoDeath")
    
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
