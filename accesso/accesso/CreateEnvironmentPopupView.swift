//
//  CreateEnvironmentPopupView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI

struct CreateEnvironmentPopupView: View {
    @EnvironmentObject var appState: AppState
    @Binding var isPresented: Bool
    
    @State private var subject: String = ""
    @State private var batch: String = ""
    @State private var teacherName: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var isFormValid: Bool {
        !subject.trimmingCharacters(in: .whitespaces).isEmpty &&
        !batch.trimmingCharacters(in: .whitespaces).isEmpty &&
        !teacherName.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    // Dismiss on background tap
                    isPresented = false
                }
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Create New Environment")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                // Form Fields
                VStack(spacing: 15) {
                    // Subject Field
                    VStack(alignment: .leading, spacing: 5) {
                        Label("Subject", systemImage: "book.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter subject name", text: $subject)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 5)
                    }
                    
                    // Batch Field
                    VStack(alignment: .leading, spacing: 5) {
                        Label("Batch", systemImage: "calendar")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter batch (e.g., Batch 2024)", text: $batch)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 5)
                    }
                    
                    // Teacher Name Field
                    VStack(alignment: .leading, spacing: 5) {
                        Label("Teacher Name", systemImage: "person.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter your name", text: $teacherName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 5)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Error Message
                if showError {
                    HStack {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                
                Spacer()
                
                // Action Buttons
                HStack(spacing: 15) {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: createEnvironment) {
                        Text("Create")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .disabled(!isFormValid)
                }
                .padding()
            }
            .frame(maxWidth: 400)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(20)
        }
    }
    
    private func createEnvironment() {
        // Validate form
        if !isFormValid {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
        
        // Create environment
        appState.createEnvironment(
            subject: subject.trimmingCharacters(in: .whitespaces),
            batch: batch.trimmingCharacters(in: .whitespaces),
            teacherName: teacherName.trimmingCharacters(in: .whitespaces)
        )
        
        // Close popup
        isPresented = false
    }
}

#Preview {
    CreateEnvironmentPopupView(isPresented: .constant(true))
        .environmentObject(AppState())
}
