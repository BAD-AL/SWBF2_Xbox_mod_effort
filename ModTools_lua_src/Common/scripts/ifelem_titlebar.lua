--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a expandable (horizontally) titlebar
--
-- Broken off from interface_util.lua for better encapsulation

-- fnSetSize for a TitleBar's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances. Bugs: 32x32 is the smallest size possible
function TitleBarSkin_fnSetSize(this,w,h)
	-- Massive duplication. Sorry. :(
 	local x1 = (w * -0.5)
 	local x2 = x1 + 64
 	local x3 = (w *  0.5) - 32
 	local x4 = x3 + 32

	IFImage_fnSetTexturePos(this.ChunkL ,x1  ,-16,x2+1,16)
	IFImage_fnSetTexturePos(this.ChunkC ,x2-1,-16,x3,16) -- slightly overlap to avoid gap
	IFImage_fnSetTexturePos(this.ChunkR ,x3  ,-16,x4,16)
end

-- fnSelect for a TitleBar's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function TitleBarSkin_fnSelect(this,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkL,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkC,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkR,NewTexture,NewAlpha)
end

-- fnSetSize for a TitleBar's Label. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function TitleBarLabel_fnSetSize(this,w,h)
	this.label.x = w * -0.5
	this.label.y = h * -0.5
	this.label.textw = w
	this.label.texth = h
end

function TitleBarLabel_fnSetString(this,str)
	IFText_fnSetString(this.labels.label,str)
end

function TitleBarLabel_fnSetUString(this,str)
	IFText_fnSetUString(this.labels.label,str)
end


function TitleBarLabel_fnHilight(this,on,fDt,w,h)
	if(on) then
-- 		gButton_CurSizeAdd = gButton_CurSizeAdd + fDt * gButton_CurDir
--  		if(gButton_CurSizeAdd > 1) then
-- 			gButton_CurSizeAdd = 1
--  			gButton_CurDir = -math.abs(gButton_CurDir)
--  		elseif (gButton_CurSizeAdd < 0.3) then
-- 			gButton_CurSizeAdd = 0.3
--  			gButton_CurDir = math.abs(gButton_CurDir)
--  		end

		-- Shell has label2 background text. Game doesn't. Blink one of them
		IFObj_fnSetAlpha(this.label,gButton_CurSizeAdd)
	end
end

function TitleBarSkin_fnHilight(this,on,fDt,w,h)
	TitleBarSkin_fnSetSize(this,w,h) -- Off? Revert to standard size.
end


function NewIFTitleBar(Template)

	local temp = Template

 	temp.skin = NewIFContainer {
 		ZPos = 140, -- Text will be at 128 by default, be a bit behind it
 		-- 8 chunks for the pieces of the texture. Note: no texture is specified,
 		-- as that's done in fnSelect
 		ChunkL  = NewIFImage { texture = "titlebar_l", uvs_l = 0.0, uvs_r = 1.0, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
 		ChunkC  = NewIFImage { texture = "titlebar_r", uvs_l = 0.0, uvs_r = 0.5, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
 		ChunkR  = NewIFImage { texture = "titlebar_r", uvs_l = 0.5, uvs_r = 1.0, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
 	} -- end of skin

	if(Template.yFlip) then
		temp.skin.ChunkL.uvs_t,temp.skin.ChunkL.uvs_b = temp.skin.ChunkL.uvs_b,temp.skin.ChunkL.uvs_t
		temp.skin.ChunkR.uvs_t,temp.skin.ChunkR.uvs_b = temp.skin.ChunkR.uvs_b,temp.skin.ChunkR.uvs_t
		Template.yFlip = nil
	end

 	temp.labels = NewIFContainer {
		y = -2, 

		label = NewIFText {
			valign = "vcenter",
			inert_all = 1,
			font = Template.font,
--			ColorR = 255, ColorG = 255, ColorB = 255,
		}, -- end of label
	}

	local Width = Template.width or 200
	TitleBarSkin_fnSetSize(temp.skin,Width,32)
	TitleBarLabel_fnSetSize(temp.labels,Width,32)

	if(Template.string) then
		TitleBarLabel_fnSetString(temp,Template.string)
		Template.string = nil
	end
	if(Template.ustring) then
		TitleBarLabel_fnSetUString(temp,Template.ustring)
		Template.ustring = nil
	end

	-- Make a button from this expanded template
	return NewIFContainer(temp)
end
