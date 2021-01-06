--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("MultiObjectiveContainer")
ScriptCB_DoFile("ObjectiveAssault")
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("ObjectiveGoto")
ScriptCB_DoFile("ObjectiveCTF")
ScriptCB_DoFile("ObjectiveTDM")
ScriptCB_DoFile("Ambush")
ScriptCB_DoFile("setup_teams")
--  REP Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2


function ScriptPostLoad()

	SetAIDifficulty(2, -8, "medium")
	AllowAISpawn(REP, false)
	SetMissionEndMovie("ingame.mvs", "geomon02") 
	AddAIGoal(3, "Deathmatch", 100)
	ScriptCB_SetGameRules("campaign")
	ScriptCB_PlayInGameMovie("ingame.mvs", "geomon01")
	EnableSPScriptedHeroes()
	AddDeathRegion("deathregion")
	AddDeathRegion("deathregion2")
	AddDeathRegion("deathregion3")
	AddDeathRegion("deathregion4")
	AddDeathRegion("deathregion5")
	--SetProperty("c_cp3", "CaptureRegion", "cp3_capture_outofreach")
	
		onfirstspawn = OnCharacterSpawn(
	        function(character)
	            if character == 0 then
	            	ShowPopup("level.geo1.hints.hints")
	                ReleaseCharacterSpawn(onfirstspawn)
	                onfirstspawn = nil
	                BeginObjectivesTimer()
	                ScriptCB_EnableCommandPostVO(0)
	                BroadcastVoiceOver("GEO_obj_18", ATT)
	                ScriptCB_PlayInGameMusic("rep_geo_amb_obj1_3_explore")
	            end
	        end)

	
	KillObject("c_cp4")
	KillObject("c_cp3")
	KillObject("c_cp8")
	
	
	--set max health on droids so player can't repair them before the objective
	SetProperty("ammo_pad", "MaxHealth", 9999999999)
	SetProperty("health_pad", "MaxHealth", 9999999999)
	SetProperty("ammo_pad", "CurHealth", 0)
	SetProperty("health_pad", "CurHealth", 0)
	--and this kills them so they have to be repaired
	KillObject("ammo_pad")
	KillObject("health_pad")
 
 --Objective1
 
 	Objective1 = ObjectiveGoto:New{TeamATT = ATT, TeamDEF = DEF, 
								   text = "level.geo1.objectives.campaign.1", popupText = "level.geo1.objectives.campaign.1_popup",
								   regionName = "goto1", mapIcon = "hud_objective_icon_circle",  AIGoalWeight = 0}
	
	Objective1:AddHint("level.geo1.hints.movement")
	Objective1:AddHint("level.geo1.hints.obj_markers")
	Objective1:AddHint("level.geo1.hints.review_objectives")
	Objective1:AddHint("level.geo1.hints.sprint")
	
	
	
 	Objective1.OnStart = function(self)
 		AICanCaptureCP("c_cp3", ATT, false)
	 	att_obj1_aigoal = AddAIGoal(ATT, "Deathmatch", 1)
	 	def_obj1_aigoal = AddAIGoal(DEF, "Deathmatch", 1)
	 	BroadcastVoiceOver("GEO_obj_54", ATT)
	 	MapAddEntityMarker("goto", "hud_objective_icon", 3.0, 1, "YELLOW", true)
	 	SetProperty("obj3_wheeltank", "MaxHealth", 80000000)
	 	SetProperty("obj3_wheeltank", "CurHealth", 5000000)
	 	SetProperty("obj3_wheeltank", "DisableTime", 1e+37)
	 	
 	end
 	
 	Objective1.OnComplete = function(self)
 		DeleteAIGoal(att_obj1_aigoal)
 		DeleteAIGoal(def_obj1_aigoal)
 		BroadcastVoiceOver("GEO_obj_55", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		MapRemoveEntityMarker("goto")
		
		
		
		
 	end
 	
 	--Objective 2a, destroy the 3 droids
 	
 	Scouts = TargetType:New{classname = "cis_inf_rifleman", killLimit = 3, icon = "hud_objective_icon_circle"}
	
	Objective2a = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
							  text = "level.geo1.objectives.campaign.2a", popupText = "level.geo1.objectives.campaign.2a_popup",  AIGoalWeight = 0}
	Objective2a:AddTarget(Scouts)
	
	Objective2a:AddHint("level.geo1.hints.weapons")
	Objective2a:AddHint("level.geo1.hints.lockon")
	Objective2a:AddHint("level.geo1.hints.reticle")
	Objective2a:AddHint("level.geo1.hints.enemymarkers")
 	
 	Objective2a.OnStart = function(self)
 		Ambush("scout_ambush_spawn", 3, 4)
 		scouts_goal = AddAIGoal(4, "Defend", 100, "health_pad")
 	end
 	
 	Objective2a.OnComplete = function(self)
 		ShowMessageText("game.objectives.complete", ATT)
 		DeleteAIGoal(scouts_goal)
		BroadcastVoiceOver("GEO_obj_56", ATT)
 		
 	end
 	
 	--Objective 2b, destroy the wheel tank
 	
 	Wheeltank = TargetType:New{classname = "cis_tread_hailfire", killLimit = 1, killedByPlayer = true, icon = "hud_objective_icon_circle"}
	
	Objective2b = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
							  text = "level.geo1.objectives.campaign.2b", popupText = "level.geo1.objectives.campaign.2b_popup",  AIGoalWeight = 0}
	Objective2b:AddTarget(Wheeltank)
 	
 	Objective2b.OnStart = function(self) 		
 		SetProperty("obj3_wheeltank", "MaxHealth", 8000)
	 	SetProperty("obj3_wheeltank", "CurHealth", 500)
	 	BroadcastVoiceOver("GEO_obj_57", ATT)
 	end
 	
 	Objective2b.OnComplete = function(self)
 		ShowMessageText("game.objectives.complete", ATT)
 		KillObject("obj3_wheel")
 		BroadcastVoiceOver("GEO_obj_58", ATT)
 		RespawnObject("c_cp3")
 		
 	end
 --Objective 2
 	Objective2CP = CommandPost:New{name = "c_cp3"}
	Objective2 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.2", popupText = "level.geo1.objectives.campaign.2_popup",  AIGoalWeight = 0}
	Objective2:AddCommandPost(Objective2CP)
	
	Objective2:AddHint("level.geo1.hints.capture_cp")
	
	Objective2.OnStart = function(self)
		AllowAISpawn(REP, true)
		att_obj2_aigoal = AddAIGoal(ATT, "Defend", 50, "c_cp3")
		def_obj2_aigoal = AddAIGoal(DEF, "Defend", 50, "c_cp3")
		att_obj2_aigoal2 = AddAIGoal(ATT, "Deathmatch", 50)
		def_obj2_aigoal2 = AddAIGoal(DEF, "Deathmatch", 50)
		--BatchChangeTeams(5, ATT, 11)
		--SetUnitCount(1, 12)
		AddUnitClass(1, "rep_inf_ep2_rifleman", 10)
		SetProperty("cis_spawn1", "Team", 2)
	end
		
	Objective2.OnComplete = function(self)
		BroadcastVoiceOver("GEO_obj_59", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		--SetProperty("c_cp3", "CaptureRegion", "cp3_capture_outofreach")
		DeleteAIGoal(att_obj2_aigoal)
		DeleteAIGoal(att_obj2_aigoal2)
		DeleteAIGoal(def_obj2_aigoal)
		DeleteAIGoal(def_obj2_aigoal2)
		AICanCaptureCP("c_cp3", DEF, false)
		SetProperty("c_cp3", "Team", 1)
	end
	
	
 
 --Objective 3
 	droid_count = 5 	
	Objective3 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.3", popupText = "level.geo1.objectives.campaign.3_popup",  AIGoalWeight = 0}
	
	Objective3.OnStart = function(self) 
		att_obj3_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj3_aigoal = AddAIGoal(DEF, "Defend", 50, "c_cp3")
		def_obj3_aigoal2 = AddAIGoal(DEF, "Deathmatch", 50)
		Objective3DroidKill = OnObjectKill( 
			function(object, killer) 
				if killer and IsCharacterHuman(killer) and GetObjectTeam(object) == DEF then
					droid_count = droid_count - 1
					if droid_count > 0 then 
						ShowMessageText("level.geo1.objectives.campaign.3-" .. droid_count, 1) 
					end
					if droid_count == 0 then 
					   Objective3:Complete(ATT) 
					   ReleaseObjectKill(Objective3DroidKill) 
					end 
				end 
			end 
		) 
                 
	end
	
	Objective3.OnComplete = function(self)
		BroadcastVoiceOver("GEO_obj_26", ATT)
		ShowMessageText("game.objectives.complete", ATT)
		DeleteAIGoal(att_obj3_aigoal)
		DeleteAIGoal(def_obj3_aigoal)
		DeleteAIGoal(def_obj3_aigoal2)
	end
	
	--Objective 4
	Objective4CP = CommandPost:New{name = "c_cp8"}
	Objective4 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.4", popupText = "level.geo1.objectives.campaign.4_popup",  AIGoalWeight = 0}
	Objective4:AddCommandPost(Objective4CP)
	
	Objective4.OnStart = function(self)
		BroadcastVoiceOver("GEO_obj_24", ATT)
		--SetProperty("cis_spawn1", "SpawnPath", "cis_spawn2")
		RespawnObject("c_cp8")
		AICanCaptureCP("c_cp8", ATT, false)
		SetProperty("c_cp8", "Team", 2)
		att_obj4_aigoal = AddAIGoal(ATT, "Defend", 50, "c_cp8")
		att_obj4_aigoal2 = AddAIGoal(ATT, "Deathmatch", 50)
		def_obj4_aigoal = AddAIGoal(DEF, "Deathmatch", 90)
		def_obj4_aigoal2 = AddAIGoal(DEF, "Defend", 10, "c_cp8")
	end
	
	Objective4.OnComplete = function (self)
		ShowMessageText("game.objectives.complete", ATT)
		BroadcastVoiceOver("GEO_obj_11", ATT)
		BroadcastVoiceOver("GEO_obj_52", ATT)		
		SetProperty("c_cp8", "CaptureRegion", "c_cp4_no")
		--spawn the flag object for the next objective
		plans_spawn = GetPathPoint("plans_spawn", 0) --gets the path point
        CreateEntity("geo1_flag_disk", plans_spawn, "plans") --spawns the flag
        --SetProperty("plans", "GeometryName", "geo_icon_disk")
        --SetProperty("plans", "CarriedGeometryName", "geo_icon_disk")
        DeleteAIGoal(att_obj4_aigoal)
        DeleteAIGoal(att_obj4_aigoal2)
        DeleteAIGoal(def_obj4_aigoal)
        DeleteAIGoal(def_obj4_aigoal2)
        AICanCaptureCP("c_cp8", DEF, false)
        SetProperty("c_cp8", "Team", 1)
        
	end
	
	----
	--Objective 5
	----
	
	Objective5 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.geo1.objectives.campaign.5", popupText = "level.geo1.objectives.campaign.5_popup",  AIGoalWeight = 0}
	Objective5:AddFlag{name = "plans", homeRegion = "", captureRegion = "cp8_capture",
				capRegionMarker = "hud_objective_icon", capRegionMarkerScale = 3.0, 
				mapIcon = "flag_icon", mapIconScale = 2.0}
	
	Objective5.OnStart = function(self)
		att_obj5_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj5_aigoal = AddAIGoal(DEF, "Defend", 50, "c_cp8")
		def_obj5_aigoal2 = AddAIGoal(DEF, "Deathmatch", 50)
		--SetProperty("cis_spawn1", "SpawnPath", "cis_spawn3")
		--SetProperty("cis_spawn1", "AllyPath", "GeoSpawn13")
		plans_capture_on = OnFlagPickUp(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("c_cp8", "hud_objective_icon", 4.0, ATT, "YELLOW", true)				
			end
		end,
		"plans"
		)
	
		
		
		plans_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapRemoveEntityMarker("c_cp8")				
			end
		end,
		"plans"
		)
		
		
	end
					
	Objective5.OnComplete = function (self)
		ShowMessageText("game.objectives.complete", ATT)
		--RespawnObject("c_cp7")
		
		ReleaseFlagPickUp(plans_capture_on)
		ReleaseFlagDrop(plans_capture_off)
		MapRemoveEntityMarker("c_cp8")
		
		DeleteAIGoal(att_obj5_aigoal)
		DeleteAIGoal(def_obj5_aigoal)
		DeleteAIGoal(def_obj5_aigoal2)
	end
	
	--Objective10			
	--This is the actual objective setup
    Objective20 = ObjectiveTDM:New{teamATT = ATT, teamDEF = DEF, 
                           textATT = "level.geo1.objectives.campaign.20",
                           textDEF = "Kill Everyone!"}
	
	Objective20.OnStart = function(self)
		SetReinforcementCount(DEF, 25)
	end
	
	--Objective21
	
	droid_count_obj21 = 10 	
	Objective21 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.21", popupText = "level.geo1.objectives.campaign.21_popup",  AIGoalWeight = 0}
	
	Objective21:AddHint("level.geo1.hints.jedi_forcepowers")
	Objective21:AddHint("level.geo1.hints.jedi_superjump")
	
	Objective21.OnStart = function(self)
	
		--ScriptCB_PlayInGameMovie("ingame.mvs", "geo1cam2")
		
		--BroadcastVoiceOver("GEO_obj_37", ATT)
				
		SetHeroClass(REP, "rep_hero_macewindu")
		UnlockHeroForTeam(1)
		AcceptHero(0)
		att_obj21_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj21_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		
		Objective21.maceTimer = CreateTimer("macetimer")
		
		SetTimerValue(Objective21.maceTimer, 1.0)						              
		StartTimer(Objective21.maceTimer)
		Objective21.maceTimerResponse = OnTimerElapse(
			function(timer)
				--total hack to make sure mace stays unlocked
				UnlockHeroForTeam(1)
				SetTimerValue(Objective21.maceTimer, 1.0)
				StartTimer(Objective21.maceTimer)
			end,
			Objective21.maceTimer
		)
                        
		Objective21.maceDies = OnObjectKillClass(
			function(object, killer)
				--even if he dies, make sure the player can keep
				--selecting him, since he's essential to beating the objective
				UnlockHeroForTeam(1)
			end,
			"rep_hero_macewindu"
		)
			
		
		Objective21.DroidKill = OnObjectKill( 
			function(object, killer) 
				if killer and IsCharacterHuman(killer) and GetObjectTeam(object) == DEF then
					if GetObjectLastHitWeaponClass(object) == "rep_weap_lightsaber" or GetObjectLastHitWeaponClass(object) == "com_weap_inf_sabre_throw" then
						droid_count_obj21 = droid_count_obj21 - 1 
						if droid_count_obj21 > 0 then
							
							ShowMessageText("level.geo1.objectives.campaign.21-" .. droid_count_obj21, 1) 
						end
						if droid_count_obj21 == 0 then 
						   Objective21:Complete(ATT) 
						   ReleaseObjectKill(Objective21.DroidKill)
						end 
					end
				end 
			end 
		) 
                 
	end
	
	Objective21.OnComplete = function(self)
		ReleaseObjectKill(Objective21.maceDies)
		ReleaseTimerElapse(Objective21.maceTimerResponse)
		StopTimer(Objective21.maceTimer)
		ShowMessageText("game.objectives.complete", ATT)
		RespawnObject("c_cp8")
	end
	
	--Objective6a - change to engineer
	Objective6a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.6a", popupText = "level.geo1.objectives.campaign.6a_popup"}
	
	Objective6a.OnStart = function(self)
		AddUnitClass(1, "rep_inf_ep2_engineer", 4)
		MapAddEntityMarker("c_cp3", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true, true, true)
		att_obj6_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj6_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		player_selected_engineer = OnCharacterChangeClass(
			function(player)
				if IsCharacterHuman(player) and GetCharacterClass(player) == 1 then
					ReleaseCharacterChangeClass(player_selected_engineer)
					Objective6a:Complete(ATT)
				end
			end
			)
	end
	
	Objective6a.OnComplete = function(self)
		MapRemoveEntityMarker("c_cp3")
		BroadcastVoiceOver("GEO_obj_60", ATT)
	end
	
	Objective6a:AddHint("level.geo1.hints.change_units")
	--Objective 6
	Objective6 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.6", popupText = "level.geo1.objectives.campaign.6_popup",  AIGoalWeight = 0}
	
	
	Objective6:AddHint("level.geo1.hints.fusion_cutter")
	
	Objective6.OnStart = function(self)
		
		--SetUnitCount(1, 15)
		--BatchChangeTeams(6, ATT, 3)
		
		SetProperty("ammo_pad", "MaxHealth", 200)
		SetProperty("health_pad", "MaxHealth", 200)
		SetProperty("ammo_pad", "CurHealth", 0)
		SetProperty("health_pad", "CurHealth", 0)
		pad_count = 2
		MapAddEntityMarker("health_pad", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
		health_pad_repair = OnObjectRepairName(
		function(objPtr, characterId)
			MapRemoveEntityMarker("health_pad")
			ReleaseObjectRepair(health_pad_repair)
			if pad_count == 2 then
				pad_count = pad_count - 1
			elseif pad_count == 1 then
				Objective6:Complete(ATT)
			end
		end,
		"health_pad"
		)
		
		MapAddEntityMarker("ammo_pad", "hud_objective_icon", 4.0, ATT, "YELLOW", true)
		ammo_pad_repair = OnObjectRepairName(
		function(objPtr, characterId)
			ReleaseObjectRepair(ammo_pad_repair)
			MapRemoveEntityMarker("ammo_pad")
			if pad_count == 2 then
				pad_count = pad_count - 1
			elseif pad_count == 1 then
				Objective6:Complete(ATT)
			end			
		end,
		"ammo_pad"
		)
		
	end
	
	Objective6.OnComplete = function(self)
		
		--SetTimerValue(hint6timer, 3)
		--StartTimer(hint6timer)
		--hint6b = OnTimerElapse(PlayHint6b, hint6timer)
		DeleteAIGoal(att_obj6_aigoal)
		DeleteAIGoal(def_obj6_aigoal)
		ScriptCB_PlayInGameMusic("rep_geo_amb_vehicle_01")
		BroadcastVoiceOver("GEO_obj_12", ATT)		
		ShowMessageText("game.objectives.complete", ATT)
		SetProperty("atte_cp", "Team", 1)
		SetProperty("spider_cp", "Team", 2)
	end
	
	
	--Objective 8
	Objective8CP = CommandPost:New{name = "c_cp4"}
	Objective8 = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.8", popupText = "level.geo1.objectives.campaign.8_popup",  AIGoalWeight = 0}
	Objective8:AddCommandPost(Objective8CP)
	Objective8.OnStart = function(self)
		Ambush("cliff_ambush_spawn", 4, 4)
		cliff_goal = AddAIGoal(4, "Defend", 100, "c_cp4")
		att_obj8_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj8_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		AICanCaptureCP("c_cp4", ATT, false)
		RespawnObject("c_cp4")
		SetProperty("c_cp4", "Team", 2)
		--SetProperty("c_cp4", "CaptureRegion", "c_cp4_no")
		ActivateRegion("c_cp4_capture")
		c_cp4_activate = OnEnterRegion(
        function(region, character) 
            if IsCharacterHuman(character) then 
                SetProperty("c_cp4", "CaptureRegion", "c_cp4_capture") 
                --ShowMessageText("blahblahbl", 1)
                ReleaseEnterRegion(c_cp4_activate)
            end
        end,
        "c_cp4_capture"
        )
		
	end
	
	Objective8.OnComplete = function(self)
		BroadcastVoiceOver("GEO_obj_29", ATT)
		ScriptCB_PlayInGameMusic("rep_geo_objComplete_02")
		 -- Music Timer -- 
		 music02Timer = CreateTimer("music02")
		SetTimerValue(music02Timer, 10.0)
				              
			StartTimer(music02Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("rep_geo_objComplete_02")
				ScriptCB_PlayInGameMusic("rep_geo_amb_act_01")
				DestroyTimer(timer)
			end,
			music02Timer
                        ) 		
		ShowMessageText("game.objectives.complete", ATT)
		SetProperty("c_cp4", "CaptureRegion", "c_cp4_no")
		DeleteAIGoal(att_obj8_aigoal)
		DeleteAIGoal(def_obj8_aigoal)
		AICanCaptureCP("c_cp4", DEF, false)
		SetProperty("c_cp4", "Team", 1)
	end
	
	
	Objective9a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.9a", popupText = "level.geo1.objectives.campaign.9a_popup"}
	Objective9a.OnStart = function(self)
		MapAddEntityMarker("c_cp4", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true, true, true)
		AddUnitClass(1, "rep_inf_ep2_sniper", 4)
		att_obj9_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj9_aigoal = AddAIGoal(DEF, "Deathmatch", 100) 
		player_selected_sniper = OnCharacterChangeClass(
			function(player)
				if IsCharacterHuman(player) and GetCharacterClass(player) == 3 then
					ReleaseCharacterChangeClass(player_selected_sniper)
					Objective9a:Complete(ATT)
				end
			end
			)
	end
	
	Objective9a.OnComplete = function(self)
		MapRemoveEntityMarker("c_cp4")
	
	end	
	--Objective 11
 	sniperdroid_count = 3 	
	Objective9 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.9", popupText = "level.geo1.objectives.campaign.9_popup",  AIGoalWeight = 0}
	
	Objective9:AddHint("level.geo1.hints.zoom")
	Objective9:AddHint("level.geo1.hints.head_shots")
	
	Objective9.OnStart = function(self)
		
		
		Objective9DroidKill = OnObjectKill( 
			function(object, killer) 
				if killer and IsCharacterHuman(killer) and GetObjectTeam(object) == DEF and GetObjectLastHitWeaponClass(object) == "rep_weap_inf_sniper_rifle" then
					if sniperdroid_count > 1 then
						sniperdroid_count = sniperdroid_count - 1 
						ShowMessageText("level.geo1.objectives.campaign.9-" .. sniperdroid_count, 1) 
					elseif sniperdroid_count == 1 then 
					   Objective9:Complete(ATT) 
					   ReleaseObjectKill(Objective9DroidKill) 
					end 
				end 
			end 
		) 
                 
	end
		
	Objective9.OnComplete = function(self)
		
        BroadcastVoiceOver("GEO_obj_69", ATT)
        ShowMessageText("game.objectives.complete", ATT)
        DeleteAIGoal(att_obj9_aigoal)
		DeleteAIGoal(def_obj9_aigoal)
	end
	
	Objective10a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.10a", popupText = "level.geo1.objectives.campaign.10a_popup"}
	Objective10a.OnStart = function(self)
		MapAddEntityMarker("c_cp3", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true, true, true)
		AddUnitClass(1, "rep_inf_ep2_jettrooper_training", 3)
		att_obj10_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj10_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		player_selected_jettrooper = OnCharacterChangeClass(
			function(player)
				if IsCharacterHuman(player) and GetCharacterClass(player) == 2 then
					ReleaseCharacterChangeClass(player_selected_jettrooper)
					Objective10a:Complete(ATT)
				end
			end
			)
	end
	
	Objective10a.OnComplete = function(self)
		MapRemoveEntityMarker("c_cp3")
		BroadcastVoiceOver("GEO_obj_67", ATT)
	end
	
	--Objective 10
	Objective10 = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 1, text = "level.geo1.objectives.campaign.10", popupText = "level.geo1.objectives.campaign.10_popup",  AIGoalWeight = 0}
	Objective10:AddFlag{name = "holocron", homeRegion = "", captureRegion = "holocron_capture",
				capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
				mapIcon = "flag_icon", mapIconScale = 2.0}
	
	Objective10:AddHint("level.geo1.hints.acquire")
	Objective10:AddHint("level.geo1.hints.return")
	
	Objective10.OnStart = function(self)
		plans_capture_on = OnFlagPickUp(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapAddEntityMarker("goto", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)				
			end
		end,
		"holocron"
		)
	
		
		
		plans_capture_off = OnFlagDrop(
		function(flag, carrier)
			if IsCharacterHuman(carrier) then
				MapRemoveEntityMarker("goto")				
			end
		end,
		"holocron"
		)
	end
				
	Objective10.OnComplete = function (self)
		MapRemoveEntityMarker("goto")
		ReleaseFlagPickUp(plans_capture_on)
		ReleaseFlagDrop(plans_capture_off)
		BroadcastVoiceOver("GEO_obj_28", ATT)	
		ShowMessageText("game.objectives.complete", ATT)
		DeleteAIGoal(att_obj10_aigoal)
		DeleteAIGoal(def_obj10_aigoal)
		
	end
	
	--objective 11a
	Objective11a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.11a", popupText = "level.geo1.objectives.campaign.11a_popup"}
	Objective11a.OnStart = function(self)
	
		
		obj5_spider1_dmgthreshold = OnObjectInitName(
			function()
				print("set obj5 spider2 damage threshold")
				SetAIDamageThreshold("cp5spider2", 0.2)
			end,
			"cp5spider2"
			) 
		obj5_spider2_dmgthreshold = OnObjectInitName(
			function()
				print("set obj5 spider5 damage threshold")
				SetAIDamageThreshold("cp5spider5", 0.2)
			end,
			"cp5spider5"
			)
		SetAIDamageThreshold("cp5spider2", 0.2)
		SetAIDamageThreshold("cp5spider5", 0.2)
		
		AddUnitClass(1, "rep_inf_ep2_rocketeer", 3)
		att_obj11_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj11_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		player_selected_heavy = OnCharacterChangeClass(
			function(player)
				if IsCharacterHuman(player) and GetCharacterClass(player) == 4 then
					ReleaseCharacterChangeClass(player_selected_heavy)
					Objective11a:Complete(ATT)
				end
			end
			)
	end
	
	Objective11a.OnComplete = function(self)
		BroadcastVoiceOver("GEO_obj_70", ATT)
	end
	--objective 11
	
	Spider = TargetType:New{classname = "cis_walk_spider", killLimit = 1, weapon = "rep_weap_inf_rocket_launcher", killedByPlayer = true, icon = "hud_target_hint_onscreen"}
	
	Objective11 = ObjectiveAssault:New{teamATT = ATT, teamDEF = DEF, 
							  text = "level.geo1.objectives.campaign.11", popupText = "level.geo1.objectives.campaign.11_popup",  AIGoalWeight = 0}
	Objective11:AddTarget(Spider)
	
	Objective11:AddHint("level.geo1.hints.crit_hit")
	Objective11:AddHint("level.geo1.hints.heavy_lock")
	
	Objective11.OnStart = function(self)
		
		
		
		
		
	end
	
	Objective11.OnComplete = function(self)
		DeleteAIGoal(att_obj11_aigoal)
		DeleteAIGoal(def_obj11_aigoal)
		BroadcastVoiceOver("GEO_obj_49", ATT)
		ScriptCB_PlayInGameMusic("rep_geo_objComplete_03")
		 -- Music Timer -- 
		 music03Timer = CreateTimer("music03")
		SetTimerValue(music03Timer, 19.0)
				              
			StartTimer(music03Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("rep_geo_objComplete_03")
				ScriptCB_PlayInGameMusic("rep_geo_amb_act_02")
				DestroyTimer(timer)
			end,
			music03Timer
                        ) 		
		ShowMessageText("game.objectives.complete", ATT)
		
		ReleaseObjectInit(obj5_spider1_dmgthreshold)
		ReleaseObjectInit(obj5_spider2_dmgthreshold)
		SetAIDamageThreshold("cp5spider2", 0.2)
		SetAIDamageThreshold("cp5spider5", 0.2)
	end
	
	
	--Objective12a get into the ATTE
	Objective12a = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.12a", popupText = "level.geo1.objectives.campaign.12a_popup"}
	
	Objective12a.OnStart = function(self)
		
		
		Objective12a:AddHint("level.geo1.hints.enter_vehicle")
		BroadcastVoiceOver("GEO_obj_61", ATT)
		att_obj12_aigoal = AddAIGoal(ATT, "Deathmatch", 100)
		def_obj12_aigoal = AddAIGoal(DEF, "Deathmatch", 100)
		
		obj12_spider1_dmgthreshold = OnObjectInitName(
			function()
				print("set damage threshold for spider2")
				SetAIDamageThreshold("cp5spider2", 0.2)
			end,
			"cp5spider2"
			) 
		obj12_spider2_dmgthreshold = OnObjectInitName(
			function()
				SetAIDamageThreshold("cp5spider5", 0.2)
				print("set damage threshold for spider5")
			end,
			"cp5spider5"
			)
		
		MapAddEntityMarker("ATTE2", "hud_objective_icon_circle", 4.0, ATT, "YELLOW", true)
		SetProperty("ATTE2", "MaxHealth", 1e+37)
		SetProperty("ATTE2", "CurHealth", 1e+37)
				
			
		atte_entered = OnCharacterEnterVehicle(
			 function (player, vehicle)
			 	if IsCharacterHuman(player) and string.lower(GetEntityName(vehicle)) == "atte2" then
			 		ReleaseCharacterEnterVehicle(atte_entered)
			 		Objective12a:Complete(ATT)
			 	end
			 end
			 )

	end
	
	Objective12a.OnComplete = function(self)
		MapRemoveEntityMarker("ATTE2")
		BroadcastVoiceOver("GEO_obj_63", ATT)
	end
	--Objective 12
		
	Objective12 = Objective:New{teamATT = ATT, teamDEF = DEF, text = "level.geo1.objectives.campaign.12", popupText = "level.geo1.objectives.campaign.12_popup",  AIGoalWeight = 0}
	
	Objective12:AddHint("level.geo1.hints.vehicle_changeweapon")
	
	
	Objective12.OnStart = function(self)
		
		--ScriptCB_PlayInGameMovie("ingame.mvs", "geo1cam1")
		
		
		
				
		
		
		SetAIDamageThreshold("cp5spider2", 0)
		SetAIDamageThreshold("cp5spider5", 0)
		MapAddClassMarker("cis_walk_spider", "hud_target_hint_onscreen", 3.0, ATT, "YELLOW", true)
		
		Objective12SpiderKill = OnObjectKillClass( 
			function(object, killer)
				if killer and IsCharacterHuman(killer) then
					if GetObjectLastHitWeaponClass(object) == "rep_weap_walk_atte_laser" then
						Objective12:Complete(ATT) 
					   ReleaseObjectKill(Objective12SpiderKill)
					elseif GetObjectLastHitWeaponClass(object) == "rep_weap_walk_atte_recoilless" then
					   Objective12:Complete(ATT) 
					   ReleaseObjectKill(Objective12SpiderKill) 
					elseif GetObjectLastHitWeaponClass(object) == "rep_weap_walk_atte_turret_cannon" then
					   Objective12:Complete(ATT) 
					   ReleaseObjectKill(Objective12SpiderKill)
					elseif GetObjectLastHitWeaponClass(object) == "rep_weap_walk_atte_rear_gun" then
					   Objective12:Complete(ATT) 
					   ReleaseObjectKill(Objective12SpiderKill)
					end 
				end 
			end,
			"cis_walk_spider"
		) 
                 
	end

	Objective12.OnComplete = function(self)
		Holocron1Spawn = GetPathPoint("holocron_spawn", 0) --gets the path point
        CreateEntity("com_item_holocron", Holocron1Spawn, "holocron") --spawns the flag
		ReleaseObjectInit(obj12_spider1_dmgthreshold)
		ReleaseObjectInit(obj12_spider2_dmgthreshold)
		SetAIDamageThreshold("cp5spider2", 0)
		SetAIDamageThreshold("cp5spider5", 0)
		BroadcastVoiceOver("GEO_obj_66", ATT)
		ScriptCB_PlayInGameMusic("rep_geo_objComplete_01")
		 -- Music Timer -- 
		 music01Timer = CreateTimer("music01")
		SetTimerValue(music01Timer, 15.0)
				              
			StartTimer(music01Timer)
			OnTimerElapse(
				function(timer)
				ScriptCB_StopInGameMusic("rep_geo_objComplete_01")
				ScriptCB_PlayInGameMusic("rep_geo_amb_obj4_9_explore")
				DestroyTimer(timer)
			end,
			music01Timer
                        ) 		
	 	ShowMessageText("game.objectives.complete", ATT)
		MapRemoveClassMarker("cis_walk_spider")
		DeleteAIGoal(att_obj12_aigoal)
		DeleteAIGoal(def_obj12_aigoal)
	end

	
----------------------------------------
--**************************************
--*********Hint Stuff*******************
--**************************************
----------------------------------------       
    
    
    
end

function BeginObjectivesTimer()
	beginobjectivestimer = CreateTimer("beginobjectivestimer")
	OnTimerElapse(BeginObjectives, beginobjectivestimer)
	SetTimerValue(beginobjectivestimer, 12)
	StartTimer(beginobjectivestimer)
end

function BeginObjectives()
	objectiveSequence = MultiObjectiveContainer:New{delayVictoryTime = 4}
	objectiveSequence:AddObjectiveSet(Objective1)
	objectiveSequence:AddObjectiveSet(Objective2a)
	objectiveSequence:AddObjectiveSet(Objective2b)
	objectiveSequence:AddObjectiveSet(Objective2)
	--objectiveSequence:AddObjectiveSet(Objective3)
	objectiveSequence:AddObjectiveSet(Objective6a)
	objectiveSequence:AddObjectiveSet(Objective6)
	objectiveSequence:AddObjectiveSet(Objective12a)
	objectiveSequence:AddObjectiveSet(Objective12)
	objectiveSequence:AddObjectiveSet(Objective10a)
	objectiveSequence:AddObjectiveSet(Objective10)
	objectiveSequence:AddObjectiveSet(Objective8)
	objectiveSequence:AddObjectiveSet(Objective9a)	
	objectiveSequence:AddObjectiveSet(Objective9)	
	objectiveSequence:AddObjectiveSet(Objective11a)
	objectiveSequence:AddObjectiveSet(Objective11)
	objectiveSequence:AddObjectiveSet(Objective21)
	objectiveSequence:AddObjectiveSet(Objective4)
	--objectiveSequence:AddObjectiveSet(Objective5)
	
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
    StealArtistHeap(256 * 1024)
    SetPS2ModelMemory(3500000)
    ReadDataFile("ingame.lvl")
    
    

    

    SetTeamAggressiveness(CIS, 1.0)
    SetTeamAggressiveness(REP, 1.0)

    ReadDataFile("sound\\geo.lvl;geo1cw")
    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_bldg_forwardcenter",
                             "rep_fly_assault_dome",
                             --"rep_fly_gunship",
                             "rep_fly_gunship_dome",
                             "rep_fly_jedifighter_dome",
                           	 "rep_inf_ep2_rocketeer",
                             "rep_inf_ep2_rifleman",
                             "rep_inf_ep2_jettrooper_training",
                             "rep_inf_ep2_sniper",
                             "rep_inf_ep2_officer_training",
                             "rep_inf_ep2_engineer",
                             "rep_hero_macewindu",
                             "rep_walk_atte")
                             
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_fly_droidfighter_dome",
                             --"cis_fly_geofighter",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_pilot",
                             "cis_inf_sniper",
                             --"cis_hero_jangofett",
                             --"cis_inf_droideka",
                             "cis_tread_hailfire",
                             "cis_hover_stap",
                             "cis_walk_spider")
    ReadDataFile("SIDE\\geo.lvl",
                             "gen_inf_geonosian")
	
	ReadDataFile("SIDE\\tur.lvl",
                             "tur_bldg_laser",
                             "tur_bldg_geoturret")                       
                             
    ScriptCB_SetSpawnDisplayGain(0.2, 0.5)                         

    --  Level Stats

    ClearWalkers()
    SetMemoryPoolSize("EntityWalker", -1)
    --AddWalkerType(0, 3) -- 8 droidekas (special case: 0 leg pairs)
    AddWalkerType(2, 2) -- 2 spider walkers with 2 leg pairs each
    AddWalkerType(3, 1) -- 2 attes with 3 leg pairs each
    local weaponCnt = 300
    SetMemoryPoolSize("Aimer", 70)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 200)
    SetMemoryPoolSize("CommandWalker", 1)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("EntityHover", 6)
    SetMemoryPoolSize("EntityLight", 36)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 12)
	SetMemoryPoolSize("Music", 34)
    SetMemoryPoolSize("Obstacle", 410)
    SetMemoryPoolSize("PathNode", 100)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    
    SetSpawnDelay(10.0, 0.25)


    SetupTeams{
             
        rep = {
            team = REP,
            units = 23,
            reinforcements = -1,
            soldier  = { "rep_inf_ep2_rifleman",1},
            --assault  = { "rep_inf_ep2_rocketeer",4},
            --engineer = { "rep_inf_ep2_engineer",3},
            --sniper   = { "rep_inf_ep2_sniper",2},
            --officer = {"rep_inf_ep2_officer_training",2},
            --special = { "rep_inf_ep2_jettrooper_training",3},
            
        },
        cis = {
            team = CIS,
            units = 25,
            reinforcements = -1,
           	soldier  = { "cis_inf_rifleman",11},
            assault  = { "cis_inf_rocketeer",4},
            engineer = { "cis_inf_engineer",3},
            sniper   = { "cis_inf_sniper",4},
            officer = {"cis_inf_officer",2},
            --special = { "cis_inf_droideka",3},
        }
     }
     
     
        
    SetTeamAsEnemy(ATT,3)    
    SetTeamAsEnemy(3,ATT)
    SetTeamAsFriend(DEF,3)

    --  Local Stats
    SetTeamName(3, "locals")
    AddUnitClass(3, "geo_inf_geonosian", 4)
    SetUnitCount(3, 4)
    SetTeamAsFriend(3, DEF)
    SetReinforcementCount(3, -1)
    
    --Setup scout ambush team
    
    AddUnitClass(4, "cis_inf_rifleman", 4)
    SetUnitCount(4, 4)
    SetTeamAsEnemy(4, ATT)
    SetTeamAsEnemy(ATT, 4)
    
--    SetUnitCount(5, 11)
--    AddUnitClass(5, "rep_inf_ep2_rifleman", 11)
    
--    SetUnitCount(6, 3)
--    AddUnitClass(6, "rep_inf_ep2_engineer", 3)
    

    ReadDataFile("GEO\\geo1.lvl", "geo1_campaign")

    SetDenseEnvironment("false")
    SetMinFlyHeight(-65)
    SetMaxFlyHeight(50)
    SetMaxPlayerFlyHeight(50)



    --  Birdies
    --SetNumBirdTypes(1)
    --SetBirdType(0.0,10.0,"dragon")
    --SetBirdFlockMinHeight(90.0)

    --  Sound
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "geo_objective_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)     
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "cis_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "rep_unit_vo_quick", voiceQuick)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\geo.lvl",  "geo_objective_vo_slow")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")
    OpenAudioStream("sound\\geo.lvl",  "geo1cw")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "repleaving")
    SetOutOfBoundsVoiceOver(2, "cisleaving")

    -- SetAmbientMusic(REP, 1.0, "rep_GEO_amb_start",  0,1)
    -- SetAmbientMusic(REP, 0.99, "rep_GEO_amb_middle", 1,1)
    -- SetAmbientMusic(REP, 0.1,"rep_GEO_amb_end",    2,1)
    -- SetAmbientMusic(CIS, 1.0, "cis_GEO_amb_start",  0,1)
    -- SetAmbientMusic(CIS, 0.99, "cis_GEO_amb_middle", 1,1)
    -- SetAmbientMusic(CIS, 0.1,"cis_GEO_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_geo_amb_victory")
    SetDefeatMusic (REP, "rep_geo_amb_defeat")
    SetVictoryMusic(CIS, "cis_geo_amb_victory")
    SetDefeatMusic (CIS, "cis_geo_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    --ActivateBonus(CIS, "SNEAK_ATTACK")
    --ActivateBonus(REP, "SNEAK_ATTACK")

    SetAttackingTeam(ATT)

    --Opening Satalite Shot
    --Geo
    --Mountain
    AddCameraShot(0.996091, 0.085528, -0.022005, 0.001889, -6.942698, -59.197201, 26.136919)
    --Wrecked Ship
    AddCameraShot(0.906778, 0.081875, -0.411906, 0.037192, 26.373968, -59.937874, 122.553581)
    --War Room  
    --AddCameraShot(0.994219, 0.074374, 0.077228, -0.005777, 90.939568, -49.293945, -69.571136)
end

