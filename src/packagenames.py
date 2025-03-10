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
from .library.packagenamesitem import PackagenamesItem

@Gtk.Template(resource_path='/com/ml4w/packagesinstaller/packagenames.ui')
class PackagesinstallerPackagenames(Adw.PreferencesDialog):
    __gtype_name__ = 'PackagesinstallerPackagenames'

    packagereplacements_group = Gtk.Template.Child()
    save_packagenames_btn = Gtk.Template.Child()

    packagenamesstore = Gio.ListStore()

    def __init__(self, cmd_packagenames):
        super().__init__()

        self.packagereplacements_group.bind_model(self.packagenamesstore,self.create_packagenamesstore_row)
        self.save_packagenames_btn.connect('clicked', self.on_save)
        self.cmd_packagenames = cmd_packagenames
        self.packagenamesstore.remove_all()

        print(self.cmd_packagenames)

        item = PackagenamesItem()
        if "apt" in self.cmd_packagenames:
            item.pkn_name = self.cmd_packagenames["apt"]
        item.pkn_platform = "apt"
        self.packagenamesstore.append(item)

        item = PackagenamesItem()
        if "dnf" in self.cmd_packagenames:
            item.pkn_name = self.cmd_packagenames["dnf"]
        item.pkn_platform = "dnf"
        self.packagenamesstore.append(item)

        item = PackagenamesItem()
        if "pacman" in self.cmd_packagenames:
            item.pkn_name = self.cmd_packagenames["pacman"]
        item.pkn_platform = "pacman"
        self.packagenamesstore.append(item)

        item = PackagenamesItem()
        if "zypper" in self.cmd_packagenames:
            item.pkn_name = self.cmd_packagenames["zypper"]
        item.pkn_platform = "zypper"
        self.packagenamesstore.append(item)

    def create_packagenamesstore_row(self,item):
        row = Adw.EntryRow()
        row.set_title("Package for " + item.pkn_platform)
        row.set_text(item.pkn_name)
        row.connect("changed",self.on_row_change)
        return row

    def on_row_change(self,row,*args):
        pos = row.get_index()
        r = self.packagenamesstore.get_item(pos)
        r.pkn_name = row.get_text()

    def on_save(self,*args):
        for i in range(self.packagenamesstore.get_n_items()):
            r = self.packagenamesstore.get_item(i)
            match r.pkn_platform:
                case "apt":
                    self.cmd_packagenames["apt"] = r.pkn_name

                case "dnf":
                    self.cmd_packagenames["dnf"] = r.pkn_name

                case "pacman":
                    self.cmd_packagenames["pacman"] = r.pkn_name

                case "zypper":
                    self.cmd_packagenames["zypper"] = r.pkn_name
        self.close()
