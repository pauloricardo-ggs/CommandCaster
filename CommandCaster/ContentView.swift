//
//  ContentView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 25/09/2024.
//

import SwiftUICore
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationSplitView {
            Sidebar()
        } content: {
            DefaultContentView()
        } detail: {
            DefaultDetailView()
        }
    }
}

#Preview {
    ContentView()
}

struct DefaultContentView: View {
    var body: some View {
        ContentUnavailableView("Select an element from the sidebar", systemImage: "doc.text.image.fill")
            .toolbar{ Spacer() }
    }
}

struct DefaultDetailView: View {
    var body: some View {
        ContentUnavailableView("Select an element from the list", systemImage: "doc.text.image.fill")
            .toolbar{ Spacer() }
    }
}

struct Sidebar: View {
    @State private var selectedItem: SidebarItem?
    private var groupedItems: [String: [SidebarItem]] = [
        "Parameter Store": [
            SidebarItem(name: "Parameter Store", icon: "lock.icloud", listView: ParameterStoreListView()),
        ],
//        "Project Management": [
//            SidebarItem(name: "Projects", icon: "folder", listView: ProjectsListView()),
//            SidebarItem(name: "Connections", icon: "network", listView: ConnectionsListView()),
//            SidebarItem(name: "Platforms", icon: "server.rack", listView: PlatformsListView())
//        ]
    ]
    
    var body: some View {
        List(selection: $selectedItem) {
            ForEach(Array(groupedItems.keys), id: \.self) { group in
                if let items = groupedItems[group] {
                    Section(header: Text(group)) {
                        ForEach(items) { item in
                            NavigationLink(
                                destination: item.listView,
                                label: { Label(item.name, systemImage: item.icon) }
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle("Sidebar")
    }
}

struct SidebarItem: Identifiable, Hashable {
    var id: String
    var name: String
    var icon: String
    var listView: AnyView
    
    init(name: String, icon: String, listView: some View) {
        self.id = UUID().uuidString
        self.name = name
        self.icon = icon
        self.listView = AnyView(listView)
    }
    
    static func == (lhs: SidebarItem, rhs: SidebarItem) -> Bool {
        lhs.id == rhs.id
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
