--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
    ScriptCB_DoFile("setup_teams")
    ScriptCB_DoFile("ObjectiveConquest")
    ScriptCB_DoFile("ObjectiveAssault")
    ScriptCB_DoFile("MultiObjectiveContainer")
    ScriptCB_DoFile("ObjectiveCTF")
    ScriptCB_DoFile("Ambush")
    ScriptCB_SetGameRules("campaign")

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
    --  Empire Attacking (attacker is always #1)
    ALL = 2
    IMP = 1
    --  These variables do not change
    ATT = 1
    DEF = 2
    
    rebels1 = 4
    rebels2 = 5

function ScriptPostLoad ()

SetMissionEndMovie("ingame.mvs", "hotmon02")

SetAIDifficulty(0, 2, "hard")

AddDeathRegion("fall")

DisableAIAutoBalance()

DisableBarriers("conquestbar")

ScriptCB_PlayInGameMovie("ingame.mvs", "hotmon01") 

-- Timer to Beat -- 
timeoutTimer = CreateTimer("timeout")
	SetTimerValue(timeoutTimer, 1260)
    ShowTimer(timeoutTimer)
    
    OnTimerElapse(
        function(timer)
            MissionVictory(DEF)
            ScriptCB_SndPlaySound("HOT_obj_07")
            ShowTimer(nil)
            DestroyTimer(timer)
        end,
        timeoutTimer
        )
     
FirstTransport = CreateTimer("FirstTransport")
	SetTimerValue(FirstTransport, 1240)
	
	OnTimerElapse(
        function(timer)
            PlayAnimation("takeoff")
        end,
        FirstTransport
        )
        
RealFirstTransport = CreateTimer("RealFirstTransport")
	SetTimerValue(RealFirstTransport, 10)
	
	OnTimerElapse(
        function(timer)
            PlayAnimation("takeoff2")
        end,
        RealFirstTransport
        )

        
-- Trigger Spawns --

--Activating -- 

ActivateRegion("trigger1")


   EnemyStart = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger1() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger1")
        end
    end,
    "trigger1"
    )
    
    EnemyStart2 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger2() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger2")
        end
    end,
    "trigger2"
    )
    
    EnemyStart3 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger3() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger3")
        end
    end,
    "trigger3"
    )
    
    EnemyStart5 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger5() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger5")
        end
    end,
    "trigger5"
    )
    
    OutVeh = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            ForceAIOutOfVehicles(2, true)
--            ShowMessageText("level.hoth.c.6d", 1)
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("outveh")
        end
    end,
    "outveh"
    )
    
    EnemyStart6 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger6() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger6")
        end
    end,
    "trigger6"
    )
    
    EnemyStart7 = OnEnterRegion(
    function(region, character) 
        if IsCharacterHuman(character) then 
            Trigger7() 
            --ReleaseEnterRegion(MusicTriggerTechRoom)
            DeactivateRegion("trigger7")
        end
    end,
    "trigger7"
    )
    	

-- Objective Setup -- 

  SetObjectTeam("CP6", 2)
  BlockPlanningGraphArcs("echobase")
  BlockPlanningGraphArcs("group2")
  BlockPlanningGraphArcs("atat")
  KillObject("CP4")
  KillObject("CP7OBJ")
  KillObject("CP7")
  KillObject("CP3")
  KillObject("hangarcp")
  KillObject("shieldgen")
  KillObject("newbomb")
  SetProperty("newbomb", "IsVisible", "0")
  
  
  --KillObject("ion_core")
  --KillObject("CP5")
  SetProperty("CP5", "AISpawnWeight", "13")
  SetProperty("enemyspawn", "IsVisible", 0)
  SetProperty("CP6", "SpawnPath", "")
  SetProperty("shield", "SpawnPath", "")
  SetProperty("CP3", "SpawnPath", "")
  SetProperty("ship", "MaxHealth", 1e+37)
  SetProperty("ship", "CurHealth", 1e+37)
  SetProperty("shield", "MaxHealth", 1e+37)
  SetProperty("shield", "CurHealth", 1e+37)
  SetProperty("ship", "MaxHealth", 1e+37)
  SetProperty("ship", "CurHealth", 1e+37)
  SetProperty("ship2", "MaxHealth", 1e+37)
  SetProperty("ship2", "CurHealth", 1e+37)
  SetProperty("ship3", "MaxHealth", 1e+37)
  SetProperty("ship3", "CurHealth", 1e+37)
  SetProperty("VehicleSpawn_21", "MaxHealth", 108000.0)
  SetProperty("VehicleSpawn_21", "CurHealth", 108000.0)
  SetProperty("VehicleSpawn_01", "MaxHealth", 108000.0)
  SetProperty("VehicleSpawn_01", "CurHealth", 108000.0)

  --SetProperty("newbomb", "MaxHealth", 1e+37)
  --SetProperty("newbomb", "CurHealth", 1e+37)
  SetProperty("CP5", "captureRegion", "CP3_Distraction")
  
    --Setup Timer-- 
    timePop = CreateTimer("timePop")
	SetTimerValue(timePop, 0.3)

ScriptCB_SetSpawnDisplayGain(0.2, 0.5) 

-- ON FIRST SPAWN --
  
      onfirstspawn = OnCharacterSpawn(
        function(character)
            if IsCharacterHuman(character) then
                ReleaseCharacterSpawn(onfirstspawn)
                onfirstspawn = nil
                ScriptCB_EnableCommandPostVO(0)
                ScriptCB_PlayInGameMusic("imp_hot_amb_obj1_2_explore")
                StartTimer(timePop)                                
                OnTimerElapse(
        			function(timer)
            			StartObjectives()
                		ScriptCB_SndPlaySound("HOT_obj_20")
            			DestroyTimer(timer)
            			StartTimer(timeoutTimer)
      					StartTimer(FirstTransport)
      					StartTimer(RealFirstTransport)
        			end,
        		timePop
        		)          
             end
        end)
  
  
  -- Objective First --
	ObjectiveNew = CommandPost:New{name = "CP6"}
    ObjectiveFirst = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.s", popupText = "level.hoth.c.pop.s"}
    ObjectiveFirst:AddCommandPost(ObjectiveNew)
    
    ObjectiveFirst.OnStart = function(self)
      --objectiveSequence.delayNextSetTime = 0.5
      AICanCaptureCP("CP6", ATT, false)
      ObjectiveFirst.defendGoal1 = AddAIGoal(DEF, "Defend", 300, "CP6");
      ObjectiveFirst.defendGoal2 = AddAIGoal(ATT, "Defend", 3000, "CP6");
      --SetProperty("CP6", "Value_ATK_Empire", "2000")
    end
    
    ObjectiveFirst.OnComplete = function(self)
      ShowMessageText("game.objectives.complete", ATT)
      SetProperty("CP6", "SpawnPath", "CP6_SpawnPath")
      DeleteAIGoal(ObjectiveFirst.defendGoal1)
      DeleteAIGoal(ObjectiveFirst.defendGoal2)
      Ambush("rebels1", 8, 4)
      Rebels1Goal = AddAIGoal(4, "Defend", 3000, "CP3");
      ATT_ReinforcementCount = GetReinforcementCount(ATT)
      SetReinforcementCount(ATT, ATT_ReinforcementCount + 30)
      if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_07")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_12")
	  end
      
    end
    

-- Objective 1 Stuff

    Objective1CP = CommandPost:New{name = "CP3"}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.1", popupText = "level.hoth.c.pop.1"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function(self)
      SetObjectTeam("CP6", 1)
      --objectiveSequence.delayNextSetTime = 0.5
      AICanCaptureCP("CP3", ATT, false)
      ActivateRegion("trigger2")
      RespawnObject("CP3")
      Objective1.defendGoal2 = AddAIGoal(ATT, "Defend", 3000, "CP3");
      Objective1.defendGoal1 = AddAIGoal(DEF, "Defend", 300, "CP3");
      SetProperty("CP6", "captureRegion", "CP3_Distraction")
    end
    
    Objective1.OnComplete = function(self)
      ShowMessageText("game.objectives.complete", ATT)
	  SetProperty("CP3", "SpawnPath", "CP3_SpawnPath")
	  SetProperty("enemyspawn", "SpawnPath", "spawn5")
	  UnblockPlanningGraphArcs("atat")
	  DisableBarriers("atat")
	  DeleteAIGoal(Objective1.defendGoal2)
	  DeleteAIGoal(Objective1.defendGoal1)
	  Ambush("rebels2", 8, 5)
	  ATT_ReinforcementCount = GetReinforcementCount(ATT)
	  SetReinforcementCount(ATT, ATT_ReinforcementCount + 20)
      Rebels2Goal = AddAIGoal(5, "Defend", 3000, "shieldgen")
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_13")
	    	ScriptCB_PlayInGameMusic("imp_hot_objComplete_01")
	    	 -- Music Timer -- 
		 music01Timer = CreateTimer("music01")
		SetTimerValue(music01Timer, 33.0)
				              
			StartTimer(music01Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("imp_hot_objComplete_01")
				ScriptCB_PlayInGameMusic("imp_hot_amb_action_01")
				DestroyTimer(timer)
			end,
			music01Timer
                        )
	    end
    end
    
--Objective 2 Stuff- Assault
    
    ShieldGen = Target:New{name = "shield"}
    Objective2 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.2", popupText = "level.hoth.c.pop.2", AIGoalWeight = 0.0}
    Objective2:AddTarget(ShieldGen)
    
    Objective2.OnStart = function(self)
    	SetObjectTeam("CP3", 1)
    	--objectiveSequence.delayNextSetTime = 0.5
    	SetProperty("shield", "MaxHealth", 120000.0)
 		SetProperty("shield", "CurHealth", 120000.0)
        SetAIDamageThreshold("shield", 0.2)
        
        --GOALS--
    	Objective2.defendGoal1 = AddAIGoal(DEF, "Defend", 30, "CP5")
    	Objective2.defendGoal2 = AddAIGoal(DEF, "Deathmatch", 100)
    	Objective2.defendGoal3 = AddAIGoal(ATT, "Destroy", 100, "shield")
    	--Objective2.defendGoal3 = AddAIGoal(ATT, "Deathmatch", 300)
    	Rebels2Goal = AddAIGoal(5, "Defend", 3000, "shieldgen")
    	
     	SetProperty("CP3", "captureRegion", "CP3_Distraction")
     	--Objective2.dmGoal1 = AddAIGoal(DEF, "Deathmatch", 500)

     end
     
     Objective2.OnComplete = function(self)
     	ShowMessageText("game.objectives.complete", ATT)
     	Ambush("rebels1_2", 8, 4)
     	SetProperty("CP5", "captureRegion", "CP5_Capture")
     	ATT_ReinforcementCount = GetReinforcementCount(ATT)
     	SetReinforcementCount(ATT, ATT_ReinforcementCount + 30)
     	
     	-- DELETING GOALS--
     	DeleteAIGoal(Objective2.defendGoal1)
     	DeleteAIGoal(Objective2.defendGoal2)
     	DeleteAIGoal(Objective2.defendGoal3)
     	
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_PlayInGameMovie("ingame.mvs", "hot1cam2")
	    end
    end
    
    
--Objective 4 Stuff

  Objective4CP = CommandPost:New{name = "CP5"}
    Objective4 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.4", popupText = "level.hoth.c.pop.4"}
    Objective4:AddCommandPost(Objective4CP)
    
  Objective4.OnStart = function(self)
  		--objectiveSequence.delayNextSetTime = 0.5
  		ScriptCB_SndPlaySound("HOT_obj_14")
  		ScriptCB_PlayInGameMusic("imp_hot_amb_obj4_explore")
  		RespawnObject("shieldgen")
  		AICanCaptureCP("CP5", ATT, false)
  		SetSpawnDelayTeam(9.5, 3.5, DEF)
  		ActivateRegion("trigger5")
  		ActivateRegion("outveh")
  		
        --GOALS
        Objective4.defendDEF = AddAIGoal(DEF, "Defend", 8000, "CP5");
        Objective4.defendATT = AddAIGoal(ATT, "Defend", 3000, "CP5");
        
        SetProperty("enemyspawn", "SpawnPath", "SPAWN4")
        SetProperty("enemyspawn", "AISpawnWeight", "5000")
        SetProperty("shieldgen", "AISpawnWeight", "5000")
    end
    
    Objective4.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	KillObject("echo_shield1")
        KillObject("echo_shield2")
        ScriptCB_SndPlaySound("HOT_obj_22")
        ATT_ReinforcementCount = GetReinforcementCount(ATT)
        SetReinforcementCount(ATT, ATT_ReinforcementCount + 10)
	ScriptCB_PlayInGameMusic("imp_hot_objComplete_02")
	 -- Music Timer -- 
	 music03Timer = CreateTimer("music03")
	SetTimerValue(music03Timer, 27.0)			              
		StartTimer(music03Timer)
		OnTimerElapse(
			function(timer)
			ScriptCB_StopInGameMusic("imp_hot_objComplete_02")
			ScriptCB_PlayInGameMusic("imp_hot_amb_obj5_6_explore")
			DestroyTimer(timer)
		end,
		music03Timer
                )        
        
        --DELETING GOALS--
     	DeleteAIGoal(Objective4.defendATT)
     	
     	ForceAIOutOfVehicles(1, true)
        UnblockPlanningGraphArcs("echobase")
        SetProperty("CP5", "captureRegion", "CP3_Distraction")
        SetProperty("enemyspawn", "SpawnPath", "spawn6")
        SetProperty("shieldgen", "AISpawnWeight", "0")
        SetProperty("CP5", "AISpawnWeight", "5000")
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_06")
	    end
    end
    
    
    Console = Target:New{name = "console"}
    Objective5 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.5", popupText = "level.hoth.c.pop.5"}
    Objective5:AddTarget(Console)
    
    Objective5.OnStart = function(self)
    	SetObjectTeam("CP5", 1)
    	UnlockHeroForTeam(1)
    	Ambush("hangarspawn", 8, 4)
    	--objectiveSequence.delayNextSetTime = 0.5
    	SetAIDamageThreshold("console", 0.5)
    	SetProperty("console", "MaxHealth", 500)
  		SetProperty("console", "CurHealth", 500)
  		Objective5.defendGoal2 = AddAIGoal(DEF, "Defend", 1000, "hangarcp");
    	Objective5.defendGoal1 = AddAIGoal(DEF, "Defend", 10, "CP5");
    end
    
    Objective5.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	KillObject("echoback1")
    	KillObject("echoback2")
    	UnblockPlanningGraphArcs("group2")
    	RespawnObject("hangarcp")
    	ActivateRegion("trigger6")
    	ActivateRegion("trigger7")
    	SetProperty("enemyspawn2", "AISpawnWeight", "5000")
    	SetProperty("enemyspawn2", "SpawnPath", "enemyspawn2path")
    	SetProperty("enemyspawn", "SpawnPath", "spawn7")
    	Ambush("hangarspawn", 8, 5)
    	Ambush("enemyspawn2path", 8, 4)
    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_19")
	    end
    end
    
    Objective9CP = CommandPost:New{name = "hangarcp"}
    Objective9 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.hoth.c.8", popupText = "level.hoth.c.pop.8"}
    Objective9:AddCommandPost(Objective9CP)
    
    Objective9.OnStart = function(self)
    	--objectiveSequence.delayNextSetTime = 0.5
    	Objective9.defendGoal1 = AddAIGoal(ATT, "Defend", 3000, "hangarcp");
    	--Objective9:Complete(ATT)
    end
    
    Objective9.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
    	ATT_ReinforcementCount = GetReinforcementCount(ATT)
    	SetReinforcementCount(ATT, ATT_ReinforcementCount + 30)
    	PlayAnimation("gundrop")
    	SetProperty("falcon", "IsVisible", "0")
  		SetProperty("falcon", "IsCollidable", "0")
  		SetProperty("falconl1", "IsVisible", "0")
  		SetProperty("falconl1", "IsCollidable", "0")
  		SetProperty("falconl2", "IsVisible", "0")
  		SetProperty("falconl2", "IsCollidable", "0")
  		SetProperty("falconl3", "IsVisible", "0")
  		SetProperty("falconl3", "IsCollidable", "0")
  		SetProperty("falconl4", "IsVisible", "0")
  		SetProperty("falconl4", "IsCollidable", "0")
  		SetProperty("falconl5", "IsVisible", "0")
  		SetProperty("falconl5", "IsCollidable", "0")
  		KillObject("gun1")
  		Ambush("spawn10", 8, 5)
    	Ambush("spawn10", 8, 4)
  		
  		Holocron1Spawn = GetPathPoint("becon", 0)
        CreateEntity("hot1_flag_bomb", Holocron1Spawn, "holodisk")
        SetProperty("holodisk", "AllowAIPickUp", 0)
        --SetObjectTeam("hangarcp", 1)
        SetProperty("hangarcp", "captureRegion", "CP3_Distraction")
        SetProperty("hangarcp", "AISpawnWeight", "5000")
        SetProperty("CP5", "AISpawnWeight", "500")
        DeleteAIGoal(Objective5.defendGoal2)
        DeleteAIGoal(Objective5.defendGoal1)
--        DeleteAIGoal(Objective9.defendGoal1)
        
        if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_PlayInGameMovie("ingame.mvs", "hot1cam1")
	    end
	end
  		
    
    Objective6 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, 
            text = "level.hoth.c.6", 
            popupText = "level.hoth.c.pop.6",
            showTeamPoints = false,
            AIGoalWeight = 1.0}
        
    Objective6:AddFlag{name = "holodisk", captureRegion = "dropoff",
            capRegionMarker = "imp_icon", capRegionMarkerScale = 3.0, 
            mapIcon = "flag_icon", mapIconScale = 2.0}
    
    Objective6.OnStart = function(self)
    	SetObjectTeam("hangarcp", 1)
    	SetSpawnDelayTeam(9.5, 3.5, DEF)
--    	SetSpawnDelayTeam(10.0, 1.5, DEF)
    	DeleteAIGoal(Objective9.defendGoal1)
    	ScriptCB_SndPlaySound("HOT_obj_21")
    	ScriptCB_PlayInGameMusic("imp_hot_amb_action_02")
    	--objectiveSequence.delayNextSetTime = 0.5
    	Objective6.defendGoal1 = AddAIGoal(DEF, "Defend", 1000, "enemyspawn2")
    	Objective6.defendGoal2 = AddAIGoal(ATT, "Defend", 5000, "enemyspawn2")
    	SetProperty("enemyspawn", "SpawnPath", "spawn10")
  		SetProperty("enemyspawn2", "SpawnPath", "spawn10")
    	--Objective6.defendGoal1 = AddAIGoal(DEF, "Deathmatch", 500);
    	plans_capture_on = OnFlagPickUp(
    	function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("enemyspawn2", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
				ShowMessageText("level.hoth.c.6d", 1)		
			end
		end,
		"holodisk"
		)
    end
    
    Objective6.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
--    	MapRemoveEntityMarker("enemyspawn2")
    	RespawnObject("newbomb")
    	SetProperty("newbomb", "IsVisible", "1")
    	StopTimer("timeout")
    	StopTimer("FirstTransport")
    	DeleteAIGoal(Objective6.defendGoal1)
    	DeleteAIGoal(Objective6.defendGoal2)
    	ATT_ReinforcementCount = GetReinforcementCount(ATT)
      	SetReinforcementCount(ATT, ATT_ReinforcementCount + 15)

    	if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_09")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_23")
	    	ScriptCB_PlayInGameMusic("imp_hot_immVict_01")
	    end
    end
    
    Bomb = Target:New{name = "newbomb"}
    Objective7 = ObjectiveAssault:New{teamATT = DEF, teamDEF = ATT, textDEF = "level.hoth.c.7", popupText = "level.hoth.c.pop.7", timeLimit = 60, timeLimitWinningTeam = ATT}
    Objective7:AddTarget(Bomb)
    
    Objective7.OnStart = function(self)
    	SetProperty("hangarcp", "SpawnPath", "lastobj")
    	MapRemoveEntityMarker("enemyspawn2")
    	MapAddEntityMarker("newbomb", "hud_objective_icon", 3.0, 1, "YELLOW", true)
    	--objectiveSequence.delayNextSetTime = 0.5
    	SetProperty("newbomb", "MaxHealth", 11000)
 		SetProperty("newbomb", "CurHealth", 11000)
 		SetSpawnDelayTeam(1.0, 1.0, DEF)
    	Objective7.defendGoal1 = AddAIGoal(ATT, "Defend", 3000, "newbomb")
    	Objective7.defendGoal1 = AddAIGoal(DEF, "Destroy", 5000, "newbomb")
--    	Objective7.defendGoal1 = AddAIGoal(DEF, "Destroy", 5000, "newbomb")
  		--SetProperty("newbomb", "IsCollidable", "1")
  		
    end
    
    Objective7.OnComplete = function(self)
    	ShowMessageText("game.objectives.complete", ATT)
--    	KillObject("ship")
		if self.winningTeam == DEF then
    		ScriptCB_SndPlaySound("HOT_obj_10")
    	else
    		--play the win sound
	    	ScriptCB_SndPlaySound("HOT_obj_24")
	    end	
--    	ScriptCB_SndPlaySound("HOT_obj_25")
    end
    
function StartObjectives()     
    objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 12.0}
    
    objectiveSequence:AddObjectiveSet(ObjectiveFirst)
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective9)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:AddObjectiveSet(Objective7)
    objectiveSequence:Start()
end
    
    
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


-- Trigger Region Functions -- 
function Trigger1()
	SetProperty("enemyspawn", "SpawnPath", "spawn2")
	--ShowMessageText("level.myg1.obj.c7", 1)
end

function Trigger2()
	SetProperty("enemyspawn", "SpawnPath", "spawn3")
	--ShowMessageText("level.myg1.obj.c7", 1)
end

function Trigger3()
	--ShowMessageText("level.myg1.obj.c7", 1)
end

function Trigger5()
	SetSpawnDelayTeam(9.5, 7.5, DEF)
	SetProperty("enemyspawn", "SpawnPath", "spawn51")
end

function Trigger6()
	SetProperty("enemyspawn", "SpawnPath", "spawn8")
	DeleteAIGoal(Objective4.defendDEF)
end

function Trigger7()
	SetProperty("enemyspawn", "SpawnPath", "spawn9")
	--ShowMessageText("level.myg1.obj.c7", 1)
end


function ScriptInit()
    StealArtistHeap(1024*1024)	-- steal 1MB from art heap
    -- Designers, these two lines *MUST* be first.
    --SetPS2ModelMemory(42073760)
    --SetPS2ModelMemory(4800000)
    SetPS2ModelMemory(3300000)
    ReadDataFile("ingame.lvl")
    EnableSPScriptedHeroes()  


    SetMaxFlyHeight(70)
    SetMaxPlayerFlyHeight(70)

    ReadDataFile("sound\\hot.lvl;hot1gcw")
    ReadDataFile("SIDE\\all.lvl",
                             "all_fly_snowspeeder",
                             "all_inf_rifleman_snow",
                             "all_inf_rocketeer_snow",
--                             "all_inf_engineer_snow",
                             "all_inf_sniper_snow",
                             --"all_hero_luke_jedi",
                             --"all_inf_officer_snow",
                             --"all_hero_luke_jedi",
                             --"all_inf_wookiee_snow",
                             "all_walk_tauntaun")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_inf_rifleman_snow",
                             "imp_inf_rocketeer_snow",
                             "imp_inf_sniper_snow",
                             "imp_inf_dark_trooper",
                             "imp_inf_engineer_snow",
                             "imp_inf_officer",
                             "imp_hero_darthvader",
                             "imp_walk_atat",
                             "imp_walk_atst_snow")
                             
    ReadDataFile("SIDE\\tur.lvl",
    					"tur_bldg_hoth_dishturret",
						"tur_bldg_hoth_lasermortar",
						"tur_bldg_chaingun_tripod",
						--	"tur_bldg_chaingun",
						"tur_bldg_chaingun_roof")

    SetupTeams{

        all={
            team = ALL,
            units = 23,
            reinforcements = -1,
            soldier  = {"all_inf_rifleman_snow"},
            assault  = {"all_inf_rocketeer_snow"},
--            engineer = {"all_inf_engineer_snow"},
            sniper   = {"all_inf_sniper_snow", 4},
            --officer  = {"all_inf_officer_snow"},
            --special  = {"all_inf_wookiee_snow"},
            
        },
        
        imp={
            team = IMP,
            units = 17,
            reinforcements = 35,
            soldier = {"imp_inf_rifleman_snow"},
            assault = {"imp_inf_rocketeer_snow"},
            engineer   = {"imp_inf_engineer_snow"},
            sniper  = {"imp_inf_sniper_snow"},
            officer = {"imp_inf_officer", 2, 4},
            special = {"imp_inf_dark_trooper", 2, 4},
        }
    }

--Setting up Heros--

    SetHeroClass(IMP, "imp_hero_darthvader")
    --SetHeroClass(ALL, "all_hero_luke_jedi")
    
--Ambush Teams true

	SetTeamName(rebels1, "all")
    SetUnitCount(rebels1, 8)
    AddUnitClass(rebels1, "all_inf_rifleman_snow", 2)
    AddUnitClass(rebels1, "all_inf_rocketeer_snow", 2)
    AddUnitClass(rebels1, "all_inf_engineer_snow", 2)
    AddUnitClass(rebels1, "all_inf_sniper_snow", 2)
    SetReinforcementCount(rebels1, -1)
    
    SetTeamAsEnemy(rebels1, IMP)
    SetTeamAsFriend(rebels1, ALL)
    SetTeamAsFriend(ALL, rebels1)
    
    SetTeamName(rebels2, "all")
    SetUnitCount(rebels2, 8)
    AddUnitClass(rebels2, "all_inf_rifleman_snow", 2)
    AddUnitClass(rebels2, "all_inf_rocketeer_snow", 2)
    AddUnitClass(rebels2, "all_inf_engineer_snow", 2)
    AddUnitClass(rebels2, "all_inf_sniper_snow", 2)
    SetReinforcementCount(rebels2, -1)
    
    SetTeamAsEnemy(rebels2, IMP)
    SetTeamAsFriend(rebels2, ALL)
    SetTeamAsFriend(ALL, rebels2)
    SetTeamAsFriend(rebels1, rebels2)
    SetTeamAsFriend(rebels2, rebels1)
    
    local weaponCnt = 350
    --  Level Stats
    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -2)
    AddWalkerType(0, 0) -- 0 droidekas
    AddWalkerType(1, 4) -- 6 atsts with 1 leg pairs each
    AddWalkerType(2, 2) -- 2 atats with 2 leg pairs each

	SetMemoryPoolSize("ActiveRegion", 32)
    SetMemoryPoolSize("Aimer", 90)
	SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 248)
    SetMemoryPoolSize("CommandWalker", 2)
    SetMemoryPoolSize("ConnectivityGraphFollower", 56)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntityFlyer", 12)
    SetMemoryPoolSize("EntityLight", 218)
    SetMemoryPoolSize("EntitySoundStatic", 13)
    SetMemoryPoolSize("EntitySoundStream", 6)
    SetMemoryPoolSize("FlagItem", 1)
	SetMemoryPoolSize("FLEffectObject::OffsetMatrix", 54)
    SetMemoryPoolSize("MountedTurret", 46)
    SetMemoryPoolSize("Navigator", 42)
    SetMemoryPoolSize("Obstacle", 395)
  SetMemoryPoolSize("OrdnanceTowCable", 40) -- !!!! need +4 extra for wrapped/fallen cables !!!!
    SetMemoryPoolSize("PathFollower", 42)
	SetMemoryPoolSize("PathNode", 268)
	SetMemoryPoolSize("RedOmniLight", 230)
    SetMemoryPoolSize("TreeGridStack", 342)
    SetMemoryPoolSize("UnitController", 61)
    SetMemoryPoolSize("UnitAgent", 61)
	SetMemoryPoolSize("Weapon", weaponCnt)

    ReadDataFile("HOT\\hot1.lvl","hoth_objective")
--    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    SetDefenderSnipeRange(170)
    SetGroundFlyerMap(1);
    --AddDeathRegion("Death")

    --  Local Stats
    --  SetTeamName(3, "Local")
    --  AddUnitClass(3, "snw_inf_wampa", 1)
    --  SetUnitCount(3, 1)
    --  SetTeamAsEnemy(3,ATT)
    --  SetTeamAsEnemy(3,DEF)

    --Attacker Stats
    --if(ScriptCB_GetPlatform() == "PS2") then
    --    SetUnitCount(ATT, 25)
    -- else
    --    SetUnitCount(ATT, 28)
    --end


    --Defender Stats

    --if(ScriptCB_GetPlatform() == "PS2") then
        --SetUnitCount(DEF, 25)
    --else
        --SetUnitCount(DEF, 28)
    --end


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "hot_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)
    
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    -- OpenAudioStream("sound\\hot.lvl",  "hot_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")
    OpenAudioStream("sound\\hot.lvl", "hot1gcw")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    --SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .75, 1)
    --SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .5, 1)
    --SetLowReinforcementsVoiceOver(ALL, IMP, "all_hot_transport_away", .25, 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    -- SetAmbientMusic(ALL, 1.0, "all_hot_amb_start",  0,1)
    -- SetAmbientMusic(ALL, 0.5, "all_hot_amb_middle", 1,1)
    -- SetAmbientMusic(ALL, 0.25,"all_hot_amb_end",    2,1)
    -- SetAmbientMusic(IMP, 1.0, "imp_hot_amb_start",  0,1)
    -- SetAmbientMusic(IMP, 0.5, "imp_hot_amb_middle", 1,1)
    -- SetAmbientMusic(IMP, 0.25,"imp_hot_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_hot_amb_victory")
    SetDefeatMusic (ALL, "all_hot_amb_defeat")
    SetVictoryMusic(IMP, "imp_hot_amb_victory")
    SetDefeatMusic (IMP, "imp_hot_amb_defeat")

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
    --Hoth
    --Hangar
    AddCameraShot(0.944210, 0.065541, 0.321983, -0.022350, -500.489838, 0.797472, -68.773849)
    --Shield Generator
    AddCameraShot(0.371197, 0.008190, -0.928292, 0.020482, -473.384155, -17.880533, 132.126801)
    --Back Hangar
    AddCameraShot(0.990313, -0.084493, 0.109784, 0.009367, -370.947021, 2.597793, -221.730988);
end
 