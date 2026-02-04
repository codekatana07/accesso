//
//  S3FileService.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//


import Foundation

final class S3FileService {

    // 🔹 CHANGE THIS to your bucket
    private let baseURL = "https://eu-north-1.console.aws.amazon.com/s3/buckets/access29010?region=eu-north-1&tab=objects"

    func fetchNotes() -> [NoteFile] {
        let files = [
            "notes/math_notes.pdf",
            "notes/lecture_slides.pptx"
        ]

        return files.compactMap { path in
            guard let url = URL(string: "\(baseURL)/\(path)") else { return nil }
            return NoteFile(
                name: url.deletingPathExtension().lastPathComponent,
                url: url
            )
        }
    }

    func fetchVideos() -> [VideoFile] {
        let files = [
            "videos/intro.mp4",
            "videos/chapter1.mp4"
        ]

        return files.compactMap { path in
            guard let url = URL(string: "\(baseURL)/\(path)") else { return nil }
            return VideoFile(
                title: url.deletingPathExtension().lastPathComponent,
                url: url
            )
        }
    }
}
