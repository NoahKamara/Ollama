import XCTest
@testable import Ollama

final class OllamaTests: XCTestCase {
    let config = OllamaConfiguration(
        baseURI: URL(string: "http://localhost:11434")!
    )
    
    func testListModels() async throws {
        let client = Ollama(config: config)
        let models = try await client.models()
        
        XCTAssert(!models.isEmpty)
    }
    
    func testModelInfo() async throws {
        let client = Ollama(config: config)
        let model = try await client.model("llama2:latest").info()
        
        XCTAssertEqual(model.details.family, "llama")
    }
    
    func testChatStream() async throws {
        let client = Ollama(config: config)
        let chat = client.model("llama2:latest").chat
        
        let response = try await chat.stream(messages: [
            ChatMessage(role: .user, content: "Who has the high ground?")
        ])
        
        var fullContent = ""
        
        for try await res in response {
            fullContent += res.message.content
        }
        
        XCTAssert(!fullContent.isEmpty)
    }
    
    func testChatComplete() async throws {
        let client = Ollama(config: config)
        let chat = client.model("llama2:latest").chat
        
        let res = try await chat.get(messages: [
            ChatMessage(role: .user, content: "write a swift, python and javascript function converting a template string where {TEMPLATE_VALUE} is a value using the provided parameters in dictionary form")
        ])
        
        print("RES", res)
    }
}
