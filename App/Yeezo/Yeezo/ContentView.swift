//
//  ContentView.swift
//  Yeezo
//
//  Created by Heba El-Shimy on 24/07/2023.
//

import Starscream
import SwiftUI
import SwiftUIJoystick

struct OctagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let sides = 8
        var path = Path()
        let theta = (2.0 * .pi) / Double(sides) // how much to turn at every corner
        let offset = CGFloat.pi / 8.0 // offset our angle to start the first point in the right place
        let width = Double(min(rect.size.width, rect.size.height)) // width of the square

        for i in 0..<sides {
            let angle = Double(i) * theta - Double(offset)
            let segmentLength = width / 2.0
            let x = CGFloat(width / 2.0 + segmentLength * cos(angle))
            let y = CGFloat(width / 2.0 + segmentLength * sin(angle))

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y)) // move to the first point
            } else {
                path.addLine(to: CGPoint(x: x, y: y)) // draw a line to the next vertex
            }
        }
        path.closeSubpath()
        return path
    }
}

class WebSocketManager: ObservableObject {
    var socket: WebSocket!

    @Published var isConnected: Bool = false
    @Published var receivedText: String = ""
    @Published var lastSentCommand: String = "Stop"
    var currentDirection: String?

    init() {
        let request = URLRequest(url: URL(string: "ws://192.168.70.174:8765")!)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    func sendMessage(message: String) {
        socket.write(string: message)
    }
    
    func sendControlCommand(point: CGPoint) {
        var command = "s"
        var fullCommand = "Stop"
        
        if point.y >= 20 && point.x >= -100 && point.x <= 100 {
            command = "f"
        } else if point >= 130 && point < 200 {
            command = "l"
        } else if point >= 200 && point <= 360 {
            command = "b"
        } else if point > 0 && point < 70 {
            command = "r"
        } else {
            command = "s"
        }
        
        // Only send the message if the direction has changed
        if command != currentDirection {
            socket.write(string: command)
            currentDirection = command
            
            if command == "f" {
                fullCommand = "Forward"
            } else if command == "r" {
                fullCommand = "Right"
            } else if command == "b" {
                fullCommand = "Backward"
            } else if command == "l" {
                fullCommand = "Left"
            } else if command == "s" {
                fullCommand = "Stop"
            }
            
            self.lastSentCommand = fullCommand
        }
    }
    
    func sendStopCommand() {
        socket.write(string: "s")
        self.lastSentCommand = "Stop"
    }
}

extension WebSocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("WebSocket is connected: \(headers)")
            DispatchQueue.main.async {
                self.isConnected = true
            }
        case .disconnected(let reason, let code):
            print("WebSocket is disconnected: \(reason) with code: \(code)")
            DispatchQueue.main.async {
                self.isConnected = false
            }
        case .text(let string):
            print("Received text: \(string)")
            DispatchQueue.main.async {
                self.receivedText = string
            }
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("WebSocket was cancelled")
        case .error(let error):
            if let error = error {
                print("WebSocket error occurred: \(error)")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var webSocketManager = WebSocketManager()
    @StateObject private var monitor = JoystickMonitor()
    
    var body: some View {
        ZStack {
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
        
            HStack {
                VStack {
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
                    .onChange(of: monitor.xyPoint) { newPoint in
                        webSocketManager.sendControlCommand(degrees: newPoint)
                    }
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        webSocketManager.socket.connect()
                    }) {
                        Text(webSocketManager.isConnected ? "Connected" : "Reconnect")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(.lightGray))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .disabled(webSocketManager.isConnected)
                    
                    Text("Sending command \(webSocketManager.lastSentCommand), \(monitor.xyPoint.x.formattedString), \(monitor.xyPoint.y.formattedString) to car")
                        .padding(.bottom, 30.0)
                        .padding(.top, 10)
                        .fixedSize()
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        webSocketManager.sendStopCommand()
                    }) {
                        Text("Stop")
                            .frame(width: 130, height: 130)
                            .background(OctagonShape().fill(Color.red))
                            .foregroundColor(.white)
                            .cornerRadius(65)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 100)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                webSocketManager.socket.disconnect()
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
