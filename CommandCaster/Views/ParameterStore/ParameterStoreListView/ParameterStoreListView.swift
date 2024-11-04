//
//  ParameterStoreListView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUI
import AWSSSM

struct ParameterStoreListView: View {
    @ObservedObject private var viewModel = ParameterStoreListViewModel(dataSource: .shared)
    
    private let padding: CGFloat = 8
    private let columnWidth: CGFloat = 120
    private let cellHeight: CGFloat = 30
    private let dividerHeight: CGFloat = 2

    @State private var showAddParameterStorePath = false
    @State private var showEditParameterStorePath = false
    @State private var showDeleteParameterStorePath = false
    @State private var selectedPathForEditOrDelete: ParameterStorePath?
    @State private var showAddParameter = false
    @State private var showAddProfile = false
    @State private var columnsCount: Int = 1
    @State private var headerHeight: CGFloat = 30
    @State private var maxHeaderHeight: CGFloat = 30
    @State private var minHeaderHeight: CGFloat = 30
    @State var showErrorAlert = false
    @State var error = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                Header
                DragBar
                ListBody(geometry)
            }
            .onAppear() {
                viewModel.fetchPaths()
                (columnsCount, maxHeaderHeight, minHeaderHeight) = calculateHeaderDimensions(geometry.size.width)
                updateHeaderHeight(to: minHeaderHeight * 2.5)
            }
            .onChange(of: "\(geometry.size.width)\(viewModel.paths)") {
                (columnsCount, maxHeaderHeight, minHeaderHeight) = calculateHeaderDimensions(geometry.size.width)
                updateHeaderHeight(to: minHeaderHeight * 2.5)
            }
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text(error)
        }
        .sheet(isPresented: $showAddParameterStorePath, onDismiss: {
            viewModel.fetchPaths()
        }) {
            ParameterStorePathAddView(paths: viewModel.paths)
                .presentationBackgroundInteraction(.disabled)
        }
        .sheet(isPresented: $showAddParameter, onDismiss: {
            if let selectedPath = viewModel.selectedPath {
                fetchParameters(for: selectedPath)
            }
        }) {
            ParameterStoreAddView(paths: viewModel.paths, selectedPath: viewModel.selectedPath, parameters: viewModel.parameters)
                .presentationBackgroundInteraction(.disabled)
        }
        .sheet(isPresented: $showEditParameterStorePath, onDismiss: {
            viewModel.fetchPaths()
        }) {
            if let selectedPath = selectedPathForEditOrDelete {
                ParameterStorePathEditView(selectedPath: selectedPath, paths: viewModel.paths)
                    .presentationBackgroundInteraction(.disabled)
            }
        }
    }
    
    @ToolbarContentBuilder
    private var Toolbar: some ToolbarContent {
        ToolbarItemGroup(content: {
            
            Menu("Add", systemImage: "plus", content: {
                Button("Add path", action: {
                    showAddParameterStorePath = true
                })
                
                if (viewModel.paths.count > 0) {
                    Button("Add variable", action: {
                        showAddParameter = true
                    })
                }
            })
        })
    }
        
    @ViewBuilder
    private var Header: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columnsCount), spacing: padding) {
                ForEach(Array(viewModel.paths.sorted()), id: \.self) { path in
                    HeaderCell(path: path)
                        .alert("Delete \(selectedPathForEditOrDelete?.name ?? "")?", isPresented: $showDeleteParameterStorePath) {
                            Button("Delete", role: .destructive) {
                                if let selectedPath = selectedPathForEditOrDelete {
                                    viewModel.delete(selectedPath)
                                    viewModel.fetchPaths()
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Any unsaved changes will be lost.")
                        }
                }
            }
            .padding(padding)
        }
        .frame(maxHeight: headerHeight)
    }
    
    @ViewBuilder
    private func HeaderCell(path: ParameterStorePath) -> some View {
        ZStack {
            Button(action: {
                viewModel.selectedPath = path
                fetchParameters(for: path)
            }, label: {
                Text(path.name)
                    .lineLimit(1)
                    .padding(8)
                    .frame(minHeight: cellHeight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(viewModel.selectedPath == path ? .gray : .tertiarySystemFill))
                    .cornerRadius(8)
            })
            .disabled(viewModel.selectedPath == path)
            .buttonStyle(.plain)
            .contextMenu {
                Button("Edit") {
                    selectedPathForEditOrDelete = path
                    showEditParameterStorePath = true
                }
                Button("Delete") {
                    selectedPathForEditOrDelete = path
                    showDeleteParameterStorePath =  true
                }
            }
        }
    }
    
    @ViewBuilder
    private var DragBar: some View {
        Rectangle()
            .fill(Color(.secondarySystemFill))
            .frame(height: dividerHeight)
            .onHover { hovering in
                hovering ? NSCursor.resizeUpDown.push() : NSCursor.pop()
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newHeaderHeight = headerHeight + value.translation.height
                        updateHeaderHeight(to: newHeaderHeight)
                    }
            )
    }
    
    @ViewBuilder
    private func ListBody(_ geometry: GeometryProxy) -> some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .textCase(.lowercase)
                .disableAutocorrection(true)
        }
        .padding(8)
        .onChange(of: viewModel.searchText) {
            viewModel.filterParameters()
        }
        
        Divider()
        
        VStack {
            if (viewModel.loading) {
                ProgressView("Loading...")
                    .progressViewStyle(.automatic)
                    .padding()
            } else {
                List(viewModel.filteredParameters, selection: $viewModel.selectedParameter) { parameter in
                    NavigationLink(
                        destination: ParameterStoreDetailView(for: parameter, postDeleteAction: { viewModel.delete(parameter) }),
                        label: { ParameterCell(parameter) }
                    )
                }
                .toolbar { Toolbar }
            }
        }
        .navigationTitle(viewModel.selectedPath == nil ? "Parameter Store" : "\(viewModel.selectedPath!.name) - \(viewModel.selectedPath!.path)")
        .navigationSubtitle(viewModel.selectedPath == nil || viewModel.loading ? " " : "\(viewModel.parameters.count) variables")
        .onDisappear {
            viewModel.cancelFetch()
        }
        .frame(maxHeight: geometry.size.height - headerHeight - dividerHeight)
    }
    
    @ViewBuilder
    private func ParameterCell(_ parameter: ParameterStoreVariable) -> some View {
        Text(parameter.name)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 5)
    }
    
    private func fetchParameters(for path: ParameterStorePath) {
        viewModel.searchText = ""
        viewModel.fetchParameters(for: path) { success, errorMessage in
            if !success {
                error = errorMessage
                showErrorAlert = true
            }
        }
    }
    
    private func updateHeaderHeight(to newHeaderHeight: CGFloat? = nil) {
        let targetHeight = newHeaderHeight ?? headerHeight
        headerHeight = min(max(targetHeight, minHeaderHeight), maxHeaderHeight)
    }
    
    private func calculateHeaderDimensions(_ windowWidth: CGFloat) -> (columnsCount: Int, maxHeaderHeight: CGFloat, minHeaderHeight: CGFloat) {
        let columnsCount = max(Int(windowWidth / columnWidth), 1)
        let linesCount = CGFloat((viewModel.paths.count + columnsCount - 1) / columnsCount)
        let maxHeaderHeight = cellHeight * linesCount + padding * (linesCount + 3)
        let minHeaderHeight = cellHeight + 3 * padding
        return (columnsCount, maxHeaderHeight, minHeaderHeight)
    }
}

#Preview {
    ParameterStoreListView()
}
