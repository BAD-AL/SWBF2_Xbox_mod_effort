-- start balanced galactic civil war
function ifs_freeform_start_gcw(this)

	-- save scenario type
	this.scenario = "gcw"
	
	-- assigned teams
	local ALL = 1
	local IMP = 2
	
	-- GCW init
	ifs_freeform_init_gcw(this, ALL, IMP)

	-- set to versus play
	ifs_freeform_controllers(this, { [0] = ALL, [1] = IMP, [2] = ALL, [3] = IMP })

	-- balanced GCW start
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
			["myg"] = IMP,
			["nab"] = ALL,
			["pol"] = ALL,
			["tat"] = IMP,
			["uta"] = IMP,
			["yav"] = ALL,
		}
		
--		-- create starting starports for each team
--		this.planetPort = {
--			["hot"] = ALL,
--			["cor"] = IMP,
--		}
		
		-- create starting fleets for each team
		this.planetFleet = {
			["hot"] = ALL,
			["cor"] = IMP
		}
	end
end
