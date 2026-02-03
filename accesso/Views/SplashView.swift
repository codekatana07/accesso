//
//  SplashView.swift .swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//


import Foundation
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var isAnimating = false
    @State private var opacity = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            
            VStack(spacing: 20) {
                Text("ACCESO")
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .foregroundColor(.blue)
                
                Text("Every Slide Becomes a Teacher")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            // 1. Run Animation
            withAnimation(.easeOut(duration: 1.0)) {
                self.opacity = 1.0
                self.scale = 1.0
            }
            
            // 2. Navigate after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                appState.navigateToRoleSelection()
            }
        }
    }
}
