import bluetooth
from typing import Optional


def send_messages(mac_address: str,
        message: str,
        channel: Optional[int] = 1) -> None:
    """
    Send messages (client side)
    :param mac_address: (str)
    """
    socket = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    socket.connect((mac_address, channel))

    print(f"Connected to {mac_address}")
    
    socket.send(message)


def receive_messages(channel: Optional[int] = 1) -> None:
    """
    Receive messages (server side)
    """
    server_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    server_sock.bind(("", channel))
    print("Waiting for client...")
    # Wait for client
    server_sock.listen(1)

    client_sock, client_address = server_sock.accept()
    print(f"Accepted connection from {client_address}")
    data = client_sock.recv(1024)
    data = data.decode("utf-8")
    
    print(data)
    print("Finished")


# Print nearby bluetooth devices
def discover_devices():
    """
    Print nearby bluetooth devices
    """
    nearby_devices = bluetooth.discover_devices()
    for bdaddr in nearby_devices:
        print(f"{bluetooth.lookup_name(bdaddr)} + [{bdaddr}]")


# Close connection to Raspberry Pi bluetooth
def close_connection(client_socket):
    client_socket.close()
    return

