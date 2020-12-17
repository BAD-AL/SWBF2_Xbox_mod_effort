--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- load the gametype script
ScriptCB_DoFile("ObjectiveConquest")
ScriptCB_DoFile("setup_teams") 
	
	--  REP Attacking (attacker is always #1)
    REP = 1;
    CIS = 2;
    --  These variables do not change
    ATT = REP;
    DEF = CIS;


function ScriptPostLoad()	   
    
    
    --This defines the CPs.  These need to happen first
    cp1 = CommandPost:New{name = "cp1"}
    cp2 = CommandPost:New{name = "cp2"}
    cp3 = CommandPost:New{name = "cp3"}
    cp4 = CommandPost:New{name = "cp4"}
    cp5 = CommandPost:New{name = "cp5"}
    cp6 = CommandPost:New{name = "cp6"}
    cp7 = CommandPost:New{name = "cp7"}
    cp8 = CommandPost:New{name = "cp8"}
    cp9 = CommandPost:New{name = "cp9"}
    cp10 = CommandPost:New{name = "cp10"}
    cp11 = CommandPost:New{name = "cp11"}
    cp12 = CommandPost:New{name = "cp12"}
    cp13 = CommandPost:New{name = "cp13"}
    cp14 = CommandPost:New{name = "cp14"}
    
    
    
    --This sets up the actual objective.  This needs to happen after cp's are defined
    conquest = ObjectiveConquest:New{teamATT = ATT, teamDEF = DEF, 
                                     textATT = "game.modes.con", 
                                     textDEF = "game.modes.con2",
                                     multiplayerRules = true}
    
    --This adds the CPs to the objective.  This needs to happen after the objective is set up
    conquest:AddCommandPost(cp1)
    conquest:AddCommandPost(cp2)
    conquest:AddCommandPost(cp3)
    conquest:AddCommandPost(cp4)    
    conquest:AddCommandPost(cp5)
    conquest:AddCommandPost(cp6)
    conquest:AddCommandPost(cp7)
    conquest:AddCommandPost(cp8)   
    conquest:AddCommandPost(cp9)
    conquest:AddCommandPost(cp10)
    conquest:AddCommandPost(cp11)
    conquest:AddCommandPost(cp12)   
    conquest:AddCommandPost(cp13)
    conquest:AddCommandPost(cp14)

    conquest:Start()

    EnableSPHeroRules()
    
 end

--[[
    Layer notes
    Adding a layer to the 'base' group has the following effects:
    Creates:[ <wld_name>_<layer_name>.HNT,
                                     .LGT,
                                     .PTH,
                                     .RGN,
                                     .lyr
    ]
     Modifies:[ <world_name>.GRP, 
                            .LDX,
                            .req
    ]
]]

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
    local numPlayers = ScriptCB_GetNumControllers()
    if( numPlayers > 1 ) then 
        --StealArtistHeap(1024*1024) 
        StealArtistHeap(3072*1024)
    end 

    print("XMSc_con: Show Loadscreen")
    ReadDataFile("dc:Load\\common.lvl")
    print("XMSc_con: Show Loadscreen - Done")

    ReadDataFile("ingame.lvl")
    
   
    SetMaxFlyHeight(85)
    SetMaxPlayerFlyHeight (85)
    
    SetMemoryPoolSize ("ClothData",20)
    SetMemoryPoolSize ("Combo",50)              -- should be ~ 2x number of jedi classes
    SetMemoryPoolSize ("Combo::State",650)      -- should be ~12x #Combo
    SetMemoryPoolSize ("Combo::Transition",650) -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Condition",650)  -- should be a bit bigger than #Combo::State
    SetMemoryPoolSize ("Combo::Attack",550)     -- should be ~8-12x #Combo
    SetMemoryPoolSize ("Combo::DamageSample",6000)  -- should be ~8-12x #Combo::Attack
    SetMemoryPoolSize ("Combo::Deflect",100)     -- should be ~1x #combo  
    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1600)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1024)

    --[[
        sound file, only difference pc vs xbox
        Location 	PC		XBOX
        0x20C       05       04

        The PC sound lvl wouldn't load on Xbox
        But, changing byte 0x20 to '04' allows 
        the sound to run just fine on xbox.
    ]]
    --[[
        xbox common.lvl notes:
        Original (xbox) common.lvl has additional files:
            controller_presets.script,
            ifs_opt_controller_common.script, 
            ifs_opt_mp_listtags.script
        And omits file:
            ifelem_form.script
    ]]

    ReadDataFile("dc:sound\\xms.lvl;xmsgcw")
    ReadDataFile("sound\\yav.lvl;yav1cw")
  
    ReadDataFile("dc:SIDE\\rep.lvl",
                             "rep_inf_ep3_rifleman",
                             "rep_inf_ep3_rocketeer",
                             "rep_inf_ep3_engineer",
                             "rep_inf_ep3_sniper_felucia",
                             "rep_inf_ep3_officer",
                             "rep_inf_ep3_jettrooper")
 
    ReadDataFile("dc:SIDE\\cis.lvl",
                             "cis_inf_rifleman",
                             "cis_inf_rocketeer",
                             "cis_inf_engineer",
                             "cis_inf_sniper",
                             "cis_inf_officer",
                             "cis_inf_droideka")

    -- if( numPlayers == 1 ) then 
    if( numPlayers < 3 ) then 
        ReadDataFile("dc:SIDE\\des.lvl",
                            "xms_hero_santa",
                            "xms_drive_explorer"
                        )
    end

    print("XMSc_con: Setup teams")
	SetupTeams{
		rep = {
			team = REP,
			units = 20,
			reinforcements = 150,
			soldier  = { "rep_inf_ep3_rifleman",9, 25},
			assault  = { "rep_inf_ep3_rocketeer",1, 4},
			engineer = { "rep_inf_ep3_engineer",1, 4},
			sniper   = { "rep_inf_ep3_sniper_felucia",1, 4},
			officer = {"rep_inf_ep3_officer",1, 4},
			special = { "rep_inf_ep3_jettrooper",1, 4},
	        
		},
		cis = {
			team = CIS,
			units = 20,
			reinforcements = 150,
			soldier  = { "cis_inf_rifleman",9, 25},
			assault  = { "cis_inf_rocketeer",1, 4},
			engineer = { "cis_inf_engineer",1, 4},
			sniper   = { "cis_inf_sniper",1, 4},
			officer = {"cis_inf_officer",1, 4},
			special = { "cis_inf_droideka",1, 4},
		}
	}

    --if( numPlayers == 1 ) then 
    if( numPlayers < 3 ) then 
        SetHeroClass(CIS, "xms_hero_badsanta")
        SetHeroClass(REP, "xms_hero_santa")
    end 
    --  Level Stats
    --  ClearWalkers()
    AddWalkerType(0, 4) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)
    local weaponCnt = 1024
    SetMemoryPoolSize("Aimer", 75)
    SetMemoryPoolSize("AmmoCounter", weaponCnt)
    SetMemoryPoolSize("BaseHint", 1024)
    SetMemoryPoolSize("EnergyBar", weaponCnt)
	SetMemoryPoolSize("EntityCloth", 32)
	SetMemoryPoolSize("EntityFlyer", 32)
    SetMemoryPoolSize("EntityHover", 32)
    SetMemoryPoolSize("EntityLight", 200)
    SetMemoryPoolSize("EntitySoundStream", 4)
    SetMemoryPoolSize("EntitySoundStatic", 32)
    SetMemoryPoolSize("MountedTurret", 32)
	SetMemoryPoolSize("Navigator", 128)
    SetMemoryPoolSize("Obstacle", 1024)
	SetMemoryPoolSize("PathNode", 1024)
    SetMemoryPoolSize("SoundSpaceRegion", 64)
    SetMemoryPoolSize("TreeGridStack", 1024)
	SetMemoryPoolSize("UnitAgent", 128)
	SetMemoryPoolSize("UnitController", 128)
    SetMemoryPoolSize("Weapon", weaponCnt)
    SetMemoryPoolSize("SoldierAnimation",296)
    SetMemoryPoolSize("ParticleTransformer::ColorTrans", 1592)
    SetMemoryPoolSize("ParticleTransformer::SizeTransf", 1030)
    SetMemoryPoolSize("LightFlash", 64)

    SetSpawnDelay(10.0, 0.25)
    print("XMSc_con: load conquest")

    ReadDataFile("dc:XMS\\XMS.lvl", "XMS_conquest")
    --[[
    if(numPlayers > 1) then 
        -- for 3 or 4 players, load a more bare level
        ReadDataFile("dc:XMS\\XMS2.lvl", "XMS_conquest")
    else     
        ReadDataFile("dc:XMS\\XMS.lvl", "XMS_conquest")
    end]]

    SetDenseEnvironment("false")

    --  Sound

    voiceSlow = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl", "rep_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl", "cis_unit_vo_quick", voiceQuick)
    
    -- Custom music is here
    OpenAudioStream("dc:sound\\xms.lvl", "xmsgcw_music") 
    OpenAudioStream("sound\\global.lvl",  "cw_music")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1")
    OpenAudioStream("sound\\yav.lvl",  "yav1_emt")

    SetBleedingVoiceOver(REP, REP, "rep_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(REP, CIS, "rep_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, REP, "cis_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(CIS, CIS, "cis_off_com_report_us_overwhelmed", 1)

    SetOutOfBoundsVoiceOver(2, "cisleaving")
    SetOutOfBoundsVoiceOver(1, "repleaving")

    -- play the custom music
    SetAmbientMusic(REP, 1.0, "all_xms_amb_start",  0,1)
    --SetAmbientMusic(REP, 0.8, "all_tat_amb_middle", 1,1)
    --SetAmbientMusic(REP, 0.2, "all_tat_amb_end",    2,1)
    SetAmbientMusic(CIS, 1.0, "all_xms_amb_start",  0,1)
    --SetAmbientMusic(CIS, 0.8, "imp_tat_amb_middle", 1,1)
    ---SetAmbientMusic(CIS, 0.2, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(REP, "all_xms_amb_victory")
    SetDefeatMusic (REP, "all_xms_amb_defeat")
    SetVictoryMusic(CIS, "all_xms_amb_victory")
    SetDefeatMusic (CIS, "all_xms_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",      "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut",     "binocularzoomout")
    --SetSoundEffect("BirdScatter",             "birdsFlySeq1")
    --SetSoundEffect("WeaponUnableSelect",      "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")


--OpeningSateliteShot
    AddCameraShot(0.922189, 0.005190, 0.386699, -0.002176, 16.152931, 2.152442, 14.451564);
    AddCameraShot(0.762110, -0.035159, -0.645805, -0.029794, -125.405746, 2.266697, -24.197813);
	AddCameraShot(0.938617, 0.067516, -0.337416, 0.024271, 0.699885, 2.314275, -1.267133);
	AddCameraShot(0.567659, -0.027116, 0.821880, 0.039260, 47.822720, 1.902458, -54.789948);
	AddCameraShot(0.971843, 0.207635, -0.108941, 0.023275, -55.186462, 2.043368, -18.466204);
	AddCameraShot(0.997534, -0.065570, 0.024970, 0.001641, -101.618469, 2.043368, -26.347338);
    AddCameraShot(0.579236, 0.068464, -0.806665, 0.095345, -139.846054, 2.043368, 62.268623);
    
end

