--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveTDM")

    --  Imp Attacking (attacker is always #1)
    ALL = 1
    IMP = 2
    --  These variables do not change
    ATT = 1
    DEF = 2
    
    WookieTeam= 3

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
	EnableSPHeroRules()
 	-- This is the actual objective setup
	TDM = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, 
						multiplayerScoreLimit = 100,
						textATT = "game.modes.tdm",
						textDEF = "game.modes.tdm2", 
						multiplayerRules = true,
						isUberMode = true,
						uberScoreLimit = 350,
						}
	TDM:Start()

    AddAIGoal(1, "Deathmatch", 100)
    AddAIGoal(2, "Deathmatch", 100)
    AddAIGoal(ALL, "Defend", 30, "gatepanel")
	AddAIGoal(IMP, "Destroy", 30, "gatepanel")
	AddAIGoal(IMP, "Destroy", 10, "woodl")
	AddAIGoal(IMP, "Destroy", 10, "woodc")
	AddAIGoal(IMP, "Destroy", 10, "woodr")
	AddAIGoal(ALL, "Defend", 10, "woodl")
	AddAIGoal(ALL, "Defend", 10, "woodc")
	AddAIGoal(ALL, "Defend", 10, "woodr")
    
--    TDM.OnStart = function(self)
--    	ctf.goal1 = AddAIGoal(ALL, "Defend", 30, "gatepanel")
--		ctf.goal2 = AddAIGoal(IMP, "Destroy", 30, "gatepanel")
--		ctf.goal3 = AddAIGoal(IMP, "Destroy", 10, "woodl")
--		ctf.goal4 = AddAIGoal(IMP, "Destroy", 10, "woodc")
--		ctf.goal5 = AddAIGoal(IMP, "Destroy", 10, "woodr")
--		ctf.goal6 = AddAIGoal(ALL, "Defend", 10, "woodl")
--		ctf.goal7 = AddAIGoal(ALL, "Defend", 10, "woodc")
--		ctf.goal8 = AddAIGoal(ALL, "Defend", 10, "woodr")
--	end
    
    --Gate Stuff -- 
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme");
    
    SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodl", "CurHealth", 15000)
    SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodr", "CurHealth", 15000)
    SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("woodc", "CurHealth", 15000)
    SetProperty("gatepanel", "MaxHealth", 1000)
    SetProperty("gatepanel", "CurHealth", 1000)
    
    
     OnObjectKillName(PlayAnimDown, "gatepanel");
     OnObjectRespawnName(PlayAnimUp, "gatepanel");
     OnObjectKillName(woodl, "woodl");
     OnObjectKillName(woodc, "woodc");
     OnObjectKillName(woodr, "woodr");
     OnObjectRespawnName(woodlr, "woodl");
     OnObjectRespawnName(woodcr, "woodc");
     OnObjectRespawnName(woodrr, "woodr");
 end
 
 function PlayAnimDown()
    PauseAnimation("thegateup");
    RewindAnimation("thegatedown");
    PlayAnimation("thegatedown");
    ShowMessageText("level.kas2.objectives.gateopen",1)
    ScriptCB_SndPlaySound("KAS_obj_13")
    SetProperty("gatepanel", "MaxHealth", 2200)
--    SetProperty("gatepanel", "CurHealth", 50000)
--    PlayAnimation("gatepanel");
    --SetProperty("gatepanel", "MaxHealth", 1e+37)
    --SetProperty("gatepanel", "CurHealth", 1e+37)
      
            
   -- Allowing AI to run under gate   
    UnblockPlanningGraphArcs("seawall1");
    DisableBarriers("seawalldoor1");
    DisableBarriers("vehicleblocker");
      
end

function PlayAnimUp()
    PauseAnimation("thegatedown");
    RewindAnimation("thegateup");
    PlayAnimation("thegateup");
      
            
   -- Allowing AI to run under gate   
    BlockPlanningGraphArcs("seawall1");
    EnableBarriers("seawalldoor1");
    EnableBarriers("vehicleblocker");
    SetProperty("gatepanel", "MaxHealth", 1000)
    SetProperty("gatepanel", "CurHealth", 1000)
      
end

function woodl()
    UnblockPlanningGraphArcs("woodl");
    DisableBarriers("woodl");
    SetProperty("woodl", "MaxHealth", 1800)
--    SetProperty("woodl", "CurHealth", 15)
end
    
function woodc()
    UnblockPlanningGraphArcs("woodc");
    DisableBarriers("woodc");
    SetProperty("woodc", "MaxHealth", 1800)
--    SetProperty("woodc", "CurHealth", 15)
end
    
function woodr()
    UnblockPlanningGraphArcs("woodr");
    DisableBarriers("woodr");
    SetProperty("woodr", "MaxHealth", 1800)
--    SetProperty("woodr", "CurHealth", 15)
end

function woodlr()
	BlockPlanningGraphArcs("woodl")
	EnableBarriers("woodl")
	SetProperty("woodl", "MaxHealth", 15000)
    SetProperty("woodl", "CurHealth", 15000)
end
	
function woodcr()
	BlockPlanningGraphArcs("woodc")
	EnableBarriers("woodc")
	SetProperty("woodc", "MaxHealth", 15000)
    SetProperty("woodc", "CurHealth", 15000)
end

function woodrr()
	BlockPlanningGraphArcs("woodr")
	EnableBarriers("woodr")
	SetProperty("woodr", "MaxHealth", 15000)
    SetProperty("woodr", "CurHealth", 15000)
end

function ScriptInit()
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(3550000)
    
    SetUberMode(1);
    
    ReadDataFile("ingame.lvl")


    SetMaxFlyHeight(70)


    ReadDataFile("sound\\kas.lvl;kas2gcw")
    ReadDataFile("SIDE\\all.lvl",
                    "all_inf_rifleman_jungle",
                    "all_inf_rocketeer_jungle",
                    "all_inf_sniper_jungle",
                    "all_inf_engineer",
                    "all_inf_officer",
                    "all_hover_combatspeeder",
                    "all_hero_chewbacca",
                    "all_inf_wookiee")
    ReadDataFile("SIDE\\imp.lvl",
                    "imp_inf_rifleman",
                    "imp_inf_rocketeer",
                    "imp_inf_engineer",
                    "imp_inf_sniper",
                    "imp_inf_dark_trooper",
                    "imp_hover_fightertank",
                    "imp_hover_speederbike",
                    "imp_inf_officer",
                    --"imp_walk_atst",
                    "imp_hero_bobafett")
    ReadDataFile("SIDE\\wok.lvl",
                             "wok_inf_basic")
                             
	ReadDataFile("SIDE\\tur.lvl",
							"tur_bldg_beam",
							"tur_bldg_recoilless_kas")

    
    SetupTeams{

        all={
            team = ALL,
            units = 160,
            reinforcements = -1,
            soldier = {"all_inf_rifleman_jungle",10, 40},
            assault = {"all_inf_rocketeer_jungle",1, 30},
            engineer = {"all_inf_engineer",1, 30},
            sniper  = {"all_inf_sniper_jungle",1, 20},
            officer = {"all_inf_officer",1, 20},
            special = {"all_inf_wookiee",1, 20},
            
        },
        
        imp={
            team = IMP,
            units = 160,
            reinforcements = -1,
            soldier = {"imp_inf_rifleman",10, 40},
            assault = {"imp_inf_rocketeer",1, 30},
            engineer = {"imp_inf_engineer",1, 30},
            sniper  = {"imp_inf_sniper",1, 20},
            officer = {"imp_inf_officer",1, 20},
            special = {"imp_inf_dark_trooper",1, 20},
        }
    }

    --  Alliance Stats
    SetHeroClass(ALL, "all_hero_chewbacca")

    --    Imperial Stats
    SetHeroClass(IMP, "imp_hero_bobafett")


	SetTeamName(3, "locals")
    SetTeamIcon(3, "all_icon")
    AddUnitClass(3, "wok_inf_warrior",2)
    AddUnitClass(3, "wok_inf_rocketeer",2)
    AddUnitClass(3, "wok_inf_mechanic",1)
    

    SetUnitCount(3, 5)
	AddAIGoal(WookieTeam, "Deathmatch", 100)
	SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(3,ATT)
    SetTeamAsEnemy(DEF,3)
    SetTeamAsEnemy(3,DEF)  

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) --
    AddWalkerType(2, 3) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each

    SetMemoryPoolSize("Aimer", 100)
	SetMemoryPoolSize("EntityCloth", 37)
    SetMemoryPoolSize("EntityLight", 44)
    SetMemoryPoolSize("EntityHover", 11)
    SetMemoryPoolSize("EntityFlyer", 7)
    SetMemoryPoolSize("EntitySoundStream", 3)
    SetMemoryPoolSize("MountedTurret", 25)
    SetMemoryPoolSize("Obstacle", 600)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 20)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Weapon", 300)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAS\\kas2.lvl", "kas2_xl")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish") 
    
--  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick) 
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "Allleaving")
    SetOutOfBoundsVoiceOver(2, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_kas_amb_start",  0,1)
    SetAmbientMusic(ALL, 0.8, "all_kas_amb_middle", 1,1)
    SetAmbientMusic(ALL, 0.2,"all_kas_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "imp_kas_amb_start",  0,1)
    SetAmbientMusic(IMP, 0.8, "imp_kas_amb_middle", 1,1)
    SetAmbientMusic(IMP, 0.2,"imp_kas_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_kas_amb_victory")
    SetDefeatMusic (ALL, "all_kas_amb_defeat")
    SetVictoryMusic(IMP, "imp_kas_amb_victory")
    SetDefeatMusic (IMP, "imp_kas_amb_defeat")

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

    --Kas2 Docks
    --Wide beach shot
	AddCameraShot(0.977642, -0.052163, -0.203414, -0.010853, 66.539520, 21.864969, 168.598495);
	AddCameraShot(0.969455, -0.011915, 0.244960, 0.003011, 219.552948, 21.864969, 177.675674);
	AddCameraShot(0.995040, -0.013447, 0.098558, 0.001332, 133.571289, 16.216759, 121.571236);
	AddCameraShot(0.350433, -0.049725, -0.925991, -0.131394, 30.085188, 32.105236, -105.325264);



-- GOOD SHOTS -- 
	-- Gate to Right


--Kinda Cool -- 
	
    AddCameraShot(0.163369, -0.029669, -0.970249, -0.176203, 85.474831, 47.313362, -156.345627);
	AddCameraShot(0.091112, -0.011521, -0.987907, -0.124920, 97.554062, 53.690968, -179.347076);
	AddCameraShot(0.964953, -0.059962, 0.254988, 0.015845, 246.471008, 20.362143, 153.701050);  



end

