-- start ALL campaign
function ifs_freeform_start_all(this)

	-- save scenario type
	this.scenario = "all"
	
	-- assigned teams
	local ALL = 1
	local IMP = 2
	
	-- GCW init
	ifs_freeform_init_gcw(this, ALL, IMP)

	-- set to versus play
	ifs_freeform_controllers(this, { [0] = ALL, [1] = ALL, [2] = ALL, [3] = ALL })

	-- ALL start
	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

	   	-- set team for each planet
   		this.planetTeam = {
			["cor"] = IMP,
			["dag"] = ALL,
			["end"] = IMP,
			["fel"] = IMP,
			["hot"] = ALL,
			["kas"] = IMP,
			["mus"] = IMP,
			["myg"] = IMP,
			["nab"] = IMP,
			["pol"] = IMP,
			["tat"] = IMP,
			["uta"] = IMP,
			["yav"] = ALL,
		}
		
		-- create starting fleets for each team
		this.planetFleet = {}
		for team, start in pairs(this.planetStart) do
			local planet = start[math.random(table.getn(start))]
			this.planetFleet[planet] = team
		end
	end
end
