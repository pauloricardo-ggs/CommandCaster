//
//  ConnectionsListViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ConnectionsListViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var connections: [Connection]
    
    @State var selectedConnection: Connection?
        
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.connections = []
    }

    func fetchConnections() {
        connections = dataSource.fetchConnections()
    }
    
    func addPreviewConnection() {
        dataSource.add(Connection.sample)
        fetchConnections()
    }
}
