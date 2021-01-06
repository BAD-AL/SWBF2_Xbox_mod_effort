--
-- Copyright (c) 2005 Pandemic Studios, LLC. All rights reserved.
--

ifs_purchase_lighting = {
   ambient = {
      top = { red = 0.25, green = 0.25, blue = 0.25 },
      bottom = { red = 0.25, green = 0.25, blue = 0.25 },
   },
    directional = {
       { direction = { x = 0, y = -0.7, z = -0.7 }, color = { red = 1, green = 1, blue = 1 }, },
--       { direction = { x = 1, y = 0, z = 0 }, color = { red = 1, green = 0, blue = 0 }, },
--       { direction = { x = -1, y = 0, z = 0 }, color = { red = 0, green = 0, blue = 1 }, },
    },
}

ifs_purchase_bright_color = 255
ifs_purchase_dark_color = 75

ifs_freeform_purchase = NewIFShellScreen {
   nologo = 1,
   movieIntro      = nil,
   movieBackground = nil,
   scale = 0.01,
   bNohelptext_accept = 1,
   bNohelptext_back = 1,
   bNohelptext_backPC = 1,
--    lighting_save = nil,

   Enter = function(this, bFwd)
	      gIFShellScreenTemplate_fnEnter(this, bFwd)

-- 	      lighting_save = ScriptCB_GetIFaceLighting()
-- 	      ScriptCB_SetIFaceLighting(ifs_purchase_lighting)

	      --s/b whichever purchase screen was last
	      ScriptCB_PushScreen("ifs_freeform_purchase_tech")
	   end,

   Exit = function(this, bFwd)
-- 	     ScriptCB_SetIFaceLighting(lighting_save)
	  end,

   Update = function(this, fDt)
	       gIFShellScreenTemplate_fnUpdate(this, fDt)
	    end,

}

function ifs_purchase_build_screen()
   ifs_purchase_unit_build_screen()
   ifs_purchase_tech_build_screen()
   -- and the rest...
end

function ifs_purchase_load_data(...)
   ReadDataFile("inshell.lvl")
   ifs_purchase_unit_load_data(unpack(arg))
   ifs_purchase_tech_load_data(unpack(arg))
end


function make_purchase_interpolator(start, finish, time)
   local timer = time
   local x = start

   return {
      start = function(this)
		 return start
	      end,

      finish = function(this)
		  return finish
	       end,

      value = function(this)
		 return x
	      end,

      done = function(this)
		 return timer <= 0
	      end,

      update = function(this, dt)
		  if (timer > 0) then
		     local t = timer / time
		     local blend = t * t * (3 - 2 * t)
		     local blend_comp = 1 - blend

		     x = finish * blend_comp + start * blend

		     timer = timer - dt
		     if ( timer < 0 ) then
			timer = 0
		     end
		  else
		     x = finish
		  end
	       end,
   }
end

function make_purchase_oscillator(min, max, time)
   local time = time / 2
   local interpolator = make_purchase_interpolator(min, max, time)

   return {
      value = function(this)
		 return interpolator:value()
	      end,
      update = function(this, dt)
		  interpolator:update(dt)
		  if ( interpolator:done() ) then
		     local start = interpolator:finish()
		     local finish = interpolator:start()

		     interpolator = make_purchase_interpolator(start, finish, time)
		  end
	       end,
   }

end


AddIFScreen(ifs_freeform_purchase,"ifs_freeform_purchase")
