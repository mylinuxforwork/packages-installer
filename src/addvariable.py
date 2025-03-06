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
from .library.variableitem import VariableItem

@Gtk.Template(resource_path='/com/ml4w/packagesinstaller/addvariable.ui')
class PackagesinstallerAddVariable(Adw.Dialog):
    __gtype_name__ = 'PackagesinstallerAddVariable'

    add_var_name = Gtk.Template.Child()
    add_var_value = Gtk.Template.Child()
    add_var_description = Gtk.Template.Child()
    add_var_btn = Gtk.Template.Child()

    store = Gio.ListStore()

    def __init__(self, store):
        super().__init__()
        self.add_var_name.connect("changed",self.on_activate_add_var_name)
        self.add_var_btn.connect('clicked', self.on_save)
        self.store = store

    def on_activate_add_var_name(self,widget,*args):
        if len(self.add_var_name.get_text()) != 0:
            self.add_var_btn.set_sensitive(True)
        else:
            self.add_var_btn.set_sensitive(False)

    def on_save(self,*args):
        item = VariableItem()
        item.var_name = self.add_var_name.get_text()
        item.var_value = self.add_var_value.get_text()
        item.var_description = self.add_var_description.get_text()
        self.store.insert(0,item)
        self.close()
