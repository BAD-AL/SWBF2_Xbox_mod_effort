--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- This is the Campaign Script for JEDI TEMPLE: KNIGHTFALL, map name COR1C_C (Designer: P. Baker)

ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveCTF")     
ScriptCB_DoFile("ObjectiveTDM")  
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("setup_teams")  
ScriptCB_DoFile("Ambush")
 
ATT = 1
DEF = 2
GAR = DEF		--the dorky looking naboo guards
RUN = 5		--the flag runners
BOS = 6		--the boss team (several powerful jedi)

AMB = 3	--the "JED" team is actually the extra henchmen jedis that surround the boss jedis at the last objective
REP = ATT	--the player is on the republic team

ambushTeamAMB = AMB
ambushTeamJED = AMB
ambushTeam3 = GAR
ambushcount1 = 1
ambushCount3 = 3
ambushCount4 = 4   
ambushCount5 = 5    
ambushCount10 = 10
ambushCount15 = 15
ambushCountBOS = 3


     
function ScriptPostLoad ()
	ScriptCB_SetGameRules("campaign")
	SetAIDifficulty(2, -2, "medium")
    SetMapNorthAngle(180, 1)
	SetMissionEndMovie("ingame.mvs", "cormon02")
	DisableAIAutoBalance() 


	    AddDeathRegion("death")
	    AddDeathRegion("death1")
	    AddDeathRegion("death2")
	    AddDeathRegion("death3")
	    AddDeathRegion("death4")




	EnableSPScriptedHeroes()
	
	SetClassProperty ("rep_hero_cloakedanakin","MaxHealth",2200)
    
        
    SetProperty ("Library_CP","team",DEF)    
    SetProperty ("Consul_CP","team",DEF)
    SetProperty ("WarRoom_CP","team",DEF)
    SetProperty ("StarChamber_CP","team",DEF)
    SetProperty ("CommRoom_CP","team",DEF)
    SetProperty ("ExtraSpawn_CP","team",DEF)

    ScriptCB_PlayInGameMovie("ingame.mvs","cormon01")
    
    
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
	                	ScriptCB_SndPlaySound("cor_obj_26")
	               		ScriptCB_PlayInGameMusic("rep_cor_amb_obj1_2_explore")
	                	PlayAnimationFromTo("GunShipDropOff",0.0,20.5)
	                	
               		end,
               		objectives_timer
               		)
            end
        end
        )
    
    KillObject ("Library_CP")
    KillObject ("StarChamber_CP")
    KillObject ("WarRoom_CP")
    KillObject ("CommRoom_CP")
    KillObject ("ExtraSpawn_CP")
    
    SetProperty ("LibCase1","Team",0)
    SetProperty ("LibCase2","Team",0)
    SetProperty ("LibCase3","Team",0)
    SetProperty ("LibCase4","Team",0)
    
    BlockPlanningGraphArcs (1)
    BlockPlanningGraphArcs (2)
    BlockPlanningGraphArcs (3)
    BlockPlanningGraphArcs (4)
    BlockPlanningGraphArcs (5)
    BlockPlanningGraphArcs (6)


                        
    -- OBJECTIVE ONE Conquest Objective. Capture the Jedi Concil Chamber.-----------------------
       
    Objective1CP = CommandPost:New{name = "Consul_CP", hideCPs = false}
    Objective1 = ObjectiveConquest:New{teamATT = ATT, teamDEF = GAR, text = "level.cor1.objectives.Campaign.1",
        popupText = "level.cor1.objectives.Campaign.1_popup"}
    Objective1:AddCommandPost(Objective1CP)
    
    Objective1.OnStart = function (self)
    
       	SetupAmbushTrigger("Minor_Hall_Entrance_Trigger", "Minor_Hall_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Consul_Room_Trigger", "Consul_Room_Trigger_SpawnPath", ambushCount5, ambushTeamAMB) 
		AICanCaptureCP("Consul_CP", ATT, false)
        SetProperty ("Consul_CP","Value_ATK_Republic",10)
        SetProperty ("Library_CP","Value_DEF_CIS",10)
        ConcilAmbushAMB = AddAIGoal (AMB, "Deathmatch",1)
        ATTgoal = AddAIGoal (ATT, "Defend", 100, "Consul_CP")
        
    end
    
    Objective1.OnComplete = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        SetProperty("Library_CP", "CaptureRegion","fake_cp")
        SetProperty("Library_CP", "value_ATK_CIS","0") 
        SetProperty("Library_CP", "value_DEF_Republic","0")
        SetProperty ("Library_CP","team",DEF)
        DeleteAIGoal(ConcilAmbushAMB)
        DeleteAIGoal(ATTgoal)
		OBJ1_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ1_ReinforcementCount + 30)
	    ShowMessageText("game.objectives.complete", ATT)
        
    end 

    -- Objective 2 A Goto Obj. Go to the Library.-------------------------------------------------
    
    Objective2a = ObjectiveGoto:New{teamATT = ATT, teamDEF = DEF, text = "level.cor1.objectives.campaign.2.a",
    popupText = "level.cor1.objectives.campaign.2.a_popup", regionName = "GotoEnd", mapIcon = "imp_icon"}

    Objective2a.OnStart = function (self)
    	ATTGotoLibrary = AddAIGoal (ATT,"Defend", 100, "Library_CP")
    	GARGotoLibrary = AddAIGoal (GAR,"Defend" ,100,"Library_CP")
    	SetProperty ("Consul_CP", "Team", 1)
    	SetProperty ("Consul_CP","SpawnPath", "CP3CampSpawnPath")
    	SetProperty ("Consul_CP", "CaptureRegion","fake_cp")
    	AICanCaptureCP("Consul_CP", DEF, false)

    	MapAddEntityMarker("Library_CP", "hud_objective_icon", 3.0, ATT, "YELLOW", true, true, true) 
    	RespawnObject ("Library_CP")
    	PlayAnimation("DoorOpen01")
        DisableBarriers("SideDoor1")
        DisableBarriers("MainLibraryDoors")
        UnblockPlanningGraphArcs (1)

    	RespawnObject ("ExtraSpawn_CP")
    	SetAIDamageThreshold("LibCase1", 1)
    	SetAIDamageThreshold("LibCase2", 1)
    	SetAIDamageThreshold("LibCase3", 1)
    	SetAIDamageThreshold("LibCase4", 1)
    	
    	SetProperty ("LibCase1","CurHealth",999999)
    	SetProperty ("LibCase2","CurHealth",999999)
    	SetProperty ("LibCase3","CurHealth",999999)
    	SetProperty ("LibCase4","CurHealth",999999)

    	SetProperty ("LibCase1","Team",1)
    	SetProperty ("LibCase2","Team",1)
    	SetProperty ("LibCase3","Team",1)
    	SetProperty ("LibCase4","Team",1)
        
        --KillObject ("Veranda_CP")
        ScriptCB_SndPlaySound("cor_obj_29")       
        
    end
    
    Objective2a.OnComplete = function (self)
    
    	
        MapRemoveEntityMarker("Library_CP")
        DeleteAIGoal(ATTGotoLibrary)
        DeleteAIGoal(GARGotoLibrary)
        OBJ2a_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ2a_ReinforcementCount + 30)
	    ShowMessageText("game.objectives.complete", ATT)

    end
    
    -- OBJECTIVE 2 C Defend the Library for 2 minutes while we search for the Holocron information----------------------------------------    

	Bookcases = TargetType:New{classname = "cor1_prop_librarystack", killLimit = 4, icon = nil}
   	Objective2c = ObjectiveAssault:New{teamATT = AMB , teamDEF = ATT, textDEF = "level.cor1.objectives.Campaign.2.c",
   										popupText = "level.cor1.objectives.campaign.2.c_popup", timeLimit = 120, timeLimitWinningTeam = ATT, AIGoalWeight = 0.0} -- should really rename the loc file
    Objective2c:AddTarget(Bookcases) 
    book_count = 4 
        
    Bookcases.OnDestroy = function(self, objectPtr)
        book_count = book_count - 1
        if book_count == 3 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.3", ATT)
    	elseif
    		book_count == 2 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.2", ATT)
    	elseif
    		book_count == 1 then
        	ShowMessageText ("level.cor1.objectives.Campaign.bookcount.1", ATT)
    	elseif
        	book_count == 0 then 
        	MissionVictory (DEF)
        end
    end

    Objective2c.OnStart = function (self)
    	objectiveSequence.delayNextSetTime = 0.5
    	
    	
    	SetProperty ("LibCase1","CurHealth",11000)
    	SetProperty ("LibCase2","CurHealth",11000)
    	SetProperty ("LibCase3","CurHealth",11000)
    	SetProperty ("LibCase4","CurHealth",11000)

    	--ScriptCB_PlayInGameMovie("ingame.mvs", "cor1cam1") 
        MapRemoveEntityMarker("Library_CP")
        ScriptCB_SndPlaySound("cor_obj_30")
        ScriptCB_PlayInGameMusic("rep_cor_amb_defend_library_01")
    	RespawnObject ("ExtraSpawn_CP")
    	SetProperty ("ExtraSpawn_CP", "Team", GAR)
    	Ambush("JediLibraryDefenders", ambushCount10, AMB)

        LibraryAmbushTimer = CreateTimer("LibraryAmbushTimer")
        SetTimerValue(LibraryAmbushTimer, 60)
		StartTimer(LibraryAmbushTimer)
		LibraryAmbush = OnTimerElapse(
			function (timer) 
		    	LibraryAmbush2 = Ambush("SecondJediLibraryAmbush", ambushCount10, AMB)
		    	DestroyTimer(Timer)
			end,
			LibraryAmbushTimer
			)

    	--KillObject ("Consul_CP")
    	
    	
    	SetAIDamageThreshold("LibCase1",0)
    	SetAIDamageThreshold("LibCase2",0)
    	SetAIDamageThreshold("LibCase3",0)
    	SetAIDamageThreshold("LibCase4",0)

    	
    	SetProperty ("LibCase1","Team",1)
    	SetProperty ("LibCase2","Team",1)
    	SetProperty ("LibCase3","Team",1)
    	SetProperty ("LibCase4","Team",1)

    	MapAddEntityMarker("LibCase1", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase2", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase3", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	MapAddEntityMarker("LibCase4", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true, true, true) 
    	
    	
   		SetProperty("Library_CP","value_ATK_CIS",10) 
   		SetProperty("Library_CP","value_DEF_Republic",10)
    	SetProperty ("Library_CP","Team", ATT)
		
		AMBDeathmatch = AddAIGoal (AMB, "Deathmatch", 50)
		GARDeathmatch = AddAIGoal (GAR, "Deathmatch", 50)
		ATTLibraryDefend = AddAIGoal (ATT, "Defend",50, "Library_CP")
		ATTDeathmatch = AddAIGoal (ATT, "Deathmatch", 50)
		
		AMBLibraryDestroy1 = AddAIGoal (AMB, "Destroy", 50, "LibCase1")
		AMBLibraryDestroy2 = AddAIGoal (AMB, "Destroy", 50, "LibCase2")
        AMBLibraryDestroy3 = AddAIGoal (AMB, "Destroy", 50, "LibCase3")
        AMBLibraryDestroy4 = AddAIGoal (AMB, "Destroy", 50, "LibCase4")
        
        GARLibraryDestroy1 = AddAIGoal (GAR, "Destroy", 50, "LibCase1")
		GARLibraryDestroy2 = AddAIGoal (GAR, "Destroy", 50, "LibCase2")
        GARLibraryDestroy3 = AddAIGoal (GAR, "Destroy", 50, "LibCase3")
        GARLibraryDestroy4 = AddAIGoal (GAR, "Destroy", 50, "LibCase4")
    end    
    
    Objective2c.OnComplete = function (self)
    	if self.winningTeam == self.teamATT then
            BroadcastVoiceOver("cor_obj_24")
		end
	    
    	DeleteAIGoal(AMBLibraryDestroy1)
    	DeleteAIGoal(AMBLibraryDestroy2)
    	DeleteAIGoal(AMBLibraryDestroy3)
    	DeleteAIGoal(AMBLibraryDestroy4)
    	
		DeleteAIGoal(GARLibraryDestroy1)
    	DeleteAIGoal(GARLibraryDestroy2)
    	DeleteAIGoal(GARLibraryDestroy3)
    	DeleteAIGoal(GARLibraryDestroy4)
    	
    	DeleteAIGoal(AMBDeathmatch)
    	DeleteAIGoal(GARDeathmatch)
		DeleteAIGoal(ATTLibraryDefend)
    	DeleteAIGoal(ATTDeathmatch)
    	
		OBJ2c_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ2c_ReinforcementCount + 30)
	    
	    MapRemoveEntityMarker("LibCase1")
        MapRemoveEntityMarker("LibCase2")
        MapRemoveEntityMarker("LibCase3")
        MapRemoveEntityMarker("LibCase4")


    end

    -- Objective 4  - Retrieve Holocron from Comm. Room and return to Gunship

    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = GAR, captureLimit = 1, text = "level.cor1.objectives.campaign.4",
                                    popupText = "level.cor1.objectives.campaign.4_popup"}
    
    Objective4:AddFlag{name = "holocron1", captureRegion = "Veranda_Flag_Cap"}
                    
    Objective4.OnStart = function (self)
    
        Holocron1Spawn = GetPathPoint("holocronspawn_a", 0) 
        CreateEntity("cor1_item_holocron", Holocron1Spawn, "holocron1")
        SetProperty ("holocron1", "AllowAIPickUp", 0)
    
		holocron_capture_on = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					--ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
					MapAddEntityMarker("Veranda_CP", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
					ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")
				end
			end,
			"holocron"
		)
		
		holocron_capture_off = OnFlagDrop(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					MapRemoveEntityMarker("Veranda_CP")
					--ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)				
				end
			end,
			"holocron"
		)

     	objectiveSequence.delayNextSetTime = 0.5
		ScriptCB_SndPlaySound("cor_obj_33")
		ScriptCB_PlayInGameMusic("rep_cor_objComplete_01")
		
-- Music Timer -- 
 	music01Timer = CreateTimer("music01")
	SetTimerValue(music01Timer, 13.0)
		              
	StartTimer(music01Timer)
	OnTimerElapse(
		function(timer)
		ScriptCB_StopInGameMusic("rep_cor_objComplete_01")
		ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_retrieve_01")
		DestroyTimer(Timer)
	end,
	music01Timer
        )  	
 
		-- Open main star room and war room
		RespawnObject ("Veranda_CP")
		SetupAmbushTrigger("Library_SideDoor_Trigger","Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) --Library Side Door 1
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount4, AMB) -- Comm. Room
		SetupAmbushTrigger("GrandHall_Trigger_a", "GrandHall_Trigger_a_Path", ambushCount3, AMB)	
    	SetupAmbushTrigger("GrandHall_Trigger_b", "GrandHall_Trigger_b_Path", ambushCount3, AMB) 
		SetupAmbushTrigger("Mainframe_Jedi_ambush_trigger", "JediMainframeDefenders", ambushCount10, AMB)	

		--KillObject ("Library_CP")
		
        PlayAnimation ("DoorOpen02")        
        DisableBarriers("ComputerRoomDoor1")        
        UnblockPlanningGraphArcs (2)
        
        PlayAnimation("DoorOpen01")
        PlayAnimationFromTo("GunShipDropOff",20.5,30.0)
        
        
        AMBDeathmatch = AddAIGoal (AMB, "Deathmatch",100)
        GARDeathmatch = AddAIGoal (GAR, "Deathmatch",100)

    end
    
    Objective4.OnComplete = function (self)
		ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")

    	MapRemoveEntityMarker("Veranda_CP")
    
    	ReleaseFlagPickUp(holocron_capture_on)
		ReleaseFlagDrop(holocron_capture_off)

    	OBJ4_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ4_ReinforcementCount + 30)
	    
	    DeleteAIGoal(AMBDeathmatch)
	    DeleteAIGoal(GARDeathmatch)
	    
	    UnlockHeroForTeam(ATT)
	    ShowMessageText("game.objectives.complete", ATT)


	end

   
    -- OBJECTIVE 5 Catch the Jedi with the Flag----------------------------------------------------------------------
            
    Objective5 = ObjectiveCTF:New{teamATT = ATT, teamDEF = GAR, captureLimit = 1, text = "level.cor1.objectives.campaign.5",
        popupText = "level.cor1.objectives.campaign.5_popup", AIGoalWait = 0}

    Objective5:AddFlag{name = "holocron2",  captureRegion = "Veranda_Flag_Cap"}
                        
    Objective5.OnDrop = function(self, flag)
        SetProperty(flag.name, "AllowAIPickUp", 0)
    end
        
--    FlagJedi = GetTeamMember(RUN, 0)
--	FlagJediName = GetEntityName(FlagJedi)
--	
--	JediNextGoal = OnEnterRegion(
--		function(region, character)
--			DeleteAIGoal (RunnerGoal1) 
--	        RunnerGoal2 = AddAIGoal(RUN, "Defend",100,"Runner_Goto_2")
--		end,
--		"CP3CaptureCamp",
--		FlagJediName
--		)
                
    Objective5.OnStart = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        holocron_capture_on = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					--ShowMessageText("level.dea1.objectives.campaign.4_pickup", ATT)
					MapAddEntityMarker("Veranda_CP", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
					ScriptCB_PlayInGameMusic("rep_cor_amb_holocron_return_01")
				else
					MapAddEntityMarker(GetCharacterUnit(carrier), "hud_target_flag_onscreen", 4.0, ATT, "YELLOW", true)
				end
			end,
			"holocron"
			)
		
		holocron_capture_off = OnFlagDrop(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					MapRemoveEntityMarker("Veranda_CP")
					--ShowMessageText("level.dea1.objectives.campaign.4_drop", ATT)				
				else
					MapRemoveEntityMarker(GetCharacterUnit(carrier))
				end
			end,
			"holocron"
			)
		
        ---ScriptCB_PlayInGameMovie("ingame.mvs", "cor1cam2") 
		RespawnObject ("WarRoom_CP")
        ScriptCB_SndPlaySound("cor_obj_35")
        ScriptCB_PlayInGameMusic("rep_cor_act_01")

        Ambush("flagrunner", 1, RUN)        
        
        DisableBarriers("StarChamberDoor1")
        DisableBarriers("StarChamberDoor2")
        DisableBarriers("WarRoomDoor1")
        DisableBarriers("WarRoomDoor2")
        DisableBarriers("WarRoomDoor3")
        
		UnblockPlanningGraphArcs (3)
		UnblockPlanningGraphArcs (4)
		
		PlayAnimation ("DoorOpen03") 
        PlayAnimation ("DoorOpen04") 

        SetProperty ("Consul_CP" ,"CaptureRegion", "fake_cp")
        KillObject ("tur_weap_built_gunturret")
        KillObject ("tur_weap_built_gunturret")
        KillObject ("tur_weap_built_gunturret")

        GARDeathmatchCatchJEdi = AddAIGoal (GAR, "Deathmatch", 100)
        AMBDeathmatch = AddAIGoal (AMB, "Deathmatch",100) 
	    REPCatchtheJedi = AddAIGoal (ATT,"Deathmatch",100)
	    REPCatchtheJediDeathmatch = AddAIGoal (ATT,"Deathmatch",1)
        RunnerGoal1 = AddAIGoal (RUN, "Defend",100,"WarRoom_CP") 

        
   		SetupAmbushTrigger("Library_SideDoor_Trigger","Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
		SetupAmbushTrigger("GrandHall_Trigger_a", "GrandHall_Trigger_a_Path", ambushCount3, ambushTeamAMB)	
    	SetupAmbushTrigger("GrandHall_Trigger_b", "GrandHall_Trigger_b_Path", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Balconey_Ambush", "Balconey_Ambush_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Star_Chamber_trigger", "Star_Chamber_trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("War_Room_trigger", "War_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Minor_Hall_Corner_Trigger", "Minor_Hall_Corner_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Coom_Room_Trigger", "Comm_Room_Trigger_SpawnPath", ambushCount3, ambushTeamAMB) 
        SetupAmbushTrigger("Library_SideDoor_Trigger", "Library_SideDoor_Trigger_SpawnPath", ambushCount3, ambushTeamAMB)
        SetupAmbushTrigger("Consul_Room_Trigger", "Consul_Room_Trigger_SpawnPath", ambushCount5, ambushTeamAMB) 
 
--        SetProperty ("Consul_CP","Team",AMB)
--        RespawnObject ("Consul_CP")
        --ScriptCB_SndPlaySound("cor_obj_16")

    end
            
    Objective5.OnComplete = function (self)
  		PlayAnimationFromTo("GunShipDropOff",30.0,35.0)
    	ReleaseFlagPickUp(holocron_capture_on)
		ReleaseFlagDrop(holocron_capture_off)
		MapRemoveEntityMarker("Veranda_CP")
		
        --KillObject ("Consul_CP")
        DeleteAIGoal(GARDeathmatchCatchJEdi)
        DeleteAIGoal(AMBDeathmatch)
        DeleteAIGoal(REPCatchtheJedi)
        DeleteAIGoal(REPCatchtheJediDeathmatch)
        DeleteAIGoal(RunnerGoal1)
        --DeleteAIGoal(RunnerGoal2)

        DeactivateRegion ("Star_Chamber_trigger")
        DeactivateRegion ("War_Room_trigger")
        DeactivateRegion ("Minor_Hall_Corner_Trigger")
        DeactivateRegion ("Coom_Room_Trigger")
        DeactivateRegion ("Library_SideDoor_Trigger")
        DeactivateRegion ("Balconey_Ambush")
        DeactivateRegion ("GrandHall_Trigger_a")
        DeactivateRegion ("GrandHall_Trigger_b")

        OBJ5_ReinforcementCount = GetReinforcementCount(ATT)
	    SetReinforcementCount(ATT, OBJ5_ReinforcementCount + 50)
	    ShowMessageText("game.objectives.complete", ATT)
	     

    end  
                      
    --OBJECTIVE 6 TDM - Kill all the Jedi.

    Objective6 = Objective:New{teamATT = ATT, teamDEF = DEF, text ="level.cor1.objectives.campaign.6",
        popupText = "level.cor1.objectives.campaign.6_popup"}
       
    Objective6.OnStart = function (self)
        objectiveSequence.delayNextSetTime = 0.5
        
        SetProperty ("ExtraSpawn_CP", "Team", 3)
		
        ATTKillAllJedi = AddAIGoal (ATT, "deathmatch",100)
        GARKillAllJedi = AddAIGoal (GAR, "deathmatch",100)
        AMBiFinalStand = AddAIGoal (AMB, "Deathmatch", 100)
        BossGoal = AddAIGoal(BOS, "Deathmatch", 100)
        
        ScriptCB_SndPlaySound("cor_obj_38")
        ScriptCB_PlayInGameMusic("rep_cor_objComplete_02")
        
			
	-- Music Timer -- 
	 	music03Timer = CreateTimer("music03")
		SetTimerValue(music03Timer, 26.0)
			              
		StartTimer(music03Timer)
		OnTimerElapse(
			function(timer)
			ScriptCB_StopInGameMusic("rep_cor_objComplete_02")
			ScriptCB_PlayInGameMusic("rep_cor_act_01")
			DestroyTimer(timer)
		end,
		music03Timer
        ) 
        
        --SetReinforcementCount (ATT,100)
        
--        SetProperty ("Consul_CP","Team",AMB)
--        SetProperty ("Consul_CP","SpawnPath","HenchMen")
--        RespawnObject ("Consul_CP")
        SetReinforcementCount(AMB, -1)
        
        Ambush("SuperJedi", ambushCountBOS, BOS, 0.3)
       
        MapAddClassMarker("jed_master_01", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
        MapAddClassMarker("jed_master_02", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
        MapAddClassMarker("jed_master_03", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
       
        boss_count = ambushCountBOS
        Objective6KillBosses = OnObjectKillTeam( 
            function(object, killer) 
                if boss_count > 0 then
                    boss_count = boss_count - 1
                end 
                if boss_count == 2 then
               		ShowMessageText ("level.cor1.objectives.Campaign.mastercount.2", ATT)
                elseif boss_count == 1 then
                  	ShowMessageText ("level.cor1.objectives.Campaign.mastercount.1", ATT)
                elseif boss_count == 0 then
                    ScriptCB_SndPlaySound("cor_obj_21") 
                    Objective6:Complete(ATT) 
                    ReleaseObjectKill(Objective6KillBosses)
                end 
            end,
            BOS
        )       
    end
    
    Objective6.OnComplete = function(self)
        DeleteAIGoal(ATTKillAllJedi)
        DeleteAIGoal(GARKillAllJedi)
        DeleteAIGoal(AMBiFinalStand)
        DeleteAIGoal(BossGoal)
        if self.winningTeam == self.teamDEF then
            BroadcastVoiceOver("cor_obj_24")
        elseif self.winningTeam == self.teamATT then
        	ShowMessageText("game.objectives.complete", ATT)
            BroadcastVoiceOver("cor_obj_05")
        end
     end    


	----------------------------------------------------------------------------------------------------------------

    
         
end


----This creates the objective "container" and specifies order of objectives, and gets that shit running          
function StartObjectives() 
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 6.0 }
	objectiveSequence:AddObjectiveSet(Objective1)
	objectiveSequence:AddObjectiveSet(Objective2a)
	objectiveSequence:AddObjectiveSet(Objective2c)
	objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5)
    objectiveSequence:AddObjectiveSet(Objective6)
    objectiveSequence:Start()
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
    StealArtistHeap(400*1024)
    SetPS2ModelMemory(3800000)

    AISnipeSuitabilityDist(30)
    
     SetMaxFlyHeight(25)
     SetMaxPlayerFlyHeight (25)
     
     
    
    --  Memory Pool Settings

    ClearWalkers()
    AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(1, 0) -- 
    AddWalkerType(2, 0) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 0) -- 2 attes with 3 leg pairs each
    local weaponCnt = 234
    SetMemoryPoolSize("Aimer", 20)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize ("Combo",64)                  -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",256)          -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",256)     -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",256)      -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",150)         -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",4086)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",64)         -- should be ~1x #combo
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 22)
    SetMemoryPoolSize("EntityHover", 0)
    SetMemoryPoolSize("EntityLight", 120)
    SetMemoryPoolSize("EntitySoundStream", 10)
    SetMemoryPoolSize("EntitySoundStatic", 0)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 15)
    SetMemoryPoolSize("Music", 33)
    SetMemoryPoolSize("Navigator", 55)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathFollower", 53)
    SetMemoryPoolSize("PathNode", 256)
    SetMemoryPoolSize("ShieldEffect", 0)
    SetMemoryPoolSize("SoundSpaceRegion", 38)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 200)
    SetMemoryPoolSize("Weapon", weaponCnt)
--   	SetMemoryPoolSize("EntityFlyer", 6)   



    ReadDataFile("ingame.lvl")
    
    ReadDataFile("sound\\cor.lvl;cor1cw")

    ReadDataFile("SIDE\\rep.lvl",
        "rep_inf_ep3_rifleman",
        "rep_inf_ep3_rocketeer",
        "rep_inf_ep3_engineer",
        "rep_inf_ep3_sniper",
   		"rep_fly_assault_DOME",
		"rep_fly_gunship_DOME",
        "rep_inf_ep3_officer",
        "rep_inf_ep3_jettrooper",
        "rep_hero_cloakedanakin")
                
    ReadDataFile("SIDE\\jed.lvl",
        "jed_knight_01",
        "jed_knight_02",
        "jed_knight_03",
        "jed_knight_04",
        "jed_master_01",
        "jed_master_02",
        "jed_master_03",
        "jed_runner")
 
    ReadDataFile("SIDE\\gar.lvl",
        "gar_inf_temple_soldier",
        "gar_inf_temple_vanguard")
    
    ReadDataFile("SIDE\\tur.lvl",
        "tur_weap_built_gunturret")
        
    ReadDataFile("SIDE\\cis.lvl",
        "cis_fly_droidfighter_DOME")
        
        
    ReadDataFile("SIDE\\tur.lvl", 
    			"tur_bldg_laser")          
        

    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)       
        
                 
    -- Set up teams.
    SetupTeams{             
        rep = {
            team = REP,
            units = 32,
            reinforcements = 50,
            soldier  = { "rep_inf_ep3_rifleman",13, 16},
            assault  = { "rep_inf_ep3_rocketeer",5, 4},
            engineer = { "rep_inf_ep3_engineer",3, 4},
            sniper   = { "rep_inf_ep3_sniper",2, 4},
            officer = {"rep_inf_ep3_officer",2, 4},
            special = {"rep_inf_ep3_jettrooper",2, 4},

            hero = {"rep_hero_cloakedanakin"},
        }
    }
    
    SetupTeams{ 
        all = {
            team = GAR,
            units = 8,
            reinforcements = -1,
            soldier  = { "gar_inf_temple_soldier",3, 4},
            assault =   { "gar_inf_temple_vanguard",3, 4},
            
        }
    }
     
    SetupTeams{ 
        jedi = {
            team = AMB,
            units = 17,
            reinforcements = 0,
            soldier  = { "jed_knight_01",4, 6},
            assault  = { "jed_knight_02",4, 6},
            engineer  = { "jed_knight_03",3, 6},
            sniper = { "jed_knight_04",2, 6},
        }
    }
    
    SetupTeams{ 
        bos = {
            team = RUN,
            units = 1,
            reinforcements = 0,
            soldier  = { "jed_master_03",1, 1},
        }
    }
    
    SetupTeams{
    	bos = {
    		team = BOS,
    		units = ambushCountBOS,
    		reinforcements = 3,
    		soldier = { "jed_master_01", 1, 1 },
    		assault = { "jed_master_02", 1, 1 },
    		engineer = { "jed_master_03", 1, 1 },
    	}
    }

    --Pools of extra characters for Ambushes.
 
    
    SetTeamAsEnemy(AMB, ATT)
    SetTeamAsEnemy(ATT, AMB)
    
    SetTeamAsEnemy(ATT, GAR)
    SetTeamAsEnemy(GAR, ATT)
    
    SetTeamAsEnemy(DEF, ATT)
    SetTeamAsEnemy(ATT, DEF)
    
    SetTeamAsEnemy(RUN, ATT)
    SetTeamAsEnemy(ATT, RUN)
    
    SetTeamAsEnemy(BOS, ATT)
    SetTeamAsEnemy(ATT, BOS)
       
    
    SetTeamAsFriend(AMB, DEF)
    SetTeamAsFriend(DEF, AMB)
    
    SetTeamAsFriend(AMB, GAR)
    SetTeamAsFriend(GAR, AMB)
    
    SetTeamAsFriend(GAR, DEF)
    SetTeamAsFriend(DEF, GAR)
    
    SetTeamAsFriend(RUN, DEF)
    SetTeamAsFriend(DEF, RUN)
    
    SetTeamAsFriend(RUN, GAR)
    SetTeamAsFriend(GAR, RUN)
    
    SetTeamAsFriend(RUN, AMB)
    SetTeamAsFriend(AMB, RUN)
    
    SetTeamAsFriend(RUN, DEF)
    SetTeamAsFriend(DEF, RUN)
    
    SetTeamAsFriend(BOS, DEF)
    SetTeamAsFriend(DEF, BOS)
    
    SetTeamAsFriend(BOS, AMB)
    SetTeamAsFriend(AMB, BOS)
    
    SetTeamAsFriend(BOS, GAR)
    SetTeamAsFriend(GAR, BOS)
    
    
    SetHeroClass(REP,"rep_hero_cloakedanakin")
          
    -- This sets the overall unit spawn delay for this level.    
    SetSpawnDelayTeam(2.0, 0.5, ATT)
    SetSpawnDelayTeam(10.0, 0.5, DEF)
    SetSpawnDelayTeam(10.0, 0.5, AMB)
    SetSpawnDelayTeam(10.0, 0.5, GAR)




    SetSpawnDelay(1.0, 0.25)

    -- This sets what level to load, and what game mode layer.
        
    ReadDataFile("cor\\cor1.lvl","cor1_campaign")
    -- Misc.

    SetDenseEnvironment("True")
    SetMapNorthAngle(0)
    SetMaxFlyHeight(25)
    SetMaxPlayerFlyHeight (25)
    
    


    --  Music and Audio Calls

    voiceSlow = OpenAudioStream("sound\\global.lvl", "cor_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "all_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 

    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    -- OpenAudioStream("sound\\cor.lvl",  "cor_objective_vo_slow")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    OpenAudioStream("sound\\cor.lvl",  "cor1")
    -- OpenAudioStream("sound\\cor.lvl",  "cor1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, JED, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(JED, REP, "JED_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(JED, JED, "JED_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "allleaving")

    -- SetAmbientMusic(REP, 1.0, "rep_cor_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_cor_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_cor_amb_end",    2,1)
    -- SetAmbientMusic(JED, 1.0, "JED_cor_amb_start",  0,1)
    -- SetAmbientMusic(JED, 0.99, "JED_cor_amb_middle", 1,1)
    -- SetAmbientMusic(JED, 0.1,"JED_cor_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_cor_amb_victory")
    SetDefeatMusic (REP, "rep_cor_amb_defeat")
    --SetVictoryMusic(JED, "JED_cor_amb_victory")
    --SetDefeatMusic (JED, "JED_cor_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


    --  Camera Stats
	AddCameraShot(0.419938, 0.002235, -0.907537, 0.004830, -15.639358, 5.499980, -176.911179);
	AddCameraShot(0.994506, 0.104463, -0.006739, 0.000708, 1.745251, 5.499980, -118.700668);
	AddCameraShot(0.008929, -0.001103, -0.992423, -0.122538, 1.366768, 16.818106, -114.422173);
	AddCameraShot(0.761751, -0.117873, -0.629565, -0.097419, 59.861904, 16.818106, -81.607773);
	AddCameraShot(0.717110, -0.013583, 0.696703, 0.013197, 98.053314, 11.354497, -85.857857);
	AddCameraShot(0.360958, -0.001053, -0.932577, -0.002721, 69.017578, 18.145807, -56.992413);
	AddCameraShot(-0.385976, 0.014031, -0.921793, -0.033508, 93.111061, 18.145807, -20.164375);
	AddCameraShot(0.695468, -0.129569, -0.694823, -0.129448, 27.284357, 18.145807, -12.377695);
	AddCameraShot(0.009002, -0.000795, -0.996084, -0.087945, 1.931320, 13.356332, -16.410583);
	AddCameraShot(0.947720, -0.145318, 0.280814, 0.043058, 11.650738, 16.955814, 28.359180);
	AddCameraShot(0.686380, -0.127550, 0.703919, 0.130810, -30.096384, 11.152356, -63.235146);
	AddCameraShot(0.937945, -0.108408, 0.327224, 0.037821, -43.701199, 8.756138, -49.974789);
	AddCameraShot(0.531236, -0.079466, -0.834207, -0.124787, -62.491230, 10.305247, -120.102989);
	AddCameraShot(0.452286, -0.179031, -0.812390, -0.321572, -50.015198, 15.394646, -114.879379);
	AddCameraShot(0.927563, -0.243751, 0.273918, 0.071982, 26.149965, 26.947924, -46.834148);
end




