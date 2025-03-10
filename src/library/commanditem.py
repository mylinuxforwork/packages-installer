from gi.repository import GObject,Gtk, Gio, Adw

class CommandItem(GObject.GObject):

    cmd_name = GObject.property(type = str)
    cmd_command = GObject.property(type = str)
    cmd_description = GObject.property(type = str)
    cmd_isinstalled = GObject.property(type = bool, default = False)
    cmd_type = GObject.property(type = str)
    cmd_packagenames = []

    def __init__(self,cmd_type):
        GObject.GObject.__init__(self)
        self.cmd_type = cmd_type

