--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--[[ -------- Modder's Note -----------------
    Pandemic's Battlefront II Mission Scripting Guide:
        https://sites.google.com/site/swbf2modtoolsdocumentation/battlefront-ii-mission-lua-guide 
]]


--[[ -------- Modder's Note -----------------
    Alternate Addon assetLocation logic.
    See YouTube Video chapter: 
        https://www.youtube.com/watch?v=LVhKMDW22AY&t=3758s 

    https://github.com/Gametoast/AltAddonSystem
]]
assetLocation = "DC:"
if( ScriptCB_IsFileExist("addon\\013\\mission.lvl") == 1 ) then
    assetLocation = "addon\\013\\"
end 


ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

	--  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    local ATT = 1
    local DEF = 2
    
function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    
    
    
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
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)
    
    conquest:Start()

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
    ReadDataFile(assetLocation .. "Load\\ama.lvl")
    ReadDataFile("ingame.lvl")


    SetMaxFlyHeight(40)
	SetMaxPlayerFlyHeight(40)


    --[[  ------------------ Modder's note ------------------------
        This block of SetMemoryPoolSize set the memory pool sizes for various things for Jedi, 
        and other heroes in the map.  The ClothData sets how many cloth objects can be in the 
        level at one time.  The Combo:: pools set up various attack, and combo values for the 
        jedi.  You’ll notice these values are set much higher in the Hero Assault scripts.
    ]]
	--SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    
    
    
    ReadDataFile("sound\\dag.lvl;dag1gcw") -- it's got what we need. Luke, Vader, water, grass...
    
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
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
                    "imp_hero_darthvader",
                    "imp_fly_destroyer_dome" )
 
	SetupTeams{
		all = {
			team = ALL,
			units = 20,
			reinforcements = 150,
			soldier	= { "all_inf_rifleman"},
			assault	= { "all_inf_rocketeer"},
			engineer = { "all_inf_engineer"},
			sniper	= { "all_inf_sniper"},
			officer	= { "all_inf_officer"},
			special	= { "all_inf_wookiee"},

		},
		imp = {
			team = IMP,
			units = 20,
			reinforcements = 150,
			soldier	= { "imp_inf_rifleman"},
			assault	= { "imp_inf_rocketeer"},
			engineer = { "imp_inf_engineer"},
			sniper	= { "imp_inf_sniper"},
			officer	= { "imp_inf_officer"},
			special	= { "imp_inf_dark_trooper"},
		},
	}
    
    SetHeroClass(ALL, "all_hero_luke_jedi")
    SetHeroClass(IMP, "imp_hero_darthvader")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    
    --[[ ------------------ Modder's note ------------------------
        Memory pool settings for this map & game mode.

        See the following YouTube Video chapter for method of setting Memory Pools:
            https://www.youtube.com/watch?v=LVhKMDW22AY&t=1882s
    ]]
    local weaponCnt = 220
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt) 
    SetMemoryPoolSize("BaseHint", 50)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 10)
    SetMemoryPoolSize("EntityHover", 10)
    SetMemoryPoolSize("EntityLight", 10)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 4)
    SetMemoryPoolSize("MountedTurret", 20)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 220)
	SetMemoryPoolSize("PathNode", 80) 
    SetMemoryPoolSize("SoundSpaceRegion", 4)
    SetMemoryPoolSize("TreeGridStack", 512)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
	SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("SoldierAnimation", 350)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile(assetLocation .. "AMA\\AMA.lvl", "AMA_conquest")
    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\dag.lvl",  "dag1")
    OpenAudioStream("sound\\dag.lvl",  "dag1")
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

    -- from: 
    --  https://github.com/Gametoast/SWBF2-Lua-API/blob/master/API/LuaDevelopmentTools/Battlefront2API.doclua
    --------------------------------------------------------------
    -- Sets the ambient music to play for players on the specified team.
    -- 
    -- @param #int playerTeam			Player's team number
    -- @param #int reinforcementCount	Reinforcement count of the player's team which triggers the specified music
    -- @param #string musicName			Name of the music configuration (from 'xxx_music.mus' file)
    -- @param #int gameStage			Value from 0 to 2, where 0 = beginning, 1 = middle, and 2 = end
    -- @param #int isPercentage			Optional argument which when set to 1 treats reinforcementCount as a fraction (`0.0..1.0`) of maximum reinforcements
    -- function SetAmbientMusic(playerTeam, reinforcementCount, musicName, gameStage, isPercentage) end
    --------------------------------------------------------------
    SetAmbientMusic(ALL, 1.0, "all_dag_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_dag_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2,"all_dag_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_dag_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_dag_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2,"imp_dag_amb_end",    2,1)

    -- SetVictoryMusic(playerTeam, musicName)
    SetVictoryMusic(ALL, "all_dag_amb_victory")
    SetDefeatMusic (ALL, "all_dag_amb_defeat")
    SetVictoryMusic(IMP, "imp_dag_amb_victory")
    SetDefeatMusic (IMP, "imp_dag_amb_defeat")

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
    --Tat2 Mos Eisley
	AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
	AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);
end
