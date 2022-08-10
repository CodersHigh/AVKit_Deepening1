//
//  ContentView.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject var videoManager = VideoManager()
    
    var body: some View {
        VStack(spacing: 0) {
            QueryListView(videoManager: videoManager)
            VideoListView(videoManager: videoManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
