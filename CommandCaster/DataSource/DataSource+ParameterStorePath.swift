//
//  DataSource+ParameterStorePath.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftData
import Foundation

extension DataSource {
    
    func fetchParameterStorePaths() -> [ParameterStorePath] {
        do {
            let descriptor = FetchDescriptor<ParameterStorePath>()
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func add(_ parameterStorePath: ParameterStorePath) {
        modelContext.insert(parameterStorePath)
        save()
    }
    
    func delete(_ parameterStorePath: ParameterStorePath) {
        modelContext.delete(parameterStorePath)
        save()
    }
}
