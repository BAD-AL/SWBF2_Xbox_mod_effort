--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
    Conquest = ScriptCB_DoFile("ObjectiveConquest")
    ScriptCB_DoFile("setup_teams") 

--  Empire Attacking (attacker is always #1)
    CIS = 1
    REP = 2
    GAR = 3
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
	DisableBarriers("cambar1")
	DisableBarriers("cambar2")
	DisableBarriers("cambar3")
	DisableBarriers("turbar1")
	DisableBarriers("turbar2")
	DisableBarriers("turbar3")
	DisableBarriers("camveh")
    SetMapNorthAngle(180, 1)
    AddAIGoal (GAR, "Deathmatch", 100)
 
	AICanCaptureCP("CP1", GAR, false)
	AICanCaptureCP("CP2", GAR, false)
	AICanCaptureCP("CP3", GAR, false)
	AICanCaptureCP("CP4", GAR, false)
	AICanCaptureCP("CP5", GAR, false)
	AICanCaptureCP("CP6", GAR, false)
   
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "CP1"}
    cp2 = CommandPost:New{name = "CP2"}
    cp3 = CommandPost:New{name = "CP3"}
    cp4 = CommandPost:New{name = "CP4"}
    cp5 = CommandPost:New{name = "CP5"}
    cp6 = CommandPost:New{name = "CP6"}
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
  
  
    
    conquest:Start()   
    EnableSPHeroRules()
end

function ScriptInit()
    StealArtistHeap(1200*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3100000)
    ReadDataFile("ingame.lvl")

   

    ReadDataFile("sound\\nab.lvl;nab2cw")
     ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_rifleman",
                "rep_inf_ep3_rocketeer",
                "rep_inf_ep3_engineer",
                "rep_inf_ep3_sniper", 
                "rep_inf_ep3_officer",
                "rep_inf_ep3_jettrooper",
                "rep_hero_obiwan",
                "rep_walk_oneman_atst")
                
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_rocketeer",
                "cis_inf_engineer",
                  "cis_inf_sniper",
                  "cis_inf_officer",
                "cis_inf_droideka",
                "cis_hero_darthmaul",
                "cis_hover_aat")
                
    ReadDataFile("SIDE\\tur.lvl", 
                "tur_bldg_laser")
                
                          
--    ReadDataFile("SIDE\\gar.lvl", 
--    			"gar_inf_soldier", 
--    			"gar_inf_vanguard") 

    SetupTeams{
        rep = {
            team = REP,
            units = 32,
            reinforcements = 150,
            soldier  = { "rep_inf_ep3_rifleman",9, 25},
            assault  = { "rep_inf_ep3_rocketeer",1, 4},
            engineer = { "rep_inf_ep3_engineer",1, 4},
            sniper   = { "rep_inf_ep3_sniper",1, 4},
            officer = {"rep_inf_ep3_officer",1, 4},
            special = { "rep_inf_ep3_jettrooper",1, 4},
            
        }
    }
    SetupTeams{ 
        cis = {
            team = CIS,
            units = 32,
            reinforcements = 150,
            soldier  = { "cis_inf_rifleman",9, 25},
            assault  = { "cis_inf_rocketeer",1, 4},
            engineer = { "cis_inf_engineer",1, 4},
            sniper   = { "cis_inf_sniper",1, 4},
            officer = {"cis_inf_officer",1, 4},
            special = { "cis_inf_droideka",1, 4},
        }
    }
--    SetupTeams{ 
--        gar = {
--            team = GAR,
--            units = 5,
--            reinforcements = -1,
--           soldier  = { "gar_inf_soldier",6},
--            assault  = { "gar_inf_vanguard",5},
--        }
--    }
    

    SetHeroClass(CIS, "cis_hero_darthmaul")
    SetHeroClass(REP, "rep_hero_obiwan")
    
--    SetTeamAsEnemy(GAR, ATT)
--    SetTeamAsEnemy(ATT, GAR)
--       
--    
--    SetTeamAsFriend(GAR, DEF)
--    SetTeamAsFriend(DEF, GAR)

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- 8 droidekas with 0 leg pairs each
    AddWalkerType(1, 3) -- ATSTs
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 50)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 128)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 18)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 44)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("MountedTurret", 11)
    SetMemoryPoolSize("Navigator", 40)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 40)
    SetMemoryPoolSize("PathNode", 200)
    SetMemoryPoolSize("TreeGridStack", 400)
    SetMemoryPoolSize("UnitAgent", 40)
    SetMemoryPoolSize("UnitController", 40)
    SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6)   
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("NAB\\nab2.lvl","naboo2_Conquest")
    SetDenseEnvironment("true")
    --AddDeathRegion("Water")
    AddDeathRegion("Waterfall")
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight (25)

    

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)     
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\nab.lvl",  "nab2")
    OpenAudioStream("sound\\nab.lvl",  "nab2")
    OpenAudioStream("sound\\nab.lvl",  "nab2_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
    
    SetLowReinforcementsVoiceOver(REP, REP, "rep_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(REP, CIS, "rep_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, CIS, "cis_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(CIS, REP, "cis_off_victory_im", .1, 1)    

    SetOutOfBoundsVoiceOver(2, "repleaving")
    SetOutOfBoundsVoiceOver(1, "cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_nab_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_nab_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_nab_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_nab_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_nab_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_nab_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_nab_amb_victory")
    SetDefeatMusic (REP, "rep_nab_amb_defeat")
    SetVictoryMusic(CIS, "cis_nab_amb_victory")
    SetDefeatMusic (CIS, "cis_nab_amb_defeat")

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
    --Nab2 Theed
    --Palace
    AddCameraShot(0.038177, -0.005598, -0.988683, -0.144973, -0.985535, 18.617458, -123.316505);
    AddCameraShot(0.993106, -0.109389, 0.041873, 0.004612, 6.576932, 24.040697, -25.576218);
    AddCameraShot(0.851509, -0.170480, 0.486202, 0.097342, 158.767715, 22.913860, -0.438658);
    AddCameraShot(0.957371, -0.129655, -0.255793, -0.034641, 136.933548, 20.207420, 99.608246);
    AddCameraShot(0.930364, -0.206197, 0.295979, 0.065598, 102.191856, 22.665434, 92.389435);
    AddCameraShot(0.997665, -0.068271, 0.002086, 0.000143, 88.042351, 13.869274, 93.643898);
    AddCameraShot(0.968900, -0.100622, 0.224862, 0.023352, 4.245263, 13.869274, 97.208542);
    AddCameraShot(0.007091, -0.000363, -0.998669, -0.051089, -1.309990, 16.247049, 15.925866);
    AddCameraShot(-0.274816, 0.042768, -0.949121, -0.147705, -55.505108, 25.990822, 86.987534);
    AddCameraShot(0.859651, -0.229225, 0.441156, 0.117634, -62.493008, 31.040747, 117.995369);
    AddCameraShot(0.703838, -0.055939, 0.705928, 0.056106, -120.401054, 23.573559, -15.484946);
    AddCameraShot(0.835474, -0.181318, -0.506954, -0.110021, -166.314774, 27.687098, -6.715797);
    AddCameraShot(0.327573, -0.024828, -0.941798, -0.071382, -109.700180, 15.415476, -84.413605);
    AddCameraShot(-0.400505, 0.030208, -0.913203, -0.068878, 82.372711, 15.415476, -42.439548);
    
    end

