import gi
import subprocess
import json
import os
import pathlib
import shutil

from gi.repository import Gtk, Adw, Gio, Gdk

home_folder = os.path.expanduser('~')
script_folder = "com.ml4w.packagesinstaller"
config_folder = home_folder + "/" + script_folder

path_name = str(pathlib.Path(__file__).resolve().parent.parent)

# Library of helper functions
class Library:

    # Setup the installation script
    def setupConfigFolder(self):
        if not os.path.exists(config_folder):
            print("")
            print("------------------------------------------------------------")
            print("ML4W Installer SETUP")
            print("------------------------------------------------------------")

            # Create folder if not exists
            pathlib.Path(config_folder).mkdir(parents=True, exist_ok=True)

