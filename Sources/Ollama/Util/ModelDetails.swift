//
//  File.swift
//  
//
//  Created by Noah Kamara on 27.12.23.
//

import Foundation

public struct OLModelDetails: Codable {
    public let format: String
    public let family: String
    public let families: [String]?
    public let parameterSize: String
    public let quantizationLevel: String
    
    enum CodingKeys: String, CodingKey {
        case format
        case family
        case families
        case parameterSize = "parameter_size"
        case quantizationLevel = "quantization_level"
    }
}
