--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--
gFinalBuild = false 

ScriptCB_DoFile("setup_teams")
ScriptCB_DoFile("ObjectiveConquest")

	--  Empire Attacking (attacker is always #1)
    local ALL = 2
    local IMP = 1
    --  These variables do not change
    local ATT = 1
    local DEF = 2
    
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

    print("XMSc_con: Show Loadscreen")
    ReadDataFile("dc:Load\\common.lvl")
    print("XMSc_con: Show Loadscreen - Done")
    ReadDataFile("ingame.lvl")

    SetMaxFlyHeight(85)
    SetMaxPlayerFlyHeight(85)

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
    
    ReadDataFile("sound\\tat.lvl;tat2gcw")
    ReadDataFile("dc:sound\\xms.lvl;xmsgcw")

    ReadDataFile("dc:SIDE\\all.lvl",
                    "all_inf_rifleman",
                    "all_inf_rocketeer",
                    "all_inf_sniper",
                    "all_inf_engineer",
                    "all_inf_officer"
                --    ,"all_inf_wookiee_snow"
                )
                    
    ReadDataFile("dc:SIDE\\imp.lvl",
                    "imp_inf_rifleman_snow",
                    "imp_inf_rocketeer_snow",
                    "imp_inf_pilot_atat",
                    "imp_inf_sniper",
                    --"imp_inf_officer"
                    "imp_inf_dark_trooper"
                )
 
    if( numPlayers < 3 ) then 
        ReadDataFile("dc:SIDE\\des.lvl",
                    "xms_hero_santa",
                    "xms_drive_explorer")
    end

	SetupTeams{
		all = {
			team = ALL,
			units = 20,
			reinforcements = 150,
			soldier	= { "all_inf_rifleman",9, 25},
			assault	= { "all_inf_rocketeer",1,4},
			engineer = { "all_inf_engineer",1,4},
			sniper	= { "all_inf_sniper",1,4},
			officer	= { "all_inf_officer",1,4},
			--special	= { "all_inf_wookiee_snow",1,4},

		},
		imp = {
			team = IMP,
			units = 20,
			reinforcements = 150,
			soldier	= { "imp_inf_rifleman_snow",9, 25},
			assault	= { "imp_inf_rocketeer_snow",1,4},
			engineer = { "imp_inf_pilot_atat",1,4},
            sniper	= { "imp_inf_sniper",1,4},
            officer = { "imp_inf_dark_trooper",1,4},
			-- officer	= { "imp_inf_officer",1,4},
			--special	= { "imp_inf_dark_trooper",1,4},
		},
	}
    if( numPlayers < 3 ) then 
        SetHeroClass(ALL, "xms_hero_santa")
        SetHeroClass(IMP, "xms_hero_badsanta")
    end
    --  Level Stats
    ClearWalkers()
    --[[
    AddWalkerType(0, 0) -- special -> droidekas
    AddWalkerType(1, 0) -- 1x2 (1 pair of legs)
    AddWalkerType(2, 0) -- 2x2 (2 pairs of legs)
    AddWalkerType(3, 0) -- 3x2 (3 pairs of legs)]]
    
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
    --[[if(numPlayers > 1) then 
        ReadDataFile("dc:XMS\\XMS2.lvl", "XMS_conquest")
    else     
        ReadDataFile("dc:XMS\\XMS.lvl", "XMS_conquest")
    end]]

    SetDenseEnvironment("false")


    --  Sound Stats
    
    voiceSlow = OpenAudioStream("sound\\global.lvl", "all_unit_vo_slow")
    AudioStreamAppendSegments("sound\\global.lvl", "imp_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "des_unit_vo_slow", voiceSlow)
    AudioStreamAppendSegments("sound\\global.lvl", "global_vo_slow", voiceSlow)
    
    voiceQuick = OpenAudioStream("sound\\global.lvl",  "all_unit_vo_quick")
    AudioStreamAppendSegments("sound\\global.lvl",  "imp_unit_vo_quick", voiceQuick)    
 
    -- Custom music is here
    OpenAudioStream("dc:sound\\xms.lvl", "xmsgcw_music") 
    OpenAudioStream("sound\\global.lvl",  "gcw_music")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    OpenAudioStream("sound\\tat.lvl",  "tat2")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_quick")
    -- OpenAudioStream("sound\\global.lvl",  "global_vo_slow")

    SetBleedingVoiceOver(ALL, ALL, "all_off_com_report_us_overwhelmed", 1)
    SetBleedingVoiceOver(ALL, IMP, "all_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, ALL, "imp_off_com_report_enemy_losing",   1)
    SetBleedingVoiceOver(IMP, IMP, "imp_off_com_report_us_overwhelmed", 1)

    SetLowReinforcementsVoiceOver(ALL, ALL, "all_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(ALL, IMP, "all_off_victory_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, IMP, "imp_off_defeat_im", .1, 1)
    SetLowReinforcementsVoiceOver(IMP, ALL, "imp_off_victory_im", .1, 1)

    SetOutOfBoundsVoiceOver(2, "Allleaving")
    SetOutOfBoundsVoiceOver(1, "Impleaving")

    SetAmbientMusic(ALL, 1.0, "all_xms_amb_start",  0,1)
    --SetAmbientMusic(ALL, 0.8, "all_tat_amb_middle", 1,1)
    --SetAmbientMusic(ALL, 0.2, "all_tat_amb_end",    2,1)
    SetAmbientMusic(IMP, 1.0, "all_xms_amb_start",  0,1)
    --SetAmbientMusic(IMP, 0.8, "imp_tat_amb_middle", 1,1)
    ---SetAmbientMusic(IMP, 0.2, "imp_tat_amb_end",    2,1)

    SetVictoryMusic(ALL, "all_xms_amb_victory")
    SetDefeatMusic (ALL, "all_xms_amb_defeat")
    SetVictoryMusic(IMP, "all_xms_amb_victory")
    SetDefeatMusic (IMP, "all_xms_amb_defeat")

    SetSoundEffect("ScopeDisplayZoomIn",  "binocularzoomin")
    SetSoundEffect("ScopeDisplayZoomOut", "binocularzoomout")
    --SetSoundEffect("WeaponUnableSelect",  "com_weap_inf_weaponchange_null")
    --SetSoundEffect("WeaponModeUnableSelect",  "com_weap_inf_modechange_null")
    SetSoundEffect("SpawnDisplayUnitChange",       "shell_select_unit")
    SetSoundEffect("SpawnDisplayUnitAccept",       "shell_menu_enter")
    SetSoundEffect("SpawnDisplaySpawnPointChange", "shell_select_change")
    SetSoundEffect("SpawnDisplaySpawnPointAccept", "shell_menu_enter")
    SetSoundEffect("SpawnDisplayBack",             "shell_menu_exit")

    --  Camera Stats
    --Tat2 Mos Eisley
    --[[AddCameraShot(0.974338, -0.222180, 0.035172, 0.008020, -82.664650, 23.668301, 43.955681);
	AddCameraShot(0.390197, -0.089729, -0.893040, -0.205362, 23.563562, 12.914885, -101.465561);
	AddCameraShot(0.169759, 0.002225, -0.985398, 0.012916, 126.972809, 4.039628, -22.020613);
	AddCameraShot(0.677453, -0.041535, 0.733016, 0.044942, 97.517807, 4.039628, 36.853477);
    AddCameraShot(0.866029, -0.156506, 0.467299, 0.084449, 7.685640, 7.130688, -10.895234);]]
    
    AddCameraShot(0.922189, 0.005190, 0.386699, -0.002176, 16.152931, 2.152442, 14.451564);
    AddCameraShot(0.762110, -0.035159, -0.645805, -0.029794, -125.405746, 2.266697, -24.197813);
	AddCameraShot(0.938617, 0.067516, -0.337416, 0.024271, 0.699885, 2.314275, -1.267133);
	AddCameraShot(0.567659, -0.027116, 0.821880, 0.039260, 47.822720, 1.902458, -54.789948);
	AddCameraShot(0.971843, 0.207635, -0.108941, 0.023275, -55.186462, 2.043368, -18.466204);
	AddCameraShot(0.997534, -0.065570, 0.024970, 0.001641, -101.618469, 2.043368, -26.347338);
    AddCameraShot(0.579236, 0.068464, -0.806665, 0.095345, -139.846054, 2.043368, 62.268623);
    
end
