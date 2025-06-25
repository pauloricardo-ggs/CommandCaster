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
    
    init(paths: [ParameterStorePath], selectedPath: ParameterStorePath?, parameters: [ParameterStoreVariable]?) {
        _viewModel = StateObject(wrappedValue: ParameterStoreAddViewModel(dataSource: .shared, paths: paths, selectedPath: selectedPath, parameters: parameters))
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
                    TextField("Name", text: $viewModel.name)
                        .textFieldStyle(.plain)
                        .font(.title2)
                    
                    Divider().opacity(0.5)
                    
                    HStack {
                        Text("Value")
                            .foregroundStyle(.gray)
                            .padding(.trailing, 8)
                        TextField("required", text: $viewModel.value)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(.plain)
                    }
                    .padding(.vertical, 3)
                    
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
        
        await viewModel.add() { success, errorMessage in
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
    ParameterStoreAddView(paths: paths, selectedPath: paths.first, parameters: nil)
}
