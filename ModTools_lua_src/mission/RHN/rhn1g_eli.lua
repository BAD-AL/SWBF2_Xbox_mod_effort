--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
Conquest = ScriptCB_DoFile("ObjectiveTDM")
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

	-- This is the actual objective setup
	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", multiplayerRules = true, isCelebrityDeathmatch = true}
	TDM:Start()
	
	
    EnableSPHeroRules()
    
end

function ScriptInit()
    StealArtistHeap(1800*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2097152 + 65536 * 10)
    ReadDataFile("ingame.lvl")

	SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  

	ReadDataFile("dc:sound\\hero.lvl;herogcw")
    ReadDataFile("sound\\tat.lvl;tat2gcw")
     ReadDataFile("SIDE\\all.lvl",
                "all_hero_luke_jedi",
                "all_hero_hansolo_tat",
                "all_hero_chewbacca")
                    
    ReadDataFile("SIDE\\imp.lvl",
                "imp_hero_darthvader",
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
                assault = { "all_hero_chewbacca",   1,2},
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
                --special = { "cis_hero_countdooku", 1,2},

        },
    }   
    AddUnitClass(IMP, "rep_hero_anakin",1,2)
    AddUnitClass(IMP, "dlc_hero_ventress",1,2)
   
    --  Level Stats
    ClearWalkers()
    local weaponCnt = 96
    SetMemoryPoolSize("Aimer", 1)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 128)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 45)
    SetMemoryPoolSize("MountedTurret", 17)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 8)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 5)   
    SetMemoryPoolSize("Aimer", 1)
    SetMemoryPoolSize("ConnectivityGraphFollower", 23)
    SetMemoryPoolSize("EntityCloth",41)
    SetMemoryPoolSize("EntityDefenseGridTurret", 0)
    SetMemoryPoolSize("EntityDroid", 0)
    SetMemoryPoolSize("EntityLight", 80, 80) -- stupid trickery to actually set lights to 80
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

     ReadDataFile("dc:RHN\\RHN1.lvl","RhenVar1_celeb")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("true")
    SetDefenderSnipeRange(170)
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

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
