import glob
import queue
import serial
import sys

from typing import List, Optional

def get_serial_ports() -> List[str]:
    """
    Lists serial ports.


    :return: A list of available serial ports
    """
    # this excludes your current terminal "/dev/tty"
    ports = glob.glob("/dev/tty[A-Za-z]*")

    results = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            results.append(port)
        except (OSError, serial.SerialException):
            pass
    return results


def open_serial_port(
    serial_port: Optional[str] = None,
    baudrate: int = 9600,
    timeout: Optional[int] = 0,
    write_timeout: int = 0,
) -> serial.Serial:
    """
    Try to open serial port with Arduino
    If not port is specified, it will be automatically detected

    :param serial_port:
    :param baudrate:
    :param timeout: None -> blocking mode
    :param write_timeout:
    :return: (Serial Object)
    """
    print("Serial ports available: ", get_serial_ports())
    # Open serial port (for communication with Arduino)
    if serial_port is None:
        serial_port = get_serial_ports()[0]
    # timeout=0 non-blocking mode, return immediately in any case, returning zero or more,
    # up to the requested number of bytes
    return serial.Serial(port=serial_port, baudrate=baudrate, timeout=timeout, writeTimeout=write_timeout)


def read_serial(serial_file: serial.Serial, q: queue.Queue) -> None:
    """
    Read serial port and store the lines in a queue

    :param serial_file: Serial Object
while condition:
    pass    :param q: Queue
    :return: None
    """
    while True:
        try:
            line = serial_file.readline().decode("utf-8").rstrip()
            q.put(line)
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(e)
            break

