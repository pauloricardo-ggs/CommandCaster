//
//  ParameterStoreVariable.swift
//  CommandCaster
//
//  Created by Paulo Ricardo on 24/10/2024.
//

import Foundation
import AWSSSM

struct ParameterStoreVariable: Hashable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var path: String
    var arn: String
    var value: String
    var version: String
    var lastModifiedDate: String
    var type: String
    var dataType: String
}

extension ParameterStoreVariable {
    static func from(ssmParameter: SSMClientTypes.Parameter) -> ParameterStoreVariable? {
        
        guard let fullName = ssmParameter.name else {
            return nil
        }
        
        let path: String
        let name: String
        
        if let lastSlashIndex = fullName.lastIndex(of: "/") {
            path = fullName
            name = String(fullName[fullName.index(after: lastSlashIndex)...])
        } else {
            path = "/"
            name = fullName
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let formattedDate = ssmParameter.lastModifiedDate.map { dateFormatter.string(from: $0) } ?? "-"

        return ParameterStoreVariable(
            name: name,
            path: path,
            arn: ssmParameter.arn ?? "-",
            value: ssmParameter.value ?? "-",
            version: "\(ssmParameter.version)",
            lastModifiedDate: formattedDate,
            type: ssmParameter.type?.rawValue ?? "-",
            dataType: ssmParameter.dataType ?? "-"
        )
    }
}
