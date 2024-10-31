//
//  ProjectsListView.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import SwiftUICore
import SwiftUI

struct ProjectsListView: View {
    
    @StateObject var viewModel = ProjectsListViewModel(dataSource: .shared)

    @State private var showAddProject = false
    
    var body: some View {
        List(viewModel.projects, selection: $viewModel.selectedProject) { project in
            NavigationLink(
                destination: ProjectDetailView(),
                label: { ProjectCell(project) }
            )
        }
        .navigationTitle("Projects")
        .navigationSubtitle("\(viewModel.projects.count)")
        .toolbar { Toolbar }
        .onAppear {
            viewModel.fetchProjects()
        }
        .sheet(isPresented: $showAddProject) { AddProjectView() }
    }
    
    @ToolbarContentBuilder
    var Toolbar: some ToolbarContent {
        ToolbarItemGroup(content: {
            Button(action: {
            }) {
                Image(systemName: "arrow.up.arrow.down")
                Image( systemName: "chevron.down")
                    .imageScale(.small)
            }
            
            Button(action: {
//                showAddConnection = true
                viewModel.addProject()
            }) {
                Image(systemName: "plus")
            }
        })
    }
    
    @ViewBuilder
    func ProjectCell(_ project: Project) -> some View {
        VStack(alignment: .leading) {
            Text(project.name)
                .font(.title2)
                .fontWeight(.semibold)
            Text("\(project.id)")
        }
        .padding(.vertical, 5)
    }
}
