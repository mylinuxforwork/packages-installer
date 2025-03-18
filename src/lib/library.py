# library.py
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

import gi
import subprocess
import json
import os
import sys
import pathlib
import shutil

from gi.repository import Gtk, Adw, Gio, Gdk
from urllib.parse import urlparse

# Library of helper functions
class Library:

    path_name = os.path.dirname(sys.argv[0])
    path_name = str(pathlib.Path(__file__).resolve().parent.parent)
    home_folder = os.path.expanduser('~')
    config_folder = home_folder + "/.local/share/com.ml4w.packagesinstaller"
    exec_folder = home_folder + "/.local/bin/"

    def setup(self):

        # Create config folder
        if not os.path.exists(self.config_folder):
            pathlib.Path(self.config_folder).mkdir(parents=True, exist_ok=True)
            print(":: " + self.config_folder + " created")

        # Delete old script folder
        if os.path.exists(self.config_folder):
            shutil.rmtree(self.config_folder)

        # Copy latest version to script folder
        shutil.copytree(self.path_name + '/script', self.config_folder)

        # Create Bin folder
        if not os.path.exists(self.exec_folder):
            pathlib.Path(self.exec_folder).mkdir(parents=True, exist_ok=True)
            print(":: " + self.exec_folder + " created")

        # Remove old packages-installer file
        if os.path.exists(self.exec_folder + "/packages-installer"):
            os.remove(self.exec_folder + "/packages-installer")

        # Copy new packages-installer file
        shutil.copy(self.path_name + '/script/packages-installer', self.exec_folder)

        print(":: Installation script has been installed/updated in " + self.config_folder)
        print(":: Please add " + self.exec_folder + " to your PATH environment variable")
        print(":: Execute it with packages-installer in your terminal")
        print(":: Get help with packages-installer -h")

