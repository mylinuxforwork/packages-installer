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
import subprocess

gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')

from gi.repository import Gtk, Gio, Adw
from .window import PackagesinstallerWindow
from .cmdline import main as cli_main
from .lib.library import Library

lib = Library()

class PackagesinstallerApplication(Adw.Application):
    def __init__(self):
        super().__init__(application_id='com.ml4w.packagesinstaller',
                         flags=Gio.ApplicationFlags.DEFAULT_FLAGS)
        self.create_action('quit', lambda *_: self.quit(), ['<primary>q'])
        self.create_action('about', self.on_about_action)
        self.create_action('preferences', self.on_preferences_action)

        self.create_action('pacman_packages', self.on_pacman_packages)
        self.create_action('apt_packages', self.on_apt_packages)
        self.create_action('dnf_packages', self.on_dnf_packages)
        self.create_action('zypper_packages', self.on_zypper_packages)

        self.create_action('help', self.on_help_action)
        self.create_action('issue', self.on_issue_action)
        self.create_action('update', self.on_update_action)

        lib.setup()

    def do_activate(self):
        win = self.props.active_window
        if not win:
            win = PackagesinstallerWindow(application=self)
        win.present()

    # --------------------------------------------------
    # About Dialog
    # --------------------------------------------------
    def on_about_action(self, *args):
        about = Adw.AboutDialog(application_name='Packages Installer',
                                application_icon='com.ml4w.packagesinstaller',
                                developer_name='Stephan Raabe',
                                comments=(
                                    'Create portable bash installation scripts for your favorite packages collection.'
                                    'The following package managers and related Linux distributions are supported: apt, dnf, pacman (+ yay and paru), zypper'
                                ),
                                version="0.5",
                                website="https://github.com/mylinuxforwork/packages-installer",
                                issue_url="https://github.com/mylinuxforwork/packages-installer/issues",
                                support_url="https://github.com/mylinuxforwork/packages-installer/issues",
                                copyright='© 2025 Stephan Raabe')
        about.set_translator_credits(_('translator-credits'))
        about.present(self.props.active_window)

    # --------------------------------------------------
    # Menu Items
    # --------------------------------------------------
    def on_pacman_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://archlinux.org/"])

    def on_apt_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://packages.ubuntu.com/"])

    def on_dnf_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://packages.fedoraproject.org/"])

    def on_zypper_packages(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://software.opensuse.org/find"])

    def on_help_action(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/wiki"])

    def on_update_action(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/releases/latest"])

    def on_issue_action(self, widget, _):
        subprocess.Popen(["flatpak-spawn", "--host", "xdg-open", "https://github.com/mylinuxforwork/packages-installer/issues"])

    def on_preferences_action(self, widget, _):
        print('app.preferences action activated')

    # --------------------------------------------------
    # Create Actions
    # --------------------------------------------------
    def create_action(self, name, callback, shortcuts=None):
        action = Gio.SimpleAction.new(name, None)
        action.connect("activate", callback)
        self.add_action(action)
        if shortcuts:
            self.set_accels_for_action(f"app.{name}", shortcuts)

def main(version):
    if len(sys.argv) == 1:
        app = PackagesinstallerApplication()
        return app.run(sys.argv)
    return cli_main(version)

