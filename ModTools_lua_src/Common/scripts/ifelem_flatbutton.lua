--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a flated interface button (FlatIFButton)
--
-- [Requires ifelem_button.lua to be already loaded, executed]
--
-- Broken off from interface_util.lua for better encapsulation


-- Like NewIFButton, but puts a nice fancy skin on it.
function NewFlatIFButton(Template)
	local temp = Template

	temp.skin = NewIFContainer {
		ZPos = 130, -- Text will be at 128 by default, be a bit behind it

		-- 1 chunk for the background. Note: no texture is specified,
		-- as that's done in fnSelect
		ChunkC  = NewIFImage { inertUVs = 1},

-- 		fnSetSize = gFlatIFButtonSkin_fnSetSize,
-- 		fnSelect = gFlatIFButtonSkin_fnSelect,
-- 		fnHilight = gFlatIFButtonSkin_fnHilight,
		
	} -- end of skin

	temp.label = NewIFText {
		valign = "vcenter",

	} -- end of label

	-- Make a button from this expanded template
	return NewIFButton(temp)
end
