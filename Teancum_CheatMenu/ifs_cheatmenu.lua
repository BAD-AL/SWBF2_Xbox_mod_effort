--ifs_cheatmenu.lua (Zerted & Teancum?)
-- Decompiled by cbadal with help from SWBF2CodeHelper
-- verified
--[[
    This decompiled cheat menu is functionally the same to the menu Teancum gave me; 
    but the resulting code looks strange in a couple places
]]
ifs_cheatmenu_vbutton_layout = {
    ySpacing = 5,
    width = 360,
    font = gMenuButtonFont,
    buttonlist = {
        {tag = "unlock_hero_and_units", string = "Unlock Heroes & Classes"},
        {tag = "jetpacks", string = "Add Jetpacks"},
        {tag = "reinforcements", string = "Add 50 reinforcements"},
        {tag = "victory", string = "Force Mission Victory"},
        {tag = "extra_vehicles", string = "Enable Hidden Vehicles"},
        {tag = "no_ai_vehicles", string = "No AI in Vehicles"},
        {tag = "classic_flyers", string = "Classic Starfighters"},
        {tag = "restore_hud", string = "Restore HUD"}
    },
    title = "Cheat Menu"
}
gConsoleCmdList = {}


function ifs_pausemenu_fnUpdateFlyersText(this)
    if this.buttons.classic_flyers then
        if (this.bClassic) then
            SetGroundFlyerMap(1)
            RoundIFButtonLabel_fnSetString(this.buttons.classic_flyers, "Advanced Starfighters")
        else
            SetGroundFlyerMap(0)
            RoundIFButtonLabel_fnSetString(this.buttons.classic_flyers, "Classic Starfighters")
        end
    end
end
--
ifs_cheatmenu =
    NewIFShellScreen {
    nologo = 1,
    bAcceptIsSelect = 1,
    movieIntro = nil,
    bDimBackdrop = 1,
    buttons = NewIFContainer {ScreenRelativeX = 0.5, ScreenRelativeY = 0.40000000596046},
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd)
        if (bFwd) then
            local result = ScriptCB_GetShellActive()
            
            if (ScriptCB_PausingIsPrimary) then
                this.buttons.sound.hidden = not ScriptCB_PausingIsPrimary()
            else
                this.buttons.sound.hidden = ScriptCB_GetPausingViewport() ~= 0
            end
            
            this.CurButton = ShowHideVerticalButtons(this.buttons,ifs_cheatmenu_vbutton_layout)
            SetCurButton(this.CurButton)
            ScriptCB_GetConsoleCmds()
        end
    end,
    Input_Accept = function(this)
        if( gShellScreen_fnDefaultInputAccept(this)) then 
            return 
        end 
        ifelm_shellscreen_fnPlaySound(this.acceptSound)

        if (this.CurButton == "unlock_hero_and_units") then
            UnlockHeroForTeam(1)
            UnlockHeroForTeam(2)
            local tbl = {{name = "PointsToUnlock", value = "0"}}
            uf_changeClassProperties( all_classes, tbl) 
        elseif(this.CurButton   == "nearly_unstoppable") then
            uf_changeObjectProperty("AddHealth", 2000, "human")
            local tbl = {
                {name = "JetFuelRechargeRate", value = "2000"},
                {name = "EnergyRestore", value = "2000"},
                {name = "EnergyRestoreIdle", value = "2000"}
            }
            uf_changeClassProperties(all_classes, tbl)
        elseif(this.CurButton   ==  "jetpacks" ) then 
            local tbl =  {
                {name = "AnimatedAddon", value = "jetpack_cheat"},
                {name = "GeometryAddon", value = "neu_addon_phaze1_pack"},
                {name = "AddonAttachJoint", value = "bone_ribcage"},
                {name = "JetEffect", value = "com_sfx_jet_cht"},
                {name = "ControlSpeed", value = "jet 10.85 1.85 2.00"},
                {name = "JetJump", value = "8.0"},
                {name = "JetPush", value = "8.0"},
                {name = "JetAcceleration", value = "20.0"},
                {name = "JetType", value = "hover"},
                {name = "JetFuelRechangeRate", value = "1"},
                {name = "JetFuelCost", value = "0.0"},
                {name = "JetFuelInitialCost", value = "0.0"},
                {name = "JetFuelMinBorder", value = "0.0"},
                {name = "CollisionScale", value =  "0.0 0.0 0.0"},
                {name = "EngineSound", value = "rep_inf_Jetpack_engine_parameterized"},
                {name = "TurnOnSound", value = "rep_weap_jetpack_turnon"},
                {name = "TurnOffSound", value = "rep_weap_jetpack_turnoff"},
                {name = "TurnOffTime", value = "0.0"}
            }
            uf_changeClassProperties(non_jetpack_classes, tbl)
        elseif(this.CurButton == "reinforcements")  then
            AddReinforcements(1, 50)
            AddReinforcements(2, 50)
        elseif(this.CurButton  == "victory") then
            MissionVictory({1, 2})
        elseif this.CurButton == "enhanced_weapons" then
            ActivateBonus(1, "team_bonus_advanced_blasters")
            ActivateBonus(2, "team_bonus_advanced_blasters")
        elseif this.CurButton == "extra_vehicles" then
            SetHistorical(1)
        elseif this.CurButton == "no_ai_vehicles" then
            ForceAIOutOfVehicles(1)
        elseif this.CurButton  == "classic_flyers" then
            this.bClassic = not this.bClassic
            ifs_pausemenu_fnUpdateFlyersText( this)
        elseif this.CurButton  == "restore_hud" then
            ScriptCB_DoConsoleCmd(gConsoleCmdList[0] )
        end
    end,
    Input_Back = function(this)
        ScriptCB_PopScreen()
    end
}

all_classes = {
    "all_inf_engineer",
    "all_inf_engineer_fleet",
    "all_inf_engineer_jungle",
    "all_inf_engineer_snow",
    "all_inf_fleet_soldier",
    "all_inf_marine",
    "all_inf_officer",
    "all_inf_officer_jungle",
    "all_inf_officer_snow",
    "all_inf_pilot",
    "all_inf_rifleman",
    "all_inf_rifleman_desert",
    "all_inf_rifleman_fleet",
    "all_inf_rifleman_jungle",
    "all_inf_rifleman_snow",
    "all_inf_rifleman_urban",
    "all_inf_rocketeer",
    "all_inf_rocketeer_fleet",
    "all_inf_rocketeer_jungle",
    "all_inf_rocketeer_snow",
    "all_inf_sniper",
    "all_inf_sniper_fleet",
    "all_inf_sniper_jungle",
    "all_inf_sniper_snow",
    "all_inf_wookiee",
    "all_inf_wookiee_snow",
    "all_hero_luke_jedi",
    "all_hero_luke_pilot",
    "all_hero_luke_storm",
    "all_hero_hansolo_storm",
    "all_hero_hansolo_tat",
    "all_hero_leia",
    "all_hero_chewbacca",
    "all_inf_specialops",
    "cis_inf_droideka",
    "cis_inf_engineer",
    "cis_inf_marine",
    "cis_inf_officer",
    "cis_inf_officer_hunt",
    "cis_inf_pilot",
    "cis_inf_rifleman",
    "cis_inf_rocketeer",
    "cis_inf_sniper",
    "cis_hero_countdooku",
    "cis_hero_darthmaul",
    "cis_hero_grievous",
    "cis_hero_jangofett",
    "cis_inf_commando",
    "imp_inf_dark_trooper",
    "imp_inf_dark_trooper_hunt",
    "imp_inf_darthvader",
    "imp_inf_engineer",
    "imp_inf_engineer_snow",
    "imp_inf_marine",
    "imp_inf_officer",
    "imp_inf_officer_gray",
    "imp_inf_officer_hunt",
    "imp_inf_officer_snow",
    "imp_inf_pilot",
    "imp_inf_pilot_atat",
    "imp_inf_pilot_atst",
    "imp_inf_pilot_tie",
    "imp_inf_rifleman",
    "imp_inf_rifleman_desert",
    "imp_inf_rifleman_snow",
    "imp_inf_rocketeer",
    "imp_inf_rocketeer_snow",
    "imp_inf_sniper",
    "imp_inf_sniper_snow",
    "imp_hero_emperor",
    "imp_hero_darthvader",
    "imp_hero_bobafett",
    "imp_inf_commando",
    "rep_inf_ep2_engineer",
    "rep_inf_ep2_jettrooper",
    "rep_inf_ep2_jettrooper_rifleman",
    "rep_inf_ep2_jettrooper_sniper",
    "rep_inf_ep2_jettrooper_training",
    "rep_inf_ep2_marine",
    "rep_inf_ep2_officer",
    "rep_inf_ep2_officer_training",
    "rep_inf_ep2_pilot",
    "rep_inf_ep2_rifleman",
    "rep_inf_ep2_rocketeer",
    "rep_inf_ep2_rocketeer_chaingun",
    "rep_inf_ep2_sniper",
    "rep_inf_ep3_engineer",
    "rep_inf_ep3_jettrooper",
    "rep_inf_ep3_marine",
    "rep_inf_ep3_officer",
    "rep_inf_ep3_pilot",
    "rep_inf_ep3_rifleman",
    "rep_inf_ep3_rifleman_space",
    "rep_inf_ep3_rocketeer",
    "rep_inf_ep3_sniper",
    "rep_inf_ep3_sniper_felucia",
    "rep_inf_ep3_space_pilot",
    "rep_hero_obiwan",
    "rep_hero_anakin",
    "rep_hero_cloakedanakin",
    "rep_hero_macewindu",
    "rep_hero_yoda",
    "rep_hero_aalya",
    "rep_hero_kiyadimundi",
    "rep_inf_commando",
    "rvs_inf_rbasic",
    "rvs_inf_rheavy",
    "rvs_inf_rmelee",
    "rvs_inf_rsupport",
    "rvs_inf_rstealth",
    "rvs_inf_radept",
    "rvs_inf_rofficer",
    "rvs_inf_rdroid",
    "rvs_inf_jedi",
    "rvs_inf_jedi_master",
    "kor_hero_atton",
    "kor_hero_bastila",
    "kor_hero_carth",
    "kor_hero_hk47",
    "kor_hero_jolee",
    "kor_hero_mandalore",
    "kor_hero_mission",
    "kor_hero_vandar",
    "rvs_inf_sbasic",
    "rvs_inf_sheavy",
    "rvs_inf_smelee",
    "rvs_inf_ssupport",
    "rvs_inf_sstealth",
    "rvs_inf_sadept",
    "rvs_inf_sofficer",
    "rvs_inf_sdroid",
    "rvs_inf_sith",
    "rvs_inf_sith_lord",
    "kor_hero_malak",
    "kor_hero_nihilus",
    "kor_hero_revan",
    "kor_hero_sion",
    "kor_hero_traya",
    "tat_inf_jawa",
    "tat_inf_tuskenhunter",
    "tat_inf_tuskenraider",
    "ewk_inf_scout",
    "ewk_inf_repair",
    "ewk_inf_trooper",
    "gam_inf_gamorreanguard",
    "gar_inf_defender",
    "gar_inf_naboo_queen",
    "gar_inf_soldier",
    "gar_inf_temple_soldier",
    "gar_inf_temple_vanguard",
    "gar_inf_vanguard",
    "gen_inf_geonosian",
    "geo_inf_acklay",
    "geo_inf_agro_geonosian",
    "gun_inf_soldier",
    "gun_inf_rider",
    "gun_inf_defender",
    "jed_knight_01",
    "jed_knight_02",
    "jed_knight_03",
    "jed_knight_04",
    "jed_master_01",
    "jed_master_02",
    "jed_master_03",
    "jed_runner",
    "jed_sith_01",
    "snw_inf_wampa",
    "wok_inf_mechanic",
    "wok_inf_rocketeer",
    "wok_inf_warrior"
}

non_jetpack_classes = {
    "all_inf_engineer",
    "all_inf_engineer_fleet",
    "all_inf_engineer_jungle",
    "all_inf_engineer_snow",
    "all_inf_fleet_soldier",
    "all_inf_marine",
    "all_inf_officer",
    "all_inf_officer_jungle",
    "all_inf_officer_snow",
    "all_inf_pilot",
    "all_inf_rifleman",
    "all_inf_rifleman_desert",
    "all_inf_rifleman_fleet",
    "all_inf_rifleman_jungle",
    "all_inf_rifleman_snow",
    "all_inf_rifleman_urban",
    "all_inf_rocketeer",
    "all_inf_rocketeer_fleet",
    "all_inf_rocketeer_jungle",
    "all_inf_rocketeer_snow",
    "all_inf_sniper",
    "all_inf_sniper_fleet",
    "all_inf_sniper_jungle",
    "all_inf_sniper_snow",
    "all_inf_wookiee",
    "all_inf_wookiee_snow",
    "all_inf_specialops",
    "cis_inf_droideka",
    "cis_inf_engineer",
    "cis_inf_marine",
    "cis_inf_officer",
    "cis_inf_officer_hunt",
    "cis_inf_pilot",
    "cis_inf_rifleman",
    "cis_inf_rocketeer",
    "cis_inf_sniper",
    "cis_inf_commando",
    "imp_inf_engineer",
    "imp_inf_engineer_snow",
    "imp_inf_marine",
    "imp_inf_officer",
    "imp_inf_officer_gray",
    "imp_inf_officer_hunt",
    "imp_inf_officer_snow",
    "imp_inf_pilot",
    "imp_inf_pilot_atat",
    "imp_inf_pilot_atst",
    "imp_inf_pilot_tie",
    "imp_inf_rifleman",
    "imp_inf_rifleman_desert",
    "imp_inf_rifleman_snow",
    "imp_inf_rocketeer",
    "imp_inf_rocketeer_snow",
    "imp_inf_sniper",
    "imp_inf_sniper_snow",
    "imp_inf_commando",
    "rep_inf_ep2_engineer",
    "rep_inf_ep2_marine",
    "rep_inf_ep2_officer",
    "rep_inf_ep2_officer_training",
    "rep_inf_ep2_pilot",
    "rep_inf_ep2_rifleman",
    "rep_inf_ep2_rocketeer",
    "rep_inf_ep2_rocketeer_chaingun",
    "rep_inf_ep2_sniper",
    "rep_inf_ep3_engineer",
    "rep_inf_ep3_marine",
    "rep_inf_ep3_officer",
    "rep_inf_ep3_pilot",
    "rep_inf_ep3_rifleman",
    "rep_inf_ep3_rifleman_space",
    "rep_inf_ep3_rocketeer",
    "rep_inf_ep3_sniper",
    "rep_inf_ep3_sniper_felucia",
    "rep_inf_ep3_space_pilot",
    "rep_inf_commando",
    "rvs_inf_rbasic",
    "rvs_inf_rheavy",
    "rvs_inf_rmelee",
    "rvs_inf_rsupport",
    "rvs_inf_rstealth",
    "rvs_inf_rofficer",
    "rvs_inf_sbasic",
    "rvs_inf_sheavy",
    "rvs_inf_smelee",
    "rvs_inf_ssupport",
    "rvs_inf_sstealth",
    "rvs_inf_sofficer"
}

function uf_changeClassProperties(param0, param1)
    local r2 = nil -- unused
	for r3 =1, table.getn(param0) do 
		local r6 = nil  -- unused 
		for r7 =1, table.getn(param1) do 
			if FindEntityClass(param0[r3]) ~= FindEntityClass("Zerted hopes no one names a class like this") then
				SetClassProperty(param0[r3], param1[r7].name, param1[r7].value )
			end
		end 
	end     
end

function uf_applyFunctionOnTeamUnits(functionToApply, param1, param2, param3, param4)
    -- param3 & param4 not used???
    if functionToApply == nil then
		return
    end
	local r5 = param3 or {1, 2}
	local r6 = nil 
	
	for r7 = 1, table.getn(r5) do 
		local r10 = GetTeamSize(r5[r7])
		local r11 = nil   -- not used?
		for r12 = 0, r10 - 1 do
			local r15 = GetTeamMember(r5[r7], r12)
			local r16 = IsCharacterHuman(r15)
			local r17 = GetCharacterUnit(r15)
			functionToApply(r15,r17, param1, param2 )
		end
	end 
end


function uf_changeObjectProperty(targetObject, value, class)
    local setMyStuff = function (s_param0, obj, property, value) -- why isn't the first param used? strange...
        if (obj == nil or property == nil or value == nil) then
            return
        end
        SetProperty(obj, property, value)
    end 
    uf_applyFunctionOnTeamUnits(setMyStuff,targetObject, value, {1,2}, class )
end

function ifs_cheatmenu_fnBuildScreen(this)
    local w = nil
    local h = nil
    w, h = ScriptCB_GetSafeScreenInfo()

    if ScriptCB_GetShellActive() and gPlatformStr ~= "PC" then
        ifs_cheatmenu_vbutton_layout.bLeftJustifyButtons = 1
    end
    this.CurButton = AddVerticalButtons(this.buttons, ifs_cheatmenu_vbutton_layout)
end

ifs_cheatmenu_fnBuildScreen(ifs_cheatmenu)
ifs_cheatmenu_fnBuildScreen = nil
AddIFScreen(ifs_cheatmenu, "ifs_cheatmenu")
ifs_cheatmenu = DoPostDelete(ifs_cheatmenu)
