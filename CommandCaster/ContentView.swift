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
            ContentUnavailableView("Select an element from the sidebar", systemImage: "doc.text.image.fill")
                .toolbar { Spacer() }
        } detail: {
            ContentUnavailableView("Select an element from the list", systemImage: "doc.text.image.fill")
                .toolbar { Spacer() }
        }
    }
}

struct Sidebar: View {
    @State private var selectedItem: SidebarItem?
    @State private var hasUpdate = false
    @State private var latestVersion: String?
    @State private var downloadURL: URL?
    
    private let skipVersionKey = "skippedVersion"
    
    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private var groupedItems: [String: [SidebarItem]] = [
        "Parameter Store": [
            SidebarItem(name: "Parameter Store", icon: "lock.icloud", listView: ParameterStoreListView()),
        ]
    ]
    
    var body: some View {
        VStack {
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
            
            if (hasUpdate) { newUpdateCard }
        }
        .navigationTitle("Sidebar")
        .onAppear {
            Task {
                await checkForUpdates()
            }
        }
    }
    
    @ViewBuilder
    private var newUpdateCard: some View {
        VStack(spacing: 0) {
            
            Text("New Version Available (\(latestVersion ?? ""))")
                .font(.caption2)
            
            Text("Would you like to update?")
                .font(.caption)
            
            HStack {
                Button {
                    withAnimation {
                        hasUpdate = false
                    }
                } label: {
                    Text("Not Now")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
                
                Button {
                    if let version = latestVersion {
                        UserDefaults.standard.set(version, forKey: skipVersionKey)
                    }
                    withAnimation {
                        hasUpdate = false
                    }
                } label: {
                    Text("Skip Version")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.caption)
            .padding(.vertical, 8)
            
            Button {
                if let url = downloadURL {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Text("Update")
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(8)
        .background(Color(.controlAccentColor.withAlphaComponent(0.08)))
        .cornerRadius(10)
        .shadow(radius: 0.5)
        .transition(.move(edge: .bottom))
    }
    
    @MainActor
    private func checkForUpdates() async {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "LatestReleaseUrl") as? String,
              let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let tagName = json["tag_name"] as? String,
               let assets = json["assets"] as? [[String: Any]],
               let asset = assets.first,
               let downloadURLString = asset["browser_download_url"] as? String,
               let downloadURL = URL(string: downloadURLString) {
                self.downloadURL = downloadURL
                self.latestVersion = tagName
                
                let skippedVersion = UserDefaults.standard.string(forKey: skipVersionKey)
                
                if tagName != currentVersion && tagName != skippedVersion {
                    self.hasUpdate = true
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
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

#Preview {
    ContentView()
}
