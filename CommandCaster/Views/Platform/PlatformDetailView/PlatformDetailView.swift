//
//  PlatformDetailView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 25/09/2024.
//

import SwiftUI

struct PlatformDetailView: View {
    
    @ObservedObject var viewModel: PlatformDetailViewModel
    
    @State var editMode = false
    @State var showingConfirmationDialog = false
    
    init(for platform: Platform) {
        _viewModel = ObservedObject(wrappedValue: PlatformDetailViewModel(dataSource: .shared, platform: platform))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DataSection(viewModel.platform)
            }
            .padding()
        }
        .toolbar {
            if editMode {
                ToolbarEditMode
            } else {
                Toolbar
            }
        }
        .toolbar(removing: .title)
        .onChange(of: viewModel.platform, initial: true) {
            viewModel.loadData()
            editMode = false
        }
    }
    
    @ToolbarContentBuilder
    private var Toolbar: some ToolbarContent {
        ToolbarItemGroup(content: {
            Spacer()
            Button(action: {
                editMode = true
            }) {
                Text("Edit")
            }
            .padding(.trailing, 8)
        })
    }
    
    @ToolbarContentBuilder
    private var ToolbarEditMode: some ToolbarContent {
        ToolbarItemGroup(content: {
            Button(action: { showingConfirmationDialog = true }) {
                Text("Delete")
                    .foregroundColor(.red)
            }
            .confirmationDialog("Are you sure you want to delete this platform?", isPresented: $showingConfirmationDialog) {
                Button("Delete Platform", role: .destructive) {
                    viewModel.delete()
                }
                Button("Cancel", role: .cancel) {}
            }
            
            Spacer()
            
            Button("Cancel", role: .cancel) { cancelEditPushed() }
            
            Button(action: { savePushed() }) {
                Text("Save")
                    .foregroundColor(viewModel.isValid() ? .blue : nil)
            }
            .padding(.trailing, 8)
            .buttonStyle(.bordered)
            .disabled(!viewModel.isValid())
        })
    }
    
    @ViewBuilder
    private func DataSection(_ platform: Platform) -> some View {
        VStack(spacing: 0) {
            GroupBox {
                VStack(alignment: .leading) {
                    if editMode {
                        TextField(platform.name, text: $viewModel.name)
                            .font(.title)
                            .disabled(!editMode)
                            .frame(height: 20)
                    } else {
                        Text(platform.name)
                            .font(.title)
                            .frame(height: 20)
                    }
                    Text("Last modified \(platform.lastModifiedDescription)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    CustomDivider
                    PropertyTextField("Value", text: $viewModel.value)
                }
                .padding()
                .textFieldStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func PropertyTextField(_ title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(editMode ? .gray : .primary)
                .padding(.trailing, 8)
            TextField("required", text: text)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.trailing)
                .disabled(!editMode)
        }
        .padding(.vertical, 3)
    }
    
    @ViewBuilder
    private var CustomDivider: some View {
        Divider().opacity(0.5)
    }
    
    private func cancelEditPushed() {
        viewModel.loadData()
        editMode = false
    }
    
    private func savePushed() {
        viewModel.save()
        editMode = false
    }
}

#Preview {
    PlatformDetailView(for: Platform.sample)
}
