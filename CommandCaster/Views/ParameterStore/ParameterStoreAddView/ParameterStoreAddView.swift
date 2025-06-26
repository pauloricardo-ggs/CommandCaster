//
//  ParameterStoreAddView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftUICore
import SwiftUI

struct ParameterStoreAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ParameterStoreAddViewModel
    
    @State var showCancelAlert = false
    @State var showErrorAlert = false
    @State var error = ""
    
    var onAdd: () -> Void
    
    init(paths: [ParameterStorePath], selectedPath: ParameterStorePath?, parameters: [ParameterStoreVariable]?, onAdd: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: ParameterStoreAddViewModel(dataSource: .shared, paths: paths, selectedPath: selectedPath, parameters: parameters))
        self.onAdd = onAdd
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DataSection.padding()
            Divider()
            Footer.padding()
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(error)
        }
    }
    
    @ViewBuilder
    private var DataSection: some View {
        VStack(spacing: 0) {
            Text("New Parameter Store Variable")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading) {
                    ScrollView {
                        VStack {
                            ForEach(Array($viewModel.variables.enumerated()), id: \.element.id) { index, $variable in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        TextField("Name", text: $variable.name)
                                            .textFieldStyle(.plain)
                                            .font(.title3)

                                        TextField("Value", text: $variable.value)
                                            .textFieldStyle(.plain)
                                            .font(.body)
                                    }

                                    if index > 0 {
                                        Button(role: .destructive) {
                                            viewModel.variables.removeAll { $0.id == variable.id }
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .padding(.leading, 8)
                                    }
                                }

                                Divider().opacity(0.3)
                            }
                        }
                    }
                    .frame(maxHeight: 300)

                    Button(action: {
                        viewModel.variables.append(ParameterStoreVariableInput())
                    }) {
                        Label("Adicionar outro", systemImage: "plus")
                    }
                    .padding(.top, 4)
                    
                    Divider().opacity(0.5)
                    
                    HStack {
                        Text("Path").padding(.trailing, 8)
                        Spacer()
                        
                        Picker("", selection: $viewModel.selectedPath) {
                            Text("Select a Path").tag(nil as ParameterStorePath?)
                            ForEach(viewModel.paths) { path in
                                Text(path.name)
                                    .tag(path as ParameterStorePath?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .labelsHidden()
                        .frame(width: 150)
                    }
                    .foregroundStyle(.gray)
                    .padding(.vertical, 3)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
            }
        }
    }

    
    @ViewBuilder
    private var Footer: some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            Button("Cancel") { cancelPushed() }
                .alert("Abort Parameter Store Variable Setup", isPresented: $showCancelAlert) {
                Button("Yes", role: .destructive) { dismiss() }
                Button("Keep Editing", role: .cancel) {}
            } message: {
                Text("Any unsaved changes will be lost.")
            }
            .disabled(viewModel.loading)
            
            Button("Add") { Task { await addPushed() }}
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid() || viewModel.loading)
        }
    }
    
    private func cancelPushed() {
        if viewModel.isEmpty() { dismiss() }
        else { showCancelAlert = true }
    }
    
    private func addPushed() async {
        guard !viewModel.loading else { return }
        viewModel.loading = true
        defer { viewModel.loading = false }
        
        await viewModel.addAll { success, errorMessage in
            onAdd()
            
            if !success {
                error = errorMessage
                showErrorAlert = true
                return
            }
            
            dismiss()
        }
    }
}

#Preview {
    let paths = [ ParameterStorePath(name: "path", path: "/path/to/parameter/") ]
    ParameterStoreAddView(paths: paths, selectedPath: paths.first, parameters: nil) {}
}
