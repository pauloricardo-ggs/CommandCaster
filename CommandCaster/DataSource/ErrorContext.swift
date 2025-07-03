//
//  ErrorContext.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 28/09/2024.
//

import Foundation
import AppKit

final class ErrorContext: ObservableObject {
    
    static var shared = ErrorContext()
    
    @Published var error: CustomError?
    
    var hasError: Bool {
        error != nil
    }
    
    func set(_ error: CustomError?) {
        self.error = error
        if let error = error {
            showGlobalAlert(title: "Error", message: error.description)
        }
    }
    
    func clear() {
        self.error = nil
    }
    
    private func showGlobalAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")

            if let window = NSApp.windows.first(where: \.isKeyWindow) ?? NSApp.windows.first {
                alert.beginSheetModal(for: window)
            } else {
                alert.runModal()
            }
        }
    }
}

enum CustomError: Error {
    case duplicatedPath
    case duplicatedVariable
    case failedToAddPath
    case failedToDeleteVariable
    case failedToFetchPaths
    case failedToFetchVariables
    case failedToUpdateVariable
    case failedToSave
    case noPathSelected
    case noValidVariable
    case withMessage(String)

    var description: String {
        return switch self {
        case .duplicatedPath: "Already exists a parameter store path with this name"
        case .duplicatedVariable: "Duplicate variable names are not allowed"
        case .failedToAddPath: "Failed to add path"
        case .failedToDeleteVariable: "Failed to delete variable"
        case .failedToFetchPaths: "Failed to fetch paths"
        case .failedToFetchVariables: "Failed to fetch variables"
        case .failedToUpdateVariable: "Failed to update variable"
        case .failedToSave: "Failed to save path"
        case .noPathSelected: "No path selected"
        case .noValidVariable: "Please enter at least one valid variable"
        case .withMessage(let message): message
        }
    }
}
