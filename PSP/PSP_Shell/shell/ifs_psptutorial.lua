-- ifs_psptutorial.lua 
-- Decompiled by cbadal 
-- verified 
ifspspstutorial_vbutton_layout = {
    xWidth = 300,
    width = 300,
    xSpacing = 6,
    ySpacing = 5,
    font = gMenuButtonFont,
    buttonlist = {
        {
            tag = "tutbasic",
            string = "ifs.main.tutbasic"
        },
        {
            tag = "tutoptandtips",
            string = "ifs.main.tutopt"
        },
        {
            tag = "tutclasses",
            string = "ifs.main.tutclasses"
        },
        {
            tag = "tutspace",
            string = "ifs.main.tutspace"
        },
        {
            tag = "tutchallenge",
            string = "ifs.main.tutchallenge"
        },
        {
            tag = "tutgalc",
            string = "ifs.main.tutgalc"
        }
    },
    title = "ifs.main.psptut"
}

function ifs_stop_ShellMusic(param0)
    ScriptCB_CloseMovie()
end
ifs_psptutorial = NewIFShellScreen {
    bNohelptext_backPC = 1,
    bAcceptIsSelect = 1,
    bg_texture = "psp_mainmenu_1",
    tutSelect = 0,
    buttons = NewIFContainer {
        ScreenRelativeX = 0.5,
        ScreenRelativeY = 0.5
    },
    Input_Accept = function(this)
        if (gShellScreen_fnDefaultInputAccept(this)) then
            return
        end
        if (this.CurButton) then
            ifelm_shellscreen_fnPlaySound(this.acceptSound)
        end

        if (this.CurButton == "tutbasic") then
            this.tutSelect = 1
        elseif (this.CurButton == "tutoptandtips") then
            this.tutSelect = 2
        elseif (this.CurButton == "tutclasses") then
            this.tutSelect = 3
        elseif (this.CurButton == "tutspace") then
            this.tutSelect = 4
        elseif (this.CurButton == "tutchallenge") then
            this.tutSelect = 5
        elseif (this.CurButton == "tutgalc") then
            this.tutSelect = 6
        end
        ifs_movietrans_PushScreen(ifs_instruction)
    end,
    Enter = function(this, bFwd)
        gIFShellScreenTemplate_fnEnter(this, bFwd)
        ShowHideVerticalButtons(this.buttons, ifspspstutorial_vbutton_layout)
    end
}

function ifs_psptutorial_fnBuildScreen(this)
    this.CurButton = AddVerticalButtons(this.buttons, ifspspstutorial_vbutton_layout)
end
ifs_psptutorial_fnBuildScreen(ifs_psptutorial)
ifs_psptutorial_fnBuildScreen = nil
AddIFScreen(ifs_psptutorial, "ifs_psptutorial")
