//
//  StudentHomeView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation
import SwiftUI




struct StudentHomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showRAGChat = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
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
                        Text("Student Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Access your learning materials")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        appState.navigateToStudentEnvironments()
                    }) {
                        DashboardButton(title: "My Environments", icon: "folder.fill")
                    }
                    .buttonStyle(.plain)
                    
//                    NavigationLink(isActive: $showRAGChat) {
//                        RAGChatView()
//                    } label: {
//                        Button(action: {
//                            showRAGChat = true
//                        }) {
//                            DashboardButton(title: "Ask from Notes", icon: "sparkles")
//                        }
//                        .buttonStyle(.plain)
//                    }
                }
                // Quick Actions
            
                
//                HStack(spacing: 20) {
//                    DashboardButton(title: "View Lectures", icon: "play.tv.fill")
//                    
//                    Spacer()
//                }
//                
                Spacer()
            }
            .padding(40)
        }
    }
}

struct DashboardButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
            Text(title)
                .fontWeight(.medium)
        }
        .frame(width: 160, height: 120)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    StudentHomeView()
        .environmentObject(AppState())
}
