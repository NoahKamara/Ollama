//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

public struct ChatMessage: Codable {
    public enum CodingKeys: CodingKey {
        case role
        case content
    }
    
    public let role: ChatRole
    public var content: String
    
    public init(role: ChatRole, content: String) {
        self.role = role
        self.content = content
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.role, forKey: .role)
        try container.encode(self.content, forKey: .content)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.role = try container.decode(ChatRole.self, forKey: .role)
        self.content = try container.decode(String.self, forKey: .content)
    }
}

