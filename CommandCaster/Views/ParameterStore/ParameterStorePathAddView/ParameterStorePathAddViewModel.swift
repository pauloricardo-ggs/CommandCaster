//
//  ParameterStorePathAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation

@MainActor
class ParameterStorePathAddViewModel: ObservableObject {

    private let dataSource = DataSource.shared
    private let errorContext = ErrorContext.shared
    
    @Published var paths: [ParameterStorePath]
    @Published var name = ""
    @Published var path = ""
    @Published var loading = false
    
    init(paths: [ParameterStorePath]) {
        self.paths = paths
    }
    
    func add() async {
        if !isValid() {
            return
        }
        
        if paths.contains(where: { $0.name == name }) {
            errorContext.set(.duplicatedPath)
            return
        }
        
        do {
            try dataSource.add(ParameterStorePath(name: name, path: path))
        } catch {
            errorContext.set(.failedToAddPath)
        }
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
