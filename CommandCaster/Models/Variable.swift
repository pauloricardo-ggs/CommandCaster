//
//  Variable.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Variable: Identifiable {
    @Attribute var id: String
    var name: String
    var value: String
    private var typeRaw: String
    @Relationship var compose: Compose
    
    var type: VariableType {
        get { VariableType(rawValue: typeRaw) ?? .custom }
        set { typeRaw = newValue.rawValue }
    }
    
    init(name: String, value: String, type: VariableType, compose: Compose) {
        self.id = UUID().uuidString
        self.name = name
        self.value = value
        self.typeRaw = type.rawValue
        self.compose = compose
    }
    
    init(name: String, value: String, type: VariableType) {
        self.id = UUID().uuidString
        self.name = name
        self.value = value
        self.typeRaw = type.rawValue
        self.compose = Compose()
    }
}
