//
//  DataSource+ParameterStoreVariable.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import AWSSSM
import AWSClientRuntime

extension DataSource {
    
    func fetchParameterStoreVariables(for path: String, nextToken: String? = nil) async throws -> (variables: [ParameterStoreVariable], nextToken: String?) {
        let client = try await SSMClient()
        let input = GetParametersByPathInput(nextToken: nextToken, path: path, withDecryption: true)
        let result = try await client.getParametersByPath(input: input)
        let mapped = result.parameters?.compactMap { ParameterStoreVariable.from(ssmParameter: $0) } ?? []
        return (mapped, result.nextToken)
    }
    
    func addParameterStoreVariable(with name: String, to path: String, and value: String) async throws {
        let client = try await SSMClient()
        let input = PutParameterInput(name: path + name, overwrite: false, type: .string, value: value)
        _ = try await client.putParameter(input: input)
    }
    
    func updateParameterStoreVariableValue(_ parameter: ParameterStoreVariable, to newValue: String) async throws -> Int {
        let client = try await SSMClient()
        let input = PutParameterInput(name: parameter.path, overwrite: true, value: newValue)
        let result = try await client.putParameter(input: input)
        return result.version
    }
    
    func deleteParameterStoreVariable(withPath path: String) async throws {
        let client = try await SSMClient()
        let input = DeleteParameterInput(name: path)
        _ = try await client.deleteParameter(input: input)
    }
}
