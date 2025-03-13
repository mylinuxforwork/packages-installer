# main.py
#
# Copyright 2025 Stephan Raabe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# SPDX-License-Identifier: GPL-3.0-or-later

import sys
import gi
import json
import os
import subprocess
import pathlib

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import GObject,Gtk,Gdk, Gio, Adw

from .window import PackagesinstallerWindow
from .preferences import PackagesinstallerPreferences
from .addvariable import PackagesinstallerAddVariable
from .addcommand import PackagesinstallerAddCommand
from .packagenames import PackagesinstallerPackagenames
from .generate import PackagesinstallerGenerate

from urllib.request import urlopen
from urllib.parse import urlparse

from .library.library import Library
from .library.commanditem import CommandItem
from .library.variableitem import VariableItem
from .library.preferences import Preferences

lib = Library()

class PackagesinstallerApplication(Adw.Application):

    path_name = str(pathlib.Path(__file__).resolve().parent)

    # Configuration
    loaded_configuration = {}
    save_configuration = {}
    loaded_filename = ""
    loaded_file = ""
    installscript = ""

    # Local or Remote configuration
    config_type = ""

    # List Stores
    commandstore = Gio.ListStore()

    # List Stores
    variablestore = Gio.ListStore()

    # Preferences
    preferences = Preferences()

    # Init Application
    def __init__(self):
        super().__init__(application_id='com.ml4w.packagesinstaller',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)
        self.create_action('report_issue', self.on_report_issue)
        self.create_action('help', self.on_help)
        self.create_action('check_updates', self.on_check_updates)
        self.create_action('open_file', self.on_open_file)
        self.create_action('new_file', self.on_new_file)
        self.create_action('saveas_file', self.on_check_save)
        self.create_action('open_remote', self.load_remote_dialog)

        self.create_action('arch_packages', self.on_arch_packages)
        self.create_action('ubuntu_packages', self.on_ubuntu_packages)
        self.create_action('fedora_packages', self.on_fedora_packages)
        self.create_action('opensuse_packages', self.on_opensuse_packages)

        self.create_action('add_command', self.on_add_command)
        self.create_action('add_command_apt', self.on_add_command_apt)
        self.create_action('add_command_dnf', self.on_add_command_dnf)
        self.create_action('add_command_pacman', self.on_add_command_pacman)
        self.create_action('add_command_zypper', self.on_add_command_zypper)
        self.create_action('add_package', self.on_add_package)
        self.create_action('add_package_yay', self.on_add_package_yay)
        self.create_action('add_package_paru', self.on_add_package_paru)
        self.create_action('add_echo', self.on_add_echo)
        self.create_action('add_comment', self.on_add_comment)
        self.create_action('add_flatpak_app', self.on_add_flatpak_app)
        self.create_action('add_flatpak_flathub', self.on_add_flatpak_flathub)
        self.create_action('add_flatpak_remote', self.on_add_flatpak_remote)
        self.create_action('add_flatpak_local', self.on_add_flatpak_local)
        self.create_action('add_copr_repository', self.on_add_copr_repository)
        self.create_action('add_variable', self.on_add_variable)

        self.create_action('generate_script', self.on_generate_script)
        self.create_action('cancel', self.on_cancel)

    # Activate Application
    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = PackagesinstallerWindow(application=self)

        # Show Load Configuration Page
        self.page_stack = win.page_stack
        self.page_stack.set_visible_child_name("page_load_configuration")

        # Bind commandstores
        self.props.active_window.packages_group.bind_model(self.commandstore,self.create_command_row)
        self.props.active_window.variables_group.bind_model(self.variablestore,self.create_variable_row)

        # Load preferences
        self.preferences = Preferences()
        self.preferences_dialog = PackagesinstallerPreferences(self.preferences)
        self.preferences_dialog.connect("closed",self.on_save_preferences)
        self.preferences_dialog.pref_terminal.bind_property("text", self.preferences, "terminal", GObject.BindingFlags.BIDIRECTIONAL)
        self.preferences_dialog.pref_greeting.bind_property("text", self.preferences, "greeting", GObject.BindingFlags.BIDIRECTIONAL)
        win.present()

    # -----------------------------------------------------
    # Configuration
    # -----------------------------------------------------

    # Reset configuration
    def reset_configuration(self):
        self.loaded_filename = ""
        self.commandstore.remove_all()
        self.variablestore.remove_all()
        self.props.active_window.config_title.set_text("")
        self.props.active_window.config_description.set_text("")
        self.props.active_window.config_successmessage.set_text("")

    # Cancel configuration
    def on_cancel(self, *args):

        dialog = Adw.AlertDialog(
            heading="Cancel Configuration",
            body="Do you really want to cancel editing the configuration?",
            close_response="no",
        )

        dialog.add_response("no", "No")
        dialog.add_response("yes", "Yes")
        dialog.set_response_appearance("yes", Adw.ResponseAppearance.DESTRUCTIVE)
        dialog.choose(self.props.active_window, None, self.on_response_cancel_dialog)

    def on_response_cancel_dialog(self,_dialog, task):
        response = _dialog.choose_finish(task)
        if response == "yes":
            self.page_stack.set_visible_child_name("page_load_configuration")
            self.props.active_window.btn_run.set_visible(False)
            self.props.active_window.btn_cancel.set_visible(False)
            self.reset_configuration()

    # -----------------------------------------------------
    # Save/Save As file
    # -----------------------------------------------------

    def on_check_save(self, *args):
        if len(self.props.active_window.config_title.get_text()) > 1 and len(self.props.active_window.config_scriptname.get_text()) > 1:
            self.on_saveas_file()
        else:
            dialog = Adw.AlertDialog(
                heading="Error",
                body="Please fill out all fields to save your configuration",
                close_response="cancel",
            )
            dialog.add_response("okay", "Okay")
            dialog.choose(self.props.active_window, None)

    def on_saveas_file(self, *args):

        FILTER_PKGINST_FILES = Gtk.FileFilter()
        FILTER_PKGINST_FILES.set_name(name='PackagesInstaller')
        FILTER_PKGINST_FILES.add_pattern(pattern='*.pkginst')
        FILTER_PKGINST_FILES.add_mime_type(mime_type='text/json')

        FILTER_ALL_FILES = Gtk.FileFilter()
        FILTER_ALL_FILES.set_name(name='All')
        FILTER_ALL_FILES.add_pattern(pattern='*')

        gio_list_store = Gio.ListStore.new(Gtk.FileFilter)
        gio_list_store.append(item=FILTER_PKGINST_FILES)
        gio_list_store.append(item=FILTER_ALL_FILES)

        if len(self.loaded_filename) == 0:
            self.loaded_filename = "packages.pkginst"

        dialog = Gtk.FileDialog(initial_name=self.loaded_filename)
        dialog.set_filters(filters=gio_list_store)
        dialog.save(parent=self.props.active_window, cancellable=None, callback=self.on_file_saveased)

    def on_file_saveased(self, dialog, result):
        file = dialog.save_finish(result)
        if file is not None:
            self.save_configuration = lib.create_json(self.props.active_window,self.variablestore,self.commandstore)
            with open(file, 'w', encoding='utf-8') as f:
                json.dump(self.save_configuration, f, ensure_ascii=False, indent=4)

    # -----------------------------------------------------
    # New configuration
    # -----------------------------------------------------

    def on_new_file(self, *args):
        self.props.active_window.btn_run.set_visible(True)
        self.props.active_window.btn_cancel.set_visible(True)
        self.page_stack.set_visible_child_name("page_configuration")

    # -----------------------------------------------------
    # Open File/Remote
    # -----------------------------------------------------

    def on_open_file(self, *args):

        FILTER_PKGINST_FILES = Gtk.FileFilter()
        FILTER_PKGINST_FILES.set_name(name='PackagesInstaller')
        FILTER_PKGINST_FILES.add_pattern(pattern='*.pkginst')
        FILTER_PKGINST_FILES.add_mime_type(mime_type='text/json')

        FILTER_ALL_FILES = Gtk.FileFilter()
        FILTER_ALL_FILES.set_name(name='All')
        FILTER_ALL_FILES.add_pattern(pattern='*')

        gio_list_store = Gio.ListStore.new(Gtk.FileFilter)
        gio_list_store.append(item=FILTER_PKGINST_FILES)
        gio_list_store.append(item=FILTER_ALL_FILES)

        dialog = Gtk.FileDialog()
        dialog.set_filters(filters=gio_list_store)
        dialog.open(self.props.active_window, None, self.on_file_opened)

    def on_file_opened(self, dialog, result):
        file = dialog.open_finish(result)
        if file is not None:
            with open(file, 'r') as f:
                value = f.read()
            if self.convert_to_json(value):
                self.config_type = "local"
                self.loaded_filename = lib.get_file_name(file)
                self.set_configuration()

    # Loads configuration from selected source
    def set_configuration(self):
        self.props.active_window.config_title.set_text(self.loaded_configuration["title"])
        self.props.active_window.config_description.set_text(self.loaded_configuration["description"])
        self.props.active_window.config_successmessage.set_text(self.loaded_configuration["successmessage"])
        self.props.active_window.config_scriptname.set_text(self.loaded_configuration["scriptname"])

        for i in self.loaded_configuration["variables"]:
            item = VariableItem()
            item.var_name = i["name"]
            if "description" in i:
                item.var_description = i["description"]
            else:
                item.cmd_description = ""
            item.var_value = i["value"]
            self.variablestore.append(item)

        for i in self.loaded_configuration["packages"]:
            item = CommandItem(i["type"])

            if "name" in i:
                item.cmd_name = i["name"]
            else:
                item.cmd_name = ""

            if "packagenames" in i:
                item.cmd_packagenames = i["packagenames"]
            else:
                item.cmd_packagenames = {}

            if "description" in i:
                item.cmd_description = i["description"]
            else:
                item.cmd_description = ""

            if "isinstalled" in i:
                item.cmd_isinstalled = i["isinstalled"]
            else:
                item.cmd_isinstalled = False

            if "command" in i:
                item.cmd_command = i["command"]
            else:
                item.cmd_command = ""

            if "type" in i:
                item.cmd_type = i["type"]
            else:
                item.cmd_command = "package"

            self.commandstore.append(item)

        self.page_stack.set_visible_child_name("page_configuration")
        self.props.active_window.btn_run.set_visible(True)
        self.props.active_window.btn_cancel.set_visible(True)

    def load_remote_dialog(self, *_args):
        dialog = Adw.AlertDialog(
            heading="Remote Configuration",
            body="Please enter the url of the remote configuration.",
            close_response="cancel",
        )

        dialog.add_response("cancel", "Cancel")
        dialog.add_response("load", "Load")
        dialog.set_response_appearance("load", Adw.ResponseAppearance.SUGGESTED)
        entry = Gtk.Entry()
        dialog.set_extra_child(entry)
        dialog.choose(self.props.active_window, None, self.on_response_remote_dialog)

    def on_response_remote_dialog(self,_dialog, task):
        response = _dialog.choose_finish(task)
        if response == "load":
            entry = _dialog.get_extra_child()
            link = entry.get_text()

            try:
                f = urlopen(link)
                value = f.read()
            except:
                dialog = Adw.AlertDialog(
                    heading="Url Error",
                    body="The remote file could not be loaded.",
                    close_response="okay",
                )
                dialog.add_response("okay", "Okay")
                dialog.choose(self.props.active_window, None)
                return

            if self.convert_to_json(value):
                self.config_type = "remote"
                self.loaded_file = link
                a = urlparse(link)
                self.loaded_filename = os.path.basename(a.path)
                self.set_configuration()
                self.page_stack.set_visible_child_name("page_configuration")
            else:
                dialog = Adw.AlertDialog(
                    heading="File Error",
                    body="The remote file could not be loaded. Please check the file format.",
                    close_response="okay",
                )
                dialog.add_response("okay", "Okay")

    # -----------------------------------------------------
    # Variable Row
    # -----------------------------------------------------

    def create_variable_row(self,item):
        row = Adw.ExpanderRow()
        row.set_title(item.var_name)
        btn = Gtk.Button()
        btn.set_icon_name("user-trash-symbolic")
        btn.connect("clicked",self.delete_variable,row)
        btn.set_valign(3)
        row.add_suffix(btn)

        package_row = Adw.EntryRow()
        package_row.set_title("Variable")
        package_row.set_text(item.var_name)
        package_row.bind_property("text", row, "title", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "var_name", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Value")
        package_row.set_text(item.var_value)
        row.set_subtitle(item.var_value)
        package_row.bind_property("text", item, "var_value", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", row, "subtitle", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Description")
        package_row.set_text(item.var_description)
        package_row.bind_property("text", item, "var_description", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        return row

    # Add Variable to the variablestore
    def on_add_variable(self, *args):
        self.addvariable_dialog = PackagesinstallerAddVariable(self.variablestore)
        self.addvariable_dialog.present(self.props.active_window)

    # Delete a Variable from the variablestore
    def delete_variable(self, widget, row, *args):
        self.variablestore.remove(row.get_index())

    # -----------------------------------------------------
    # Package Row
    # -----------------------------------------------------

    def create_command_row(self,item):
        row = Adw.ExpanderRow()

        if item.cmd_type == "comment":
                row.set_margin_start(0)
        else:
                row.set_margin_start(20)
        row.set_title(item.cmd_name)
        row.set_subtitle(item.cmd_type)
        btn = Gtk.Button()
        btn.set_icon_name("user-trash-symbolic")
        btn.connect("clicked",self.delete_command,row)
        btn.set_valign(3)
        row.add_suffix(btn)

        btn = Gtk.Button()
        btn.set_icon_name("up-symbolic")
        btn.connect("clicked",self.move_command,row)
        btn.set_valign(3)
        row.add_prefix(btn)

        btn = Gtk.Button()
        btn.set_icon_name("down-symbolic")
        btn.connect("clicked",self.move_down_command,row)
        btn.set_valign(3)
        row.add_prefix(btn)

        btn = Gtk.Button()
        btn.set_icon_name("top-symbolic")
        btn.connect("clicked",self.top_command,row)
        btn.set_valign(3)
        row.add_prefix(btn)

        package_row = Adw.EntryRow()
        match item.cmd_type:
            case "command":
                package_row.set_title("Command")
            case "command-apt":
                package_row.set_title("Command for apt")
            case "command-dnf":
                package_row.set_title("Command for dnf")
            case "command-pacman":
                package_row.set_title("Command for pacman")
            case "command-zypper":
                package_row.set_title("Command for zypper")
            case "package":
                package_row.set_title("Package Name")
            case "echo":
                package_row.set_title("Echo")
            case "comment":
                package_row.set_title("Comment")
            case "flatpak-app":
                package_row.set_title("Flatpak ID")
            case "flatpak-flathub":
                package_row.set_title("Flatpak ID from Flathub")
            case "flatpak-remote":
                package_row.set_title("Flatpak Remote Url")
            case "flatpak-local":
                package_row.set_title("Absolute Path to Flatpak package")
            case "package-yay":
                package_row.set_title("Package Name")
            case "package-paru":
                package_row.set_title("Package Name")
            case "copr-repository":
                package_row.set_title("Copr Repository")

        package_row.set_text(item.cmd_name)
        package_row.bind_property("text", row, "title", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "cmd_name", GObject.BindingFlags.BIDIRECTIONAL)

        btn = Gtk.Button()
        btn.set_icon_name("view-list-bullet-rtl-symbolic")
        btn.connect("clicked",self.open_packagenames,item.cmd_packagenames)
        btn.set_valign(3)
        btn.set_visible(False)
        if item.cmd_type == "package":
            btn.set_visible(True)
        package_row.add_prefix(btn)

        row.add_row(package_row)

        package_row = Adw.SwitchRow()
        package_row.set_title("Check if package is already installed")
        package_row.set_active(item.cmd_isinstalled)
        package_row.bind_property("active", item, "cmd_isinstalled", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.set_visible(False)
        if item.cmd_type == "package":
            package_row.set_visible(True)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Download Folder")
        package_row.set_text(item.cmd_command)
        package_row.bind_property("text", item, "cmd_command", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.set_visible(False)
        if item.cmd_type == "download":
            package_row.set_visible(True)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Description")
        package_row.set_text(item.cmd_description)
        package_row.bind_property("text", item, "cmd_description", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        return row

    # -----------------------------------------------------
    # Add Commands
    # -----------------------------------------------------

    def on_add_command(self, *args):
        self.open_add_command_dialog("command")

    def on_add_command_apt(self, *args):
        self.open_add_command_dialog("command-apt")

    def on_add_command_dnf(self, *args):
        self.open_add_command_dialog("command-dnf")

    def on_add_command_pacman(self, *args):
        self.open_add_command_dialog("command-pacman")

    def on_add_command_zypper(self, *args):
        self.open_add_command_dialog("command-zypper")

    def on_add_package(self, *args):
        self.open_add_command_dialog("package")

    def on_add_echo(self, *args):
        self.open_add_command_dialog("echo")

    def on_add_comment(self, *args):
        self.open_add_command_dialog("comment")

    def on_add_flatpak_app(self, *args):
        self.open_add_command_dialog("flatpak-app")

    def on_add_flatpak_flathub(self, *args):
        self.open_add_command_dialog("flatpak-flathub")

    def on_add_flatpak_remote(self, *args):
        self.open_add_command_dialog("flatpak-remote")

    def on_add_flatpak_local(self, *args):
        self.open_add_command_dialog("flatpak-local")

    def on_add_copr_repository(self, *args):
        self.open_add_command_dialog("copr-repository")

    def on_add_package_yay(self, *args):
        self.open_add_command_dialog("package-yay")

    def on_add_package_paru(self, *args):
        self.open_add_command_dialog("package-paru")

    # Open Add Dialog
    def open_add_command_dialog(self,add_cmd_type):
        self.addcommand_dialog = PackagesinstallerAddCommand(self.commandstore,add_cmd_type)
        self.addcommand_dialog.set_size_request(400,100)
        self.addcommand_dialog.present(self.props.active_window)

    # Delete a Package from the commandstore
    def delete_command(self, widget, row, *args):
        self.commandstore.remove(row.get_index())

    # Move Package up in the commandstore
    def move_command(self, widget, row, *args):
        pos = row.get_index()
        if pos > 0:
            c = self.commandstore.get_item(pos)
            self.commandstore.insert(pos-1,c)
            self.commandstore.remove(pos+1)

    # Move Package up in the commandstore
    def move_down_command(self, widget, row, *args):
        pos = row.get_index()
        if pos < (self.commandstore.get_n_items()-1):
            c = self.commandstore.get_item(pos)
            self.commandstore.remove(pos)
            self.commandstore.insert(pos+1,c)

    # Move Package to the top in the commandstore
    def top_command(self, widget, row, *args):
        pos = row.get_index()
        c = self.commandstore.get_item(pos)
        self.commandstore.insert(0,c)
        self.commandstore.remove(pos+1)

    def open_packagenames(self, widget, item, *args):
        self.packagenames_dialog = PackagesinstallerPackagenames(item)
        self.packagenames_dialog.set_size_request(400,100)
        self.packagenames_dialog.present(self.props.active_window)

    # -----------------------------------------------------
    # About Dialog
    # -----------------------------------------------------

    def on_about_action(self, *args):
        about = Adw.AboutDialog(application_name='Packages Installer',
                                application_icon='com.ml4w.packagesinstaller',
                                developer_name='Stephan Raabe',
                                comments=(
                                    'Create portable bash installation scripts for your favorite packages collection.'
                                    'The following package managers and related Linux distributions are supported: apt, dnf, pacman (+ yay and paru), zypper'
                                ),
                                version=self.preferences.version,
                                website="https://github.com/mylinuxforwork/packages-installer",
                                issue_url="https://github.com/mylinuxforwork/packages-installer/issues",
                                support_url="https://github.com/mylinuxforwork/packages-installer/issues",
                                copyright='© 2025 Stephan Raabe')
        # Translators: Replace "translator-credits" with your name/username, and optionally an email or URL.
        about.set_translator_credits(_('translator-credits'))
        about.present(self.props.active_window)

    # -----------------------------------------------------
    # Generate Script
    # -----------------------------------------------------

    def on_generate_script(self,*args):
        self.generate_dialog = PackagesinstallerGenerate(self.props.active_window,self.commandstore,self.variablestore,self.preferences)
        self.generate_dialog.set_size_request(400,100)
        self.generate_dialog.present(self.props.active_window)

    # -----------------------------------------------------
    # Main Menu
    # -----------------------------------------------------

    def on_preferences_action(self, widget, _):
        self.preferences_dialog.present(self.props.active_window)

    def on_save_preferences(self, dialog, *args):
        self.preferences.write_json()

    def on_help(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/wiki"])

    def on_check_updates(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/releases/latest"])

    def on_report_issue(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/issues"])

    def on_arch_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://archlinux.org/"])

    def on_ubuntu_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://packages.ubuntu.com/"])

    def on_fedora_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://packages.fedoraproject.org/"])

    def on_opensuse_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://software.opensuse.org/find"])

    # -----------------------------------------------------
    # Helpers
    # -----------------------------------------------------

    # Convert string to json
    def convert_to_json(self,value):
        try:
            self.loaded_configuration = json.loads(value)
            return True
        except:
            dialog = Adw.AlertDialog(
                heading="Format Error",
                body="The remote file has an unvalid format. Please check your remote file.",
                close_response="okay",
            )
            dialog.add_response("okay", "Okay")
            dialog.choose(self.props.active_window, None)
            return False

    # Create am action
    def create_action(self, name, callback, shortcuts=None):
        action = Gio.SimpleAction.new(name, None)
        action.connect("activate", callback)
        self.add_action(action)
        if shortcuts:
            self.set_accels_for_action(f"app.{name}", shortcuts)

# -----------------------------------------------------
# Run Application
# -----------------------------------------------------

def main(version):
    lib.setupConfigFolder()
    path_name = str(pathlib.Path(__file__).resolve().parent)
    app = PackagesinstallerApplication()
    return app.run(sys.argv)
