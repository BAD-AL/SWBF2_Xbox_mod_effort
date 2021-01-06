--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("PlayMovieWithTransition")
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
		SetAIDifficulty(1, -3, "medium")   
		ScriptCB_SetGameRules("campaign")
    	ScriptCB_PlayInGameMovie("ingame.mvs", "utamon01")
    	SetMissionEndMovie("ingame.mvs", "utamon02")

		AICanCaptureCP("CAM_CP4", 1, false)
		AICanCaptureCP("CAM_CP3", 1, false)
		AICanCaptureCP("CAM_CP5", 1, false)

		AICanCaptureCP("CAM_CP4", 2, false)
		AICanCaptureCP("CAM_CP3", 2, false)
		AICanCaptureCP("CAM_CP5", 2, false)

		SetAIDamageThreshold("uturr01", 0.3)
		SetAIDamageThreshold("uturr02", 0.3)
		SetAIDamageThreshold("Power01", 0.3)

		SetClassProperty("cis_hero_grievous", "MaxHealth", 3000)
		ActivateRegion("CAM_CP4Control")		
	    backup_region = GetRegion("Supportregion")
		helpers_region = GetRegion("2Supportregion")		
			
 		SetProperty("LAATAttack", "MaxHealth", 150)
 		SetProperty("LAATAttack", "CurHealth", 150)
 		
 		SetProperty("LAATRider", "MaxHealth", 150)
 		SetProperty("LAATRider", "CurHealth", 150)
			
		SetProperty("CAM_CP4", "Team", 2)
		SetProperty("CAM_CP5", "Team", 0)
		SetProperty("CAM_CP5", "CaptureRegion", "")
		SetProperty("CAM_CP3", "CaptureRegion", "")
		SetProperty("CAM_CP4", "Value_ATK_Republic", "10")
		
		SetProperty("uturr01", "MaxHealth", 1e+37)
		SetProperty("uturr01", "CurHealth", 1e+37)
		
		SetProperty("uturr02", "MaxHealth", 1e+37)
		SetProperty("uturr02", "CurHealth", 1e+37)
		
		SetProperty("Power01", "MaxHealth", 1e+37)
		SetProperty("Power01", "CurHealth", 1e+37)
		
		EnableSPScriptedHeroes()

		laanim = 1
		lranim = 2
		la_anim()
		lr_anim()
		
		-- This is the LAAT Callback info
		la_death = OnObjectKillName(la_anim, "LAATAttack");
		lr_death = OnObjectKillName(lr_anim, "LAATRider");
		
	la_timer = CreateTimer("la_timer")
	SetTimerValue(la_timer, 20)
    StartTimer(la_timer)

    OnTimerElapse(
        function(timer)
            KillObject("LAATAttack")
        end,
        la_timer
        )

	lr_timer = CreateTimer("lr_timer")
	SetTimerValue(lr_timer, 20)
    StartTimer(lr_timer)	

    OnTimerElapse(
        function(timer)
            KillObject("LAATRider")
        end,
        lr_timer
        )
        
--Objective1:Start()
    onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                BeginObjectives()
             end
        end)
 
             local Support
    Support = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Backup() 
                ReleaseEnterRegion(Support)
            end
        end,
        backup_region
        )
        
             local Support2
    Support2 = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Helpers() 
                ReleaseEnterRegion(Support2)
            end
        end,
        helpers_region
        )
 
 	--This is objective 1 Start  Get in the vicinity of the nearest CP
	
	Objective1 = Objective:New{teamATT = ATT, teamDEF = DEF,
						 text = "level.uta1.objectives.campaign.1", popupText = "level.uta1.objectives.long.1"}
	Objective1Complete = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Objective1:Complete(ATT)
                ReleaseEnterRegion(Objective1Complete)
            end
        end,
        "CAM_CP4Control"
        )

     Objective1.OnStart = function(self)
        ScriptCB_EnableCommandPostVO(0)
        ScriptCB_SndPlaySound("UTA_obj_46")
        ScriptCB_PlayInGameMusic("rep_uta_amb_obj1_explore")
        Objective1.CAM_CP4Goal1 = AddAIGoal(ATT, "Defend", 100, "CAM_CP4")
        Objective1.CAM_CP4Goal2 = AddAIGoal(DEF, "Defend", 20, "CAM_CP4")
        MapAddEntityMarker("CAM_CP4", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
    end
 
     Objective1.OnComplete = function(self)
		SetProperty("CAM_CP5", "Team", 2)
		SetProperty("CAM_CP5", "CaptureRegion", "CAM_CP5Capture")
		ScriptCB_SndPlaySound("UTA_obj_20")
		SetProperty("CAM_CP4", "Value_DEF_CIS", "5")
		ShowMessageText("game.objectives.complete", ATT)
    end
 
--This is objective 2   
    Objective2CP = CommandPost:New{name = "CAM_CP4"}
    Objective2 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF,
						 text = "level.uta1.objectives.campaign.2", popupText = "level.uta1.objectives.long.2"}
    Objective2:AddCommandPost(Objective2CP)
    
	Objective2.OnStart = function(self)
	end
    
    Objective2.OnComplete = function(self)
    	MapRemoveEntityMarker("CAM_CP4")
        ScriptCB_SndPlaySound("UTA_obj_24")
        ScriptCB_PlayInGameMusic("rep_uta_amb_obj2_explore")
        ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)      
		ShowMessageText("level.uta1.objectives.temp.2c")
		ActivateRegion("CAM_CP5Control")
		SetProperty("CAM_CP4", "Value_DEF_CIS", "2")
		SetProperty("CAM_CP5", "Value_DEF_CIS", "5")
		SetProperty("CAM_CP3", "Value_DEF_CIS", "0")
		SetProperty("CAM_CP4", "Value_ATK_Republic", "2")
		SetProperty("CAM_CP5", "Value_ATK_Republic", "10")
		SetProperty("CAM_CP5", "SpawnPath", "CAM_CP5SpawnHigh")
		DeleteAIGoal(Objective1.CAM_CP4Goal1)
		Objective1.CAM_CP5Goal1 = AddAIGoal(DEF, "Defend", 50, "CAM_CP5")
		Objective1.CAM_CP5Goal2 = AddAIGoal(ATT, "Defend", 100, "CAM_CP5")
		
		SetProperty ("CAM_CP4", "Team", self.winningTeam)
		AICanCaptureCP("CAM_CP4", DEF, false)
		ShowMessageText("game.objectives.complete", ATT)

    end

 	--This is objective 2a Activate alternate spawn path
	
	Objective2a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.uta1.objectives.temp.2a"}
	Objective2aComplete = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                Objective2a:Complete(ATT)
                ReleaseEnterRegion(Objective2aComplete)
            end
        end,
        "CAM_CP5Control"
        )
 
     Objective2a.OnComplete = function(self)
    end

--This is objective 3  
    Objective3CP = CommandPost:New{name = "CAM_CP5"}
    Objective3 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF,
										text = "level.uta1.objectives.campaign.3", popupText = "level.uta1.objectives.long.3"}    
    Objective3:AddCommandPost(Objective3CP)
    
    Objective3.OnStart = function(self)
		MapAddEntityMarker("CAM_CP5", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
	end
    
    Objective3.OnComplete = function(self)
    	DeleteAIGoal(Objective1.CAM_CP4Goal2)
        MapRemoveEntityMarker("CAM_CP5")
        ScriptCB_SndPlaySound("UTA_obj_39")
        ScriptCB_SndPlaySound("UTA_obj_35")
        ScriptCB_PlayInGameMusic("rep_uta_amb_obj3_explore")
        UnlockHeroForTeam(1)
		SetProperty("CAM_CP5", "SpawnPath", "CAM_CP5Spawn")
		SetProperty("CAM_CP5", "Value_DEF_CIS", "3")
		SetProperty("CAM_CP3", "Value_DEF_CIS", "5")
		SetProperty("CAM_CP5", "Value_ATK_Republic", "3")
		SetProperty("CAM_CP3", "SpawnPath", "CAM_CP3SpawnBack")
		SetProperty("CAM_CP3", "CaptureRegion", "CAM_CP3Capture")
		DeleteAIGoal(Objective1.CAM_CP5Goal1)
		DeleteAIGoal(Objective1.CAM_CP5Goal2)
        ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 30) 
		
		SetProperty ("CAM_CP5", "Team", self.winningTeam)
		AICanCaptureCP("CAM_CP5", DEF, false)
		ShowMessageText("game.objectives.complete", ATT)
    end

--This is objective 3a
    Objective3aCP = CommandPost:New{name = "CAM_CP3"}
    Objective3a = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF,
										text = "level.uta1.objectives.campaign.3a", popupText = "level.uta1.objectives.long.3a"}    
    Objective3a:AddCommandPost(Objective3aCP)
    
    Objective3a.OnStart = function(self)
		MapAddEntityMarker("CAM_CP3", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
	end
    
    
    Objective3a.OnComplete = function(self)
        MapRemoveEntityMarker("CAM_CP3")
        SetProperty("CAM_CP3", "SpawnPath", "CAM_CP3Rep")
		SetProperty("CAM_CP2", "Team", 2)
		SetProperty("CAM_CP2", "SpawnPath", "CAM_CP3Spawn")      
		ScriptCB_SndPlaySound("UTA_obj_40")
		ScriptCB_PlayInGameMusic("rep_uta_grievous_01")
		SetProperty("CAM_CP3", "CaptureRegion", "")
		-- add Grievious as a new unit
		local characterindex = GetTeamMember(4, 0)
		BatchChangeTeams(4, DEF, 1)
		SetHeroClass(CIS, "cis_hero_grievous")
		SelectCharacterClass(characterindex, "cis_hero_grievous")
		SpawnCharacter(characterindex, GetPathPoint("grievious_spawn", 0)) 
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)  
		
		SetProperty ("CAM_CP3", "Team", self.winningTeam)
		AICanCaptureCP("CAM_CP3", DEF, false)
		ShowMessageText("game.objectives.complete", ATT)
end		

--This is objective 3b  Destroy Grevious
    
	Objective3b= ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF,
										text = "level.uta1.objectives.campaign.3b", popupText = "level.uta1.objectives.long.3b"}	

	JediKiller = TargetType:New{classname = "cis_hero_grievous", killLimit = 1}
	Objective3b:AddTarget(JediKiller)
	
	Objective3b.OnStart = function(self)
		Objective3b.CAM_CP3Goal1 = AddAIGoal(ATT, "Defend", 100, "CAM_CP3")
		Objective3b.CAM_CP3Goal2 = AddAIGoal(DEF, "Defend", 20, "CAM_CP3")
	end
	
	Objective3b.OnComplete = function(self)
	    SetProperty("uturr01", "MaxHealth", 2000)
		SetProperty("uturr01", "CurHealth", 2000)
		SetProperty("uturr02", "MaxHealth", 2000)
		SetProperty("uturr02", "CurHealth", 2000)
		ActivateRegion("Supportregion")
		ScriptCB_SndPlaySound("UTA_obj_42")	
		ScriptCB_SndPlaySound("UTA_obj_26")
		ScriptCB_PlayInGameMusic("rep_uta_ImmVict_01")			
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 10) 
		DeleteAIGoal(Objective3b.CAM_CP3Goal1)
		DeleteAIGoal(Objective3b.CAM_CP3Goal2)
	end

--This is objective 4.  Destroy the AA Guns
    Gun_count = 2    
    Gun01 = Target:New{name = "uturr01"}
    Gun02 = Target:New{name = "uturr02"}
    Gun01.OnDestroy = function(self)
        if Gun_count > 1 then
        Gun_count = Gun_count - 1
        ShowMessageText("level.uta1.objectives.temp.4-" .. Gun_count)
        ScriptCB_SndPlaySound("UTA_obj_28")
        SetProperty("CAM_CP3", "SpawnPath", "CAM_CP3Spawn")
        end
    end
    Gun02.OnDestroy = function(self)
        if Gun_count > 1 then
        Gun_count = Gun_count - 1
        ShowMessageText("level.uta1.objectives.temp.4-" .. Gun_count)
        ScriptCB_SndPlaySound("UTA_obj_28")
        end
    end
        
    Objective4 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
                      										text = "level.uta1.objectives.campaign.4", popupText = "level.uta1.objectives.long.4"}

    Objective4:AddTarget(Gun01)
    Objective4:AddTarget(Gun02)
   
    Objective4.OnComplete = function(self)
--    ScriptCB_SndPlaySound("CorSpc_obj_20")
	SetProperty("uturr01", "Team", 0)
	SetProperty("uturr02", "Team", 0)
	ActivateRegion("2Supportregion")
	SetProperty("CAM_CP6", "Team", 1)
	SetProperty("CAM_CP3", "Value_DEF_CIS", "0")
	SetProperty("CAM_CP4", "Value_DEF_CIS", "0")
	SetProperty("CAM_CP5", "Value_DEF_CIS", "0")
	SetProperty("CAM_CP3", "Value_ATK_Republic", "1")
	SetProperty("CAM_CP4", "Value_ATK_Republic", "1")
	SetProperty("CAM_CP5", "Value_ATK_Republic", "1")
	SetProperty("CAM_CP2", "Value_DEF_CIS", "3")	
	SetProperty("CAM_CP2", "Value_ATK_Republic", "3")		
	SetProperty("Power01", "MaxHealth", 12000)
	SetProperty("Power01", "CurHealth", 12000)
	SetProperty("CAM_CP2", "SpawnPath", "CAM_CP2Spawn")
	ScriptCB_SndPlaySound("UTA_obj_29")
	ScriptCB_SndPlaySound("UTA_obj_30")
	ScriptCB_SndPlaySound("UTA_obj_32")
	ATTReinforcementCount = GetReinforcementCount(ATT)
	SetReinforcementCount(ATT, ATTReinforcementCount + 10) 	
	ShowMessageText("game.objectives.complete", ATT)
end

	--This is objective 5  Destroy the Power Gen
	Power = Target:New{name = "Power01"}
	Power.OnDestroy = function(self)
		ShowMessageText("level.uta1.objectives.temp.5c", 1)
	end
	
	Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
										text = "level.uta1.objectives.campaign.5", popupText = "level.uta1.objectives.long.5"}
	Objective5:AddTarget(Power)

    Objective5.OnComplete = function(self)
	ScriptCB_SndPlaySound("UTA_obj_34")
	ShowMessageText("game.objectives.complete", ATT)
    end

end
function BeginObjectives()
--This creates the objective "container" and specifies order of objectives, and gets that running           
--	objectiveSequence = MultiObjectiveContainer:New{}
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 4.5}
	objectiveSequence:AddObjectiveSet(Objective1)
	objectiveSequence:AddObjectiveSet(Objective2)
	objectiveSequence:AddObjectiveSet(Objective2a, Objective3)
	objectiveSequence:AddObjectiveSet(Objective3a)
	objectiveSequence:AddObjectiveSet(Objective3b)
	objectiveSequence:AddObjectiveSet(Objective4)
	objectiveSequence:AddObjectiveSet(Objective5)
  objectiveSequence:Start()
end

function la_anim()
	if laanim == 1 then
		PauseAnimation("LA03");
		RewindAnimation("LA01");
		PlayAnimation("LA01");
		EntityFlyerTakeOff("LAATAttack")
		laanim = 2
	
	
	elseif laanim == 2 then
		PauseAnimation("LA01");
		RewindAnimation("LA02");
		PlayAnimation("LA02");
		EntityFlyerTakeOff("LAATAttack")	
		laanim = 3
		
	
	elseif laanim == 3 then
		PauseAnimation("LA02");
		RewindAnimation("LA03");
		PlayAnimation("LA03");
		EntityFlyerTakeOff("LAATAttack")
		laanim = 1
	end
	
	SetTimerValue(la_timer, 30)
    StartTimer(la_timer)	
end

function lr_anim()
	if lranim == 1 then
	PauseAnimation("LR03");
	RewindAnimation("LR02");
	PlayAnimation("LR02");
	EntityFlyerTakeOff("LAATRider")
	lranim = 2
	
	
	elseif lranim == 2 then
	PauseAnimation("LR01");
	RewindAnimation("LR03");
	PlayAnimation("LR03");
	EntityFlyerTakeOff("LAATRider")
	lranim = 3
	
	
	elseif lranim == 3 then
	PauseAnimation("LR02");
	RewindAnimation("LR01");
	PlayAnimation("LR01");
	EntityFlyerTakeOff("LAATRider")
	lranim = 1
	end
	
	SetTimerValue(lr_timer, 30)
    StartTimer(lr_timer)	
end

function Backup()
    SetProperty("LAATDrop01", "MaxHealth", 1250)
	SetProperty("LAATDrop01", "CurHealth", 1250)
	EntityFlyerTakeOff("LAATDrop01")
	EntityFlyerInitAsLanded("LAATAttack")
	KillObject("LAATAttack")
	KillObject("LAATRider")
	DestroyTimer(lr_timer)
	DestroyTimer(la_timer)
	ReleaseObjectKill(la_death)
	ReleaseObjectKill(lr_death)
	DeactivateRegion(backup_region)
	PauseAnimation("LA01");
	PauseAnimation("LA02");
	PauseAnimation("LA03");
	PauseAnimation("LR01");
	PauseAnimation("LR02");
	PauseAnimation("LR03");
	PauseAnimation("drop-hide");

	RewindAnimation("LA-hide");
	PlayAnimation("LA-hide");
	RewindAnimation("LR-hide");
	PlayAnimation("LR-hide");

	RewindAnimation("Backup");
	PlayAnimation("Backup");

end

function Helpers()
	SetProperty("LAATDrop01", "MaxHealth", 1250)
	SetProperty("LAATDrop01", "CurHealth", 1250)
	SetProperty("LAATDrop02", "MaxHealth", 1250)
	SetProperty("LAATDrop02", "CurHealth", 1250)
	EntityFlyerTakeOff("LAATDrop01")
	EntityFlyerTakeOff("LAATDrop02")
	EntityFlyerInitAsLanded("LAATAttack")
	EntityFlyerInitAsLanded("LAATRider")	
	DeactivateRegion(helpers_region)
	
	PauseAnimation("hide02");
	PauseAnimation("Backup");
	RewindAnimation("backup2");
	PlayAnimation("backup2");
	EntityFlyerTakeOff("LAATDrop01")
	EntityFlyerTakeOff("LAATDrop02")

end

function ScriptInit()
	StealArtistHeap(300*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4700000)

    SetMemoryPoolSize("Combo::State", 75)  --need more of these than default
    SetMemoryPoolSize("Combo::DamageSample", 600)  --need more of these than default

    ReadDataFile("ingame.lvl")

    SetTeamAggressiveness(REP, 0.95)
    SetTeamAggressiveness(CIS, 0.95)  

    ReadDataFile("sound\\uta.lvl;uta1cw")

    ReadDataFile("SIDE\\rep.lvl",
						"rep_inf_ep3_rifleman",
						"rep_inf_ep3_rocketeer",
						"rep_inf_ep3_engineer",
						"rep_inf_ep3_sniper",
						"rep_inf_ep3_officer",
						"rep_inf_ep3_jettrooper",
						"rep_hero_obiwan",
						"uta1_prop_gunship",
						"rep_walk_oneman_atst",
						"rep_hover_fightertank")
    ReadDataFile("SIDE\\cis.lvl",
                        "cis_inf_rifleman",
                        "cis_inf_rocketeer",
                        "cis_inf_engineer",
                        "cis_inf_sniper",
                        "cis_hero_grievous",
                        "cis_inf_officer",
                        "cis_hover_aat")
                        
ScriptCB_SetSpawnDisplayGain(0.2, 0.5)                                                

SetupTeams{
        rep = {
	    team = REP,
	    units = 19,
	    reinforcements = 15,
	    soldier  = { "rep_inf_ep3_rifleman", 8},
	    assault  = { "rep_inf_ep3_rocketeer", 2},
	    engineer = { "rep_inf_ep3_engineer", 3},
	    sniper   = { "rep_inf_ep3_sniper", 3},
	    officer  = { "rep_inf_ep3_officer", 1},
	    special  = { "rep_inf_ep3_jettrooper", 2},
            
        },
        cis = {
	    team = CIS,
	    units = 13,
	    reinforcements = -1,
	    soldier  = { "cis_inf_rifleman",4},
	    assault  = { "cis_inf_rocketeer",4},
	    engineer = { "cis_inf_engineer",1},
	    sniper   = { "cis_inf_sniper",2},
	    officer  = { "cis_inf_officer", 2},
        }
     }

		SetHeroClass(REP, "rep_hero_obiwan")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 0)     -- droidekas
    AddWalkerType(1, 4) -- ATRTa (special case: 0 leg pairs)
    local weaponCnt = 200
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 193)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 12)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("EntityLight", 80)
    SetMemoryPoolSize("EntitySoundStream", 8)
    SetMemoryPoolSize("EntitySoundStatic", 27)
    SetMemoryPoolSize("MountedTurret", 21)
    SetMemoryPoolSize("Navigator", 34)
    SetMemoryPoolSize("Obstacle", 450)
    SetMemoryPoolSize("PathFollower", 34)
    SetMemoryPoolSize("PathNode", 384)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("Timer", 10)
    SetMemoryPoolSize("TreeGridStack", 225)
    SetMemoryPoolSize("UnitAgent", 49)
    SetMemoryPoolSize("UnitController", 49)
    SetMemoryPoolSize("Weapon", weaponCnt)   
    
         --Adding Grievous Pool
     AddUnitClass(4, "rep_inf_ep3_rifleman", 1)
       SetUnitCount(4, 1)
    
    
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("uta\\uta1.lvl", "uta1_Campaign")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(500)
    SetMaxPlayerFlyHeight(29.5)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "uta_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\uta.lvl",  "uta1")
    OpenAudioStream("sound\\uta.lvl",  "uta1")
    -- OpenAudioStream("sound\\uta.lvl",  "uta_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\uta.lvl",  "uta1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    -- SetAmbientMusic(REP, 1.0, "RepUta01_GunshipIntro",  0,1)
    -- SetAmbientMusic(REP, 0.98, "RepUta01_ExpAmb1", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_uta_amb_end",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_uta_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_uta_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_uta_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_uta_amb_victory")
    SetDefeatMusic (REP, "rep_uta_amb_defeat")
    SetVictoryMusic(CIS, "cis_uta_amb_victory")
    SetDefeatMusic (CIS, "cis_uta_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--  Camera Stats - Utapau: Sinkhole
	AddCameraShot(-0.428091, 0.045649, -0.897494, -0.095703, 162.714951, 45.857063, 40.647118)
	AddCameraShot(-0.194861, -0.001600, -0.980796, 0.008055, -126.179787, 16.113789, 70.012894);
	AddCameraShot(-0.462548, -0.020922, -0.885442, 0.040050, -16.947638, 4.561796, 156.926956);
	AddCameraShot(0.995310, 0.024582, -0.093535, 0.002310, 38.288612, 4.561796, 243.298508);
	AddCameraShot(0.827070, 0.017093, 0.561719, -0.011609, -24.457638, 8.834146, 296.544586);
	AddCameraShot(0.998875, 0.004912, -0.047174, 0.000232, -45.868237, 2.978215, 216.217880);


end


