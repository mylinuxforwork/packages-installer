from gi.repository import GObject,Gtk, Gio, Adw

class PackageItem(GObject.GObject):

    package = GObject.property(type = str)
    description = GObject.property(type = str)
    installationcommmand = GObject.property(type = str)

    def __init__(self):
        GObject.GObject.__init__(self)
