--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveOneFlagCTF")
ScriptCB_DoFile("setup_teams")

---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
	ctf = ObjectiveOneFlagCTF:New{teamATT = 1, teamDEF = 2,
							textATT = "game.modes.1flag", textDEF = "game.modes.1flag2",
							captureLimit = 5, flag = "flag", flagIcon = "flag_icon", 
							flagIconScale = 3.0, homeRegion = "team1_capture",
							capRegionWorldATT = "com_bldg_ctfbase", capRegionWorldDEF = "com_bldg_ctfbase1",
							captureRegionATT = "team1_capture", captureRegionDEF = "team2_capture",
							capRegionMarkerATT = "hud_objective_icon_circle", capRegionMarkerDEF = "hud_objective_icon_circle",
							capRegionMarkerScaleATT = 3.0, capRegionMarkerScaleDEF = 3.0, multiplayerRules = true, hideCPs = true}
	SoundEvent_SetupTeams( 2, 'imp', 1, 'all' )
	ctf:Start()
	EnableSPHeroRules()
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
	StealArtistHeap(2048*1024)
	
	-- Designers, these two lines *MUST* be first.
	SetPS2ModelMemory(2460000)
	ReadDataFile("ingame.lvl")
	
	SetWorldExtents(1277.3)

	local ALL = 1
	local IMP = 2

	local ATT = 1
	local DEF = 2
	
	ReadDataFile("sound\\end.lvl;end1gcw")

	SetTeamAggressiveness(ALL, 1.0)
	SetTeamAggressiveness(IMP, 0.7)

	SetMaxFlyHeight(43)
	SetMaxPlayerFlyHeight(43)

	ReadDataFile("SIDE\\all.lvl",
					"all_inf_rifleman_jungle",
					"all_inf_rocketeer_jungle",
					"all_inf_engineer_jungle",
					"all_inf_sniper_jungle",
					"all_inf_officer_jungle",
					"all_hero_hansolo_tat",
					"all_inf_wookiee")
	
	ReadDataFile("SIDE\\imp.lvl",
					"imp_inf_rifleman",
					"imp_inf_rocketeer",
					"imp_inf_engineer",
					"imp_inf_sniper",
					"imp_inf_officer",
					"imp_inf_dark_trooper",					
					"imp_hero_darthvader",
					"imp_hover_speederbike",
					"imp_walk_atst_jungle")
					
	ReadDataFile("SIDE\\tur.lvl",
				"tur_bldg_laser")	

	ReadDataFile("SIDE\\ewk.lvl",
				"ewk_inf_basic")

	SetupTeams{
		all = {
			team = ALL,
			units = 29,
			reinforcements = -1,
			soldier	= { "all_inf_rifleman_jungle",10, 25},
			assault	= { "all_inf_rocketeer_jungle",1,4},
			engineer = { "all_inf_engineer_jungle",1,4},
			sniper	= { "all_inf_sniper_jungle",1,4},
			officer = {"all_inf_officer_jungle",1,4},
			special = { "all_inf_wookiee",1,4},
		},	
		imp = {
			team = IMP,
			units = 29,
			reinforcements = -1,
			soldier	= { "imp_inf_rifleman",10, 25},
			assault	= { "imp_inf_rocketeer",1,4},
			engineer = { "imp_inf_engineer",1,4},
			sniper	= { "imp_inf_sniper",1,4},
			officer = {"imp_inf_officer",1,4},
			special = { "imp_inf_dark_trooper",1,4},
		}
	}
	
	SetHeroClass(ALL, "all_hero_hansolo_tat")
	SetHeroClass(DEF, "imp_hero_darthvader")

	--	Local Stats
	SetTeamName(3, "locals")
	AddUnitClass(3, "ewk_inf_trooper", 3)
	AddUnitClass(3, "ewk_inf_repair", 3)
	SetUnitCount(3, 6)
	
	SetTeamAsFriend(3,ATT)
	SetTeamAsEnemy(3,DEF)

	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(1, 3) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
	AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
	
	local weaponCnt = 220
	SetMemoryPoolSize("ActiveRegion", 4)
	SetMemoryPoolSize("Aimer", 27)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 100)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityHover", 9)
	SetMemoryPoolSize("EntityLight", 25)
	SetMemoryPoolSize("EntitySoundStatic", 95)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("MountedTurret", 6)
	SetMemoryPoolSize("Navigator", 39)
	SetMemoryPoolSize("Obstacle", 745)
	SetMemoryPoolSize("PathFollower", 39)
	SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoundSpaceRegion", 6)
	SetMemoryPoolSize("TreeGridStack", 587)
	SetMemoryPoolSize("UnitAgent", 39)
	SetMemoryPoolSize("UnitController", 39)
	SetMemoryPoolSize("Weapon", weaponCnt)
	SetMemoryPoolSize("FlagItem", 1)
	
	--	Attacker Stats
	SetTeamAsFriend(ATT, 3)


	--	Defender Stats
	SetTeamAsEnemy(DEF, 3)

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("end\\end1.lvl", "end1_1flag")
	SetDenseEnvironment("true")
	AddDeathRegion("deathregion")
	SetStayInTurrets(1)


	--	Movies
	--	SetVictoryMovie(ALL, "all_end_victory")
	--	SetDefeatMovie(ALL, "imp_end_victory")
	--	SetVictoryMovie(IMP, "imp_end_victory")
	--	SetDefeatMovie(IMP, "all_end_victory")

	--	Sound
	
	voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
	
	voiceQuick = OpenAudioStream("sound\\global.lvl",	"all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl",	"imp_unit_vo_quick", voiceQuick)
	
	OpenAudioStream("sound\\global.lvl",	"gcw_music")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_quick")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_slow")
	OpenAudioStream("sound\\end.lvl",	"end1gcw")
	OpenAudioStream("sound\\end.lvl",	"end1gcw")
	OpenAudioStream("sound\\end.lvl",	"end1gcw_emt")

	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(1, "allleaving")
	SetOutOfBoundsVoiceOver(2, "impleaving")

	SetAmbientMusic(ALL, 1.0, "all_end_amb_start",	0,1)
	SetAmbientMusic(ALL, 0.99, "all_end_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.1,"all_end_amb_end",	2,1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_start",	0,1)
	SetAmbientMusic(IMP, 0.99, "imp_end_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.1,"imp_end_amb_end",	2,1)

	SetVictoryMusic(ALL, "all_end_amb_victory")
	SetDefeatMusic(ALL, "all_end_amb_defeat")
	SetVictoryMusic(IMP, "imp_end_amb_victory")
	SetDefeatMusic(IMP, "imp_end_amb_defeat")

	SetSoundEffect("ScopeDisplayZoomIn",	"binocularzoomin")
	SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
	--	SetSoundEffect("BirdScatter",		"birdsFlySeq1")
	SetSoundEffect("SpawnDisplayUnitChange",		"shell_select_unit")
	SetSoundEffect("SpawnDisplayUnitAccept",		"shell_menu_enter")
	SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
	SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
	SetSoundEffect("SpawnDisplayBack",			"shell_menu_exit")


	SetAttackingTeam(ATT)

	--Endor
	--Shield Bunker
	AddCameraShot(0.997654, 0.066982, 0.014139, -0.000949, 155.137131, 0.911505, -138.077072)
	--Village
	AddCameraShot(0.729761, 0.019262, 0.683194, -0.018033, -98.584869, 0.295284, 263.239288)
	--Village
	AddCameraShot(0.694277, 0.005100, 0.719671, -0.005287, -11.105947, -2.753207, 67.982201)
end

