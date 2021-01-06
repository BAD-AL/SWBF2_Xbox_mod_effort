--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
-- SPA8 - Hoth
--
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("spa8g_cmn")

ScriptCB_DoFile("ObjectiveSpaceAssault")
ScriptCB_DoFile("LinkedShields")
ScriptCB_DoFile("LinkedDestroyables")

myGameMode = "spa8_ass"
    
function ScriptPostLoad()
	SetupObjectives()
    
    SetupShields()
    SetupDestroyables()
    SetupTurrets()
	
	AddAIGoal(ALL, "Deathmatch", 100)
    AddAIGoal(IMP, "Deathmatch", 100)
	
	-- cleanup
	LockHangarWarsDoors(false)
	SetupFrigDeathAnims()
	AddDeathRegion('deathregionall')
	AddDeathRegion('deathregionimp')
	
	-- disable 1 flag paths that are being loaded
--~ 	EnableFlyerPath( 'pickup', 0 )
--~ 	EnableFlyerPath( 'capture', 0 )

	DisableSmallMapMiniMap()
end

function SetupObjectives()
	assault = ObjectiveSpaceAssault:New{
		teamATT = IMP, teamDEF = ALL, 
		multiplayerRules = true
	}
	
	local impTargets = {
		engines		= {"all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6"},
		lifesupport	= "all_cap1_life_ext",
		bridge		= "all_cap1_bridge",
		comm		= "all_cap1_comms",
		sensors		= "all_cap1_sensor",
		frigates	= { "all_frig1", "all_frig3" },
		internalSys	= { "all_cap1_life_int", "all_cap1_engines_int" },
	}
	
	local allTargets = {
		engines		= { "imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3" },
		lifesupport	= "imp_cap1_life_ext",
		bridge		= "imp_cap1_bridge",
		comm		= "imp_cap1_comms",
		sensors		= "imp_cap1_sensor",
		frigates	= { "imp_frig1", "imp_frig3" },
		internalSys	= { "imp_cap1_life_int", "imp_cap1_engines_int" },
	}
	
	assault:SetupAllCriticalSystems( "imp", impTargets, true )
	assault:SetupAllCriticalSystems( "all", allTargets, false )
	
	assault:Start()
end

function SetupShields()
    -- ALL Shielded objects    
    local linkedShieldObjectsALL = { "all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6",
		"all_cap1_life_ext", "all_cap1_sensor", "all_cap1_comms", "all_cap1_bridge", "all_cap1_body", "all_cap1_body2" }
    shieldStuffALL = LinkedShields:New{objs = linkedShieldObjectsALL, controllerObject = "all_cap1_shield_int"}
    shieldStuffALL:Init()
    
    function shieldStuffALL:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", IMP)
        ShowMessageText("level.spa.hangar.shields.def.down", ALL)
		
		BroadcastVoiceOver( "IOSMP_obj_16", IMP )
		BroadcastVoiceOver( "AOSMP_obj_17", ALL )
    end
    function shieldStuffALL:OnAllShieldsUp() 
        ShowMessageText("level.spa.hangar.shields.atk.up", IMP)
        ShowMessageText("level.spa.hangar.shields.def.up", ALL)
		
		BroadcastVoiceOver( "IOSMP_obj_18", IMP )
		BroadcastVoiceOver( "AOSMP_obj_19", ALL )
    end
    
    -- IMP Shielded objects    
    local linkedShieldObjectsIMP = { "imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3",
		"imp_cap1_life_ext", "imp_cap1_sensor", "imp_cap1_comms", "imp_cap1_bridge",
		"imp_cap1_body1", "imp_cap1_body2", "imp_cap1_body3", "imp_cap1_body4",
		}
    shieldStuffIMP = LinkedShields:New{objs = linkedShieldObjectsIMP, controllerObject = "imp_cap1_shield_int"}    
    shieldStuffIMP:Init()
    
    function shieldStuffIMP:OnAllShieldsDown() 
        ShowMessageText("level.spa.hangar.shields.atk.down", ALL)
        ShowMessageText("level.spa.hangar.shields.def.down", IMP)
		
		BroadcastVoiceOver( "IOSMP_obj_17", IMP )
		BroadcastVoiceOver( "AOSMP_obj_16", ALL )
    end
	function shieldStuffIMP:OnAllShieldsUp() 
        ShowMessageText("level.spa.hangar.shields.atk.up", ALL)
        ShowMessageText("level.spa.hangar.shields.def.up", IMP)
		
		BroadcastVoiceOver( "IOSMP_obj_19", IMP )
		BroadcastVoiceOver( "AOSMP_obj_18", ALL )
    end
end


function SetupDestroyables()
    --ALL destroyables
    lifeSupportLinkageALL = LinkedDestroyables:New{ objectSets = {{"all_cap1_life_int"}, {"all_cap1_life_ext"}} }
    lifeSupportLinkageALL:Init()
        
    engineLinkageALL = LinkedDestroyables:New{ objectSets = {
		{"all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6"}, {"all_cap1_engines_int"}} }
    engineLinkageALL:Init()
    
    --IMP destroyables
    lifeSupportLinkageIMP = LinkedDestroyables:New{ objectSets = {{"imp_cap1_life_int"}, {"imp_cap1_life_ext"}} }
    lifeSupportLinkageIMP:Init()    
    
    engineLinkageIMP = LinkedDestroyables:New{ objectSets = {{"imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3"}, {"imp_cap1_engines_int"}} }
    engineLinkageIMP:Init()
end
