--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_fleet = 
{
	all = "gal_prp_moncalamaricruiser",
	cis = "gal_prp_fedcoreship",
	imp = "gal_prp_stardestroyer",
	rep = "gal_prp_assaultship",
}

do
	local ingameLang = {
		english    = "movies\\crawl.mvs",
		spanish    = "movies\\crawlsp.mvs",
		italian    = "movies\\crawlit.mvs",
		french     = "movies\\crawlfr.mvs",
		german     = "movies\\crawlgr.mvs",
		uk_english = "movies\\crawl.mvs" -- nathan's script renames crawluk.mvs to crawl.mvs--cbb 10/03/05
	}
	local langStr, langIndex = ScriptCB_GetLanguage()
	gIngameStream = ingameLang[langStr] or ingameLang["english"]
	print("ingame stream", gIngameStream)
end

ifs_campaign_mission = {
	{
		intro = { gIngameStream, "crawl1" },
		planet = "myg",
		side = "rep",
		enemy = "cis",
		unit = {			
			assault = {
				name = "entity.rep.inf_ep3_rocketeer",
				info = "ifs.freeform.purchase.military.sides.rep.assault",
				sound = "mtg_rep_unit_name_rocketeer",
				body = "rep_inf_ep3heavytrooper",
				weapon = "rep_weap_inf_launcher",
				anim_set = bazooka_anim_set
			},
			engineer = {
				name = "entity.rep.inf_ep3_engineer",
				info = "ifs.freeform.purchase.military.sides.rep.engineer",
				sound = "mtg_rep_unit_name_engineer",
				body = "rep_inf_ep3armoredpilot",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
		},
		level = "myg1c_c",
		transition = { gMovieStream, "myg1tran1" },
	},
	{
		planet = "cor",
		side = "rep",
		enemy = "cis",
		space = "spa2c_c",
		transition = { gMovieStream, "sb2tran1" },
		unit = {
			soldier = {
				name = "entity.rep.inf_ep3_rifleman",
				info = "ifs.freeform.purchase.military.sides.rep.soldier",
				sound = "mtg_rep_unit_name_rifleman",
				body = "rep_inf_ep3trooper",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},
			pilot = {
				name = "entity.rep.inf_ep3_pilot",
				info = "ifs.freeform.purchase.military.sides.rep.pilot",
				sound = "mtg_rep_unit_name_pilot",
				body = "rep_inf_ep3spacepilot",
				weapon = "reap_weap_inf_pistol",
				anim_set = rifle_anim_set
			},			
		},
	},
	{
		planet = "fel",
		side = "rep",
		enemy = "cis",
		tech = { "blaster_amplification", "adrenaline" },
		unit = {			
			sniper = {
				name = "entity.rep.inf_ep3_sniper",
				info = "ifs.freeform.purchase.military.sides.rep.sniper",
				sound = "mtg_rep_unit_name_sniper",
				body = "rep_inf_ep3sniper",
				weapon = "rep_weap_inf_sniperrifle",
				anim_set = rifle_anim_set
			},			
		},
		level = "fel1c_c",
		transition = { gMovieStream, "fel1tran1" },
	},
	{
		planet = "kas",
		side = "rep",
		enemy = "cis",
		tech = { "defense_grid" },
		unit = {
			marine = {
				name = "entity.rep.inf_ep3_marine",
				info = "ifs.freeform.purchase.military.sides.rep.marine",
				sound = "mtg_rep_unit_name_marine",
				body = "rep_inf_ep3trooper",
				weapon = "rep_weap_inf_rifle",
				anim_set = rifle_anim_set
			},			
		},
		space = "spa3c_c",
		transition = { gMovieStream, "sb3tran1" },
	},
	{
		planet = "kas",
		side = "rep",
		enemy = "cis",
		level = "kas2c_c",
		transition = { gMovieStream, "kas2tran1" },
	},
	{
		planet = "uta",
		side = "rep",
		enemy = "cis",
		tech = { "reinforcement" },
		unit = {
			officer = {
				name = "entity.rep.inf_ep3_officer",
				info = "ifs.freeform.purchase.military.sides.rep.officer",
				sound = "mtg_rep_unit_name_officer",
				body = "rep_inf_clonecommander",
				weapon = "rep_weap_inf_chaingun",
				anim_set = bazooka_anim_set
			},
		},
		level = "uta1c_c",
		transition = { gMovieStream, "uta1tran1" },
	},
	{
		planet = "cor",
		side = "rep",
		enemy = "cis",
		tech = { "advanced_armor" },
		unit = {
			special = {
				name = "entity.rep.inf_ep3_jettrooper",
				info = "ifs.freeform.purchase.military.sides.rep.special",
				sound = "mtg_rep_unit_name_special",
				body = "rep_inf_ep3jettrooper",
				weapon = "com_weap_inf_torpedo",
				anim_set = rifle_anim_set
			},
		},
		level = "cor1c_c",
		transition = { gMovieStream, "cor1tran1" },
	},
	
	-- republic is now the empire
	
	{
		intro = { gIngameStream, "crawl2" },
		planet = "nab",
		side = "imp",
		enemy = "gar",
		tech = {"supply_cache" },
		unit = {
			soldier = {
				name = "entity.imp.inf_rifleman",
				info = "ifs.freeform.purchase.military.sides.imp.soldier",
				sound = "mtg_imp_unit_name_rifleman",
				body = "imp_inf_stormtrooper",
				weapon = "imp_weap_inf_rifle",
			},
			pilot = {
				name = "entity.imp.inf_pilot",
				info = "ifs.freeform.purchase.military.sides.imp.pilot",
				sound = "mtg_imp_unit_name_pilot",
				body = "imp_inf_pilot",
				weapon = "imp_weap_inf_pistol",
			},
			assault = {
				name = "entity.imp.inf_rocketeer",
				info = "ifs.freeform.purchase.military.sides.imp.assault",
				sound = "mtg_imp_unit_name_rocketeer",
				body = "imp_inf_shocktrooper",
				weapon = "imp_weap_inf_launcher",
			},
			sniper = {
				name = "entity.imp.inf_sniper",
				info = "ifs.freeform.purchase.military.sides.imp.sniper",
				sound = "mtg_imp_unit_name_sniper",
				body = "imp_inf_scout",
				weapon = "imp_weap_inf_sniperrifle",
			},
			marine = {
				name = "entity.imp.inf_marine",
				info = "ifs.freeform.purchase.military.sides.imp.marine",
				sound = "mtg_imp_unit_name_marine",
				body = "imp_inf_stormtrooper",
				weapon = "imp_weap_inf_rifle",
			},
			engineer = {
				name = "entity.imp.inf_engineer",
				info = "ifs.freeform.purchase.military.sides.imp.engineer",
				sound = "mtg_imp_unit_name_engineer",
				body = "imp_inf_gunner",
				weapon = "imp_weap_inf_rifle",
			},
			officer = {
				name = "entity.imp.inf_officer",
				info = "ifs.freeform.purchase.military.sides.imp.officer",
				sound = "mtg_imp_unit_name_officer",
				body = "imp_inf_atatcommander",
				weapon = "com_weap_inf_torpedo",
			},
			special = {
				name = "entity.imp.inf_dark_trooper",
				info = "ifs.freeform.purchase.military.sides.imp.special",
				sound = "mtg_imp_unit_name_special",
				body = "imp_inf_darktrooper",
				weapon = "imp_weap_inf_rifle",
			},
		},
		level = "nab2g_c",
		transition = { gMovieStream, "nab1tran1" },
	},
	{
		planet = "mus",
		side = "imp",
		enemy = "cis",		
		space = "spa4g_c",
		transition = { gMovieStream, "sb4tran1" },
		tech = { "espionage" },
	},
	{
		planet = "mus",
		side = "imp",
		enemy = "cis",
		level = "mus1c_c",
		transition = { gMovieStream, "mus1tran1" },
	},
	{
		planet = "kam",
		side = "imp",
		enemy = "rep",
		tech = { "bacta_refinery" },
		level = "kam1c_c",
		transition = { gMovieStream, "kam1tran1" },
	},
	{
		planet = "dea",
		side = "imp",
		enemy = "all",		
		level = "dea1g_c",
		transition = { gMovieStream, "dea1tran1" },
	},
	{
		planet = "pol",
		side = "imp",
		enemy = "all",		
		level = "pol1g_c",
		transition = { gMovieStream, "pol1tran1" },
	},
	{
		planet = "tat",
		side = "imp",
		enemy = "all",		
		level = "tan1g_c",
		transition = { gMovieStream, "tan1tran1" },
	},
	{
		planet = "yav",
		side = "imp",
		enemy = "all",		
		space = "spa1g_c",
		transition = { gMovieStream, "sb1tran1" },
	},
	{
		planet = "yav",
		side = "imp",
		enemy = "all",
		level = "yav1g_c",
		transition = { gMovieStream, "yav1tran1" },
	},
	{
		planet = "hot",
		side = "imp",
		enemy = "all",		
		level = "hot1g_c",
		transition = { gMovieStream, "hot1tran1" },
	}
}
