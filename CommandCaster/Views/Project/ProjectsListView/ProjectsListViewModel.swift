//
//  ProjectsListViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class ProjectsListViewModel: ObservableObject {
    
    private let dataSource: DataSource
    
    @Published var projects: [Project] = []
    
    @State var selectedProject: Project?
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.projects = []
    }
    
    func addProject() {
        let newProject = Project(name: "New Project", connections: [], platforms: [], compose: nil)
        dataSource.add(newProject)
        fetchProjects()
    }
    
    func fetchProjects() {
        projects = dataSource.fetchProjects()
    }
}
