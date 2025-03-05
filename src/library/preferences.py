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

    def __init__(self):
        super().__init__()
        try:
            pref_json = json.load(open(self.config_folder + "/preferences.json"))
            self.terminal = pref_json["terminal"]
        except:
            self.terminal = ""

    def write_json(self):
        pref = {}
        pref["terminal"] = self.terminal
        with open(self.config_folder + '/preferences.json', 'w', encoding='utf-8') as f:
            json.dump(pref, f, ensure_ascii=False, indent=4)
        
