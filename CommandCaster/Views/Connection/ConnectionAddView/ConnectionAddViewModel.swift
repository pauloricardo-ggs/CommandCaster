//
//  ConnectionAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ConnectionAddViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var name: String = ""
    @Published var host: String = ""
    @Published var port: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var databases: [(id: UUID, name: String)] = []
    @Published var newDatabaseName = ""
    @Published var databaseNameErrorMessage = ""
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func save() -> Bool {
        if !isValid() { return false }
        
        let newConnection = Connection(name: name, host: host, port: port, username: username, password: password)
        for database in databases {
            newConnection.addDatabase(Database(name: database.name, connection: newConnection))            
        }
        
        dataSource.add(newConnection)
        return true
    }
    
    func addDatabase() {
        if !databaseNameIsValid() { return }
        
        databases.insert((id: UUID(), name: newDatabaseName), at: 0)
        newDatabaseName = ""
    }
    
    func removeDatabase(id: UUID) {
        databases.removeAll(where: { $0.id == id })
    }
    
    func isEmpty() -> Bool {
        return name.isEmpty &&
               host.isEmpty &&
               port.isEmpty &&
               username.isEmpty &&
               password.isEmpty &&
               databases.isEmpty
    }
    
    func isValid() -> Bool {
        return !name.isEmpty &&
               !host.isEmpty &&
               !port.isEmpty &&
               !username.isEmpty &&
               !password.isEmpty &&
               !databases.isEmpty
    }
    
    private func databaseNameIsValid() -> Bool {
        let databaseNameAlreadyExists = databases.contains(where: { $0.name == newDatabaseName })
        
        if (databaseNameAlreadyExists) {
            databaseNameErrorMessage = "Database name already exists"
            return false
        }
        
        databaseNameErrorMessage = ""
        return true
    }
}
