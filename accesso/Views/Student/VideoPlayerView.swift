//
//  VideoPlayerView.swift
//  accesso
//
//  Created by KIET55 on 04/02/26.
//


import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: URL

    var body: some View {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .navigationTitle("Video")
            .navigationBarTitleDisplayMode(.inline)
    }
}
