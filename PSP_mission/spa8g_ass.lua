--Extracted\spa8g_ass.lua
-- Decompiled with SWBF2CodeHelper
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
    AddAIGoal(ALL,"Deathmatch",100)
    AddAIGoal(IMP,"Deathmatch",100)
    LockHangarWarsDoors(false)
    SetupFrigDeathAnims()
    AddDeathRegion("deathregionall")
    AddDeathRegion("deathregionimp")
end

function SetupObjectives()
    assault = ObjectiveSpaceAssault:New({ teamATT = IMP, teamDEF = ALL, multiplayerRules = true })
    assault:SetupAllCriticalSystems("imp",{ 
        engines =         { "all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6" }, lifesupport = "all_cap1_life_ext", bridge = "all_cap1_bridge", comm = "all_cap1_comms", sensors = "all_cap1_sensor", 
        frigates =         { "all_frig1", "all_frig3" }, 
        internalSys =         { "all_cap1_life_int", "all_cap1_engines_int" }
       },true)
    assault:SetupAllCriticalSystems("all",{ 
        engines =         { "imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3" }, lifesupport = "imp_cap1_life_ext", bridge = "imp_cap1_bridge", comm = "imp_cap1_comms", sensors = "imp_cap1_sensor", 
        frigates =         { "imp_frig1", "imp_frig3" }, 
        internalSys =         { "imp_cap1_life_int", "imp_cap1_engines_int" }
       },false)
    assault:Start()
end

function SetupShields()
    shieldStuffALL = LinkedShields:New({ 
        objs =         { "all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6", "all_cap1_life_ext", "all_cap1_sensor", "all_cap1_comms", "all_cap1_bridge", "all_cap1_body", "all_cap1_body2" }, controllerObject = "all_cap1_shield_int"
       })
    shieldStuffALL:Init()
    shieldStuffIMP = LinkedShields:New({ 
        objs =         { "imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3", "imp_cap1_life_ext", "imp_cap1_sensor", "imp_cap1_comms", "imp_cap1_bridge", "imp_cap1_body1", "imp_cap1_body2", "imp_cap1_body3", "imp_cap1_body4" }, controllerObject = "imp_cap1_shield_int"
       })
    shieldStuffIMP:Init()
end

function SetupDestroyables()
    lifeSupportLinkageALL = LinkedDestroyables:New({ 
        objectSets =         {           { "all_cap1_life_int" },           { "all_cap1_life_ext" } }
       })
    lifeSupportLinkageALL:Init()
    engineLinkageALL = LinkedDestroyables:New({ 
        objectSets =         {           { "all_cap1_engine1", "all_cap1_engine2", "all_cap1_engine3", "all_cap1_engine4", "all_cap1_engine5", "all_cap1_engine6" },           { "all_cap1_engines_int" } }
       })
    engineLinkageALL:Init()
    lifeSupportLinkageIMP = LinkedDestroyables:New({ 
        objectSets =         {           { "imp_cap1_life_int" },           { "imp_cap1_life_ext" } }
       })
    lifeSupportLinkageIMP:Init()
    engineLinkageIMP = LinkedDestroyables:New({ 
        objectSets =         {           { "imp_cap1_engine1", "imp_cap1_engine2", "imp_cap1_engine3" },           { "imp_cap1_engines_int" } }
       })
    engineLinkageIMP:Init()
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",IMP)
    ShowMessageText("level.spa.hangar.shields.def.down",ALL)
    BroadcastVoiceOver("IOSMP_obj_16",IMP)
    BroadcastVoiceOver("AOSMP_obj_17",ALL)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    ShowMessageText("level.spa.hangar.shields.atk.up",IMP)
    ShowMessageText("level.spa.hangar.shields.def.up",ALL)
    BroadcastVoiceOver("IOSMP_obj_18",IMP)
    BroadcastVoiceOver("AOSMP_obj_19",ALL)
end

function OnAllShieldsDown(OnAllShieldsDownParam0)
    ShowMessageText("level.spa.hangar.shields.atk.down",ALL)
    ShowMessageText("level.spa.hangar.shields.def.down",IMP)
    BroadcastVoiceOver("IOSMP_obj_17",IMP)
    BroadcastVoiceOver("AOSMP_obj_16",ALL)
end

function OnAllShieldsUp(OnAllShieldsUpParam0)
    ShowMessageText("level.spa.hangar.shields.atk.up",IMP)
    ShowMessageText("level.spa.hangar.shields.def.up",ALL)
    BroadcastVoiceOver("IOSMP_obj_19",IMP)
    BroadcastVoiceOver("AOSMP_obj_18",ALL)
end

