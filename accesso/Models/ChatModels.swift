//
//  ChatModels.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation

struct ChatRequest: Codable {
    let question: String
}

struct ChatResponse: Codable {
    let answer: String
    let sources: [String]?
    
    enum CodingKeys: String, CodingKey {
        case answer
        case sources
    }
}
