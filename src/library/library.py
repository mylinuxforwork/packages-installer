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
    def create_json(self,win,variablestore,liststore):
        save_configuration = {}
        save_configuration["title"] = win.config_title.get_text()
        save_configuration["description"] = win.config_description.get_text()
        save_configuration["distribution"] = win.config_distribution.get_text()
        save_configuration["successmessage"] = win.config_successmessage.get_text()

        variables = []

        for i in range(variablestore.get_n_items()):
            item = variablestore.get_item(i)
            variable = {}
            variable["name"] = item.var_name
            variable["description"] = item.var_description
            variable["value"] = item.var_value
            variables.append(variable)

        save_configuration["variables"] = variables

        packages = []

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            package = {}
            package["package"] = item.pkg_package
            package["description"] = item.pkg_description
            package["command"] = item.pkg_command
            packages.append(package)

        save_configuration["packages"] = packages

        return save_configuration

    # Generates the installation script content based on the template
    def generate_installer(self,win,variablestore,liststore):

        with open(path_name + "/scripts/installer.sh", 'r') as file:
            installer = file.read()

        installer = installer.replace("{title}",win.config_title.get_text())
        installer = installer.replace("{description}",win.config_description.get_text())
        installer = installer.replace("{distribution}",win.config_distribution.get_text())
        installer = installer.replace("{successmessage}",win.config_successmessage.get_text())

        packages = ""

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            pkg_command = item.pkg_command

            for i in range(variablestore.get_n_items()):
                variable = variablestore.get_item(i)
                pkg_command = pkg_command.replace("{" + variable.var_name + "}",variable.var_value)

            pkg_command = pkg_command.replace("{package}",item.pkg_package)

            packages = packages + pkg_command + "\n"

        installer = installer.replace("{packages}",packages)

        return installer
