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
from .library.library import Library
from gi.repository import GObject,Gtk, Gio, Adw

@Gtk.Template(resource_path='/com/ml4w/packagesinstaller/generate.ui')
class PackagesinstallerGenerate(Adw.PreferencesDialog):
    __gtype_name__ = 'PackagesinstallerGenerate'

    generate_scriptname = Gtk.Template.Child()
    generate_apt = Gtk.Template.Child()
    generate_dnf = Gtk.Template.Child()
    generate_pacman = Gtk.Template.Child()
    generate_zypper = Gtk.Template.Child()

    save_ok = GObject.property(type = bool, default = False)

    generate_now_btn = Gtk.Template.Child()

    lib = Library()

    def __init__(self,win,commandstore,variablestore):
        super().__init__()
        self.win = win

        self.commandstore = commandstore
        self.variablestore = variablestore

        self.generate_scriptname.set_text(self.win.config_scriptname.get_text())
        self.generate_scriptname.connect("changed",self.on_activate_scriptname)
        self.generate_apt.connect("notify::active",self.on_activate_scriptname)
        self.generate_dnf.connect("notify::active",self.on_activate_scriptname)
        self.generate_pacman.connect("notify::active",self.on_activate_scriptname)
        self.generate_zypper.connect("notify::active",self.on_activate_scriptname)
        self.generate_now_btn.bind_property("sensitive", self, "save_ok", GObject.BindingFlags.BIDIRECTIONAL)

        self.generate_now_btn.connect('clicked', self.on_generate)

    def on_activate_scriptname(self,widget,*args):
        if len(self.generate_scriptname.get_text()) != 0 and (self.generate_apt.get_active() == True or self.generate_dnf.get_active() == True or self.generate_pacman.get_active() == True or self.generate_zypper.get_active() == True):
            self.save_ok = True
        else:
            self.save_ok = False

    def on_generate(self,*args):
        dialog = Gtk.FileDialog()
        dialog.select_folder(parent=self.win, callback=self.on_script_saveased)

    def on_script_saveased(self, file_dialog, gio_task):
        folder = file_dialog.select_folder_finish(gio_task)
        # print(f'Folder name: {folder.get_basename()}')
        # print(f'Folder path: {folder.get_path()}')
        # print(f'Folder URI: {folder.get_uri()}\n')
        folder_path = folder.get_path()
        sel_manager = []
        if self.generate_apt.get_active():
            sel_manager.append("apt")
        if self.generate_dnf.get_active():
            sel_manager.append("dnf")
        if self.generate_pacman.get_active():
            sel_manager.append("pacman")
        if self.generate_zypper.get_active():
            sel_manager.append("zypper")

        self.lib.generate_installer(self.win,folder_path,self.generate_scriptname.get_text(),sel_manager,self.commandstore,self.variablestore)

        self.close()
