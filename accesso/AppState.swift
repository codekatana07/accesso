//
//  AppState.swift .swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation
import Combine
import SwiftUI

//import SwiftUI
//import Foundation
//import Observation


enum AppScreen {
    case splash
    case roleSelection
    case teacherHome
    case studentHome
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var currentUserRole: UserRole? = nil
    @Published var goBackToSplash: Bool = false
    
    func navigateToRoleSelection() {
        withAnimation {
            self.currentScreen = .roleSelection
        }
    }
    
    func selectRole(_ role: UserRole) {
        self.currentUserRole = role
        withAnimation {
            switch role {
            case .teacher:
                self.currentScreen = .teacherHome
            case .student:
                self.currentScreen = .studentHome
            }
        }
    }
    
    // Navigates from Home Screens back to Role Selection
        func goBackToRoles() {
            self.currentUserRole = nil
            withAnimation {
                self.currentScreen = .roleSelection
            }
        }
    
    func logout() {
        //self.currentUserRole = nil
        withAnimation {
            //self.currentScreen = .roleSelection
            self.currentScreen = .splash
        }
    }
}
