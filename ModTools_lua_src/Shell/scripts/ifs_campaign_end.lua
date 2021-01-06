--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_campaign_end = NewIFShellScreen {
	nologo = 1,
	movieIntro      = nil,
	movieBackground = nil,
	bNohelptext_accept = 1,
	bNohelptext_back = 1,
	bNohelptext_backPC = 1,
			
	Enter = function(this, bFwd)
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		if bFwd then
			-- Rise of empire is completed, set flag to enable scenarios
			ScriptCB_SetSPProgress(2,2)
			
			-- show the whole galaxy, because it's cool
			ifs_campaign_main:SetZoom(0)
			SnapMapCamera()
			ifs_campaign_main:UpdateZoom()
			
		elseif this.playedCredits then
			-- reset the shell
			this:Done()
		end
	end,
	
	Exit = function(this, bFwd)
--		gIFShellScreenTemplate_fnExit(this)
		if not bFwd then
			this.playedCredits = nil
		end
	end,
	
	Update = function(this)
		-- show the credits
		ScriptCB_PushScreen("ifs_credits")
		this.playedCredits = true
	end,
	
	Done = function(this)
		-- reset everything (like quit)
		ScriptCB_ClearMetagameState()
		ScriptCB_ClearCampaignState()
		ScriptCB_ClearMissionSetup();
		SetState("shell")
	end,
	
	Input_Accept = function(this)
	end,
	
	Input_Back = function(this)
	end,
	
	Input_Misc = function(this)
	end,
}

AddIFScreen(ifs_campaign_end,"ifs_campaign_end")
