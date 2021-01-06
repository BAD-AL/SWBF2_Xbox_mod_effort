--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA7 - Felucia
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("spa7c_cmn")

ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")

myGameMode = "spa7_obj"

function myScriptInit()
	SetMemoryPoolSize("CommandFlyer", 4)
end	
    
function ScriptPostLoad()
    SetupObjectives()
    
    SetupShields()
    SetupDestroyables()
    SetupTurrets()

    AddAIGoal(REP, "Deathmatch", 100)
    AddAIGoal(CIS, "Deathmatch", 100)	
	
	-- cleanup
	LockHangarWarsDoors( false )
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
		engines		= { "cis_engine1", "cis_engine2" },
		lifesupport	= "life_ext_cis",
		bridge		= "cis_fedcruiser_bridge",
		comm		= "comms_cis",
		sensors		= "cis_cruiser_sensor2",
		frigates	= { "cis_frig1", "cis_frig2" },
		internalSys	= { "life_int_cis", "engine_cis" },
	}
	
	local cisTargets = {
		engines		= "rep_engine1",
		lifesupport	= "life_ext_rep",
		bridge		= "rep_bridge",
		comm		= "comms_rep",
		sensors		= "rep_assault_sensor2",
		frigates	= { "rep_frig1", "rep_frig2" },
		internalSys	= { "life_int_rep", "engine_rep" },
	}
	
	assault:SetupAllCriticalSystems( "rep", repTargets, true )
	assault:SetupAllCriticalSystems( "cis", cisTargets, false )
	
	assault:Start()
end

function SetupShields()
    -- CIS Shielded objects    
    local linkedShieldObjectsCIS = { "cis_engine1", "cis_engine2", "life_ext_cis", "cis_cruiser_sensor2", "comms_cis", "cis_fedcruiser_bridge", 
		"cis_fly_fedcruiser0", "cis_fly_fedcruiser2", "cis_fly_fedcruiser3", "cis_fly_fedcruiser4" }
    shieldStuffCIS = LinkedShields:New{objs = linkedShieldObjectsCIS, controllerObject = "shieldgenCIS"}
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
    local linkedShieldObjectsREP = { "rep_engine1", "life_ext_rep", "rep_assault_sensor2", "comms_rep", "rep_bridge",
		"rep_cap_assultship0", "rep_cap_assultship2", "rep_cap_assultship3", "rep_cap_assultship4", }
    shieldStuffREP = LinkedShields:New{objs = linkedShieldObjectsREP, controllerObject = "shieldgenREP"}    
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
    lifeSupportLinkageCIS = LinkedDestroyables:New{ objectSets = {{"life_int_cis"}, {"life_ext_cis"}} }
    lifeSupportLinkageCIS:Init()
        
    engineLinkageCIS = LinkedDestroyables:New{ objectSets = {{"cis_engine1", "cis_engine2"}, {"engine_cis"}} }
    engineLinkageCIS:Init()
    
    --REP destroyables
    lifeSupportLinkageREP = LinkedDestroyables:New{ objectSets = {{"life_int_rep"}, {"life_ext_rep"}} }
    lifeSupportLinkageREP:Init()    
    
    engineLinkageREP = LinkedDestroyables:New{ objectSets = {{"rep_engine1"}, {"engine_rep"}} }
    engineLinkageREP:Init()
end
