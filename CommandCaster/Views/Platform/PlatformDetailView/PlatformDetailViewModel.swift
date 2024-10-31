//
//  PlatformDetailViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class PlatformDetailViewModel: ObservableObject {
    
    private let dataSource: DataSource
    
    @Published var name: String = ""
    @Published var value: String = ""
    
    @Published var platform: Platform
    
    init(dataSource: DataSource, platform: Platform) {
        self.dataSource = dataSource
        self.platform = platform
    }
    
    func loadData() {
        name = ""
        value = platform.value
    }
    
    func save() {
        if (!name.isEmpty) { platform.update(name: name) }
        if (!value.isEmpty) { platform.update(value: value) }
    }
    
    func delete() {
        dataSource.delete(platform)
    }
    
    func isValid() -> Bool {
        return !value.isEmpty
    }
}
