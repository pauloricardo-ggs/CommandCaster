//
//  DataSource+Platform.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftData
import Foundation

extension DataSource {
    
    func fetchPlatforms() -> [Platform] {
        do {
            let descriptor = FetchDescriptor<Platform>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(_ platform: Platform) {
        modelContext.insert(platform)
        save()
    }
    
    func delete(_ platform: Platform) {
        modelContext.delete(platform)
        save()
    }
}
