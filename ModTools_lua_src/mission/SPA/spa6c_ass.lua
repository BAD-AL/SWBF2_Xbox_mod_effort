--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA6 - Mygeeto
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("spa6c_cmn")

ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")

myGameMode = "spa6_obj"
    
function ScriptPostLoad()
	SetupObjectives()
    
    SetupShields()
    SetupDestroyables()
    SetupTurrets()
	
    AddAIGoal(REP, "Deathmatch", 100)
    AddAIGoal(CIS, "Deathmatch", 100)	
	
	LockHangarWarsDoors(false)
	SetupFrigateDeaths()
	AddDeathRegion('deathregionCIS')
	AddDeathRegion('deathregionRep')
	
	DisableSmallMapMiniMap()
end

function SetupObjectives()
	assault = ObjectiveSpaceAssault:New{
		teamATT = REP, teamDEF = CIS, 
		multiplayerRules = true
	}
	
	local repTargets = {
		engines		= { "cis_cap1_engine1", "cis_cap1_engine2" },
		lifesupport	= "cis_cap1_life_ext",
		bridge		= "cis_cap1_bridge",
		comm		= "cis_cap1_comms",
		sensors		= "cis_cap1_sensor2",
		frigates	= { "cis_frig1", "cis_frig2", "cis_frig3" },
		internalSys	= { "cis_cap1_life_int", "cis_cap1_engine_int" },
	}
	
	local cisTargets = {
		engines		= "rep_cap2_engine",
		lifesupport	= "rep_cap2_life_ext", 
		bridge		= "rep_cap2_bridge", 
		comm		= "rep_cap2_comms", 
		sensors		= "rep_cap2_sensor2", 
		frigates	= { "rep_frig1", "rep_frig2", "rep_frig3", },
		internalSys	= { "rep_cap2_life_int", "rep_cap2_engine_int", },
	}
	
	assault:SetupAllCriticalSystems( "rep", repTargets, true )
	assault:SetupAllCriticalSystems( "cis", cisTargets, false )
	
	assault:Start()
end

function SetupShields()
    -- CIS Shielded objects
    shieldStuffCIS = LinkedShields:New{
		objs = { "cis_cap1_engine1", "cis_cap1_engine2", "cis_cap1_life_ext", "cis_cap1_sensor2", "cis_cap1_comms", "cis_cap1_bridge", 
				"cis_cap1_body1", "cis_cap1_body2", "cis_cap1_body3", "cis_cap1_body4" },
		controllerObject = "cis_cap1_shieldgen"}
    shieldStuffCIS:Init()
    
    function shieldStuffCIS:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", REP)
        ShowMessageText("level.spa.hangar.shields.def.down", CIS)
		
		BroadcastVoiceOver( "ROSMP_obj_16", REP )
		BroadcastVoiceOver( "COSMP_obj_17", CIS )
    end
    function shieldStuffCIS:OnAllShieldsUp() 
        ShowMessageText("level.spa.hangar.shields.atk.up", REP)
        ShowMessageText("level.spa.hangar.shields.def.up", CIS)
		
		BroadcastVoiceOver( "ROSMP_obj_18", REP )
		BroadcastVoiceOver( "COSMP_obj_19", CIS )
    end
    
    -- REP Shielded objects    
    shieldStuffREP = LinkedShields:New{
		-- add body
		objs = { "rep_cap2_engine", "rep_cap2_life_ext", "rep_cap2_sensor2", "rep_cap2_bridge",
			"rep_cap_body1", "rep_cap_body2", "rep_cap_body3", "rep_cap_body4"
		},
		controllerObject = "rep_cap2_shieldgen"}    
    shieldStuffREP:Init()
    
    function shieldStuffREP:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", CIS)
        ShowMessageText("level.spa.hangar.shields.def.down", REP)
		
		BroadcastVoiceOver( "ROSMP_obj_17", REP )
		BroadcastVoiceOver( "COSMP_obj_16", CIS )
    end
	function shieldStuffREP:OnAllShieldsUp() 
        ShowMessageText("level.spa.hangar.shields.atk.up", CIS)
        ShowMessageText("level.spa.hangar.shields.def.up", REP)
		
		BroadcastVoiceOver( "ROSMP_obj_19", REP )
		BroadcastVoiceOver( "COSMP_obj_18", CIS )
    end
end


function SetupDestroyables()
    --CIS destroyables
    lifeSupportLinkageCIS = LinkedDestroyables:New{ objectSets = {{"cis_cap1_life_int"}, {"cis_cap1_life_ext"}} }
    lifeSupportLinkageCIS:Init()
        
    engineLinkageCIS = LinkedDestroyables:New{ objectSets = {{"cis_cap1_engine1", "cis_cap1_engine2"}, {"cis_cap1_engine_int"}} }
    engineLinkageCIS:Init()
    
    --REP destroyables
    lifeSupportLinkageREP = LinkedDestroyables:New{ objectSets = {{"rep_cap2_life_int"}, {"rep_cap2_life_ext"}} }
    lifeSupportLinkageREP:Init()    
    
    engineLinkageREP = LinkedDestroyables:New{ objectSets = {{"rep_cap2_engine"}, {"rep_cap2_engine_int"}} }
    engineLinkageREP:Init()
end
