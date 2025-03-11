import gi
import subprocess
import json
import os
import pathlib
import shutil

from gi.repository import GObject, Gtk, Adw, Gio, Gdk

class Preferences(GObject.Object):

    home_folder = os.path.expanduser('~')
    script_folder = "com.ml4w.packagesinstaller"
    config_folder = home_folder + "/.config/" + script_folder

    terminal = GObject.Property(type=str)
    greeting = GObject.Property(type=str)

    default_greeting = "Created with Packages Manager {version}"

    def __init__(self):
        super().__init__()
        self.version = "0.3"

        try:
            pref_json = json.load(open(self.config_folder + "/preferences.json"))
            self.terminal = pref_json["terminal"]
            self.greeting = pref_json["greeting"]
        except:
            self.terminal = ""
            self.greeting = self.default_greeting

    def write_json(self):
        pref = {}
        pref["terminal"] = self.terminal

        if len(self.greeting) == 0:
            self.greeting = self.default_greeting
        pref["greeting"] = self.greeting

        with open(self.config_folder + '/preferences.json', 'w', encoding='utf-8') as f:
            json.dump(pref, f, ensure_ascii=False, indent=4)
        
