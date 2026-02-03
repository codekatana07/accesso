//
//  RoleSelectionView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation

import SwiftUI

struct RoleSelectionView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Left Back Button
                HStack {
                    Button(action: {
                        appState.goBackToRoles()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.secondary)
                            .padding(10)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                // Main Content
                VStack(spacing: 40) {
                    VStack(spacing: 10) {
                        Text("Select Your Role")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Choose how you want to use Acceso")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 30) {
                        RoleButton(
                            title: "Teacher",
                            icon: "graduationcap.fill",
                            color: .blue
                        ) {
                            appState.selectRole(.teacher)
                        }
                        
                        RoleButton(
                            title: "Student",
                            icon: "person.2.fill",
                            color: .green
                        ) {
                            appState.selectRole(.student)
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct RoleButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 15) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(width: 180, height: 180)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(radius: 5)
        }
        .buttonStyle(.plain)
    }
}
