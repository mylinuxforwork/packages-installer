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

installer_commands = ["apt","dnf","flatpak","pacman","zypper"]

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

        commands = []

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            cmd = {}
            cmd["name"] = item.cmd_name
            cmd["description"] = item.cmd_description
            cmd["command"] = item.cmd_command
            cmd["isinstalled"] = item.cmd_isinstalled
            cmd["type"] = item.cmd_type
            commands.append(cmd)

        save_configuration["packages"] = commands

        return save_configuration

    # Generates the installation script content based on the template
    def generate_installer(self,win,variablestore,liststore):

        with open(path_name + "/scripts/installer.sh", 'r') as file:
            installer = file.read()

        # Adding installer information
        installer = installer.replace("{title}",win.config_title.get_text())
        installer = installer.replace("{description}",win.config_description.get_text())
        installer = installer.replace("{distribution}",win.config_distribution.get_text())
        installer = installer.replace("{successmessage}",win.config_successmessage.get_text())

        # Adding isinstalled scripts
        isinstalled_scripts = ""
        isInstalled = {}

        for ic in installer_commands:
            isInstalled[ic] = False

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            cmd_command = item.cmd_command

            for ic in installer_commands:
                if item.cmd_command.find(ic) != -1 and isInstalled[ic] == False:
                    with open(path_name + "/scripts/isinstalled_" + ic + ".sh", 'r') as file:
                        s = file.read()
                    isinstalled_scripts = isinstalled_scripts + s + "\n"
                    isInstalled[ic] = True

        installer = installer.replace("{isinstalled}",isinstalled_scripts)

        # Adding package commmands
        commands = ""

        with open(path_name + "/scripts/isinstalled_snipped.sh", 'r') as file:
            snipped_script = file.read()

        for i in range(liststore.get_n_items()):
            item = liststore.get_item(i)
            cmd_command = item.cmd_command

            for i in range(variablestore.get_n_items()):
                variable = variablestore.get_item(i)
                cmd_command = cmd_command.replace("{" + variable.var_name + "}",variable.var_value)

            cmd_command = cmd_command.replace("{name}",item.cmd_name)
            cmd_command = cmd_command.replace("{package}",item.cmd_name)
            cmd_command = cmd_command.replace("&amp;","&")

            if item.cmd_type == "package":
                if item.cmd_isinstalled == True:
                    for ic in installer_commands:
                        if cmd_command.find(ic) != -1:
                            print(item.cmd_name)
                            snipped = snipped_script.replace("{name}",item.cmd_name)
                            snipped = snipped.replace("{manager}",ic)
                            snipped = snipped.replace("{command}",cmd_command)
                    cmd_command = snipped

            commands = commands + cmd_command + "\n"

        installer = installer.replace("{commands}",commands)

        return installer
