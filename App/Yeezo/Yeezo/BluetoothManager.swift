//
//  BluetoothManager.swift
//  Yeezo
//
//  Created by Heba El-Shimy on 24/07/2023.
//

import Combine
import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
        var peripheral: CBPeripheral!
        @Published var isSwitchedOn = false
        @Published var isConnected = false
        
        // Replace with the UUID of your peripheral device
        let targetPeripheralUUID = CBUUID(string: "e4341429-3b58-4723-86cc-bd70deda86ad")
        
        // Replace with the UUID of your service and characteristic
        let targetServiceUUID = CBUUID(string: "e4341429-3b58-4723-86cc-bd70deda86ad")
        let targetCharacteristicUUID = CBUUID(string: "f4e0d6d3-ac9c-4d75-80c2-5428e7988210")
    
    override init() {
            super.init()
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        
        // This function is called when the state of Bluetooth is changed.
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
            case .poweredOn:
                isSwitchedOn = true
                // Start scanning for peripherals
                centralManager.scanForPeripherals(withServices: [targetPeripheralUUID])
            default:
                isSwitchedOn = false
            }
        }
        
        // This function is called when a peripheral is discovered during scanning.
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            self.peripheral = peripheral
            self.peripheral.delegate = self
            centralManager.stopScan() // stop scanning as peripheral is found
            centralManager.connect(self.peripheral)
        }
        
        // This function is called when the app successfully connects to the peripheral.
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            isConnected = true
            peripheral.discoverServices([targetServiceUUID])
        }
        
        // This function is called when the app fails to connect to the peripheral.
        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            isConnected = false
            // Handle failure to connect here
        }
        
        // This function is called when the services of the peripheral are discovered.
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let services = peripheral.services {
                for service in services {
                    if service.uuid == targetServiceUUID {
                        peripheral.discoverCharacteristics([targetCharacteristicUUID], for: service)
                    }
                }
            }
        }
        
        // This function is called when the characteristics of the service are discovered.
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    if characteristic.uuid == targetCharacteristicUUID {
                        // Once you discover the characteristic, you can read/write data to it
                        peripheral.setNotifyValue(true, for: characteristic)
                        // Write data example
                        let data = "Hello, Raspberry Pi!".data(using: .utf8)!
                        peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    }
                }
            }
        }
        
        // This function is called when the peripheral receives a new value for the characteristic data.
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            if let data = characteristic.value {
                let str = String(decoding: data, as: UTF8.self)
                print("Received data: \(str)")
            }
        }
        
        // This function is called when the peripheral writes a new value for the characteristic data.
        func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
            if let error = error {
                print("Failed to write value for characteristic with error: \(error)")
            } else {
                print("Successfully wrote value for characteristic.")
            }
        }
}
