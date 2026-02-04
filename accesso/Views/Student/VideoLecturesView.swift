import SwiftUI
import AVKit

struct VideoLecturesView: View {
    let environment: LearningEnvironment

    private let service = S3FileService()

    var body: some View {
        let videos = service.fetchVideos()

        List(videos) { video in
            NavigationLink {
                VideoPlayerView(videoURL: video.url)
            } label: {
                HStack {
                    Image(systemName: "play.circle.fill")
                        .foregroundColor(.blue)

                    Text(video.title)
                }
            }
        }
        .navigationTitle("Lectures")
    }
}
