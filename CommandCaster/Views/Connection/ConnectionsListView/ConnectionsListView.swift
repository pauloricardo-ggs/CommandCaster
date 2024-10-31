//
//  ConnectionsListView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUI

struct ConnectionsListView: View {
    
    @ObservedObject var viewModel = ConnectionsListViewModel(dataSource: .shared)
    
    @State private var showAddConnection = false
    
    var body: some View {
        List(viewModel.connections, selection: $viewModel.selectedConnection) { connection in
            NavigationLink(
                destination: ConnectionDetailView(for: connection),
                label: { ConnectionCell(connection) }
            )
        }
        .navigationTitle("Connections")
        .navigationSubtitle("\(viewModel.connections.count)")
        .toolbar { Toolbar }
        .onAppear() {
            viewModel.fetchConnections()
        }
        .sheet(isPresented: $showAddConnection) {
            ConnectionAddView()
                .onDisappear() {
                    viewModel.fetchConnections()
                }
        }
    }
    
    @ToolbarContentBuilder
    var Toolbar: some ToolbarContent {
        ToolbarItemGroup(content: {
            Button(action: {
            }) {
                Image(systemName: "arrow.up.arrow.down")
                Image( systemName: "chevron.down")
                    .imageScale(.small)
            }
            
            Button(action: {
                if isPreview {
                    viewModel.addPreviewConnection()
                    return
                }
                showAddConnection = true
            }) {
                Image(systemName: "plus")
            }
        })
    }
    
    @ViewBuilder
    func ConnectionCell(_ connection: Connection) -> some View {
        VStack(alignment: .leading) {
            Text(connection.name)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
            Text("\(connection.host):\(connection.port)")
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.vertical, 5)
    }
}
