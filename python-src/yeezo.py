import serial
import queue
import threading
import time

from serial_utils import open_serial_port, read_serial


def send_command(serial_obj, command):
    serial_obj.write(command.encode())  # Send the command


if __name__ == "__main__":
    try:
        from uuid import uuid4
        char_uuid = str(uuid4())
        print(char_uuid)
        # serial_obj = open_serial_port(baudrate=9600, timeout=None)
        # print(serial_obj.name)
        # while True:
        #     # Test commands
        #     send_command(serial_obj, 'r')  # Right
        #     time.sleep(1)
        #     send_command(serial_obj, 'l')  # Left
        #     time.sleep(1)
        #     send_command(serial_obj, 'f')  # Forward
        #     time.sleep(1)
        #     send_command(serial_obj, 's')  # Stop
        #     time.sleep(1)
    except Exception as e:
        raise e

