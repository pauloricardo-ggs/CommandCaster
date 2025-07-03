//
//  ParameterStoreAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import Foundation
import SwiftData
import SwiftUICore
import AWSSSM

@MainActor
class ParameterStoreAddViewModel: ObservableObject {

    private let dataSource = DataSource.shared
    private let errorContext = ErrorContext.shared
    
    @Published var paths: [ParameterStorePath]
    @Published var selectedPath: ParameterStorePath?
    @Published var loading = false

    @Published var variables: [ParameterStoreVariableInput] = [ParameterStoreVariableInput()]
    
    private var initialSelectedPath: ParameterStorePath?
    private var parameters: [ParameterStoreVariable]?
    
    init(paths: [ParameterStorePath], selectedPath: ParameterStorePath?, parameters: [ParameterStoreVariable]?) {
        self.paths = paths
        self.selectedPath = selectedPath
        self.parameters = parameters
        self.initialSelectedPath = selectedPath
    }
    
    func addAll() async {
        guard let selectedPath = selectedPath else {
            errorContext.set(.noPathSelected)
            return
        }

        let filteredVariables = variables.filter { !$0.name.isEmpty && !$0.value.isEmpty }

        if filteredVariables.isEmpty {
            errorContext.set(.noValidVariable)
            return
        }

        let names = filteredVariables.map { $0.name }
        let duplicates = Set(names.filter { name in names.filter { $0 == name }.count > 1 })

        if !duplicates.isEmpty {
            errorContext.set(.duplicatedVariable)
            return
        }

        var errorMessages: [(name: String, message: String)] = []

        for variable in filteredVariables {
            do {
                try await dataSource.addParameterStoreVariable(with: variable.name, to: selectedPath.path, and: variable.value)
            } catch _ as ParameterAlreadyExists {
                let message = "The parameter already exists."
                errorMessages.append((name: variable.name, message: message))
            } catch {
                errorMessages.append((name: variable.name, message: error.localizedDescription))
            }
        }

        if !errorMessages.isEmpty {
            let grouped = Dictionary(grouping: errorMessages, by: { $0.message })
            let message = grouped.map { (message, entries) in
                let names = entries.map { $0.name }.joined(separator: "\n")
                return "• \(message)\n\(names)"
            }.joined(separator: "\n\n")

            let failedNames = Set(errorMessages.map { $0.name })
            variables = variables.filter { failedNames.contains($0.name) }
            errorContext.set(.withMessage("Some variables could not be added:\n\n\(message)"))
        }
    }
    
    func isEmpty() -> Bool {
        return variables.allSatisfy { $0.name.isEmpty && $0.value.isEmpty }
    }
    
    func isValid() -> Bool {
        return variables.contains { !$0.name.isEmpty && !$0.value.isEmpty } && selectedPath != nil
    }
}
