-- start IMP campaign
function ifs_freeform_start_imp(this)

	-- save scenario type
	this.scenario = "imp"
	
	-- assigned teams
	local ALL = 1
	local IMP = 2
	
	-- GCW init
	ifs_freeform_init_gcw(this, ALL, IMP)
	
	-- set to co-op play
	ifs_freeform_controllers(this, { [0] = IMP, [1] = IMP, [2] = IMP, [3] = IMP })

	-- IMP start
	this.Start = function(this)
		-- perform common start
		ifs_freeform_start_common(this)

	   	-- set team for each planet
   		this.planetTeam = {
			["cor"] = IMP,
			["dag"] = ALL,
			["end"] = IMP,
			["fel"] = ALL,
			["hot"] = ALL,
			["kas"] = ALL,
			["mus"] = IMP,
			["myg"] = ALL,
			["nab"] = ALL,
			["pol"] = ALL,
			["tat"] = ALL,
			["uta"] = ALL,
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
