--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

-- Animation manager for Lua

-- Items are stored in a linked list of active items, which are
-- updated per frame. When done, items are removed from that list.

gCurAnimationList = nil -- nothing so far

-- Removes any/all animations from the specified obj.
function AnimationMgr_ClearAnimations(obj)
	obj.bAnimActive = nil
	obj.fElapsedTime = nil
	obj.fTotalTime = nil

	obj.fStartAlpha = nil
	obj.fEndAlpha = nil

	obj.fStartX = nil
	obj.fEndX = nil
	obj.fStartY = nil
	obj.fEndY = nil

	obj.fStartW = nil
	obj.fEndW = nil
	obj.fStartH = nil
	obj.fEndH = nil

	obj.bCustomActive = nil
end

-- Adds an animation to the current object, given an object and a
-- template The template may have any of the following params (most
-- must be specified in pairs or quads):
--
-- fTotalTime : total animation time in seconds
-- fStartAlpha, fEndAlpha : Alpha animation
-- fStartX, fEndX, fStartY, fEndY : position animation
-- fStartW, fEndW, fStartH, fEndH : size animation (obj must have :fnSetSize() )
-- bCustomActive : Adds a custom animation to the object. If this is
--     done, it'll call obj:fnCustomAnim(fElapsedTime,fTotalTime) each
--     frame

function AnimationMgr_AddAnimation(obj,Template)
	-- can't animate until pushed to C
	if(not obj.cp) then
		return
	end

	-- Add to animation list if not already in it
	if(not obj.bAnimActive) then
		obj.AnimNext = gCurAnimationList
		gCurAnimationList = obj
	end

	obj.bAnimActive = 1
	obj.fElapsedTime = 0
	obj.fTotalTime = Template.fTotalTime or obj.fTotalTime
	obj.fTotalTime = obj.fTotalTime or gShellAnimTime -- Extra fallback if not specified

	obj.fStartAlpha = Template.fStartAlpha or obj.fStartAlpha
	obj.fEndAlpha = Template.fEndAlpha or obj.fEndAlpha

	if(Template.fStartAlpha or Template.fEndAlpha) then
		IFObj_fnSetAlpha(obj,obj.fStartAlpha)
	end

	obj.fStartX = Template.fStartX or obj.fStartX
	obj.fEndX = Template.fEndX or obj.fEndX
	obj.fStartY = Template.fStartY or obj.fStartY
	obj.fEndY = Template.fEndY or obj.fEndY
	if(Template.fStartX or Template.fStartY) then
		IFObj_fnSetPos(obj,obj.fStartX,obj.fStartY)
	end

	obj.fStartW = Template.fStartW or obj.fStartW
	obj.fEndW = Template.fEndW or obj.fEndW
	obj.fStartH = Template.fStartH or obj.fStartH
	obj.fEndH = Template.fEndH or obj.fEndH
	if(Template.fStartW or Template.fStartH) then
		obj:fnSetSize(obj.fStartW,obj.fStartH)
	end
	
	obj.bCustomActive = Template.bCustomActive or obj.bCustomActive
end

-- Updates all active animations
function AnimationMgr_Update(fDt)
	local Prev = nil
	local Cur = gCurAnimationList

	while (Cur) do
		Cur.fElapsedTime = math.min(Cur.fElapsedTime + fDt, Cur.fTotalTime)
		local fRatio = Cur.fElapsedTime / Cur.fTotalTime

		if(Cur.fStartAlpha) then
			IFObj_fnSetAlpha(Cur,Cur.fStartAlpha + fRatio * (Cur.fEndAlpha - Cur.fStartAlpha))
		end
		if(Cur.fStartX) then
			IFObj_fnSetPos(Cur, 
										 Cur.fStartX + fRatio * (Cur.fEndX - Cur.fStartX),
										 Cur.fStartY + fRatio * (Cur.fEndY - Cur.fStartY))
		end
 		if(Cur.fStartW) then
 			Cur:fnSetSize(Cur.fStartW + fRatio * (Cur.fEndW - Cur.fStartW),
 										Cur.fStartH + fRatio * (Cur.fEndH - Cur.fStartH))
 		end
		if(Cur.bCustomActive) then
			Cur:fnCustomAnim(Cur.fElapsedTime,Cur.fTotalTime)
		end

		if(fRatio >= 0.9999) then
			-- delete, try and move on
			AnimationMgr_ClearAnimations(Cur)

			Cur = Cur.AnimNext
			if(not Prev) then
				gCurAnimationList = Cur
			else
				Prev.AnimNext = Cur
			end
		else
			-- Move on...
			Prev = Cur
			Cur = Cur.AnimNext
		end
	end

end