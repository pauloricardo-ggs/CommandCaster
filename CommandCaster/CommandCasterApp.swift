//
//  CommandCasterApp.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUI
import SwiftData

@main
struct CommandCasterApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
