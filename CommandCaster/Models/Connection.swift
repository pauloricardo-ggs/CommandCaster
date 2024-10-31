//
//  Connection.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Connection: Nameable, Identifiable {
    @Attribute var id: String
    var name: String
    var host: String
    var port: String
    var username: String
    var password: String
    var lastModifiedDate: Date
    var lastModifiedDescription: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self.lastModifiedDate) { return "Today" }
        if calendar.isDateInYesterday(self.lastModifiedDate) { return "Yesterday" }
        return "\(self.lastModifiedDate.formatted(date: .numeric, time: .omitted))"
    }
    @Relationship var databases: [Database]
    
    init(name: String, host: String, port: String, username: String, password: String, lastModifiedDate: Date = .now) {
        self.id = UUID().uuidString
        self.databases = []
        self.name = name
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.lastModifiedDate = lastModifiedDate
    }
    
    func addDatabase(_ database: Database) {
        databases.append(database)
    }
    
    func addDatabases(_ databases: [Database]) {
        for database in databases {
            self.databases.append(database)
        }
    }
    
    func update(name: String) {
        self.name = name
        updateLastModifiedDate()
    }
    
    func update(host: String) {
        self.host = host
        updateLastModifiedDate()
    }
    
    func update(port: String) {
        self.port = port
        updateLastModifiedDate()
    }
    
    func update(username: String) {
        self.username = username
        updateLastModifiedDate()
    }
    
    func update(password: String) {
        self.password = password
        updateLastModifiedDate()
    }

    private func updateLastModifiedDate(_ newDate: Date = .now)
    {
        self.lastModifiedDate = newDate
    }
}
