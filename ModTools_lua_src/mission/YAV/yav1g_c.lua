 	--TEST
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- This is the Campaign Sript for YAVIN 4, Revenge of the Empire map name yav1g_c (Designer: P. Baker)

ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveGoto")     
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("Ambush")

ATT = 1
DEF = 2
AMS = 3
BOS = 4





IMP = ATT
ALL = DEF

ambushTeamAMS = AMS

ambushcount1 = 1
ambushCount3 = 3
ambushCount4 = 4   
ambushCount5 = 5
ambushCount8 = 8    
ambushCount10 = 10
ambushCount15 = 15

function ScriptPostLoad ()
	ScriptCB_SetGameRules("campaign")
	SetAIDifficulty(0, 0, "medium")
	DisableAIAutoBalance()
    BlockPlanningGraphArcs (1)
	SetMissionEndMovie("ingame.mvs", "yavmon02")

	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")
	    AddDeathRegion("death5")
	    AddDeathRegion("death6")
	    AddDeathRegion("death7")
	    AddDeathRegion("death8") 
	
	KillObject ("TempleCamp")
	
--	KillObject ("TflankCamp")
--	KillObject ("TflankVehicles1")
--	KillObject ("TflankVehicles2")
	
	KillObject ("ReflectingPoolCamp")
	KillObject ("ReflectingVehicles1")
	KillObject ("ReflectingVehicles2")
	
	KillObject ("ViaductCamp")
	KillObject ("ViaDuctVehicle1")
	KillObject ("ViaDuctVehicle2")

	

	SetProperty ("TflankCamp","Value_ATK_Empire",0)
	SetProperty ("TflankCamp","Value_DEF_Empire",0)
	SetProperty ("TflankCamp","Value_ATK_Alliance",0)
	SetProperty ("TflankCamp","Value_DEF_Alliance",0)
	
	SetProperty ("CP1Camp","Value_ATK_Empire",0)
	SetProperty ("CP1Camp","Value_DEF_Empire",0)
	SetProperty ("CP1Camp","Value_ATK_Alliance",0)
	SetProperty ("CP1Camp","Value_DEF_Alliance",0)
	
	ScriptCB_SetSpawnDisplayGain(0.2, 0.5)


	
	ScriptCB_PlayInGameMovie("ingame.mvs","yavmon01")
	

        
    onfirstspawn = OnCharacterSpawn( 
        function(character)
            if IsCharacterHuman(character) then
            	ReleaseCharacterSpawn(onfirstspawn)
	        onfirstspawn = nil
            	objectives_timer = CreateTimer("objectives_timer")
            	SetTimerValue(objectives_timer, 2)
            	StartTimer(objectives_timer)
            	begin_objectives = OnTimerElapse(
            		function(timer)
	                	StartObjectives ()
	                	ScriptCB_EnableCommandPostVO(0)
	                	ScriptCB_SndPlaySound("YAV_obj_09")
	               		ScriptCB_PlayInGameMusic("imp_yav_amb_obj1_2_explore")
               		end,
               		objectives_timer
               		)
            end
        end
        )
	
-- OBJECTIVE 1: Capture Fountain CP (BAZZAR)


       
    Objective1CP = CommandPost:New{name = "BazaarCamp", hideCPs = False}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.yavin1.objectives.Campaign.1", popupText = "level.yavin1.objectives.Campaign.1_popup"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function (self)
    
    	AICanCaptureCP("BazaarCamp", ATT, false)
    	AICanCaptureCP("BazaarCamp", DEF, true)
    	AICanCaptureCP("BazaarCamp", AMS, true)
    	
		SetupAmbushTrigger("AltRouteTrigger","Altpath_spawn", ambushCount8, ambushTeamAMS)
		SetupAmbushTrigger("BazaarCaptureCamp","ftrigger", ambushCount8, ambushTeamAMS) --Library Side Door 1
		
    	--SetProperty ("BazaarCamp","SpawnPath","CP1CampSpawn")

    	ATTConquest = AddAIGoal (ATT,"Conquest",100)
    	DEFDefend = AddAIGoal (DEF,"Defend",100,"BazaarCamp")
    	
    	AMSDefend = AddAIGoal (AMS,"Defend",100,"BazaarCamp")

		-- EMPIRE CP ATTACK WEIGHTS        
		SetProperty ("BazaarCamp","Value_ATK_Empire",10)
		SetProperty ("cp1camp","Value_ATK_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_ATK_Empire",0)
		SetProperty ("tflankcamp","Value_ATK_Empire",0)
		SetProperty ("viaductcamp","Value_ATK_Empire",0)
		SetProperty ("TempleCamp","Value_ATK_Empire",0)
		SetProperty ("landingzonecamp","Value_ATK_Empire",0)
		-- EMPIRE CP DEFENSE WEIGHTS
		SetProperty ("BazaarCamp","Value_DEF_Empire",0)
		SetProperty ("cp1camp","Value_DEF_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_DEF_Empire",0)
		SetProperty ("tflankcamp","Value_DEF_Empire",0)
		SetProperty ("viaductcamp","Value_DEF_Empire",0)
		SetProperty ("TempleCamp","Value_DEF_Empire",0)
		SetProperty ("landingzonecamp","Value_DEF_Empire",0)
		-- REBEL CP ATTACK WEIGHTS		
        SetProperty ("BazaarCamp","Value_ATK_Alliance",0)
        SetProperty ("cp1camp","Value_ATK_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_ATK_Alliance",0)
        SetProperty ("tflankcamp","Value_ATK_Alliance",0)
        SetProperty ("viaductcamp","Value_ATK_Alliance",0)
        SetProperty ("TempleCamp","Value_ATK_Alliance",0)
        SetProperty ("landingzonecamp","Value_ATK_Alliance",0)
		-- REBEL CP DEFENSE WEIGHTS
        SetProperty ("BazaarCamp","Value_DEF_Alliance",10)
        SetProperty ("cp1camp","Value_DEF_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_DEF_Alliance",0)
        SetProperty ("tflankcamp","Value_DEF_Alliance",0)
        SetProperty ("viaductcamp","Value_DEF_Alliance",0)
        SetProperty ("TempleCamp","Value_DEF_Alliance",0)
        SetProperty ("landingzonecamp","Value_DEF_Alliance",0)

    end
    
	Objective1.OnComplete = function (self)
		
		SetProperty ("BazaarCamp", "Team", 1)
    	AICanCaptureCP("BazaarCamp", ATT, true)
    	AICanCaptureCP("BazaarCamp", DEF, false)
    	AICanCaptureCP("BazaarCamp", AMS, false)
    	
    	
		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 20)
    
    	DeleteAIGoal(ATTConquest)
	    DeleteAIGoal(DEFDefend)
	    
	    DeleteAIGoal(AMSDefend)
	    ShowMessageText("game.objectives.complete", ATT)

	end
    
     

-- OBJECTIVE 3: Capture ViaDuct CP (with rocketeer ambushes)

	Objective3CP = CommandPost:New{name = "ViaDuctCamp", hideCPs = False}
    Objective3 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.yavin1.objectives.Campaign.3", popupText = "level.yavin1.objectives.Campaign.3_popup"}
    Objective3:AddCommandPost(Objective3CP)
    
    Objective3.OnStart = function (self)
   		KillObject ("Spawn_Land3Camp")
    	KillObject ("Spawn_Land1Camp")
    	SetProperty ("BazaarCamp", "AISpawnWeight", 100)
        ScriptCB_SndPlaySound("YAV_obj_18")
        ScriptCB_PlayInGameMusic("imp_yav_objComplete_01")
         -- Music Timer -- 
	 music01Timer = CreateTimer("music01")
	SetTimerValue(music01Timer, 33.0)
			              
		StartTimer(music01Timer)
		OnTimerElapse(
			function(timer)
			ScriptCB_StopInGameMusic("imp_yav_objComplete_01")
			ScriptCB_PlayInGameMusic("imp_yav_amb_obj3_5_explore")
			DestroyTimer(timer)
		end,
		music01Timer
                )
        
        AICanCaptureCP("ViaDuctCamp", ATT, false)
    	AICanCaptureCP("ViaDuctCamp", DEF, true)
    	AICanCaptureCP("ViaDuctCamp", AMS, true)
    	
    

   		SetupAmbushTrigger("ViaDuctTrigger","ViaDuctAmbushPath", ambushCount8, ambushTeamAMS)
 
    	RespawnObject ("ViaDuctCamp")
    	RespawnObject ("ViaDuctVehicle1")
		RespawnObject ("ViaDuctVehicle2")
    	
   	
		
		   	
    	ATTConquest = AddAIGoal (ATT,"Conquest",100)
    	DEFDefend = AddAIGoal (DEF,"Defend",100,"ViaDuctCamp")
    	
    	AMSDeathmatch = AddAIGoal (AMS,"Deathmatch",100)

		-- EMPIRE CP ATTACK WEIGHTS        
		SetProperty ("BazaarCamp","Value_ATK_Empire",0)
		SetProperty ("cp1camp","Value_ATK_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_ATK_Empire",0)
		SetProperty ("tflankcamp","Value_ATK_Empire",0)
		SetProperty ("viaductcamp","Value_ATK_Empire",10)
		SetProperty ("TempleCamp","Value_ATK_Empire",0)
		SetProperty ("landingzonecamp","Value_ATK_Empire",0)
		-- EMPIRE CP DEFENSE WEIGHTS
		SetProperty ("BazaarCamp","Value_DEF_Empire",0)
		SetProperty ("cp1camp","Value_DEF_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_DEF_Empire",0)
		SetProperty ("tflankcamp","Value_DEF_Empire",0)
		SetProperty ("viaductcamp","Value_DEF_Empire",0)
		SetProperty ("TempleCamp","Value_DEF_Empire",0)
		SetProperty ("landingzonecamp","Value_DEF_Empire",0)
		-- REBEL CP ATTACK WEIGHTS		
        SetProperty ("BazaarCamp","Value_ATK_Alliance",0)
        SetProperty ("cp1camp","Value_ATK_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_ATK_Alliance",0)
        SetProperty ("tflankcamp","Value_ATK_Alliance",0)
        SetProperty ("viaductcamp","Value_ATK_Alliance",0)
        SetProperty ("TempleCamp","Value_ATK_Alliance",0)
        SetProperty ("landingzonecamp","Value_ATK_Alliance",0)
		-- REBEL CP DEFENSE WEIGHTS
        SetProperty ("BazaarCamp","Value_DEF_Alliance",0)
        SetProperty ("cp1camp","Value_DEF_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_DEF_Alliance",0)
        SetProperty ("tflankcamp","Value_DEF_Alliance",0)
        SetProperty ("viaductcamp","Value_DEF_Alliance",10)
        SetProperty ("TempleCamp","Value_DEF_Alliance",0)
        SetProperty ("landingzonecamp","Value_DEF_Alliance",0)

    end

	Objective3.OnComplete = function (self)
		KillObject ("LandingZoneCamp")
	
		SetProperty ("ViaDuctCamp", "Team", 1)
    	AICanCaptureCP("ViaDuctCamp", ATT, true)
    	AICanCaptureCP("ViaDuctCamp", DEF, false)
    	AICanCaptureCP("ViaDuctCamp", AMS, false)
    	
    	DeleteAIGoal(ATTConquest)
	    DeleteAIGoal(DEFDefend)
	    
	    DeleteAIGoal(AMSDeathmatch)
	    
      	


		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 20)
	    ShowMessageText("game.objectives.complete", ATT)
	end
	
-- OBJECTIVE 4: Capture ReflectingPoolCamp

	Objective4CP = CommandPost:New{name = "ReflectingPoolCamp", hideCPs = False}
    Objective4 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.yavin1.objectives.Campaign.4", popupText = "level.yavin1.objectives.Campaign.4_popup"}
    Objective4:AddCommandPost(Objective4CP)
    
    Objective4.OnStart = function (self)
    
		SetProperty ("FountainVehicle1","ClassImpATK", "") 
		SetProperty ("FountainVehicle2","ClassImpATK", "") 
		SetProperty ("FountainVehicle3","ClassImpATK", "") 

		SetProperty ("FountainVehicle1","ClassAllDEF", "") 
		SetProperty ("FountainVehicle2","ClassAllDEF", "") 
		SetProperty ("FountainVehicle3","ClassAllDEF", "") 

    	KillObject ("FountainVehicle1")
    	KillObject ("FountainVehicle2")
    	KillObject ("FountainVehicle3")
    
    
    	SetProperty ("ViaDuctCamp", "AISpawnWeight", 100)
        SetProperty ("ViaDuctCamp", "Team", 1)
        ScriptCB_SndPlaySound("YAV_obj_19")
        SetProperty ("ViaCustCamp", "SpawnPath", "ViaductSpawnCamp")
		KillObject ("CP1Camp")
--		KillObject ("ViaDuctVehicle1")
--    	KillObject ("ViaDuctVehicle2")
--    	KillObject ("ViaDuctVehicle3")


        AICanCaptureCP("ReflectingPoolCamp", ATT, false)
    	AICanCaptureCP("ReflectingPoolCamp", DEF, true)
    	AICanCaptureCP("ReflectingPoolCamp", AMS, true)
    	

   		SetupAmbushTrigger("ReflectingPoolTrigger","ReflectingPoolPath", ambushCount8, ambushTeamAMS)

       	--RespawnObject ("TflankCamp")
       	RespawnObject ("ReflectingPoolCamp")
		RespawnObject ("ReflectingVehicles1")
		RespawnObject ("ReflectingVehicles2")
       	
        --SetProperty ("ReflectingPoolCamp","SpawnPath","TFlankCampSpawn")

    	ATTConquest = AddAIGoal (ATT,"Conquest",100)
    	DEFDefend = AddAIGoal (DEF,"Defend",100,"ReflectingPoolCamp")
    	
    	AMSDeathmatch = AddAIGoal (AMS,"Deathmatch",100)
    	
    	--KillObject ("BazaarCamp")
		
				-- EMPIRE CP ATTACK WEIGHTS        
		SetProperty ("BazaarCamp","Value_ATK_Empire",0)
		SetProperty ("cp1camp","Value_ATK_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_ATK_Empire",10)
		SetProperty ("tflankcamp","Value_ATK_Empire",0)
		SetProperty ("viaductcamp","Value_ATK_Empire",0)
		SetProperty ("TempleCamp","Value_ATK_Empire",0)
		SetProperty ("landingzonecamp","Value_ATK_Empire",0)
		-- EMPIRE CP DEFENSE WEIGHTS
		SetProperty ("BazaarCamp","Value_DEF_Empire",0)
		SetProperty ("cp1camp","Value_DEF_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_DEF_Empire",0)
		SetProperty ("tflankcamp","Value_DEF_Empire",0)
		SetProperty ("viaductcamp","Value_DEF_Empire",0)
		SetProperty ("TempleCamp","Value_DEF_Empire",0)
		SetProperty ("landingzonecamp","Value_DEF_Empire",0)
		-- REBEL CP ATTACK WEIGHTS		
        SetProperty ("BazaarCamp","Value_ATK_Alliance",0)
        SetProperty ("cp1camp","Value_ATK_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_ATK_Alliance",0)
        SetProperty ("tflankcamp","Value_ATK_Alliance",0)
        SetProperty ("viaductcamp","Value_ATK_Alliance",0)
        SetProperty ("TempleCamp","Value_ATK_Alliance",0)
        SetProperty ("landingzonecamp","Value_ATK_Alliance",0)
		-- REBEL CP DEFENSE WEIGHTS
        SetProperty ("BazaarCamp","Value_DEF_Alliance",0)
        SetProperty ("cp1camp","Value_DEF_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_DEF_Alliance",10)
        SetProperty ("tflankcamp","Value_DEF_Alliance",0)
        SetProperty ("viaductcamp","Value_DEF_Alliance",0)
        SetProperty ("TempleCamp","Value_DEF_Alliance",0)
        SetProperty ("landingzonecamp","Value_DEF_Alliance",0)

    end
    
	Objective4.OnComplete = function (self)
		SetProperty ("ReflectingPoolCamp", "Team", 1)
	    DeleteAIGoal(ATTConquest)
	    DeleteAIGoal(DEFDefend)
	    
		SetProperty ("ViaDuctVehicle1","ClassImpATK", "") 
		SetProperty ("ViaDuctVehicle2","ClassImpATK", "") 
		SetProperty ("ViaDuctVehicle3","ClassImpATK", "") 

		SetProperty ("ViaDuctVehicle1","ClassAllDEF", "") 
		SetProperty ("ViaDuctVehicle2","ClassAllDEF", "") 
		SetProperty ("ViaDuctVehicle3","ClassAllDEF", "") 

    	KillObject ("ViaDuctVehicle1")
    	KillObject ("ViaDuctVehicle2")
    	KillObject ("ViaDuctVehicle3")
    	
	    DeleteAIGoal(AMSDeathmatch)

		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 20)
	    ShowMessageText("game.objectives.complete", ATT)
	end

--  Objective 5, Defend ReflectingPoolCamp --------------------------------------------------------


        Objective5CP = CommandPost:New{name = "ReflectingPoolCamp", hideCPs = False}
        Objective5 = ObjectiveConquest:New{teamATT = DEF, teamDEF = ATT, textDEF = "level.yavin1.objectives.Campaign.5", popupText = "level.yavin1.objectives.Campaign.5_popup", timeLimit = 120, timeLimitWiningTeam = ATT}
        Objective5:AddCommandPost(Objective5CP)
    

    Objective5.OnStart = function (self)
    	--SetProperty ("CP3Camp","team",2)
        ScriptCB_SndPlaySound("YAV_obj_20")
		Ambush("ReflectingPoolPath", ambushCount8, AMS)
    	SetProperty ("ReflectingPoolCamp", "AISpawnWeight", 100)
     	objectiveSequence.delayNextSetTime = 0.5
        AICanCaptureCP("ReflectingPoolCamp", ATT, false)
    	AICanCaptureCP("ReflectingPoolCamp", DEF, true)
    	AICanCaptureCP("ReflectingPoolCamp", AMS, true)
    	
    	
    	ATTDefend = AddAIGoal (ATT,"Defend",100,"ReflectingPoolCamp")
    	DEFConquest = AddAIGoal (DEF,"Conquest",100 , "ReflectingPoolCamp")
    	
    	AMSDefend = AddAIGoal (AMS,"Conquest",100,"ReflectingPoolCamp")
    	
    	ReflectingPoolDefenseAmbushTimer = CreateTimer("ReflectingPoolDefenseAmbushTimer")
        SetTimerValue(ReflectingPoolDefenseAmbushTimer, 60)
		StartTimer(ReflectingPoolDefenseAmbushTimer)
		ReflectingPoolAmbush = OnTimerElapse(
			function (timer) 
		    	ReflectingPoolAmbush2 = Ambush("ReflectingPoolPath", ambushCount8, AMS)
			end,
			ReflectingPoolDefenseAmbushTimer
			)
    	
    					-- EMPIRE CP ATTACK WEIGHTS        
		SetProperty ("BazaarCamp","Value_ATK_Empire",0)
		SetProperty ("cp1camp","Value_ATK_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_ATK_Empire",0)
		SetProperty ("tflankcamp","Value_ATK_Empire",0)
		SetProperty ("viaductcamp","Value_ATK_Empire",0)
		SetProperty ("TempleCamp","Value_ATK_Empire",0)
		SetProperty ("landingzonecamp","Value_ATK_Empire",0)
		-- EMPIRE CP DEFENSE WEIGHTS
		SetProperty ("BazaarCamp","Value_DEF_Empire",0)
		SetProperty ("cp1camp","Value_DEF_Empire",0)
		SetProperty ("reflectingpoolcamp","Value_DEF_Empire",10)
		SetProperty ("tflankcamp","Value_DEF_Empire",0)
		SetProperty ("viaductcamp","Value_DEF_Empire",0)
		SetProperty ("TempleCamp","Value_DEF_Empire",0)
		SetProperty ("landingzonecamp","Value_DEF_Empire",0)
		-- REBEL CP ATTACK WEIGHTS		
        SetProperty ("BazaarCamp","Value_ATK_Alliance",0)
        SetProperty ("cp1camp","Value_ATK_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_ATK_Alliance",10)
        SetProperty ("tflankcamp","Value_ATK_Alliance",0)
        SetProperty ("viaductcamp","Value_ATK_Alliance",0)
        SetProperty ("TempleCamp","Value_ATK_Alliance",0)
        SetProperty ("landingzonecamp","Value_ATK_Alliance",0)
		-- REBEL CP DEFENSE WEIGHTS
        SetProperty ("BazaarCamp","Value_DEF_Alliance",0)
        SetProperty ("cp1camp","Value_DEF_Alliance",0)
        SetProperty ("ReflectingPoolCamp","Value_DEF_Alliance",0)
        SetProperty ("tflankcamp","Value_DEF_Alliance",0)
        SetProperty ("viaductcamp","Value_DEF_Alliance",0)
        SetProperty ("TempleCamp","Value_DEF_Alliance",0)
        SetProperty ("landingzonecamp","Value_DEF_Alliance",0)

    end
    
    
    Objective5.OnComplete = function (self)
    
    	SetProperty ("ReflectingPoolCamp", "Team", 1)
    	AICanCaptureCP("ReflectingPoolCamp", ATT, true)
    	AICanCaptureCP("ReflectingPoolCamp", DEF, false)
    	AICanCaptureCP("ReflectingPoolCamp", AMS, false)

    
    	DeleteAIGoal(ATTDefend)
	    DeleteAIGoal(DEFConquest)
	    
	    DeleteAIGoal(AMSDefend)

    	OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 20)
    	if self.winningTeam == self.teamATT then 
			BroadcastVoiceOver("yav_obj_08")
			SetProperty("ReflectingPoolCamp", "Team", 2)
			AICanCaptureCP("ReflectingPoolCamp", ATT, false)
		else 
			ShowMessageText("game.objectives.complete", ATT)
			SetProperty ("ReflectingPoolCamp", "Team", 1)
		end 
    end
   

-- Objective 6, Get the bomb, blow up the Temple door


	Objective6 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.yavin1.objectives.campaign.6", popupText = "level.yavin1.objectives.campaign.6_popup"}
    
	Objective6:AddFlag{name = "yav_flag_bomb", captureRegion = "temple_door_trigger",
			capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
			mapIcon = "flag_icon", mapIconScale = 2.0}
			
    StartTimer(bomb_timer)

                
    Objective6.OnStart = function (self)
        
        objectiveSequence.delayNextSetTime = 14.0
        
        
        ScriptCB_SndPlaySound("YAV_obj_21")
       	AICanCaptureCP("ReflectingPoolCamp", DEF, false)
    	SetProperty ("ReflectingPoolCamp", "AISpawnWeight", 100)
		ScriptCB_PlayInGameMusic("imp_yav_amb_bomb_retrieve")     
        
    	
        BombSpawn = GetPathPoint("BombSpawn", 0) --Put the rebel plans on this spawn path.
        CreateEntity("yav_flag_bomb", BombSpawn, "yav_flag_bomb") --Spawns the Holocron.
        SetProperty ("yav_flag_bomb", "AllowAIPickUp", 0)
        
        SetupAmbushTrigger("SunTempleTrigger","SunTempleTriggerPath", ambushCount8, ambushTeamAMS)

        ATTFlag = AddAIGoal (ATT, "CTFOffense",100,"yav_flag_bomb")
        DEFFlag = AddAIGoal (DEF, "Defend",100,"yav_flag_bomb")
        
        AMSDeathmatch = AddAIGoal (AMS, "Deathmatch",100)
    
    	bomb_capture_on = OnFlagPickUp(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("temple_door_trigger", "hud_objective_icon_circle_circle", 4.0, ATT, "YELLOW", true)
				ScriptCB_PlayInGameMusic("imp_yav_amb_bomb_return")
			end
		end,
		"yav_flag_bomb"
		)
    	
    	bomb_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapRemoveEntityMarker("temple_door_trigger")
			end
		end,
		"yav_flag_bomb"
		)
    end
    
    Objective6.OnComplete = function (self)
    	SetProperty("rebelleader_cp1", "Team", 2) --- turns on tank spawns in the temple
		SetProperty("rebelleader_cp2", "Team", 2)
		SetProperty("rebelleader_cp3", "Team", 2)

       	DeleteAIGoal(ATTFlag)
	    DeleteAIGoal(DEFFlag)
	    
	    DeleteAIGoal(AMSDeathmatch)

	    MapRemoveEntityMarker("temple_door_trigger")
	    ReleaseFlagPickUp (bomb_capture_on)
	    ReleaseFlagDrop (bomb_capture_off)
		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    	
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 20)
	    ShowMessageText("game.objectives.complete", ATT)
		if self.winningTeam == self.teamDEF then 
			BroadcastVoiceOver("yav_obj_08")
		end
		
		--create a timer for the bomb
		bomb_timer = CreateTimer("bomb_timer")
		SetTimerValue(bomb_timer, 10.0)
		StartTimer(bomb_timer)
		ShowTimer("bomb_timer")
	    OnTimerElapse(
	        function(timer)
	        	ShowTimer(nil)
	            SetProperty ("TempleBlastDoor", "CurHealth",0)
	            KillObject ("TempleBlastDoor")
	        end,
	        bomb_timer
	        )
    end
        
-- OBJECTIVE 7: Assault Objective. Destroy the Rebel leaders
    
    rebelleader_count = 3
    Objective7 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.yavin1.objectives.campaign.7", popupText = "level.yavin1.objectives.campaign.7_popup", AIGoalWeight = 0}
	
	Objective7.OnStart = function(self)
	    objectiveSequence.delayNextSetTime = 6.0
    	SetProperty ("ReflectingPoolCamp", "AISpawnWeight", 100)
		RespawnObject ("TempleCamp")
        ScriptCB_SndPlaySound("YAV_obj_22")
        ScriptCB_PlayInGameMusic("imp_yav_immVict_01")
        	
    	AICanCaptureCP("ReflectingPoolCamp", DEF, false)
    	AICanCaptureCP("ReflectingPoolCamp", ATT, true)
    	AICanCaptureCP("ViaDuctCamp", ATT, true)
    	AICanCaptureCP("BazaarCamp", ATT, true)
    	AICanCaptureCP("TempleCamp", ATT, false)
    	
        
        
		--ambush in the bosses and set their AIDamageThresholds
		Ambush("BossSpawn", ambushCount3, BOS)
		MapAddClassMarker("all_inf_officer_jungle", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
		for teamMember = 0, (ambushCount3 - 1) do
			local charIndex = GetTeamMember(BOS, teamMember)
			SetAIDamageThreshold(GetCharacterUnit(charIndex), 1.0)
		end
		
		--ambush in the rest of the goons
		Ambush("InsideTempleAmbushPath", ambushCount10, AMS)	
		
		--Setup AI goals
		RebelLeaderPart = AddAIGoal (DEF, "Deathmatch",100)
		ATTTempleAttack = AddAIGoal (ATT, "Deathmatch",100)		
		AMSTempleAttack = AddAIGoal (AMS, "Deathmatch",100)
		BOSAttack = AddAIGoal (BOS,"Defend",100, "TempleCamp")
    
		--make sure the tank spawns are active (makes debugging easier when we skip the previous objective)
		SetProperty("rebelleader_cp1", "Team", 2)
		SetProperty("rebelleader_cp2", "Team", 2)
		SetProperty("rebelleader_cp3", "Team", 2)
		
		--set up what happens when a boss is killed
		Objective7.bosscount = ambushCount3
		Objective7.bossKillEvent = OnObjectKill(
			function(object, killer)
				if GetObjectTeam(object) == BOS then
					if Objective7.bosscount > 0 then
						Objective7.bosscount = Objective7.bosscount - 1
					end
					
					if Objective7.bosscount == 2 then
						ShowMessageText("level.yavin1.objectives.campaign.bosscount.2", ATT)
					elseif Objective7.bosscount == 1 then
						ShowMessageText("level.yavin1.objectives.campaign.bosscount.1", ATT)
					elseif Objective7.bosscount == 0 then
						--complete the objective!
						Objective7:Complete(ATT)
            			ReleaseObjectKill(Objective7.bossKillEvent)
						MapRemoveClassMarker("all_inf_officer_jungle")
					end					
						
				end
			end
			)
	end
	
	Objective7.OnComplete = function(self)
		MapRemoveClassMarker("all_hover_combatspeeder")
		BroadcastVoiceOver("yav_obj_13", ATT)
		
		DeleteAIGoal (RebelLeaderPart)
		DeleteAIGoal (ATTTempleAttack)
		
		DeleteAIGoal (AMSTempleAttack)
		DeleteAIGoal (BOSAttack)
		ShowMessageText("game.objectives.complete", ATT)
	end

-------------------------------------------------------------------------------------------

end
	function StartObjectives() 
		objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0 }
	    objectiveSequence:AddObjectiveSet(Objective1)
	    objectiveSequence:AddObjectiveSet(Objective3)
	    objectiveSequence:AddObjectiveSet(Objective4)
	    objectiveSequence:AddObjectiveSet(Objective5)
	    objectiveSequence:AddObjectiveSet(Objective6)
	    objectiveSequence:AddObjectiveSet(Objective7)
	    objectiveSequence:Start()


end

function ScriptInit()
	StealArtistHeap(1664*1024)	-- steal 1664kb from art heap

    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(2428224)
    ReadDataFile("ingame.lvl")
    
    SetMaxFlyHeight(14)
    SetMaxPlayerFlyHeight (14)
    
   
    
    SetMaxFlyHeight(-17)
    
    ReadDataFile("sound\\yav.lvl;yav1gcw")
    
    ReadDataFile("SIDE\\all.lvl",
                             "all_inf_rifleman_jungle",
                             "all_inf_rocketeer_jungle",
                             "all_inf_sniper_jungle",
                             "all_inf_engineer_jungle",
                             "all_inf_officer_jungle",
                             "all_inf_wookiee",
                             "all_hover_combatspeeder",
                             "all_hover_bos_combatspeeder")
    ReadDataFile("SIDE\\imp.lvl",
                             "imp_hover_speederbike",
                             "imp_inf_rifleman",
                             "imp_inf_rocketeer",
                             "imp_inf_sniper",
                             "imp_inf_engineer",
                             "imp_inf_officer",
                             "imp_inf_dark_trooper",
                             "imp_hover_fightertank")
                             
                             
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser",
				"tur_bldg_tower")          
                             
                             
    -- set up teams
	SetupTeams{
	    imp = {
	        team = IMP,
	
	        units = 25,
	        reinforcements = 70,
	        soldier  = { "imp_inf_rifleman",11,16},
	        assault  = { "imp_inf_rocketeer",4,6},
	        engineer  = { "imp_inf_engineer",3,3},
	        sniper   = { "imp_inf_sniper",2,4},
	        officer = {"imp_inf_officer",2,4},
	        special = { "imp_inf_dark_trooper",3,4},
	    }
	}
	SetupTeams{
	    all = {
	        team = ALL,
	        units = 12,
	        reinforcements = -1,
	       	soldier  = { "all_inf_rifleman_jungle",7,9},
	        assault  = { "all_inf_rocketeer_jungle",2,3},
	        engineer    = { "all_inf_engineer_jungle",1,2},
	        sniper   = { "all_inf_sniper_jungle",1,2},
	        special = { "all_inf_wookiee",1,4},
	    }
	 }
	 SetupTeams{
	    ams = {
	        team = AMS,
	
	        units = 11,
	        reinforcements = 0,
	        assault  = { "all_inf_rocketeer_jungle",6,7},
	        sniper   = { "all_inf_rifleman_jungle",2,3},
	        special = { "all_inf_wookiee",2,3},
	    }
	 }
	 SetupTeams{
	    bos = {
	        team = BOS,
	
	        units = 3,
	        reinforcements = 0,
	        assault  = { "all_inf_officer_jungle",3,3},
	    }
	 }


     
    SetTeamAsEnemy(ATT,DEF)
    SetTeamAsEnemy(DEF,ATT)

    SetTeamAsEnemy(AMS,ATT)
    SetTeamAsEnemy(ATT,AMS)
    
    SetTeamAsEnemy(ATT,BOS)
    SetTeamAsEnemy(BOS,ATT)

    SetTeamAsFriend(DEF,AMS)
    SetTeamAsFriend(AMS,DEF) 
    
    SetTeamAsFriend(DEF,BOS)
    SetTeamAsFriend(BOS,DEF)
    
    SetTeamAsFriend(AMS,BOS)
    SetTeamAsFriend(BOS,AMS)


     
    
    SetSpawnDelayTeam(1.0, 0.5, ATT)
    SetSpawnDelayTeam(1.0, 0.5, DEF)
    SetSpawnDelayTeam(1.0, 0.5, AMS)
    SetSpawnDelayTeam(1.0, 0.5, BOS)


    --  Level Stats
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 330
    SetMemoryPoolSize("ActiveRegion", 12)
    SetMemoryPoolSize("Aimer", 120)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1000)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 1)
    SetMemoryPoolSize("EntityHover", 12)
    SetMemoryPoolSize("EntityLight", 48)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 20)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("MountedTurret", 25)
    SetMemoryPoolSize("Navigator", 41)
    SetMemoryPoolSize("Obstacle", 761)
    SetMemoryPoolSize("PathFollower", 38)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("SoundSpaceRegion", 25)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("TreeGridStack", 595)
    SetMemoryPoolSize("UnitAgent", 49)
    SetMemoryPoolSize("UnitController", 49)
    SetMemoryPoolSize("Weapon", weaponCnt) 
    
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("YAV\\yav1.lvl","yavin1_Campaign")
    SetDenseEnvironment("false")

    --  Birds
    
    SetNumBirdTypes(2)
    SetBirdType(0,1.0,"bird")
    SetBirdType(1,1.5,"bird2")

    --  Fish
    
    SetNumFishTypes(1)
    SetFishType(0,0.8,"fish")

    --  Sound

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")

    voiceSlow = OpenAudioStream("sound\\global.lvl", "yav_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow) 
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "imp_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "all_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl",  "global_vo_quick", voiceQuick)

    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(1, "impleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")

    --SetAmbientMusic(ALL, 1.0, "all_yav_amb_start",  0,1)
    --SetAmbientMusic(ALL, 0.5, "all_yav_amb_middle", 1,1)
    --SetAmbientMusic(ALL, 0.25,"all_yav_amb_end",    2,1)
    --SetAmbientMusic(IMP, 1.0, "imp_yav_amb_start",  0,1)
    --SetAmbientMusic(IMP, 0.5, "imp_yav_amb_middle", 1,1)
    --SetAmbientMusic(IMP, 0.25,"imp_yav_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_yav_amb_victory")
    SetDefeatMusic (ALL, "all_yav_amb_defeat")
    SetVictoryMusic(IMP, "imp_yav_amb_victory")
    SetDefeatMusic (IMP, "imp_yav_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    SetAttackingTeam(ATT)
    --Fountain
    AddCameraShot(0.925694, -0.056832, 0.373277, 0.022917, 132.356064, -65.527252, -25.416561)
    --Forrest Ruins
    AddCameraShot(0.361355, -0.024311, -0.930009, -0.062569, 93.845818, -52.247051, -194.743134)
    --Temple
    AddCameraShot(0.934074, 0.077334, -0.347417, 0.028764, 102.660049, -30.127220, -335.167145)

end

