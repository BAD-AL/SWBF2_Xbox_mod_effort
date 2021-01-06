--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")


	--	Republic Attacking (attacker is always #1)
IMP = 1
ALL = 2
	--	These variables do not change
ATT = 1
DEF = 2

---------------------------------------------------------------------------
-- ScriptPostLoad
---------------------------------------------------------------------------
function ScriptPostLoad()
		--This defines the CPs.	These need to happen first
	cp1 = CommandPost:New{name = "cp1"}
	cp2 = CommandPost:New{name = "cp2"}
	cp3 = CommandPost:New{name = "cp3"}
	cp4 = CommandPost:New{name = "cp4"}
	cp5 = CommandPost:New{name = "cp5"}
	
	--This sets up the actual objective.	This needs to happen after cp's are defined
	conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
	
	--This adds the CPs to the objective.	This needs to happen after the objective is set up
	conquest:AddCommandPost(cp1)
	conquest:AddCommandPost(cp2)
	conquest:AddCommandPost(cp3)
	conquest:AddCommandPost(cp4)
	conquest:AddCommandPost(cp5)
	
	conquest:Start()
 
	EnableSPHeroRules()
end

---------------------------------------------------------------------------
-- ScriptInit
---------------------------------------------------------------------------
function ScriptInit()
    StealArtistHeap(950*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3997152)
    ReadDataFile("ingame.lvl")

	-- Memory settings ---------------------------------------------------------------------
	local weaponCnt = 220
    SetMemoryPoolSize ("Combo::Transition",75) -- should be a bit bigger than #Combo::State
	SetMemoryPoolSize("Aimer", 0)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
	SetMemoryPoolSize("BaseHint", 105)
	SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 22)
	SetMemoryPoolSize("EntityFlyer", 6) -- to account for rocket upgrade
	SetMemoryPoolSize("EntityLight", 145)
	SetMemoryPoolSize("EntitySoundStream", 2)
	SetMemoryPoolSize("EntitySoundStatic", 3)
	SetMemoryPoolSize("MountedTurret", 0)
	SetMemoryPoolSize("Navigator", 35)
	SetMemoryPoolSize("Obstacle", 202)
	SetMemoryPoolSize("PathFollower", 35)
	SetMemoryPoolSize("RedOmniLight", 150)
	SetMemoryPoolSize("PathNode", 256)
	SetMemoryPoolSize("ShieldEffect", 0)
	SetMemoryPoolSize("SoundSpaceRegion", 80)
	SetMemoryPoolSize("TentacleSimulator", 12)
	SetMemoryPoolSize("TreeGridStack", 80)
	SetMemoryPoolSize("UnitAgent", 35)
	SetMemoryPoolSize("UnitController", 35)
	SetMemoryPoolSize("Weapon", weaponCnt)
	----------------------------------------------------------------------------------------

	ReadDataFile("sound\\tat.lvl;tat3gcw")
	ReadDataFile("SIDE\\all.lvl",
					"all_inf_rifleman",
					"all_inf_rocketeer",
					"all_inf_engineer",
					"all_inf_sniper",
					"all_inf_officer",
					"all_inf_wookiee",
					"all_hero_luke_jedi")
	ReadDataFile("SIDE\\imp.lvl",
					"imp_inf_rifleman",
					"imp_inf_rocketeer",
					"imp_inf_engineer",
					"imp_inf_sniper",
					"imp_inf_officer",
					"imp_inf_dark_trooper",					
					"imp_hero_bobafett")


	---[[ Gamorrean Guards
	ReadDataFile("SIDE\\gam.lvl",
		"gam_inf_gamorreanguard")
	SetTeamName(3, "locals")
	AddUnitClass(3, "gam_inf_gamorreanguard",3)
	SetUnitCount(3, 2)
	SetTeamAsEnemy(3, ATT)
	SetTeamAsEnemy(3, DEF) 
	SetTeamAsEnemy(ATT, 3)
	SetTeamAsEnemy(DEF, 3)
	AddAIGoal(3,"Deathmatch",100)
	--]]


	SetupTeams{
		all = {
			team = ALL,
			units = 30,
			reinforcements = 150,
			soldier	= { "all_inf_rifleman",7, 25},
			assault	= { "all_inf_rocketeer",1,4},
			engineer = { "all_inf_engineer",1,4},
			sniper	= { "all_inf_sniper",1,4},
			officer	= { "all_inf_officer",1,4},
			special	= { "all_inf_wookiee",1,4},

		},
		imp = {
			team = IMP,
			units = 30,
			reinforcements = 150,
			soldier	= { "imp_inf_rifleman",7, 25},
			assault	= { "imp_inf_rocketeer",1,4},
			engineer = { "imp_inf_engineer",1,4},
			sniper	= { "imp_inf_sniper",1,4},
			officer	= { "imp_inf_officer",1,4},
			special	= { "imp_inf_dark_trooper",1,4},
		},
	}
		
	SetHeroClass(ALL, "all_hero_luke_jedi")
	SetHeroClass(IMP, "imp_hero_bobafett")

		--	Level Stats
	ClearWalkers()
	AddWalkerType(0, 0)
	AddWalkerType(1, 0)
	AddWalkerType(2, 0)


	SetSpawnDelay(10.0, 0.25)
	ReadDataFile("TAT\\tat3.lvl", "tat3_con")
	SetDenseEnvironment("true")
	--AddDeathRegion("Sarlac01")
	SetMaxFlyHeight(90)
	SetMaxPlayerFlyHeight(90)
    AISnipeSuitabilityDist(30)


	--	Sound Stats
	
	voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
	AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "gam_unit_vo_slow", voiceSlow)
	AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
	
	voiceQuick = OpenAudioStream("sound\\global.lvl",	"all_unit_vo_quick")
	AudioStreamAppendSegments("sound\\global.lvl",	"imp_unit_vo_quick", voiceQuick)	
	
	OpenAudioStream("sound\\global.lvl",	"gcw_music")
	OpenAudioStream("sound\\tat.lvl",	"tat3")
	OpenAudioStream("sound\\tat.lvl",	"tat3")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_quick")
	-- OpenAudioStream("sound\\global.lvl",	"global_vo_slow")
	OpenAudioStream("sound\\tat.lvl",	"tat3_emt")

	SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
	SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",	1)
	SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

	SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
	SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

	SetOutOfBoundsVoiceOver(2, "Allleaving")
	SetOutOfBoundsVoiceOver(1, "Impleaving")

	SetAmbientMusic(ALL, 1.0, "all_tat_amb_start",	0,1)
	SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
	SetAmbientMusic(ALL, 0.2, "all_tat_amb_end",	2,1)
	SetAmbientMusic(IMP, 1.0, "imp_tat_amb_start",	0,1)
	SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
	SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end",	2,1)

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



	--	Camera Stats
	--Tat 3 - Jabbas' Palace
	AddCameraShot(0.685601, -0.253606, -0.639994, -0.236735, -65.939224, -0.176558, 127.400444)
	AddCameraShot(0.786944, 0.050288, -0.613719, 0.039218, -80.626396, 1.175180, 133.205551)
	AddCameraShot(0.997982, 0.061865, -0.014249, 0.000883, -65.227898, 1.322798, 123.976990)
	AddCameraShot(-0.367869, -0.027819, -0.926815, 0.070087, -19.548307, -5.736280, 163.360519)
	AddCameraShot(0.773980, -0.100127, -0.620077, -0.080217, -61.123989, -0.629283, 176.066025)
	AddCameraShot(0.978189, 0.012077, 0.207350, -0.002560, -88.388947, 5.674968, 153.745255)
	AddCameraShot(-0.144606, -0.010301, -0.986935, 0.070304, -106.872772, 2.066469, 102.783096)
	AddCameraShot(0.926756, -0.228578, -0.289446, -0.071390, -60.819584, -2.117482, 96.400620)
	AddCameraShot(0.873080, 0.134285, 0.463274, -0.071254, -52.071609, -8.430746, 67.122437)
	AddCameraShot(0.773398, -0.022789, -0.633236, -0.018659, -32.738083, -7.379394, 81.508003)
	AddCameraShot(0.090190, 0.005601, -0.993994, 0.061733, -15.379695, -9.939115, 72.110054)
	AddCameraShot(0.971737, -0.118739, -0.202524, -0.024747, -16.591295, -1.371236, 147.933029)
	AddCameraShot(0.894918, 0.098682, -0.432560, 0.047698, -20.577391, -10.683214, 128.752563)

end
