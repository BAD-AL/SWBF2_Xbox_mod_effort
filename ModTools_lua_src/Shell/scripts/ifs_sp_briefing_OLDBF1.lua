--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-- For a cluster of items in Dest, a list, and a selected index, sets
-- visibility/textures
function ifs_sp_briefing_fnSetItemTextures(this,List,Idx,Count,Max)

--	print("ifs_sp_briefing_fnSetItemTextures, Idx, Count =", Idx, Count)
	
	if(Max < 2) then
		-- Just 1 map. Hide the rest.
		IFObj_fnSetVis(this.ModelL,nil)
		IFObj_fnSetVis(this.ModelL2,nil)
		IFObj_fnSetVis(this.ModelR2,nil)
--		IFMapPreview_fnSetTexture(this.ModelR,"map_unk")
		IFObj_fnSetVis(this.ModelR,1)
	else
		IFObj_fnSetVis(this.ModelL,1)
		IFObj_fnSetVis(this.ModelR,1)
		IFObj_fnSetVis(this.ModelL2,nil)
		IFObj_fnSetVis(this.ModelR2,nil)
		
		-- Don't make this a circular list
		local Idx2 = Idx - 1
		if(Idx2 > 0) then
			IFModel_fnSetMsh(this.ModelL,List[Idx2].Mesh)

			Idx2 = Idx2 - 1
			if(Idx2 > 0) then
				IFModel_fnSetMsh(this.ModelL2,List[Idx2].Mesh)
			end
		else
			IFObj_fnSetVis(this.ModelL,nil)
		end

		-- Do the ones to the right of the player
		Idx2 = Idx + 1
		if(Idx2 < Max) then
			IFModel_fnSetMsh(this.ModelR,List[Idx2].Mesh)

			-- Move on, do R2
			Idx2 = Idx2 + 1
			if(Idx2 < Max) then
				IFModel_fnSetMsh(this.ModelR2,List[Idx2].Mesh)
			else
				-- one more to the right isn't possible
				IFObj_fnSetVis(this.ModelR2,nil)
			end

		else
			-- one to the right isn't possible
			IFObj_fnSetVis(this.ModelR,nil)
		end

	end
	
	-- Always update center map
	if(Count >= 1) then
		IFModel_fnSetMsh(this.ModelC,List[Idx].Mesh)
		IFMapPreview_fnSetTexture(this.ItemC, List[Idx].texture)
		IFText_fnSetString(ifs_sp_briefing.PlanetName, List[Idx].PlanetStr)
	end
end


-- For a cluster of items in Dest, a list, and a selected index, sets
-- visibility/textures
function ifs_sp_briefing_fnSetHoloTextures(this,List,Idx,Count,Max)

	local HoloMesh = "planet_holo"
	
	if(Max < 2) then
		-- Just 1 map. Hide the rest.
		IFObj_fnSetVis(this.ModelL,nil)
		IFObj_fnSetVis(this.ModelL2,nil)
		IFObj_fnSetVis(this.ModelR2,nil)
		IFObj_fnSetVis(this.ModelR,1)
	else
		IFObj_fnSetVis(this.ModelL,1)
		IFObj_fnSetVis(this.ModelR,1)
		IFObj_fnSetVis(this.ModelL2,nil)
		IFObj_fnSetVis(this.ModelR2,nil)
		
		-- Don't make this a circular list
		local Idx2 = Idx - 1
		if(Idx2 > 0) then
			IFModel_fnSetMsh(this.ModelL,HoloMesh)

			Idx2 = Idx2 - 1
			if(Idx2 > 0) then
				IFModel_fnSetMsh(this.ModelL2,HoloMesh)
			end
		else
			IFObj_fnSetVis(this.ModelL,nil)
		end

		-- Do the ones to the right of the player
		Idx2 = Idx + 1
		if(Idx2 < Max) then
			IFModel_fnSetMsh(this.ModelR,HoloMesh)

			-- Move on, do R2
			Idx2 = Idx2 + 1
			if(Idx2 < Max) then
				IFModel_fnSetMsh(this.ModelR2,HoloMesh)
			else
				-- one more to the right isn't possible
				IFObj_fnSetVis(this.ModelR2,nil)
			end
		else
			-- one to the right isn't possible
			IFObj_fnSetVis(this.ModelR,nil)
		end

	end


	-- Always update center map
	if(Count >= 1) then
		IFModel_fnSetMsh(this.ModelC,HoloMesh)
	end
end

function ifs_sp_briefing_fnSetArrows(List,Idx,Count,Max)
	local this = ifs_sp_briefing
	
	if(gPlatformStr == "PC") then
		-- show the left arrow?
		IFObj_fnSetVis(this.buttons.leftarrow,Idx>1)
		-- show the right arrow?
		IFObj_fnSetVis(this.buttons.rightarrow,Idx<Max)
		-- dim the right arrow if we haven't unlocked that mission yet
		local alpha = 1
		if(Idx==Count) then
			alpha = 0.5
		end	
		this.buttons.rightarrowalpha = alpha
		--	IFObj_fnSetAlpha(this.buttons.rightarrow,alpha)
	end
end

function ifs_sp_briefing_fnUpdateScreen(this)
--	print("ifs_sp_briefing_fnUpdateScreen, this=", this, "this.iSelected = ",this.iSelected)

	ifs_sp_briefing_fnSetItemTextures(this.Previews,gCurCampaign,this.iSelected,this.iProgress,this.iMaxMissions)
	ifs_sp_briefing_fnSetHoloTextures(this.PreviewsHolo,gCurCampaign,this.iSelected,this.iProgress,this.iMaxMissions)
	ifs_sp_briefing_fnSetArrows(gCurCampaign,this.iSelected,this.iProgress,this.iMaxMissions)
	
	local Selection = gCurCampaign[this.iSelected]
	IFText_fnSetString(this.NextMapTitle,Selection.showstr)
--	IFText_fnSetString(this.NextMapDescr,Selection.description)
--	IFObj_fnSetVis(this.NextMapDescr, nil)
end

-- For a cluster of items in Dest, a direction to animate, small & large sizes,
-- and a visible count, animates them sliding left or right. FIXME: this is
-- nearly-duplicated code, seems kinda wasteful
function ifs_sp_briefing_fnAnimateItems(dest,fDir,fSmallSize,fLargeSize,fSmallScale,fLargeScale,fYOffset,Idx,Count)
	local fAnimTime = 0.5
	-- Set up animations
	if(fDir > 0.5) then
		-- move things right
		AnimationMgr_AddAnimation(dest.ModelL,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 0, fEndAlpha = 1,
																fStartX = -(fLargeSize + 3 * fSmallSize),
																fEndX =   -(fLargeSize + 1 * fSmallSize),
																fStartY = fYOffset,
																fEndY = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelL:fnSetSize(fSmallSize,fSmallSize) -- constant param

		AnimationMgr_AddAnimation(dest.ModelC,
															{ fTotalTime = fAnimTime,
																fStartX = -(fLargeSize + fSmallSize),
																fEndX   = 0,
																fStartY = fYOffset,
																fEndY   = -fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fLargeScale,
																fEndH   = fLargeScale,
															})
		IFObj_fnSetAlpha(dest.ModelC,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelR,
															{ fTotalTime = fAnimTime,
																fStartX = 0,
																fEndX   = (fLargeSize + fSmallSize),
																fStartY = -fYOffset,
																fEndY   = fYOffset,
																fStartW = fLargeScale,
																fStartH = fLargeScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
--		IFObj_fnSetAlpha(dest.ModelR,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelR2,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 1, fEndAlpha   = 0,
 																fStartX = (fLargeSize + 1 * fSmallSize),
 																fEndX   = (fLargeSize + 3 * fSmallSize),
 																fStartY = fYOffset,
 																fEndY   = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelR2:fnSetSize(fSmallSize,fSmallSize) -- constant param
		IFObj_fnSetVis(dest.ModelR2,Count > 1)
	elseif (fDir < -0.5) then
		-- Move things left

		AnimationMgr_AddAnimation(dest.ModelR,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 0, fEndAlpha = 1,
																fStartX = (fLargeSize + 3 * fSmallSize),
																fEndX =   (fLargeSize + 1 * fSmallSize),
																fStartY = fYOffset,
																fEndY =   fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelR:fnSetSize(fSmallSize,fSmallSize) -- constant param

		AnimationMgr_AddAnimation(dest.ModelC,
															{ fTotalTime = fAnimTime,
																fStartX = (fLargeSize + fSmallSize),
																fEndX   = 0,
																fStartY = fYOffset,
																fEndY   = -fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fLargeScale,
																fEndH   = fLargeScale,
															})
		IFObj_fnSetAlpha(dest.ModelC,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelL,
															{ fTotalTime = fAnimTime,
																fStartX = 0,
																fEndX   = -(fLargeSize + fSmallSize),
																fStartY = -fYOffset,
																fEndY   = fYOffset,
																fStartW = fLargeScale,
																fStartH = fLargeScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		IFObj_fnSetAlpha(dest.ModelL,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelL2,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 1, fEndAlpha   = 0,
																fStartX = -(fLargeSize + 1 * fSmallSize),
																fEndX   = -(fLargeSize + 3 * fSmallSize),
																fStartY = fYOffset,
																fEndY   = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelL2:fnSetSize(fSmallSize,fSmallSize) -- constant param
		IFObj_fnSetVis(dest.ModelL2,Idx > 2)
	else
		-- Stay still. All params should be the same
		fAnimTime = 0.5
		AnimationMgr_AddAnimation(dest.ModelL,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 0, fEndAlpha = 1,
																fStartX = -(fLargeSize + 1 * fSmallSize),
																fEndX =   -(fLargeSize + 1 * fSmallSize),
																fStartY = fYOffset,
																fEndY = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelL:fnSetSize(fSmallSize,fSmallSize) -- constant param

		AnimationMgr_AddAnimation(dest.ModelC,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 0, fEndAlpha = 1,
																fStartX = 0,
																fEndX   = 0,
																fStartY = -fYOffset,
																fEndY   = -fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fLargeScale,
																fEndH   = fLargeScale,
															})
		IFObj_fnSetAlpha(dest.ModelC,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelR,
															{ fTotalTime = fAnimTime,
																fStartX = (fLargeSize + fSmallSize),
																fEndX   = (fLargeSize + fSmallSize),
																fStartY = fYOffset,
																fEndY   = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		IFObj_fnSetAlpha(dest.ModelR,1,1) -- constant for this item

		AnimationMgr_AddAnimation(dest.ModelR2,
															{ fTotalTime = fAnimTime,
																fStartAlpha = 1, fEndAlpha   = 0,
 																fStartX = (fLargeSize + 3 * fSmallSize),
 																fEndX   = (fLargeSize + 3 * fSmallSize),
 																fStartY = fYOffset,
 																fEndY   = fYOffset,
																fStartW = fSmallScale,
																fStartH = fSmallScale, 
																fEndW   = fSmallScale,
																fEndH   = fSmallScale,
															})
		dest.ModelR2:fnSetSize(fSmallSize,fSmallSize) -- constant param
		IFObj_fnSetVis(dest.ModelR2,Count > 1)

	end
end

-- Changes the selection
function ifs_sp_briefing_fnChangeSel(this,fDir)
	if(this.Previews.ModelC.bAnimActive) then
		return InIdx
	end

	local fLargeSize = this.fLargeSize
	local fSmallSize = this.fSmallSize
	local fLargeScale = this.fLargeScale
	local fSmallScale = this.fSmallScale

	ifs_sp_briefing_fnAnimateItems(this.Previews,fDir,fSmallSize,fLargeSize,fSmallScale,fLargeScale,0,this.iSelected,this.iProgress)
	ifs_sp_briefing_fnAnimateItems(this.PreviewsHolo,fDir,fSmallSize,fLargeSize,fSmallScale,fLargeScale,0,this.iSelected,this.iProgress)

	-- Always fade in names as well.
	local fAnimTime = 1.0
	AnimationMgr_AddAnimation(this.NextMapTitle,	{ fTotalTime = 1.5 * fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	AnimationMgr_AddAnimation(this.Previews.ItemC,	{ fTotalTime = 2 * fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	AnimationMgr_AddAnimation(this.PlanetName,		{ fTotalTime = 2 * fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})
	AnimationMgr_AddAnimation(this.Previews.ItemC,	{ fTotalTime = 2 * fAnimTime, fStartAlpha = 0, fEndAlpha = 1,})

	-- fade in the arrows
	if(gPlatformStr == "PC") then
		AnimationMgr_AddAnimation(this.buttons.rightarrow,	{ fTotalTime = fAnimTime, fStartAlpha = 0.5, fEndAlpha = this.buttons.rightarrowalpha,})
		AnimationMgr_AddAnimation(this.buttons.leftarrow,	{ fTotalTime = fAnimTime, fStartAlpha = 0.5, fEndAlpha = 1,})
	end

end

-- Callback (from C++) -- saving is done. Do something.
--function ifs_archive_fnSaveProfileDone(this)
--	Popup_LoadSave:fnActivate(nil)
--	local this = ifs_sp_briefing
--	IFObj_fnSetVis(this,1)
--	ifs_sp_briefing_fnUpdateScreen(this)
--end

----------------------------------------------------------------------------------------
-- save progress for player 1
----------------------------------------------------------------------------------------

function ifs_sp_briefing_StartSaveProfile1()
	print("ifs_sp_briefing_StartSaveProfile1")
	local this = ifs_sp_briefing
	
	-- is the profile dirty?
	if(ScriptCB_IsProfileDirty(1)) then

		-- start save profiles
		ifs_saveop.doOp = "SaveProfile"
		ifs_saveop.OnSuccess = ifs_sp_briefing_SaveProfile1Success
		ifs_saveop.OnCancel = ifs_sp_briefing_SaveProfile1Cancel
		ifs_saveop.saveName = ScriptCB_GetProfileName(1)
		ifs_saveop.saveProfileNum = 1
		ifs_movietrans_PushScreen(ifs_saveop)
	else
		ifs_sp_briefing_StartSaveProfile2()
		return	
	end
end

function ifs_sp_briefing_SaveProfile1Success()
	print("ifs_sp_briefing_SaveProfile1Success")
	local this = ifs_sp_briefing

	this.returningFromProfile1Save = 1
	ScriptCB_PopScreen()
end

function ifs_sp_briefing_SaveProfile1Cancel()
	print("ifs_sp_briefing_SaveProfile1Cancel")
	local this = ifs_sp_briefing

	this.returningFromProfile1Save = 1
	ScriptCB_PopScreen()
end

-------------------------------------
-- save progress for player 2
-------------------------------------

function ifs_sp_briefing_StartSaveProfile2()
	print("ifs_sp_briefing_StartSaveProfile2")
	local this = ifs_sp_briefing

	if(ScriptCB_IsProfileDirty(2)) then
		-- start save profiles
		ifs_saveop.doOp = "SaveProfile"
		ifs_saveop.OnSuccess = ifs_sp_briefing_SaveProfile2Success
		ifs_saveop.OnCancel = ifs_sp_briefing_SaveProfile2Cancel
		ifs_saveop.saveName = ScriptCB_GetProfileName(2)
		ifs_saveop.saveProfileNum = 2
		ifs_movietrans_PushScreen(ifs_saveop)
	else
		-- skip it
		this.returningFromProfile2Save = 1
		this:Enter(nil)
		return
	end
end

function ifs_sp_briefing_SaveProfile2Success()
	print("ifs_sp_briefing_SaveProfile2Success")
	local this = ifs_sp_briefing

	this.returningFromProfile2Save = 1
	ScriptCB_PopScreen()
end

function ifs_sp_briefing_SaveProfile2Cancel()
	print("ifs_sp_briefing_SaveProfile2Cancel")
	local this = ifs_sp_briefing

	this.returningFromProfile2Save = 1
	ScriptCB_PopScreen()
end

----------------------------------------------------------------------------------------
-- the second half of the enter function (after the progress save)
----------------------------------------------------------------------------------------

function ifs_sp_briefing_PostSaveEnter(this)
	print("ifs_sp_briefing_PostSaveEnter")

	-- Flag missions as locked if the user hasn't progressed that far
	for i=this.iProgress+1,this.iMaxMissions do
		gCurCampaign[i].bLocked = 1
	end
--			this.iProgress = this.iMaxMissions

	-- Default: show the latest mission.
	--this.iSelected = this.iProgress
	-- show the last mission played, unless we won, then show the next
	this.iSelected = this.iNumLastMission

-- 	print("SP Progress = ", this.iProgress, ", Max = ",this.iMaxMissions, ", numlastmission = ",this.iNumLastMission)
-- 	print(" this.bSetVis = ",this.bSetVis)

	-- Set up default mode (archive if everything complete, else
	-- current)
	if(this.bSetVis) then
		ifs_sp_briefing_fnUpdateScreen(this)
		ifs_sp_briefing_fnChangeSel(this, -0.05)
		ifs_sp_briefing_fnChangeSel(this, 0)
	end
	
	-- right align the launch button	
	if(gPlatformStr == "PC") then
		local w,h = ScriptCB_GetSafeScreenInfo()
		gIFShellScreenTemplate_fnMoveClickableButton(this.buttons.launch,this.buttons.launch.label,w)
	end

			
	--if we won, go directly to the yoda screen
	if(this.wonLastMission) then
--		print("this.wonLastMission")
		-- go directly to the yoda screen, view the exit movies and stuff
		local LastMission = gCurCampaign[this.wonIndex]
		ifs_sp_yoda.playExitMovie 	   = LastMission.exitmovie
		ifs_sp_yoda.playExitMovieLocalized = LastMission.exitmovielocalized
		this.skipDifficulty = 1
		
		-- if its the last mission, come back after the exit movie
		if(this.wonIndex == this.iMaxMissions) then
--			print("setting ifs_sp_yoda.popAfterExitMovie=1")
			ifs_sp_yoda.popAfterExitMovie = 1
		end
		
		this.CurButton = "launch"
		this.Input_Accept(this)
	end
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_sp_briefing = NewIFShellScreen {
	nologo = 1,
	bg_texture = nil, -- "iface_bgmeta_space",
	movieIntro      = "ifs_sp_briefing_intro",
	movieBackground = "ifs_sp_briefing",
	music           = "shell_soundtrack",
	exitSound       = "",

	Previews = NewIFContainer {
		ScreenRelativeX = 0.5, ScreenRelativeY = 0.5, -- center
	},
	PreviewsHolo = NewIFContainer {
		ScreenRelativeX = 0.5, ScreenRelativeY = 0.5, -- center
	},

	PlanetName = NewIFText {
		font = "gamefont_large",
		ScreenRelativeX = 0.5, -- left
		ScreenRelativeY = 0.05, -- top
		textw = 450,
		valign = "top",
		nocreatebackground = 1,
	},

	NextMapTitle = NewIFText {
		font = "gamefont_large",
		ScreenRelativeX = 0.5, -- left
		ScreenRelativeY = 0.8, -- near bottom of screen
		y = -20,
		textw = 425,
		texth = 60,
		valign = "vcenter",
		nocreatebackground = 1,
		ZPos = 90,
	},

--	NextMapDescr = NewIFText {
--		font = "gamefont_medium",
--		ScreenRelativeX = 0.5, -- center
--		ScreenRelativeY = 0.72, -- middle of screen
--		textw = 450,
--		texth = 150,
--		valign = "top",
--		nocreatebackground = 1,
--	},

	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd) -- call default enter function
	
		
		this.iCheatStage = 0
--		print("")
--		print("ifs_sp_briefing.Enter. this=",this," iProgress=", this.iProgress)
		gMovieAlwaysPlay = 1
		
		-- set sun light for the model
		ScriptCB_SetSunlight( this )
		
		--pop on enter?
		-- this gets set when we want to jump from ifs_yoda back to the era screen
		if(this.popOnEnter) then
			print("ifs_sp_briefing.Enter popOnEnter")
			this.popOnEnter = nil
			ScriptCB_PopScreen()
			return
		end

		if( this.returningFromProfile1Save ) then
			print("this.returningFromProfile1Save")
			this.returningFromProfile1Save = nil
			ifs_sp_briefing_StartSaveProfile2()
		
		elseif( this.returningFromProfile2Save ) then
			print("this.returningFromProfile2Save")
			this.returningFromProfile2Save = nil
			ifs_sp_briefing_PostSaveEnter(this)			
			
		elseif( bFwd or this.returningFromUnlockable ) then
			print("bFwd or this.returningFromUnlockable")
		
			this.returningFromUnlockable = nil
			--ifelem_shellscreen_fnStopMovie()

			local iMissionSuccess = -1
			local bOnLastMission = nil
			this.iNumLastMission = 1

			if(ScriptCB_IsCampaignStateSaved()) then
				this.iCampaignNum,bOnLastMission,this.iNumLastMission = ScriptCB_LoadCampaignState()
				iMissionSuccess = ScriptCB_GetLastBattleVictory() -- team that won the last map
				this.iSelected = this.iNumLastMission -- default this, it might be overridden in a minute
-- 				print("Read in campaign # & success",this.iCampaignNum,iMissionSuccess)
-- 				print(" this.iNumLastMission = ",this.iNumLastMission)
-- 				print(" this.iSelected = ",this.iSelected)
			else
				-- First time in. Figure out which campaign number the user wanted.
				if(this.era == "new") then
					this.iCampaignNum = 1
				elseif (this.era == "classic") then
					this.iCampaignNum = 2
				else
					assert(0) -- uhoh!
				end
--				print("Calculated campaign #",this.iCampaignNum)
			end

			if(this.iCampaignNum == 1) then
				gCurCampaign = SPCampaign_CW
			elseif (this.iCampaignNum == 2) then
				gCurCampaign = SPCampaign_GCW
			end
			this.iProgress = ScriptCB_GetSPProgress(this.iCampaignNum)
			if(this.iProgress == 0) then
				-- Hack, maybe we should play a special intro here?
				this.iProgress = 1
			end
			
			-- did we win the last mission?
			this.wonLastMission = nil
			this.wonIndex = this.iNumLastMission
			if(iMissionSuccess >= 0) then
				local Selection = gCurCampaign[this.iNumLastMission]
				local PlayerSide = Selection.side or 1
				-- did we win?
				if(math.abs(PlayerSide - iMissionSuccess) < 0.1) then
					this.wonLastMission = 1
				end
			end
			
			
			-- if we won and there was an unlockable associated with this mission, unlock it
			if(this.wonLastMission) then
				local Selection = gCurCampaign[this.iNumLastMission]
				local PlayerSide = Selection.side or 1
				if (Selection.unlockable) then
					ifs_dounlock.unlockNum = Selection.unlockable
					-- only if it hasn't been unlocked before
					local numStr = tostring(ifs_dounlock.unlockNum)
					if(not ScriptCB_UnlockableState(numStr)) then
						-- set a flag so we'll redo this when we return
						this.returningFromUnlockable = 1
						-- go there
                        ifs_movietrans_PushScreen(ifs_dounlock)
						return							
					end					
				end					
			end

			this.iMaxMissions = table.getn(gCurCampaign)
			-- Build list of textures for the missions as well
			local i
			local k,v
			for i=1,this.iMaxMissions do
				gCurCampaign[i].texture = "map_" .. string.sub(gCurCampaign[i].mapluafile,1,4)
				gCurCampaign[i].Mesh = "planet_" .. string.sub(gCurCampaign[i].mapluafile,1,3)

				gCurCampaign[i].PlanetStr = "???"
				local Planet3 = strupper(string.sub(gCurCampaign[i].mapluafile,1,3))
				for k,v in metagame_state.planets do
					if(Planet3 == v.MapName) then	
						gCurCampaign[i].PlanetStr = v.LocalizeName
					end
				end
			end


			-- Update 
			this.bSetVis = 1
			if(this.wonLastMission) then
				--yes
				local Selection = gCurCampaign[this.iProgress]
				local PlayerSide = Selection.side or 1
				this.iNumLastMission = math.min(this.iNumLastMission + 1, this.iMaxMissions)
				--did we win the last mission thats unlocked?			
				if(bOnLastMission) then
					this.iProgress = math.min(this.iProgress + 1, this.iMaxMissions)
--					print("User won! Advancing mission! Progress = ",this.iProgress)
					ScriptCB_SetSPProgress(this.iCampaignNum,this.iProgress)
					--IFObj_fnSetVis(this,nil)
					this.bSetVis = nil
					--Popup_LoadSave:fnActivate(1)
					--ScriptCB_StartSaveProfile()
				else
--					print("User lost! Staying here...")
				end
			end

			-- save your progress?
			ifs_sp_briefing_StartSaveProfile1()
			return
		end
		
		-- coming backwards.  animate everything stopped
		ifs_sp_briefing_fnUpdateScreen(this)
		ifs_sp_briefing_fnChangeSel(this, 0)
		
	end,

	Exit = function(this, bFwd)
		-- Clear SP state if we back out of here.
		if(not bFwd) then
			ScriptCB_SaveCampaignState()
			ScriptCB_SetHistoricalRulesOn(nil)
			gMovieAlwaysPlay = nil
		end
		this.iCheatStage = 0
	end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gShellScreen_fnDefaultInputAccept(this)) then
			return
		end

--		print( "Curbutton = ",this.CurButton)
	
		if( this.CurButton == "new" ) then
			ifs_sp_briefing.era = this.CurButton
			this:Enter(1)
		elseif (this.CurButton == "classic") then
			ifs_sp_briefing.era = this.CurButton
			this:Enter(1)
		elseif (this.CurButton == "rightarrow") then
			this:Input_GeneralRight(1)
		elseif (this.CurButton == "leftarrow") then
			this:Input_GeneralLeft(1)
		elseif (this.CurButton == "launch" or gPlatformStr ~= "PC" ) then
			local Selection = gCurCampaign[this.iSelected]
			this.iCheatStage = 0
			if(this.bArchiveMode) then
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				ifs_sp_briefing_fnSetMode(this,nil)
			else
				
				ifelm_shellscreen_fnPlaySound(this.acceptSound)
				-- Time to launch
				if(Selection.side) then
					ScriptCB_SetPlayerSide(Selection.side,0)
					ScriptCB_SetPlayerSide(Selection.side,1)
				end
				-- play this movie when we enter yoda			
				ifs_sp_yoda.playIntroMovie 	    = Selection.intromovie
				ifs_sp_yoda.playIntroMovieLocalized = Selection.intromovielocalized
				-- play this movie after yoda
				ifs_sp_yoda.playOuttroMovie 	     = Selection.outtromovie
				ifs_sp_yoda.playOuttroMovie_left 	     = Selection.outtromovie_left
				ifs_sp_yoda.playOuttroMovie_top 	     = Selection.outtromovie_top
				ifs_sp_yoda.playOuttroMovie_width 	     = Selection.outtromovie_width
				ifs_sp_yoda.playOuttroMovie_height 	     = Selection.outtromovie_height
				ifs_sp_yoda.playOuttroMovieLocalized = Selection.outtromovielocalized

				ScriptCB_SaveCampaignState(this.iCampaignNum,this.iSelected == this.iProgress,this.iSelected)
				ScriptCB_SetMissionNames(Selection.mapluafile,nil) -- launch mission
				ScriptCB_SetCanSwitchSides(nil) -- no!
				ScriptCB_SetHistoricalRulesOn(1)

				-- do the difficulty screen?
				--if(not this.skipDifficulty) then
				-- Reset difficulty to what's in profile
				ScriptCB_SetDifficulty(ScriptCB_GetDifficulty())
				--ScriptCB_EnterMission() --hack
				ifs_movietrans_PushScreen(ifs_sp_yoda)
				--else
				--	this.skipDifficulty = nil
				--	ifs_sp_briefing_fnDidDifficulty()
				--end
			end
		else
		
		end 
	
		
	end,
	Update = function(this, fDt)
		gIFShellScreenTemplate_fnUpdate(this, fDt)  -- call base class
		if( gPlatformStr == "PC" ) then
		
		if( ifs_sp_briefing.era == "new" ) then
			--this.buttons["classic"].textcolorr = 255
			--this.buttons["classic"].textcolorg = 255
			--this.buttons["classic"].textcolorb = 255
			--IFObj_fnSetColor( this.buttons["classic"] ,255,255,255)
		else
			--this.buttons["new"].textcolorr = 255
			--this.buttons["new"].textcolorg = 255
			--this.buttons["new"].textcolorn = 255
			--IFObj_fnSetColor( this.buttons["new"] ,255,255,255)
		end
		--IFObj_fnSetColor( this.buttons[ifs_sp_briefing.era] ,100,255,100)
		--IFObj_fnSetColor( this.buttons[ifs_sp_briefing.era] ,200,180,140)
		end

	end,
	Input_Back = function(this)
		if(this.bArchiveMode) then
			ifs_sp_briefing_fnSetMode(this,nil)
		else
			ScriptCB_PopScreen()
		end
		this.iCheatStage = 0
	end,

	iCheatStage = 0,

	-- Disable these buttons
	Input_GeneralLeft = function(this)
		if((this.iSelected > 1) and (not this.Previews.ModelC.bAnimActive)) then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
			this.iSelected = this.iSelected - 1
			ifs_sp_briefing_fnUpdateScreen(this)
			ifs_sp_briefing_fnChangeSel(this, 1)
		end
		this.iCheatStage = 0
	end,

	Input_GeneralRight = function(this)
		if((this.iSelected < this.iProgress) and (not this.Previews.ModelC.bAnimActive)) then
			ifelm_shellscreen_fnPlaySound(this.selectSound)
			this.iSelected = this.iSelected + 1
			ifs_sp_briefing_fnUpdateScreen(this)
			ifs_sp_briefing_fnChangeSel(this, -1)
		end
		this.iCheatStage = 0
	end, 
 
	-- Disable these buttons before release!
	Input_GeneralUp = function(this)
		if( gPlatformStr == "PC") then
			if(this.CurButton == "new" ) then
				SetCurButtonTable(this.buttons.back)	
			elseif(this.CurButton == "launch" ) then
				SetCurButtonTable(this.buttons.classic)	
			elseif(this.CurButton == "back" ) then
				SetCurButtonTable(this.buttons.launch)	
			else
				gDefault_Input_GeneralUp(this)
			end
		end
		this.iCheatStage = 0
	end,
	Input_GeneralDown = function(this)
		if( gPlatformStr == "PC") then
			if(this.CurButton == "classic" ) then
				SetCurButtonTable(this.buttons.launch)	
			elseif (this.CurButton == "launch" ) then
				SetCurButtonTable(this.buttons.back)	
			elseif (this.CurButton == "back" ) then
				SetCurButtonTable(this.buttons.new)	
			else
				gDefault_Input_GeneralDown(this)
			end
		end
-- 		if(this.iProgress > this.iSelected) then
-- 			this.iProgress = this.iProgress - 1
-- 			print("SP Progress = ", this.iProgress, "Max = ",this.iMaxMissions)
-- 			ifs_sp_briefing_fnUpdateScreen(this)
-- 		end
		this.iCheatStage = 0
	end,

	Input_Misc = function(this)
		if((this.iCheatStage == 0) or (this.iCheatStage == 2)) then
			this.iCheatStage = this.iCheatStage + 1
		end
	end,

	Input_Misc2 = function(this)
		if((this.iCheatStage == 1) or (this.iCheatStage == 3)) then
			this.iCheatStage = this.iCheatStage + 1
		end
		if(this.iCheatStage == 4) then
			this.iProgress = this.iMaxMissions
			ifelm_shellscreen_fnPlaySound(this.acceptSound)
			-- do the arrow highlights			
			ifs_sp_briefing_fnUpdateScreen(this)			
			ifs_sp_briefing_fnChangeSel(this, 0)
		end
	end,

--	fnSaveProfileDone = ifs_archive_fnSaveProfileDone,
}


--getting moved into here for the PC
ifs_briefing_era_vbutton_layout = {
	width = 200,
	ySpacing = 5,
	font = "gamefont_tiny",
	
	buttonlist = { 
		{ tag = "new", string = "common.era.cw", },
		{ tag = "classic", string = "common.era.gcw", },
	},
	title = "ifs.sp.pick_era",
    rotY = 20,
}

-- Programatically builds this screen
function ifs_sp_briefing_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	local HalfWidth = w * 0.5
	-- The half-size (around the center) of the large and small
	-- previews. These should sum to about 0.5 to make everything fit
	-- (over 0.5 means safezones will be exceeded)

	if(gPlatformStr == "XBox") then
		w = w * 0.8 -- shink to fit screen better
	end

	local LargeSize = w * 0.2
	local SmallSize = w * 0.2

	local LargeScale = 0.10
	local SmallScale = 0.03

	if(gPlatformStr == "XBox") then
--		LargeScale = 0.11
--		SmallScale = 0.035
		LargeScale = 0.055
		SmallScale = 0.017
	end

	-- Store for later
	this.fLargeSize = LargeSize
	this.fSmallSize = SmallSize
	this.fLargeScale = LargeScale
	this.fSmallScale = SmallScale

	this.Previews.ModelC = NewIFModel {
		x = 0, y = 0, ---SmallSize,
		scale = LargeScale,
		OmegaY = 0.2,
		lighting = 1,
--		ZPos = 90,
-- 		model = "planet_BES",
-- 		OmegaY = 0.67,
	}
	this.PreviewsHolo.ModelC = NewIFModel {
		x = 0, y = 0, ---SmallSize,
		scale = LargeScale,
		OmegaY = 0.2,
		lighting = 1,
	}

	this.Previews.ItemC = NewIFMapPreview {
		x = LargeSize * -1.2, y = -LargeSize * 0.85,
		width = LargeSize * 0.6,
	}

	this.Previews.ModelL = NewIFModel {
		x = -(LargeSize + SmallSize), y = 0, -- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}
	this.PreviewsHolo.ModelL = NewIFModel {
		x = -(LargeSize + SmallSize), y = 0, -- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}

	this.Previews.ModelL2 = NewIFModel {
		x = -(LargeSize + SmallSize), y = 0, -- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}
	this.PreviewsHolo.ModelL2 = NewIFModel {
		x = -(LargeSize + SmallSize), y = 0, -- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}

	this.Previews.ModelR = NewIFModel {
		x = (LargeSize + SmallSize), y = 0,-- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}
	this.PreviewsHolo.ModelR = NewIFModel {
		x = (LargeSize + SmallSize), y = 0,-- SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}

	this.Previews.ModelR2 = NewIFModel {
		x = (LargeSize + SmallSize), y = 0, --SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}
	this.PreviewsHolo.ModelR2 = NewIFModel {
		x = (LargeSize + SmallSize), y = 0, --SmallSize,
		scale = SmallScale,
		OmegaY = 0.2,
		lighting = 1,
	}
	
	this.buttons = NewIFContainer {
		ScreenRelativeX = 0.0, -- center
		ScreenRelativeY = 0.0, -- top
	}
	
	
	--ifs_briefing_era_vbutton_layout.yTop = h*.1
	--ifs_briefing_era_vbutton_layout.xStart = ifs_briefing_era_vbutton_layout.width/2
	if (gPlatformStr == "PC") then
	----	AddVerticalButtons(this.buttons,ifs_briefing_era_vbutton_layout)

		local BackButtonW = 100
		this.buttons.launch  = NewClickableIFButton  
		{ 
			x = w/2 - BackButtonW + 25,
			y = h - 15, 
			btnw = BackButtonW, 
			btnh =  ScriptCB_GetFontHeight("gamefont_medium"),
			font = "gamefont_medium", 
--			bg_width = BackButtonW,
			bg_tail = 20,
			nocreatebackground = 1,
		}
		this.buttons.launch.label.bHotspot = 1
		this.buttons.launch.label.fHotspotW = this.buttons.launch.btnw
		this.buttons.launch.label.fHotspotH = this.buttons.launch.btnh
		this.buttons.launch.tag = "launch"
		RoundIFButtonLabel_fnSetString(this.buttons.launch ,"common.accept")
		
	
		
		aw,ah = ScriptCB_GetScreenInfo()
		
		--add the left/right arrows
		local arrowsize = w*.075
		local arrowheight = h*.075
		this.buttons.rightarrow = NewIFImage 
		{
 			ZPos = 0, 
 			x = w/2 + w*.23, 
 			y = h/2, -- inertUVs = 1, --center at the middle
 			alpha = 180,
 			localpos_l = -arrowsize/2, localpos_t = -arrowheight/2,
 			localpos_r =  arrowsize/2, localpos_b =  arrowheight/2,
 		
 		--	localpos_l = -w, localpos_t = -h,
 		--	localpos_r =  w, localpos_b =  h,
 			
			--ColorR = 0, ColorG = 0, ColorB =255, -- black
			texture = "small_arrow",
			tag = "rightarrow",
 		}
 		this.buttons.rightarrow.bHotspot = 1
		this.buttons.rightarrow.fHotspotW = arrowsize
		this.buttons.rightarrow.fHotspotH = arrowsize
		this.buttons.rightarrow.fHotspotX = -arrowsize/2
		this.buttons.rightarrow.fHotspotY = -arrowsize/2
 		
 		this.buttons.leftarrow = NewIFImage 
		{
 			ZPos = 0, 
 			x =  w/2 - (w*.23)  , 
 			y = h/2, -- inertUVs = 1, --center at the middle
 			alpha = 180,
 			localpos_l = -(arrowsize/2), localpos_t = -arrowheight/2,
 			localpos_r =  (arrowsize/2), localpos_b =  arrowheight/2,
			--ColorR = 0, ColorG = 0, ColorB =255, -- black
			texture = "small_arrow",
			tag = "leftarrow",
 		}
 		this.buttons.leftarrow.bHotspot = 1
		this.buttons.leftarrow.fHotspotW = arrowsize
		this.buttons.leftarrow.fHotspotH = arrowsize
		this.buttons.leftarrow.fHotspotX = -arrowsize/2
		this.buttons.leftarrow.fHotspotY = -arrowsize/2
 		
		IFImage_fnSetUVs(this.buttons.leftarrow,1,0,0,1)
	
	end
end

ifs_sp_briefing_fnBuildScreen(ifs_sp_briefing)
ifs_sp_briefing_fnBuildScreen = nil -- dump out of memory to save space
AddIFScreen(ifs_sp_briefing,"ifs_sp_briefing")