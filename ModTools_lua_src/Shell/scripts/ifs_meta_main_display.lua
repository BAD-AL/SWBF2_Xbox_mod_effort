--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- ifs_meta_main_display.lua
-- Contains code for visual changes in interface related to
-- the metagame

--------------------------------------------------------------------

z_pos_base = 100

--------------------------------------------------------------------

function metagame_display_fnUpdateMainTitle(this)
	--print( "+++ gMetagameCurrentPage  =", gMetagameCurrentPage )
	local SpacesUStr = ScriptCB_tounicode(": ")

	if(gMetagameCurrentPage == 1) then
		if(not metagame_state.applyingbonus) then
			local CurTeamName = ScriptCB_getlocalizestr(metagame_state[string.format("team%d",metagame_state.pickteam)].teamname)
			-- Generate this with ScriptCB_getlocalizestr() or ScriptCB_tounicode()
			local NewTitle = ScriptCB_getlocalizestr("ifs.meta.Main.selattack")

			-- "common.pctspcts" is a localization database entry with "%s %s" as its contents
			local ShowUStr = ScriptCB_usprintf("common.pctspcts", CurTeamName, SpacesUStr)
			ShowUStr = ScriptCB_usprintf("common.pctspcts", ShowUStr, NewTitle)
			IFText_fnSetUString( this.title, ShowUStr )
		else
			--print( "++metagame_state.applyingbonus", metagame_state.applyingbonus )
			local tname = metagame_state[string.format("team%d",metagame_state.pickteam)].teamname
			local CurTeamName = ScriptCB_getlocalizestr(tname)
			local NewTitle
			if( tname == "common.sides.all.name" ) then
				NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.apply_all")
			elseif( tname == "common.sides.imp.name" ) then
				NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.apply_imp")
			elseif( tname == "common.sides.rep.name" ) then
				NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.apply_rep")
			elseif( tname == "common.sides.cis.name" ) then
				NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.apply_cis")
			end			
			local ShowUStr = ScriptCB_usprintf("common.pctspcts", CurTeamName, SpacesUStr)
			ShowUStr = ScriptCB_usprintf("common.pctspcts", ShowUStr, NewTitle)
			IFText_fnSetUString( this.title, ShowUStr )		
		end
	elseif (gMetagameCurrentPage == 2) then
	elseif (gMetagameCurrentPage == 3) then
		local CurTeamName = ScriptCB_getlocalizestr(metagame_state[string.format("team%d",metagame_state.pickteam)].teamname)
		-- Generate this with ScriptCB_getlocalizestr() or ScriptCB_tounicode()
		local NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.select")

		-- "common.pctspcts" is a localization database entry with "%s %s" as its contents
		local ShowUStr = ScriptCB_usprintf("common.pctspcts", CurTeamName, SpacesUStr)
		ShowUStr = ScriptCB_usprintf("common.pctspcts", ShowUStr, NewTitle)
		IFText_fnSetUString( this.title, ShowUStr )
	elseif (gMetagameCurrentPage == 4) then
		local CurTeamName = ScriptCB_getlocalizestr(metagame_state[string.format("team%d",3-metagame_state.pickteam)].teamname)
		-- Generate this with ScriptCB_getlocalizestr() or ScriptCB_tounicode()
		local NewTitle = ScriptCB_getlocalizestr("ifs.meta.Bonus.select")

		-- "common.pctspcts" is a localization database entry with "%s %s" as its contents
		local ShowUStr = ScriptCB_usprintf("common.pctspcts", CurTeamName, SpacesUStr)
		ShowUStr = ScriptCB_usprintf("common.pctspcts", ShowUStr, NewTitle)
		IFText_fnSetUString( this.title, ShowUStr )
	end
end

-- play planet name / planet bonus voice over
gPrevStreamVO     = ""
gPrevMetagamePage = 0
function metagame_display_PlanetPlayVO(teamname, mapluafile)
    local mapname
    
    -- make sure this VO is played after page change
    if (gPrevMetagamePage == gMetagameCurrentPage) then
    
        -- special skill selection page ?
	    if (gMetagameCurrentPage == 3) or (gMetagameCurrentPage == 4) then
				mapname    = strlower(string.sub(mapluafile, 1, 3))
		    actiontype = "_bonus"
	    else
	        -- attack selection page 
		    actiontype = "_select"
				mapname    = strlower(string.sub(mapluafile, 1, 3))
	    end
	    
	    local streamname = teamname .. "_" .. mapname .. actiontype
	    
	    --print( "+++streamname:", streamname )
	    --print( "+++gPrevStreamVO:", gPrevStreamVO )
	    --print( "+++ifs_meta_main.NoPromptSave:", ifs_meta_main.NoPromptSave )
	    --print( "+++ifs_meta_movie.isEnabled:", ifs_meta_movie.isEnabled )
	    
	    -- make sure the VO isn't played again and again ... etc
	    if (streamname ~= gPrevStreamVO) then
			if(ifs_meta_main.NoPromptSave) then
				if( not ifs_meta_movie.isEnabled ) then		-- don't say a word during movie is played
					print("PlanetPlayVO " .. streamname)
					ScriptCB_ShellPlayDelayedStream(streamname, 0, 1.0)
					gPrevStreamVO = streamname
				end
			end
	    end
    end
    gPrevMetagamePage = gMetagameCurrentPage
end

-- SECRET BASE BONUSES VO define
base_bonus_active = 
{
	cis = { name = "cis_geonosis_activate_blockade" },
	all = { name = "all_hoth_activate_rebellion" },
	rep = { name = "rep_kamino_activate_insurgence" },
	imp = { name = "imp_endor_activate_deathstar" },
}

base_bonus_target = 
{
	cis = { name = "cis_geonosis_choose_blockade_target" },
	all = { name = "all_hoth_choose_rebellion_target" },
	rep = { name = "rep_kamino_choose_insurgence_target" },
	imp = { name = "imp_endor_choose_deathstar_target" },
}

base_bonus_complete = 
{
	cis = { name = "cis_geonosis_blockade_complete" },
	all = { name = "all_hoth_rebellion_complete" },
	rep = { name = "rep_kamino_insurgence_complete" },
	imp = { name = "imp_endor_deathstar_complete" },
}

function metagame_display_fnPageChanged(this)

    local CurTeam = metagame_state_fnGetCurrentTeam(this)
    
    if (not ScriptCB_IsMetagameStateSaved()) then
        StopAudioStream(gVoiceOverStream, 0);
    end
    
	-- Now, turn on items for the new page
	if(gMetagameCurrentPage == 1) then		
        if (not CurTeam.aicontrol and not ScriptCB_IsMetagameStateSaved()) then
			if(ifs_meta_main.NoPromptSave) then
				if( not ifs_meta_movie.isEnabled ) then		-- don't say a word during movie is played
					local vo_name = nil
					
					local BattleResult = ScriptCB_GetLastBattleVictory()
					if( BattleResult > 0 ) then
						ifs_meta_main_PlayBattleOverVO( this, BattleResult )
					end
															
					if(metagame_state.applyingbonus) then
						vo_name = base_bonus_target[CurTeam.shortname].name
						print("Play Bonus VO ", vo_name )
					else						
						vo_name = CurTeam.shortname .. "_planet_select"
						print("Play Attack VO ", vo_name )
					end					
                    ScriptCB_ShellPlayDelayedStream(vo_name, 0, 0)
				end
			end
	    end
	    metagame_display_fnSetMapPreviews(this)
	
		IFObj_fnSetVis(Metagame_Popup_PlanetActivated,nil)
		metagame_display_fnUpdateGalaxyPlanets(this)
		metagame_display_fnUpdatePlanetInfo(this)
		metagame_display_fnHiliteCurrentButton(this)
		metagame_display_fnUpdateMainTitle(this)

		AnimationMgr_AddAnimation(this.galaxy, {fStartAlpha = 0, fEndAlpha = 1,})

		IFObj_fnSetVis( this.AttackItems, 1 )
		IFObj_fnSetAlpha(this.AttackItems.ModelC, 1, 1) -- constant for this item

		metagame_display_fnUpdatePage1ZPos( this, nil)
		
	elseif (gMetagameCurrentPage == 2) then
		-- Going to attack planet stage. Redo selections if were just on
		-- war status page (but not if we back up to the page)

		metagame_display_fnHiliteCurrentButton(this)
--		AnimationMgr_AddAnimation(this.AttackItems, { fStartAlpha = 0, fEndAlpha =1,})

		-- zoom animation for selected planet
		local Planet = metagame_state.planets[metagame_state.pickplanet]
--		IFText_fnSetString( this.title, Planet.LocalizeName )
--		AnimationMgr_AddAnimation(this.AttackItems.ModelC,
--								{ fTotalTime = 0.5,
--								fStartAlpha = 0, fEndAlpha = 1,
--								fStartX = this.galaxy[Planet.pickorder].x,
--								fEndX   = 0,
--								fStartY = this.galaxy[Planet.pickorder].y,
--								fEndY   = 0,
--								fStartW = this.fSmallScale,
--								fStartH = this.fSmallScale,
--								fEndW   = this.fLargeScale * 1.5,
--								fEndH   = this.fLargeScale * 1.5,
--								})

		metagame_display_fnUpdatePlanetInfo(this)

		-- fade out the galaxy for page 2
--		IFObj_fnSetAlpha( this.galaxy, 0.5, 0.5 )

		-- disable the other attack items for planet select page
		-- invisible AttackItems.ItemC and MapName
--		IFObj_fnSetVis( this.AttackItems.ItemC, nil )
--		IFObj_fnSetVis( this.AttackItems.MapName, nil )
--		IFObj_fnSetVis( this.AttackItems.PlanetName, nil )

--		metagame_display_fnUpdatePage1ZPos( this, 1)
	elseif ((gMetagameCurrentPage == 3) or ((gMetagameCurrentPage == 4))) then

		metagame_display_fnUpdateGalaxyPlanets(this)
		metagame_display_fnUpdateMainTitle(this)
		metagame_display_fnHiliteCurrentButton(this)

		IFObj_fnSetVis(this.TopBonus.ItemL2,nil)
		IFObj_fnSetVis(this.BotBonus.ItemL2,nil)
		IFObj_fnSetVis(this.TopBonus.ItemR2,nil)
		IFObj_fnSetVis(this.BotBonus.ItemR2,nil)

		--IFObj_fnSetVis(this.AttackBonusName, nil)
		--IFObj_fnSetVis(this.AttackBonusImage, nil)
		--IFObj_fnSetVis(this.AttackBonusText, nil)

		AnimationMgr_AddAnimation(this.TopBonus, { fTotalTime = 0.6, fStartAlpha = 0, fEndAlpha = 1, })
		AnimationMgr_AddAnimation(this.BotBonus, { fTotalTime = 0.6, fStartAlpha = 0, fEndAlpha = 1, })
		metagame_display_fnUpdatePlanetInfo(this)
		
		if (not CurTeam.aicontrol) then
			if( not ifs_meta_movie.isEnabled ) then		-- don't say a word during movie is played
				print("Play VO " .. CurTeam.shortname .. "_bonus_select")
                ScriptCB_ShellPlayDelayedStream(CurTeam.shortname .. "_bonus_select", 0, 0)
			end
        end
        
        metagame_display_fnSetBonusAttackMap(this, 1)

--		IFObj_fnSetAlpha( this.AttackItems.ModelC, 0.5, 0.5 ) -- constant for this item
	end

	-- always show galaxy as background
	IFObj_fnSetVis( this.galaxy, 1 )
end

-- For a cluster of items in Dest, a list, and a selected index, sets
-- visibility/textures
function metagame_display_fnSetItemTextures(dest,List,Idx)
	local Count = table.getn(List)
	if(Count < 2) then
		-- Just 1 map. Hide the rest.
		IFObj_fnSetVis(dest.ItemL,nil)
		IFObj_fnSetVis(dest.ItemR,nil)
		IFObj_fnSetVis(dest.ItemL2,nil)
		IFObj_fnSetVis(dest.ItemR2,nil)
	elseif (Count < 3) then
		-- Just 2 maps. Hide R or L depending on where the current one is
		-- disable bonus itemsL, R
		--IFObj_fnSetVis(dest.ItemL,(Idx > 1))
		--IFObj_fnSetVis(dest.ItemR,(Idx < 2))
		IFObj_fnSetVis(dest.ItemL,nil)
		IFObj_fnSetVis(dest.ItemR,nil)
		IFObj_fnSetVis(dest.ItemL2,nil)
		IFObj_fnSetVis(dest.ItemR2,nil)

		-- Simpler (in Lua) to set the other ones to the opposite texture.
		local OppositeTex = List[3-Idx].texture
		IFMapPreview_fnSetTexture(dest.ItemL,OppositeTex)
		IFMapPreview_fnSetTexture(dest.ItemR,OppositeTex)

	else
		-- disable bonus itemsL, R
		--IFObj_fnSetVis(dest.ItemL,1)
		--IFObj_fnSetVis(dest.ItemR,1)
		IFObj_fnSetVis(dest.ItemL,nil)
		IFObj_fnSetVis(dest.ItemR,nil)
		IFObj_fnSetVis(dest.ItemL2,nil)
		IFObj_fnSetVis(dest.ItemR2,nil)

		-- Modulo-arithmetic is harder when lua is 1-based :(
		local Idx2 = Idx - 1
		if(Idx2 < 1) then
			Idx2 = Count
		end
		IFMapPreview_fnSetTexture(dest.ItemL,List[Idx2].texture)
		Idx2 = Idx2 - 1
		if(Idx2 < 1) then
			Idx2 = Count
		end
		IFMapPreview_fnSetTexture(dest.ItemL2,List[Idx2].texture)
		Idx2 = Idx + 1
		if(Idx2 > Count) then
			Idx2 = 1
		end
		IFMapPreview_fnSetTexture(dest.ItemR,List[Idx2].texture)
		Idx2 = Idx2 + 1
		if(Idx2 > Count) then
			Idx2 = 1
		end
		IFMapPreview_fnSetTexture(dest.ItemR2,List[Idx2].texture)
	end

	-- Always update center map
	if(Count >= 1) then
		IFMapPreview_fnSetTexture(dest.ItemC, List[Idx].texture)
	end
end

-- For a cluster of items in Dest, a list, and a selected index, sets
-- visibility/meshes
function metagame_display_fnSetItemMeshes(dest,List,Idx)
	local Count = table.getn(List)
	-- Always update center map
	if(Count >= 1) then
		IFModel_fnSetMsh(dest.ModelC, List[Idx].Mesh)
--		IFMapPreview_fnSetTexture(dest.ItemC, List[Idx].texture)
		if(gPlatformStr == "PC") then
			IFModel_fnSetOmegaY(dest.ModelC,List[Idx].OmegaY/2)
		else
			IFModel_fnSetOmegaY(dest.ModelC,List[Idx].OmegaY)
		end
	end
end

-- Sets the current set of map previews based on gMetaAttackableList
-- and this.iMapSelectIdx
function metagame_display_fnSetMapPreviews(this)
	metagame_display_fnSetItemMeshes(this.AttackItems,gMetaAttackableList,this.iMapSelectIdx)
	IFModel_fnSetDepth(this.AttackItems.ModelC, 0.12 )
	if(table.getn(gMetaAttackableList) >= 1) then
		local Selection = gMetaAttackableList[this.iMapSelectIdx]
		IFText_fnSetString(this.AttackItems.PlanetName,Selection.PlanetLocName)
--		gButtonWindow_fnSetText(this.AttackBonusName, Selection.BonusName )
		gButtonWindow_fnSetText(this.InfoBox, Selection.BonusName )
		IFText_fnSetString(this.AttackBonusText, Selection.BonusText )
		--IFMapPreview_fnSetTexture( this.AttackBonusImage, Selection.BonusImage )

		local MapName = Selection.mapluafile
		local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
		local origMapName = MapName
		MapName = MapName .. strupper(CurTeam.char)
		MapName = string.sub(MapName,1,4)
		local TargetPlanet = metagame_state.planets[metagame_state.pickplanet]
		if(gMetagameCurrentPage == 1) then
			if(metagame_state.applyingbonus) then
				TargetPlanet = metagame_state.planets[gBonusPlanetSelect]
			else
				TargetPlanet = metagame_state.planets[gAttackPlanetSelect]
			end
		else
				TargetPlanet = metagame_state.planets[metagame_host_state.gAttackPlanet]
		end
		local Map12Char = string.sub(MapName,4,4) -- 1 or 2
		local MapExtension = "MapName" .. Map12Char

		local selectTeam = metagame_state_fnGetCurrentTeam()
		if (not selectTeam.aicontrol and not ScriptCB_IsMetagameStateSaved()) then
			metagame_display_PlanetPlayVO(selectTeam.shortname, Selection.mapluafile)
		end
	else
		gButtonWindow_fnSetText( this.InfoBox, "common.none" )
		IFText_fnSetString( this.AttackBonusText, "ifs.meta.Bonus.nobonus" )
		IFObj_fnSetVis( this.AttackBonusText, 1 )
	end
	
--	metagame_display_fnUpdatePlanetInfo(this)
end

-- Sets the current set of map previews based on gMetaAttackableList by Planet Name
function metagame_display_fnSetBonusAttackMap(this, dontPlayVO)
	local k,v
	local map_select_idx = nil
	local planet_name = nil
	
	if( (gMetagameCurrentPage == 3) ) then
		-- attacker's bonus
		if( metagame_state.pickteam == 1 ) then
			planet_name = gMetaTopBonusList[gTopBonusIdx].name
		else
			planet_name = gMetaBotBonusList[gBotBonusIdx].name
		end
	elseif( (gMetagameCurrentPage == 4) ) then
		-- defender's bonus
		if( metagame_state.pickteam == 1 ) then
			planet_name = gMetaBotBonusList[gBotBonusIdx].name
		else
			planet_name = gMetaTopBonusList[gTopBonusIdx].name			
		end
	end	
	
	if( (not planet_name) or (planet_name == "none") ) then
		IFObj_fnSetVis(this.AttackItems.ModelC, nil)
		IFObj_fnSetVis(this.AttackItems.PlanetName, nil)
--		IFObj_fnSetVis(this.AttackBonusName, nil)		
		--IFObj_fnSetVis(this.AttackBonusImage, nil)		
		IFObj_fnSetVis(this.AttackBonusText, nil)		
		gButtonWindow_fnSetText( this.InfoBox, "common.none" )
		IFText_fnSetString(this.AttackBonusText, "ifs.meta.Bonus.nobonus" )
		IFObj_fnSetVis( this.AttackBonusText, 1 )
	else
--		IFObj_fnSetVis(this.AttackBonusName, 1)
		IFObj_fnSetVis(this.AttackBonusText, 1)
		for k,v in metagame_state.planets do
			if( k == planet_name ) then
				local Mesh = "planet_" .. v.MapName
				local OmegaY = v.RotateSpeed
				if(gPlatformStr == "PC") then
					OmegaY = OmegaY / 2
				end

				PlanetLocName = v.LocalizeName .. "_wide"
				-- if it's a new selection
				if( this.AttackItems.PlanetName ~= PlanetLocName ) then			
					IFModel_fnSetMsh( this.AttackItems.ModelC, Mesh )
					IFModel_fnSetOmegaY( this.AttackItems.ModelC, OmegaY )
					IFModel_fnSetDepth(this.AttackItems.ModelC, 0.12 )
					IFText_fnSetString( this.AttackItems.PlanetName, PlanetLocName )
--					gButtonWindow_fnSetText( this.AttackBonusName, v.ShortBonusText )
					gButtonWindow_fnSetText( this.InfoBox, v.ShortBonusText )
					IFText_fnSetString( this.AttackBonusText, v.LongBonusText )
					--IFMapPreview_fnSetTexture( this.AttackBonusImage, "bonus_" .. v.MapName )
					IFObj_fnSetVis(this.AttackItems.ModelC, 1)
					IFObj_fnSetVis(this.AttackItems.PlanetName, 1)
					
					local selectTeam = metagame_state_fnGetCurrentTeam()
                    if (not selectTeam.aicontrol and not dontPlayVO) then
                        metagame_display_PlanetPlayVO(selectTeam.shortname, planet_name)
                    end
				end
			end		
		end
	end
end

-- Sets the current set of bonus previews in dest based on the list
-- passed in and the index in there selected
function metagame_display_fnShowBonuses(dest,BonusList,Idx)
	metagame_display_fnSetItemTextures(dest,BonusList,Idx)

	if(table.getn(BonusList) >= 1) then
		-- fill in bonus texts here
		local Selection = BonusList[Idx]
		IFText_fnSetString(dest.PlanetName,Selection.BonusName)
		IFText_fnSetString(dest.BonusName,Selection.PlanetName)
	end

end

-- For a cluster of items in Dest, a direction to animate, small & large sizes,
-- and a visible count, animates them sliding left or right. FIXME: this is
-- nearly-duplicated code, seems kinda wasteful
function 
metagame_display_fnAnimateItems(dest,fDir,fSmallSize,fLargeSize,fYOffset,Count)
	local fAnimTime = 0.3
	-- Set up animations
	if(fDir > 0) then
		-- move things right
		AnimationMgr_AddAnimation(dest.ItemL,
		{ fTotalTime = fAnimTime,fStartAlpha = 0, fEndAlpha = 1,
			fStartX = -(fLargeSize + 4 * fSmallSize), fEndX = -(fLargeSize + 1 * fSmallSize),
			fStartY = fYOffset, fEndY = fYOffset,})

		dest.ItemL:fnSetSize(fSmallSize,fSmallSize) -- constant param
		AnimationMgr_AddAnimation(dest.ItemC,
			{ fTotalTime = fAnimTime,
				fStartX = -(fLargeSize + fSmallSize),
				fEndX   = 0,
				fStartY = fYOffset,
				fEndY   = -fYOffset,
				fStartW = fSmallSize,
				fStartH = fSmallSize,
				fEndW   = fLargeSize,
				fEndH   = fLargeSize,
			})
		IFObj_fnSetAlpha(dest.ItemC,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ItemR,
			{ fTotalTime = fAnimTime,
				fStartX = 0,
				fEndX   = (fLargeSize + fSmallSize),
				fStartY = -fYOffset,
				fEndY   = fYOffset,
				fStartW = fLargeSize,
				fStartH = fLargeSize,
				fEndW   = fSmallSize,
				fEndH   = fSmallSize,
			})
		IFObj_fnSetAlpha(dest.ItemR,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ItemR2,
			{ fTotalTime = fAnimTime,
				fStartAlpha = 1,
				fEndAlpha   = 0,
				fStartX = (fLargeSize + 1 * fSmallSize),
				fEndX   = (fLargeSize + 4 * fSmallSize),
				fStartY = fYOffset,
				fEndY   = fYOffset,
			})
		dest.ItemR2:fnSetSize(fSmallSize,fSmallSize) -- constant param
		IFObj_fnSetVis(dest.ItemR2,Count > 2)
	else
		-- Move things left

		AnimationMgr_AddAnimation(dest.ItemR,
			{ fTotalTime = fAnimTime,
				fStartAlpha = 0, fEndAlpha = 1,
				fStartX = (fLargeSize + 4 * fSmallSize),
				fEndX =   (fLargeSize + 1 * fSmallSize),
				fStartY = fYOffset,
				fEndY =   fYOffset,
			})
		dest.ItemR:fnSetSize(fSmallSize,fSmallSize) -- constant param

		AnimationMgr_AddAnimation(dest.ItemC,
			{ fTotalTime = fAnimTime,
				fStartX = (fLargeSize + fSmallSize),
				fEndX   = 0,
				fStartY = fYOffset,
				fEndY   = -fYOffset,
				fStartW = fSmallSize,
				fStartH = fSmallSize,
				fEndW   = fLargeSize,
				fEndH   = fLargeSize,
			})
		IFObj_fnSetAlpha(dest.ItemC,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ItemL,
			{ fTotalTime = fAnimTime,
				fStartX = 0,
				fEndX   = -(fLargeSize + fSmallSize),
				fStartY = -fYOffset,
				fEndY   = fYOffset,
				fStartW = fLargeSize,
				fStartH = fLargeSize,
				fEndW   = fSmallSize,
				fEndH   = fSmallSize,
			})
		IFObj_fnSetAlpha(dest.ItemL,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ItemL2,
			{ fTotalTime = fAnimTime,
				fStartAlpha = 1,
				fEndAlpha   = 0,
				fStartX = -(fLargeSize + 1 * fSmallSize),
				fEndX   = -(fLargeSize + 4 * fSmallSize),
				fStartY = fYOffset,
				fEndY   = fYOffset,
			})
		dest.ItemL2:fnSetSize(fSmallSize,fSmallSize) -- constant param
		IFObj_fnSetVis(dest.ItemL2,Count > 2)
	end
end

-- Helper function, turns button bars on/off
function metagame_display_fnHiliteCurrentButton(this)
	local A1,A2,A3,A4 = 0.4,0.4,0.4,0.4
	local bPage1,bPage2,bPage3,bPage4 = nil,nil,nil,nil

	-- Default these off, we might turn them on below
	IFObj_fnSetVis(this.TopBonus,nil)
	IFObj_fnSetVis(this.BotBonus,nil)
--	IFObj_fnSetVis(this.TopBonusLocked, nil)
--	IFObj_fnSetVis(this.BotBonusLocked, nil)

	if(gMetagameCurrentPage == 1) then
		A1 = 1.0
		bPage1 = 1
	elseif (gMetagameCurrentPage == 2) then
--		metagame_display_fnSetMapPreviews(this)
		A2 = 1.0
		bPage2 = 1
	elseif (gMetagameCurrentPage == 3) then
		-- Attacker chooses their bonus first.
		if(metagame_state.pickteam == 1) then
			-- Top player is attacking
			metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)

--			TitleBarLabel_fnSetString(this.TopBonusLocked,"ifs.meta.Bonus.locked")
			IFObj_fnSetVis(this.TopBonus, not this.Player1Choice)
--			IFObj_fnSetVis(this.TopBonusLocked, this.Player1Choice)

			--TitleBarLabel_fnSetString(this.BotBonusLocked,"ifs.meta.main.defender_wait")
			--IFObj_fnSetVis(this.BotBonusLocked, 1)
--			IFObj_fnSetVis(this.BotBonusLocked, nil)
			IFObj_fnSetVis(this.BotBonus, nil)
		else
			-- bottom player is attacking
			metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)

--			TitleBarLabel_fnSetString(this.BotBonusLocked,"ifs.meta.Bonus.locked")
			IFObj_fnSetVis(this.BotBonus, not this.Player2Choice)
--			IFObj_fnSetVis(this.BotBonusLocked, this.Player2Choice)

			--TitleBarLabel_fnSetString(this.TopBonusLocked,"ifs.meta.main.defender_wait")
			--IFObj_fnSetVis(this.TopBonusLocked, 1)
--			IFObj_fnSetVis(this.TopBonusLocked, nil)
			IFObj_fnSetVis(this.TopBonus, nil)
		end

		A3 = 1.0
		bPage3 = 1
	elseif (gMetagameCurrentPage == 4) then
		A4 = 1.0
		bPage4 = 1

		-- Defender chooses their bonus second.
		if(metagame_state.pickteam == 1) then
			-- Show attacker's (top) choice
			local ChoiceUStr = ScriptCB_getlocalizestr( "common.none" )
			if(this.Player1Choice) then
				ChoiceUStr = ScriptCB_getlocalizestr(gMetaTopBonusList[this.Player1Choice].BonusName)
			end
			local ShowUStr = ScriptCB_usprintf("ifs.meta.main.attacker_choice",ChoiceUStr)
--			TitleBarLabel_fnSetUString(this.TopBonusLocked,ShowUStr)
			IFObj_fnSetVis(this.TopBonus, nil)
--			IFObj_fnSetVis(this.TopBonusLocked, 1)

			metagame_display_fnShowBonuses(this.BotBonus,gMetaBotBonusList,gBotBonusIdx)
--			TitleBarLabel_fnSetString(this.BotBonusLocked,"ifs.meta.Bonus.locked")
			IFObj_fnSetVis(this.BotBonus, not this.Player2Choice)
--			IFObj_fnSetVis(this.BotBonusLocked, this.Player2Choice)
		else
			-- Show attacker's (bottom) choice
			local ChoiceUStr = ScriptCB_getlocalizestr( "common.none" )
			if(this.Player2Choice) then
				ChoiceUStr = ScriptCB_getlocalizestr(gMetaBotBonusList[this.Player2Choice].BonusName)
			end
			local ShowUStr = ScriptCB_usprintf("ifs.meta.main.attacker_choice",ChoiceUStr)
--			TitleBarLabel_fnSetUString(this.BotBonusLocked,ShowUStr)
			IFObj_fnSetVis(this.BotBonus, nil)
--			IFObj_fnSetVis(this.BotBonusLocked, 1)

			metagame_display_fnShowBonuses(this.TopBonus,gMetaTopBonusList,gTopBonusIdx)
--			TitleBarLabel_fnSetString(this.TopBonusLocked,"ifs.meta.Bonus.locked")
			IFObj_fnSetVis(this.TopBonus, not this.Player1Choice)
--			IFObj_fnSetVis(this.TopBonusLocked, this.Player1Choice)
		end

	end

--	IFObj_fnSetVis(this.galaxy,bPage1)
--	IFObj_fnSetVis(this.PickTargetBar,nil) -- bPage1)
--	IFObj_fnSetVis(this.BonusNameBar,nil) -- bPage1)
--	IFObj_fnSetVis(this.AttackItems,bPage2)
end

-- Reads gAttackPlanet, updates the center info window.
function metagame_display_fnUpdatePlanetInfo(this)
	local CurTeam = metagame_state[string.format("team%d",metagame_state.pickteam)]
--	IFText_fnSetString(this.InfoBox.CurTeam,CurTeam.teamname)

	if(metagame_state.applyingbonus) then
		PlanetNameStr = gBonusPlanetSelect
	else
		PlanetNameStr = gAttackPlanetSelect
	end
	
	if(gMetagameCurrentPage == 1) then
		--IFObj_fnSetVis(this.InfoBox.MainText,nil)
	elseif (gMetagameCurrentPage == 2) then
		PlanetNameStr = metagame_host_state.gAttackPlanet
		local Planet = metagame_state.planets[metagame_host_state.gAttackPlanet]
--		IFObj_fnSetVis(this.InfoBox.MainText,1)
--		IFText_fnSetString(this.InfoBox.MainText,Planet.ShortBonusText)
--	elseif (gMetagameCurrentPage == 2) then
--		IFObj_fnSetVis(this.InfoBox.MainText,nil)
	end

	local Planet = metagame_state.planets[PlanetNameStr]

	local bCanPick,HelpStr,PickTexture = metagame_state_fnCouldPickSelected(metagame_state)
	local DispPlanet = this.galaxy[Planet.pickorder]
	if(DispPlanet) then
		DispPlanet.ring.OverrideTexture = PickTexture
	end

	if(Planet.bBlockaded) then
		DispPlanet.ring.OverrideTexture = "naboo_shielded_overlay"
	end

--	TitleBarLabel_fnSetUString(this.PickTargetBar,HelpStr)
--	TitleBarLabel_fnSetString(this.BonusNameBar,Planet.ShortBonusText)
end

-- For dest being a IFText object, and a planet, sets the color
-- of its label
function metagame_display_fnColorPlanetName( dest, Planet, model )

	local R,G,B
	local fade = 5
	
	-- if model == 1, it's a model, otherwise it's the hexagon
	if( model == 1 ) then
		--for planet model
		R = 200 
		G = 200
		B = 200
		if(gPlatformStr == "PS2") then
			fade = 3
		else
			fade = 2
		end
	else
		--for hexagon
		if(metagame_state_local.mJoystickTeams[1] == Planet.owner1) then
			R = 42
			G = 239 
			B = 59
		else
			R = 239 
			G = 59
			B = 42
		end
		fade = 5

		if(not Planet.faction_planet) then
			if(Planet.owner1 ~= Planet.owner2) then
				R = 200 
				G = 200
				B = 200
			end
		end
	end

	if(gMetagameCurrentPage==1) then
		local isAttackable = nil
		for Idx = 1,table.getn(gMetaAttackableList) do
			if(Planet.pickorder == metagame_state.planets[gMetaAttackableList[Idx].planet].pickorder ) then
				isAttackable = 1
			end
		end
		if(not isAttackable) then
			R = R/fade
			G = G/fade
			B = B/fade
		end
	elseif((gMetagameCurrentPage==3) or (gMetagameCurrentPage==4)) then
		local TeamNumber
		if(gMetagameCurrentPage==3) then
			TeamNumber = metagame_state.pickteam
		else
			TeamNumber = 3-metagame_state.pickteam
		end
		local isValidBonus = nil
		if( (Planet.owner1 == Planet.owner2) and (TeamNumber == Planet.owner1) 
			 and (not Planet.faction_planet) and (not Planet.bBlockaded) ) then
			isValidBonus = 1
		end
		if(not isValidBonus) then
			R = R/fade
			G = G/fade
			B = B/fade
		end
	end
		
	
	-- Team of first owner
	local Team = metagame_state[string.format("team%d",Planet.owner1)]
	IFObj_fnSetColor(dest,R,G,B)

end


-- Updates visibility (including ownership rings) of the galaxy planets.
function metagame_display_fnUpdateGalaxyPlanets(this)
	local k,v
	local dest = this.galaxy
	local heightper, ygutter = metagame_GetPlanetPreviewSize()
	heightper = (heightper * 0.5) + 3 -- half-scale, to go from -heightper .. heightper

	local NumNormalPlanets = metagame_table.getnumPlanets()

	local pickPlanet
	if(metagame_state.applyingbonus) then
		pickPlanet = gBonusPlanetSelect
	else
		pickPlanet = gAttackPlanetSelect
	end
	for k,v in metagame_state.planets do
		local i = v.pickorder

		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			local planetVotes
			if(metagame_state.applyingbonus) then
				planetVotes = v.SecretBaseVotes
			else
				planetVotes = v.AttackVotes
			end
			if((planetVotes>0) and (gMetagameCurrentPage==1)) then
				IFObj_fnSetVis(dest[i].numVotes, 1)
				IFText_fnSetString(dest[i].numVotes,string.format("%d",planetVotes))
			else
				local numAttackBonusVotes
				local numDefendBonusVotes

				if(metagame_state.pickteam==1) then
					numAttackBonusVotes = v.Bonus1Votes
					numDefendBonusVotes = v.Bonus2Votes
				else
					numAttackBonusVotes = v.Bonus2Votes
					numDefendBonusVotes = v.Bonus1Votes
				end
				if((numAttackBonusVotes > 0) and (gMetagameCurrentPage == 3)) then
					IFObj_fnSetVis(dest[i].numVotes, 1)
					IFText_fnSetString(dest[i].numVotes,string.format("%d",numAttackBonusVotes))
				elseif((numDefendBonusVotes > 0) and (gMetagameCurrentPage == 4)) then
					IFObj_fnSetVis(dest[i].numVotes, 1)
					IFText_fnSetString(dest[i].numVotes,string.format("%d",numDefendBonusVotes))
				else
					IFObj_fnSetVis(dest[i].numVotes, nil)				
				end
			end
			
			-- Hide/show the entire container by the destroyed flag.
			IFObj_fnSetVis(dest[i], not v.destroyed)
			IFObj_fnSetVis(dest[i].icon, nil)

			if( gPlatformStr == "PC" ) then
				IFModel_fnSetOmegaY(dest[i].model,v.RotateSpeed/2)
			else
				IFModel_fnSetOmegaY(dest[i].model,v.RotateSpeed)
			end

			local ModelAlpha,OwnerIconAlpha

			IFModel_fnSetDepth(dest[i].hexagon, dest[i].hexagon.depth)
			IFObj_fnSetAlpha( dest[i].hexagon, 0.5 )

			IFModel_fnSetDepth(dest[i].cursor, dest[i].cursor.depth)
			
			-- set the mesh for the planet model
			local Mesh = "planet_" .. v.MapName
			IFModel_fnSetMsh( dest[i].model, Mesh )
			IFModel_fnSetDepth(dest[i].model, dest[i].model.depth )
			Mesh = "bonusplanet_" .. v.MapName
			IFModel_fnSetMsh( dest[i].bonus, Mesh )
			IFModel_fnSetDepth(dest[i].bonus, dest[i].bonus.depth )			
			
			ModelAlpha = 1.0
			if((k ~= pickPlanet)) then --  or (not metagame_state.applyingbonus)
				-- Not selected. Dimmer
				OwnerIconAlpha = 0.9 -- 0.7
				-- IFModel_fnSetDepth(dest[i].model, dest[i].model.depth )
			else -- Selected. Make bright
				OwnerIconAlpha = 0.9
				-- IFModel_fnSetDepth(dest[i].model, dest[i].model.depth * 0.75 )
			end

			IFObj_fnSetAlpha(dest[i].model,ModelAlpha)

			--IFObj_fnSetAlpha(dest[i].owner1, OwnerIconAlpha)
			IFObj_fnSetVis(dest[i].owner1, nil)
			if(not v.faction_planet) then
				--IFObj_fnSetAlpha(dest[i].owner2, OwnerIconAlpha)
				IFObj_fnSetVis(dest[i].owner2, nil)				
			end

--				IFImage_fnSetTexture(dest[i].icon, "holoplanet")
			
			IFText_fnSetString(dest[i].label, v.LocalizeName)
			IFText_fnSetString(dest[i].label2, v.LocalizeName)

			metagame_display_fnColorPlanetName(dest[i].label,v)
			metagame_display_fnColorPlanetName(dest[i].hexagon,v)
			metagame_display_fnColorPlanetName(dest[i].model, v, 1)

			if(v.destroyed) then
				IFObj_fnSetVis(dest[i].iconbg,nil)
			else
				-- Ring is off, but at normal size by default
				--IFObj_fnSetVis(dest[i].ring,
				--			(v.bBlockaded) or
				--			((k == pickPlanet)))   -- and (metagame_state.applyingbonus)
				-- hide ring, show cursor
				IFObj_fnSetVis(dest[i].ring, nil)				
--				IFObj_fnSetVis(dest[i].cursor,
--							(v.bBlockaded) or
--							((k == pickPlanet)))   -- and (metagame_state.applyingbonus)
--				print("+2++planetname", k)
				local RingSize = heightper * 1.6
				IFImage_fnSetTexturePos(dest[i].ring,-RingSize,-RingSize,RingSize,RingSize)

				if(v.bBlockaded) then
					dest[i].ring.OverrideTexture = "naboo_shielded_overlay"
					IFImage_fnSetTexture(dest[i].ring,"naboo_shielded_overlay")
				end

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
	
	--update the charge meter
	metagame_display_fnUpdateChargeMeter( this )
end

-- Updates visibility (including ownership rings) of the galaxy planets.
function metagame_display_fnUpdatePage1ZPos(this, hide)
	local NumPlanets = metagame_table.getnumPlanets()
	local i

	if(hide) then
		IFObj_fnSetZPos(this.galaxy,z_pos_base+31)
		for i = 1,NumPlanets do
			-- Container for the whole thing so we can hide/enable it quickly
			IFObj_fnSetZPos(this.galaxy[i],z_pos_base+31)
			IFObj_fnSetZPos(this.galaxy[i].icon,z_pos_base+31)
			IFObj_fnSetZPos(this.galaxy[i].model,z_pos_base+20)
			IFObj_fnSetZPos(this.galaxy[i].iconbg,z_pos_base+38)
			IFObj_fnSetZPos(this.galaxy[i].ring,z_pos_base+35)
			IFObj_fnSetZPos(this.galaxy[i].label,z_pos_base+35)
			IFObj_fnSetZPos(this.galaxy[i].label2,z_pos_base+38)
			IFObj_fnSetZPos(this.galaxy[i].owner1,z_pos_base+32)

			if((i ~= 1) and (i ~= NumPlanets)) then
				IFObj_fnSetZPos(this.galaxy[i].owner2,z_pos_base+32)
			end
		end -- loop over all planets
	else
		IFObj_fnSetZPos(this.galaxy,z_pos_base+20)
		for i = 1,NumPlanets do
			IFObj_fnSetZPos(this.galaxy[i],z_pos_base+20)
			IFObj_fnSetZPos(this.galaxy[i].icon,z_pos_base+25)
			IFObj_fnSetZPos(this.galaxy[i].model,z_pos_base+20)
			IFObj_fnSetZPos(this.galaxy[i].iconbg,z_pos_base+28)
			IFObj_fnSetZPos(this.galaxy[i].ring,z_pos_base+15)
			IFObj_fnSetZPos(this.galaxy[i].label,z_pos_base+15)
			IFObj_fnSetZPos(this.galaxy[i].label2,z_pos_base+18)
			IFObj_fnSetZPos(this.galaxy[i].owner1,z_pos_base+22)

		end -- loop over all planets
	end
end

-- Helper function: for a specified icon image, and a owner (float), updates it.
function metagame_display_fnUpdateOwnerIcon(IconImage,fOwner)
	local OwnerTeam
	if(fOwner < 1.5) then
		OwnerTeam = metagame_state.team1
	else
		OwnerTeam = metagame_state.team2
	end
	IFImage_fnSetTexture(IconImage,OwnerTeam.icon)
--	IFObj_fnSetColor(IconImage,OwnerTeam.ColorR,OwnerTeam.ColorG,OwnerTeam.ColorB)
	--IFObj_fnSetVis(IconImage,fOwner > 0.5)
	
	IFObj_fnSetVis(IconImage, nil)
end

-- Updates visibility (including ownership rings) of the galaxy
-- planets.  (Not all screens have this)
function metagame_display_BounceSelectionRing(this,fDt)
	local dest = this.galaxy
	if(dest) then
		local pickPlanet
		if(metagame_state.applyingbonus) then
			pickPlanet = gBonusPlanetSelect
		else
			pickPlanet = gAttackPlanetSelect
		end
		local Planet = metagame_state.planets[pickPlanet]
		local Idx = Planet.pickorder
		local heightper = metagame_GetPlanetPreviewSize()
		heightper = (heightper * 0.5) + 3 + this.ButtonAddScale -- half-scale, to go from -heightper .. heightper

		-- Apply override texture now if needed
		if(dest[Idx].ring.OverrideTexture) then
			if(Planet.bBlockaded) then
				IFImage_fnSetTexture(dest[Idx].ring,"naboo_shielded_overlay")
			else
				IFImage_fnSetTexture(dest[Idx].ring,dest[Idx].ring.OverrideTexture)
			end
			dest[Idx].ring.OverrideTexture = nil
		end

		if(not Planet.bBlockaded) then
			local RingSize = heightper * 1.3
			IFImage_fnSetTexturePos(dest[Idx].ring,-RingSize,-RingSize,RingSize,RingSize)
		end
	end
end



-- Updates visibility of rings of the galaxy planets' bonus
function metagame_display_fnUpdateGalaxyPlanetsRingForBonus( this )
	local k,v
	local dest = this.galaxy
	local NumNormalPlanets = metagame_table.getnumPlanets()
	local pickPlanet = nil
	local heightper = metagame_GetPlanetPreviewSize()
	heightper = (heightper * 0.5) + 3 + this.ButtonAddScale -- half-scale, to go from -heightper .. heightper
	
	if( gMetagameCurrentPage == 3 )then
		-- attacker's bonus
		if( metagame_state.pickteam == 1 ) then
			pickPlanet = gMetaTopBonusList[gTopBonusIdx].name
		else
			pickPlanet = gMetaBotBonusList[gBotBonusIdx].name
		end
	elseif( gMetagameCurrentPage == 4 )then
		-- defender's bonus
		if( metagame_state.pickteam == 1 ) then
			pickPlanet = gMetaBotBonusList[gBotBonusIdx].name
		else
			pickPlanet = gMetaTopBonusList[gTopBonusIdx].name
		end
	end
	
	--print( "pickPlanet == ", pickPlanet )
	for k,v in metagame_state.planets do
		local i = v.pickorder

		-- Ignore the factional planets shunted off the normal list
		if(i <= NumNormalPlanets) then
			if((k ~= pickPlanet)) then
				-- Not selected. Dimmer
				ModelAlpha = 0.8 -- 0.5
				OwnerIconAlpha = 0.9 -- 0.7
				IFModel_fnSetDepth(dest[i].model, dest[i].model.depth)
				IFObj_fnSetVis(dest[i].ring, nil)
				IFObj_fnSetVis(dest[i].cursor, nil)
			else -- Selected. Make bright
				ModelAlpha = 0.9
				OwnerIconAlpha = 0.9
				-- IFModel_fnSetDepth(dest[i].model, dest[i].model.depth * 0.75 )
				IFImage_fnSetTexture(dest[i].ring, "planet_select_yes")
				--IFObj_fnSetVis(dest[i].ring, 1)
				IFObj_fnSetVis(dest[i].ring, nil)
--				IFObj_fnSetVis(dest[i].cursor, 1)
--				print("+1++planetname", k)
				if(not v.bBlockaded) then
					local RingSize = heightper * 1.3
					IFImage_fnSetTexturePos(dest[i].ring,-RingSize,-RingSize,RingSize,RingSize)
				end				
			end
			local numAttackBonusVotes
			local numDefendBonusVotes

			if(metagame_state.pickteam==1) then
				numAttackBonusVotes = v.Bonus1Votes
				numDefendBonusVotes = v.Bonus2Votes
			else
				numAttackBonusVotes = v.Bonus2Votes
				numDefendBonusVotes = v.Bonus1Votes
			end
			if((numAttackBonusVotes > 0) and (gMetagameCurrentPage == 3)) then
				IFObj_fnSetVis(dest[i].numVotes, 1)
				IFText_fnSetString(dest[i].numVotes,string.format("%d",numAttackBonusVotes))
				IFObj_fnSetVis(this.TopBonus.ItemL,nil)
				IFObj_fnSetVis(this.TopBonus.ItemR,nil)
			elseif((numDefendBonusVotes > 0) and (gMetagameCurrentPage == 4)) then
				IFObj_fnSetVis(dest[i].numVotes, 1)
				IFText_fnSetString(dest[i].numVotes,string.format("%d",numDefendBonusVotes))
				IFObj_fnSetVis(this.BotBonus.ItemL,nil)
				IFObj_fnSetVis(this.BotBonus.ItemR,nil)
			else
				IFObj_fnSetVis(dest[i].numVotes, nil)
			end
		end -- planet is in normal list
	end -- loop over all planets
end

-- Updates visibility of rings of the galaxy planets' charge meter
function metagame_display_fnUpdateChargeMeterByResult( this , bWon )
	--print( "++team ", metagame_state.pickteam, ": bWon = ", bWon )
	local iChargeMeter = 0
	if( bWon == 1 ) then
		if( metagame_state.pickteam == 1 ) then
			-- team1 win
			metagame_state.charge_meter_team1 = metagame_state.charge_meter_team1 + 1
			iChargeMeter = metagame_state.charge_meter_team1
			--print( "++ metagame_state.charge_meter_team1 win = ", metagame_state.charge_meter_team1 )
		else				
			-- team2 win
			metagame_state.charge_meter_team2 = metagame_state.charge_meter_team2 + 1
			iChargeMeter = metagame_state.charge_meter_team2
			--print( "++ metagame_state.charge_meter_team2 win = ", metagame_state.charge_meter_team2 )		
		end
	else
		-- if lose last battle, pickteam already get changed to another team( win team )
		-- metagame_state.pickteam is the winner, add it's charge meter
		if( metagame_state.pickteam == 1 ) then
			-- team1 win
			metagame_state.charge_meter_team1 = metagame_state.charge_meter_team1 + 1
			iChargeMeter = metagame_state.charge_meter_team1
			--print( "++ metagame_state.charge_meter_team1 win = ", metagame_state.charge_meter_team1 )
		else				
			-- team2 win
			metagame_state.charge_meter_team2 = metagame_state.charge_meter_team2 + 1
			iChargeMeter = metagame_state.charge_meter_team2
			--print( "++ metagame_state.charge_meter_team2 win = ", metagame_state.charge_meter_team2 )		
		end
	end

	--apply bonus when get 4 charge meter
	if( iChargeMeter >= 4 ) then
		metagame_state.applyingbonus = 1
		--print( "metagame_state.applyingbonus = ", metagame_state.applyingbonus )
		local Planet
		for k,v in metagame_state.planets do
			if( ( not v.destroyed ) and ( v.faction_planet == 1 ) ) then
				-- secret bases
				--print( "+v = ", v )
				if( ( v.owner1 == metagame_state.pickteam ) and ( v.owner2 == metagame_state.pickteam ) ) then
					--print( "+Planet = ", Planet )
					Planet = v
				end
			end
		end		
		-- flag for faction planet to able to attackable
		if( metagame_state.pickteam == 1 ) then
			-- team1 win
			metagame_state.team1_charged = 1
		else
			-- team2 win
			metagame_state.team2_charged = 1
			
		end		
		
		--print( "++++++team", metagame_state.pickteam, " get charged." )
		--print( "++++++metagame_state.team1_charged", metagame_state.team1_charged )
		--print( "++++++metagame_state.team2_charged", metagame_state.team2_charged )
		
		--print( "Planet = ", Planet )
		if( Planet ) then
			metagame_state.bonusplanet = Planet
			metagame_state.bonusplanet:fnBonusActivated()
		end
	end
	
	metagame_display_fnUpdateChargeMeter( this )
end


-- Updates visibility of rings of the galaxy planets' charge meter
function metagame_display_fnUpdateChargeMeter( this )
	local i = 0
	local NumPlanets = metagame_table.getnumPlanets()
	for i = 1, 4 do
		if( i <= metagame_state.charge_meter_team1 ) then		
			--print( "this has been called 3: i = ", i )
			--IFObj_fnSetVis(this.galaxy[1].charge_meter[i], 1)
			--IFObj_fnSetAlpha(this.galaxy[1].charge_meter[i], 1)
			IFImage_fnSetTexture(this.galaxy[1].charge_meter[i], "oval_icon_full")
		else
			--print( "this has been called 3.5: i = ", i )
			--IFObj_fnSetVis(this.galaxy[1].charge_meter[i], nil)
			--IFObj_fnSetAlpha(this.galaxy[1].charge_meter[i], 0.3)
			IFImage_fnSetTexture(this.galaxy[1].charge_meter[i], "oval_icon_empty")
		end
	end
	for i = 1, 4 do
		if( i <= metagame_state.charge_meter_team2 ) then
			--print( "this has been called 4: i = ", i, " NumPlanets = ", NumPlanets )
			--IFObj_fnSetVis(this.galaxy[NumPlanets].charge_meter[i], 1)
			--IFObj_fnSetAlpha(this.galaxy[NumPlanets].charge_meter[i], 1)
			IFImage_fnSetTexture(this.galaxy[NumPlanets].charge_meter[i], "oval_icon_full")
		else
			--print( "this has been called 4.5: i = ", i, " NumPlanets = ", NumPlanets )
			--IFObj_fnSetVis(this.galaxy[NumPlanets].charge_meter[i], nil)
			--IFObj_fnSetAlpha(this.galaxy[NumPlanets].charge_meter[i], 0.3)
			IFImage_fnSetTexture(this.galaxy[NumPlanets].charge_meter[i], "oval_icon_empty")
		end
	end	
end

-- Updates Information box
function metagame_display_fnUpdateInfoBox( this )
	local k,v
	local dest = ifs_meta_main.galaxy
	local NumNormalPlanets = metagame_table.getnumPlanets()

	local pickPlanet
	if(gMetagameCurrentPage == 1) then
		if(metagame_state.applyingbonus) then
			pickPlanet = gBonusPlanetSelect
		else
			pickPlanet = gAttackPlanetSelect
		end
	elseif(gMetagameCurrentPage == 2) then
		pickPlanet = gBonusPlanetSelect
	end


	for k,v in metagame_state.planets do
		local i = v.pickorder
		
		if( k == pickPlanet) then
			if(gMetagameCurrentPage == 1) then
				gButtonWindow_fnSetText( ifs_meta_main.InfoBox, v.LocalizeName )
				local status, mapname, bonus
				if( ( v.owner1 == v.owner2 ) ) then
					if( ( v.owner1 ~= metagame_state.pickteam ) ) then
						status = ScriptCB_getlocalizestr("ifs.meta.Main.enemy")						
						mapname = ScriptCB_getlocalizestr(v.MapName1)
					else
						status = ScriptCB_getlocalizestr("ifs.meta.Main.own")
						mapname = ScriptCB_getlocalizestr("common.none")
					end
				else
					if( ( v.owner1 ~= metagame_state.pickteam ) ) then
						mapname = ScriptCB_getlocalizestr(v.MapName1)
					else
						mapname = ScriptCB_getlocalizestr(v.MapName2)
					end
					status = ScriptCB_getlocalizestr("ifs.meta.Main.contest")	
				end
				bonus = ScriptCB_getlocalizestr(v.ShortBonusText)
				local ShowUStr = ScriptCB_usprintf("ifs.meta.Main.infobox", status, mapname, bonus )
				IFText_fnSetUString( ifs_meta_main.AttackBonusText, ShowUStr )
				IFObj_fnSetVis( ifs_meta_main.AttackBonusText, 1 )				
			elseif(gMetagameCurrentPage == 2) then

			end
		end
		
		if(i <= NumNormalPlanets) then
			-- enable/disable bonus model
			if(gMetagameCurrentPage == 1) then
				IFObj_fnSetVis( dest[i].bonus, nil )
			elseif( (gMetagameCurrentPage == 2) or (gMetagameCurrentPage == 3) ) then
				local picklist = nil
				if( metagame_state.pickteam == 1 ) then
					picklist = gMetaTopBonusList
				else
					picklist = gMetaBotBonusList
				end
				local bonusId = ifs_meta_main_PlanetName_To_Index( k, picklist )
				if( bonusId ) then
					IFObj_fnSetVis( dest[i].bonus, 1 )
				else
					IFObj_fnSetVis( dest[i].bonus, nil )
				end
			elseif( (gMetagameCurrentPage == 4) ) then
				local picklist = nil
				if( metagame_state.pickteam == 1 ) then
					picklist = gMetaBotBonusList
				else
					picklist = gMetaTopBonusList
				end
				local bonusId = ifs_meta_main_PlanetName_To_Index( k, picklist )
				if( bonusId ) then
					IFObj_fnSetVis( dest[i].bonus, 1 )
				else
					IFObj_fnSetVis( dest[i].bonus, nil )
				end			
			end
		end
	end
end


-- Updates HexCursor for selected planet
function metagame_display_fnUpdateHexCursor( this )
	local k,v
	local dest = ifs_meta_main.galaxy
	local NumNormalPlanets = metagame_table.getnumPlanets()

	local pickPlanet = nil
	if(gMetagameCurrentPage == 1) then
		if(metagame_state.applyingbonus) then
			pickPlanet = gBonusPlanetSelect
		else
			pickPlanet = gAttackPlanetSelect
		end
		local Idx, ret = nil
		for Idx = 1, table.getn(gMetaAttackableList) do
			if( pickPlanet == gMetaAttackableList[Idx].planet ) then
				ret = 1
			end
		end
		
		if( not ret ) then
			if(metagame_state.applyingbonus) then
				gBonusPlanetSelect = gMetaAttackableList[1].planet
			else
				gAttackPlanetSelect = gMetaAttackableList[1].planet
			end
			pickPlanet = gMetaAttackableList[1].planet
		end
	elseif(gMetagameCurrentPage == 2) then
		pickPlanet = gBonusPlanetSelect
	elseif( (gMetagameCurrentPage == 3) ) then
		-- attacker's bonus
		if( metagame_state.pickteam == 1 ) then
			pickPlanet = gMetaTopBonusList[gTopBonusIdx].name
		else
			pickPlanet = gMetaBotBonusList[gBotBonusIdx].name
		end
	elseif( (gMetagameCurrentPage == 4) ) then
		-- defender's bonus
		if( metagame_state.pickteam == 1 ) then
			pickPlanet = gMetaBotBonusList[gBotBonusIdx].name
		else
			pickPlanet = gMetaTopBonusList[gTopBonusIdx].name			
		end
	end	

--	print( "+++gMetagameCurrentPage", gMetagameCurrentPage )
--	print( "+++pickPlanet", pickPlanet )
	
	local NumNormalPlanets = metagame_table.getnumPlanets()
	for k,v in metagame_state.planets do
		local i = v.pickorder
	
		if( i <= NumNormalPlanets ) then
			IFObj_fnSetVis(dest[i].cursor, nil)
			if( k == pickPlanet) then
				dest[i].cursor.alpha = dest[i].cursor.alpha + 0.03
				if( dest[i].cursor.alpha > 1 ) then
					dest[i].cursor.alpha = 0.2
				end
				IFObj_fnSetAlpha( dest[i].cursor, dest[i].cursor.alpha )
				IFObj_fnSetVis(dest[i].cursor, 1)
			end
		end
	end
end