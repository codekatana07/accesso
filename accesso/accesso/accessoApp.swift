//
//  accessoApp.swift
//  accesso
//
//  Created by KIET55 on 03/02/26.
//

//import SwiftUI
//
//@main
//struct accessoApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
import SwiftUI
import Foundation

@main
struct accessoApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            Group {
                
                switch appState.currentScreen {
                case .splash:
                    SplashView()
                case .roleSelection:
                    RoleSelectionView()
                case .teacherHome:
                    TeacherHomeView()
                case .studentHome:
                    StudentHomeView()
                }
            }
            .environmentObject(appState)
            .background(Color(.systemBackground))
        }
    }
}






