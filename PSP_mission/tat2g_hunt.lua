--Extracted\tat2g_hunt.lua
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveTDM")
ALL = 2
IMP = 1
ATT = 1
DEF = 2

function ScriptPostLoad()
    hunt = ObjectiveTDM:New({ teamATT = 1, teamDEF = 2, pointsPerKillATT = 1, pointsPerKillDEF = 1, textATT = "game.modes.hunt", textDEF = "game.modes.hunt2", multiplayerRules = true })
    hunt:Start()
end

function ScriptInit()
if ScriptCB_GetPlatform() == "PSP" then
        SetPSPModelMemory(1265681)
        SetPSPClipper(1)
else
        SetPS2ModelMemory(2097152 + 65536 * 10)
end
    ReadDataFile("ingame.lvl")
    AddMissionObjective(IMP,"red","game.modes.tdm")
    AddMissionObjective(ALL,"green","lgame.modes.tdm")
    SetMaxFlyHeight(40)
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("SIDE\\des.lvl","tat_inf_jawa","tat_inf_tuskenraider","tat_inf_tuskenhunter")
    SetTeamName(1,"Tuskens")
    AddUnitClass(1,"tat_inf_tuskenhunter",2,6)
    AddUnitClass(1,"tat_inf_tuskenraider",2,6)
    SetUnitCount(1,12)
    SetTeamAsEnemy(ATT,DEF)
    SetReinforcementCount(1,-1)
    SetTeamName(2,"Jawas")
    AddUnitClass(2,"tat_inf_jawa",25)
    SetUnitCount(2,25)
    SetTeamAsEnemy(DEF,ATT)
    SetReinforcementCount(2,-1)
    ClearWalkers()
    AddWalkerType(0,0)
    AddWalkerType(1,0)
    AddWalkerType(2,0)
    AddWalkerType(3,0)
    SetMemoryPoolSize("Aimer",14)
    SetMemoryPoolSize("Obstacle",664)
    SetMemoryPoolSize("PathNode",384)
    SetMemoryPoolSize("TreeGridStack",500)
    SetSpawnDelay(10,0.25)
    ReadDataFile("TAT\\tat2.lvl","tat2_hunt")
    SetDenseEnvironment("false")
    OpenAudioStream("sound\\global.lvl","gcw_music")
    SetAmbientMusic(ALL,1,"all_tat_amb_hunt",0,1)
    SetAmbientMusic(IMP,1,"imp_tat_amb_hunt",0,1)
    SetVictoryMusic(ALL,"all_tat_amb_victory")
    SetDefeatMusic(ALL,"all_tat_amb_defeat")
    SetVictoryMusic(IMP,"imp_tat_amb_victory")
    SetDefeatMusic(IMP,"imp_tat_amb_defeat")
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    SetAttackingTeam(ATT)
    AddCameraShot(0.97433799505234,-0.22217999398708,0.035172000527382,0.0080199996009469,-82.664649963379,23.668300628662,43.955680847168)
    AddCameraShot(0.39019700884819,-0.089729003608227,-0.89304000139236,-0.2053620070219,23.563562393188,12.914884567261,-101.46556091309)
    AddCameraShot(0.16975900530815,0.0022249999456108,-0.98539799451828,0.012915999628603,126.97280883789,4.0396280288696,-22.020612716675)
    AddCameraShot(0.67745298147202,-0.041535001248121,0.73301601409912,0.044941999018192,97.517807006836,4.0396280288696,36.853477478027)
    AddCameraShot(0.86602902412415,-0.15650600194931,0.46729901432991,0.084449000656605,7.6856398582458,7.1306881904602,-10.895234107971)
end

function OnStart(OnStartParam0)
    AddAIGoal(ATT,"Deathmatch",1000)
    AddAIGoal(DEF,"Deathmatch",1000)
end

