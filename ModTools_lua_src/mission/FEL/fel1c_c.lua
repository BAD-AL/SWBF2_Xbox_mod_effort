    --
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("Ambush")

--  These variables do not change
 ATT = 1;
 DEF = 2;
--  Republic Attacking (attacker is always #1)
 REP = ATT;
 CIS = DEF;




function ScriptPostLoad()   
	
	SetAIDifficulty(1, -5, "medium")
	SetMissionEndMovie("ingame.mvs", "felmon02")
	AICanCaptureCP("CP1", 5, false)
	AICanCaptureCP("CP1", DEF, false)
	ScriptCB_SetGameRules("campaign")
	--SetProperty("ATTE", "Team", 0)
	--Set Turrets to team 0 until turret objective
	SetProperty("turret1", "Team", 0)
	SetProperty("turret2", "Team", 0)
	SetProperty("turret3", "Team", 0)
	SetProperty("turret4", "Team", 0)
	SetProperty("turret5", "Team", 0)
	SetProperty("turret1", "CurHealth", 1e+37)
	SetProperty("turret2", "CurHealth", 1e+37)
	SetProperty("turret3", "CurHealth", 1e+37)
	SetProperty("turret4", "CurHealth", 1e+37)
	SetProperty("turret5", "CurHealth", 1e+37)
	SetAIDamageThreshold("turret1", 0.5)
	SetAIDamageThreshold("turret2", 0.5)
	SetAIDamageThreshold("turret3", 0.5)
	SetAIDamageThreshold("turret4", 0.5)
	SetAIDamageThreshold("turret5", 0.5)
	ScriptCB_PlayInGameMovie("ingame.mvs", "felmon01")
	ScriptCB_SetSpawnDisplayGain(0.2, 0.5)
	KillObject("CP2")
	KillObject("CP3")
	KillObject("CP4")
	KillObject("CP5")
	KillObject("CP6")
	--This delays the objectives until the player spawns
    onfirstspawn = OnCharacterSpawn(
	        function(character)
	            if IsCharacterHuman(character) then
	                ReleaseCharacterSpawn(onfirstspawn)
	                onfirstspawn = nil
	                
	                ScriptCB_PlayInGameMusic("rep_fel_amb_obj1_3_explore")
	                onfirstspawn = nil
	                start_timer = CreateTimer("start_timer")
	                SetTimerValue(start_timer, 2)
	                StartTimer(start_timer)
	                begin_objectives = OnTimerElapse(
                	function()
                		BeginObjectives()
                		ReleaseTimerElapse(begin_objectives)
                		begin_objectives = nil
                	end,
                	start_timer
                	)
	            end
	            
	        end)
	        
	        
    Objective1 = ObjectiveGoto:New{TeamATT = ATT, TeamDEF = DEF, text = "level.fel1.objectives.campaign.1", popupText = "level.fel1.objectives.campaign.1_popup", regionName = "goto1", timeLimit = 30, timeLimitWinningTeam = DEF}
    
    Objective1.OnStart = function(self)
    	MapAddEntityMarker("atte_busted", "hud_objective_icon_circle", 3.0, 1, "YELLOW", true)
    	
--    	SetClassProperty("rep_walk_atte", "MaxSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "MaxStrafeSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "MaxTurnSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "StoppedTurnSpeed", 0)
--    	SetClassProperty("rep_walk_atte", "Acceleration", 0)
    	SetProperty("atte_busted", "MaxHealth", 5000000)
    	SetProperty("atte_busted", "CurHealth", 4000000)
    	ScriptCB_EnableCommandPostVO(0)
    	BroadcastVoiceOver("FEL_obj_05", ATT)
    	
    	vo2_timer = CreateTimer("vo2_timer")
    	SetTimerValue(vo2_timer, 1)
    	StartTimer(vo2_timer)
    	vo3_timer = CreateTimer("vo3_timer")
    	vo4_timer = CreateTimer("vo4_timer")
    	
    	playvo2 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_09", ATT)
    			ReleaseTimerElapse(playvo2)
    			playvo2 = nil
    			
    			SetTimerValue(vo3_timer, 9)
    			StartTimer(vo3_timer)
    		end,
    		vo2_timer
    		)
    		
    	playvo3 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_10", ATT)
    			ReleaseTimerElapse(playvo3)
    			playvo3 = nil
    			
    			SetTimerValue(vo4_timer, 3)
    			StartTimer(vo4_timer)
    		end,
    		vo3_timer
    		)
    		
    	playvo4 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_obj_06", ATT)
    			ReleaseTimerElapse(playvo4)
    			playvo4 = nil
    		end,
    		vo4_timer
    		)
    			
    	
    		
    end
    
    Objective1.OnComplete = function(self, winningTeam)
    	if winningTeam == ATT then
    		ReleaseTimerElapse(playvo2)
    		playvo2 = nil
    		ReleaseTimerElapse(playvo3)
    		playvo3 = nil
    		ReleaseTimerElapse(playvo4)
    		playvo4 = nil
    		
	    	MapRemoveEntityMarker("atte_busted")
	    	BroadcastVoiceOver("FEL_inf_11", ATT)
	    	vo6_timer = CreateTimer("vo6_timer")
	    	SetTimerValue(vo6_timer, 3)
	    	StartTimer(vo6_timer)
	    	ShowMessageText("game.objectives.complete", ATT)
    	end
    	
    	if winningTeam == DEF then
    	end
    	
    	
    	
    end
    
    --Objective 2
    acklay_count = 6
    Objective2 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.fel1.objectives.campaign.2", popupText = "level.fel1.objectives.campaign.2_popup", AIGoalWeight = 0}
	
	Objective2.OnStart = function(self) 
	

	
		BlockPlanningGraphArcs (1)
		--AI goals for objecjective 2
		att_obj2_defend = AddAIGoal(ATT, "Defend", 100, "atte_busted")
		--acklay_obj2_attack = AddAIGoal(3, "Destroy", 100, "ATTE")
		BroadcastVoiceOver("FEL_obj_07", ATT)
		vo7_timer = CreateTimer("vo7_timer")
		SetTimerValue(vo7_timer, 3)
    	StartTimer(vo7_timer)
    	vo8_timer = CreateTimer("vo8_timer") 
    	
    	playvo7 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_inf_12", ATT)
    			ReleaseTimerElapse(playvo7)
    			playvo7 = nil
    			
    			SetTimerValue(vo8_timer, 3)
    			StartTimer(vo8_timer)
    		end,
    		vo7_timer
    		)
    		
    	playvo8 = OnTimerElapse(
    		function()
    			BroadcastVoiceOver("FEL_obj_08", ATT)
    			ReleaseTimerElapse(playvo8)
    			playvo8 = nil
    		end,
    		vo8_timer
    		)
    		
--		SetProperty("acklay_cp1", "Team", 5)
--		SetProperty("acklay_cp2", "Team", 3)
--		SetProperty("acklay_cp3", "Team", 3)
		
		--ambush in the acklay
		Ambush("acklay_spawn", 3, 5, 0.5)
		MapAddClassMarker("geo_inf_acklay", "hud_objective_icon_circle", 3.5, ATT, "YELLOW", true)
		
		acklay_aigoal = AddAIGoal(5, "Defend", 100, "atte_busted")
		ReleaseTimerElapse(acklayspawn)
		acklayspawn = nil
		
		--MapAddClassMarker("geo_walk_acklay", "hud_objective_icon_circle", 3.0, ATT, "YELLOW", true)
		Objective2AcklayKill = OnObjectKillClass( 
			function(object, killer)
				if killer and IsCharacterHuman(killer) then
					acklay_count = acklay_count - 1 
					
					if acklay_count > 0 then						
						ShowMessageText("level.fel1.objectives.campaign.2-" .. acklay_count, 1)				 
					elseif acklay_count == 0 then
						Objective2:Complete(ATT)
						ReleaseObjectKill(Objective2AcklayKill)
						Objective2AcklayKill = nil
					end
					if acklay_count == 3 then
						Ambush("acklay_spawn", 3, 5, 0.5)
					elseif acklay_count == 2 then
						BroadcastVoiceOver("FEL_obj_15", ATT)
					elseif acklay_count == 1 then
						BroadcastVoiceOver("FEL_obj_16", ATT)
					end
					
				end
			end,
			"geo_inf_acklay"
		) 
		
	
		
--		acklayKillSpawn2 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp2", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn2)
--				end
--			end,
--			"acklay2"
--			)
--		acklayKillSpawn1 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp1", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn1)
--				end
--			end,
--			"acklay1"
--			)
--		acklayKillSpawn0 = OnObjectKillName(
--			function(object, killer)
--				if killer and IsCharacterHuman(killer) then
--					SetProperty("acklay_cp3", "Team", "0")
--					ReleaseObjectKill(acklayKillSpawn0)
--				end
--			end,
--			"acklay3"
--			)
--		
--		acklay1_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay1 damage threshold")
--				SetAIDamageThreshold("acklay1", 0.2)
--				ReleaseObjectInit(acklay1_dmgthreshold)
--			end,
--			"acklay1"
--			) 
--		acklay2_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay2 damage threshold")
--				SetAIDamageThreshold("acklay2", 0.2)
--				ReleaseObjectInit(acklay2_dmgthreshold)
--			end,
--			"acklay2"
--			)
--		acklay3_dmgthreshold = OnObjectInitName(
--			function()
--				print("set acklay3 damage threshold")
--				SetAIDamageThreshold("acklay3", 0.2)
--				ReleaseObjectInit(acklay3_dmgthreshold)
--			end,
--			"acklay3"
--			)
                 
	end
	
	Objective2.OnComplete = function(self)
		RespawnObject("CP6")
		ShowMessageText("game.objectives.complete", ATT)
		UnblockPlanningGraphArcs (1)
		RespawnObject("CP4")
		MapRemoveClassMarker("geo_inf_acklay")
		BroadcastVoiceOver("FEL_obj_09", ATT)
		ScriptCB_StopInGameMusic("rep_fel_amb_obj1_3_explore")
		ScriptCB_PlayInGameMusic("rep_fel_ObjComplete_01")
		 -- Music Timer -- 
		 music01Timer = CreateTimer("music01")
		SetTimerValue(music01Timer, 17.0)
				              
			StartTimer(music01Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("rep_fel_ObjComplete_01")
				ScriptCB_PlayInGameMusic("rep_fel_amb_defendATTE")
				DestroyTimer(timer)
			end,
			music01Timer
                         )		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)

		
	end
	
	--Objective3
	
	ATTE = Target:New{name = "atte_busted"}    
    Objective3 = ObjectiveAssault:New{teamATT = DEF, teamDEF = ATT, 
                    textDEF = "level.fel1.objectives.campaign.3",
                    textATT = "blah",
                    popupText = "level.fel1.objectives.campaign.3_popup", 
                    timeLimit = 120, timeLimitWinningTeam = ATT, AIGoalWeight = 0}
    Objective3:AddTarget(ATTE)
   
    Objective3.OnStart = function(self)
    	SetProperty("atte_busted", "MaxHealth", 50000)
    	SetProperty("atte_busted", "CurHealth", 40000)
    	def_obj3_attack = AddAIGoal(DEF, "Destroy", 60, "atte_busted")
    	def_obj3_dm = AddAIGoal(DEF, "Deathmatch", 40)
    	MapAddEntityMarker("atte_busted", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
    	DisableBarriers("acklay1")
    	DisableBarriers("acklay2")
    	DisableBarriers("acklay3")
    end
    
    Objective3.OnComplete = function(self, winningTeam)
    
    	if winningTeam == ATT then
    		SetProperty("atte_busted", "MaxHealth", 500000000)
    		SetProperty("atte_busted", "CurHealth", 400000000)
    		ShowMessageText("game.objectives.complete", ATT)
	    	DeleteAIGoal(def_obj3_attack)
	    	DeleteAIGoal(def_obj3_dm)
	    	DeleteAIGoal(att_obj2_defend)
	    	PowerCellSpawn = GetPathPoint("powercell_spawn", 0)
	    	CreateEntity("fel1_flag_powercell", PowerCellSpawn, "powercell") --Spawns the Holocron.
	    	--SetProperty("powercell", "GeometryName", "fel1_icon_powercell")
	    	--SetProperty("powercell", "CarriedGeometryName", "fel1_icon_powercell")
	    	SetProperty("powercell", "AllowAIPickUp", 0)
	    	UnlockHeroForTeam(1)
	    	BroadcastVoiceOver("FEL_obj_10", ATT)

	    	ATTReinforcementCount = GetReinforcementCount(ATT)
			SetReinforcementCount(ATT, ATTReinforcementCount + 15)
			MapRemoveEntityMarker("atte_busted")
		elseif winningTeam == DEF then
			BroadcastVoiceOver("FEL_inf_05", ATT)
		end
    	
    end
    
    --Objective 4
    
    Objective4 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.fel1.objectives.campaign.4", popupText = "level.fel1.objectives.campaign.4_popup", AIGoalWeight = 0}
	Objective4:AddFlag{name = "powercell", homeRegion = "", captureRegion = "powercell_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				mapIcon = "flag_icon", mapIconScale = 2.0}
	
	Objective4.OnStart = function(self)
		
		Ambush("acklay_spawn_powercell", 1, 5)
		Ambush("ctf_ambush", 8, 4)
		team4_ctf_goal = AddAIGoal(4, "Defend", 100, "obj4_defend")
		BroadcastVoiceOver("FEL_obj_11", ATT)
		ScriptCB_PlayInGameMusic("rep_fel_amb_power_retrieve")
		--SetProperty("cis_spawn1", "SpawnPath", "cis_spawn3")
		--SetProperty("cis_spawn1", "AllyPath", "GeoSpawn13")
		
		--This swaps the busted ATTE in for the functional one when the player picks up the power cell
		atte_swap = OnFlagPickUp(
			function(flag, carrier)
				if IsCharacterHuman(carrier) then
					KillObject("atte_busted")
					SetProperty("atte_cp", "Team", 1)
					ReleaseFlagPickUp(atte_swap)
					atte_swap = nil
					SetProperty("ATTE", "DisableTime", 1e+37)
				
				end
			end,
			"powercell"
			)
			
		powercell_capture_on = OnFlagPickUp(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("atte_marker", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
			ScriptCB_PlayInGameMusic("Rep_fel_amb_power_return")	
			end
		end,
		"powercell"
		)
		
		powercell_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapRemoveEntityMarker("atte_marker")				
			end
		end,
		"powercell"
		)
		
		att_obj4_dm = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj4_dm = AddAIGoal(DEF, "Deathmatch", 100)
	end
	
	Objective4.OnComplete = function(self)
		SetProperty("snail_cp", "Team", 2)
		ShowMessageText("game.objectives.complete", ATT)
		MapRemoveEntityMarker("atte_marker")
		
		ReleaseFlagPickUp(powercell_capture_on)
		powercell_capture_on = nil
		ReleaseFlagDrop(powercell_capture_off)
		powercell_capture_off = nil
		
		DeleteAIGoal(team4_ctf_goal)
		DeleteAIGoal(att_obj4_dm)
		DeleteAIGoal(def_obj4_dm)
		SetProperty("ATTE", "DisableTime", 0)
		SetProperty("ATTE", "Team", 1)
		BroadcastVoiceOver("FEL_OBJ_20", ATT)
		ScriptCB_PlayInGameMusic("rep_fel_act_01")
		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)
		BatchChangeTeams(4, DEF, 8)
		SetProperty("CP4", "SpawnPath", "c_cp2_spawn")
		
	end
	
	--Objective 5a
	
	Turret1 = Target:New{name = "turret1"}
	Turret2 = Target:New{name = "turret2"}
	Turret3 = Target:New{name = "turret3"}
	Turret4 = Target:New{name = "turret4"}
	Turret5 = Target:New{name = "turret5"}
	
	Objective5a = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
							  text = "level.fel1.objectives.campaign.5a", popupText = "level.fel1.objectives.campaign.5a_popup", AIGoalWeight = 0}
	Objective5a:AddTarget(Turret1)
	Objective5a:AddTarget(Turret2)
	Objective5a:AddTarget(Turret3)
	Objective5a:AddTarget(Turret4)
	Objective5a:AddTarget(Turret5)
	
	Objective5a.OnStart = function(self)
		SetProperty("turret1", "Team", 2)
		SetProperty("turret2", "Team", 2)
		SetProperty("turret3", "Team", 2)
		SetProperty("turret4", "Team", 2)
		SetProperty("turret5", "Team", 2)
		SetProperty("turret1", "CurHealth", 3000)
		SetProperty("turret2", "CurHealth", 3000)
		SetProperty("turret3", "CurHealth", 3000)
		SetProperty("turret4", "CurHealth", 3000)
		SetProperty("turret5", "CurHealth", 3000)
		Ambush("acklay_spawn_turret", 3, 5)
		BroadcastVoiceOver("FEL_obj_12", ATT)
		att_obj5_destroy1 = AddAIGoal(ATT, "Destroy", 10, "turret1")
		att_obj5_destroy2 = AddAIGoal(ATT, "Destroy", 10, "turret2")
		att_obj5_destroy3 = AddAIGoal(ATT, "Destroy", 10, "turret3")
		att_obj5_destroy4 = AddAIGoal(ATT, "Destroy", 60)
		att_obj5_dm = AddAIGoal(ATT, "Deathmatch", 10, "turret1")
		def_obj5_defend1 = AddAIGoal(DEF, "Defend", 25, "turret1")
		def_obj5_defend2 = AddAIGoal(DEF, "Defend", 25, "turret2")
		def_obj5_defend3 = AddAIGoal(DEF, "Defend", 25, "turret3")
		def_obj5_defend4 = AddAIGoal(DEF, "Defend", 25, "turret4")
		
		--Setup callback to show update messages when turrets are killed
		turret_count = 5
		TurretKill = OnObjectKillClass( 
			function(object, killer)
				if killer and IsCharacterHuman(killer) then
					turret_count = turret_count - 1 
					
					if turret_count > 0 then						
						ShowMessageText("level.fel1.objectives.campaign.5a-" .. turret_count, 1)				 
					end					
				end
			end,
			"tur_bldg_recoilless_fel_auto"
			) 
	end
	
	Objective5a.OnComplete = function(self)
		ReleaseObjectKill(TurretKill)
		TurretKill = nil
		
		ShowMessageText("game.objectives.complete", ATT)
		DeleteAIGoal(att_obj5_destroy1)
		DeleteAIGoal(att_obj5_destroy2)
		DeleteAIGoal(att_obj5_destroy3)
		DeleteAIGoal(att_obj5_destroy4)
		DeleteAIGoal(att_obj5_dm)
		DeleteAIGoal(def_obj5_defend1)
		DeleteAIGoal(def_obj5_defend2)
		DeleteAIGoal(def_obj5_defend3)
		DeleteAIGoal(def_obj5_defend4)
		--RespawnObject("CP2")
		--AICanCaptureCP("CP2", ATT, false)
		--BroadcastVoiceOver("FEL_obj_19", ATT)
		BroadcastVoiceOver("FEL_obj_14", ATT) --set back to 13
		--ATTReinforcementCount = GetReinforcementCount(ATT)
		--SetReinforcementCount(ATT, ATTReinforcementCount + 15)

	end
		
    --Objective 5
    
    Objective5CP = CommandPost:New{name = "CP2"}
	Objective5 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.fel1.objectives.campaign.5", popupText = "level.fel1.objectives.campaign.5_popup", AIGoalWeight = 0}
	Objective5:AddCommandPost(Objective5CP)
	
	Objective5.OnStart = function(self)
		def_obj5_defend = AddAIGoal(DEF, "Defend", 100, "CP2")
		att_obj5_capture = AddAIGoal(ATT, "Defend", 100, "CP2")
	end
	
	Objective5.OnComplete = function(self)
		ShowMessageText("game.objectives.complete", ATT)
		
		ATTReinforcementCount = GetReinforcementCount(ATT)
		SetReinforcementCount(ATT, ATTReinforcementCount + 15)
		DeleteAIGoal(def_obj5_defend)
		DeleteAIGoal(att_obj5_capture)
	end
	--Objective6			
	--This is the actual objective setup
    Objective6 = ObjectiveTDM:New{teamATT = ATT, teamDEF = DEF, 
                           textATT = "level.fel1.objectives.campaign.6",
                           popupText = "level.fel1.objectives.campaign.6_popup",
                           textDEF = "Kill Everyone!", AIGoalWeight = 0}
	
	Objective6.OnStart = function(self)
		SetReinforcementCount(DEF, 20)
		att_obj6goal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj6goal = AddAIGoal(DEF, "Deathmatch", 100)
	end
	
	Objective6.OnComplete = function(self)
		BroadcastVoiceOver("FEL_obj_14", ATT)
    end
    
    EnableSPScriptedHeroes()


    
    
end


function BeginObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 7.0}
    objectiveSequence:AddObjectiveSet(Objective1)
    objectiveSequence:AddObjectiveSet(Objective2)
    objectiveSequence:AddObjectiveSet(Objective3)
    objectiveSequence:AddObjectiveSet(Objective4)
    objectiveSequence:AddObjectiveSet(Objective5a)
    --objectiveSequence:AddObjectiveSet(Objective5)
    --objectiveSequence:AddObjectiveSet(Objective6)
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
 
 
    -- Designers, these two lines *MUST* be first.
    StealArtistHeap(1024*1024)
    SetPS2ModelMemory(3200000)
    ReadDataFile("ingame.lvl")
    
    SetMemoryPoolSize ("Combo",30)				-- should be ~ 2x number of jedi classes
	SetMemoryPoolSize ("Combo::State",350)		-- should be ~12x #Combo
	SetMemoryPoolSize ("Combo::Transition",256)	-- should be a bit bigger than #Combo::State
	SetMemoryPoolSize ("Combo::Condition",256)	-- should be a bit bigger than #Combo::State
	SetMemoryPoolSize ("Combo::Attack",300)		-- should be ~8-12x #Combo
	SetMemoryPoolSize ("Combo::DamageSample",1000)	-- should be ~8-12x #Combo::Attack
	SetMemoryPoolSize ("Combo::Deflect",64)		-- should be ~1x #combo
	SetMemoryPoolSize ("ClothData",19)
	SetMemoryPoolSize ("EntityCloth",40)		
	SetMemoryPoolSize ("Music", 39)

    ReadDataFile("sound\\fel.lvl;fel1cw")
    SetMaxFlyHeight(53)
    SetMaxPlayerFlyHeight (53)
    ReadDataFile("SIDE\\rep.lvl",
                             --"Rep_hover_swampspeeder",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper_felucia", 
                             "rep_hero_aalya",
                             "rep_walk_atte",
                             "rep_inf_ep3_officer")
                             --"rep_bldg_defensegridturret")
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_tread_snailtank",
                             --"cis_hover_stap",     
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper")
                           --  "cis_bldg_defensegridturret")

    ReadDataFile("SIDE\\geo.lvl",
                             "geo_inf_acklay")
                             
   	ReadDataFile("SIDE\\tur.lvl",
                             "tur_bldg_recoilless_fel_auto")
                             
 
 
 
      SetAttackingTeam(ATT)
      
SetupTeams{
    rep = {
        team = REP,
        units = 18,
        reinforcements = 40,
        soldier  = { "rep_inf_ep3_rifleman", 10},
        assault  = { "rep_inf_ep3_rocketeer", 3},
        engineer = { "rep_inf_ep3_engineer", 3},
        sniper   = { "rep_inf_ep3_sniper_felucia", 3},
        officer  = { "rep_inf_ep3_officer", 3},
        special  = { "rep_inf_ep3_jettrooper", 3},
               --        turret = { "rep_bldg_defensegridturret"}, 
    },
    cis = {
        team = CIS,
        units = 10,
        reinforcements = -1,
        soldier  = { "CIS_inf_rifleman", 5},
        assault  = { "CIS_inf_rocketeer", 5},
        --engineer = { "CIS_inf_engineer", 3},
        --sniper   = { "CIS_inf_sniper", 3},
        --officer = { "CIS_inf_officer", 3},
               --   turret = { "cis_bldg_defensegridturret"},
    },

}

	--  Local Stats -- Acklay
	SetTeamName(3, "acklay")
	SetTeamAsEnemy(3, ATT)
	SetTeamAsEnemy(3, DEF)
	SetTeamAsEnemy(ATT, 3)
	SetTeamAsEnemy(DEF, 3)
	
	SetTeamName(4, "cis")
	SetTeamAsEnemy(4, ATT)
	SetTeamAsFriend(4, DEF)
	SetTeamAsEnemy(ATT, 4)
	SetTeamAsFriend(DEF, 4) 
	SetTeamAsEnemy(5, ATT)
	SetTeamAsEnemy(ATT, 5)
	
	SetUnitCount(4, 8)
	
	AddUnitClass(4, "CIS_inf_engineer", 2)
	AddUnitClass(4, "CIS_inf_sniper", 3)
	AddUnitClass(4, "CIS_inf_officer", 3)
	SetReinforcementCount(4, -1)
	
	SetTeamName(5, "acklay")
	SetUnitCount(5, 4)
	AddUnitClass(5, "geo_inf_acklay", 4)
	SetReinforcementCount(5, -1)
	
	

    SetHeroClass(REP, "rep_hero_aalya")
    --SetHeroClass(CIS, "cis_hero_jangofett")

    --  Level Stats
    ClearWalkers()
    -- AddWalkerType(0, 8)
    SetMemoryPoolSize("EntityWalker", 0)
    --AddWalkerType(0, 2) -- 2 droidekas (special case: 0 leg pairs)
    AddWalkerType(3, 1) -- 1 atte with 3 leg pairs each
    AddWalkerType(2, 3) -- 3 acklay with 2 leg pairs each
    SetMemoryPoolSize("Aimer", 51)
    SetMemoryPoolSize("BaseHint", 154)
    SetMemoryPoolSize("CommandWalker", 1)
    SetMemoryPoolSize("EntityHover", 4)
    SetMemoryPoolSize("EntityLight", 33)
    SetMemoryPoolSize("MountedTurret", 7)
    SetMemoryPoolSize("Obstacle", 400)
    SetMemoryPoolSize("PathNode", 192)
    SetMemoryPoolSize("TreeGridStack", 280)
    SetMemoryPoolSize("Weapon", 220)
    SetMemoryPoolSize("FlagItem", 1)
    SetMemoryPoolSize("AcklayData", 6)
    SetMemoryPoolSize("EntityFlyer", 6)
    
    SetSpawnDelay(10.0, 0.25)
    SetDenseEnvironment("false")
    SetAIViewMultiplier(0.65)
    --AddDeathRegion("Sarlac01")
        ReadDataFile("fel\\fel1.lvl", "fel1_campaign")
    
    --  Birdies
    SetNumBirdTypes(1)
    SetBirdType(0,1.0,"bird")  
        
    --  Sound Stats
        
    voiceSlow = OpenAudioStream("sound\\global.lvl", "fel_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick) 
      
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    OpenAudioStream("sound\\fel.lvl",  "fel1")
    -- OpenAudioStream("sound\\fel.lvl",  "fel_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\fel.lvl",  "fel1_emt")
  
    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)
  
    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")
    
    -- SetAmbientMusic(REP, 1.0, "rep_fel_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_fel_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_fel_amb_end",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_fel_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_fel_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_fel_amb_end",    2,1)
    
    SetVictoryMusic(REP, "rep_fel_amb_victory")
    SetDefeatMusic (REP, "rep_fel_amb_defeat")
    SetVictoryMusic(CIS, "cis_fel_amb_victory")
    SetDefeatMusic (CIS, "cis_fel_amb_defeat")
   
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
    AddCameraShot(0.896307, -0.171348, -0.401716, -0.076796, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.909343, -0.201967, -0.355083, -0.078865, -116.306931, 31.039505, 20.757469)
    AddCameraShot(0.543199, 0.115521, -0.813428, 0.172990, -108.378189, 13.564240, -40.644150)
    AddCameraShot(0.970610, 0.135659, 0.196866, -0.027515, -3.214346, 11.924586, -44.687294)
    AddCameraShot(0.346130, 0.046311, -0.928766, 0.124267, 87.431061, 20.881388, 13.070729)
    AddCameraShot(0.468084, 0.095611, -0.860724, 0.175812, 18.063482, 19.360580, 18.178158)

end



