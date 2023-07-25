import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

SERVICE_UUID = "e4341429-3b58-4723-86cc-bd70deda86ad"  # Replace with your service UUID
CHARACTERISTIC_UUID = "f4e0d6d3-ac9c-4d75-80c2-5428e7988210"  # Replace with your characteristic UUID

class GattCharacteristic(dbus.service.Object):
    def __init__(self, bus, index, uuid, flags, service):
        self.path = f"{service.path}/char{index}"
        self.bus = bus
        self.uuid = uuid
        self.flags = flags
        self.service = service
        super().__init__(bus, self.path)

    @dbus.service.method(dbus_interface="org.bluez.GattCharacteristic1", in_signature="a{sv}", out_signature="ay")
    def ReadValue(self, options):
        print("A device is connected and is reading characteristic")
            # Return some value here. For example, we just return an empty array.
        return dbus.Array([], signature="y")

    @dbus.service.method(dbus_interface="org.bluez.GattCharacteristic1", in_signature="aya{sv}")
    def WriteValue(self, value, options):
        print("A device is connected and is writing to characteristic")
 
        
class GattService(dbus.service.Object):
    def __init__(self, bus, index, uuid, primary):
        self.path = f"/org/bluez/service{index}"
        self.bus = bus
        self.uuid = uuid
        self.primary = primary
        dbus.service.Object.__init__(self, bus, self.path)

mainloop = DBusGMainLoop(set_as_default=True)
systembus = dbus.SystemBus(mainloop=mainloop)

service_manager = dbus.Interface(
    systembus.get_object("org.bluez", "/org/bluez"),
    "org.bluez.GattManager1")

service = GattService(systembus, 0, SERVICE_UUID, True)
characteristic = GattCharacteristic(systembus, 0, CHARACTERISTIC_UUID, ["read", "write"], service)

mainloop = GLib.MainLoop()
mainloop.run()
