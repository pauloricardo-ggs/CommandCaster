//
//  DataSource+ParameterStorePath.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftData
import Foundation

extension DataSource {
    
    func fetchParameterStorePaths() throws -> [ParameterStorePath] {
        let descriptor = FetchDescriptor<ParameterStorePath>()
        return try modelContext.fetch(descriptor)
    }
    
    func add(_ parameterStorePath: ParameterStorePath) throws {
        modelContext.insert(parameterStorePath)
        try save()
    }
    
    func delete(_ parameterStorePath: ParameterStorePath) throws {
        modelContext.delete(parameterStorePath)
        try save()
    }
}
