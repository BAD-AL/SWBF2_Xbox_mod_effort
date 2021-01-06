function ifs_freeform_init_custom(this, prefs)
	-- save streamlined prefs
	this.custom = {
		iEra = prefs.iEra,
		iVictoryType = prefs.iVictoryType
	}
	
	-- apply era
	if prefs.iEra == 1 then
		ifs_freeform_init_cw(ifs_freeform_main, 1, 2)
	elseif prefs.iEra == 2 then
		ifs_freeform_init_gcw(ifs_freeform_main, 1, 2)
	end
	
	-- apply victory
	-- assumption: SetVictory...() doesn't require anything from Setup()
	print("VictoryType", prefs.iVictoryType)
	if prefs.iVictoryType == 1 then
		ifs_freeform_main:SetVictoryPlanetLimit(nil)
	elseif prefs.iVictoryType == 2 then
		ifs_freeform_main:SetVictoryBaseCapture(this.planetBase[1], this.planetBase[2])
	elseif prefs.iVictoryType == 3 then
		ifs_freeform_main:SetVictoryTurnLimit(prefs.iVictoryTurn)
		this.custom.iVictoryTurn = prefs.iVictoryTurn
	elseif prefs.iVictoryType == 4 then
		ifs_freeform_main:SetVictoryResourceLimit(prefs.iVictoryCredits)
		this.custom.iVictoryCredits = prefs.iVictoryCredits
	end
end
