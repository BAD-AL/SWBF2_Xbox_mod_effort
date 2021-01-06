--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


-----------------------------------------------------------------------
-- main screen
-----------------------------------------------------------------------

ifs_mpps2_eula = NewIFShellScreen {
 	nologo = 1,
 	bg_texture = "iface_bgmeta_space",
	movieIntro      = nil,
	movieBackground = nil,
 	
	Enter = function(this,bFwd)
		print("ifs_mpps2_eula.Enter(",bFwd,")")
		gIFShellScreenTemplate_fnEnter(this, bFwd)

		-- Added chunk for error handling...
		if(not bFwd) then
			local ErrorLevel,ErrorMessage = ScriptCB_GetError()
--			print("ifs_mp_main, ErrorLevel = ",ErrorLevel)
			if(ErrorLevel >= 8) then -- login error, must keep going further
				ScriptCB_PopScreen()
			end
		end
		
		-- index the text body
		this.numPages = ScriptCB_IndexMultipageText("ifs.mp.dnas.eula","ifs_mpps2_eula.eulaBox.eulaText")

		-- show the first page of text
		this.curPage = 1
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText",this.curPage)
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText2",this.curPage + 1)
		
		-- size the slider bar
		local SliderHeight = this.eulaBox.slider_bot - this.eulaBox.slider_top
		local NewTop = this.eulaBox.slider_top + SliderHeight * (this.curPage / (this.numPages+2))
		local NewBot = this.eulaBox.slider_top + SliderHeight * ((this.curPage+2) / (this.numPages+2))
		IFImage_fnSetTexturePos(this.eulaBox.sliderfg,0,NewTop,16,NewBot)        
      
	end,
	
	Input_Accept = function(this)
		ScriptCB_SetHasSeenDNASEULA()
		ifs_mpps2_dnas.ReturningFromEULA = 1
		ScriptCB_PopScreen()
	end,	


	Input_GeneralUp = function(this)
		this.curPage = math.max(1,this.curPage - 2)
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText",this.curPage)
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText2",this.curPage + 1)
		-- size the slider bar
		local SliderHeight = this.eulaBox.slider_bot - this.eulaBox.slider_top
		local NewTop = this.eulaBox.slider_top + SliderHeight * (this.curPage / (this.numPages+2))
		local NewBot = this.eulaBox.slider_top + SliderHeight * ((this.curPage+2) / (this.numPages+2))
		IFImage_fnSetTexturePos(this.eulaBox.sliderfg,0,NewTop,16,NewBot)        
	end,

	Input_GeneralRight = function(this)
	end,

	Input_GeneralDown = function(this)
		this.curPage = math.min(this.numPages,this.curPage + 2)
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText",this.curPage)
		ScriptCB_ShowMultipageText("ifs_mpps2_eula.eulaBox.eulaText2",this.curPage + 1)
		-- size the slider bar
		local SliderHeight = this.eulaBox.slider_bot - this.eulaBox.slider_top
		local NewTop = this.eulaBox.slider_top + SliderHeight * (this.curPage / (this.numPages+2))
		local NewBot = this.eulaBox.slider_top + SliderHeight * ((this.curPage+2) / (this.numPages+2))
		IFImage_fnSetTexturePos(this.eulaBox.sliderfg,0,NewTop,16,NewBot)
	end,

	Input_GeneralLeft = function(this)
	end,

	Input_GeneralUp2 = function(this)
	end,

	Input_GeneralRight2 = function(this)
	end,

	Input_GeneralDown2 = function(this)
	end,

	Input_GeneralLeft2 = function(this)
	end,

}


-- build the screen
function ifs_mpps2_eula_fnBuildScreen(this)	
	local w,h,v = ScriptCB_GetSafeScreenInfo()

	local BoxW = w * 0.95
	local BoxH = h * 0.9
	local TextBoxW = BoxW * 0.9
	local TextBoxH = BoxH * 0.5
	local fontHeight = ScriptCB_GetFontHeight("gamefont_tiny")
	
	this.eulaBox = NewIFContainer {
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 0.45,
		width = BoxW,
		height = BoxH,
		header = "Foo",
		x=0,y=0,
		
		border = NewButtonWindow {
			font = "gamefont_tiny",
			x = 0,
			y = 0,
			width = BoxW,
			height = BoxH + 10,
			ZPos = 220,
		},		
		eulaText = NewIFText {
			string = "text",
			font = "gamefont_small",
			halign = "left",
			valign = "top",
			flashy = 0,
			textw = TextBoxW,
			texth = TextBoxH,
			x = TextBoxW * -0.52,
			y = TextBoxH * -1.0,
		},
		-- need two of these since one can only have 512 characters in it, and a full page
		-- of tiny font text is more than that.
		eulaText2 = NewIFText {
			string = "text",
			font = "gamefont_small",
			halign = "left",
			valign = "top",
			flashy=0,
			textw = TextBoxW,
			texth = TextBoxH,
			x = TextBoxW * -0.52,
			y = TextBoxH * -1.0 + math.floor(TextBoxH / fontHeight) * fontHeight,
		},
		
		slider_top = -TextBoxH,
		slider_bot =  TextBoxH - 10,
		sliderbg = NewIFImage { ZPos = 160, x = TextBoxW*0.5, y = 0, 
			localpos_l = 0, localpos_r = 16, 
			localpos_t = -TextBoxH, localpos_b = TextBoxH-10,
			texture = "slider_bg"
		},
		sliderfg = NewIFImage { ZPos = 159, x = TextBoxW*0.5, y = 0, 
			localpos_l = 0, localpos_r = 16, 
			localpos_t = 0, localpos_b = 10,
			texture = "slider_fg"
		},		
	}

	
end


ifs_mpps2_eula_fnBuildScreen(ifs_mpps2_eula)
ifs_mpps2_eula_fnBuildScreen = nil
AddIFScreen(ifs_mpps2_eula,"ifs_mpps2_eula")
