//
//  accessoApp.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI

@main
struct accessoApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                switch appState.currentScreen {
                case .splash:
                    SplashView()
                case .roleSelection:
                    RoleSelectionView()
                case .teacherHome:
                    TeacherHomeView()
                case .teacherEnvironmentDetail(let environment):
                    EnvironmentDetailView(environment: environment)
                case .studentHome:
                    StudentHomeView()
                case .studentEnvironmentList:
                    StudentEnvironmentListView()
                case .studentEnvironmentDetail(let environment):
                    StudentEnvironmentDetailView(environment: environment)
                }
            }
            .environmentObject(appState)
        }
    }
}
