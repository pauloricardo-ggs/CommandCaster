//
//  ParameterStorePathEditView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

import SwiftUICore
import SwiftUI

struct ParameterStorePathEditView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ParameterStorePathEditViewModel
    
    @State var showCancelAlert = false
    
    init(selectedPath: ParameterStorePath, paths: [ParameterStorePath]) {
        _viewModel = ObservedObject(initialValue: ParameterStorePathEditViewModel(selectedPath: selectedPath, paths: paths))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DataSection.padding()
            Divider()
            Footer.padding()
        }
    }
    
    @ViewBuilder
    private var DataSection: some View {
        VStack(spacing: 0) {
            Text("Edit Parameter Store Path")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading) {
                    TextField("Name", text: $viewModel.newName)
                        .textFieldStyle(.plain)
                        .font(.title2)
                    
                    CustomDivider
                    
                    PropertyTextField("Path", text: $viewModel.newPath)
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
                .alert("Abort Path Edit", isPresented: $showCancelAlert) {
                    Button("Yes", role: .destructive) { dismiss() }
                    Button("Keep Editing", role: .cancel) {}
                } message: {
                    Text("Any unsaved changes will be lost.")
                }
            
            Button("Save") { savePushed() }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.isValid())
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
        if !viewModel.changed() { dismiss() }
        else { showCancelAlert = true }
    }
    
    private func savePushed() {
        viewModel.save()
        if !ErrorContext.shared.hasError {
            dismiss()
        }
    }
}

#Preview {
    let selectedPath = ParameterStorePath(name: "Parameter Path", path: "/path/of/the/parameter")
    ParameterStorePathEditView(selectedPath: selectedPath, paths: [selectedPath])
}
