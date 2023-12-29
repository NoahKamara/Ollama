//
//  File.swift
//  
//
//  Created by Noah Kamara on 26.12.23.
//

import Foundation

// MARK: - Model
public struct OLModel: Codable {
    public typealias Details = OLModelDetails
    public let name: String
    public let modifiedAt: String
    public let size: Int
    public let digest: String
    public let details: Details
    
    enum CodingKeys: String, CodingKey {
        case name
        case modifiedAt = "modified_at"
        case size
        case digest
        case details
    }
}


