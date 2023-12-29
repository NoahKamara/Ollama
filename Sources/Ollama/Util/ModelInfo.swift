//
//  File.swift
//  
//
//  Created by Noah Kamara on 27.12.23.
//

import Foundation

public struct OLModelInfo: Codable {
    public typealias Details = OLModelDetails
    
    public let license: String
    public let modelfile: String
    public let parameters: String
    public let template: String
    public let details: Details
    
    enum CodingKeys: String, CodingKey {
        case license
        case modelfile
        case parameters
        case template
        case details
    }
}
