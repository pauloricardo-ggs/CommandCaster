//
//  PlatformAddViewModel.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData
import SwiftUICore

class PlatformAddViewModel: ObservableObject {

    private let dataSource: DataSource
    
    @Published var name: String = ""
    @Published var value: String = ""
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func save() -> Bool {
        if !isValid() { return false }
        
        let newPlatform = Platform(name: name, value: value)
        dataSource.add(newPlatform)
        return true
    }
    
    func isEmpty() -> Bool {
        return name.isEmpty &&
               value.isEmpty
    }
    
    func isValid() -> Bool {
        return !name.isEmpty &&
               !value.isEmpty
    }
}
