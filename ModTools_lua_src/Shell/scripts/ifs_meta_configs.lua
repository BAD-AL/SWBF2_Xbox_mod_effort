--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

metagame_configs = 
{
	{
		{owner1=1,owner2=2},
		{owner1=1,owner2=2},
		{owner1=1,owner2=2},
		{owner1=2,owner2=1},
		{owner1=2,owner2=1},
		{owner1=2,owner2=1}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=2},
		{owner1=1,owner2=2},
		{owner1=2,owner2=1},
		{owner1=2,owner2=1},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=2},
		{owner1=2,owner2=1},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1}
	},
	{
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2},
		{owner1=2,owner2=2}
	},
	{
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2}
	},
	{
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1},
		{owner1=2,owner2=2},
		{owner1=1,owner2=1}
	}
}

metagame_config_id=nil
-- Updates visibility (including ownership rings) of the galaxy planets.
function ifs_meta_configs_fnUpdateGalaxy(this)
	local k,v
	local dest = this.galaxy
	local heightper, ygutter = metagame_GetPlanetPreviewSize()
	heightper = (heightper * 0.5) + 3 -- half-scale, to go from -heightper .. heightper

	local NumNormalPlanets = metagame_table.getnumPlanets()

	local pickPlanet

	for k,v in metagame_state.planets do
		local i = v.pickorder

		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			-- Hide/show the entire container by the destroyed flag.
			IFObj_fnSetVis(dest[i], not v.destroyed)
			IFObj_fnSetVis(dest[i].icon, nil)
			IFObj_fnSetVis(dest[i].ring, nil)
			IFObj_fnSetVis(dest[i].cursor, nil)
			IFObj_fnSetVis(dest[i].iconbg,nil)

			IFModel_fnSetOmegaY(dest[i].model,v.RotateSpeed)

			local ModelAlpha,OwnerIconAlpha

			-- Not selected. Dimmer
			OwnerIconAlpha = 0.9 -- 0.7
			IFModel_fnSetDepth(dest[i].model, 0.018)

			IFObj_fnSetAlpha(dest[i].model,0.8)
			IFObj_fnSetAlpha(dest[i].owner1, 0.9)
			if(not v.faction_planet) then
				IFObj_fnSetAlpha(dest[i].owner2, 0.9)
			else
				IFObj_fnSetVis(dest[i].charge_meter,nil)
			end

			IFText_fnSetString(dest[i].label, v.LocalizeName)
			IFText_fnSetString(dest[i].label2, v.LocalizeName)

			metagame_display_fnColorPlanetName(dest[i].label,v)
			metagame_display_fnColorPlanetName(dest[i].hexagon,v)
			metagame_display_fnColorPlanetName(dest[i].model, v, 1)

			if(v.destroyed) then
			else

				-- Update owner for the capital map (always exists)
				if(v.faction_planet) then
					metagame_display_fnUpdateOwnerIcon(dest[i].owner1,v.owner1)
				else
					metagame_display_fnUpdateOwnerIcon(dest[i].owner1,v.owner2) -- capital map
					metagame_display_fnUpdateOwnerIcon(dest[i].owner2,v.owner1) -- staging map
				end

				IFObj_fnSetVis(dest[i].iconbg,nil)

			end -- planet isn't destroyed
		end -- planet is in normal list
	end -- loop over all planets
end


function ifs_meta_configs_Update(this,fDt)
	if(not metagame_config_id) then
		metagame_config_id = 1
		ifs_meta_configs_SetConfiguration()
	end
end

function ifs_meta_configs_InputLeft(this,iJoystick,bFromAI)
end

function ifs_meta_configs_InputRight(this,iJoystick,bFromAI)
end

function ifs_meta_configs_InputUp(this,iJoystick,bFromAI)
	metagame_config_id=metagame_config_id-1
	if(metagame_config_id<=0) then
		metagame_config_id = table.getn(metagame_configs)
	end
	ifs_meta_configs_SetConfiguration()
end

function ifs_meta_configs_InputDown(this,iJoystick,bFromAI)
	metagame_config_id=metagame_config_id+1
	if(metagame_config_id>table.getn(metagame_configs)) then
		metagame_config_id = 1
	end
	ifs_meta_configs_SetConfiguration()
end

function ifs_meta_configs_InputAccept(this,iJoystick,bFromAI)
	ScriptCB_PopScreen()
    ifs_movietrans_PushScreen(ifs_meta_top)
end

function ifs_meta_configs_InputBack(this,iJoystick,bFromAI)
	ScriptCB_PopScreen()
end

function ifs_meta_configs_SetConfiguration()
	local NumNormalPlanets = metagame_table.getnumPlanets()
	for k,v in metagame_state.planets do
		local i = v.pickorder
		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			if(not v.faction_planet) then
				v.owner1 = metagame_configs[metagame_config_id][i-1].owner1
				v.owner2 = metagame_configs[metagame_config_id][i-1].owner2
			end
		end
	end
	ifs_meta_configs_fnUpdateGalaxy(ifs_meta_main)
end

function ifs_meta_configs_Enter(this, bFwd)
	IFObj_fnSetVis(this.title, 1)
	IFObj_fnSetAlpha(this.title, 1.0)
	IFText_fnSetString(this.title,"ifs.meta.main.selconfig")
	IFObj_fnSetVis(this.galaxy, 1)
	IFObj_fnSetAlpha(this.galaxy, 1.0)
	IFObj_fnSetVis(this.AttackItems, nil)
--	IFObj_fnSetVis(this.AttackBonusName, nil)
	IFObj_fnSetVis(this.AttackBonusText, nil)
	metagame_config_id = nil
end
