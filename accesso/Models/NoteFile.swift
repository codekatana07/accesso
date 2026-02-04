import Foundation

struct NoteFile: Identifiable {
    let id = UUID()
    let name: String
    let url: URL

    var icon: String {
        url.pathExtension.lowercased() == "pdf"
        ? "doc.richtext.fill"
        : "chart.bar.doc.horizontal.fill"
    }
}
