//
//  ParameterStorePath.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 28/10/2024.
//

import Foundation
import SwiftData

@Model
class ParameterStorePath: Identifiable {
    @Attribute var id: String
    var name: String
    var path: String
    
    init(name: String, path: String) {
        self.id = UUID().uuidString
        self.name = name
        self.path = path
    }
    
    func update(name: String? = nil, path: String? = nil) {
        if let name = name { self.name = name }
        if let path = path { self.path = path }
    }
}

extension ParameterStorePath: Comparable {
    static func < (lhs: ParameterStorePath, rhs: ParameterStorePath) -> Bool {
        lhs.name < rhs.name
    }
}
