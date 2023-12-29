//
//  File.swift
//  
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation

struct SingleKey<T: Codable>: Codable {
    let key: String
    let value: T
    
    init(value: T, forKey key: String) {
        self.key = key
        self.value = value
    }
    
    struct CodingKeys: CodingKey {
        let stringValue: String
        
        let intValue: Int? = nil
        
        init?(intValue: Int) {
            return nil
        }
        
        init(stringValue: String) {
            self.stringValue = stringValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .init(stringValue: key))
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let key = container.allKeys.first else {
            fatalError("Key Missing")
        }
        
        let value = try container.decode(T.self, forKey: key)
        
        self.key = key.stringValue
        self.value = value
    }
}
