//
//  DataSource+Project.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftData
import Foundation

extension DataSource {
    
    func fetchProjects() -> [Project] {
        do {
            let descriptor = FetchDescriptor<Project>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(_ project: Project) {
        modelContext.insert(project)
        save()
    }
}
