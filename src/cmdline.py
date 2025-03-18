# cmdline.py
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
import argparse
import os
import pathlib
import subprocess
import shutil

class CommandLineInterface:

    path_name = os.path.dirname(sys.argv[0])
    path_name = str(pathlib.Path(__file__).resolve().parent)
    home_folder = os.path.expanduser('~')
    config_folder = home_folder + "/.local/share/com.ml4w.packagesinstaller"
    exec_folder = home_folder + "/.local/bin/"

    def __init__(self, version):
        self.version = version
        # self.parser = self.create_argument_parser()
        # self.calculator = IPCalculator()

    def create_argument_parser(self):
        print("drin")

    def run(self):
        # args = self.parser.parse_args()

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


        # subprocess.Popen(["flatpak-spawn", "--host", "kitty", "-e", self.config_folder + "/script/packages-installer", "-s", "https://raw.githubusercontent.com/mylinuxforwork/dotfiles/main/packages.pkginst"])

        # if args.version:
        #     self.print_version()

def main(version):
    cli = CommandLineInterface(version)
    cli.run()

if __name__ == '__main__':
    main()
