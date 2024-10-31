//
//  PlatformsListView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUICore
import SwiftUI

struct PlatformsListView: View {
    
    @ObservedObject var viewModel = PlatformsListViewModel(dataSource: .shared)
    
    @State private var showAddPlatform = false
    
    var body: some View {
        List(viewModel.platforms, selection: $viewModel.selectedPlatform) { platform in
            NavigationLink(
                destination: PlatformDetailView(for: platform),
                label: { PlatformCell(platform) }
            )
        }
        .navigationTitle("Platforms")
        .navigationSubtitle("\(viewModel.platforms.count)")
        .toolbar { Toolbar }
        .onAppear {
            viewModel.fetchPlatforms()
        }
        .sheet(isPresented: $showAddPlatform) {
            PlatformAddView()
                .onDisappear() {
                    viewModel.fetchPlatforms()
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
                    viewModel.addPreviewPlatform()
                    return
                }
                showAddPlatform = true
            }) {
                Image(systemName: "plus")
            }
        })
    }
    
    @ViewBuilder
    func PlatformCell(_ platform: Platform) -> some View {
        VStack(alignment: .leading) {
            Text(platform.name)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .padding(.vertical, 5)
    }
}
