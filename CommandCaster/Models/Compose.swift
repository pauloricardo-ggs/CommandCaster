//
//  Compose.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Compose: Identifiable {
    @Attribute var id: String
    var filePath: String
    @Relationship var services: [Service]
    @Relationship var variables: [Variable]
    @Relationship var project: Project
    
    init()
    {
        self.id = UUID().uuidString
        filePath = ""
        services = []
        variables = []
        project = Project()
    }
    
    init(filePath: String, services: [Service], variables: [Variable], project: Project) {
        self.id = UUID().uuidString
        self.filePath = filePath
        self.services = services
        self.variables = variables
        self.project = project
    }
}
