//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation


public struct ChatRequest: Encodable {
    typealias Message = ChatMessage
    
    let model: String
    let template: String?
    let messages: [Message]
    //    let format: String = "json"
    
    init(
        model: String,
        template: String? = nil,
        messages: [Message]
    ) {
        self.model = model
        self.template = template
        self.messages = messages
    }
}
