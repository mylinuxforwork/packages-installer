# main.py
#
# Copyright 2025 Unknown
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

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import GObject,Gtk, Gio, Adw
from .window import PackagesinstallerWindow
from .library.library import Library

lib = Library()

class PackagesinstallerApplication(Adw.Application):

    loaded_configuration = {}
    save_configuration = {}
    loaded_filename = ""

    def __init__(self):
        super().__init__(application_id='com.ml4w.packagesinstaller',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)
        self.create_action('open_file', self.on_open_file)
        self.create_action('saveas_file', self.on_saveas_file)
        self.create_action('open_remote', self.on_open_remote)

    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = PackagesinstallerWindow(application=self)

        self.page_stack = win.page_stack
        self.page_stack.set_visible_child_name("page_load_configuration")

        win.present()

    def on_saveas_file(self, *args):
        dialog = Gtk.FileDialog(initial_name=self.loaded_filename)
        dialog.save(parent=self.props.active_window, cancellable=None, callback=self.on_file_saveased)

    def on_file_saveased(self, dialog, result):
        file = dialog.save_finish(result)
        if file is not None:
            print("Saving now")
            contents="JSON"
            '''
            file.replace_contents_async(
                contents,
                etag=None,
                make_backup=False,
                flags=Gio.FileCreateFlags.NONE,
                cancellable=None,
                callback=on_replace_contents,
            )
            '''

    def on_replace_contents(file, result):
        file.replace_contents_finish(result)
        print(f"File {file.get_basename()} saved")

    def get_file_name(self, file):
        info = file.query_info("standard::name", Gio.FileQueryInfoFlags.NONE, None)
        return info.get_name()

    def on_file_opened(self, dialog, result):
        file = dialog.open_finish(result)
        if file is not None:
            with open(file, 'r') as f:
                value = f.read()
            if self.convert_to_json(value):
                self.set_configuration()
                self.loaded_filename = self.get_file_name(file)
                print(self.loaded_filename)

    def set_configuration(self):
        self.props.active_window.config_title.set_text(self.loaded_configuration["title"])
        self.props.active_window.config_description.set_text(self.loaded_configuration["description"])
        self.props.active_window.config_distribution.set_text(self.loaded_configuration["distribution"])
        self.props.active_window.config_isinstalledcommand.set_text(self.loaded_configuration["isinstalledcommand"])

        for i in self.loaded_configuration["packages"]:
            row = Adw.ExpanderRow()
            row.set_title(i["package"])

            package_row = Adw.EntryRow()
            package_row.set_title("Package")
            package_row.set_text(i["package"])
            package_row.bind_property("text", row, "title", GObject.BindingFlags.BIDIRECTIONAL)
            row.add_row(package_row)

            if "description" in i:
                description = i["description"]
            else:
                description = ""

            package_row = Adw.EntryRow()
            package_row.set_title("Description")
            row.set_subtitle(description)
            package_row.set_text(description)
            package_row.bind_property("text", row, "subtitle", GObject.BindingFlags.BIDIRECTIONAL)
            row.add_row(package_row)

            package_row = Adw.EntryRow()
            package_row.set_title("Installation Command")
            package_row.set_text(i["installationcommand"])
            row.add_row(package_row)

            package_row = Adw.ActionRow()
            package_row.set_title("")
            btn = Gtk.Button()
            btn.set_label("Delete")
            btn.set_valign(3)
            btn.connect("clicked",self.delete_package,row)
            package_row.add_suffix(btn)
            row.add_row(package_row)

            self.props.active_window.packages_group.add(row)

        self.page_stack.set_visible_child_name("page_configuration")

    def delete_package(self, widget, package_row, *args):
        self.props.active_window.packages_group.remove(package_row)

    def convert_to_json(self,value):
        try:
            self.loaded_configuration = json.loads(value)
            return True
        except:
            return False

    def on_open_file(self, *args):
        dialog = Gtk.FileDialog()
        dialog.open(self.props.active_window, None, self.on_file_opened)

    def on_open_remote(self, *args):
        print(self.props.active_window.open_remote_url.get_text())
        self.page_stack.set_visible_child_name("page_configuration")

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

    def create_action(self, name, callback, shortcuts=None):
        action = Gio.SimpleAction.new(name, None)
        action.connect("activate", callback)
        self.add_action(action)
        if shortcuts:
            self.set_accels_for_action(f"app.{name}", shortcuts)


def main(version):
    lib.installInstallationScript()
    print(sys.argv)
    app = PackagesinstallerApplication()
    return app.run(sys.argv)
