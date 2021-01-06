--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("setup_teams")

--  REP Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2



function ScriptPostLoad()
   --force all the human players onto the attacking side
	
    
    hunt = ObjectiveTDM:New{teamATT = 1, teamDEF = 2, pointsPerKillATT = 2, pointsPerKillDEF = 1, textATT = "level.kas2.hunt.ATT", textDEF = "level.kas2.hunt.DEF", multiplayerRules = true}
    
    hunt.OnStart = function(self)
    	AddAIGoal(ATT, "Deathmatch", 1000)
    	AddAIGoal(DEF, "Deathmatch", 1000)
    end
   

	hunt:Start()
    
    --Gate Stuff -- 
    BlockPlanningGraphArcs("seawall1")
    BlockPlanningGraphArcs("woodl")
    BlockPlanningGraphArcs("woodc")
    BlockPlanningGraphArcs("woodr")
    DisableBarriers("disableme");
    KillObject("ctfbase1")
    KillObject("ctfbase2")
    
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
    SetPS2ModelMemory(3720000)
    ReadDataFile("ingame.lvl")

    SetMaxFlyHeight(70)

    ReadDataFile("sound\\kas.lvl;kas2cw")
    ReadDataFile("SIDE\\rep.lvl",
                    			"rep_fly_cat_dome")
    
--    ReadDataFile("SIDE\\wok.lvl",
--    						 "wok_inf_mechanic",
--    						 "wok_inf_rocketeer",
--    						 "wok_inf_warrior")

	ReadDataFile("SIDE\\wok.lvl",
                             "wok_inf_basic")
                    
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_fly_gunship_dome",
                             "cis_inf_officer_hunt")
                             
	ReadDataFile("SIDE\\tur.lvl",
							"tur_bldg_beam",
							"tur_bldg_recoilless_kas")

    SetupTeams{
             
        rep = {
            team = REP,
            units = 32,
            reinforcements = -1,
            
            sniper   = { "cis_inf_officer_hunt",8},
            
            
        },
        cis = {
            team = CIS,
            units = 32,
            reinforcements = -1,
            soldier  = { "wok_inf_mechanic", 5},
			engineer = {"wok_inf_warrior", 20},
            
        }
     }
       
    SetTeamName(1, "CIS")
    SetTeamName(2, "Wookiees")     
            
    --  Attacker Stats
    --SetUnitCount(ATT, 25)
    --SetReinforcementCount(ATT, 250)
    --SetTeamAsEnemy(DEF,3)

    --  Defender Stats
    --SetUnitCount(DEF, 32)
    --SetReinforcementCount(DEF, -1)
    --SetTeamAsFriend(ATT,3)

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0) -- 4 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) --
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    SetMemoryPoolSize("Aimer", 100)
    SetMemoryPoolSize("BaseHint", 240)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityCloth", 80)
    SetMemoryPoolSize("EntityHover", 15)
    SetMemoryPoolSize("EntityLight", 60)
    SetMemoryPoolSize("MountedTurret", 20)
    SetMemoryPoolSize("Obstacle", 590)
    SetMemoryPoolSize("PathNode", 512)
    SetMemoryPoolSize("TentacleSimulator", 22)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Weapon", 265)

    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("KAS\\kas2.lvl", "kas2_hunt")
    SetDenseEnvironment("false")
    SetMaxFlyHeight(65)
    SetMaxPlayerFlyHeight(65)

    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")

    --  Fishies
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Local Stats
    --SetTeamName(3, "locals")
    --SetTeamIcon(3, "all_icon")
    --AddUnitClass(3, "wok_inf_warrior", 3)
    --AddUnitClass(3, "wok_inf_rocketeer", 2)
    --AddUnitClass(3, "wok_inf_mechanic", 2)
    --SetUnitCount(3, 7)
    --SetTeamAsEnemy(3,DEF)
    --SetTeamAsFriend(3,ATT)

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

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetAmbientMusic(REP, 1.0, "rep_kas_amb_hunt",  0,1)
    -- SetAmbientMusic(REP, 0.9, "rep_kas_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1, "rep_kas_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_kas_amb_hunt",  0,1)
    -- SetAmbientMusic(CIS, 0.9, "cis_kas_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1, "cis_kas_amb_end",    2,1)

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


end
