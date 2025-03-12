# window.py
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

from gi.repository import Adw
from gi.repository import Gtk
from gi.repository import GObject,Gtk, Gio, Adw
from .library.commanditem import CommandItem

@Gtk.Template(resource_path='/com/ml4w/packagesinstaller/addcommand.ui')
class PackagesinstallerAddCommand(Adw.Dialog):
    __gtype_name__ = 'PackagesinstallerAddCommand'

    add_cmd_name = Gtk.Template.Child()
    add_cmd_btn = Gtk.Template.Child()
    add_cmd_type = ""
    store = Gio.ListStore()

    def __init__(self, store, cmd_type):
        super().__init__()
        self.add_cmd_name.connect("changed",self.on_activate_add_cmd_name)
        self.add_cmd_btn.connect('clicked', self.on_save)
        self.store = store
        self.add_cmd_type = cmd_type
        match self.add_cmd_type:
            case "command":
                self.set_title("New Command")
                self.add_cmd_name.set_title("Command")
            case "command-apt":
                self.set_title("New Command for apt")
                self.add_cmd_name.set_title("Command for apt")
            case "command-dnf":
                self.set_title("New Command for dnf")
                self.add_cmd_name.set_title("Command for dnf")
            case "command-pacman":
                self.set_title("New Command for pacman")
                self.add_cmd_name.set_title("Command for pacman")
            case "command-zypper":
                self.set_title("New Command for zypper")
                self.add_cmd_name.set_title("Command for zypper")
            case "package":
                self.set_title("New Package")
                self.add_cmd_name.set_title("Package Name")
            case "echo":
                self.set_title("New Echo")
                self.add_cmd_name.set_title("Output")
            case "flatpak-app":
                self.set_title("New Flatpak App")
                self.add_cmd_name.set_title("Flatpak ID")
            case "flatpak-flathub":
                self.set_title("New Flatpak from Flathub")
                self.add_cmd_name.set_title("Flatpak ID from Flathub")
            case "flatpak-remote":
                self.set_title("New Flatpak from Remote")
                self.add_cmd_name.set_title("Flatpak Remote Url")
            case "flatpak-local":
                self.set_title("New Flatpak from Local")
                self.add_cmd_name.set_title("Absolute Path to Flatpak package")
            case "package-yay":
                self.set_title("New Yay Package")
                self.add_cmd_name.set_title("Package Name")
            case "package-paru":
                self.set_title("New Paru Package")
                self.add_cmd_name.set_title("Package Name")
            case "copr-repository":
                self.set_title("New Copr Repository")
                self.add_cmd_name.set_title("Repository Name")

    def on_activate_add_cmd_name(self,widget,*args):
        if len(self.add_cmd_name.get_text()) != 0:
            self.add_cmd_btn.set_sensitive(True)
        else:
            self.add_cmd_btn.set_sensitive(False)

    def on_save(self,*args):
        item = CommandItem("command")
        item.cmd_name = self.add_cmd_name.get_text()
        item.cmd_description = ""
        item.cmd_isinstalled = True
        item.cmd_type = self.add_cmd_type
        self.store.append(item)
        self.close()
