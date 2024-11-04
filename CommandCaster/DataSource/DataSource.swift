//
//  DataSource.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 28/09/2024.
//

import SwiftData
import Foundation

final class DataSource {
    
    private let modelContainer: ModelContainer
    let modelContext: ModelContext
    
    @MainActor
    static let shared = DataSource()
    
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(
                for: Compose.self,
                Connection.self,
                Database.self,
                Platform.self,
                Project.self,
                Service.self,
                Variable.self,
                ParameterStorePath.self,
                configurations: ModelConfiguration(
                    isStoredInMemoryOnly: isPreview
                )
            )
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Failed to load model container: \(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}


