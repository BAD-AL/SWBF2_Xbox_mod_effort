---
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
	SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )

    ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
                           textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
                           captureLimit = 8, flag = "flag", flagIcon = "flag_icon", 
                           flagIconScale = 3.0, homeRegion = "team1_capture",
                           captureRegionATT = "team1_capture", captureRegionDEF = "team2_capture",
                           capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
                           capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true}
    ctf:Start()

     EnableSPHeroRules()
     
 end
 
 function ScriptInit()
    StealArtistHeap(256*1024)
    -- Designers, these two lines *MUST* be first.
    SetPS2ModelMemory(2497152 + 65536 * 0)
    ReadDataFile("ingame.lvl")
    
    ReadDataFile("sound\\geo.lvl;geo1cw")

	SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",20)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",300)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",300) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",300)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",150)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",1800)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",50)
    
    SetMaxFlyHeight(30)
    SetMaxPlayerFlyHeight(30)

    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper", 
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                "cis_inf_officer",
                "cis_inf_sniper",
                "cis_inf_droideka",
                "cis_hero_darthmaul")
                
		ReadDataFile("dc:SIDE\\dlc.lvl",
                "dlc_hero_fisto")                
   
       ReadDataFile("SIDE\\tur.lvl",
        "tur_bldg_laser")
        
   SetupTeams{
        rep = {
            team = REP,
            units = 20,
            reinforcements = 150,
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
            reinforcements = 150,
            soldier = { "cis_inf_rifleman",9, 25},
            assault = { "cis_inf_rocketeer",1,4},
            engineer = { "cis_inf_engineer",1,4},
            sniper  = { "cis_inf_sniper",1,4},
            officer = {"cis_inf_officer",1,4},
            special = { "cis_inf_droideka",1,4},
        }
    }

    SetHeroClass(REP, "dlc_hero_fisto")
    SetHeroClass(CIS, "cis_hero_darthmaul")
    
       --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4) -- 0 droidekas
    AddWalkerType(1, 5) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	local weaponCnt = 221
	SetMemoryPoolSize("Aimer", 80)
	SetMemoryPoolSize("FlagItem", 2)
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
	SetMemoryPoolSize("PathFollower", 63)
	SetMemoryPoolSize("PathNode", 160)
	SetMemoryPoolSize("ShieldEffect", 4)
	SetMemoryPoolSize("TreeGridStack", 300)
	SetMemoryPoolSize("UnitController", 63)
	SetMemoryPoolSize("UnitAgent", 63)
	SetMemoryPoolSize("Weapon", weaponCnt)

     ReadDataFile("dc:RHN\\RHN2.lvl", "rhenvar2_1flag")
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("true")
    SetDefenderSnipeRange(170)
    AddDeathRegion("FalltoDeath")
        
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

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_GEO_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2, "rep_GEO_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_GEO_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2, "cis_GEO_amb_end",    2,1)

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
    --Rhen Var 2 Citadel
    --Statue
    AddCameraShot(0.994005, -0.109073, 0.007486, 0.000821, -203.097900, 26.624817, -101.682487)
    --Steps
    AddCameraShot(0.104328, -0.022317, -0.972296, -0.207984, -266.398132, 24.953222, -251.513596)
    --Terrace
    AddCameraShot(0.908227, 0.026135, 0.417489, -0.012014, -101.176414, 12.784149, -199.053940)


end


