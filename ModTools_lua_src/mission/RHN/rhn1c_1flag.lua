--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

--  Empire Attacking (attacker is always #1)
     REP = 1
     CIS = 2
     --  These variables do not change
     ATT = 1
     DEF = 2

 --PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()

	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "flag_home",
                           captureRegionATT = "t2_home", captureRegionDEF = "t1_home",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}

    ctf:Start()
    
    EnableSPHeroRules()
        
end
---
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
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
    StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(2497152 + 65536 * 0)
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
    ReadDataFile("sound\\geo.lvl;geo1cw")

    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper", 
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_walk_atte",
                "rep_hover_fightertank")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_officer",
                "cis_inf_sniper",
                "cis_inf_droideka",
                "cis_hover_aat")
   
       ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_laser")
        
            ReadDataFile("dc:SIDE\\dlc.lvl",
                "dlc_hero_fisto",
                "dlc_hero_ventress")
        
   SetupTeams{
        rep = {
            team = REP,
            units = 20,
            reinforcements = -1,
            soldier = { "rep_inf_ep3_rifleman",9, 25},
            assault = { "rep_inf_ep3_rocketeer",1,4},
            engineer = { "rep_inf_ep3_engineer",1,4},
            sniper  = { "rep_inf_ep3_sniper",1,4},
            officer = {"rep_inf_ep3_officer",1,4},
            special = { "rep_inf_ep3_jettrooper",1,4},
            
        },
        cis = {
            team = CIS,
            units = 20,
            reinforcements = -1,
            soldier = { "cis_inf_rifleman",9, 25},
            assault = { "cis_inf_rocketeer",1,4},
            engineer = { "cis_inf_engineer",1,4},
            sniper  = { "cis_inf_sniper",1,4},
            officer = {"cis_inf_officer",1,4},
            special = { "cis_inf_droideka",1,4},
        }
    }

    SetHeroClass(REP, "dlc_hero_fisto")
    SetHeroClass(CIS, "dlc_hero_ventress")

--  Level Stats
    ClearWalkers()
    SetMemoryPoolSize ("EntityWalker",-1)
    AddWalkerType(0, 12) -- 12 droidekas
    AddWalkerType(1, 0) -- 0 atsts with 1 leg pairs each
    AddWalkerType(2, 0) -- 0 atats with 2 leg pairs each
    AddWalkerType(3, 1) -- 2 attes with 3 leg pairs each
    SetMemoryPoolSize("Commandwalker", 1)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("MountedTurret", 48)
    SetMemoryPoolSize("PowerupItem", 60)
    SetMemoryPoolSize("EntityMine", 40)
    SetMemoryPoolSize("Weapon", 280)
    ReadDataFile("dc:RHN\\RHN1.lvl", "RhenVar1_CTF")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
--  AddDeathRegion("Death");

--  AI
    SetAIVehicleNotifyRadius(80)
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)   

--  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_GEO_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_GEO_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_GEO_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_GEO_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_geo_amb_victory")
    SetDefeatMusic (REP, "rep_geo_amb_defeat")
    SetVictoryMusic(CIS, "cis_geo_amb_victory")
    SetDefeatMusic (CIS, "cis_geo_amb_defeat")

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
