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
    
    public func get(messages: [Message] = [], format: ChatRequest.Format? = nil) async throws -> Response {
        let request = Request(
            model: model,
            messages: messages,
            format: format
        )
        
        let stream = try await stream("/api/chat", body: request, as: Response.self)
        
        var response: Response? = nil
        
        for try await res in stream {
            guard response != nil else {
                response = res
                continue
            }
            
            response?.message.content += res.message.content
        }
        
        guard let response else {
            fatalError("This shouldnt happen whoops")
        }
        
        return response
    }
    
    
    
    public func stream(messages: [Message] = [], format: ChatRequest.Format? = nil) async throws -> AsyncThrowingStream<Response, any Error> {
        let request = Request(
            model: model,
            messages: messages,
            format: format
        )
        
        return try await stream("/api/chat", body: request, as: Response.self)
    }
}
