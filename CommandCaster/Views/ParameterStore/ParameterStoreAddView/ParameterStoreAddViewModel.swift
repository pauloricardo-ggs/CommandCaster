//
//  ParameterStoreAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ParameterStoreAddViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var name: String = ""
    @Published var value: String = ""
    @Published var paths: [ParameterStorePath]
    @Published var selectedPath: ParameterStorePath?
    @Published var loading = false
    
    private var initialSelectedPath: ParameterStorePath?
    private var parameters: [ParameterStoreVariable]?
    
    init(dataSource: DataSource, paths: [ParameterStorePath], selectedPath: ParameterStorePath?, parameters: [ParameterStoreVariable]?) {
        self.dataSource = dataSource
        self.paths = paths
        self.selectedPath = selectedPath
        self.parameters = parameters
        self.initialSelectedPath = selectedPath
    }
    
    func add() async -> (success: Bool, errorMessage: String) {
        if !isValid() {
            return (false, "")
        }
        
        guard let selectedPath = selectedPath else { return (false, "No path selected.") }
        
        if initialSelectedPath != selectedPath {
            parameters = await dataSource.fetchParameterStoreVariables(for: selectedPath.path)
        }
        
        guard let parameters = parameters else { return (false, "Error fetching parameters.") }
        
        if parameters.contains(where: { $0.name == name }) {
            return (false, "\(selectedPath.name) already has a variable with this name.")
        }
        
        await dataSource.addParameterStoreVariable(with: name, to: selectedPath.path, and: value)
        return (true, "")
    }
    
    func isEmpty() -> Bool {
        return name.isEmpty &&
               value.isEmpty
    }
    
    func isValid() -> Bool {
        return !name.isEmpty &&
               !value.isEmpty &&
               selectedPath != nil
    }
}
