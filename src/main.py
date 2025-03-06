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

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import GObject,Gtk, Gio, Adw
from .window import PackagesinstallerWindow
from .preferences import PackagesinstallerPreferences
from urllib.request import urlopen
from urllib.parse import urlparse

from .library.library import Library
from .library.packageitem import PackageItem
from .library.preferences import Preferences

lib = Library()

class PackagesinstallerApplication(Adw.Application):

    # Configuration
    loaded_configuration = {}
    save_configuration = {}
    loaded_filename = ""
    loaded_file = ""

    # Local or Remote configuration
    config_type = ""

    # List Stores
    liststore = Gio.ListStore()

    # Preferences
    preferences = Preferences()

    # Init Application
    def __init__(self):
        super().__init__(application_id='com.ml4w.packagesinstaller',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)
        self.create_action('open_file', self.on_open_file)
        self.create_action('new_file', self.on_new_file)
        self.create_action('saveas_file', self.on_saveas_file)
        self.create_action('open_remote', self.load_remote_dialog)
        self.create_action('add_package', self.on_add_package)
        self.create_action('cancel', self.on_cancel)

    # Activate Application
    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = PackagesinstallerWindow(application=self)

        # Show Load Configuration Page
        self.page_stack = win.page_stack
        self.page_stack.set_visible_child_name("page_load_configuration")

        # Bind ListStore
        self.props.active_window.packages_group.bind_model(self.liststore,self.create_package_row)

        # Load preferences
        self.preferences = Preferences()
        self.preferences_dialog = PackagesinstallerPreferences(self.preferences.terminal)
        self.preferences_dialog.connect("closed",self.on_save_preferences)
        self.preferences_dialog.pref_terminal.bind_property("text", self.preferences, "terminal", GObject.BindingFlags.BIDIRECTIONAL)

        win.present()

    # -----------------------------------------------------
    # Configuration
    # -----------------------------------------------------

    # Reset configuration
    def reset_configuration(self):
        self.loaded_filename = ""
        self.liststore.remove_all()
        self.props.active_window.config_title.set_text("")
        self.props.active_window.config_description.set_text("")
        self.props.active_window.config_distribution.set_text("")
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

    def on_saveas_file(self, *args):
        dialog = Gtk.FileDialog(initial_name=self.loaded_filename)
        dialog.save(parent=self.props.active_window, cancellable=None, callback=self.on_file_saveased)

    def on_file_saveased(self, dialog, result):
        file = dialog.save_finish(result)
        if file is not None:
            lib.create_json(self.props.active_window,self.liststore)
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

    def on_file_opened(self, dialog, result):
        file = dialog.open_finish(result)
        if file is not None:
            with open(file, 'r') as f:
                value = f.read()
            if self.convert_to_json(value):
                self.config_type = "local"
                self.set_configuration()
                self.loaded_filename = lib.get_file_name(file)

    def on_open_file(self, *args):
        dialog = Gtk.FileDialog()
        dialog.open(self.props.active_window, None, self.on_file_opened)

    # Loads configuration from selected source
    def set_configuration(self):
        self.props.active_window.config_title.set_text(self.loaded_configuration["title"])
        self.props.active_window.config_description.set_text(self.loaded_configuration["description"])
        self.props.active_window.config_distribution.set_text(self.loaded_configuration["distribution"])
        self.props.active_window.config_successmessage.set_text(self.loaded_configuration["successmessage"])

        for i in self.loaded_configuration["packages"]:
            item = PackageItem()
            item.pkg_package = i["package"]
            if "description" in i:
                item.pkg_description = i["description"]
            else:
                item.pkg_description = ""
            item.pkg_installation = i["installationcommand"]
            self.liststore.append(item)

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
    # Package Row
    # -----------------------------------------------------

    def create_package_row(self,item):
        row = Adw.ExpanderRow()
        row.set_title(item.pkg_package)
        btn = Gtk.Button()
        btn.set_label("Delete")
        btn.connect("clicked",self.delete_package,row)
        btn.set_valign(3)
        row.add_suffix(btn)

        btn = Gtk.Button()
        btn.set_label("Up")
        btn.connect("clicked",self.move_package,row)
        btn.set_valign(3)
        row.add_prefix(btn)

        btn = Gtk.Button()
        btn.set_label("To Top")
        btn.connect("clicked",self.top_package,row)
        btn.set_valign(3)
        row.add_prefix(btn)

        package_row = Adw.EntryRow()
        package_row.set_title("Package")
        package_row.set_text(item.pkg_package)
        package_row.bind_property("text", row, "title", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "pkg_package", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Description")
        row.set_subtitle(item.pkg_description)
        package_row.set_text(item.pkg_description)
        package_row.bind_property("text", row, "subtitle", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "pkg_description", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Installation Command")
        package_row.set_text(item.pkg_command)
        package_row.bind_property("text", item, "pkg_command", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        return row

    # Add Package to the liststore
    def on_add_package(self, *args):
        item = PackageItem()
        self.liststore.insert(0,item)

    # Delete a Package from the liststore
    def delete_package(self, widget, row, *args):
        self.liststore.remove(row.get_index())

    # Move Package up in the liststore
    def move_package(self, widget, row, *args):
        pos = row.get_index()
        if pos > 0:
            c = self.liststore.get_item(pos)
            self.liststore.insert(pos-1,c)
            self.liststore.remove(pos+1)

    # Move Package to the top in the liststore
    def top_package(self, widget, row, *args):
        pos = row.get_index()
        c = self.liststore.get_item(pos)
        self.liststore.insert(0,c)
        self.liststore.remove(pos+1)

    # -----------------------------------------------------
    # About Dialog
    # -----------------------------------------------------

    def on_about_action(self, *args):
        about = Adw.AboutDialog(application_name='Packages Installer',
                                application_icon='com.ml4w.packagesinstaller',
                                developer_name='Stephan Raabe',
                                version='0.1',
                                copyright='© 2025 Stephan Raabe')
        # Translators: Replace "translator-credits" with your name/username, and optionally an email or URL.
        about.set_translator_credits(_('translator-credits'))
        about.present(self.props.active_window)

    # -----------------------------------------------------
    # Preferences
    # -----------------------------------------------------

    def on_preferences_action(self, widget, _):
        self.preferences_dialog.present(self.props.active_window)

    def on_save_preferences(self, dialog, *args):
        self.preferences.write_json()

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
    app = PackagesinstallerApplication()
    return app.run(sys.argv)
