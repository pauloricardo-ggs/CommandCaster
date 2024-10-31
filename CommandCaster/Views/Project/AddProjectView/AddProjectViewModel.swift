//
//  AddProjectViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class AddProjectViewModel: ObservableObject {
    
//    private let connectionRepository: any ConnectionRepositoryProtocol = DIContainer.resolve()
//    private let platformRepository: any PlatformRepositoryProtocol = DIContainer.resolve()
    
    @Published var project = Project()
    @Published var connections: [Connection] = []
    @Published var platforms: [Platform] = []
    
    init() {
        listConnections()
        listPlatforms()
    }
    
    func listConnections() {
//        if let response = connectionRepository.list() {
//            connections = response
//        }
    }
    
    func listPlatforms() {
//        if let response = platformRepository.list() {
//            platforms = response
//        }
    }
}
