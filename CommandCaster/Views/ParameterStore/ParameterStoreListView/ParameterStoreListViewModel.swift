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

    private let errorContext = ErrorContext.shared
    private let dataSource = DataSource.shared
    
    private var task: Task<Void, Never>?
    
    @Published var paths: [ParameterStorePath] = []
    @Published var variables: [ParameterStoreVariable] = []
    @Published var filteredVariables: [ParameterStoreVariable] = []
    @Published var selectedPath: ParameterStorePath?
    @Published var loading = false
    @Published var searchText: String = ""
    
    @State var selectedParameter: ParameterStoreVariable?
    
    func fetchPaths() {
        do {
            paths = try dataSource.fetchParameterStorePaths()
        } catch {
            errorContext.set(.failedToFetchPaths)
        }
    }
    
    func fetchVariables(for path: ParameterStorePath?) {
        guard let path = path else {
            errorContext.set(.noPathSelected)
            return
        }
        
        cancelFetch()
        selectedPath = path
        variables = []
        loading = true
        
        task = Task {
            var nextToken: String? = nil
            do {
                repeat {
                    let result = try await dataSource.fetchParameterStoreVariables(for: path.path, nextToken: nextToken)
                    guard !Task.isCancelled else { return }
                    variables.append(contentsOf: result.variables)
                    variables.sort { $0.name < $1.name }
                    filterVariables()
                    nextToken = result.nextToken
                } while nextToken != nil
            } catch {
                errorContext.set(.failedToFetchVariables)
            }
            loading = false
        }
    }
    
    func filterVariables() {
        if searchText.isEmpty {
            filteredVariables = variables
            return
        }
        
        filteredVariables = variables.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func cancelFetch() {
        task?.cancel()
    }
    
    func delete(_ path: ParameterStorePath) {
        do {
            try dataSource.delete(path)
        } catch {
            errorContext.set(.failedToDeleteVariable)
        }
    }
    
    func delete(_ variable: ParameterStoreVariable) {
        filteredVariables.removeAll(where: { $0.id == variable.id })
    }
}
