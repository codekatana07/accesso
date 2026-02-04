//
//  RAGChatView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI

struct RAGChatView: View {
    @Environment(\.dismiss) var dismiss
    @State private var question: String = ""
    @State private var answer: String? = nil
    @State private var sources: [String] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var hasAnswered: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("Back")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.secondary)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("Ask from Notes")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .padding(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(16)
                .borderBottom()
                
                // Main Content
                VStack(spacing: 20) {
                    // Question Input Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Question")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $question)
                            .frame(height: 120)
                            .padding(12)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .disabled(isLoading)
                    }
                    
                    // Ask Button
                    Button(action: {
                        askQuestion()
                    }) {
                        if isLoading {
                            HStack(spacing: 8) {
                                ProgressView()
                                    .tint(.white)
                                Text("Loading...")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(8)
                        } else {
                            Text("Ask")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .disabled(isLoading || question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    // Answer Section
                    if hasAnswered {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Answer")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    if let answer = answer {
                                        Text(answer)
                                            .lineSpacing(4)
                                            .textSelection(.enabled)
                                    }
                                    
                                    if !sources.isEmpty {
                                        Divider()
                                            .padding(.vertical, 8)
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Sources")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.secondary)
                                            
                                            VStack(alignment: .leading, spacing: 6) {
                                                ForEach(sources, id: \.self) { source in
                                                    HStack(spacing: 8) {
                                                        Image(systemName: "doc.fill")
                                                            .font(.caption)
                                                            .foregroundColor(.blue)
                                                        
                                                        Text(source)
                                                            .font(.caption)
                                                            .lineLimit(2)
                                                    }
                                                    .padding(8)
                                                    .background(Color.gray.opacity(0.05))
                                                    .cornerRadius(6)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(12)
                            }
                            .frame(maxHeight: 300)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Error Message
                    if let errorMessage = errorMessage {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                Text("Error")
                                    .fontWeight(.semibold)
                            }
                            Text(errorMessage)
                                .font(.caption)
                                .lineLimit(3)
                        }
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding(16)
                .scrollable()
            }
        }
    }
    
    private func askQuestion() {
        let trimmedQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuestion.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        hasAnswered = false
        
        Task {
            do {
                let response = try await RAGService.shared.sendQuestion(trimmedQuestion)
                answer = response.answer
                sources = response.sources ?? []
                hasAnswered = true
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

// Helper view modifier for border bottom
struct BorderBottom: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Divider()
        }
    }
}

extension View {
    func borderBottom() -> some View {
        modifier(BorderBottom())
    }
    
    func scrollable() -> some View {
        ScrollView {
            self
        }
    }
}

#Preview {
    RAGChatView()
}
