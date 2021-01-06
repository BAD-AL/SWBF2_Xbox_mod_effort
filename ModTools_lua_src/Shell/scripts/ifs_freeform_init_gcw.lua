-- initialize for Galactic Civil War
ifs_freeform_init_gcw = function(this, ALL, IMP)

	-- common init
	ifs_freeform_init_common(this)

	-- default victory condition (take all planets)
	this:SetVictoryPlanetLimit(nil)
	
	-- associate codes with teams
	this.teamCode = {
		[ALL] = "all",
		[IMP] = "imp"
	}
	
	-- use GCW setup
	this.Setup = function(this)
		-- remove unused planets
		DeleteEntity("geo")
		DeleteEntity("kam")
		DeleteEntity("kam_system")
		DeleteEntity("geo_system")
		DeleteEntity("end_star")
		DeleteEntity("hot_star")
		DeleteEntity("tantive")
					
		-- create the connectivity graph
		this.planetDestination = {
			["cor"] = { "star20", "star18", "star17" },
			["dag"] = { "star05", "star06", "nab" },
			["end"] = { "star20", "star18" },
			["fel"] = { "star13", "yav" },
--			["geo_star"] = { "star07", "star10" },
			["hot"] = { "star02", "star03" },
			["kas"] = { "star12", "star13", "star15", "star17" },
			["kam_star"] = { "tat", "star12", "star13" },
			["mus"] = { "star02", "star04", "star05" },
			["myg"] = { "star18", "star17", "star15" },
			["nab"] = { "star07", "star12", "star17", "dag" },
			["pol"] = { "star04", "star03" },
			["tat"] = { "star10", "kam_star" },
			["uta"] = { "star04", "star05", "star06" },
			["yav"] = { "star15", "fel"},
--			["star01"] = { "hot", "end", "star02" },
			["star02"] = { "hot", "mus" },
			["star03"] = { "hot", "pol" },
			["star04"] = { "mus", "pol", "uta" },
			["star05"] = { "mus", "uta", "dag" },
			["star06"] = { "uta", "dag", "star07" },
			["star07"] = { "nab", "star06", "star10" },
--			["star08"] = { "star06", "geo_star" },
--			["star09"] = { "tat", "geo_star" },
			["star10"] = { "star12", "tat", "star07" },
--			["star11"] = { "tat", "kam_star" },
			["star12"] = { "star10", "kam_star", "nab", "kas" },
			["star13"] = { "kas", "kam_star", "fel" },
--			["star14"] = { "fel", "yav" },
			["star15"] = { "kas", "yav", "myg" },
--			["star16"] = { "yav", "myg" },
			["star17"] = { "cor", "kas", "myg", "nab" },
			["star18"] = { "cor", "myg", "end"},
--			["star19"] = { "end", "star18" },
			["star20"] = { "end", "cor" }
		}

		-- resource value for each planet
		this.planetValue = {
			["cor"] = { victory = 60, defeat = 20, turn = 3 },
			["dag"] = { victory = 60, defeat = 20, turn = 3 },
			["end"] = { victory = 100, defeat = 35, turn = 10 },
			["fel"] = { victory = 50, defeat = 20, turn = 3 },
			["hot"] = { victory = 100, defeat = 35, turn = 10 },
			["kas"] = { victory = 50, defeat = 20, turn = 3 },
			["mus"] = { victory = 60, defeat = 20, turn = 3 },
			["myg"] = { victory = 50, defeat = 20, turn = 3 },
			["nab"] = { victory = 50, defeat = 20, turn = 3 },
			["pol"] = { victory = 50, defeat = 20, turn = 3 },
			["tat"] = { victory = 50, defeat = 20, turn = 3 },
			["uta"] = { victory = 50, defeat = 20, turn = 3 },
			["yav"] = { victory = 60, defeat = 20, turn = 3 },
		}
		
		this.spaceValue = {
			victory = 30, defeat = 10,
		}
		
		-- mission to launch for each planet
		this.spaceMission = {
			["con"] = { "spa1g_ass", "spa8g_ass", "spa9g_ass" }
		}
		this.planetMission = {
			["cor"] = {
				["con"] = "cor1g_con",
--				["ctf"] = "cor1g_ctf",
			},
			["dag"] = {
				["con"] = "dag1g_con",
--				["ctf"] = "dag1g_ctf",
			},
			["end"] = {
				["con"] = "end1g_con",
--				["1flag"] = "end1g_1flag",
			},
			["fel"] = {
				["con"] = "fel1g_con",
--				["1flag"] = "fel1g_1flag",
			},
			["hot"] = {
				["con"] = "hot1g_con",
--				["1flag"] = "hot1g_1flag",
			},
			["kas"] = {
				["con"] = "kas2g_con",
--				["ctf"] = "kas2g_ctf",
			},
			["mus"] = {
				["con"] = "mus1g_con",
--				["ctf"] = "mus1g_ctf",
			},
			["myg"] = {
				["con"] = "myg1g_con",
--				["ctf"] = "myg1g_ctf",
			},
			["nab"] = {
				["con"] = "nab2g_con",
--				["ctf"] = "nab2g_ctf",
			},
			["pol"] = {
				["con"] = "pol1g_con",
--				["ctf"] = "pol1g_ctf",
			},
			["tat"] = {
				["con"] = "tat2g_con",
--				["ctf"] = "tat2g_ctf",
			},
			["uta"] = {
				["con"] = "uta1g_con",
--				["ctf"] = "uta1g_ctf",
			},
			["yav"] = {
				["con"] = "yav1g_con",
--				["1flag"] = "yav1g_1flag",
			},
		}
		
		-- associate names with teams
		this.teamName = {
			[0] = "",
			[ALL] = "common.sides.all.name",
			[IMP] = "common.sides.imp.name"
		}
		
		-- associate names with team bases
		this.baseName = {
			[ALL] = "ifs.freeform.base.all",
			[IMP] = "ifs.freeform.base.imp"
		}
		
		-- associate names with team fleets
		this.fleetName = {
			[0] = "",
			[ALL] = "ifs.freeform.fleet.all",
			[IMP] = "ifs.freeform.fleet.imp"
		}
		
		-- associate entity class with team fleets
		this.fleetClass = {
			[ALL] = "gal_prp_moncalamaricruiser",
			[IMP] = "gal_prp_stardestroyer"
		}
		
		-- associate icon textures with team fleets
		this.fleetIcon = {
			[ALL] = "all_fleet_normal_icon",
			[IMP] = "imp_fleet_normal_icon"
		}
		this.fleetStroke = {
			[ALL] = "all_fleet_normal_stroke",
			[IMP] = "imp_fleet_normal_stroke"
		}
		
		-- set the explosion effect for each team
		this.fleetExplosion = {
			[ALL] = "gal_sfx_moncalamaricruiser_exp",
			[IMP] = "gal_sfx_stardestroyer_exp"
		}
		
		-- team base planets
		this.planetBase = {
			[ALL] = "hot",
			[IMP] = "end"
		}
		
		-- team potential starting locations
		this.planetStart = {
			[ALL] = { "hot", "yav", "dag" },
			[IMP] = { "end", "cor", "mus" }
		}
	end
end
