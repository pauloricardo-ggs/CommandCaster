//
//  PlatformAddView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUICore
import SwiftUI

struct PlatformAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = PlatformAddViewModel(dataSource: .shared)
    
    @State var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView() {
                VStack(spacing: 20) {
                    DataSection
                }
                .padding()
            }
            
            Divider()
            
            Footer.padding()
        }
        .frame(width: 500, height: 530)
    }
    
    @ViewBuilder
    private var DataSection: some View {
        VStack(spacing: 0) {
            Text("New Platform")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading) {
                    TextField("Name", text: $viewModel.name)
                        .textFieldStyle(.plain)
                        .font(.title2)
                    
                    CustomDivider
                    
                    PropertyTextField("Value", text: $viewModel.value)
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
                .alert("Abort Platform Setup", isPresented: $showCancelAlert) {
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
        if viewModel.isEmpty() { dismiss() }
        else { showCancelAlert = true }
    }
    
    private func savePushed() {
        if viewModel.save() {
            dismiss()
        }
    }
}

#Preview {
    PlatformAddView()
}
