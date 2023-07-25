//
//  ContentView.swift
//  Yeezo
//
//  Created by Heba El-Shimy on 24/07/2023.
//

import SwiftUI
import SwiftUIJoystick

struct ContentView: View {
    @StateObject var bluetoothManager = BluetoothManager()
    @StateObject private var monitor = JoystickMonitor()
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                                if !self.bluetoothManager.isConnected {
                                    if self.bluetoothManager.isSwitchedOn {
                                        self.bluetoothManager.centralManager.scanForPeripherals(withServices: [self.bluetoothManager.targetPeripheralUUID])
                                    } else {
                                        print("Bluetooth is not switched on.")
                                    }
                                }
                            }) {
                                Text("Connect")
                                    .frame(minWidth: 60, maxWidth: 80)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(40)
                                    .padding(.horizontal, 20)
                            }
                            .foregroundColor(.white)
                            .background(self.bluetoothManager.isConnected ? Color.gray : Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 10)
                            .buttonStyle(PlainButtonStyle())
                            .disabled(self.bluetoothManager.isConnected)

                Text("Sending command \(monitor.xyPoint.x.formattedString) to car")
                    .padding(.bottom, 30.0)
                    .padding(.top, 10)
                    .fixedSize()
                    .foregroundColor(.white)
                
                JoystickBuilder(
                    monitor: monitor,
                    width: 130,
                    shape: .rect,
                    background: {
                        ZStack {
                            Circle()
                                .fill(Color(hue: 1.0, saturation: 0.03, brightness: 0.268))
                                .overlay(Circle().stroke(Color(hue: 1.0, saturation: 0.004, brightness: 0.271))
                                    .shadow(color: Color.black, radius: 5))
                            
                        }
                    },
                    foreground: {
                        Circle()
                            .fill(RadialGradient(colors: [.black, .gray], center: .center, startRadius: 1, endRadius: 80))
                            .frame(width: 80, height: 80)
                            .shadow(color: .gray, radius: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 8)
                                    .blur(radius: 10)
                                    .offset(x: 2, y: 2)
                                    .shadow(color: Color.black, radius: 40)
                                    .frame(width: 10.0, height: 10.0)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .blur(radius: 4)
                                    .offset(x: 0, y: 0)
                                    .shadow(color: Color.white, radius: 10)
                                    .blur(radius: 2)
                                    .foregroundColor(.black)
                                    .frame(width: 40, height: 40)
                            )
                    },
                    locksInPlace: false)
            }
            .padding(.top, 80.0)

            GeometryReader {geometry in
                VStack {
                        Text("Yeezo")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width - 25)
                            .padding()
                            .background(Color(hue: 0.593, saturation: 0.197, brightness: 0.118))
                            .foregroundColor(.white)
                            .shadow(color: Color(hue: 1.0, saturation: 0.019, brightness: 0.275), radius: 10.0, x: 0.0, y: 0.0)
                    }
                }
            }
        .background(
            Image("background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

public extension CGFloat {
    var formattedString: String {
        String(format: "%.2f", self)
    }
}
