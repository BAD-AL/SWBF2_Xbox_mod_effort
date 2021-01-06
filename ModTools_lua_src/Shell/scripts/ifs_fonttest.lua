--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--


gFontList_PC = {
	"gamefont_super_tiny",
	"gamefont_tiny",
	"gamefont_small",
	"gamefont_medium",
	"gamefont_large",
}

gFontList_Console = {
	"gamefont_tiny",
	"gamefont_small",
	"gamefont_medium",
	"gamefont_large",
--	"gamefont_super_tiny",
}

gFontList_BackgroundTextures = {
	"iface_bgmeta_space",
	"movie_bg",
	"movie_bg2",
	"his_brief_bg",
	"",
}

gFontList_TextColors = {
	{255, 255, 255, },
	{128, 128, 128, },
	{0, 0, 0},
	{255, 0, 0,},
	{0, 255, 0 },
	{0, 0, 255 },
	{255, 255, 0 },
	{255, 0, 255 },
	{0, 255, 255},
}

function ifs_fonttest_fnSetColor(this, iColorIdx)
	local NumColors = table.getn(gFontList_TextColors)
	if (iColorIdx > NumColors) then
		iColorIdx = 1
	elseif (iColorIdx < 1) then
		iColorIdx = NumColors
	end

	this.iColorIdx = iColorIdx

	local R,G,B
	R = gFontList_TextColors[iColorIdx][1]
	G = gFontList_TextColors[iColorIdx][2]
	B = gFontList_TextColors[iColorIdx][3]

	IFObj_fnSetColor(this.TestString , R, G, B)
	IFObj_fnSetColor(this.TestCaps , R, G, B)
	IFObj_fnSetColor(this.TestLower , R, G, B)
	IFObj_fnSetColor(this.TestNumbers , R, G, B)
	IFObj_fnSetColor(this.TestPunctuation , R, G, B)
	IFObj_fnSetColor(this.TestOther , R, G, B)
end

function ifs_fonttest_fnSetBackground(this, iBackgroundIdx)
	local NumBGs = table.getn(gFontList_BackgroundTextures)
	if(iBackgroundIdx > NumBGs) then
		iBackgroundIdx = 1
	elseif (iBackgroundIdx < 1) then
		iBackgroundIdx = NumBGs
	end

	this.iBackgroundIdx = iBackgroundIdx

	local NewBG = gFontList_BackgroundTextures[iBackgroundIdx]
	if(NewBG ~= "") then
		IFImage_fnSetTexture(this.bg, NewBG)
		IFObj_fnSetVis(this.bg, 1)
	else
		IFObj_fnSetVis(this.bg, nil)
	end

end

function ifs_fonttest_fnSetFont(this, iFontIdx)
	local UseList
	local ListSize

	if (gPlatformStr == "PC") then
		UseList = gFontList_PC
	else
		UseList = gFontList_Console
	end

	ListSize = table.getn(UseList)
	if (iFontIdx < 1) then
		iFontIdx = ListSize
	elseif (iFontIdx > ListSize) then
		iFontIdx = 1
	end
	
	this.iFontIdx = iFontIdx
	local UseFont = UseList[iFontIdx]

	local yPos = 10
	local fLeft, fTop, fRight, fBot

	IFObj_fnSetPos(this.TestString, 10, yPos)
	IFText_fnSetFont(this.TestString, UseFont)
	IFText_fnSetString(this.TestString, "The Quick Brown Fox Jumps Over The Lazy Dog. Pack My Box With Five Dozen Liquor Jugs.")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestString)
	yPos = yPos + 5 + (fBot - fTop)

	IFObj_fnSetPos(this.TestCaps, 10, yPos)
	IFText_fnSetFont(this.TestCaps, UseFont)
	IFText_fnSetString(this.TestCaps, "ABCDE FGHIJ KLMNO PQRST UVWXYZ ÀÁÂÃÄ ÅÆÇÈÉ ÊËÌÍÎ ÏÐÑÒÓ ÔÕÖÙÚ ÛÜÝÞß")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestCaps)
	yPos = yPos + 5 + (fBot - fTop)

	IFObj_fnSetPos(this.TestLower, 10, yPos)
	IFText_fnSetFont(this.TestLower, UseFont)
	IFText_fnSetString(this.TestLower, "abcde fghij klmno pqrst uvwxyz àáâã äåæçè éêëìí îïñòó ôõöøù úûüýÿ")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestLower)
	yPos = yPos + 5 + (fBot - fTop)

	IFObj_fnSetPos(this.TestNumbers, 10, yPos)
	IFText_fnSetFont(this.TestNumbers, UseFont)
	IFText_fnSetString(this.TestNumbers, "01234567890 ")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestNumbers)
	yPos = yPos + 5 + (fBot - fTop)

	IFObj_fnSetPos(this.TestPunctuation, 10, yPos)
	IFText_fnSetFont(this.TestPunctuation, UseFont)
	IFText_fnSetString(this.TestPunctuation, "~!@#$%^&*()_+`-= {}|[]\:\";'<>?,./")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestPunctuation)
	yPos = yPos + 5 + (fBot - fTop)

	IFObj_fnSetPos(this.TestOther, 10, yPos)
	IFText_fnSetFont(this.TestOther, UseFont)
	IFText_fnSetString(this.TestOther, "ifs.fonttest.punctuation")
	fLeft, fTop, fRight, fBot = IFText_fnGetDisplayRect(this.TestOther)
	yPos = yPos + 5 + (fBot - fTop)

	IFText_fnSetString(this.CurFont, UseFont)

end

ifs_fonttest = NewIFShellScreen {
	bg_texture = "iface_bgmeta_space",
	bNohelptext_accept = 1,

	TestString = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	TestCaps = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	TestLower = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	TestNumbers = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	TestPunctuation = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	TestOther = NewIFText { 
		ScreenRelativeX = 0,
		ScreenRelativeY = 0,
		x = 10, y = 0, halign = "left", valign = top,
		font = "gamefont_tiny", 
		texth = 130, textw = 700, 
		nocreatebackground = 1, startdelay=0.5, 
	},

	CurFont = NewIFText { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 1,
		y = -30, 
		font = "gamefont_large", 
		texth = 50, textw = 300, 
		startdelay=0, 
	},

	Help = NewIFText { 
		ScreenRelativeX = 0.5,
		ScreenRelativeY = 1,
		y = -90, 
		font = "gamefont_medium", 
		string = "Left/Right to change font.",
		textw = 450, 
		nocreatebackground = 1, startdelay=0, 
	},

	Helptext_Misc = NewHelptext {
		ScreenRelativeX = 0.0, -- Left of center, but not in the normal 'back' position
		ScreenRelativeY = 1.0, -- bot
		y = -45,
		buttonicon = "btnmisc",
		string = "Change Background",
	},

	Helptext_Misc2 = NewHelptext {
		ScreenRelativeX = 1.0, -- right
		ScreenRelativeY = 1.0, -- bot
		y = -45,
		buttonicon = "btnmisc2",
		string = "Change Color",
		bRightJustify = 1,
	},

	buttons = NewIFContainer {
		ScreenRelativeX = 0.5, -- center
		ScreenRelativeY = 0.5, -- center
	},

	iFontIdx = 1,
	iBackgroundIdx = 1,
	iColorIdx = 1,
	Enter = function(this, bFwd)
						gHelptext_fnMoveIcon(this.Helptext_Misc2)
						ifs_fonttest_fnSetFont(this, this.iFontIdx)
						ifs_fonttest_fnSetBackground(this, this.iBackgroundIdx)
						ifs_fonttest_fnSetColor(this, this.iColorIdx)

					end,

	Input_Accept = function(this)
		-- If base class handled this work, then we're done
		if(gCurHiliteButton) then
			print(" gCur.tag = ", gCurHiliteButton.tag) 
			this.CurButton = gCurHiliteButton.tag
		end
		if(gShellScreen_fnDefaultInputAccept(this)) then
			print("fonttest - base handled")
			return
		end
		print("fonttest - base didn't handle", this.CurButton)
	end,

	Input_Back = function(this)
			ScriptCB_PopScreen()
							 end,

	Input_GeneralLeft = function(this)
						ifs_fonttest_fnSetFont(this, this.iFontIdx - 1)
  end,
	Input_GeneralRight = function(this)
						ifs_fonttest_fnSetFont(this, this.iFontIdx + 1)
  end,

	-- Up/Down have no effect on this screen
	Input_GeneralUp = function(this)
										end,
	Input_GeneralDown = function(this)
										end,

	Input_Misc = function(this)
								 ifs_fonttest_fnSetBackground(this, this.iBackgroundIdx + 1)
							 end,

	Input_Misc2 = function(this)
								 ifs_fonttest_fnSetColor(this, this.iColorIdx + 1)
							 end,

}

function ifs_fonttest_fnBuildScreen(this)
	local w,h = ScriptCB_GetSafeScreenInfo() -- of the usable screen
	this.TestString.textw = w - 20
	this.TestCaps.textw = w - 20
	this.TestLower.textw = w - 20
	this.TestNumbers.textw = w - 20
	this.TestPunctuation.textw = w - 20
	this.TestOther.textw = w - 20
end

ifs_fonttest_fnBuildScreen(ifs_fonttest)
ifs_fonttest_fnBuildScreen = nil

AddIFScreen(ifs_fonttest,"ifs_fonttest")
