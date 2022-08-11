//
//  VideoPlayView.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import SwiftUI
import AVKit

struct VideoPlayView: View {
    var video: Video
    @State private var player = AVPlayer()
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // VideoPlayView가 나타났을 때 url 얻어서 플레이 시작
                if let link = video.videoFiles.first?.link {
                    player = AVPlayer(url: URL(string: link)!)
                    player.play()
                }
            }
    }
}


