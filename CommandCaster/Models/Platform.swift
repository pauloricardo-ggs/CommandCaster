//
//  Platform.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 18/09/2024.
//

import Foundation
import SwiftData

@Model
class Platform: Nameable, Identifiable {
    @Attribute var id: String
    var name: String
    var value: String
    var lastModifiedDate: Date = Date.now
    var lastModifiedDescription: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self.lastModifiedDate) { return "Today" }
        if calendar.isDateInYesterday(self.lastModifiedDate) { return "Yesterday" }
        return "\(self.lastModifiedDate.formatted(date: .numeric, time: .omitted))"
    }
    
    init(id: String = UUID().uuidString, name: String, value: String, lastModifiedDate: Date = .now) {
        self.id = id
        self.name = name
        self.value = value
        self.lastModifiedDate = lastModifiedDate
    }
    
    func update(name: String) {
        self.name = name
        updateLastModifiedDate()
    }
    
    func update(value: String) {
        self.value = value
        updateLastModifiedDate()
    }
    
    private func updateLastModifiedDate(_ newDate: Date = .now)
    {
        self.lastModifiedDate = newDate
    }
}
