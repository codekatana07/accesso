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
                        Text("Teacher Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Manage your classrooms and lectures")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    DashboardButton(title: "Create Environment", icon: "plus.square.dashed")
                    DashboardButton(title: "View Lectures", icon: "list.bullet.rectangle.portrait")
                }
                
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
        Button(action: {
            print("\(title) tapped")
        }) {
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
        .buttonStyle(.plain)
    }
}
