//
//  ParameterStorePathAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ParameterStorePathAddViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var paths: [ParameterStorePath]
    @Published var name = ""
    @Published var path = ""
    @Published var loading = false
    
    init(dataSource: DataSource, paths: [ParameterStorePath]) {
        self.dataSource = dataSource
        self.paths = paths
    }
    
    func add() async -> (success: Bool, errorMessage: String) {
        if !isValid() {
            return (false, "")
        }
        
        if paths.contains(where: { $0.name == name }) {
            return (false, "Already exists a parameter store path with this name.")
        }
        
        dataSource.add(ParameterStorePath(name: name, path: path))
        return (true, "")
    }
    
    func isEmpty() -> Bool {
        return name.isEmpty &&
               path.isEmpty
    }
    
    func isValid() -> Bool {
        return !name.isEmpty &&
               !path.isEmpty
    }
}
