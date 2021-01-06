--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a rounded interface button (BorderRect)
--
-- [Requires ifelem_button.lua to be already loaded, executed]
--
-- Broken off from interface_util.lua for better encapsulation


-- fnSetSize for a BorderRect's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances. Bugs: 32x32 is the smallest size possible
function BorderRectSkin_fnSetSize(this,w,h)
	local borderw = w < 32 and w*0.5 or 16
	local borderh = h < 32 and h*0.5 or 16
	IFBorder_fnSetTexturePos(this, w*-0.5, h*-0.5, w*0.5, h*0.5, borderw, borderh)
end

-- fnSelect for a BorderRect's Skin. Pulled out so its
-- implementation could be properly shared (refcounted) among all
-- instances
function BorderRect_fnSetTexture(this,NewTexture,NewAlpha)
	IFBorder_fnSetTexture(this, NewTexture, NewAlpha)
end

function BorderRectSkin_fnHilight(this,on,fDt,w,h)
	BorderRectSkin_fnSetSize(this,w,h) -- Off? Revert to standard size.
end


-- Like NewIFButton, but puts a nice fancy skin on it.
function NewBorderRect(Template)

	local temp = Template

	-- 8 chunks for the pieces of the texture. Note: no texture is specified,
	-- as that's done in fnSelect
	temp.skin = NewIFBorder {
		uvs_l = 0.0,
		uvs_t = 0.0,
		uvs_r = 1.0,
		uvs_b = 1.0,
		uvs_w = 0.25,
		uvs_h = 0.25,
		inert_all = 1,
		texture = "opaque_rect",
	}

	if(Template.width) then
		BorderRectSkin_fnSetSize(temp.skin,Template.width,Template.height)
	end

	-- Make an item from this expanded template
	return NewIFContainer(temp)
end
