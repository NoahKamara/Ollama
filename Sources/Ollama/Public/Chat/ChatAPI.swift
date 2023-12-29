//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

public struct OllamaChatAPI: OllamaAPI {
    public typealias Request = ChatRequest
    public typealias Response = ChatResponse
    public typealias Message = ChatMessage
    public typealias Role = ChatRole
    
    public let model: String
    public let config: Configuration
    
    init(model: OllamaModelAPI) {
        self.config = model.config
        self.model = model.model
    }
    
    public func get(messages: [Message] = []) async throws -> Response {
        let request = Request(
            model: model,
            messages: messages
        )
        
        let stream = try await stream("/api/chat", body: request, as: Response.self)
        
        let res = try await stream.reduce(Response?.none) { partialResult, response in
            guard var result = partialResult else {
                return response
            }
            
            result.message.content += response.message.content
            
            return result
        }
        
        guard let res else {
            fatalError("This shouldnt happen whoops")
        }
        
        return res
    }
    
    public func stream(messages: [Message] = []) async throws -> AsyncThrowingStream<Response, any Error> {
        let request = Request(
            model: model,
            messages: messages
        )
        
        return try await stream("/api/chat", body: request, as: Response.self)
    }
}
