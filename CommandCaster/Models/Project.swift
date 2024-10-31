//
//  Project.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftData
import Foundation

@Model
class Project: Identifiable {
    @Attribute var id: String
    var name: String
    @Relationship var connections: [Connection]
    @Relationship var platforms: [Platform]
    @Relationship var compose: Compose?
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.connections = []
        self.platforms = []
        self.compose = nil
    }
    
    init(name: String, connections: [Connection], platforms: [Platform], compose: Compose?) {
        self.id = UUID().uuidString
        self.name = name
        self.connections = connections
        self.platforms = platforms
        self.compose = compose
    }
}
