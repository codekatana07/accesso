//
//  LearningEnvironment.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import Foundation

struct LearningEnvironment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var subject: String
    var batch: String
    var teacherName: String
    var createdDate: Date = Date()
    var folders: [Folder] = []
    
    mutating func addFolder(_ folder: Folder) {
        folders.append(folder)
    }
    
    mutating func deleteFolder(withID id: String) {
        folders.removeAll { $0.id == id }
    }
}

struct Folder: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var createdDate: Date = Date()
    var files: [PPTFile] = []
    
    mutating func addFile(_ file: PPTFile) {
        files.append(file)
    }
    
    mutating func deleteFile(withID id: String) {
        files.removeAll { $0.id == id }
    }
}

struct PPTFile: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var s3Key: String // S3 object key
    var uploadedDate: Date = Date()
}
