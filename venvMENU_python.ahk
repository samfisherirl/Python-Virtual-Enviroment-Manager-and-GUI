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
		
		this.launch := this.MyGUI.AddButton("x22 y40 w102 h23", "&Launch")
		this.launch.OnEvent("Click", this.launch_click)
		
		this.create := this.MyGUI.AddButton("x151 y40 w102 h23", "&Create")
		this.create.OnEvent("Click", this.create_click)
		; creates a new VENV environment at this location
		this.Grp2 := this.MyGUI.AddGroupBox("x11 y98 w277 h190", "Installers")
		;divider
		this.Nuitka := this.MyGUI.AddButton("x20 y137 w102 h25", "&Nuitka")
		this.Nuitka.OnEvent("Click", this.Nuitka_Click)
		; checks if nuitka is installed, opens venv and writes a standard nuitka installer
		this.autopytoexe := this.MyGUI.AddButton("x152 y137 w101 h23", "&AutoPytoEXE")
		this.autopytoexe.OnEvent("Click", this.autopytoexe_Click)
		; checks if autopytoexe is installed, opens venv and runs the easy autopytoexe GUI
		this.CXFreeze := this.MyGUI.AddButton("x19 y176 w101 h23", "&CXFreeze")
		this.CXFreeze.OnEvent("Click", this.CXFreeze_Click)
		; checks if CXFreeze is installed, opens venv and runs the  CXFreeze quickstart
		this.PyInstaller := this.MyGUI.AddButton("x152 y176 w101 h23", "PyInstaller")
		this.PyInstaller.OnEvent("Click", this.PyInstaller_Click)
		; prints standard pyinstaller script
		
		this.PID := false
		this.activate_bat := false
		this.MyGui.Show("w300 h300")

	}
	launch_click(*) {
		;Launch VENV in command window by finding nearest activate.bat file below directory
		if (G.PID = 0) {
			G.openCommandPrompt()
		}
		G.findNearest_venv_Folder()
		G.activator()
		
	}
	create_click(*) {
		G.has_command_window_been_launched(1)
		;Creates and Launches VENV in command window, in folder with this file 
		G.ControlSendTextToCMD("python -m venv venv")
		G.sendEnter()
		G.findNearest_venv_Folder()
		WinActivate "ahk_pid " G.PID  ; Show the result.
		sleep(10000)
		G.activator()
	}
	Nuitka_click(*) {
		; checks if nuitka is installed, opens venv and writes a standard nuitka installer
		G.has_command_window_been_launched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.ControlSendTextToCMD("pip install nuitka")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinAct()
		sleep(500)
		G.ControlSendTextToCMD("python -m nuitka --onefile --windows-icon-from-ico=C:\Users\dower\Documents\icons\Python.ico .py")
	}
	autopytoexe_Click(*){
		; checks if autopytoexe is installed, opens venv and runs the easy autopytoexe GUI
		G.has_command_window_been_launched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.ControlSendTextToCMD("pip install auto-py-to-exe")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinAct()
		sleep(500)
		G.WinAct()
		G.ControlSendTextToCMD("auto-py-to-exe")
		G.sendEnter()
		G.WinAct()
	}
	CXFreeze_Click(*){
		; checks if CXFreeze is installed, opens venv and runs the  CXFreeze quickstart
		G.has_command_window_been_launched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used.
		G.ControlSendTextToCMD("pip install cx-freeze")
		G.sendEnter()
		G.findNearest_venv_Folder()
		G.WinAct()
		sleep(500)
		G.WinAct()
		G.ControlSendTextToCMD("cxfreeze-quickstart")
		G.sendEnter()
		G.WinAct()
	}
	PyInstaller_Click(*){
		; prints standard pyinstaller script
		G.has_command_window_been_launched()
		; Send the text to the inactive Notepad edit control.
		; The third parameter is omitted so the last found window is used. 
		G.ControlSendTextToCMD("pyinstaller --noconfirm --onefile --console --hidden-import `"PySimpleGUI`" --exclude-module `"tk-inter`" --hidden-import `"FileDialog`"  `"" A_ScriptDir "`"")
		G.WinAct()
	}

	has_command_window_been_launched(M := 0){
		;The "has_command_window_been_launched" method is used to check whether the command prompt window has been launched or not. If it has not been launched, it is launched. The "activator" method is used to activate the command prompt window and run a batch file to activate the virtual environment.
		if (G.PID = 0) {
			G.openCommandPrompt()
		}
		if not (M = 1){
			G.findNearest_venv_Folder()
			G.activator()
		}
	}
	activator() {
		G.ControlSendTextToCMD(G.activate_bat)
		G.sendEnter()
		WinActivate "ahk_pid " G.PID  ; Show the result.
	}
	WinAct(){
		WinActivate "ahk_pid " G.PID 
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

	openCommandPrompt() {
		; checks if command window has been launched 
			Run "cmd.exe", , "Min", &PID  ; Run Notepad minimized.
			WinWait "ahk_pid " PID  ; Wait for it to appear.
			G.PID := PID
		}
	ControlSendTextToCMD(text){
		ControlSendText(text, , "ahk_pid " G.PID)
		G.WinAct()
	}
	sendEnter(){
		ControlSend("{Enter}",, "ahk_pid " G.PID)
	}

}
