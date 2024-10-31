//
//  VariableType.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

enum VariableType: String, CaseIterable {
    case custom,
         connectionHost,
         connectionPort,
         connectionUsername,
         connectionPassword,
         connectionDatabase
    
    var displayName: String {
        switch self {
        case .custom:
            return "Custom"
        case .connectionHost:
            return "Connection Host"
        case .connectionPort:
            return "Connection Port"
        case .connectionUsername:
            return "Connection Username"
        case .connectionPassword:
            return "Connection Password"
        case .connectionDatabase:
            return "Connection Database"
        }
    }
}
