//
//  ParameterStorePathAddView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftUICore
import SwiftUI

struct ParameterStorePathAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ParameterStorePathAddViewModel
    
    @State var showCancelAlert = false
    @State var showErrorAlert = false
    @State var error = ""
    
    init(paths: [ParameterStorePath]) {
        _viewModel = ObservedObject(initialValue: ParameterStorePathAddViewModel(dataSource: .shared, paths: paths))
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
            Text("New Parameter Store Path")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading) {
                    TextField("Name", text: $viewModel.name)
                        .textFieldStyle(.plain)
                        .font(.title2)
                    
                    CustomDivider
                    
                    PropertyTextField("Path", text: $viewModel.path)
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
            .alert("Abort Parameter Store Path Setup", isPresented: $showCancelAlert) {
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
    
    @ViewBuilder
    private func PropertyTextField(_ title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
                .padding(.trailing, 8)
            TextField("required", text: text)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(.plain)
        }
        .padding(.vertical, 3)
    }
    
    @ViewBuilder
    private var CustomDivider: some View {
        Divider().opacity(0.5)
    }
    
    private func cancelPushed() {
        if viewModel.isEmpty() { dismiss() }
        else { showCancelAlert = true }
    }
    
    private func addPushed() async {
        viewModel.loading = true
        let (success, error) = await viewModel.add()
        if success {
            dismiss()
            return
        }
        
        self.error = error
        showErrorAlert = true
        viewModel.loading = false
    }
}

#Preview {
    let path = ParameterStorePath(name: "Parameter Path", path: "/path/of/the/parameter")
    ParameterStorePathAddView(paths: [path])
}
