--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

function ScriptPostLoad()
        --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}

	cp6 = CommandPost:New{name = "cp6"}
	cp7 = CommandPost:New{name = "cp7"}
	cp8 = CommandPost:New{name = "cp8"}

    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
	conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)

	conquest:AddCommandPost(cp6)
	conquest:AddCommandPost(cp7)
	conquest:AddCommandPost(cp8)


conquest:Start()
  AddAIGoal(1, "conquest", 1000)
 AddAIGoal(2, "conquest", 1000)
 AddAIGoal(3, "conquest", 1000)
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
    -- Designers, these two lines *MUST* be first!
    StealArtistHeap(256*1024)
    SetPS2ModelMemory(2097152 + 65536 * 10)
    ReadDataFile("ingame.lvl")

    --  Republic Attacking (attacker is always #1)
REP = 1
CIS = 2
DES = 3
    --  These variables do not change
ATT = 1
DEF = 2



    SetTeamAggressiveness(REP, 0.95)
    SetTeamAggressiveness(CIS, 0.95)

    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

    ReadDataFile("sound\\tat.lvl;tat2cw")
    ReadDataFile("SIDE\\rep.lvl",
                        "rep_inf_ep3_rocketeer",
                        "rep_inf_ep3_rifleman",
                        "rep_inf_ep3_sniper",
                        "rep_inf_ep3_engineer",
                        "rep_inf_ep3_jettrooper",
                        "rep_inf_ep3_officer",
                        "rep_hero_obiwan")
                
    ReadDataFile("SIDE\\cis.lvl",
                    "cis_inf_rifleman",
                    "cis_inf_rocketeer",
                    "cis_inf_engineer",
                    "cis_inf_sniper",
                    "cis_inf_officer",
                    "cis_hero_darthmaul",
                    "cis_inf_droideka")
 
    ReadDataFile("SIDE\\des.lvl",
                             "tat_inf_jawa")

	ReadDataFile("SIDE\\tur.lvl",
						"tur_bldg_tat_barge",	
						"tur_bldg_laser")	

    SetAttackingTeam(ATT)

	SetupTeams{
		rep = {
			team = REP,
			units = 28,
			reinforcements = 150,
			soldier	= { "rep_inf_ep3_rifleman",9, 25},
			assault	= { "rep_inf_ep3_rocketeer",1,4},
			engineer = { "rep_inf_ep3_engineer",1,4},
			sniper	= { "rep_inf_ep3_sniper",1,4},
			officer = {"rep_inf_ep3_officer",1,4},
			special = { "rep_inf_ep3_jettrooper",1,4},
			
		},
		cis = {
			team = CIS,
			units = 28,
			reinforcements = 150,
			soldier	= { "cis_inf_rifleman",9, 25},
			assault	= { "cis_inf_rocketeer",1,4},
			engineer = { "cis_inf_engineer",1,4},
			sniper	= { "cis_inf_sniper",1,4},
			officer = {"cis_inf_officer",1,4},
			special = { "cis_inf_droideka",1,4},
		}
	}

    -- Jawas --------------------------
    SetTeamName (3, "locals")
    AddUnitClass (3, "tat_inf_jawa", 7)
    SetUnitCount (3, 7)
    SetTeamAsFriend(3,ATT)
    SetTeamAsFriend(3,DEF)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(DEF,3)
	-----------------------------------
    
    SetHeroClass(CIS, "cis_hero_darthmaul")
      SetHeroClass(REP, "rep_hero_obiwan")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 3) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    local weaponCnt = 230
    SetMemoryPoolSize("Aimer", 23)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 325)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 19)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
    SetMemoryPoolSize("EntityHover", 1)
    SetMemoryPoolSize("EntitySoundStream", 2)
    SetMemoryPoolSize("EntitySoundStatic", 43)
    SetMemoryPoolSize("MountedTurret", 15)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 667)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("TreeGridStack", 325)
    SetMemoryPoolSize("UnitAgent", 50)
    SetMemoryPoolSize("UnitController", 50)
    SetMemoryPoolSize("Weapon", weaponCnt)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("TAT\\tat2.lvl", "tat2_con")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)     
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")

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

    SetAmbientMusic(REP, 1.0, "rep_tat_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_tat_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_tat_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_tat_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_tat_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_tat_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_tat_amb_victory")
    SetDefeatMusic (REP, "rep_tat_amb_defeat")
    SetVictoryMusic(CIS, "cis_tat_amb_victory")
    SetDefeatMusic (CIS, "cis_tat_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)

    --  Camera Stats
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end


