//
//  TeacherHomeView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation
import SwiftUI

struct TeacherHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCreateEnvironmentPopup = false

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header with Back Button
                HStack {
                    Button(action: {
                        appState.goBackToRoles()
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
                }
                .padding(.bottom, 10)
                
                // Main Dashboard Content
                HStack {
                    VStack(alignment: .leading) {
                        Text("Teacher Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Manage your environments")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                // Create Environment Button
                Button(action: { showCreateEnvironmentPopup = true }) {
                    HStack {
                        Image(systemName: "plus.square.dashed")
                            .font(.system(size: 20))
                        Text("Create Environment")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                // Environments List
                if appState.teacherEnvironments.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No Environments Yet")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Create your first environment to get started")
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
                                EnvironmentCard(
                                    environment: environment,
                                    onTap: {
                                        appState.navigateToEnvironmentDetail(environment)
                                    },
                                    onDelete: {
                                        appState.deleteEnvironment(withID: environment.id)
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            
            // Popup
            if showCreateEnvironmentPopup {
                CreateEnvironmentPopupView(isPresented: $showCreateEnvironmentPopup)
                    .environmentObject(appState)
            }
        }
    }
}

struct EnvironmentCard: View {
    let environment: LearningEnvironment
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteConfirmation = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
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
            }
            .buttonStyle(.plain)
            
            Divider()
            
            HStack(spacing: 0) {
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 14))
                        Text("Delete")
                            .font(.caption)
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .confirmationDialog("Delete Environment", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(environment.subject)'? This action cannot be undone.")
        }
    }
}

#Preview {
    TeacherHomeView()
        .environmentObject(AppState())
}
