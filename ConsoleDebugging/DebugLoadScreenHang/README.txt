This is a 'load screen hang' debug assistant.
It contains 20 loadscreens (with numbers 1-20) and 'invalid function input' (red X) 
   loadscreen (this will show if you pass invalid argument to 'ShowDebugLoadScreen()' )


As you go along in ScriptInit place calls like:
ShowDebugLoadScreen(1)
...
ShowDebugLoadScreen(2)
...
ShowDebugLoadScreen(3)
...

And See how far the missions setup script goes to 
give you a better idea where the hang is happening.

The corresponding 'dbg' folder is intended to be placed in your 
target platform's (XBOX,PS2,PSP) 'LOAD' folder.

****** NOTE *****
This is an imperfect way to debug mission scripts on XBOX, PS2, PSP.
There is currently a 'pause' inserted to try to ensure that the loadscreen actually shows.
The pause is accomplished by calculating a Fibonacci number. If I find a better way to
'pause' to allow the screen to update, I'll update the info/package.
I have not used this technique enough times to be able to tell you for sure that the last 
load screen requested will show. (so keep that in mind)

********* Setup ***********
Copy the included 'ShowDebugLoadScreen()' and 'fib()' functions to your mission script.
Copy the debug load screens to your test/dev unit and make sure they are at:
   __LVL_PSP\load\dbg
   __LVL_PS2\load\dbg
or
   __LVL_XBOX\Load\dbg
