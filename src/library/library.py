import gi
import subprocess
import json
import os
import pathlib
import shutil

from gi.repository import Gtk, Adw, Gio, Gdk

home_folder = os.path.expanduser('~')
script_folder = "com.ml4w.packagesinstaller"
config_folder = home_folder + "/.config/" + script_folder

path_name = str(pathlib.Path(__file__).resolve().parent.parent)

# Library of helper functions
class Library:

    # Setup the installation script
    def setupConfigFolder(self):
        if not os.path.exists(config_folder):
            # Create folder if not exists
            pathlib.Path(config_folder).mkdir(parents=True, exist_ok=True)

    # Get file_name of seleced file
    def get_file_name(self, file):
        info = file.query_info("standard::name", Gio.FileQueryInfoFlags.NONE, None)
        return info.get_name()

    # Create the json file from current configuration
    def create_json(self,win,liststore):
        save_configuration = {}
        save_configuration["title"] = win.config_title.get_text()
        save_configuration["description"] = win.config_description.get_text()
        save_configuration["distribution"] = win.config_distribution.get_text()
        save_configuration["successmessage"] = win.config_successmessage.get_text()

        packages = []

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            package = {}
            package["package"] = item.package
            package["description"] = item.description
            package["installationcommand"] = item.installationcommand
            packages.append(package)

        save_configuration["packages"] = packages

        return save_configuration

