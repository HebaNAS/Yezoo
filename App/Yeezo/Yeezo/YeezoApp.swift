//
//  YeezoApp.swift
//  Yeezo
//
//  Created by Heba El-Shimy on 24/07/2023.
//

import SwiftUI

@main
struct YeezoApp: App {
    
    var body: some Scene {
            WindowGroup {
                TabView {
                    ContentView()
                }
                .font(.headline)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
