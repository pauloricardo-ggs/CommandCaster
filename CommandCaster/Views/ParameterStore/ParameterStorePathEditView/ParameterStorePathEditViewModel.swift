//
//  ParameterStorePathEditViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ParameterStorePathEditViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var newName: String
    @Published var newPath: String
    @Published var selectedPath: ParameterStorePath
    @Published var paths: [ParameterStorePath]
    
    init(dataSource: DataSource, selectedPath: ParameterStorePath, paths: [ParameterStorePath]) {
        self.dataSource = dataSource
        self.selectedPath = selectedPath
        newName = selectedPath.name
        newPath = selectedPath.path
        self.paths = paths
    }
    
    func save() -> (success: Bool, errorMessage: String) {
        if !isValid() {
            return (false, "")
        }
        
        if paths.contains(where: { $0.name == newName }) {
            return (false, "Already exists a parameter store path with this name.")
        }
        
        selectedPath.update(name: newName, path: newPath)
        return (true, "")
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
