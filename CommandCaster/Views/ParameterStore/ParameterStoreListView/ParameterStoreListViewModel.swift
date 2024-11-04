//
//  ParameterStoreListViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

@MainActor
class ParameterStoreListViewModel: ObservableObject {

    private let dataSource: DataSource
    private var task: Task<Void, Never>?
    
    @Published var paths: [ParameterStorePath]
    @Published var selectedPath: ParameterStorePath?
    @Published var loading = false
    @Published var searchText: String = ""
    @Published var parameters: [ParameterStoreVariable]
    @Published var filteredParameters: [ParameterStoreVariable]
    
    @State var selectedParameter: ParameterStoreVariable?
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.paths = []
        self.parameters = []
        self.filteredParameters = []
    }
    
    func fetchPaths() {
        paths = dataSource.fetchParameterStorePaths()
    }
    
    func fetchParameters(for path: ParameterStorePath?, completion: @escaping (Bool, String) -> Void) {
        guard let path = path else {
            completion(false, "No path selected.")
            return
        }
        
        cancelFetch()
        selectedPath = path
        loading = true
        task = Task {
            do {
                let unorderedParameters = try await dataSource.fetchParameterStoreVariables(for: path.path)
                guard !Task.isCancelled else { return }
                self.parameters = unorderedParameters.sorted { $0.name < $1.name }
                filterParameters()
                loading = false
                completion(true, "")
            } catch {
                loading = false
                completion(false, "Failed to fetch parameters: \(error.localizedDescription)")
            }
        }
    }
    
    func filterParameters() {
        if searchText.isEmpty {
            filteredParameters = parameters
            return
        }
        
        filteredParameters = parameters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func cancelFetch() {
        task?.cancel()
    }
    
    func delete(_ path: ParameterStorePath) {
        dataSource.delete(path)
    }
    
    func delete(_ parameter: ParameterStoreVariable) {
        parameters.removeAll(where: { $0.id == parameter.id })
    }
}
