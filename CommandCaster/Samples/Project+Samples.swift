//
//  Project+Samples.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension Project {
    static var sample: Project {
        Project(name: "Project X",
                connections: Connection.samplesInProject,
                platforms: Platform.samplesInProject,
                compose: nil)
    }
    
    static var samples: [Project] {
        [
            Project(name: "Project X",
                    connections: Connection.samplesInProject,
                    platforms: Platform.samplesInProject,
                    compose: nil),
            Project(name: "Project Y",
                    connections: Connection.samplesInProject,
                    platforms: Platform.samplesInProject,
                    compose: nil)
        ]
    }
}
