--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

--
-- Metagame AI
--
--
--
-- Do I look like an AI programmer? I hope not
--

--

function metagame_ai_fnMakeNextMove_pickstatus(this, pState)
	this.selection = "writeme" -- fill in something
	this.WaitMove = 4.0 + (math.random(4) / 10)
	if(pState.numhumans < 1) then
		this.WaitMove = this.WaitMove / 4
	end
end

-- Called from ifs_meta_main.lua:fnUpdate, calls one of the
-- sub-functions for whether it's the planet-picking stage, or
-- gameplay. Should only be called when a popup isn't up.
-- pState should be metagame_state.
function metagame_ai_fnMakeNextMove_status(this, pState, fDt, iJoystick)
	-- Need to determine target planet? Do so.
	if(not this.selection) then
		metagame_ai_fnMakeNextMove_pickstatus(this, pState)
	end

	-- Update time, go right/left as needed.
	this.WaitMove = this.WaitMove - fDt
	if(this.WaitMove < 0) then
		-- Generate move
		local r = math.random(100)

		-- Delay 0.5 - 1 seconds per move
		this.WaitMove= 1

		if(r<70) then
			if(gPlatformStr == "PC") then
				ifs_meta_main.CurButton = "do_accept"
			end
			ifs_meta_main:Input_Accept(iJoystick,1)
			this.selection = nil
		end
	end
end

function metagame_ai_fnMakeNextMove_pickselect(this, pState)
	this.selection = "writeme" -- fill in something
--	this.WaitMove = 4.0 + (math.random(4) / 10)
--	if(pState.numhumans < 1) then
--		this.WaitMove = this.WaitMove / 4
--	end

	-- Delay 0.0 - 0.5 seconds per move
	this.WaitMove = 1
	this.bGoRight = (math.random(100) > 50)
	this.iNumCycles = 0

end

-- Called from ifs_meta_main.lua:fnUpdate, calls one of the
-- sub-functions for whether it's the planet-picking stage, or
-- gameplay. Should only be called when a popup isn't up.
-- pState should be metagame_state.
function metagame_ai_fnMakeNextMove_select(this, pState, fDt, iJoystick)
	-- Need to determine target planet? Do so.
	if(not this.selection) then
		metagame_ai_fnMakeNextMove_pickselect(this, pState)
	end

	-- Delay if any animations are active
	local bCanChoose = 1
	if(ifs_meta_main.AttackItems.ModelC.bAnimActive) then
		bCanChoose = nil
	end
	if((metagame_state_local.mJoystickTeams[iJoystick+1] == 1) and (ifs_meta_main.TopBonus.ItemC.bAnimActive)) then
		bCanChoose = nil
	end
	if((metagame_state_local.mJoystickTeams[iJoystick+1] == 2) and (ifs_meta_main.BotBonus.ItemC.bAnimActive)) then
		bCanChoose = nil
	end

	-- Update time, go right/left as needed.
	this.WaitMove = this.WaitMove - fDt
	if((this.WaitMove < 0) and (bCanChoose)) then
		-- Generate move
		local r = math.random(100)

		-- 20% chance of reversing direction
		if(r < 20) then
			this.bGoRight = not this.bGoRight
			r = math.random(100)
		end

		-- Delay 0.0 - 0.5 seconds per move
		this.WaitMove = 1
--		if(pState.bonusplanet) then
--			this.WaitMove = this.WaitMove* 3
--		end
--		if(pState.numhumans < 1) then
--			this.WaitMove = this.WaitMove / 4
--		end

		if(r < (10 + 5 * this.iNumCycles)) then
			if(gPlatformStr == "PC") then
				ifs_meta_main.CurButton = "do_accept"
			end
			ifs_meta_main:Input_Accept(iJoystick,1)
			this.selection = nil
--			this.WaitMove = this.WaitMove + 3
		else
			this.iNumCycles = this.iNumCycles + 1
			if (this.bGoRight) then
				ifs_meta_main:Input_GeneralRight(iJoystick,1)
			else
				ifs_meta_main:Input_GeneralLeft(iJoystick,1)
			end
		end
	end
end


-- Table for stuffing in any values it wants. Stuff in here is NOT
-- saved across game launches, sorry.
metagame_ai = {
	-- selection = "string" -- [Next planet selected]
	WaitMove = 0,  -- timeout before next move
	passivetimer = 2.0, -- timeout before passive bonus is zapped
	iNumCycles = 0,

}

-- Table for stuffing in any values it wants. Stuff in here is NOT
-- saved across game launches, sorry.
metagame_ai2 = {
	-- selection = "string" -- [Next planet selected]
	WaitMove = 0,  -- timeout before next move
	passivetimer = 2.0, -- timeout before passive bonus is zapped
	iNumCycles = 0,
}

-- Master 'think' function. Called every frame. If team(s) are AI,
-- has them do their work.
function metagame_ai_fnUpdate(pState,fDt)
	local CurPage = gMetagameCurrentPage
	local CurTeam = metagame_state.team1
	local joyIdx = nil
	if(metagame_state_local.mJoystickTeams[1] == 1) then
		joyIdx = 0
	end
	if(metagame_state_local.mJoystickTeams[2] == 1) then
		joyIdx = 1
	end
	-- if player1 and player2 select the same team in split screen mode
	-- AI will take over the third joyStick input
	if( metagame_state_local.mJoystickTeams[1] == metagame_state_local.mJoystickTeams[2] ) then
		joyIdx = 2
	end
	
	if((CurTeam.aicontrol) and (joyIdx)) then
		if((CurPage == 1) and (pState.pickteam == 1)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai,pState,fDt,joyIdx)
		elseif ((CurPage == 2) and (pState.pickteam == 1)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai,pState,fDt,joyIdx)
		elseif ((CurPage == 3) and (metagame_state.pickteam == 1) and (not metagame_vote_state.gBonus1Vote)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai,pState,fDt,joyIdx)
		elseif ((CurPage == 4) and (metagame_state.pickteam == 2) and (not metagame_vote_state.gBonus1Vote)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai,pState,fDt,joyIdx)
		end
	end

	CurTeam = metagame_state.team2
	joyIdx = nil
	if(metagame_state_local.mJoystickTeams[1] == 2) then
		joyIdx = 0
	end
	if(metagame_state_local.mJoystickTeams[2] == 2) then
		joyIdx = 1
	end
	if( metagame_state_local.mJoystickTeams[1] == metagame_state_local.mJoystickTeams[2] ) then
		joyIdx = 2
	end
		
	if((CurTeam.aicontrol) and (joyIdx)) then
		if((CurPage == 1) and (pState.pickteam == 2)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai2,pState,fDt,joyIdx)
		elseif ((CurPage == 2)  and (pState.pickteam == 2)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai2,pState,fDt,joyIdx)
		elseif ((CurPage == 3) and (metagame_state.pickteam == 2) and (not metagame_vote_state.gBonus2Vote)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai2,pState,fDt,joyIdx)
		elseif ((CurPage == 4) and (metagame_state.pickteam == 1) and (not metagame_vote_state.gBonus2Vote)) then
			metagame_ai_fnMakeNextMove_select(metagame_ai2,pState,fDt,joyIdx)
		end
	end
end


