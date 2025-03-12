import gi
import subprocess
import json
import os
import pathlib
import shutil

from gi.repository import Gtk, Adw, Gio, Gdk
from urllib.parse import urlparse

home_folder = os.path.expanduser('~')
script_folder = "com.ml4w.packagesinstaller"
config_folder = home_folder + "/.config/" + script_folder
templates_folder = "templates"
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
        save_configuration["successmessage"] = win.config_successmessage.get_text()
        save_configuration["scriptname"] = win.config_scriptname.get_text()

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
            cmd["packagenames"] = item.cmd_packagenames
            commands.append(cmd)

        save_configuration["packages"] = commands

        return save_configuration

    # Load template from the app or from the config folder
    def load_template(self,template_file):

        if os.path.exists(config_folder + "/" + templates_folder + "/" + template_file):
            with open(config_folder + "/" + templates_folder + "/" + template_file, 'r') as file:
                template = file.read()
        else:
            with open(path_name + "/" + templates_folder + "/" + template_file, 'r') as file:
                template = file.read()

        return template

    # Generates the installation script content based on the template
    def generate_installer(self,win,folder,scriptname,managers,commandstore,variablestore,preferences):

        for mng in managers:

            # Load main template
            installer = self.load_template("installer.sh")

            # Adding installer information
            installer = installer.replace("{title}",win.config_title.get_text())
            installer = installer.replace("{description}",win.config_description.get_text())
            installer = installer.replace("{successmessage}",win.config_successmessage.get_text())
            installer = installer.replace("{greeting}",preferences.greeting)
            installer = installer.replace("{version}",preferences.version)

            if mng != "flatpak":
                if scriptname.find("{manager}") == -1:
                    scriptname = "{manager}-" + scriptname
                scriptname_tmp = scriptname.replace("{manager}",mng)
            else:
                scriptname_tmp = scriptname

            # Write Variables
            variables = ""
            for i in range(variablestore.get_n_items()):
                v = variablestore.get_item(i)
                variables = variables + v.var_name + "=\"" + v.var_value + "\"" + "\n"

            installer = installer.replace("{variables}",variables)

            # Write Is Installed
            isinstalled = ""
            is_m = self.load_template("isinstalled/isinstalled_" + mng + ".sh")
            isinstalled = isinstalled + is_m
            if mng != "flatpak":
                is_f = self.load_template("isinstalled/isinstalled_flatpak.sh")
                isinstalled = isinstalled + is_f
            installer = installer.replace("{isinstalled}",isinstalled)

            # Write Commands
            commands = ""
            for i in range(commandstore.get_n_items()):
                c = commandstore.get_item(i)

                match c.cmd_type:
                    case "package":
                        if mng != "flatpak":
                            match mng:
                                case "apt":
                                    template = self.load_template("commands/" + c.cmd_type + "-apt.sh")
                                case "dnf":
                                    template = self.load_template("commands/" + c.cmd_type + "-dnf.sh")
                                case "pacman":
                                    template = self.load_template("commands/" + c.cmd_type + "-pacman.sh")
                                case "zypper":
                                    template = self.load_template("commands/" + c.cmd_type + "-zypper.sh")
                            template = template.replace("{isinstalled}",str(c.cmd_isinstalled))
                            if mng in c.cmd_packagenames and len(c.cmd_packagenames[mng]) > 0:
                                template = template.replace("{name}",c.cmd_packagenames[mng])
                            else:
                                template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "flatpak-app":
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{isinstalled}",str(c.cmd_isinstalled))
                        template = template.replace("{name}",c.cmd_name)
                        commands = commands + template + "\n"
                    case "flatpak-flathub":
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{isinstalled}",str(c.cmd_isinstalled))
                        template = template.replace("{name}",c.cmd_name)
                        commands = commands + template + "\n"
                    case "flatpak-remote":
                        a = urlparse(c.cmd_name)
                        flatpak_name = os.path.basename(a.path)
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{url}",c.cmd_name)
                        template = template.replace("{name}",flatpak_name)
                        commands = commands + template + "\n"
                    case "flatpak-local":
                        flatpak_name = os.path.basename(c.cmd_name)
                        flatpak_dir = c.cmd_name.replace(flatpak_name,"")
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{name}",flatpak_name)
                        template = template.replace("{dir}",flatpak_dir)
                        commands = commands + template + "\n"
                    case "echo":
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{name}",c.cmd_name)
                        commands = commands + template + "\n"
                    case "command":
                        template = self.load_template("commands/" + c.cmd_type + ".sh")
                        template = template.replace("{name}",c.cmd_name)
                        commands = commands + template + "\n"
                    case "command-apt":
                        if mng == "apt":
                            template = self.load_template("commands/command.sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "command-dnf":
                        if mng == "dnf":
                            template = self.load_template("commands/command.sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "command-pacman":
                        if mng == "pacman":
                            template = self.load_template("commands/command.sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "command-zypper":
                        if mng == "zypper":
                            template = self.load_template("commands/command.sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "package-yay":
                        if mng == "pacman":
                            template = self.load_template("commands/" + c.cmd_type + ".sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "package-paru":
                        if mng == "pacman":
                            template = self.load_template("commands/" + c.cmd_type + ".sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"
                    case "copr-remote":
                        if mng == "dnf":
                            template = self.load_template("commands/" + c.cmd_type + ".sh")
                            template = template.replace("{name}",c.cmd_name)
                            commands = commands + template + "\n"

            installer = installer.replace("{commands}",commands)

            with open(folder + "/" + scriptname_tmp, 'w', encoding='utf-8') as f:
                f.write(installer)
            f.close()

