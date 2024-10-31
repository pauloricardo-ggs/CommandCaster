//
//  ConnectionAddView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUICore
import SwiftUI

struct ConnectionAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel = ConnectionAddViewModel(dataSource: .shared)
    
    @State var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView() {
                VStack(spacing: 20) {
                    NameSection
                    DataSourceSection
                    DatabasesSection
                }
                .padding()
            }
            
            Divider()
            
            Footer.padding()
        }
        .frame(width: 500, height: 530)
    }
    
    @ViewBuilder
    private var NameSection: some View {
        VStack(spacing: 0) {
            Text("New Connection")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(.plain)
                    .font(.title2)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
            }
        }
    }
    
    @ViewBuilder
    private var DataSourceSection: some View {
        VStack(spacing: 0) {
            Text("Data Source")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading) {
                    PropertyTextField("Host", text: $viewModel.host)
                    CustomDivider
                    PropertyTextField("Port", text: $viewModel.port)
                    CustomDivider
                    PropertyTextField("User Name", text: $viewModel.username)
                    CustomDivider
                    PropertyTextField("Password", text: $viewModel.password)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
            }
        }
    }
    
    @ViewBuilder
    private var DatabasesSection: some View {
        VStack(spacing: 0) {
            Text("Databases")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
            
            GroupBox {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        TextField("New database", text: $viewModel.newDatabaseName)
                            .textFieldStyle(.plain)
                            .padding(.horizontal, 8)
                            .frame(height: 23)
                            .background(Color(.systemFill))
                            .clipShape(.rect(cornerRadius: 8))
                            .onSubmit { addDatabasePushed() }
                        
                        Button(action: { addDatabasePushed() }, label: {Image(systemName: "plus")})
                        .disabled(viewModel.newDatabaseName.isEmpty)
                    }
                    
                    if !viewModel.databases.isEmpty {
                        Text(viewModel.databaseNameErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(height: 20, alignment: .top)
                                .padding(.horizontal, 8)
                    }
                    
                    DatabasesList
                }
                .padding(8)
            }
        }
    }
    
    @ViewBuilder
    private var DatabasesList: some View {
        LazyVGrid(columns: [GridItem(spacing: 8), GridItem()], spacing: 8) {
            ForEach(viewModel.databases, id: \.id) { database in
                HStack(spacing: 0) {
                    Text(database.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding(8)
                    
                    Image(systemName: "trash")
                        .frame(maxWidth: 30, maxHeight: .infinity)
                        .background(Color(.systemFill))
                        .onTapGesture { removeDatabasePushed(databaseId: database.id) }
                }
                .background(Color(.tertiarySystemFill))
                .cornerRadius(8)
            }
        }
    }
    
    @ViewBuilder
    private var Footer: some View {
        HStack(alignment: .bottom) {
            Spacer()
            
            Button("Cancel") { cancelPushed() }
                .alert("Abort Connection Setup", isPresented: $showCancelAlert) {
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
    
    private func addDatabasePushed() {
        viewModel.addDatabase()
    }
    
    private func removeDatabasePushed(databaseId: UUID) {
        viewModel.removeDatabase(id: databaseId)
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
    ConnectionAddView()
}
