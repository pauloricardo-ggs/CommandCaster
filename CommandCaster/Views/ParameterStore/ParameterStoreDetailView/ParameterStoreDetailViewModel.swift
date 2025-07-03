//
//  ParameterStoreDetailViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation

@MainActor
class ParameterStoreDetailViewModel: ObservableObject {
    
    private let dataSource = DataSource.shared
    private let errorContext = ErrorContext.shared
    
    @Published var value: String = ""
    @Published var loading = false
    
    var variable: ParameterStoreVariable
    
    var isValid: Bool {
        return !value.isEmpty
    }
    
    init(variable: ParameterStoreVariable) {
        self.variable = variable
        loadData()
    }
    
    func loadData() {
        value = variable.value
    }
    
    func updateVariableValue() async {
        loading = true
        defer { loading = false }
        
        guard isValid else { return }
        
        do {
            let newVersion = try await dataSource.updateParameterStoreVariableValue(variable, to: value)
            variable.version = String(newVersion)
        } catch {
            errorContext.set(.failedToUpdateVariable)
        }
    }
    
    func deleteVariable() async {
        loading = true
        defer { loading = false }
        
        do {
            try await dataSource.deleteParameterStoreVariable(withPath: variable.path)
        } catch {
            errorContext.set(.failedToDeleteVariable)
        }
    }
}
