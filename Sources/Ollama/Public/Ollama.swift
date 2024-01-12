// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol OllamaAPI {
    typealias Configuration = OllamaConfiguration
    var config: Configuration { get }
}

public struct OllamaConfiguration {
    public let baseURI: URL
    
    public init(baseURI: URL) {
        self.baseURI = baseURI
    }
}


public struct Ollama: OllamaAPI {
    public let config: Configuration
    
    public static let `default` = Ollama(baseURI: URL(string: "http://localhost:11434")!)
    public init(config: Configuration) {
        self.config = config
    }
    
    public init(baseURI: URL) {
        self.init(config: .init(baseURI: baseURI))
    }
    
    public func models() async throws -> [OLModel] {
        let res = try await get("/api/tags", as: SingleKey<[OLModel]>.self)
        return res.value
    }
    
    public func model(_ name: String) -> OllamaModelAPI {
        OllamaModelAPI(model: name, config: config)
    }
}



extension OllamaAPI {
    private func decodeResponse<T: Decodable>(_ data: Data, as type: T.Type = T.self) throws -> T {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            try! data.write(to: URL(filePath: "/Users/noahkamara/Downloads/test.txt"))
            print("STRING", String(data: data, encoding: .utf8)!)
            print(error)
            throw error
        }
    }
    
    func get<T: Decodable>(_ path: String, as type: T.Type = T.self) async throws -> T {
        let url = config.baseURI.appending(path: path)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try decodeResponse(data, as: T.self)
        return response
    }
    
    func stream<Body: Encodable, T: Decodable>(
        _ path: String,
        body: Body,
        as type: T.Type = T.self
    ) async throws -> AsyncThrowingStream<T,Error> {
        let url = config.baseURI.appending(path: path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(body)
        urlRequest.httpBody = bodyData
        
        return AsyncThrowingStream<T,Error> { continuation in
            let session = StreamingSession<T,OllamaError>(urlRequest: urlRequest)
            session.onReceiveContent = { session, res in
                continuation.yield(res)
            }
            
            session.onComplete = { session, error in
                if let error {
                    continuation.finish(throwing: error)
                } else {
                    continuation.finish()
                }
            }
            
            session.onProcessingError = { session, err in
                continuation.finish(throwing: err)
            }
            
//            continuation.onTermination = { @Sendable cont in
//                print("close session")
//            }
            
            session.perform()
        }
    }
    
    func post<Body: Encodable, T: Decodable>(
        _ path: String,
        body: Body,
        as type: T.Type = T.self
    ) async throws -> T {
        let url = config.baseURI.appending(path: path)
        print("URL", url)
        var request = URLRequest(url: URL(string: "http://localhost:11434"+path)!)
        request.httpMethod = "POST"
        
        let bodyData = try JSONEncoder().encode(body)
        
        request.httpBody = bodyData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, res) = try await URLSession.shared.data(for: request)
        do {
            let response = try decodeResponse(data, as: T.self)
            return response
        } catch {
            let res = res as! HTTPURLResponse
            print(res.statusCode)
            throw error
        }
    }
}
