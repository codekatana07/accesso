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
    @State private var goToNotes = false
    @State private var goToLectures = false
    @State private var goToRAG = false


    var body: some View {
        NavigationStack{
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    
                    // MARK: - Header
                    HStack {
                        Button(action: {
                            appState.backToStudentEnvironmentList()
                        }) {
                            HStack(spacing: 6) {
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
                        
                        Spacer()
                        
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                    
                    // MARK: - Course Details Box
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
                        
                        Text("(Read-only · Managed by \(environment.teacherName))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                    
                    // MARK: - Notes Section
                    SectionActionButton(
                        title: "Notes",
                        subtitle: "View available study materials",
                        icon: "folder.fill"
                    ) {
                        goToNotes = true
                    }
                    .navigationDestination(isPresented: $goToNotes) {
                        StudentNotesView(environment: environment)
                    }

                    // MARK: - Video Lectures Section
                    SectionActionButton(
                        title: "Lectures",
                        subtitle: "Watch recorded lectures",
                        icon: "play.tv.fill"
                    ) {
                        goToLectures = true
                    }
                    .navigationDestination(isPresented: $goToLectures) {
                        VideoLecturesView(environment: environment)
                    }

                    // MARK: - Ask From Notes (RAG)
                    SectionActionButton(
                        title: "Ask from Notes",
                        subtitle: "Ask questions using AI",
                        icon: "sparkles"
                    ) {
                        goToRAG = true
                    }
                    .navigationDestination(isPresented: $goToRAG) {
                        RAGChatView()
                    }

                    
                    // MARK: - Notes / Folder List
                    //                if environment.folders.isEmpty {
                    //                    VStack(spacing: 14) {
                    //                        Image(systemName: "folder.dashed")
                    //                            .font(.system(size: 40))
                    //                            .foregroundColor(.gray)
                    //
                    //                        Text("No Notes Available")
                    //                            .font(.headline)
                    //
                    //                        Text("No study material has been added yet")
                    //                            .font(.caption)
                    //                            .foregroundColor(.secondary)
                    //                    }
                    //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                } else {
                    //                    ScrollView {
                    //                        VStack(spacing: 10) {
                    //                            ForEach(environment.folders) { folder in
                    //                                StudentFolderCardView(folder: folder)
                    //                            }
                    //                        }
                    //                        .padding(.vertical, 5)
                    //                    }
                    //                }
                    
                    Spacer()
                    
                }
                .padding(16)
            }
        }
    }
}

//
// MARK: - Section Action Button
//
struct SectionActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(14)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

//
// MARK: - Folder Card
//
struct StudentFolderCardView: View {
    let folder: Folder
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation { isExpanded.toggle() }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: isExpanded ? "folder.fill" : "folder")
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

                VStack(spacing: 8) {
                    if folder.files.isEmpty {
                        Text("No files in this folder")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(folder.files) { file in
                            StudentFileItemView(file: file)
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

//
// MARK: - File Item
//
struct StudentFileItemView: View {
    let file: PPTFile
    @State private var showPreview = false

    var body: some View {
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

            Button("View") {
                showPreview = true
            }
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(6)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(6)
        .sheet(isPresented: $showPreview) {
            PPTPreviewView(fileName: file.name, s3Key: file.s3Key)
        }
    }
}

//
// MARK: - Preview
//
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
