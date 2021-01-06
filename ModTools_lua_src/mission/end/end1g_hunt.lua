--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("ObjectiveTDM")
-- load the gametype script
--	Empire Attacking(attacker is always #1)
IMP = 1
ALL = 2
--	These variables do not change
ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()	
	hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2,
						pointsPerKillATT = 1, pointsPerKillDEF = 1,
						textATT = "level.end1.objectives.hunt",
						textDEF = "game.modes.hunt2", multiplayerRules = true}	
	hunt:Start()
	
	AddAIGoal(ATT, "Deathmatch", 1000)
	AddAIGoal(DEF, "Deathmatch", 1000)
	
	
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
	-- Designers, these two lines *MUST* be first.
	SetPS2ModelMemory(2860000)
	ReadDataFile("ingame.lvl")
	
	ReadDataFile("sound\\end.lvl;end1gcw")

	SetWorldExtents(1277.3)

	SetTeamAggressiveness(ALL, 1.0)
	SetTeamAggressiveness(IMP, 0.7)

	SetMaxFlyHeight(43)
	SetMaxPlayerFlyHeight(43)

	ReadDataFile("SIDE\\imp.lvl",
				"imp_inf_sniper")
				
	ReadDataFile("SIDE\\ewk.lvl",
						"ewk_inf_basic")

	--	Attacker Stats
	SetUnitCount(ATT, 32)
	SetReinforcementCount(ATT, -1)
	
	--	Defender Stats
	SetUnitCount(DEF, 32)
	SetReinforcementCount(DEF, -1)

 --	Alliance Stats
	SetTeamName(ALL, "Ewoks")
	SetTeamIcon(ALL, "all_icon")
	AddUnitClass(ALL, "ewk_inf_trooper",12)
--	AddUnitClass(ALL, "ewk_inf_repair",8)
	AddUnitClass(ALL, "ewk_inf_scout",12)

	--	Imperial Stats
	SetTeamName(IMP, "Empire")
	SetTeamIcon(IMP, "imp_icon")
	AddUnitClass(IMP, "imp_inf_sniper",22)
	
	--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(1, 3) -- 8 droidekas(special case: 0 leg pairs)
	AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
	AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
	SetMemoryPoolSize("ActiveRegion", 4)
	SetMemoryPoolSize("Aimer", 24)
	SetMemoryPoolSize("AmmoCounter", 211)
	SetMemoryPoolSize("BaseHint", 225)
	SetMemoryPoolSize("EnergyBar", 211)
	SetMemoryPoolSize("EntityHover", 9)
	SetMemoryPoolSize("EntityLight", 20)
	SetMemoryPoolSize("EntitySoundStream", 4)
	SetMemoryPoolSize("EntitySoundStatic", 95)
	SetMemoryPoolSize("MountedTurret", 3)
	SetMemoryPoolSize("Navigator", 59)
	SetMemoryPoolSize("Obstacle", 745)
	SetMemoryPoolSize("PathFollower", 59)
	SetMemoryPoolSize("PathNode", 100)
	SetMemoryPoolSize("SoundSpaceRegion", 6)
	SetMemoryPoolSize("TreeGridStack", 587)
	SetMemoryPoolSize("UnitAgent", 59)
	SetMemoryPoolSize("UnitController", 59)
	SetMemoryPoolSize("Weapon", 211)

	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("end\\end1.lvl", "end1_hunt")
	SetDenseEnvironment("true")
	AddDeathRegion("deathregion")
	SetStayInTurrets(1)

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

	-- SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	-- SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",	1)
	-- SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",	1)
	-- SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	-- SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	-- SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(2, "allleaving")
	SetOutOfBoundsVoiceOver(1, "impleaving")

	SetAmbientMusic(ALL, 1.0, "all_end_amb_hunt",	0,1)
	-- SetAmbientMusic(ALL, 0.9, "all_end_amb_middle", 1,1)
	-- SetAmbientMusic(ALL, 0.1,"all_end_amb_end",	2,1)
	SetAmbientMusic(IMP, 1.0, "imp_end_amb_hunt",	0,1)
	-- SetAmbientMusic(IMP, 0.9, "imp_end_amb_middle", 1,1)
	-- SetAmbientMusic(IMP, 0.1,"imp_end_amb_end",	2,1)

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