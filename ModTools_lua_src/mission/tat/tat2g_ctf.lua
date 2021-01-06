--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")

--	These variables do not change
ATT = 1
DEF = 2
--	Empire Attacking (attacker is always #1)
IMP = ATT
ALL = DEF

--PostLoad, this is all done after all loading, etc.
function ScriptPostLoad()
	--Switch the flag appearance(s) for CW vs GCW
    SetProperty("ctf_flag1", "GeometryName", "com_icon_imperial_flag")
    SetProperty("ctf_flag1", "CarriedGeometryName", "com_icon_imperial_flag_carried")

    SetProperty("ctf_flag2", "GeometryName", "com_icon_alliance_flag")
    SetProperty("ctf_flag2", "CarriedGeometryName", "com_icon_alliance_flag_carried")

	
	--Set up all the CTF objective stuff 
	ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5,	textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", multiplayerRules = true, hideCPs = true}
	ctf:AddFlag{name = "ctf_flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
	ctf:AddFlag{name = "ctf_flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}

	SoundEvent_SetupTeams( 1, 'imp', 2, 'all' )

	ctf:Start()
	
	KillObject("CP1")
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	KillObject("CP7")
	KillObject("CP8")
	
	AddAIGoal(3, "Deathmatch", 1000)
end
--------------------------------------------------------------------------
-- FUNCTION:	ScriptInit
-- PURPOSE:	This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:		The name, 'ScriptInit' is a chosen convention, and each
--			mission script must contain a version of this function, as
--			it is called from C to start the mission.
---------------------------------------------------------------------------
function ScriptInit()
	-- Designers, these two lines *MUST* be first!
	SetPS2ModelMemory(2097152 + 65536 * 10)
	ReadDataFile("ingame.lvl")

	--AddMissionObjective(IMP, "red", "level.tat2.objectives.1")
	--	AddMissionObjective(IMP, "orange", "level.tat2.objectives.2")
	--AddMissionObjective(ALL, "red", "level.tat2.objectives.1")
	--	AddMissionObjective(ALL, "orange", "level.tat2.objectives.3")


	SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)

	ReadDataFile("sound\\tat.lvl;tat2gcw")

	ReadDataFile("SIDE\\all.lvl",
				"all_inf_rifleman",
				"all_inf_rocketeer",
				"all_inf_sniper",
				"all_inf_engineer",
				"all_inf_officer",
				"all_inf_wookiee",
				"all_hero_hansolo_tat")
				--"all_bldg_defensegridturret")

	ReadDataFile("SIDE\\imp.lvl",
				"imp_inf_rifleman",
				"imp_inf_rocketeer",
				"imp_inf_engineer",
				"imp_inf_sniper",
				"imp_inf_officer",
				"imp_inf_dark_trooper",
				"imp_hero_bobafett")
				--"imp_bldg_defensegridturret")

    ReadDataFile("SIDE\\des.lvl",
                             "tat_inf_jawa")
 
	ReadDataFile("SIDE\\tur.lvl",
						"tur_bldg_tat_barge",	
						"tur_bldg_laser")	
						
	SetupTeams{
		all = {
			team = ALL,
			units = 28,
			reinforcements = -1,
			soldier	= { "all_inf_rifleman",9, 25},
			assault	= { "all_inf_rocketeer",1,4},
			engineer = { "all_inf_engineer",1,4},
			sniper	= { "all_inf_sniper",1,4},
			officer	= { "all_inf_officer",1,4},
			special	= { "all_inf_wookiee",1,4},

		},
		imp = {
			team = IMP,
			units = 28,
			reinforcements = -1,
			soldier	= { "imp_inf_rifleman",9, 25},
			assault	= { "imp_inf_rocketeer",1,4},
			engineer = { "imp_inf_engineer",1,4},
			sniper	= { "imp_inf_sniper",1,4},
			officer	= { "imp_inf_officer",1,4},
			special	= { "imp_inf_dark_trooper",1,4},
		},
	}

	SetHeroClass(ALL, "all_hero_hansolo_tat")
	SetHeroClass(IMP, "imp_hero_bobafett")

    -- Jawas --------------------------
    SetTeamName (3, "locals")
    AddUnitClass (3, "tat_inf_jawa", 7)
    SetUnitCount (3, 7)
    SetTeamAsFriend(3,ATT)
    SetTeamAsFriend(3,DEF)
    SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(DEF,3)
	-----------------------------------

	ClearWalkers()
	AddWalkerType(0, 0) -- special -> droidekas
	AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
	AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
	AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
	SetMemoryPoolSize("Aimer", 18)
	SetMemoryPoolSize("EntityCloth", 27)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityLight", 40)
	SetMemoryPoolSize("FlagItem", 2)
	SetMemoryPoolSize("MountedTurret", 18)
	SetMemoryPoolSize("Obstacle", 664)
	SetMemoryPoolSize("PathNode", 384)
	SetMemoryPoolSize("TreeGridStack", 450)

	--if(ScriptCB_GetPlatform() == "PS2") then
	--	SetMemoryPoolSize("Obstacle", 640)
	--else
	--	SetMemoryPoolSize("Obstacle", 653)
	--end

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("TAT\\tat2.lvl", "tat2_ctf")
	SetDenseEnvironment("false")
	
	--	Sound Stats
	
	voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
	
	voiceQuick = OpenAudioStream("sound\\global.lvl",	"all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl",	"imp_unit_vo_quick", voiceQuick)	
	
	OpenAudioStream("sound\\global.lvl",	"gcw_music")
	OpenAudioStream("sound\\tat.lvl",	"tat2")
	OpenAudioStream("sound\\tat.lvl",	"tat2")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_quick")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_slow")

	-- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	-- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",	1)
	-- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",	1)
	-- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	-- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(2, "Allleaving")
	SetOutOfBoundsVoiceOver(1, "Impleaving")

	SetAmbientMusic(ALL, 1.0, "all_tat_amb_start",	0,1)
	SetAmbientMusic(ALL, 0.9, "all_tat_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.1, "all_tat_amb_end",	2,1)
	SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start",	0,1)
	SetAmbientMusic(IMP, 0.9, "imp_tat_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.1, "imp_tat_amb_end",	2,1)

	SetVictoryMusic(ALL, "all_tat_amb_victory")
	SetDefeatMusic (ALL, "all_tat_amb_defeat")
	SetVictoryMusic(IMP, "imp_tat_amb_victory")
	SetDefeatMusic (IMP, "imp_tat_amb_defeat")

	SetSoundEffect("ScopeDisplayZoomIn",	"binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--SetSoundEffect("WeaponUnableSelect",	"com_weap_inf_weaponchange_null")
	--SetSoundEffect("WeaponModeUnableSelect",	"com_weap_inf_modechange_null")
	SetSoundEffect("SpawnDisplayUnitChange",		"shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",		"shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",			"shell_menu_exit")


	SetAttackingTeam(ATT)

	--	Camera Stats
	--Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end
