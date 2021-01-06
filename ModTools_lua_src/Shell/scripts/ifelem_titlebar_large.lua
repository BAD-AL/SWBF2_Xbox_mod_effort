--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a expandable (horizontally) titlebar
--
-- Broken off from interface_util.lua for better encapsulation

-- fnSetSize for a TitleBarLarge's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances. Bugs: 32x32 is the smallest size possible
function TitleBarLargeSkin_fnSetSize(this,w,h)
	-- Massive duplication. Sorry. :(
 	local x1 = (w * -0.5)
 	local x2 = x1 + 122
 	local x3 = (w *  0.5) - 70
 	local x4 = x3 + 70

	IFImage_fnSetTexturePos(this.ChunkL ,x1  ,-32,x2,32)
	IFImage_fnSetTexturePos(this.ChunkC ,x2  ,-32,x3,32)
	IFImage_fnSetTexturePos(this.ChunkR ,x3  ,-32,x4,32)
end

-- fnSelect for a TitleBarLarge's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function TitleBarLargeSkin_fnSelect(this,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkL,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkC,NewTexture,NewAlpha)
	IFImage_fnSetTexture(this.ChunkR,NewTexture,NewAlpha)
end

-- fnSetSize for a TitleBarLarge's Label. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function TitleBarLargeLabel_fnSetSize(this,w,h)
	this.label.x = w * -0.5
	this.label.y = h * -0.5
	this.label.textw = w
	this.label.texth = h
end

function TitleBarLargeLabel_fnSetString(this,str)
	IFText_fnSetString(this.labels.label,str)
end

function TitleBarLargeLabel_fnSetUString(this,str)
	IFText_fnSetUString(this.labels.label,str)
end


function TitleBarLargeLabel_fnHilight(this,on,fDt,w,h)
	if(on) then
-- 		gButton_CurSizeAdd = gButton_CurSizeAdd + fDt * gButton_CurDir
--  		if(gButton_CurSizeAdd > 1) then
-- 			gButton_CurSizeAdd = 1
--  			gButton_CurDir = -math.abs(gButton_CurDir)
--  		elseif (gButton_CurSizeAdd < 0.3) then
-- 			gButton_CurSizeAdd = 0.3
--  			gButton_CurDir = math.abs(gButton_CurDir)
--  		end

		IFObj_fnSetAlpha(this.label,gButton_CurSizeAdd)
	end
end

function TitleBarLargeSkin_fnHilight(this,on,fDt,w,h)
	TitleBarLargeSkin_fnSetSize(this,w,h) -- Off? Revert to standard size.
end


-- NOTE: We canNOT do the "local temp = createObj(gIFRoundButtonTemplate , Template)"
-- approach here, as that'll create just one skin & label, which is
-- shared among all instances. This approach here uses a bit more
-- memory, but should work more reliably - NM 6/25/03

function NewIFTitleBarLarge(Template)

	local temp = Template --createObj(gIFRoundButtonTemplate , Template)

 	temp.skin = NewIFContainer {
 		ZPos = 140, -- Text will be at 128 by default, be a bit behind it

		-- Splits are at 122 & 186 of a 256-wide texture, rounded to 0.47, 0.72
 		ChunkL  = NewIFImage { texture = "titlebar_large", uvs_l = 0.00, uvs_r = 0.47, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
 		ChunkC  = NewIFImage { texture = "titlebar_large", uvs_l = 0.47, uvs_r = 0.72, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
 		ChunkR  = NewIFImage { texture = "titlebar_large", uvs_l = 0.72, uvs_r = 1.00, uvs_t = 0.00, uvs_b = 1.00, inert_all = 1, ZPos = 190},
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
	TitleBarLargeSkin_fnSetSize(temp.skin,Width,32)
	TitleBarLargeLabel_fnSetSize(temp.labels,Width,32)

	if(Template.string) then
		TitleBarLargeLabel_fnSetString(temp,Template.string)
		Template.string = nil
	end
	if(Template.ustring) then
		TitleBarLargeLabel_fnSetUString(temp,Template.ustring)
		Template.ustring = nil
	end

	-- Make a button from this expanded template
	return NewIFContainer(temp)
end
