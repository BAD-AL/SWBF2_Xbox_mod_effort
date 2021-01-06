--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Sorta-stub screen; Puts text up about a planet about to get whacked
-- by the deathstar. 

ifs_meta_deathstar = NewIFShellScreen {
	fShowTime1 = 5.0, -- Seconds the "X is about to realize the power of the deathstar" is shown
	fShowTime2 = 2.0, -- Seconds the "Y destroyed" is shown.

--  bg_texture = "gc_bg",
	nologo = 1,
	bNohelptext = 1, -- Nothing to see on this screen
    movieIntro      = nil,
    movieBackground = nil,

	AttackerStr = NewIFText {
--		string = "Debug Mode", -- filled in on entry
		font = "gamefont_large",
		textw = 460,
		texth = 200,
		ScreenRelativeX = 0.5, -- center filled in later based on screensize
		ScreenRelativeY = 0.0,
	},

	DeadPlanetStr = NewIFText {
--		string = "Debug Mode", -- filled in on entry
		font = "gamefont_large",
		textw = 460,
		y = 220,
		ScreenRelativeX = 0.5, -- center filled in later based on screensize
		ScreenRelativeY = 0.0,
	},


	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
		if(bFwd) then
			this.CurTime = this.fShowTime1
			this.bShowedName = nil

			local TempUStr

			local VictimTeam = metagame_state[string.format("team%d",3-metagame_state.planets.endor.owner1)]
			local VictimTeamName = ScriptCB_getlocalizestr(VictimTeam.teamname2)
			TempUStr = ScriptCB_usprintf("ifs.meta.battle.deathstar1",VictimTeamName)
			IFText_fnSetUString(this.AttackerStr,TempUStr)

			local DestPlanet = metagame_state.planets[metagame_state.pickplanet]
			local DestPlanetName = ScriptCB_getlocalizestr(DestPlanet.LocalizeName)
			TempUStr = ScriptCB_usprintf("ifs.meta.battle.deathstar2",DestPlanetName)
			IFText_fnSetUString(this.DeadPlanetStr,TempUStr)

			IFObj_fnSetVis(this.DeadPlanetStr,nil) -- off until appropriate time
		end
	end,

	Update = function(this, fDt)
		if(ScriptCB_InNetSession()) then
			ScriptCB_UpdateMPMetagame()
		end

		gIFShellScreenTemplate_fnUpdate(this, fDt) -- call default base class
		this.CurTime = this.CurTime - fDt
		if(this.CurTime < 0) then
			if(not this.bShowedName) then
				this.bShowedName = 1
				this.CurTime = this.fShowTime2
				IFObj_fnSetVis(this.DeadPlanetStr,1)
			else
				-- All done. Back out
				ScriptCB_PopScreen()
			end
		end
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this) 
	end,
	Input_Back = function(this)
  end,
	Input_GeneralLeft = function(this)
	end,
	Input_GeneralRight = function(this)
	end,
	Input_GeneralUp = function(this)
	end,
	Input_GeneralDown = function(this)
	end,
}

AddIFScreen(ifs_meta_deathstar,"ifs_meta_deathstar")
