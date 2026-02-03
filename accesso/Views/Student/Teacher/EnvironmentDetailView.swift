//
//  EnvironmentDetailView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct EnvironmentDetailView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var environment: LearningEnvironment
    @State private var showCreateFolderDialog = false
    @State private var newFolderName: String = ""
    @State private var showFileUploader = false
    @State private var selectedFolderId: String? = nil
    
    init(environment: LearningEnvironment) {
        _environment = State(initialValue: environment)
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // Header
                HStack {
                    Button(action: { appState.backToTeacherHome() }) {
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
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                // Create Folder Button
                Button(action: { showCreateFolderDialog = true }) {
                    HStack {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 16))
                        Text("Create Folder")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(12)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                // Folders List
                if environment.folders.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "folder.dashed")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No Folders Yet")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Create a folder to start organizing your files")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.gray)
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach($environment.folders) { $folder in
                                FolderCard(
                                    folder: $folder,
                                    onUploadFile: { fileData, fileName in
                                        uploadFile(data: fileData, fileName: fileName, toFolderId: folder.id)
                                    },
                                    onDeleteFolder: {
                                        environment.deleteFolder(withID: folder.id)
                                    },
                                    onDeleteFile: { fileId in
                                        folder.deleteFile(withID: fileId)
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            
            // Create Folder Dialog
            if showCreateFolderDialog {
                CreateFolderDialogView(
                    isPresented: $showCreateFolderDialog,
                    onCreate: { folderName in
                        let newFolder = Folder(name: folderName)
                        environment.addFolder(newFolder)
                    }
                )
            }
        }
        .onDisappear {
            // Update the environment in appState
            if let index = appState.teacherEnvironments.firstIndex(where: { $0.id == environment.id }) {
                appState.teacherEnvironments[index] = environment
            }
        }
    }
    
    private func uploadFile(data: Data, fileName: String, toFolderId: String) {
        S3UploadService.shared.uploadPPTFile(data, fileName: fileName) { result in
            switch result {
            case .success(let s3Key):
                if let index = environment.folders.firstIndex(where: { $0.id == toFolderId }) {
                    let file = PPTFile(name: fileName, s3Key: s3Key)
                    environment.folders[index].addFile(file)
                }
            case .failure(let error):
                print("Upload failed: \(error.localizedDescription)")
            }
        }
    }
}

struct FolderCard: View {
    @Binding var folder: Folder
    let onUploadFile: (Data, String) -> Void
    let onDeleteFolder: () -> Void
    let onDeleteFile: (String) -> Void
    
    @State private var isExpanded = false
    @State private var showFileUploadPicker = false
    @State private var showDeleteConfirmation = false
    
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
                    // Upload Button
                    Button(action: { showFileUploadPicker = true }) {
                        HStack {
                            Image(systemName: "plus.circle.dashed")
                                .font(.system(size: 14))
                            Text("Upload PPT")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                    
                    // Files List
                    if folder.files.isEmpty {
                        Text("No files uploaded yet")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(8)
                    } else {
                        VStack(spacing: 8) {
                            ForEach(folder.files) { file in
                                HStack(spacing: 10) {
                                    Image(systemName: "doc.richtext.fill")
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
                                    
                                    Button(action: { onDeleteFile(file.id) }) {
                                        Image(systemName: "trash.fill")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(6)
                            }
                        }
                    }
                    
                    // Delete Folder Button
                    Button(action: { showDeleteConfirmation = true }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.caption)
                            Text("Delete Folder")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .foregroundColor(.red)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(12)
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .confirmationDialog("Delete Folder", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDeleteFolder()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete '\(folder.name)'? All files in this folder will be deleted.")
        }
        .fileImporter(
            isPresented: $showFileUploadPicker,
            allowedContentTypes: [.pdf, .presentation],
            onCompletion: { result in
                switch result {
                case .success(let url):
                    // Get the filename
                    let fileName = url.lastPathComponent
                    
                    // Read file data
                    if let data = try? Data(contentsOf: url) {
                        onUploadFile(data, fileName)
                    }
                    
                case .failure(let error):
                    print("File import error: \(error.localizedDescription)")
                }
            }
        )
    }
}

struct CreateFolderDialogView: View {
    @Binding var isPresented: Bool
    let onCreate: (String) -> Void
    
    @State private var folderName: String = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 15) {
                Text("Create New Folder")
                    .font(.headline)
                    .fontWeight(.bold)
                
                TextField("Enter folder name", text: $folderName)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                
                HStack(spacing: 15) {
                    Button("Cancel") {
                        isPresented = false
                        folderName = ""
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    
                    Button("Create") {
                        if !folderName.trimmingCharacters(in: .whitespaces).isEmpty {
                            onCreate(folderName.trimmingCharacters(in: .whitespaces))
                            isPresented = false
                            folderName = ""
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(folderName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding()
            }
            .frame(maxWidth: 320)
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

#Preview {
    EnvironmentDetailView(environment: LearningEnvironment(
        subject: "Mathematics",
        batch: "Batch 2024",
        teacherName: "John Doe"
    ))
    .environmentObject(AppState())
}
