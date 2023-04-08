; Place in folder where you'd like py venv or installers
#SingleInstance Force

#Requires AutoHotkey v2
#Warn all, Off

G := MyGui_Create()
;The script defines a class named "MyGui_Create" that creates a GUI and adds buttons to it. Each button is assigned an "OnEvent" method that is triggered when the user clicks on it. These methods contain commands to launch virtual environments and run the different packaging tools.
class MyGui_Create
{
	__New() {
		this.MyGui := Gui(, "Launcher")
		Grp1 := this.MyGUI.AddGroupBox("x7 y4 w267 h93", ".venv")

		this.launch := this.MyGUI.AddButton("x19 y20 w101 h23", "&Launch")
		this.launch.OnEvent("Click", this.launch_click)

		this.create := this.MyGUI.AddButton("x152 y20 w101 h23", "&Create")
		this.create.OnEvent("Click", this.create_click)
		; creates a new VENV environment at this location
		; checks if autopytoexe is installed, checks if cmd and venv open, otherwise opens venv and writes a standard  autopytoexe GUI
		this.three11 := this.MyGUI.AddButton("x19 y56 w101 h23", "&*311 .venv")
		this.three11.OnEvent("Click", this.three11_Click)
		; checks if CXFreeze is installed, checks if cmd and venv open, otherwise opens venv and writes a CXFreeze quickstart
		this.PyInstaller := this.MyGUI.AddButton("x152 y56 w101 h23", "PyInstaller")
		this.PyInstaller.OnEvent("Click", this.PyInstaller_Click)
		; prints standard pyinstaller script
		
		this.Grp2 := this.MyGUI.AddGroupBox("x7 y98 w267 h190", "Installers")
		;divider
		this.Nuitka := this.MyGUI.AddButton("x19 y137 w101 h23", "&Nuitka")
		this.Nuitka.OnEvent("Click", this.Nuitka_Click)
		; checks if nuitka is installed, checks if cmd and venv open, otherwise opens venv and writes a standard nuitka installer
		this.autopytoexe := this.MyGUI.AddButton("x152 y137 w101 h23", "&AutoPytoEXE")
		this.autopytoexe.OnEvent("Click", this.autopytoexe_Click)
		; checks if autopytoexe is installed, checks if cmd and venv open, otherwise opens venv and writes a standard  autopytoexe GUI
		this.CXFreeze := this.MyGUI.AddButton("x19 y172 w101 h23", "&CXFreeze")
		this.CXFreeze.OnEvent("Click", this.CXFreeze_Click)
		; checks if CXFreeze is installed, checks if cmd and venv open, otherwise opens venv and writes a CXFreeze quickstart
		this.PyInstaller := this.MyGUI.AddButton("x152 y172 w101 h23", "PyInstaller")
		this.PyInstaller.OnEvent("Click", this.PyInstaller_Click)
		; prints standard pyinstaller script


		this.PID := false
		this.activate_bat := false
		this.MyGui.Show("w300 h300")

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
	create_click(*) {
		G.isCMDopen_and_isVENVlaunched(1)
		;Creates and Launches VENV in command window, in folder with this file
		G.ControlSendTextToCMD("python -m venv venv")
		G.sendEnter()
		WinActivate "ahk_pid " G.PID  ; Show the result.
		sleep(10000)
		G.findNearest_venv_Folder()
		loop 5 {
			if (G.activate_bat = 0) {
				sleep(5000)
				G.findNearest_venv_Folder()
			}
			else {
				break
			}
		}
		G.activator()
		G.ControlSendTextToCMD("python -m pip install `--upgrade pip")
		G.sendEnter()
	}
	three11_click(*) {
		G.isCMDopen_and_isVENVlaunched(1)
		;Creates and Launches VENV in command window, in folder with this file
		G.ControlSendTextToCMD("C:\Users\dower\AppData\Local\Programs\Python\Python311\python.exe -m venv venv")
		G.sendEnter()
		WinActivate "ahk_pid " G.PID  ; Show the result.
		sleep(10000)
		G.findNearest_venv_Folder()
		loop 5 {
			if (G.activate_bat = 0) {
				sleep(5000)
				G.findNearest_venv_Folder()
			}
			else {
				break
			}
		}
		G.activator()
		G.ControlSendTextToCMD("python -m pip install `--upgrade pip")
		G.sendEnter()
	}
	Nuitka_click(*) {
		; checks if nuitka is installed, opens venv and writes a standard nuitka installer
		G.isCMDopen_and_isVENVlaunched()
		G.ControlSendTextToCMD("pip install nuitka")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		G.ControlSendTextToCMD("python -m nuitka `--onefile `--windows-icon-from-ico=C:\Users\dower\Documents\icons\Python.ico `"" A_ScriptDir "\pythonfilehere.py`"")
	}
	autopytoexe_Click(*) {
		; checks if autopytoexe is installed, opens venv and runs the easy autopytoexe GUI
		G.isCMDopen_and_isVENVlaunched()

		G.ControlSendTextToCMD("pip install auto-py-to-exe")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		G.WinActivate()
		G.ControlSendTextToCMD("auto-py-to-exe")
		G.sendEnter()
		G.WinActivate()
	}
	CXFreeze_Click(*) {
		; checks if CXFreeze is installed, opens venv and runs the  CXFreeze quickstart
		G.isCMDopen_and_isVENVlaunched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.ControlSendTextToCMD("pip install cx-freeze")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinActivate()
		sleep(500)
		G.WinActivate()
		G.ControlSendTextToCMD("cxfreeze-quickstart")
		G.sendEnter()
		G.WinActivate()
	}
	PyInstaller_Click(*) {
		; prints standard pyinstaller script
		G.isCMDopen_and_isVENVlaunched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.ControlSendTextToCMD("pyinstaller `--noconfirm `--onefile `--console `--hidden-import `"PySimpleGUI`" `--exclude-module `"tk-inter`" `--hidden-import `"FileDialog`"  `"" A_ScriptDir "\pythonfilehere.py`"")
		G.WinActivate()
	}

	findNearest_venv_Folder() {
		; looks for "activate.bat" file
		if (G.activate_bat = 0) {
			Loop Files, A_ScriptDir "\*.*", "R"  ; Recurse into subfolders.
			{
				if ("activate.bat" = A_LoopFileName) {
					G.activate_bat := A_LoopFilePath
					break
				}
			}
		}
		else {
			return G.activate_bat
		}
	}
	isCMDopen_and_isVENVlaunched(Mode := 0) {
		if (G.PID = 0) {
			G.openCommandPrompt()
		}
		else if not WinExist("ahk_pid " G.PID) {
			G.openCommandPrompt()
		}
		;The "isCMDopen_and_isVENVlaunched" method is used to check whether the command prompt window has been launched or not. If it has not been launched, it is launched. The "activator" method is used to activate the command prompt window and run a batch file to activate the virtual environment.
		if not (Mode = 1) { ; if specified with param (1) will skip looking for the "activate.bat" file
			G.findNearest_venv_Folder()
			G.activator()
		}
	}
	activator() {
		G.ControlSendTextToCMD(G.activate_bat)
		G.sendEnter()
		WinActivate "ahk_pid " G.PID  ; Show the result.
	}
	WinActivate() {
		WinActivate "ahk_pid " G.PID
	}
	openCommandPrompt() {
		; checks if command window has been launched
		Run "cmd.exe", , "Min", &PID  ; Run Notepad minimized.
		WinWait "ahk_pid " PID  ; Wait for it to appear.
		G.PID := PID
	}
	ControlSendTextToCMD(text) {
		G.WinActivate()
		ControlSendText(text, , "ahk_pid " G.PID)
		G.WinActivate()
	}
	sendEnter() {
		;ControlSendEnter
		G.WinActivate()
		ControlSend("{Enter}", , "ahk_pid " G.PID)
		G.WinActivate()
	}
}