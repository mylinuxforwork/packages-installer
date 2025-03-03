import gi
import subprocess
import json
import os
import pathlib
import shutil

from gi.repository import Gtk, Adw, Gio, Gdk

home_folder = os.path.expanduser('~')
script_folder = "/.local/bin/"
script_name = "packages-installer"
script_path = home_folder + script_folder + script_name

path_name = str(pathlib.Path(__file__).resolve().parent.parent)

# Library of helper functions
class Library:

    # Setup the installation script
    def installInstallationScript(self):
        if not os.path.exists(script_path):
            print("")
            print("------------------------------------------------------------")
            print("ML4W Installer SETUP")
            print("------------------------------------------------------------")

            # Create folder if not exists
            pathlib.Path(home_folder + script_folder).mkdir(parents=True, exist_ok=True)

            # Copy ml4w-installer to script folder
            shutil.copy(path_name + '/scripts/' + script_name, home_folder + script_folder)

            print(script_name + " script installed successfully in ~/.local/bin")
            print("You can launch it in this folder or add ~/.local/bin to your PATH")
            print("")
        else:
            # Copy ml4w-installer to script folder
            shutil.copy(path_name + '/scripts/' + script_name, home_folder + script_folder)
            print(script_name + " script updated to the latest version")
            print("")
                    
