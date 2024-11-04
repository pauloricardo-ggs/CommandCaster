//
//  Platform+Samples.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension Platform {
    static var sample: Platform {
        Platform(name: "AMD",
                 value: "linux/amd64")
    }
    
    static var samples: [Platform] {
        [
            Platform(id: "1",
                     name: "AMD",
                     value: "linux/amd64"),
            Platform(id: "2",
                     name: "ARM",
                     value: "linux/armd64")
        ]
    }
    
    static var samplesInProject: [Platform] {
        [
            Platform(id: "1",
                     name: "AMD",
                     value: "linux/amd64")
        ]
    }
}
