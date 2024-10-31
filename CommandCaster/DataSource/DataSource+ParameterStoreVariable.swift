//
//  DataSource+ParameterStoreVariable.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import AWSSSM

extension DataSource {
    
    func fetchParameterStoreVariables(for path: String) async -> [ParameterStoreVariable] {
        var allParameters: [ParameterStoreVariable] = []
        var nextToken: String? = nil
        
        do {
            let client = try await SSMClient()

            repeat {
                let input = GetParametersByPathInput(
                    nextToken: nextToken,
                    path: path,
                    withDecryption: true
                )
                
                let result = try await client.getParametersByPath(input: input)
                
                let mappedParameters = result.parameters?.compactMap { ParameterStoreVariable.from(ssmParameter: $0) } ?? []
                allParameters.append(contentsOf: mappedParameters)
                
                nextToken = result.nextToken
            } while nextToken != nil && !Task.isCancelled
            return allParameters
        } catch {
            fatalError("Error fetching parameter: \(error)")
        }
    }
    
    func addParameterStoreVariable(with name: String, to path: String, and value: String) async {
        do {
            let client = try await SSMClient()
            
            let input = PutParameterInput(
                name: path + name,
                overwrite: false,
                type: .string,
                value: value
            )
            
            _ = try await client.putParameter(input: input)
        } catch {
            fatalError("Error adding parameter store variable: \(error)")
        }
    }
    
    func updateParameterStoreVariableValue(_ parameter: ParameterStoreVariable, to newValue: String) async -> Int {
        do {
            let client = try await SSMClient()
            
            let input = PutParameterInput(
                name: parameter.path,
                overwrite: true,
                value: newValue
            )
            
            let result = try await client.putParameter(input: input)
            return result.version
        } catch {
            fatalError("Error updating parameter store variable: \(error)")
        }
    }
    
    func deleteParameterStoreVariable(withPath path: String) async {
        do {
            let client = try await SSMClient()
            
            let input = DeleteParameterInput(name: path)
            
            _ = try await client.deleteParameter(input: input)
        } catch {
            fatalError("Error deleting parameter store variable: \(error)")
        }
    }
}
