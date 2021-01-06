--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Horizontal slider for Lua. Handles the overall setup of them, with
-- functions for managing them.

-- Given an item previously created w/ NewHSlider(), reads the
-- thumbwidth/thumbposn out of it, moves the thumb. 
function HSlider_MoveThumb(this)
    -- Clamp values to right/left edge
    local ThumbL = math.max((this.width * -0.5), (this.width * -0.5) + (this.width * this.thumbposn))
    local ThumbR = ThumbL + (this.width * this.thumbwidth)
    IFImage_fnSetTexturePos(this.sliderfg,ThumbL,-this.HalfHeight,ThumbR,this.HalfHeight)

    local ExtraWidth = this.width + (this.width * this.thumbwidth)
    local BGL = this.width * -0.5
    local BGR = (this.width * 0.5) + (this.width * this.thumbwidth)
    IFImage_fnSetTexturePos(this.sliderbg,BGL,-this.HalfHeight,BGR,this.HalfHeight)
end

function HSlider_fnSetAlpha(this,a)
-- no longer do we change the alpha of the actual slider widget, just the background - Mike Z
    IFObj_fnSetAlpha(this.sliderbg,a)
    IFObj_fnSetAlpha(this.sliderfg,1) --a)
end

-- Creates a new HSlider. This item is centered around the center of
-- what's passed in. Values in Template to be filled out:
--
-- width : overall width in pixels (of the background)
-- height : overall height in pixels
-- thumbwidth : width % the thumb (FG) (default 0.1, 10%)
-- thumbposn : position of the slider in 0..1 scale (clamped to right side)

function NewHSlider(Template)
    -- Fill in defaults in case parent didn't.
    Template.width = Template.width or 100
    Template.height = Template.height or 16
    Template.thumbwidth = Template.thumbpercentage or 0.1
    Template.thumbposn = Template.thumbposn or 0    
    Template.texturebg = Template.texturebg or "slider_bg"
    Template.texturefg = Template.texturefg or "slider_fg"

    local temp = NewIFContainer {
        x = Template.x,
        y = Template.y,
        ZPos = Template.ZPos,
        HalfHeight = Template.height * 0.5,
        sliderbg = NewIFImage { ZPos = 160, 
            localpos_l = Template.width * -0.5, localpos_r = Template.width * 0.5,
            localpos_t = Template.height * -0.5, localpos_b = Template.height * 0.5,
            texture = Template.texturebg,
            inert_all = 1,
        },

        sliderfg = NewIFImage { ZPos = 159,
            localpos_l = 0, localpos_r = 0,
            localpos_t = Template.height * -0.5, localpos_b = Template.height * 0.5,
            texture = Template.texturefg,
            inert_all = 1,
        },
    }

    if(gPlatformStr == "PC") then
        local ShowW = Template.width + (Template.width * Template.thumbwidth)
        temp.sliderbg.bHotspot = 1
        temp.sliderbg.fHotspotX = Template.width * -0.5
        temp.sliderbg.fHotspotW = ShowW
        temp.sliderbg.fHotspotY = Template.height * -0.5
        temp.sliderbg.fHotspotH = Template.height
    end

    temp.width = Template.width
    temp.height = Template.height
    temp.thumbwidth = Template.thumbwidth
    temp.thumbposn = Template.thumbposn
    temp.type = "hslider"

    -- Move the slider asap
    HSlider_MoveThumb(temp)

    return temp
end




