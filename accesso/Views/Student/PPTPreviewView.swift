import SwiftUI

struct PPTPreviewView: View {
    @Environment(\.dismiss) var dismiss

    let fileName: String
    let s3Key: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "doc.richtext.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)

                Text(fileName)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("S3 Key:")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(s3Key)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding()
            .navigationTitle("PPT Preview")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PPTPreviewView(
        fileName: "Sample PPT",
        s3Key: "sample/s3/key.pptx"
    )
}
