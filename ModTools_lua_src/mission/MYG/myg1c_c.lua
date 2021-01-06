--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM") 
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("Ambush")
ScriptCB_SetGameRules("campaign")

    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------


--Ambush Data-------------------------------------
ambushTeam1 = 4
ambushCount1 = 3

ambushTeam2 = 5
ambushCount2 = 3

ambushTeam3 = 6
ambushCount3 = 8

ambushTeam4 = 6
ambushCount4 = 5

CIS2 		= 7

--ambushTeam3 = 6
--ambushCount3 = 5

--ambushTeam4 = 7	
--ambushCount4 = 15




 function ScriptPostLoad()
 	
 	SetMissionEndMovie("ingame.mvs", "mygmon02")
 
 	DisableAIAutoBalance()
 	
 	SetAIDifficulty(3, -5, "medium")
 	
 	SetAIDifficulty(1, 2, "hard")
 
 	DisableBarriers("ctf")
    DisableBarriers("ctf1")
    DisableBarriers("ctf2")
    DisableBarriers("ctf3")
 
 	ScriptCB_PlayInGameMovie("ingame.mvs", "mygmon01")
 
 --  Set up the ambushes Triggers--
    SetupAmbushTrigger("magnatrigger", "magnapath", ambushCount1, ambushTeam1)
    SetupAmbushTrigger("solrush", "solrush", ambushCount4, ambushTeam4)
    --SetupAmbushTrigger("corerun3", "testing", ambushCount3, ambushTeam3)
	-- example SetupAmbushTrigger("region", "path", ambushCount1, ambushTeam1)
	--SetupAmbushTrigger("ambush_trigger_2", "ambush_trigger_path_2", ambushCount2, ambushTeam2)
	--SetupAmbushTrigger("ambush_trigger_3", "ambush_trigger_path_3", ambushCount2, ambushTeam2)
	--SetupAmbushTrigger("ambush_trigger_4", "ambush_trigger_path_4", ambushCount2, ambushTeam2)
	
	-- This is a direct call to the AMbush
	
	 --Ambush("ambush_trigger_path_4", ambushCount4, ambushTeam4)
	
-- TESTING Setup for DropShip--
	EntityFlyerInitAsLanded("repveh6")
	EntityFlyerTakeOff("repveh5")
	EntityFlyerTakeOff("repveh4")
	
--	SetObjectTeam("repship", 2)
--	MapAddEntityMarker("repveh6", "hud_objective_icon", 3.0, 1, "YELLOW", true)
--	SetProperty("repveh6", "MaxHealth", 1e+37)
--    SetProperty("repveh6", "CurHealth", 1e+37)
--	PlayAnimation("dropshipnew")
	--EntityFlyerInitAsLanding("repveh6")
	
-- General level Setup--	 
 	KillObject("CP2")
 	KillObject("CP4")
 	KillObject("norun")
    DisableBarriers("dropship")
    BlockPlanningGraphArcs("incore")
    PlayAnimation("gunshipfly2")
--    SetProperty("repveh6", "IsVisible", 0)
    SetProperty("core", "MaxHealth", 1e+37)
    SetProperty("core", "CurHealth", 1e+37)
    SetProperty("cforce_shield_01", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_01", "CurHealth", 1e+37)
    SetProperty("cforce_shield_02", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_02", "CurHealth", 1e+37)
    SetProperty("cforce_shield_03", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_03", "CurHealth", 1e+37)
    SetProperty("cforce_shield_04", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_04", "CurHealth", 1e+37)
    SetProperty("cforce_shield_05", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_05", "CurHealth", 1e+37)
    SetProperty("cforce_shield_06", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_06", "CurHealth", 1e+37)
    SetProperty("cforce_shield_07", "MaxHealth", 1e+37)
    SetProperty("cforce_shield_07", "CurHealth", 1e+37)
    SetProperty("force_shield_01", "MaxHealth", 1e+37)
    SetProperty("force_shield_01", "CurHealth", 1e+37)
    SetProperty("force_shield_02", "MaxHealth", 1e+37)
    SetProperty("force_shield_02", "CurHealth", 1e+37)
    SetProperty("force_shield_03", "MaxHealth", 1e+37)
    SetProperty("force_shield_03", "CurHealth", 1e+37)
    SetProperty("generator_01", "MaxHealth", 1e+37)
    SetProperty("generator_01", "CurHealth", 1e+37)
    SetProperty("backgen1", "MaxHealth", 1e+37)
    SetProperty("backgen1", "CurHealth", 1e+37)
    SetProperty("backgen2", "MaxHealth", 1e+37)
    SetProperty("backgen2", "CurHealth", 1e+37)
    SetProperty("autoturret1", "MaxHealth", 1e+37)
    SetProperty("autoturret1", "CurHealth", 1e+37)
    SetProperty("autoturret2", "MaxHealth", 1e+37)
    SetProperty("autoturret2", "CurHealth", 1e+37)
    SetProperty("enemyspawn", "IsVisible", 0)
    SetProperty("turretcp", "IsVisible", 0)
    SetProperty("tankspawn", "IsVisible", 0)
    
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
    
    
-- AI Can't damage Objects --  
    SetAIDamageThreshold("autoturret1", 0.5)
    SetAIDamageThreshold("autoturret2", 0.5)
    SetAIDamageThreshold("autoturret3", 0.5)
    SetAIDamageThreshold("autoturret4", 0.5)
    SetAIDamageThreshold("backgen1", 0.7)
    SetAIDamageThreshold("generator_01", 0.7)
    SetAIDamageThreshold("backgen2", 0.7)
    SetAIDamageThreshold("core", 0.3)

    -- Activate Regions -- 

    ActivateRegion("enemytrigger1")
    ActivateRegion("enemytrigger2")
    
    -- Activate Amush Regions --
    
    ActivateRegion("magnatrigger")
    ActivateRegion("solrush")

		
		CP4DisableCapture = OnFinishCaptureName(
		function (postPtr)
			SetProperty("CP4", "CaptureRegion", "distraction")
			ReleaseFinishCapture(CP4DisableCapture)	
		end,
		"CP4"
		)
    

    --Setup Timer-- 
    timePop = CreateTimer("timePop")
	SetTimerValue(timePop, 3.0)

-- ON FIRST SPAWN --
  
      onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
            	ScriptCB_PlayInGameMusic("rep_myg_amb_obj1_2_explore")
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                StartTimer(timePop)
                OnTimerElapse(
        			function(timer)
            			StartObjectives()
            			ScriptCB_EnableCommandPostVO(0)
                		ScriptCB_SndPlaySound("MYG_obj_01")
                		ScriptCB_SndPlaySound("MYG_obj_02")
            			DestroyTimer(timer)
        			end,
        		timePop
        		)          
             end
        end)
        

   EnemyStart = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            EnemyTrigger1() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("enemytrigger1")
        end
    end,
    "enemytrigger1"
    )
    
   EnemyStart2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            EnemyTrigger2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("enemytrigger2")
        end
    end,
    "enemytrigger2"
    )
    
    TankSpawnNew = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            TankSpawn() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("killtank")
        end
    end,
    "killtank"
    )

   LeftShieldBattle = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            LeftShield() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("leftshield")
            
        end
    end,
    "leftshield"
    )
    
    LeftShieldBattle2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            LeftShield2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("lshield2")
        end
    end,
    "lshield2"
    )
    
    LeftBackCall = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            LeftBack() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("lback")
        end
    end,
    "lback"
    )
    
   RightShieldBattle = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            RightShield() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("rightshield")
        end
    end,
    "rightshield"
    )
    
    RightShieldBattle2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            RightShield2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("rightshield2")
        end
    end,
    "rightshield2"
    )
 
    BackCPBattle = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            BackTrigger() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("backtrigger")
        end
    end,
    "backtrigger"
    )
    
    CoreReminder2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreReminder() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("corereminder")
        end
    end,
    "corereminder"
    )
    
    CoreRun = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreRunHome() 
            ActivateRegion("corerun2")
            ActivateRegion("corerun3")
--            ActivateRegion("flyertrigger")
            --ReleaseEnterRegion(MusicTriggerTechRoom)
        end
    end,
    "corereturn"
    )
    
    CoreRun2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreRunHome2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("corerun2")
        end
    end,
    "corerun2"
    )
    
    CoreRun3 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            CoreRunHome3() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("corerun3")
        end
    end,
    "corerun3"
    )
    
    ShieldFun = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            ShieldFunRun() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("shieldfun")
        end
    end,
    "shieldfun"
    )
    
    FlyerTrigger = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            FlyerTrigger1() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("flyertrigger")
        end
    end,
    "flyertrigger"
    )
    
    RealFlyer = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            PlayAnimation("dropshipnew")
--            ShowMessageText("level.myg1.obj.c7", 1)
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("realflyer")
        end
    end,
    "realflyer"
    )
    
    FlyerTrigger = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            NoRunCP() 
--            ScriptCB_SndPlaySound("MYG_inf_01")
            --ReleaseEnterRegion(MusicTriggerTechRoom)
        end
    end,
    "magnatrigger"
    )
    
    
 --UnlockHeroForTeam(2)
 
-- Single Player Scripting Stuff --

    --goto1 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.uta1.objectives.temp.1"}
	  --goto1Complete = OnEnterRegion(
        --function(region, character) 
          --  if IsCharacterHuman (character) then
          --      ShowMessageText("level.myg1.obj.c2c", 1)
          --      goto1:Complete(ATT)
          --      ReleaseEnterRegion(goto1Complete)
          --  end
       -- end,
       -- "goto1"
       -- )


-- Objective 1 -- 

    Objective1CP = CommandPost:New{name = "CP9OBJ"}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c1", popupText = "level.myg1.obj.pop.c1"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function(self)
    	AICanCaptureCP("CP9OBJ", ATT, false)
    	Objective1.defGoal1 = AddAIGoal(ATT, "Defend", 3000, "CP9OBJ")
    	Objective1.defendGoal1 = AddAIGoal(CIS2, "Defend", 3000, "CP9OBJ")
    end
    
    Objective1.OnComplete = function(self)
      ShowMessageText("game.objectives.complete", ATT)
      --DeactivateRegion("cp9objcontrol")
      SetProperty("CP9OBJ", "CaptureRegion", "distraction")
      SetProperty("CP9OBJ", "SpawnPath", "cp9objpath2")
      SetProperty("CP9OBJ", "Value_DEF_CIS", "0")
      SetProperty("turretcp", "SpawnPath", "")
      SetObjectTeam("tankspawn", 2)
      ActivateRegion("killtank")
      if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
    			ScriptCB_SndPlaySound("MYG_obj_03")
	    	end
      DeleteAIGoal(Objective1.defGoal1)
      DeleteAIGoal(Objective1.defendGoal1)
      SetProperty("CP9OBJ", "AISpawnWeight", "1000")
      ATT_ReinforcementCount = GetReinforcementCount(ATT)
      SetReinforcementCount(ATT, ATT_ReinforcementCount + 20) 
    end
    
-- Objective 2 --

    --setup objective 2 - Assault--
    
    
    MainframeString = "level.myg1.obj.c2-"
    Mainframe01 = Target:New{name = "autoturret1"}
    Mainframe02 = Target:New{name = "autoturret2"}
--    Mainframe03 = Target:New{name = "objturret3"}
--    Mainframe04 = Target:New{name = "objturret4"}



    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c2", popupText = "level.myg1.obj.pop.c2"}
    Objective2:AddTarget(Mainframe01)
    Objective2:AddTarget(Mainframe02)
--    Objective2:AddTarget(Mainframe03)
--    Objective2:AddTarget(Mainframe04)
	
	Objective2.OnSingleTargetDestroyed = function(self, target)
		local numTargets = self:GetNumSingleTargets()
		if numTargets > 0 then
			ShowMessageText(MainframeString .. (numTargets + 1), 1)
			ScriptCB_SndPlaySound("MYG_obj_04")
		end
	end
   
   
    Objective2.OnStart = function(self)
      SetObjectTeam("CP9OBJ", 1)
      SetProperty("autoturret1", "MaxHealth", 1000)
      SetProperty("autoturret1", "CurHealth", 1000)
      SetProperty("autoturret2", "MaxHealth", 1000)
      SetProperty("autoturret2", "CurHealth", 1000)
      Objective2.defendGoal1 = AddAIGoal(CIS2, "Deathmatch", 5000)
      Objective2.atkGoal1 = AddAIGoal(ATT, "Destroy", 3000, "autoturret1")
      Objective2.atkGoal2 = AddAIGoal(ATT, "Destroy", 3000, "autoturret2")
      Objective2.defGoal1 = AddAIGoal(DEF, "Defend", 3000, "autoturret1")
      Objective2.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "autoturret2")
    end
    
	Objective2.OnComplete = function(self)
	  ShowMessageText("game.objectives.complete", ATT)
      ShowMessageText("level.myg1.obj.c2c", 1)
      UnlockHeroForTeam(1)
      EnableBarriers("dropship")
      ActivateRegion("leftshield")
      --ActivateRegion("rightshield")
      ActivateRegion("rightshield2")
      ActivateRegion("lshield2")
      ActivateRegion("backtrigger")
      ScriptCB_PlayInGameMusic("rep_myg_act_01") 
 
      SetProperty("core", "SpawnPath", "corespawn")
      --ActivateRegion("shieldfun")
      
      --Deleting Goals
      
      DeleteAIGoal(Objective2.atkGoal1)
      DeleteAIGoal(Objective2.atkGoal2)
      DeleteAIGoal(Objective2.defGoal1)
      DeleteAIGoal(Objective2.defGoal2)
      ATT_ReinforcementCount = GetReinforcementCount(ATT)
      SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
      if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
    			ScriptCB_SndPlaySound("MYG_obj_18")
	    	end
    end
    
    NewShieldObj = Target:New{name = "generator_01"}


    Objective2new = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c13", popupText = "level.myg1.obj.pop.c13", AIGoalWeight = 0.0}
    Objective2new:AddTarget(NewShieldObj)
    
    Objective2new.OnStart = function(self)
    	SetProperty("generator_01", "MaxHealth", 150)
    	SetProperty("generator_01", "CurHealth", 150)
    end
    
    Objective2new.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
    			ScriptCB_SndPlaySound("MYG_obj_35")
	    	end
    	RespawnObject("CP2")
    	ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
    end
    
--Objective 6--

    --ForceShield01 = Target:New{name = "force_shield_01"}
    --ForceShield02 = Target:New{name = "force_shield_02"}

    --Objective6 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c7"}
    --Objective6:AddTarget(ForceShield01)
    --Objective6:AddTarget(ForceShield02)
    
    
-- Objective 2.5 --

	Objective2CP = CommandPost:New{name = "CP2"}
    Objective2_1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c10", popupText = "level.myg1.obj.pop.c10"}
    Objective2_1:AddCommandPost(Objective2CP)
    
    Objective2_1.OnStart = function(self)
   
    	SetProperty("newenemyspawn", "SpawnPath", "enemyspawn2_1")
    	SetProperty("enemyspawn", "SpawnPath", "enemyspawn2_1")
    	AICanCaptureCP("CP2", ATT, false)
    	RespawnObject("CP2")
    	Objective2_1.defGoal1 = AddAIGoal(ATT, "Defend", 3000, "CP2")
    	Objective2_1.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "CP2")
    end
    
    Objective2_1.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	ScriptCB_PlayInGameMusic("rep_myg_amb_obj5_explore")
    	DeleteAIGoal(Objective2_1.defGoal1)
      	DeleteAIGoal(Objective2_1.defGoal2)
      	SetProperty("CP9OBJ", "AISpawnWeight", "1000") 
      	SetProperty("CP2", "AISpawnWeight", "5000") 
      	SetProperty("CP2", "CaptureRegion", "distraction")
      	ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 30)
        if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
    			ScriptCB_SndPlaySound("MYG_obj_06")
	    	end
    end
    
-- Objective 2.7
	MainframeString2 = "level.myg1.obj.c2-"
    Mainframe03 = Target:New{name = "autoturret3"}
    Mainframe04 = Target:New{name = "autoturret4"}


    Objective2_2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c11", popupText = "level.myg1.obj.pop.c11"}
    Objective2_2:AddTarget(Mainframe03)
    Objective2_2:AddTarget(Mainframe04)
    
    Objective2_2.OnSingleTargetDestroyed = function(self, target)
		local numTargets = self:GetNumSingleTargets()
		if numTargets > 0 then
			ShowMessageText(MainframeString2 .. (numTargets + 1), 1)
		end
	end
	
	Objective2_2.OnStart = function(self)
	  SetProperty("newenemyspawn", "SpawnPath", "lback")
      SetProperty("enemyspawn", "SpawnPath", "rshield2")
      Objective2_2.atkGoal1 = AddAIGoal(ATT, "Destroy", 3000, "autoturret3")
      Objective2_2.atkGoal2 = AddAIGoal(ATT, "Destroy", 3000, "autoturret4")
      Objective2_2.defGoal1 = AddAIGoal(DEF, "Defend", 3000, "autoturret3")
      Objective2_2.defGoal2 = AddAIGoal(DEF, "Defend", 3000, "autoturret4")
    end
    
	Objective2_2.OnComplete = function(self)
	  ShowMessageText("game.objectives.complete", ATT)
      ShowMessageText("level.myg1.obj.c2c", 1)
      DeleteAIGoal(Objective2_2.atkGoal1)
      DeleteAIGoal(Objective2_2.atkGoal2)
      DeleteAIGoal(Objective2_2.defGoal1)
      DeleteAIGoal(Objective2_2.defGoal2)
      ActivateRegion("corereminder")
    end
    
	
	
    
-- Objective 3 -- 

    core = Target:New{name = "core"}

    Objective3 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.myg1.obj.c4", popupText = "level.myg1.obj.pop.c4"}
    Objective3:AddTarget(core)
  
  Objective3.OnStart = function(self)
  	SetObjectTeam("CP2", 1)
  	SetProperty("core", "MaxHealth", 1800)
    SetProperty("core", "CurHealth", 1800)
  	SetProperty("backgen1", "MaxHealth", 150)
    SetProperty("backgen1", "CurHealth", 150)
    SetProperty("backgen2", "MaxHealth", 150)
    SetProperty("backgen2", "CurHealth", 150)
  	SetProperty("newenemyspawn", "SpawnPath", "lback")
    SetProperty("enemyspawn", "SpawnPath", "rshield2")
  	ActivateRegion("corereminder")
  	Objective3.dmGoalATT1 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_04")
  	Objective3.dmGoalATT2 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_05")
  	Objective3.dmGoalATT3 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_06")
  	Objective3.dmGoalATT4 = AddAIGoal(ATT, "Defend", 1000, "cforce_shield_07")
    Objective3.dmGoal1 = AddAIGoal(DEF, "Deathmatch", 1000)  
    Objective3.dmGoal2 = AddAIGoal(ambushTeam2, "Defend", 3000, "core")
  end
     
    Objective3.OnComplete = function(self)
      ShowMessageText("game.objectives.complete", ATT)
      Holocron1Spawn = GetPathPoint("codespawn", 0) --gets the path point
      CreateEntity("myg1_flag_crystal", Holocron1Spawn, "crystal") --spawns the disk
      SetProperty("crystal", "AllowAIPickUp", 0)

--		SetProperty("crystal", "CarriedGeometryName", "myg1_flag_crystal")
--		SetProperty("crystal", "GeometryName", "myg1_flag_crystal")
      
      DeleteAIGoal(Objective3.dmGoalATT1)
      DeleteAIGoal(Objective3.dmGoalATT2)
      DeleteAIGoal(Objective3.dmGoalATT3)
      DeleteAIGoal(Objective3.dmGoalATT4)
      ATT_ReinforcementCount = GetReinforcementCount(ATT)
      SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
      if self.winningTeam == DEF then
    		   	ScriptCB_SndPlaySound("MYG_obj_15")
    		  else
    			ScriptCB_SndPlaySound("MYG_obj_20")
	    	end
    end

-- Objective 4 Power Crystals --
    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, 
            text = "level.myg1.obj.c5", 
            popupText = "level.myg1.obj.pop.c5",
            showTeamPoints = false,
            AIGoalWeight = 1000.0}
        
    Objective4:AddFlag{name = "crystal", captureRegion = "droppoint",
            capRegionMarker = "rep_icon", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}
            
	
	Objective4.OnStart = function(self)
		SetProperty("crystal", "AllowAIPickUp", 0)
		ActivateRegion("corerun2")
        ActivateRegion("corerun3")
        ActivateRegion("flyertrigger")
        ActivateRegion("realflyer")
		Ambush("solrush2", ambushCount4, ambushTeam4)
	    ScriptCB_PlayInGameMusic("rep_myg_objComplete_01")
	     -- Music Timer -- 
	     music01Timer = CreateTimer("music01")
	    SetTimerValue(music01Timer, 15.0)
	    		              
	    	StartTimer(music01Timer)
	    	OnTimerElapse(
	    		function(timer)
	    		ScriptCB_StopInGameMusic("rep_myg_objComplete_01")
	    		ScriptCB_PlayInGameMusic("rep_myg_amb_immVict_01")
	    		DestroyTimer(timer)
	    	end,
	    	music01Timer
        )  
    	ActivateRegion("corereturn")
    	ActivateRegion("corerun2")
    end
	
	Objective4.OnPickup = function(self, flag)
		if IsCharacterHuman(flag.carrier) then
			MapAddEntityMarker("newenemyspawn", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
			ScriptCB_SndPlaySound("MYG_obj_23")
			SetProperty("enemyspawn", "SpawnPath", "lastspawn")
			--ShowMessageText("level.myg1.obj.c2c", 1)			
		end
	end
    
    Objective4.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	MapRemoveEntityMarker("newenemyspawn")
    	MapRemoveEntityMarker("repveh6")
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("MYG_obj_16")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("MYG_obj_14")
	    end
    end        
   -- Objective4.OnStart = function (self)
          --rather than have the AI in CTF mode, just put them in Deathmatch mode for this goal
          --Objective4.dmGoal1 = AddAIGoal(ATT, "Deathmatch", 100)
          --Objective4.dmGoal2 = AddAIGoal(DEF, "Deathmatch", 100)
          --Objective4.ctfGoal1 = AddAIGoal(ATT, "Defend", 100, "holodisk")
          --Objective4.ctfGoal2 = AddAIGoal(DEF, "Defend", 100, "holodisk")
      --end
    
      --Objective4.OnComplete = function (self)
          --clean up the goals that we assigned to the AI
          --DeleteAIGoal(Objective4.dmGoal1)
          --DeleteAIGoal(Objective4.dmGoal2)
          --DeleteAIGoal(Objective4.ctfGoal1)
          --DeleteAIGoal(Objective4.ctfGoal2)
      --end

    
-- Setting up Shield functionality --

    Init("01");
    Init("02");
    Init("03");
    Init("04");
    Init("05");
    Init("06");
    Init("07");


    OnObjectRespawnName(Revived, "generator_01");
    OnObjectKillName(ShieldDied, "force_shield_01");
    OnObjectKillName(ShieldDied, "generator_01");
    OnObjectKillName(RemoveMarker, "generator_01");
    

    OnObjectRespawnName(Revived, "generator_02");
    OnObjectKillName(ShieldDied, "force_shield_02");
    OnObjectKillName(ShieldDied, "generator_02");
    
    OnObjectRespawnName(Revived, "generator_03");
    OnObjectKillName(ShieldDied, "force_shield_03");
    OnObjectKillName(ShieldDied, "generator_03");
    
    -- Collector Shields --
    OnObjectKillName(CoreShield2, "cforce_shield_04");
    OnObjectKillName(CoreShield2, "cforce_shield_05");
    OnObjectKillName(CoreShield2, "cforce_shield_06");
    OnObjectKillName(CoreShield2, "cforce_shield_07");
    
    OnObjectKillName(CoreDied, "core");
    
    -- Back Generators --
    Generator = 2
    OnObjectKillName(GeneratorKill, "backgen2");
    OnObjectKillName(GeneratorKill, "backgen1");
    
--    OnObjectKillName(CoreShield2, "core")
    
    OnObjectKillName(DestroyShield1, "force_shield_01");    
    OnObjectKillName(DestroyShield2, "force_shield_02");
    OnObjectKillName(DestroyShield3, "force_shield_03");
    
    OnObjectKillName(DestroyShield1, "generator_01");
    OnObjectKillName(DestroyShield2, "generator_02");
    OnObjectKillName(DestroyShield3, "generator_03");
    
    OnObjectRespawnName(RepairShield1, "generator_01");
    OnObjectRespawnName(RepairShield2, "generator_02");
    OnObjectRespawnName(RepairShield3, "generator_03");
    
    
       EnableSPScriptedHeroes()
       
-- VO for low reinforcements -- 
    OnTicketCountChange(
		function (team, count)
			if team == ATT and count == 35 then				
				ScriptCB_SndPlaySound("rep_off_com_report_us_overwhelmed")
			elseif team == DEF and count == 10 then
				--play DEF is low on reinforce sound
			end
		end
		)
  
end

--OBJECTIVE SEQUENCER

function StartObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective2new)
    objectiveSequence:AddObjectiveSet(Objective2_1)
--    objectiveSequence:AddObjectiveSet(Objective2_2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:Start()
end
	
--Path Setup for Campaign--


function EnemyTrigger1()
	SetProperty("enemyspawn", "SpawnPath", "enemyspawn1")
	ScriptCB_SndPlaySound("MYG_inf_04")
end

function EnemyTrigger2()
	SetProperty("enemyspawn", "SpawnPath", "enemyspawn2")
	SetProperty("turretcp", "SpawnPath", "cpfight")
end
  
function LeftShield()
    --ShowMessageText("level.myg1.obj.c7", 1)
    SetProperty("enemyspawn", "SpawnPath", "enemyspawnl")
    SetProperty("CP2", "SpawnPath", "cp2spawnpath")
    SetProperty("CP4", "SpawnPath", "CP4SpawnPath")
    --SetProperty("CP2", "Value_ATK_Republic", "20")
    --SetProperty("CP4", "Value_ATK_Republic", "0")
    --MapAddEntityMarker("force_shield_01", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    --ScriptCB_SndPlaySound("MYG_obj_22")
end

function ShieldFunRun()
    ShowMessageText("level.myg1.obj.c7", 1)
    MapAddEntityMarker("force_shield_01", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    MapAddEntityMarker("generator_01", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    ScriptCB_SndPlaySound("MYG_obj_22")
end

function LeftShield2()
    SetProperty("enemyspawn", "SpawnPath", "lshield2")
    ActivateRegion("lback")
end
    
function LeftBack()
    SetProperty("enemyspawn", "SpawnPath", "lback")
end

function RightShield()
    ShowMessageText("level.myg1.obj.c7", 1)
    SetProperty("enemyspawn", "SpawnPath", "enemyspawnr")
    SetProperty("CP2", "SpawnPath", "cp2spawnpath")
    SetProperty("CP4", "SpawnPath", "CP4SpawnPath")
    --SetProperty("CP2", "Value_ATK_Republic", "0")
    --SetProperty("CP4", "Value_ATK_Republic", "20")
    MapAddEntityMarker("force_shield_03", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    ScriptCB_SndPlaySound("MYG_obj_22")
    DeactivateRegion("leftshield")
    ActivateRegion("lback")
end

function RightShield2()
    SetProperty("enemyspawn", "SpawnPath", "rshield2")
end




function TankSpawn()
    SetObjectTeam("tankspawn", 0)
end

function BackTrigger()
	SetProperty("core", "SpawnPath", "corespawn")
end

function CoreReminder()
    ShowMessageText("level.myg1.obj.c8", 1)
--    ScriptCB_SndPlaySound("MYG_obj_08")
    MapAddEntityMarker("backgen1", "hud_objective_icon", 3.0, 1, "YELLOW", true) 
    MapAddEntityMarker("backgen2", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    Ambush("magna2", ambushCount3, ambushTeam3)
    SetProperty("enemyspawn", "SpawnPath", "rshield2")
    SetProperty("newenemyspawn", "SpawnPath", "rshield2")
    ScriptCB_SndPlaySound("MYG_obj_34")
end

function CoreRunHome()
	--ShowMessageText("level.myg1.obj.c8", 1)
	SetProperty("enemyspawn", "SpawnPath", "corerun1")
	--ScriptCB_SndPlaySound("MYG_obj_20")
end

function CoreRunHome2()
	--ShowMessageText("level.myg1.obj.c8", 1)
	SetProperty("enemyspawn", "SpawnPath", "corerun2")
end

function CoreRunHome3()
	SetProperty("enemyspawn", "SpawnPath", "corerun3")
	Ambush("droideka2", ambushCount2, ambushTeam2)
	Ambush("testing", ambushCount4, ambushTeam4)
	MapRemoveEntityMarker("enemyspawn2")
--	SetProperty("repveh6", "MaxHealth", 1e+37)
--    SetProperty("repveh6", "CurHealth", 1e+37)
--	SetProperty("repveh6", "IsVisible", 1)
end

function CoreShield2()
--    ShowMessageText("level.myg1.obj.c9", 1)
--    ScriptCB_SndPlaySound("MYG_obj_09")
    	MapRemoveEntityMarker("backgen1")
    	MapRemoveEntityMarker("backgen2")
		PlayAnimation("cshield_down_04")
		PlayAnimation("cshield_down_05")
		PlayAnimation("cshield_down_06")
		PlayAnimation("cshield_down_07")
		Ambush("droideka", ambushCount2, ambushTeam2)
		SetProperty("enemyspawn2", "SpawnPath", "lastspawn")
		UnblockPlanningGraphArcs("incore")
		SetObjectTeam("tankspawn", 2)
end

function RemoveMarker()
	MapRemoveEntityMarker("force_shield_01")
end

function GeneratorKill()
	Generator = Generator - 1 
		if Generator == 0 then
		   CoreShield2()
		   ShowMessageText("level.myg1.obj.c9", 1)
		   ScriptCB_SndPlaySound("MYG_obj_09")
		  else
		end
end

	

function FlyerTrigger1()
	SetObjectTeam("repship", 1)
	MapAddEntityMarker("repveh6", "hud_objective_icon", 3.0, 1, "YELLOW", true)
	SetProperty("repveh6", "MaxHealth", 1e+37)
    SetProperty("repveh6", "CurHealth", 1e+37)
	--PlayAnimation("dropshipnew")
	ScriptCB_SndPlaySound("MYG_inf_07")
	
end

function NoRunCP()
	RespawnObject("norun")
end


	

--Start Shield Work

function Init(numberStr)
   
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldUp(shieldName, genName, upAnim, downAnim);
     
     BlockPlanningGraphArcs("shield_" .. numberStr);
     EnableBarriers("shield_" .. numberStr);
   
end

function ShieldDied(actor)
     fullName = GetEntityName(actor);
     numberStr = string.sub(fullName, -2, -1);
     
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldDown(shieldName, genName, upAnim, downAnim);
     
     UnblockPlanningGraphArcs("shield_" .. numberStr);
     DisableBarriers("shield_" .. numberStr);

end

--Rewarding player Mission Victory for Destorying the Core (mostly for MP) -- 

function CoreDied(actor)
--	ShowMessageText("level.myg1.obj.c8", 1)
	MapRemoveEntityMarker("backgen1")
    MapRemoveEntityMarker("backgen2")
    PlayAnimation("cshield_down_04")
    PlayAnimation("cshield_down_05")
	PlayAnimation("cshield_down_06")
	PlayAnimation("cshield_down_07")
	DisableBarriers("coresh1")
	SetProperty("backgen1", "MaxHealth", 1e+37)
    SetProperty("backgen1", "CurHealth", 1e+37)
    SetProperty("backgen2", "MaxHealth", 1e+37)
    SetProperty("backgen2", "CurHealth", 1e+37)
--    KillObject("backgen2")
--    KillObject("backgen1")
end

function Revived(actor)

     fullName = GetEntityName(actor);
     numberStr = string.sub(fullName, -2, -1);
     
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldUp(shieldName, genName, upAnim, downAnim);
     BlockPlanningGraphArcs("shield_" .. numberStr);
     EnableBarriers("shield_" .. numberStr);
end

-- Drop Shield
function PlayShieldDown(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj);
      KillObject(genObj);
      PauseAnimation(upAnim);
      RewindAnimation(downAnim);
      PlayAnimation(downAnim);
    
end
-- Put Shield Backup
function PlayShieldUp(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj);
      RespawnObject(genObj);
      PauseAnimation(downAnim);
      RewindAnimation(upAnim);
      PlayAnimation(upAnim);
end

 
function ScriptInit()
	StealArtistHeap(1500*1024)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4200000)
    ReadDataFile("ingame.lvl")

    --  Republic Attacking (attacker is always #1)
    local REP = 1
    local CIS = 2
    --  These variables do not change
    local ATT = 1
    local DEF = 2



    ReadDataFile("sound\\myg.lvl;myg1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_fly_assault_dome",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_fly_gunship_dome",
                             "uta_fly_ride_gunship",
                             "uta_fly_ride_gunshipmyg",
                             "rep_walk_oneman_atst",
                             --"rep_hover_fightertank",
                             --"uta1_prop_gunship",
                             "rep_hero_kiyadimundi")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             --"cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_fly_gunship_dome",
                             "cis_hover_aat",
                             --"cis_hero_jangofett",
                             "cis_inf_droideka")
                             --"cis_hero_countdooku")
         
    ReadDataFile("SIDE\\tur.lvl",
    						"tur_bldg_recoilless_lg",
    						"tur_bldg_recoilless_myg_auto")


    SetupTeams{

        rep={
            team = REP,
            units = 22,
            --reinforcements = 160,
            reinforcements = 60,
            soldier = {"rep_inf_ep3_rifleman"},
            assault = {"rep_inf_ep3_rocketeer"},
            engineer = {"rep_inf_ep3_engineer"},
            sniper  = {"rep_inf_ep3_sniper"},
            officer = {"rep_inf_ep3_officer"},
            special = {"rep_inf_ep3_jettrooper",1,4},
            
            
        },
        
        cis={
            team = CIS,
            units = 8,
            reinforcements = -1,
            soldier = {"cis_inf_rifleman"},
            assault = {"cis_inf_rocketeer"},
            --engineer = {"cis_inf_engineer",2,5},
            --sniper  = {"cis_inf_sniper",0},
            --officer = {"cis_inf_officer",0},
            --special = {"cis_inf_droideka",0},
         },
    }
    
    SetupTeams{
       cis={
       		team = CIS2,
       		units = 4,
       		reinforcements = -1,
       		soldier = {"cis_inf_rifleman"},
            assault = {"cis_inf_rocketeer"},
         }
    }

        
        
         --Pools of extra characters for Ambushes.
 	AddUnitClass(ambushTeam1, "cis_inf_officer")
    	SetUnitCount(ambushTeam1, ambushCount1)
	SetTeamAsEnemy(ambushTeam1, REP)
	AddAIGoal(ambushTeam1, "Deathmatch", 100)
	
	AddUnitClass(ambushTeam2, "cis_inf_droideka")
    	SetUnitCount(ambushTeam2, ambushCount2)
	SetTeamAsEnemy(ambushTeam2, REP)
	AddAIGoal(ambushTeam2, "Deathmatch", 100)	
	
	AddUnitClass(ambushTeam3, "cis_inf_officer")
    	SetUnitCount(ambushTeam3, ambushCount3)
	SetTeamAsEnemy(ambushTeam3, REP)
	AddAIGoal(ambushTeam3, "Deathmatch", 100)
	
    AddUnitClass(ambushTeam4, "cis_inf_rifleman")
    	SetUnitCount(ambushTeam4, ambushCount4)
	SetTeamAsEnemy(ambushTeam4, REP)
	AddAIGoal(ambushTeam4, "Deathmatch", 100)
	
	-- Setting up my Friends and Enemies -- 
    
    SetTeamAsEnemy(CIS2, REP)
    SetTeamAsEnemy(REP, CIS2)
    SetTeamAsEnemy(ambushTeam1, REP)
    SetTeamAsEnemy(REP, ambushTeam1)
    SetTeamAsEnemy(ambushTeam2, REP)
    SetTeamAsEnemy(REP, ambushTeam2)
    SetTeamAsEnemy(ambushTeam3, REP)
    SetTeamAsEnemy(REP, ambushTeam3)
    SetTeamAsEnemy(ambushTeam4, REP)
    SetTeamAsEnemy(REP, ambushTeam4)
    SetTeamAsEnemy(REP, CIS2)
    SetTeamAsFriend(ambushTeam1, CIS)
    SetTeamAsFriend(ambushTeam1, CIS2)
    SetTeamAsFriend(ambushTeam1, ambushTeam2)
    SetTeamAsFriend(ambushTeam1, ambushTeam3)
    SetTeamAsFriend(ambushTeam1, ambushTeam4)
    SetTeamAsFriend(ambushTeam2, CIS)
    SetTeamAsFriend(ambushTeam2, CIS2)
    SetTeamAsFriend(ambushTeam2, ambushTeam1)
    SetTeamAsFriend(ambushTeam2, ambushTeam3)
    SetTeamAsFriend(ambushTeam2, ambushTeam4)
    SetTeamAsFriend(ambushTeam3, CIS)
    SetTeamAsFriend(ambushTeam3, CIS2)
    SetTeamAsFriend(ambushTeam3, ambushTeam1)
    SetTeamAsFriend(ambushTeam3, ambushTeam2)
    SetTeamAsFriend(ambushTeam3, ambushTeam4)
    SetTeamAsFriend(ambushTeam4, CIS)
    SetTeamAsFriend(ambushTeam4, CIS2)
    SetTeamAsFriend(ambushTeam4, ambushTeam1)
    SetTeamAsFriend(ambushTeam4, ambushTeam2)
    SetTeamAsFriend(ambushTeam4, ambushTeam3)
    SetTeamAsFriend(CIS2, CIS)
    SetTeamAsFriend(CIS, CIS2)
    SetTeamAsFriend(CIS2, ambushTeam1)
    SetTeamAsFriend(CIS, ambushTeam1)
    SetTeamAsFriend(CIS2, ambushTeam2)
    SetTeamAsFriend(CIS, ambushTeam2)
    SetTeamAsFriend(CIS2, ambushTeam3)
    SetTeamAsFriend(CIS, ambushTeam3)
    SetTeamAsFriend(CIS2, ambushTeam4)
    SetTeamAsFriend(CIS, ambushTeam4)
	
	--AddUnitClass(ambushTeam2, "jed_knight_01")
    --	SetUnitCount(ambushTeam2, ambushCount2)
	--SetTeamAsEnemy(ambushTeam2, REP)
	--ClearAIGoals(ambushTeam2)
	--AddAIGoal(ambushTeam2, "Deathmatch", 100)
		
	--AddUnitClass(ambushTeam3, "jed_knight_01")
    --	SetUnitCount(ambushTeam3, ambushCount3)
	--SetTeamAsEnemy(ambushTeam3, REP)
	--ClearAIGoals(ambushTeam3)
	--AddAIGoal(ambushTeam3, "Deathmatch", 100)
		
	--AddUnitClass(ambushTeam4, "jed_knight_01")
    --	SetUnitCount(ambushTeam4, ambushCount4)
	--SetTeamAsEnemy(ambushTeam4, REP)
	--ClearAIGoals(ambushTeam4)
	--AddAIGoal(ambushTeam4, "Deathmatch", 100)
        
        --  Hero Setup Section  --

		SetHeroClass(REP, "rep_hero_kiyadimundi")
	  --SetHeroClass(CIS, "cis_hero_countdooku")
	  
	-- Setup for Swapping Units--

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    AddWalkerType(1, 4) -- ATRTa (special case: 0 leg pairs)
    local weaponCnt= 240
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 230)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 24)
    SetMemoryPoolSize("EntityFlyer", 3)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("MountedTurret", 16)
	SetMemoryPoolSize("Navigator", 45)
    SetMemoryPoolSize("Obstacle", 500)
    SetMemoryPoolSize("PathFollower", 45)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("UnitAgent", 60)
    SetMemoryPoolSize("UnitController", 60)
    SetMemoryPoolSize("Weapon", weaponCnt)
  
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("myg\\myg1.lvl", "myg1_assult")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(250)
    SetMaxPlayerFlyHeight(20)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "myg_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    -- OpenAudioStream("sound\\myg.lvl",  "myg_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\myg.lvl",  "myg1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    -- SetAmbientMusic(REP, 1.0, "rep_myg_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_myg_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_myg_amb_end",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_myg_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_myg_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


        --Camera Shizzle--
        
        -- Collector Shot
    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090);
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359);
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212);
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887);
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128);
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712);
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550);


end


