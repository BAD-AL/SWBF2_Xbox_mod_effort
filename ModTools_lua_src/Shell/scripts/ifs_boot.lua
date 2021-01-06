--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

ifs_boot = NewIFShellScreen {
	bNohelptext = 1, -- turn off the bottom buttons
    enterSound  = "",
    exitSound   = "",

 	title = NewIFText {
 		string = "ifs.start.nocontroller",
 		font = "gamefont_large",
 		textw = 460,
		texth = 200,
		y = -200,
 		ScreenRelativeX = 0.5, -- center
 		ScreenRelativeY = 0.95, -- almost-bottom
 		startdelay = 0.4,
		valign = "bottom",
		nocreatebackground = 1,
	},

	Enter = function(this, bFwd)
--		print("ifs_boot.Enter")
		-- Always call base class functionality
		gIFShellScreenTemplate_fnEnter(this, bFwd)
		
		this.WaitingForController = nil
		
		--if we're ps2, do the initial check for space		
		if( gPlatformStr == "PS2" ) then		
			-- are there enough controllers?
			local iNumControllers = ScriptCB_GetNumControllers()
			if(iNumControllers < 1) then
--				print("not enough controllers")
				-- stay here and show the message
				this.WaitingForController = 1
				return
			end			
		
			-- do the initial memcard check?
			if( ScriptCB_DoInitialMemcardCheck() ) then
				-- allow all controllers
				ScriptCB_SetAutoAcquireControllers(1)
				ScriptCB_ReadAllControllers(1)
				
				-- do the check
				ifs_saveop.doOp = "InitialMemcardCheck"
				ifs_saveop.OnSuccess = ifs_boot_InitialMemcardCheckSuccessPS2
				ifs_saveop.OnCancel = ifs_boot_InitialMemcardCheckCancelPS2
				ifs_movietrans_PushScreen(ifs_saveop)
				return
			end
		end
		
		-- if we got this far we don't have anything left to boot check, so jump forwards
		ifs_movietrans_PushScreen(ifs_legal)
	end,

	-- Do nothing on this screen
	Input_Back = function(this)
	end,

	fControllerCheck = -1, -- force an update asap
	Update = function(this, fDt)
		-- Call base class functionality
		gIFShellScreenTemplate_fnUpdate(this, fDt)

		if(this.WaitingForController) then
			-- Do periodic check if controllers are present.
			this.fControllerCheck = this.fControllerCheck - fDt
			if(this.fControllerCheck < 0) then
				this.fControllerCheck = 0.25
				local iNumControllers = ScriptCB_GetNumControllers()
				if(iNumControllers > 0) then
					-- reenter this screen
					this.Enter(this,1)
					return
				end
			end
		end
	end,

	-- Overrides for most input handlers, as we want to do nothing
	-- when this happens on this screen.
	Input_Accept = function(this) 
	end,
	Input_GeneralLeft = function(this,bFromAI)
	end,
	Input_GeneralRight = function(this,bFromAI)
	end,
	Input_GeneralUp = function(this,bFromAI)
	end,
	Input_GeneralDown = function(this,bFromAI)
	end,
}

----------------------------------------------------------------------------------------
-- initial memcard check (on enter)
----------------------------------------------------------------------------------------

function ifs_boot_InitialMemcardCheckSuccessPS2()
--	print("ifs_boot_InitialMemcardCheckSuccessPS2")
	
	-- disallow all controllers
	ScriptCB_SetAutoAcquireControllers(nil)
	ScriptCB_ReadAllControllers(nil)
	if(ScriptCB_SkipToNTGUI()) then
		ScriptCB_UnbindController(-2) -- all controllers, except primary
	else
		ScriptCB_UnbindController(-1) -- all controllers
	end

	-- pop the ifs_saveop screen
	ScriptCB_PopScreen()
end

function ifs_boot_InitialMemcardCheckCancelPS2()
--	print("ifs_boot_InitialMemcardCheckCancelPS2")
	
	-- disallow all controllers
	ScriptCB_SetAutoAcquireControllers(nil)
	ScriptCB_ReadAllControllers(nil)
	if(ScriptCB_SkipToNTGUI()) then
		ScriptCB_UnbindController(-2) -- all controllers, except primary
	else
		ScriptCB_UnbindController(-1) -- all controllers
	end
	
--	print("cancel jumpToNTGUI")
	ScriptCB_ResetSkipToNTGUI()
	
	ifs_boot_InitialMemcardCheckSuccessPS2()
end

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

AddIFScreen(ifs_boot,"ifs_boot")