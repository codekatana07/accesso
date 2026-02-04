import SwiftUI

struct StudentNotesView: View {
    let environment: LearningEnvironment

    private let service = S3FileService()
    @State private var selectedFile: NoteFile?

    var body: some View {
        let notes = service.fetchNotes()

        List(notes) { file in
            Button {
                selectedFile = file
            } label: {
                HStack {
                    Image(systemName: file.icon)
                        .foregroundColor(.blue)

                    Text(file.name)

                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Notes")
        .sheet(item: $selectedFile) { file in
            QuickLookPreview(url: file.url)
        }
    }
}
