from gi.repository import GObject,Gtk, Gio, Adw

class PackagenamesItem(GObject.GObject):

    pkn_name = GObject.property(type = str)
    pkn_platform = GObject.property(type = str)

    def __init__(self):
        GObject.GObject.__init__(self)