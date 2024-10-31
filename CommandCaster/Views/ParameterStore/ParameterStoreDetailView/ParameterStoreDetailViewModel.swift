//
//  ParameterStoreDetailViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ParameterStoreDetailViewModel: ObservableObject {
    
    private let dataSource: DataSource
    
    @Published var value: String = ""
    @Published var loading = false
    
    var parameter: ParameterStoreVariable
    
    init(dataSource: DataSource, parameter: ParameterStoreVariable) {
        self.dataSource = dataSource
        self.parameter = parameter
        loadData()
    }
    
    func loadData() {
        value = parameter.value
    }
    
    func updateValue() async -> (success: Bool, errorMessage: String) {
        if !isValid() {
            return (false, "")
        }
                
        let newVersion = await dataSource.updateParameterStoreVariableValue(parameter, to: value)
        parameter.version = String(newVersion)
        return (true, "")
    }
    
    func deleteParameter() async {
        await dataSource.deleteParameterStoreVariable(withPath: parameter.path)
    }
    
    func isValid() -> Bool {
        return !value.isEmpty
    }
}
