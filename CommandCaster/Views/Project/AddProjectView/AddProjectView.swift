//
//  AddProjectView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUICore
import SwiftUI
import SwiftData


struct AddProjectView: View {
    @ObservedObject var viewModel = AddProjectViewModel()
    @State private var name = "teste"
    @State private var host = ""
    @State private var port = ""
    @State private var username = ""
    @State private var password = ""
    
    @State private var databaseNames: [String] = []
    @State private var newDatabaseName = ""
    
    @State private var showAddConnection = false
    @State private var showAddPlatform = false
    
    @FocusState var focusedServiceKey: String?
    
    private let cornerRadius: CGFloat = 5
    
    var body: some View {
        ScrollView {
            VStack {
                CustomTextField("Project Name", text: $name, font: .title, floatingLabel: true)
                
                Spacer(minLength: 30)
                
                HStack {
                    ItemsList(
                        title: "Connections",
                        buttonTitle: "New Connection",
                        selectedItems: $viewModel.project.connections,
                        items: $viewModel.connections,
                        showSheet: $showAddConnection
                    )
                    
                    ItemsList(
                        title: "Platforms",
                        buttonTitle: "New Platform",
                        selectedItems: $viewModel.project.platforms,
                        items: $viewModel.platforms,
                        showSheet: $showAddPlatform
                    )
                }
                
                Spacer(minLength: 30)
                
                Text("Docker Compose File")
                    .font(.headline)
                
                if let unwrappedCompose = viewModel.project.compose {
                    ComposeFile(compose: unwrappedCompose)
                } else {
                    Button("Add Docker Compose") {
                        // MARK: - TODO: Add function
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 800, minHeight: 500)
        .onAppear() { viewModel.listConnections() }
        .sheet(isPresented: $showAddConnection) {
            ConnectionAddView()
                .onDisappear() { viewModel.listConnections() }
        }
        .sheet(isPresented: $showAddPlatform) {
            PlatformAddView()
                .onDisappear() { viewModel.listPlatforms() }
        }
        .textFieldStyle(.roundedBorder)
    }
    
    @ViewBuilder
    private func ItemsList<T: PersistentModel & Nameable>(title: String, buttonTitle: String, selectedItems: Binding<[T]>, items: Binding<[T]>, showSheet: Binding<Bool>) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            
            VStack(spacing: 0) {
                ScrollView {
                    Spacer()
                    
                    ForEach(items.wrappedValue.sorted(by: { $0.name < $1.name }), id: \.self) { item in
                        HStack {
                            Text(item.name)
                            
                            Spacer()
                            
                            if(selectedItems.wrappedValue.contains(where: { $0.id == item.id })) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if (selectedItems.wrappedValue.contains(where: { $0.id == item.id })) {
                                selectedItems.wrappedValue.removeAll(where: { $0.id == item.id })
                            } else {
                                selectedItems.wrappedValue.append(item)
                            }
                        }
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                Label(buttonTitle, systemImage: "plus")
                    .contentShape(Rectangle())
                    .padding(.vertical)
                    .onTapGesture {
                        showSheet.wrappedValue = true
                    }
            }
            .background(Color(NSColor.tertiarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(maxHeight: 180)
        }
    }
    
    @ViewBuilder
    private func ComposeFile(compose: Compose) -> some View {
        let bindingCompose = Binding (
            get: { compose },
            set: { newValue in viewModel.project.compose = newValue }
        )
        
        VStack {
            HStack {
                Text(compose.filePath)
                    .foregroundStyle(Color.gray)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .font(.title3)
                    .onTapGesture {
                        // MARK: - TODO: Add function
                    }
            }
            
            Spacer(minLength: 30)
            
            ServicesList(compose: bindingCompose)
            
            Spacer(minLength: 30)
            
            VariablesList(compose: bindingCompose)
        }
        .padding()
        .background(Color(NSColor.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    @ViewBuilder
    private func ServicesList(compose: Binding<Compose>) -> some View {
        VStack {
            HStack {
                Text("Service")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Name")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ForEach(compose.services) { $service in
                HStack {
                    Text(service.value)
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    CustomTextField("Name", text: $service.name)
                        
                }
            }
        }
    }
    
    @ViewBuilder
    private func VariablesList(compose: Binding<Compose>) -> some View {
        let widthOfColumnType: CGFloat = 170
        
        VStack {
            HStack {
                Text("Variable")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Type")
                    .fontWeight(.bold)
                    .frame(width: widthOfColumnType, alignment: .leading)
                
                Text("Value")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ForEach(compose.variables) { $variable in
                HStack {
                    Text(variable.name)
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("", selection: $variable.type) {
                        ForEach(VariableType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()
                    .frame(width: widthOfColumnType)
                    
                    CustomTextField("Value", text: $variable.value)
                        .disabled(variable.type != .custom)
                }
            }
        }
    }
}

struct AddProjectView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AddProjectViewModel()
        
        let project = Project()
        
        let service1 = Service(
            name: "service_1",
            value: "service_1"
        )
        
        let service2 = Service(
            name: "service_2",
            value: "service_2"
        )
        
        let variable1 = Variable(
            name: "variable_1",
            value: "${variable_1}",
            type: .custom
        )
        
        let variable2 = Variable(
            name: "variable_2",
            value: "${variable_2}",
            type: .custom
        )
            
        let compose = Compose(
            filePath: "path/to/file.yml",
            services: [service1, service2],
            variables: [variable1, variable2],
            project: project
        )
        project.compose = compose
        service1.compose = compose
        service2.compose = compose
        variable1.compose = compose
        variable2.compose = compose
        viewModel.project = project
        
        return AddProjectView(viewModel: viewModel)
    }
}



