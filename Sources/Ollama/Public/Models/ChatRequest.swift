//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

public enum OllamaResponseFormat: String, Codable {
    case json
}

public struct ChatRequest: Encodable {
    public typealias Format = OllamaResponseFormat
    public typealias Message = ChatMessage
    
    public let model: String
    public let template: String?
    public let messages: [Message]
    public let format: Format?
    
    public init(
        model: String,
        template: String? = nil,
        messages: [Message],
        format: Format? = nil
    ) {
        self.model = model
        self.template = template
        self.messages = messages
        self.format = format
    }
}
