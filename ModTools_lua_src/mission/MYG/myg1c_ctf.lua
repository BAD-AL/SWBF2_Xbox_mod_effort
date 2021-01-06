--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- load the gametype script
ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveCTF")

    --  Republic Attacking (attacker is always #1)
    REP = 1
    CIS = 2
    --  These variables do not change
    ATT = 1
    DEF = 2

---------------------------------------------------------------------------
-- FUNCTION:    ScriptInit
-- PURPOSE:     This function is only run once
-- INPUT:
-- OUTPUT:
-- NOTES:       The name, 'ScriptInit' is a chosen convention, and each
--              mission script must contain a version of this function, as
--              it is called from C to start the mission.
---------------------------------------------------------------------------
 function ScriptPostLoad()
 
        SoundEvent_SetupTeams( CIS, 'cis', REP, 'rep' )
         DisableBarriers("corebar1");
         DisableBarriers("corebar2");
         DisableBarriers("corebar3");
         DisableBarriers("shield_01");
         DisableBarriers("shield_02");
         DisableBarriers("shield_03");
         DisableBarriers("corebar4");
         DisableBarriers("dropship")
         DisableBarriers("coresh1")
         
         -- Setting up Shield functionality --


    OnObjectRespawnName(Revived, "generator_01");
    OnObjectKillName(ShieldDied, "force_shield_01");
    OnObjectKillName(ShieldDied, "generator_01");
    

    OnObjectRespawnName(Revived, "generator_02");
    OnObjectKillName(ShieldDied, "force_shield_02");
    OnObjectKillName(ShieldDied, "generator_02");
    
    OnObjectRespawnName(Revived, "generator_03");
    OnObjectKillName(ShieldDied, "force_shield_03");
    OnObjectKillName(ShieldDied, "generator_03");
    
 

    
    --This is all the flag capture objective stuff
        SetProperty("flag1", "GeometryName", "com_icon_republic_flag")
        SetProperty("flag1", "CarriedGeometryName", "com_icon_republic_flag_carried")
        SetProperty("flag2", "GeometryName", "com_icon_cis_flag")
        SetProperty("flag2", "CarriedGeometryName", "com_icon_cis_flag_carried")

        SetClassProperty("com_item_flag", "DroppedColorize", 1)

    
   ctf = ObjectiveCTF:New{teamATT = ATT, teamDEF = DEF, captureLimit = 5, textATT = "game.modes.CTF", textDEF = "game.modes.CTF2", hideCPs = true, multiplayerRules = true}
    ctf:AddFlag{name = "flag1", homeRegion = "flag1_home", captureRegion = "flag2_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:AddFlag{name = "flag2", homeRegion = "flag2_home", captureRegion = "flag1_home",
                capRegionMarker = "hud_objective_icon_circle", capRegionMarkerScale = 3.0, 
                icon = "", mapIcon = "flag_icon", mapIconScale = 3.0}
    ctf:Start()
    
    EnableSPHeroRules()
    
    end
    
--Start Shield Work

function Init(numberStr)
   
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldUp(shieldName, genName, upAnim, downAnim);
     
     BlockPlanningGraphArcs("shield_" .. numberStr);
     EnableBarriers("shield_" .. numberStr);
   
end

function ShieldDied(actor)
     fullName = GetEntityName(actor);
     numberStr = string.sub(fullName, -2, -1);
     
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldDown(shieldName, genName, upAnim, downAnim);
     
     UnblockPlanningGraphArcs("shield_" .. numberStr);
     DisableBarriers("shield_" .. numberStr);

end

--Rewarding player Mission Victory for Destorying the Core (mostly for MP) -- 

--function CoreDied(actor)
        --MissionVictory(ATT)
--end

function Revived(actor)

     fullName = GetEntityName(actor);
     numberStr = string.sub(fullName, -2, -1);
     
     shieldName = "force_shield_" .. numberStr;
     genName = "generator_" .. numberStr;
     upAnim = "shield_up_" .. numberStr;
     downAnim = "shield_down_" .. numberStr;
     
     PlayShieldUp(shieldName, genName, upAnim, downAnim);
     BlockPlanningGraphArcs("shield_" .. numberStr);
     EnableBarriers("shield_" .. numberStr);
end

-- Drop Shield
function PlayShieldDown(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj);
      KillObject(genObj);
      PauseAnimation(upAnim);
      RewindAnimation(downAnim);
      PlayAnimation(downAnim);
    
end
-- Put Shield Backup
function PlayShieldUp(shieldObj, genObj, upAnim, downAnim)
      RespawnObject(shieldObj);
      RespawnObject(genObj);
      PauseAnimation(downAnim);
      RewindAnimation(upAnim);
      PlayAnimation(upAnim);
end
 
function ScriptInit()
    StealArtistHeap(450000)
    -- Designers, these two lines *MUST* be first!
    SetPS2ModelMemory(4100000)
    ReadDataFile("ingame.lvl")

    ReadDataFile("sound\\myg.lvl;myg1cw")

    ReadDataFile("SIDE\\rep.lvl",
                             --"rep_fly_assault_dome",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_jettrooper",
                             "rep_inf_ep3_sniper",
                             "rep_inf_ep3_officer",
                             "rep_hover_fightertank",
                             "rep_fly_gunship_dome",
                             "rep_hover_barcspeeder",
                             "rep_hero_kiyadimundi") 
    ReadDataFile("SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_hover_aat",
                             "cis_inf_officer",
                             "cis_fly_gunship_dome",
                             "cis_inf_droideka",
                             "cis_hero_grievous")
                                                        
    ReadDataFile("SIDE\\tur.lvl",
                            "tur_bldg_recoilless_lg")


    SetupTeams{

        rep={
            team = REP,
            units = 32,
            reinforcements = -1,
            soldier = {"rep_inf_ep3_rifleman", 9, 25},
            assault = {"rep_inf_ep3_rocketeer", 1, 4},
            engineer = {"rep_inf_ep3_engineer", 1, 4},
            sniper  = {"rep_inf_ep3_sniper", 1, 4},
            officer = {"rep_inf_ep3_officer", 1, 4},
            special = {"rep_inf_ep3_jettrooper", 1, 4},
            
            
        },
        
        cis={
            team = CIS,
            units = 32,
            reinforcements = -1,
            soldier = {"cis_inf_rifleman", 9, 25},
            assault = {"cis_inf_rocketeer", 1, 4},
            engineer = {"cis_inf_engineer", 1, 4},
            sniper  = {"cis_inf_sniper", 1, 4},
            officer   = {"cis_inf_officer", 1, 4},
            special = {"cis_inf_droideka", 1, 4},
        }
    }
        
        
        --  Hero Setup Section  --

        SetHeroClass(REP, "rep_hero_kiyadimundi")
        SetHeroClass(CIS, "cis_hero_grievous")

    --  Level Stats
    ClearWalkers()
    AddWalkerType(0, 4)
    AddWalkerType(2, 0)
    local weaponCnt = 165
    SetMemoryPoolSize("Aimer", 65)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 250)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
    SetMemoryPoolSize("EntityCloth", 17)
    SetMemoryPoolSize("EntityHover", 8)
    SetMemoryPoolSize("EntitySoundStream", 1)
    SetMemoryPoolSize("EntitySoundStatic", 76)
    SetMemoryPoolSize("EntityFlyer", 6)
    SetMemoryPoolSize("FlagItem", 2)
    SetMemoryPoolSize("MountedTurret", 13)
    SetMemoryPoolSize("Navigator", 50)
    SetMemoryPoolSize("Obstacle", 460)
    SetMemoryPoolSize("PathFollower", 50)
    SetMemoryPoolSize("PathNode", 128)
    SetMemoryPoolSize("TentacleSimulator", 0)
    SetMemoryPoolSize("TreeGridStack", 300)
    SetMemoryPoolSize("Weapon", weaponCnt)
    
    SetSpawnDelay(10.0, 0.25)
    ReadDataFile("myg\\myg1.lvl", "myg1_ctf")
    SetDenseEnvironment("false")
    AddDeathRegion("deathregion")
    SetMaxFlyHeight(20)
    SetMaxPlayerFlyHeight(20)

    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)    
    
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    OpenAudioStream("sound\\myg.lvl",  "myg1")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    -- OpenAudioStream("sound\\myg.lvl",  "myg1_emt")

    -- SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    -- SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    -- SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(1, "Repleaving")
    SetOutOfBoundsVoiceOver(2, "Cisleaving")

    SetAmbientMusic(REP, 1.0, "rep_myg_amb_start",  0,1)
    SetAmbientMusic(REP, 0.9, "rep_myg_amb_middle", 1,1)
    SetAmbientMusic(REP, 0.1,"rep_myg_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "cis_myg_amb_start",  0,1)
    SetAmbientMusic(CIS, 0.9, "cis_myg_amb_middle", 1,1)
    SetAmbientMusic(CIS, 0.1,"cis_myg_amb_end",    2,1)

    SetVictoryMusic(REP, "rep_myg_amb_victory")
    SetDefeatMusic (REP, "rep_myg_amb_defeat")
    SetVictoryMusic(CIS, "cis_myg_amb_victory")
    SetDefeatMusic (CIS, "cis_myg_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


        --Camera Shizzle--
        
        -- Collector Shot
--    AddCameraShot(0.947990, -0.029190, 0.316808, 0.009755, -88.997040, 14.153851, -17.227827);
--    AddCameraShot(0.733884, -0.181143, 0.635601, 0.156884, 67.597633, 39.055626, 55.312775);
--	AddCameraShot(0.854759, -0.048390, 0.515938, 0.029208, -23.516922, 12.832355, 204.400604);



    AddCameraShot(0.008315, 0.000001, -0.999965, 0.000074, -64.894348, 5.541570, 201.711090);
	AddCameraShot(0.633584, -0.048454, -0.769907, -0.058879, -171.257629, 7.728924, 28.249359);
	AddCameraShot(-0.001735, -0.000089, -0.998692, 0.051092, -146.093109, 4.418306, -167.739212);
	AddCameraShot(0.984182, -0.048488, 0.170190, 0.008385, 1.725611, 8.877428, 88.413887);
	AddCameraShot(0.141407, -0.012274, -0.986168, -0.085598, -77.743042, 8.067328, 42.336128);
	AddCameraShot(0.797017, 0.029661, 0.602810, -0.022434, -45.726467, 7.754435, -47.544712);
	AddCameraShot(0.998764, 0.044818, -0.021459, 0.000963, -71.276566, 4.417432, 221.054550);
end


