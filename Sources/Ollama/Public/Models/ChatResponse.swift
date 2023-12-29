//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

public struct ChatResponse: Decodable {
    public typealias Message = ChatMessage
    
    public let model: String
    public let createdAt: String
    public var message: Message
    
    public let done: Bool
    public let totalDuration: Int?
    public let loadDuration: Int?
    public let promptEvalCount: Int?
    public let promptEvalDuration: Int?
    public let evalCount: Int?
    public let evalDuration: Int?
    
    enum CodingKeys: String, CodingKey {
        case model
        case createdAt = "created_at"
        case message
        case done
        case totalDuration = "total_duration"
        case loadDuration = "load_duration"
        case promptEvalCount = "prompt_eval_count"
        case promptEvalDuration = "prompt_eval_duration"
        case evalCount = "eval_count"
        case evalDuration = "eval_duration"
    }
}
