//
//  PlatformsListViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUI

class PlatformsListViewModel: ObservableObject {
    
    private let dataSource: DataSource
    
    @Published var platforms: [Platform]
    
    @State var selectedPlatform: Platform?
        
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.platforms = []
    }
    
    func addPreviewPlatform() {
        dataSource.add(Platform.sample)
        fetchPlatforms()
    }
    
    func fetchPlatforms() {
        platforms = dataSource.fetchPlatforms()
    }
}
