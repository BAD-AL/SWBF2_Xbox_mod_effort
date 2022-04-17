--Extracted\end1g_hunt.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("ObjectiveTDM")
IMP = 1
ALL = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    hunt = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 2, textATT = "level.end1.objectives.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true })
    hunt:Start()
    AddAIGoal(ATT,"Deathmatch",1000)
    AddAIGoal(DEF,"Deathmatch",1000)
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(944637)
        SetPSPClipper(0)
else
        SetPS2ModelMemory(2860000)
end
    ReadDataFile("ingame.lvl")
    ReadDataFile("sound\\end.lvl;end1gcw")
    SetTeamAggressiveness(ALL,1)
    SetTeamAggressiveness(IMP,0.69999998807907)
    SetMaxFlyHeight(43)
    SetMaxPlayerFlyHeight(43)
    ReadDataFile("SIDE\\imp.lvl","imp_inf_sniper")
    ReadDataFile("SIDE\\ewk.lvl","ewk_inf_basic")
    SetUnitCount(ATT,12)
    SetReinforcementCount(ATT,-1)
    SetUnitCount(DEF,24)
    SetReinforcementCount(DEF,-1)
    SetTeamName(ALL,"Ewoks")
    SetTeamIcon(ALL,"all_icon")
    AddUnitClass(ALL,"ewk_inf_trooper",12)
    AddUnitClass(ALL,"ewk_inf_scout",12)
    SetTeamName(IMP,"Empire")
    SetTeamIcon(IMP,"imp_icon")
    AddUnitClass(IMP,"imp_inf_sniper",22)
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,3)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("ActiveRegion",4)
    SetMemoryPoolSize("Aimer",24)
    SetMemoryPoolSize("AmmoCounter",211)
    SetMemoryPoolSize("BaseHint",225)
    SetMemoryPoolSize("EnergyBar",211)
    SetMemoryPoolSize("EntityHover",9)
    SetMemoryPoolSize("EntityLight",20)
    SetMemoryPoolSize("EntitySoundStream",4)
    SetMemoryPoolSize("EntitySoundStatic",95)
    SetMemoryPoolSize("MountedTurret",3)
    SetMemoryPoolSize("Navigator",59)
    SetMemoryPoolSize("Obstacle",745)
    SetMemoryPoolSize("PathFollower",59)
    SetMemoryPoolSize("PathNode",100)
    SetMemoryPoolSize("SoundSpaceRegion",6)
    SetMemoryPoolSize("TreeGridStack",587)
    SetMemoryPoolSize("UnitAgent",59)
    SetMemoryPoolSize("UnitController",59)
    SetMemoryPoolSize("Weapon",211)
    SetSpawnDelay(10,0.25)
    ReadDataFile("end\\end1.lvl","end1_hunt")
    SetDenseEnvironment("true")
    AddDeathRegion("deathregion")
    SetStayInTurrets(1)
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_end_amb_hunt",0,1)
    SetAmbientMusic(IMP,1,"imp_end_amb_hunt",0,1)
    SetVictoryMusic(ALL,"all_end_amb_victory")
    SetDefeatMusic(ALL,"all_end_amb_defeat")
    SetVictoryMusic(IMP,"imp_end_amb_victory")
    SetDefeatMusic(IMP,"imp_end_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.99765402078629,0.066982001066208,0.014139000326395,-0.00094900000840425,155.1371307373,0.91150498390198,-138.07707214355)
    AddCameraShot(0.72976100444794,0.019262000918388,0.68319398164749,-0.018032999709249,-98.584869384766,0.29528400301933,263.23928833008)
    AddCameraShot(0.69427698850632,0.0051000001840293,0.71967101097107,-0.0052869999781251,-11.105946540833,-2.7532069683075,67.982200622559)
end
