//
//  ConnectionDetailViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ConnectionDetailViewModel: ObservableObject {
    
    private let dataSource: DataSource
    
    @Published var name: String = ""
    @Published var host: String = ""
    @Published var port: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var newDatabaseName: String = ""
    @Published var databases: [(id: String, name: String)] = []
    @Published var databaseNameErrorMessage = ""
    
    @Published var connection: Connection
    
    init(dataSource: DataSource, connection: Connection) {
        self.dataSource = dataSource
        self.connection = connection
    }
    
    func loadData() {
        name = ""
        host = connection.host
        port = connection.port
        username = connection.username
        password = connection.password
        databases.removeAll()
        connection.databases.forEach() { database in
            databases.append((id: database.id, name: database.name))
        }
    }
    
    func save() {
        if (!name.isEmpty) { connection.update(name: name) }
        if (!host.isEmpty) { connection.update(host: host) }
        if (!port.isEmpty) { connection.update(port: port) }
        if (!username.isEmpty) { connection.update(username: username) }
        if (!password.isEmpty) { connection.update(password: password) }
        
        let editedDatabasesIds = Set(databases.map { $0.id })
        connection.databases.removeAll { !editedDatabasesIds.contains($0.id) }
        
        let connectionDatabasesIds = Set(connection.databases.map { $0.id })
        let databasesToAdd = databases.filter { !connectionDatabasesIds.contains($0.id) }
        for databaseToAdd in databasesToAdd {
            connection.databases.append(Database(id: databaseToAdd.id, name: databaseToAdd.name, connection: connection))
        }
    }
    
    func delete() {
        dataSource.delete(connection)
    }
    
    func addDatabase() {
        if !databaseNameIsValid() { return }
        
        databases.append((id: UUID().uuidString, name: newDatabaseName))
        newDatabaseName = ""
    }
    
    func removeDatabase(id: String) {
        if databases.count == 1 {
            databaseNameErrorMessage = "There must be at least one database."
            return
        }
        databases.removeAll(where: { $0.id == id })
    }
    
    func isValid() -> Bool {
        return !host.isEmpty &&
               !port.isEmpty &&
               !username.isEmpty &&
               !password.isEmpty &&
               databases.count > 0
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
