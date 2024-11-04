//
//  Database+Samples.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension Database {
    static func samples(for connection: Connection) -> [Database] {
        [
            Database(name: "AMD", connection: connection),
            Database(name: "ARM", connection: connection)
        ]
    }
}
