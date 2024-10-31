//
//  Service.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Service: Identifiable {
    @Attribute var id: String
    var name: String
    var value: String
    @Relationship var compose: Compose
    
    init(name: String, value: String, compose: Compose) {
        self.id = UUID().uuidString
        self.name = name
        self.value = value
        self.compose = compose
    }
    
    init(name: String, value: String) {
        self.id = UUID().uuidString
        self.name = name
        self.value = value
        self.compose = Compose()
    }
}
