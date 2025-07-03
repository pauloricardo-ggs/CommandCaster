//
//  ParameterStoreVariable+Samples.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 29/10/2024.
//

extension ParameterStoreVariable {
    static var sample: ParameterStoreVariable {
        ParameterStoreVariable(
            name: "PARAMETER_SFTP_HOST",
            path: "/path/to/PARAMETER_SFTP_HOST",
            arn: "arn:aws:ssm:us-east-1:123456789012:parameter/PARAMETER_SFTP_HOST",
            value: "sftp.host.com",
            version: "3",
            lastModifiedDate: "07/06/2024 18:03",
            type: "String",
            dataType: "text")
    }
    
    static var samples: [ParameterStoreVariable] {
        [
            ParameterStoreVariable(
                name: "PARAMETER_SFTP_HOST",
                path: "/path/to/PARAMETER_SFTP_HOST",
                arn: "arn:aws:ssm:us-east-1:123456789012:parameter/PARAMETER_SFTP_HOST",
                value: "sftp.host.com",
                version: "3",
                lastModifiedDate: "2024-06-07T18:03:18.710000-03:00",
                type: "String",
                dataType: "text"),
            ParameterStoreVariable(
                name: "PARAMETER_SFTP_PORT",
                path: "/path/to/PARAMETER_SFTP_PORT",
                arn: "arn:aws:ssm:us-east-1:123456789012:parameter/PARAMETER_SFTP_PORT",
                value: "sftp.port.com",
                version: "3",
                lastModifiedDate: "12/03/2023 06:47",
                type: "String",
                dataType: "text")
        ]
    }
}
