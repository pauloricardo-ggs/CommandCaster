//
//  DataSource+Database.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension DataSource {
    
    func delete(database: Database) {
        modelContext.delete(database)
        save()
    }
}
