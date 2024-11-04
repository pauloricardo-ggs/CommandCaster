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
    
    func add(completion: @escaping (Bool, String) -> Void) async {
        if !isValid() {
            completion(false, "")
            return
        }
        
        guard let selectedPath = selectedPath else {
            completion(false, "No path selected.")
            return
        }
        
        if initialSelectedPath != selectedPath {
            do {
                parameters = try await dataSource.fetchParameterStoreVariables(for: selectedPath.path)
            } catch {
                completion(false, "Failed to fetch parameters: \(error.localizedDescription)")
            }
        }
        
        guard let parameters = parameters else {
            completion(false, "Error fetching parameters.")
            return
        }
        
        if parameters.contains(where: { $0.name == name }) {
            completion(false, "\(selectedPath.name) already has a variable with this name.")
            return
        }
        
        await dataSource.addParameterStoreVariable(with: name, to: selectedPath.path, and: value)
        completion(true, "")
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
