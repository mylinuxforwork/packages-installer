from gi.repository import GObject,Gtk, Gio, Adw

class VariableItem(GObject.GObject):

    var_name = GObject.property(type = str)
    var_value = GObject.property(type = str)
    var_description = GObject.property(type = str)

    def __init__(self):
        GObject.GObject.__init__(self)

