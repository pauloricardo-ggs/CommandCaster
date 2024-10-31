//
//  ConnectionDetailView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 25/09/2024.
//

import SwiftUI

struct ConnectionDetailView: View {
    
    @ObservedObject var viewModel: ConnectionDetailViewModel
    
    @State var editMode = false
    @State var showingConfirmationDialog = false
    @State var showPassword = false
    
    init(for connection: Connection) {
        _viewModel = ObservedObject(wrappedValue: ConnectionDetailViewModel(dataSource: .shared, connection: connection))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DataSourceSection(viewModel.connection)
                DatabasesSection()
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
        .onChange(of: viewModel.connection, initial: true) {
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
            .confirmationDialog("Are you sure you want to delete this connection?", isPresented: $showingConfirmationDialog) {
                Button("Delete Connection", role: .destructive) {
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
    private func DataSourceSection(_ connection: Connection) -> some View {
        VStack(spacing: 0) {
            GroupBox {
                VStack(alignment: .leading) {
                    if editMode {
                        TextField(connection.name, text: $viewModel.name)
                            .font(.title)
                            .disabled(!editMode)
                            .frame(height: 20)
                    } else {
                        Text(connection.name)
                            .font(.title)
                            .frame(height: 20)
                    }
                    Text("Last modified \(connection.lastModifiedDescription)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    CustomDivider
                    PropertyTextField("Host", text: $viewModel.host)
                    CustomDivider
                    PropertyTextField("Port", text: $viewModel.port)
                    CustomDivider
                    PropertyTextField("User Name", text: $viewModel.username)
                    CustomDivider
                    PasswordField("Password", text: $viewModel.password)
                }
                .padding()
                .textFieldStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func DatabasesSection() -> some View {
        VStack {
            Text("Databases")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
            GroupBox {
                VStack(alignment: .leading, spacing: 0) {
                    if editMode {
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
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 2), value: editMode)
                        
                        Text(viewModel.databaseNameErrorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .frame(height: 20, alignment: .top)
                                .padding(.horizontal, 8)
                    }
                    
                    LazyVGrid(columns: [GridItem(spacing: 8), GridItem()], spacing: 8) {
                        ForEach(viewModel.databases, id: \.id) { database in
                            HStack(spacing: 0) {
                                Text(database.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(1)
                                    .padding(8)
                                
                                if editMode {
                                    Image(systemName: "trash")
                                        .frame(maxWidth: 30, maxHeight: .infinity)
                                        .background(Color(.systemFill))
                                        .onTapGesture { removeDatabasePushed(database.id) }
                                }
                            }
                            .background(Color(.tertiarySystemFill))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(8)
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
    private func PasswordField(_ title: String, text: Binding<String>) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(editMode ? .gray : .primary)
                .padding(.trailing, 8)
            
            Group {
                if editMode || showPassword {
                    TextField("required", text: text)
                } else {
                    SecureField("required", text: text)
                }
            }
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .disabled(!editMode)
            
        }
        .padding(.vertical, 3)
        .onHover { hovering in
            showPassword = hovering
        }
    }
    
    @ViewBuilder
    private var CustomDivider: some View {
        Divider().opacity(0.5)
    }
    
    private func removeDatabasePushed(_ databaseId: String) {
        viewModel.removeDatabase(id: databaseId)
    }
    
    private func addDatabasePushed() {
        viewModel.addDatabase()
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
    let connection: Connection = {
        let connection = Connection.sample
        let databases = Database.samples(for: connection)
        connection.addDatabases(databases)
        return connection
    }()
    ConnectionDetailView(for: connection)
}
