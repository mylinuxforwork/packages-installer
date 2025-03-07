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
    add_cmd_command = Gtk.Template.Child()
    add_cmd_description = Gtk.Template.Child()
    add_cmd_btn = Gtk.Template.Child()

    store = Gio.ListStore()

    def __init__(self, store):
        super().__init__()
        self.add_cmd_name.connect("changed",self.on_activate_add_cmd_name)
        self.add_cmd_btn.connect('clicked', self.on_save)
        self.store = store

    def on_activate_add_cmd_name(self,widget,*args):
        if len(self.add_cmd_name.get_text()) != 0:
            self.add_cmd_btn.set_sensitive(True)
        else:
            self.add_cmd_btn.set_sensitive(False)

    def on_save(self,*args):
        item = CommandItem("command")
        item.cmd_name = self.add_cmd_name.get_text()
        item.cmd_command = self.add_cmd_command.get_text()
        item.cmd_description = self.add_cmd_description.get_text()
        item.cmd_isinstalled = True
        item.cmd_type = "command"
        self.store.insert(0,item)
        self.close()
