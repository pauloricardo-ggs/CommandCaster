//
//  Connection+Samples.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension Connection {
    
    static var sample: Connection {
            Connection(name: "Local",
                       host: "localhost",
                       port: "5432",
                       username: "usr_local",
                       password: "local_pass1!")
    }
    
    static var samples: [Connection] {
        [
            Connection(name: "Local",
                       host: "localhost",
                       port: "5432",
                       username: "usr_local",
                       password: "local_pass1!"),
            Connection(name: "AWS",
                       host: "aws.host.com",
                       port: "3265",
                       username: "usr_aws",
                       password: "aws_pass1!"),
            Connection(name: "Azure",
                       host: "azure.host.com",
                       port: "9028",
                       username: "usr_azure",
                       password: "azure_pass1!")
        ]
    }
    
    static var samplesInProject: [Connection] {
        [
            Connection(name: "Local",
                       host: "localhost",
                       port: "5432",
                       username: "usr_local",
                       password: "local_pass1!"),
            Connection(name: "Azure",
                       host: "azure.host.com",
                       port: "9028",
                       username: "usr_azure",
                       password: "azure_pass1!")
        ]
    }
}
