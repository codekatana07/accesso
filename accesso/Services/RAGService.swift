//
//  RAGService.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation

class RAGService {
    static let shared = RAGService()
    
    private let baseURL = "http://127.0.0.1:8000"
    private let session = URLSession.shared
    
    private init() {}
    
    /// Sends a question to the RAG backend and retrieves the answer
    /// - Parameter question: The user's question
    /// - Returns: ChatResponse containing answer and sources
    func sendQuestion(_ question: String) async throws -> ChatResponse {
        guard let url = URL(string: "\(baseURL)/chat") else {
            throw RAGError.invalidURL
        }
        
        let request = ChatRequest(question: question)
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(request)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw RAGError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            let chatResponse = try decoder.decode(ChatResponse.self, from: data)
            return chatResponse
        case 400...499:
            throw RAGError.clientError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw RAGError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw RAGError.unknownError
        }
    }
}

enum RAGError: LocalizedError {
    case invalidURL
    case invalidResponse
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case decodingError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .invalidResponse:
            return "Invalid response from server"
        case .clientError(let statusCode):
            return "Client error: \(statusCode)"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .unknownError:
            return "Unknown error occurred"
        }
    }
}
