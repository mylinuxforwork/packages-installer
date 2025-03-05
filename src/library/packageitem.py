from gi.repository import GObject,Gtk, Gio, Adw

class PackageItem(GObject.GObject):

    pkg_package = GObject.property(type = str)
    pkg_command = GObject.property(type = str)
    pkg_description = GObject.property(type = str)

    def __init__(self):
        GObject.GObject.__init__(self)

