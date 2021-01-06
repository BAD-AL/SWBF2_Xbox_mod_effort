--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script -- 
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

    --  Republic Attacking (attacker is always #1)
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
 
    DisableBarriers("dropship")
    DisableBarriers("shield_03")
    DisableBarriers("shield_02")
    DisableBarriers("shield_01")
    DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
    DisableBarriers("coresh1")

    EnableSPHeroRules()
    
    cp1 = CommandPost:New{name = "CP1_CON"}
    cp2 = CommandPost:New{name = "CP2_CON"}
    --cp3 = CommandPost:New{name = "CP3_CON"}
    cp4 = CommandPost:New{name = "CP4_CON"}
    cp5 = CommandPost:New{name = "CP5_CON"}
    cp7 = CommandPost:New{name = "CP7_CON"}
    --cp8 = CommandPost:New{name = "CP8_CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    --conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp7)
    --conquest:AddCommandPost(cp8)
    
    conquest:Start()
    
end
 
function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(2048 * 1024)
    SetPS2ModelMemory(4000000)
    ReadDataFile("ingame.lvl")

   ReadDataFile("sound\\myg.lvl;myg1cw")

        ReadDataFile("SIDE\\rep.lvl",
                             --"rep_fly_assault_dome",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_fly_gunship_dome",
                             "rep_hover_fightertank",
                             "rep_hero_kiyadimundi")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_hover_aat",
                             "cis_fly_gunship_dome",
                             "cis_inf_officer",
                             "cis_inf_droideka",
                             "cis_hero_grievous")
                             
    ReadDataFile("SIDE\\tur.lvl",
    						"tur_bldg_recoilless_lg")


    SetupTeams{

        rep={
            team = REP,
            units = 32,
            reinforcements = 150,
            soldier = {"rep_inf_ep3_rifleman", 9, 25},
            assault = {"rep_inf_ep3_rocketeer", 1, 4},
            engineer = {"rep_inf_ep3_engineer", 1, 4},
            sniper  = {"rep_inf_ep3_sniper", 1, 4},
            officer = {"rep_inf_ep3_officer", 1, 4},
            special = {"rep_inf_ep3_jettrooper", 1, 4},
            
            
        },
        
        cis={
            team = CIS,
            units = 32,
            reinforcements = 150,
            soldier = {"cis_inf_rifleman", 9, 25},
            assault = {"cis_inf_rocketeer", 1, 4},
            engineer = {"cis_inf_engineer", 1, 4},
            sniper  = {"cis_inf_sniper", 1, 4},
            officer   = {"cis_inf_officer", 1, 4},
            special = {"cis_inf_droideka", 1, 4},
        }
    }


        --  Hero Setup Section  --

		SetHeroClass(REP, "rep_hero_kiyadimundi")
		SetHeroClass(CIS, "cis_hero_grievous")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 60)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 19)
    SetMemoryPoolSize("EntityHover", 7)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("MountedTurret", 16)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 500)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("TreeGridStack", 275)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("myg\\myg1.lvl", "myg1_conquest")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\myg.lvl",  "myg1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_myg_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_myg_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_myg_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_myg_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_myg_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


        --Camera Shizzle--
        
        -- Collector Shot
    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090);
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359);
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212);
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887);
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128);
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712);
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550);
end


