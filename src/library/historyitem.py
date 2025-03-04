from gi.repository import GObject,Gtk, Gio, Adw

class HistoryItem(GObject.GObject):

    title = GObject.property(type = str)
    description = GObject.property(type = str)
    remote = GObject.property(type = str)

    def __init__(self):
        GObject.GObject.__init__(self)
