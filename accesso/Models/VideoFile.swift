import Foundation

struct VideoFile: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}
