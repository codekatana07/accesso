//
//  StudentEnvironmentListView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI

struct StudentEnvironmentListView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack {
                    Button(action: { appState.backToStudentHome() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("Back")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("My Environments")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Read-only access to your study materials")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                // Environments List
                if appState.teacherEnvironments.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "folder.badge.questionmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No Environments Available")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Your teachers haven't created any environments yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(appState.teacherEnvironments) { environment in
                                StudentEnvironmentCardView(
                                    environment: environment,
                                    onTap: {
                                        appState.navigateToStudentEnvironmentDetail(environment)
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}

struct StudentEnvironmentCardView: View {
    let environment: LearningEnvironment
    let onTap: () -> Void
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(environment.subject)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    HStack(spacing: 10) {
                        Label(environment.batch, systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label(environment.teacherName, systemImage: "person.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Created: \(dateFormatter.string(from: environment.createdDate))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .center, spacing: 5) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                    
                    Text("\(environment.folders.count)")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StudentEnvironmentListView()
        .environmentObject(AppState())
}
