//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

public struct OllamaModelAPI: OllamaAPI {
    public let config: Configuration
    public let model: String
    
    public init(model: String, config: Configuration) {
        self.model = model
        self.config = config
    }
    
    public func info() async throws -> OLModelInfo {
        let res = try await post(
            "/api/show",
            body: SingleKey(value: model, forKey: "name"),
            as: OLModelInfo.self
        )
        return res
    }
    
    public var chat: OllamaChatAPI {
        OllamaChatAPI(model: self)
    }
}
