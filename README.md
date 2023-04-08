![image](https://user-images.githubusercontent.com/98753696/230727068-7f8b0028-efb6-444a-9820-6bbd6dcfa243.png) simple Class based, AHK v2 GUI I wrote to show basic methods for GUIs and ControlSendText. I made extra extra notes, and kept everything object oriented.

This is an AutoHotkey script that creates a graphical user interface (GUI) and provides buttons to launch Python virtual environments and run different packaging tools such as Nuitka, AutoPytoEXE, CXFreeze, and PyInstaller.

The script defines a class named "MyGui_Create" that creates a GUI and adds buttons to it. Each button is assigned an "OnEvent" method that is triggered when the user clicks on it. These methods contain commands to launch virtual environments and run the different packaging tools.

The "has_command_window_been_launched" method is used to check whether the command prompt window has been launched or not. If it has not been launched, it is launched. The "activator" method is used to activate the command prompt window and run a batch file to activate the virtual environment.

The "findNearest_venv_Folder" method is used to find the nearest virtual environment folder.

The "ControlSendTextToCMD" method sends text to the command prompt window, and the "sendEnter" method sends an "Enter" key press to the window.

Overall, the script provides an easy-to-use interface for creating and managing virtual environments and packaging Python scripts.


