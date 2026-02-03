//
//  StudentEnvironmentDetailView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI

struct StudentEnvironmentDetailView: View {
    @EnvironmentObject var appState: AppState
    
    let environment: LearningEnvironment
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack {
                    Button(action: { appState.backToStudentEnvironmentList() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                            Text("Back")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }
                
                // Environment Info
                VStack(alignment: .leading, spacing: 8) {
                    Text(environment.subject)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 15) {
                        Label(environment.batch, systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Label(environment.teacherName, systemImage: "person.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("(Read-only - Managed by \(environment.teacherName))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Folders List
                if environment.folders.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "folder.dashed")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No Folders Available")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("No learning materials have been added yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(environment.folders) { folder in
                                StudentFolderCardView(folder: folder)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }
            .padding(16)
        }
    }
}

struct StudentFolderCardView: View {
    let folder: Folder
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(spacing: 12) {
                    Image(systemName: isExpanded ? "folder.fill" : "folder")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                    
                    Text(folder.name)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("\(folder.files.count)")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(12)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                Divider()
                
                VStack(spacing: 10) {
                    if folder.files.isEmpty {
                        Text("No files in this folder")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(folder.files) { file in
                                StudentFileItemView(file: file)
                            }
                        }
                    }
                }
                .padding(12)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct StudentFileItemView: View {
    let file: PPTFile
    @State private var showPreview = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "doc.richtext.fill")
                .font(.system(size: 18))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("Uploaded: \(file.uploadedDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { showPreview = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "eye.fill")
                        .font(.caption)
                    Text("View")
                        .font(.caption)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(6)
        .sheet(isPresented: $showPreview) {
            PPTPreviewView(fileName: file.name, s3Key: file.s3Key)
        }
    }
}

struct PPTPreviewView: View {
    @Environment(\.dismiss) var dismiss
    let fileName: String
    let s3Key: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text(fileName)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Preview Content
                VStack(spacing: 20) {
                    Image(systemName: "doc.richtext.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    
                    VStack(spacing: 10) {
                        Text("PPT File Preview")
                            .font(.headline)
                        
                        Text(fileName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 15) {
                            Label("S3 Key: \(s3Key)", systemImage: "cloud.fill")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                    }
                    
                    Text("Full PPT viewer with AWS S3 integration coming soon")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        // TODO: Implement S3 file download and preview
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Download PPT")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    StudentEnvironmentDetailView(
        environment: LearningEnvironment(
            subject: "Mathematics",
            batch: "Batch 2024",
            teacherName: "John Doe"
        )
    )
    .environmentObject(AppState())
}
