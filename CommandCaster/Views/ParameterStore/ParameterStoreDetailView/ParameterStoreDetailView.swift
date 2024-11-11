//
//  ParameterStoreDetailView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 25/09/2024.
//

import SwiftUI

struct ParameterStoreDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ParameterStoreDetailViewModel
    
    @State var editMode = false
    @State var showingConfirmationDialog = false
    @State var showPassword = false
    @State var error = ""
    @State var showErrorAlert = false
    private let postDeleteAction: (() -> Void)
    
    init(for parameter: ParameterStoreVariable, postDeleteAction: @escaping () -> Void) {
        _viewModel = ObservedObject(wrappedValue: ParameterStoreDetailViewModel(dataSource: .shared, parameter: parameter))
        self.postDeleteAction = postDeleteAction
    }
    
    var body: some View {
        ScrollView {
            DataSourceSection()
                .padding()
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(error)
        }
        .toolbar {
            if editMode {
                ToolbarEditMode
            } else {
                Toolbar
            }
        }
        .toolbar(removing: .title)
        .onChange(of: viewModel.parameter) {
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
            .confirmationDialog("Are you sure you want to delete this variable?", isPresented: $showingConfirmationDialog) {
                Button("Delete Variable", role: .destructive) { Task { await deletePushed() } }
                Button("Cancel", role: .cancel) {}
            }
            .disabled(viewModel.loading)
            
            Spacer()
            
            Button("Cancel", role: .cancel) {
                cancelEditPushed()
            }
            .disabled(viewModel.loading)
            
            Button(action: {
                Task {
                    await savePushed()
                }
            }) {
                Text("Save")
                    .foregroundColor(viewModel.isValid() ? .blue : nil)
            }
            .padding(.trailing, 8)
            .buttonStyle(.bordered)
            .disabled(viewModel.loading)
        })
    }
    
    @ViewBuilder
    private func DataSourceSection() -> some View {
        VStack(spacing: 0) {
            GroupBox {
                VStack(alignment: .leading) {
                    Text(viewModel.parameter.name)
                        .font(.title)
                    
                    Text("Last modified \(viewModel.parameter.lastModifiedDate)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    CustomDivider
                    PropertyTextField("Value", text: $viewModel.value)
                }
                .padding()
                .textFieldStyle(.plain)
            }
            
            Spacer(minLength: 15)
            
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Path").padding(.trailing, 8)
                        Text(viewModel.parameter.path).foregroundStyle(.gray)
                    }
                    CustomDivider.padding(.vertical, 10)
                    HStack {
                        Text("ARN").padding(.trailing, 8)
                        Text(viewModel.parameter.arn).foregroundStyle(.gray)
                    }
                    CustomDivider.padding(.vertical, 10)
                    HStack {
                        Text("Version").padding(.trailing, 8)
                        Text(viewModel.parameter.version).foregroundStyle(.gray)
                        Spacer()
                        Text("Type").padding(.trailing, 8)
                        Text(viewModel.parameter.type).foregroundStyle(.gray)
                        Spacer()
                        Text("Data Type").padding(.trailing, 8)
                        Text(viewModel.parameter.dataType).foregroundStyle(.gray)
                        
                    }
                }
                .padding()
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
        viewModel.loading = true
        viewModel.loadData()
        editMode = false
        viewModel.loading = false
    }
    
    private func savePushed() async {
        viewModel.loading = true
        editMode = false
        let (success, error) = await viewModel.updateValue()
        if success { return }
        self.error = error
        showErrorAlert = true
        viewModel.loading = false
    }
    
    private func deletePushed() async {
        viewModel.loading = true
        await viewModel.deleteParameter()
        postDeleteAction()
        viewModel.loading = false
        editMode = false
        dismiss()
    }
}

#Preview {
    ParameterStoreDetailView(for: ParameterStoreVariable.sample, postDeleteAction: {})
}
