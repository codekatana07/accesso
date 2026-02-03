//
//  AppState.swift .swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation
import Combine
import SwiftUI

enum AppScreen {
    case splash
    case roleSelection
    case teacherHome
    case teacherEnvironmentDetail(LearningEnvironment)
    case studentHome
    case studentEnvironmentList
    case studentEnvironmentDetail(LearningEnvironment)
}

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var currentUserRole: UserRole? = nil
    @Published var goBackToSplash: Bool = false
    @Published var teacherEnvironments: [LearningEnvironment] = []
    @Published var selectedEnvironment: LearningEnvironment? = nil
    
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
    
    func goBackToRoles() {
        self.currentUserRole = nil
        withAnimation {
            self.currentScreen = .roleSelection
        }
    }
    
    func logout() {
        withAnimation {
            self.currentScreen = .splash
        }
    }
    
    func createEnvironment(subject: String, batch: String, teacherName: String) {
        let newEnvironment = LearningEnvironment(
            subject: subject,
            batch: batch,
            teacherName: teacherName
        )
        teacherEnvironments.append(newEnvironment)
    }
    
    func deleteEnvironment(withID id: String) {
        teacherEnvironments.removeAll { $0.id == id }
    }
    
    func navigateToEnvironmentDetail(_ environment: LearningEnvironment) {
        self.selectedEnvironment = environment
        withAnimation {
            self.currentScreen = .teacherEnvironmentDetail(environment)
        }
    }
    
    func navigateToStudentEnvironments() {
        withAnimation {
            self.currentScreen = .studentEnvironmentList
        }
    }
    
    func navigateToStudentEnvironmentDetail(_ environment: LearningEnvironment) {
        self.selectedEnvironment = environment
        withAnimation {
            self.currentScreen = .studentEnvironmentDetail(environment)
        }
    }
    
    func backToStudentHome() {
        withAnimation {
            self.currentScreen = .studentHome
        }
    }
    
    func backToStudentEnvironmentList() {
        withAnimation {
            self.currentScreen = .studentEnvironmentList
        }
    }
    
    func backToTeacherHome() {
        withAnimation {
            self.currentScreen = .teacherHome
        }
    }
}
