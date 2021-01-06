--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Code, data for a map preview picture, which is a multi-layer group
-- of elements: a masked bitmap of the map texture, and a ring texture
-- placed on top of that.
--
-- Both parts need to be sized/positioned at the same time, so the
-- encapsulation here helps manage that.
--
-- The element is managed mainly by moving it around its center, and
-- the size is the radius-size (i.e. half of what appears onscreen)

function IFMapPreview_fnSetSize(this,w,h)
	h = h or w -- assume circular until proven otherwise
	IFImage_fnSetTexturePos(this.Map ,-w,-h,w,h)
	IFImage_fnSetTexturePos(this.Ring,-w,-h,w,h)
end

-- Helper function if the caller wants to set a full size (diameter,
-- not radius)
function IFMapPreview_fnSetFullSize(this,w,h)
	h = h or w -- assume circular until proven otherwise
	IFMapPreview_fnSetSize(this,w*0.5,h*0.5)
end

function IFMapPreview_fnSetPos(this,x,y)
	IFObj_fnSetPos(this,x,y)
end

-- Sets the texture. Mask, Ring texture are optional
function IFMapPreview_fnSetTexture(this,MapTexture,MaskTexture,RingTexture)
	IFImage_fnSetTexture(this.Map,MapTexture)
	if(MaskTexture) then
		IFMaskImage_fnSetMaskTexture(this.Map,MaskTexture)
	end
	if(RingTexture) then
		IFImage_fnSetTexture(this.Ring,RingTexture)
	end
end

function NewIFMapPreview(Template)
	local temp = NewIFContainer {
		Map = NewIFImage {
			ZPos = 130, -- slightly behind ring
			inertUVs = 1,
			type = "maskimage",
			masktexture = "ring_mask",
			rotX = Template.rotX,
			rotY = Template.rotY,
			rotZ = Template.rotZ
		},

		Ring = NewIFImage {
			texture = "ring_small", inertUVs = 1,
			rotX = Template.rotX,
			rotY = Template.rotY,
			rotZ = Template.rotZ
		},

		fnSetSize = IFMapPreview_fnSetSize, -- pull in utility function
	} -- end of temp

	if(Template.texture) then
		IFMapPreview_fnSetTexture(temp,Template.texture)
	end

	if(Template.x) then
		IFMapPreview_fnSetPos(temp,Template.x,Template.y)
	end

	if(Template.width) then
		IFMapPreview_fnSetSize(temp,Template.width,Template.height)
	end

	return temp
end

