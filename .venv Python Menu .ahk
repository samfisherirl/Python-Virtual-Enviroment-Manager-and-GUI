; Place in folder where you'd like py venv or installers
#SingleInstance Force
ProcessSetPriority "High"
Persistent
#Requires AutoHotkey v2
#Warn all, Off
SetKeyDelay 5, 5, "Play"

; Tray definition =================================================================
Application := { Name: "Menu Interface", Version: "0.1" }
; Tray.Delete()

G := MyGui_Create()
;The script defines a class named "MyGui_Create" that creates a GUI and adds buttons to it. Each button is assigned an "OnEvent" method that is triggered when the user clicks on it. These methods contain commands to launch virtual environments and run the different packaging tools.
class MyGui_Create
{
	__New() {
		
		Window := { Width: 600, Height: 400, Title: Application.Name }
		MenuWidth := 100
		Navigation := { Label: ["General", "Advanced", "Language", "Theme", "---", "Help", "About"] }

		SplitPath(A_AppData,, &AppData)
		this.MyGui := Gui(, "Launcher")
		Grp1 := this.MyGUI.AddGroupBox("x7 y4 w267 h93", ".venv")
		this.AppData := AppData
		this.launch := this.MyGUI.AddButton("x19 y20 w101 h23", "&Launch").OnEvent("Click", this.launch_click)

		this.create := this.MyGUI.AddButton("x152 y20 w101 h23", "&Create").OnEvent("Click", this.create_click)
		; creates a new VENV environment at this location
		; checks if autopytoexe is installed, checks if cmd and venv open, otherwise opens venv and writes a standard  autopytoexe GUI
		this.three11 := this.MyGUI.AddButton("x152 y56 w101 h23", "&*311 .venv").OnEvent("Click", this.three11_Click)
		; checks if CXFreeze is installed, checks if cmd and venv open, otherwise opens venv and writes a CXFreeze quickstart
		this.pipClick := this.MyGUI.AddButton("x19 y56 w101 h23", "pip3-").OnEvent("Click", this.pip_click)
		this.pythonPath := AppData "\Local\Programs\Python\Python310"
		this.pythonsitePackages := AppData "\Local\Programs\Python\Python310\Lib\site-packages"
		; prints standard pyinstaller script
		this.Grp2 := this.MyGUI.AddGroupBox("x7 y98 w267 h190", "Installers")
		;divider
		this.Nuitka := this.MyGUI.AddButton("x19 y127 w101 h23", "&Nuitka").OnEvent("Click", this.Nuitka_Click)
		; checks if nuitka is installed, checks if cmd and venv open, otherwise opens venv and writes a standard nuitka installer
		this.autopytoexe := this.MyGUI.AddButton("x152 y127 w101 h23", "&AutoPytoEXE").OnEvent("Click", this.autopytoexe_Click)
		; checks if autopytoexe is installed, checks if cmd and venv open, otherwise opens venv and writes a standard  autopytoexe GUI
		this.CXFreeze := this.MyGUI.AddButton("x19 y162 w101 h23", "&CXFreeze").OnEvent("Click", this.CXFreeze_Click)
		; checks if CXFreeze is installed, checks if cmd and venv open, otherwise opens venv and writes a CXFreeze quickstart
		this.PyInstaller := this.MyGUI.AddButton("x152 y162 w101 h23", "PyInstaller").OnEvent("Click", this.PyInstaller_Click)
		; prints standard pyinstaller script
		this.input := this.MyGUI.Add("Edit", "r1 vMyEdit y202 x19 w240", A_ScriptDIr)

		this.browse := this.MyGUI.AddButton("x19 y232 w101 h23", "&Browse").OnEvent("Click", this.browse_click)
		this.run := this.MyGUI.AddButton("x152 y232 w101 h23", "&Run").OnEvent("Click", this.run_click)
		this.pip := ""

		this.venv_packages := ""

		this.PID := false
		this.activate_bat := false
		this.MyGui.Show("w280 h300")
	}
	launch_click(*) {
		;Launch VENV in command window by finding nearest activate.bat file below directory
		G.isCMDopen_and_isVENVlaunched()
		if (G.PID = 0) {
			G.openCommandPrompt()
		}
		G.findNearest_venv_Folder()
		G.activator()
	}
	pip_click(*) {
		G.isCMDopen_and_isVENVlaunched()
		G.sendEnter()
		G.WinActivate()
		G.ControlSendTextToCMD("`"" G.pip "`" install --upgrade ")
	}

	create_click(*) {
		G.isCMDopen_and_isVENVlaunched(1)
		;Creates and Launches VENV in command window, in folder with this file
		G.ControlSendTextToCMD("python -m venv venv")
		G.create_env()
	}
	three11_click(*) {
		G.isCMDopen_and_isVENVlaunched(1)
		;Creates and Launches VENV in command window, in folder with this file
		G.pythonPath := G.AppData "\Local\Programs\Python\Python311"
		G.ControlSendTextToCMD("`"" G.pythonPath "\python.exe`" -m venv venv")
		G.create_env()
	}

	create_env() {
		G.sendEnter()
		G.WinActivate()  ; Show the result.
		sleep(5000)
		G.findNearest_venv_Folder()
		loop 5 {
			if (G.activate_bat == 0) {
				sleep(5000)
				G.findNearest_venv_Folder()
			}
			else {
				break
			}
		}
		G.activator()
		G.ControlSendTextToCMD("python -m pip install --upgrade pip")
		G.sendEnter()
	}
	Nuitka_click(*) {
		; checks if nuitka is installed, opens venv and writes a standard nuitka installer
		G.isCMDopen_and_isVENVlaunched()
		G.installer("nuitka")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		Result := MsgBox("onefile? (Yes)", , "YesNo")
		if Result = "Yes"
			G.ControlSendTextToCMD("python -m nuitka --onefile --windows-icon-from-ico=C:\Users\dower\Documents\icons\Python.ico `"" G.input.value "`"")
		else
			G.ControlSendTextToCMD("python -m nuitka --standalone --windows-icon-from-ico=C:\Users\dower\Documents\icons\Python.ico `"" G.input.value "`"")

	}
	autopytoexe_Click(*) {
		; checks if autopytoexe is installed, opens venv and runs the easy autopytoexe GUI
		G.isCMDopen_and_isVENVlaunched()
		G.installer("auto-py-to-exe")
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		G.WinActivate()
		G.ControlSendTextToCMD("auto-py-to-exe")
		G.sendEnter()
		G.WinActivate()
	}
	installer(txt) {
		G.ControlSendTextToCMD("`"" G.pip "`" install -U " txt)
		G.sendEnter()
	}
	CXFreeze_Click(*) {
		; checks if CXFreeze is installed, opens venv and runs the  CXFreeze quickstart
		G.isCMDopen_and_isVENVlaunched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.installer("cx-freeze")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		G.WinActivate()
		Result := MsgBox("Quickstart? (Yes)", , "YesNo")
		if Result = "Yes"
			G.ControlSendTextToCMD("cxfreeze-quickstart")
		else
			G.ControlSendTextToCMD("cxfreeze -c " G.input.value)

		G.WinActivate()
	}
	PyInstaller_Click(*) {
		; prints standard pyinstaller script
		G.isCMDopen_and_isVENVlaunched()
		G.installer("packaging")
		G.installer("pyinstaller")
		G.installer("setuptools")
		fileselected := FileSelect(1, A_ScriptDir, "File Select", "Python (*.py)")
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		SplitPath(fileselected, &Dir)
		x := MsgBox("Onefile?", "Onefile(y) or standalone(n)?", "8228")
		if (x == "Yes") {
			x := "--onefile"
		}
		else if (x == "No") {
			x := "--onedir"
		}
		G.ControlSendTextToCMD("pyinstaller --noconfirm " x " --console --paths `"" G.venv_packages "`" --paths `"" G.pythonsitePackages "`" `"" fileselected "`"")
		G.WinActivate()
	}

	browse_click(*) {
		SelectedFile := FileSelect(3, , "Open a file", "Python File (*.py; *.py)")
		if SelectedFile {
			G.input.value := selectedFile

		}

	}


	run_click(*) {
		SplitPath(G.input.value, &Filename)
		if InStr(Filename, ".py")
		{
			G.ControlSendTextToCMD("python " G.input.value)
			G.sendEnter()
		}
		else
		{
			SelectedFile := FileSelect(3, , "Open a file", "Python File (*.py; *.py)")
			if SelectedFile {
				G.input.value := selectedFile
				G.ControlSendTextToCMD("python " selectedFile)
				G.sendEnter()
			}

		}
	}

	check_inputfield() {
		if G.input.value != A_ScriptDir {

		}
	}
	static parseCFG(path) {
		z := FileRead(path)
		Loop Parse, z, "`n" "`r" {
			if InStr(A_LoopField, "executable") {
				p := StrSplit(A_LoopField, "=")[2]
				p := Trim(p)
				SplitPath(p, , &Dir)
				return Dir
			}
		}
	}

	findNearest_venv_Folder() {
		; looks for "activate.bat" file
		if (G.activate_bat == 0) {
			if direxist(A_ScriptDir "\venv") {
				G.activate_bat := A_ScriptDir "\venv\Scripts\activate.bat"
				SplitPath(G.activate_bat, , &Dir)
				G.pip := Dir . "\pip3.exe"
				G.venv_packages := A_ScriptDir "\venv\Lib\site-packages"
				G.pythonPath := MyGui_Create.parseCFG(A_ScriptDir "\venv\pyvenv.cfg")
			}
			else {
				Loop Files, A_ScriptDir "\*.*", "R"  ; Recurse into subfolders.
				{
					if ("activate.bat" = A_LoopFileName) {
						G.activate_bat := A_LoopFilePath
						SplitPath(A_LoopFilePath, , &OutDir)
						SplitPath(OutDir, , &Dir)
						G.venv_packages := Dir . "\Lib\site-packages"
						G.pythonPath := G.parseCFG(Dir . "\pyvenv.cfg")
						break
					} } } }
		else {
			return G.activate_bat
		}
	}
	isCMDopen_and_isVENVlaunched(Mode := 0) {
		if (G.PID == 0) {
			G.openCommandPrompt()
		}
		else if not WinExist("ahk_pid " G.PID) {
			G.openCommandPrompt()
		}
		;The "isCMDopen_and_isVENVlaunched" method is used to check whether the command prompt window has been launched or not. If it has not been launched, it is launched. The "activator" method is used to activate the command prompt window and run a batch file to activate the virtual environment.
		if not (Mode == 1) { ; if specified with param (1) will skip looking for the "activate.bat" file
			G.findNearest_venv_Folder()
			G.activator()
		}
	}
	activator() {
		G.ControlSendTextToCMD("`"" G.activate_bat "`"")
		G.sendEnter()
		G.WinActivate()  ; Show the result.
	}
	WinActivate() {
		try {
			WinActivate "ahk_pid " G.PID
		}
		catch {
			exitapp
		}
	}
	openCommandPrompt() {
		; checks if command window has been launched
		Run "cmd.exe", , "Min", &PID  ; Run Notepad minimized.
		WinWait "ahk_pid " PID  ; Wait for it to appear.
		G.PID := PID
	}
	ControlSendTextToCMD(text) {
		G.WinActivate()
		Sleep(10)
		SetKeyDelay(5, 4)
		ControlSend(text, , "ahk_pid " G.PID)
		G.WinActivate()
	}
	sendEnter() {
		;ControlSendEnter
		ControlSend("{Enter}", , "ahk_pid " G.PID)
		G.WinActivate()
	}
	checkSession() {
		if FileExist(A_ScriptDir "\session.txt") {

		}
	}

}