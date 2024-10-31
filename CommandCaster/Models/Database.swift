//
//  Database.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Database: Identifiable {
    @Attribute var id: String
    var name: String
    @Relationship var connection: Connection
    
    init(id: String = UUID().uuidString, name: String, connection: Connection) {
        self.id = id
        self.name = name
        self.connection = connection
    }
}
