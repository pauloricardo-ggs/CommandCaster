//
//  ParameterStorePathEditViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation

@MainActor
class ParameterStorePathEditViewModel: ObservableObject {

    private let dataSource = DataSource.shared
    private let errorContext = ErrorContext.shared
    
    @Published var newName: String
    @Published var newPath: String
    @Published var selectedPath: ParameterStorePath
    @Published var paths: [ParameterStorePath]
    
    init(selectedPath: ParameterStorePath, paths: [ParameterStorePath]) {
        self.selectedPath = selectedPath
        newName = selectedPath.name
        newPath = selectedPath.path
        self.paths = paths
    }
    
    func save() {
        if !isValid() {
            return
        }
        
        if paths.contains(where: { $0.name == newName }) {
            errorContext.set(.duplicatedPath)
            return
        }
        
        selectedPath.update(name: newName, path: newPath)
    }
    
    func changed() -> Bool {
        return newName != selectedPath.name || newPath != selectedPath.path
    }
    
    func isValid() -> Bool {
        return !newName.isEmpty &&
        !newPath.isEmpty &&
        changed()
    }
}
