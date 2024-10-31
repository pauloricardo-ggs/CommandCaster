//
//  DataSource+Connection.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftData
import Foundation

extension DataSource {
    
    func fetchConnections() -> [Connection] {
        do {
            let descriptor = FetchDescriptor<Connection>(sortBy: [SortDescriptor(\.name)])
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(_ connection: Connection) {
        modelContext.insert(connection)
        save()
    }
    
    func delete(_ connection: Connection) {
        modelContext.delete(connection)
        save()
    }
}
