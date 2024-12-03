"""
README:

Requires python 3.X - any should work
Either pip install or apt install pymodbus

On the line that contains lambda: ModbusProxyProtocol - replace 10.0.2.15 with the IP of the VM -
or machine running the runtime environment

To run, in terminal type "python historian.py" or "python3 historian.py" depending on machine
Additionally, in the ScadaBR data source, replace port from 502 to 5020

What this code does is sits in between the data source and the HMI - logging all traffic flowing
It acts as a middleman reading the packets and logging their contents, before passing it on. 

Once the connection is established, the file "modbus_proxy.log" will start being populated with traffic- 
This happens quickly in our system due to the constant passing of status data. To kill the process, in - 
the terminal hit ctrl+c. 

I used the pymodbus module to handle decoding, so to read the function codes, see:
https://modbus.org/docs/Modbus_Application_Protocol_V1_1b.pdf which has them defined. 

For example though, if you see a function code of 5 - that indicates you wrote to a single coil - 
most likely from pressing a button.
"""

import asyncio
import logging
import struct
from pymodbus.factory import ClientDecoder
from pymodbus.transaction import ModbusSocketFramer

# Configure logging to write to a file
logging.basicConfig(filename='modbus_proxy.log', level=logging.DEBUG,
                    format='%(asctime)s %(levelname)s %(message)s')

log = logging.getLogger()
log.setLevel(logging.DEBUG)

class ModbusProxyProtocol(asyncio.Protocol):
    def __init__(self, remote_host, remote_port):
        self.remote_host = remote_host
        self.remote_port = remote_port
        self.transport = None
        self.remote_transport = None

    def connection_made(self, transport):
        self.transport = transport
        log.info("Connection from client established")
        # Connect to remote Modbus server
        asyncio.ensure_future(self.connect_to_remote())

    async def connect_to_remote(self):
        loop = asyncio.get_event_loop()
        # Connect to remote Modbus server
        try:
            self.remote_transport, self.remote_protocol = await loop.create_connection(
                lambda: ModbusProxyRemoteProtocol(self),
                self.remote_host,
                self.remote_port)
            log.info("Connected to remote Modbus server")
        except Exception as e:
            log.error(f"Failed to connect to remote Modbus server: {e}")
            self.transport.close()

    def data_received(self, data):
        # Data received from client
        log.debug(f"Received data from client: {data.hex()}")
        if len(data) >= 8:
            transaction_id, protocol_id, length = struct.unpack('>HHH', data[0:6])
            unit_id = data[6]
            function_code = data[7]

            log.info(f"Request - Transaction ID: {transaction_id}, Protocol ID: {protocol_id}, "
                     f"Length: {length}, Unit ID: {unit_id}, Function Code: {function_code}")

        if self.remote_transport:
            self.remote_transport.write(data)
            log.debug(f"Forwarded data to server: {data.hex()}")

    def connection_lost(self, exc):
        log.info("Connection from client lost")
        if self.remote_transport:
            self.remote_transport.close()

class ModbusProxyRemoteProtocol(asyncio.Protocol):
    def __init__(self, proxy_protocol):
        self.proxy_protocol = proxy_protocol
        self.transport = None

    def connection_made(self, transport):
        self.transport = transport
        self.proxy_protocol.remote_transport = transport
        log.info("Connection to remote server established")

    def data_received(self, data):
        # Data received from remote Modbus server
        log.debug(f"Received data from server: {data.hex()}")
        if len(data) >= 8:
            transaction_id, protocol_id, length = struct.unpack('>HHH', data[0:6])
            unit_id = data[6]
            function_code = data[7]

            log.info(f"Response - Transaction ID: {transaction_id}, Protocol ID: {protocol_id}, "
                     f"Length: {length}, Unit ID: {unit_id}, Function Code: {function_code}")

        if self.proxy_protocol.transport:
            self.proxy_protocol.transport.write(data)
            log.debug(f"Forwarded data to client: {data.hex()}")

    def connection_lost(self, exc):
        log.info("Connection to remote server lost")
        if self.proxy_protocol.transport:
            self.proxy_protocol.transport.close()

async def main():
    loop = asyncio.get_event_loop()
    # Replace '10.0.2.15' with your Modbus server's IP
    server = await loop.create_server(
        lambda: ModbusProxyProtocol('10.0.2.15', 502),
        '0.0.0.0',
        5020)  # Proxy server listens on port 5020
    log.info("Modbus proxy server started on port 5020")
    try:
        await server.serve_forever()
    except KeyboardInterrupt:
        log.info("Modbus proxy server shutting down.")

if __name__ == '__main__':
    asyncio.run(main())
