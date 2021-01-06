--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

    --  Empire Attacking (attacker is always #1)
    REP = 1
    CIS = 2
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

	AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
 
    EnableSPHeroRules()
    
    --CP SETUP for CONQUEST
    
    cp1 = CommandPost:New{name = "CP1CON"}
    cp3 = CommandPost:New{name = "CP3CON"}
    cp4 = CommandPost:New{name = "CP4CON"}
    cp5 = CommandPost:New{name = "CP5CON"}
    
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, textATT = "game.modes.con", textDEF = "game.modes.con2", multiplayerRules = true}
    
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)
    conquest:AddCommandPost(cp5)
    
    conquest.OnStart = function(self)
    	conquest.goal1 = AddAIGoal(REP, "Defend", 30, "gatepanel")
		conquest.goal2 = AddAIGoal(CIS, "Destroy", 30, "gatepanel")
		conquest.goal3 = AddAIGoal(CIS, "Destroy", 10, "woodl")
		conquest.goal4 = AddAIGoal(CIS, "Destroy", 10, "woodc")
		conquest.goal5 = AddAIGoal(CIS, "Destroy", 10, "woodr")
		conquest.goal6 = AddAIGoal(REP, "Defend", 10, "woodl")
		conquest.goal7 = AddAIGoal(REP, "Defend", 10, "woodc")
		conquest.goal8 = AddAIGoal(REP, "Defend", 10, "woodr")
	end
    
    conquest:Start()
    
    --Gate Stuff -- 
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme");
    
    SetProperty("woodl", "MaxHealth", 150000)
    SetProperty("woodl", "CurHealth", 150000)
    SetProperty("woodr", "MaxHealth", 150000)
    SetProperty("woodr", "CurHealth", 150000)
    SetProperty("woodc", "MaxHealth", 150000)
    SetProperty("woodc", "CurHealth", 150000)
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
    StealArtistHeap(800 * 1024)
    SetPS2ModelMemory(3535000)
    ReadDataFile("ingame.lvl")
    
	SetUberMode(1);
    SetMaxFlyHeight(70)

    ReadDataFile("sound\\kas.lvl;kas2cw")
    ReadDataFile("SIDE\\rep.lvl",
                                 "rep_inf_ep3_rifleman",
                                 "rep_inf_ep3_rocketeer",
                                "rep_inf_ep3_sniper_felucia",
                                "rep_inf_ep3_engineer",
                                "rep_inf_ep3_jettrooper",
                                "rep_inf_ep3_officer",
                                "rep_hero_yoda",
                                "rep_hover_fightertank",
                                "rep_fly_cat_dome",
                                "rep_hover_barcspeeder")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_tread_snailtank",
                             "cis_inf_rifleman",
--                             "cis_fly_gunship_dome",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_hover_stap",
                             "cis_inf_officer",
--                             "cis_walk_spider",
                             "cis_hero_jangofett",
                             "cis_inf_droideka")
    ReadDataFile("SIDE\\wok.lvl",
                             "wok_inf_basic")	

	ReadDataFile("SIDE\\tur.lvl",
							"tur_bldg_beam",
							"tur_bldg_recoilless_kas")
							
    SetupTeams{

        rep={
            team = REP,
            units = 50,
            reinforcements = 51,
            soldier = {"rep_inf_ep3_rifleman",10, 30},
            assault = {"rep_inf_ep3_rocketeer",1, 5},
            engineer = {"rep_inf_ep3_engineer",1, 5},
            sniper  = {"rep_inf_ep3_sniper_felucia",1, 5},
            officer = {"rep_inf_ep3_officer",1, 5},
            special = {"rep_inf_ep3_jettrooper",1, 10},
            
            
        },
        
        cis={
            team = CIS,
            units = 250,
            reinforcements = 251,
            soldier = {"cis_inf_rifleman",10, 150},
            assault = {"cis_inf_rocketeer",1, 35},
            engineer = {"cis_inf_engineer",1, 25},
            sniper  = {"cis_inf_sniper",1, 5},
            officer   = {"cis_inf_officer",1, 20},
            special = {"cis_inf_droideka",1, 15},
        }
    }
            
    SetHeroClass(REP, "rep_hero_yoda")

    SetHeroClass(CIS, "cis_hero_jangofett")
            
	SetTeamName(3, "locals")
    SetTeamIcon(3, "all_icon")
    AddUnitClass(3, "wok_inf_warrior",100)
    AddUnitClass(3, "wok_inf_rocketeer",85)
    AddUnitClass(3, "wok_inf_mechanic",15)
    

    SetUnitCount(3, 200)
	AddAIGoal(WookieTeam, "Deathmatch", 100)
	SetTeamAsFriend(ATT,3)
    SetTeamAsFriend(3,ATT)
    SetTeamAsEnemy(DEF,3)
    SetTeamAsEnemy(3,DEF)  

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 25) -- 4 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) --
--    AddWalkerType(2, 2) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 2300
    local unitCnt = 500
    SetMemoryPoolSize("Aimer", 150)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 220)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityHover", 60)
    SetMemoryPoolSize("EntityLight", 40)
    SetMemoryPoolSize("EntityCloth", 58)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntitySoundStream", 3)
    SetMemoryPoolSize("EntitySoundStatic", 120)
    SetMemoryPoolSize("MountedTurret", 15)
    SetMemoryPoolSize("Navigator", unitCnt)
    SetMemoryPoolSize("Obstacle", 300)
    SetMemoryPoolSize("PathFollower", unitCnt)
    SetMemoryPoolSize("PathNode", 5120)
    SetMemoryPoolSize("TentacleSimulator", 220)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", unitCnt)
    SetMemoryPoolSize("UnitController", unitCnt)
    SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("PathRequest", unitCnt)
    SetMemoryPoolSize("PowerupItem", 200)
    SetMemoryPoolSize("ParticleEmitterObject", 400)
    SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 150)
    

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAS\\kas2.lvl", "kas2_con")
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
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)   
    AudioStreamAppendSegments("sound\\global.lvl", "wok_unit_vo_quick", voiceQuick) 

    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\kas.lvl",  "kas")
    OpenAudioStream("sound\\kas.lvl",  "kas")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetAmbientMusic(REP, 1.0, "rep_kas_amb_start",  0,1)
    SetAmbientMusic(REP, 0.8, "rep_kas_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.2,"rep_kas_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kas_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.8, "cis_kas_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.2,"cis_kas_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_kas_amb_victory")
    SetDefeatMusic (REP, "rep_kas_amb_defeat")
    SetVictoryMusic(CIS, "cis_kas_amb_victory")
    SetDefeatMusic (CIS, "cis_kas_amb_defeat")

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

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
	
-- OLD -- 

--    AddCameraShot(0.993669, -0.099610, -0.051708, -0.005183, 109.473549, 34.506077, 272.889221);
--    AddCameraShot(0.940831, -0.108255, -0.319013, -0.036707, -65.793930, 66.455177, 289.432678);


end
