-- spa2c_con.lua 
-- From the PS2 Demo Disk December 2005 
-- Decompiled with SWBF2CodeHelper
ScriptCB_DoFile("setup_teams")

REP = 1
CIS = 2
ATT = 1
DEF = 2

function ScriptPostLoad()
    OnCharacterDeathTeam(
        function (character, killer)
          AddReinforcements(ATT,-1)
        end,
        ATT
    )
    OnCharacterDeathTeam(
        function (character, killer)
          AddReinforcements(DEF,-1)
        end,
        DEF
    )
    
    OnTicketCountChange(
        function (team, count)
            if count <= 0 then
                MissionDefeat(team)
            end
        end
    )
        SetObjectTeam("cp2",2)
        SetObjectTeam("cp3",1)
end

function ScriptInit()
    SetPS2ModelMemory(3497152)
    ReadDataFile("ingame.lvl")
    SetMinFlyHeight(-1900)
    SetMaxFlyHeight(2000)
    SetMinPlayerFlyHeight(-1900)
    SetMaxPlayerFlyHeight(2000)
    SetAIVehicleNotifyRadius(100)
    
    ReadDataFile("sound\\spa.lvl;spa2cw")
    ScriptCB_SetDopplerFactor(0.4)
    
    ScaleSoundParameter("weapons","MaxDistance",5)
    ScaleSoundParameter("weapons","MuteDistance",5)
    ScaleSoundParameter("ordnance","MinDistance",5)
    ScaleSoundParameter("ordnance","MaxDistance",5)
    ScaleSoundParameter("ordnance","MuteDistance",5)
    ScaleSoundParameter("veh_weapon","MaxDistance",10)
    ScaleSoundParameter("veh_weapon","MuteDistance",10)
    ScaleSoundParameter("explosion","MaxDistance",15)
    ScaleSoundParameter("explosion","MuteDistance",15)
    
    ReadDataFile("SIDE\\rep.lvl",
                "rep_inf_ep3_pilot",
                "rep_inf_ep3_marine",
                "rep_fly_assault_dome",
                "rep_fly_anakinstarfighter_sc",
                "rep_fly_arc170fighter_sc",
                "rep_veh_remote_terminal",
                "rep_fly_arc170fighter_dome",
                "rep_fly_vwing"
    )
    
    ReadDataFile("SIDE\\cis.lvl",
                "cis_inf_rifleman",
                "cis_inf_pilot",
                "cis_fly_fedlander_dome",
                "cis_fly_droidfighter_sc",
                "cis_fly_droidfighter_dome",
                "cis_fly_greviousfighter",
                "cis_fly_tridroidfighter"
    )
    
    SetupTeams({ 
        rep = { 
            team = REP, 
            units = 16, 
            reinforcements = 25, 
            soldier = { "rep_inf_ep3_marine", 4 }, 
            pilot =   { "rep_inf_ep3_pilot", 12 }
         }, 
        cis = { 
            team = CIS, 
            units = 16, 
            reinforcements = 25, 
            soldier = { "cis_inf_rifleman", 11 }, 
            pilot =   { "cis_inf_pilot", 3 }
         }
       })
       
    ClearWalkers()
    SetMemoryPoolSize("EntityFlyer",32)
    SetMemoryPoolSize("PowerupItem",30)
    SetMemoryPoolSize("EntityMine",0)
    SetMemoryPoolSize("EntityRemoteTerminal",8)
    SetMemoryPoolSize("Obstacle",80)
    SetMemoryPoolSize("PathNode",48)
    SetMemoryPoolSize("BaseHint",0)
    SetMemoryPoolSize("PassengerSlot",0)
    SetMemoryPoolSize("EntitySoldier",32)
    SetMemoryPoolSize("EntityDroideka",0)
    SetMemoryPoolSize("EntityDroid",0)
    SetMemoryPoolSize("TreeGridStack",100)
    SetMemoryPoolSize("EntitySoundStream",48)
    SetMemoryPoolSize("Aimer",350)
    SetMemoryPoolSize("UnitController",90)
    SetMemoryPoolSize("UnitAgent",90)
    SetMemoryPoolSize("MountedTurret",60)
    SetMemoryPoolSize("Weapon",270)
    
    SetSpawnDelay(10,0.25)
    ReadDataFile("spa\\spa2.lvl")
    SetDenseEnvironment("false")
    SetParticleLODBias(15000)
    
    OpenAudioStream("sound\\spa.lvl","spacw_music")
    OpenAudioStream("sound\\spa.lvl","spacw")
    OpenAudioStream("sound\\spa.lvl","spacw")
    OpenAudioStream("sound\\global.lvl","global_vo_quick")
    OpenAudioStream("sound\\global.lvl","global_vo_slow")
    
    SetBleedingVoiceOver(REP,REP,"rep_off_com_report_us_overwhelmed",1)
    SetBleedingVoiceOver(REP,CIS,"rep_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(CIS,REP,"cis_off_com_report_enemy_losing",1)
    SetBleedingVoiceOver(CIS,CIS,"cis_off_com_report_us_overwhelmed",1)
    
    SetOutOfBoundsVoiceOver(1,"Repleaving")
    SetOutOfBoundsVoiceOver(2,"Cisleaving")
    
    SetAmbientMusic(REP,1,"rep_spa_amb_start",0,1)
    SetAmbientMusic(REP,0.99000000953674,"rep_spa_amb_middle",1,1)
    SetAmbientMusic(REP,0.10000000149012,"rep_spa_amb_end",2,1)
    SetAmbientMusic(CIS,1,"cis_spa_amb_start",0,1)
    SetAmbientMusic(CIS,0.99000000953674,"cis_spa_amb_middle",1,1)
    SetAmbientMusic(CIS,0.10000000149012,"cis_spa_amb_end",2,1)
    
    SetVictoryMusic(REP,"rep_spa_amb_victory")
    SetDefeatMusic(REP,"rep_spa_amb_defeat")
    SetVictoryMusic(CIS,"cis_spa_amb_victory")
    SetDefeatMusic(CIS,"cis_spa_amb_defeat")
    
    SetSoundEffect("ScopeDisplayZoomIn","binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut","binocularzoomout")
    SetSoundEffect("SpawnDisplayUnitChange","shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange","shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept","shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack","shell_menu_exit")
    
    SetPlanetaryBonusVoiceOver(CIS,CIS,3,"CIS_bonus_CIS_hero")
    SetPlanetaryBonusVoiceOver(CIS,REP,3,"CIS_bonus_REP_hero")
    SetPlanetaryBonusVoiceOver(REP,REP,3,"REP_bonus_REP_hero")
    SetPlanetaryBonusVoiceOver(REP,CIS,3,"REP_bonus_CIS_hero")

    AddCameraShot(0.018921999260783,0.004317999817431,-0.97475498914719,0.22243200242519,-546.70269775391,412.00747680664,-1779.9544677734)
    AddLandingRegion("CP1Control")
    AddLandingRegion("CP2CONTROL")
    AddLandingRegion("cp3control")
    AddLandingRegion("cp4control")
    
    if gPlatformStr == "PS2" then
        ScriptCB_DisableFlyerShadows()
    end
    
end
