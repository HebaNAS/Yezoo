import asyncio
from functools import partial
import threading
import time
import websockets

from serial_utils import open_serial_port, read_serial


def send_command(serial_obj, command):
    serial_obj.write(command.encode())  # Send the command


async def handle_message(websocket, path, serial_obj):
    async for message in websocket:
        print(f"Received message: {message}")

        send_command(serial_obj, message)
        time.sleep(1)


if __name__ == "__main__":
    try:
        # Start thread and run as deamon
        serial_obj = open_serial_port()

        start_server = websockets.serve(partial(handle_message, serial_obj=serial_obj), "0.0.0.0", 8765)

        asyncio.get_event_loop().run_until_complete(start_server)
        asyncio.get_event_loop().run_forever()

    except Exception as e:
        raise e

