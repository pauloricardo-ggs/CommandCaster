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
    static var shared = DataSource()
    
    @MainActor
    private init() {
        do {
            self.modelContainer = try ModelContainer(
                for: ParameterStorePath.self,
                configurations: ModelConfiguration(
                    isStoredInMemoryOnly: isPreview
                )
            )
            self.modelContext = modelContainer.mainContext
        } catch {
            fatalError("Unable to initialize CoreData stack: \(error)")
        }
    }
    
    func save() throws {
        try modelContext.save()
    }
}
