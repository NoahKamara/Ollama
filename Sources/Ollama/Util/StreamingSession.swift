//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation



final class StreamingSession<ResultType: Decodable, ErrorType: Decodable>: NSObject, Identifiable, URLSessionDelegate, URLSessionDataDelegate {
        
    enum StreamingError: Error {
        case unknownContent
        case emptyContent
        case decoded(ErrorType)
    }
    
    var onReceiveContent: ((StreamingSession, ResultType) -> Void)?
    var onProcessingError: ((StreamingSession, Error) -> Void)?
    var onComplete: ((StreamingSession, Error?) -> Void)?
    
    let decoder: JSONDecoder
    private let streamingCompletionMarker = "[DONE]"
    private let urlRequest: URLRequest
    private lazy var urlSession: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        return session
    }()
    
    private var previousChunkBuffer = ""
    
    init(urlRequest: URLRequest, decoder: JSONDecoder? = nil) {
        self.urlRequest = urlRequest
        
        if let decoder {
            self.decoder = decoder
        } else {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            self.decoder = decoder
        }
    }
    
    func perform() {
        self.urlSession
            .dataTask(with: self.urlRequest)
            .resume()
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onComplete?(self, error)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        do {
            let object = try decoder.decode(ResultType.self, from: data)
            onReceiveContent?(self, object)
        } catch let decodingError {
            do {
                let error = try decoder.decode(ErrorType.self, from: data)
                onProcessingError?(self,StreamingError.decoded(error))
            } catch {
                onProcessingError?(self,decodingError)
            }
        }
    }
    
}


struct OllamaError: Decodable {
    let error: String
}
