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
from urllib.request import urlopen
from urllib.parse import urlparse

from .library.library import Library
from .library.historyitem import HistoryItem
from .library.packageitem import PackageItem

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
    historystore = Gio.ListStore()

    # Init Application
    def __init__(self):
        super().__init__(application_id='com.ml4w.packagesinstaller',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)
        self.create_action('open_file', self.on_open_file)
        self.create_action('saveas_file', self.on_saveas_file)
#        self.create_action('open_remote', self.on_open_remote)
        self.create_action('open_remote', self.create_advanced_dialog)
        self.create_action('add_package', self.on_add_package)
        self.create_action('cancel', self.on_cancel)

    # Activate Application
    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = PackagesinstallerWindow(application=self)

        # Setup History
        self.load_history()
        self.props.active_window.history_group.bind_model(self.historystore,self.create_history_row)

        # Show Load Configuration Page
        self.page_stack = win.page_stack
        self.page_stack.set_visible_child_name("page_load_configuration")

        win.present()

    # -----------------------------------------------------
    # History
    # -----------------------------------------------------

    # Load History
    def load_history(self):
        history = lib.load_history_json()

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
        self.props.active_window.config_errormessage.set_text("")

    # Cancel configuration
    def on_cancel(self, *args):
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

    def on_open_remote(self, *args):

        self.createAdvancedDialog().catch(console.error);

        link = self.props.active_window.open_remote_url.get_text()
        f = urlopen(link)
        value = f.read()
        if self.convert_to_json(value):
            self.config_type = "remote"
            self.loaded_file = link
            a = urlparse(link)
            self.loaded_filename = os.path.basename(a.path)
            self.set_configuration()
            self.page_stack.set_visible_child_name("page_configuration")

    # Loads configuration from selected source
    def set_configuration(self):
        self.props.active_window.config_title.set_text(self.loaded_configuration["title"])
        self.props.active_window.config_description.set_text(self.loaded_configuration["description"])
        self.props.active_window.config_distribution.set_text(self.loaded_configuration["distribution"])
        self.props.active_window.config_successmessage.set_text(self.loaded_configuration["successmessage"])
        self.props.active_window.config_errormessage.set_text(self.loaded_configuration["errormessage"])

        for i in self.loaded_configuration["packages"]:
            item = PackageItem()
            item.package = i["package"]
            if "description" in i:
                item.description = i["description"]
            else:
                item.description = ""
            item.installationcommand = i["installationcommand"]
            self.liststore.append(item)

        self.props.active_window.packages_group.bind_model(self.liststore,self.create_package_row)

        # Adding Remote Configurations to the History
        if self.config_type == "remote":
            history_item = HistoryItem()
            history_item.title = self.loaded_configuration["title"]
            history_item.description = self.loaded_configuration["description"]
            history_item.remote = self.loaded_file
            self.historystore.append(history_item)

        self.page_stack.set_visible_child_name("page_configuration")
        self.props.active_window.btn_run.set_visible(True)
        self.props.active_window.btn_cancel.set_visible(True)

    def create_advanced_dialog(self, *_args):
        dialog = Adw.AlertDialog(
            heading="Remote Configuration",
            body="Please enter the url of the remote configuration.",
            close_response="cancel",
        )

        dialog.add_response("cancel", "Cancel")
        dialog.add_response("load", "Load")

        # Use SUGGESTED appearance to mark important responses such as the affirmative action
        dialog.set_response_appearance("load", Adw.ResponseAppearance.SUGGESTED)

        entry = Gtk.Entry()
        dialog.set_extra_child(entry)

        dialog.choose(self.props.active_window, None, self.on_response_selected_advanced)

    def on_response_selected_advanced(self,_dialog, task):
        entry = _dialog.get_extra_child()
        link = entry.get_text()
        f = urlopen(link)
        value = f.read()
        if self.convert_to_json(value):
            self.config_type = "remote"
            self.loaded_file = link
            a = urlparse(link)
            self.loaded_filename = os.path.basename(a.path)
            self.set_configuration()
            self.page_stack.set_visible_child_name("page_configuration")

    # -----------------------------------------------------
    # History Row
    # -----------------------------------------------------

    def create_history_row(self,item):
        row = Adw.ActionRow()
        row.set_title(item.title)
        row.set_subtitle(item.description + "\n" + item.remote)
        btn = Gtk.Button()
        btn.set_label("Open")
        btn.connect("clicked",self.open_history_configuration,row)
        btn.set_valign(3)
        row.add_suffix(btn)
        return row

    def open_history_configuration(self, *args):
        print("Open Configuration from History")

    # -----------------------------------------------------
    # Package Row
    # -----------------------------------------------------

    def create_package_row(self,item):
        row = Adw.ExpanderRow()
        row.set_title(item.package)
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

        package_row = Adw.EntryRow()
        package_row.set_title("Package")
        package_row.set_text(item.package)
        package_row.bind_property("text", row, "title", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "package", GObject.BindingFlags.BIDIRECTIONAL)

        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Description")
        row.set_subtitle(item.description)
        package_row.set_text(item.description)
        package_row.bind_property("text", row, "subtitle", GObject.BindingFlags.BIDIRECTIONAL)
        package_row.bind_property("text", item, "description", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        package_row = Adw.EntryRow()
        package_row.set_title("Installation Command")
        package_row.set_text(item.installationcommand)
        # package_row.bind_property("text", item, "installationcommand", GObject.BindingFlags.BIDIRECTIONAL)
        row.add_row(package_row)

        return row

    # Add Package to the liststore
    def on_add_package(self, *args):
        print("drin")

    # Delete a Package from the liststore
    def delete_package(self, widget, row, *args):
        self.liststore.remove(row.get_index())

    # Move Package up in the liststore
    def move_package(self, widget, row, *args):
        pos = row.get_index()
        c = self.liststore.get_item(pos)
        self.liststore.remove(pos)
        self.liststore.insert(pos-1,c)

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

    def on_preferences_action(self, widget, _):
        print('app.preferences action activated')

    # -----------------------------------------------------
    # Helpers
    # -----------------------------------------------------

    # Convert string to json
    def convert_to_json(self,value):
        try:
            self.loaded_configuration = json.loads(value)
            return True
        except:
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
