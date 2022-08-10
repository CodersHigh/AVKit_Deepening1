//
//  VideoListView.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import SwiftUI

struct VideoListView: View {
    @ObservedObject var videoManager: VideoManager
    
    var columns = [GridItem(.adaptive(minimum: 160))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(videoManager.videos, id: \.id) { video in
                    NavigationLink {
                        // VideoView
                    } label: {
                        // Video Card
                        ZStack {
                            ZStack {
                                AsyncImage(url: URL(string: video.image)) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 160, height: 250)
                                        .cornerRadius(30)
                                } placeholder: {
                                    Rectangle()
                                        .foregroundColor(.gray.opacity(0.3))
                                        .frame(width: 160, height: 250)
                                        .cornerRadius(30)
                                }
                                Rectangle()
                                    .foregroundColor(.black.opacity(0.2))
                                    .frame(width: 160, height: 250)
                                    .cornerRadius(30)
                            }
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(50)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct VideoListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(videoManager: VideoManager())
    }
}
