//
//  QueryListView.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import SwiftUI

struct QueryListView: View {
    @ObservedObject var videoManager: VideoManager
    
    // 쿼리 이름을 한글로 번역한 title 얻기
    func getTitle(query: Query) -> String {
        switch query {
        case .mountain: return "산"
        case .sunset: return "일몰"
        case .beach: return "해변"
        case .flowers: return "꽃"
        case .forest: return "산"
        case .rain: return "비"
        case .food: return "음식"
        case .sky: return "하늘"
        case .space: return "우주"
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 20) {
                ForEach(Query.allCases, id: \.self) { query in
                    // 쿼리 버튼
                    ZStack {
                        ZStack {
                            Image(uiImage: UIImage(named: query.rawValue)!)
                                .resizable()
                                .cornerRadius(55)
                                .frame(width: 55, height: 55)
                            Rectangle()
                                .cornerRadius(55)
                                .foregroundColor(.black.opacity(0.5))
                        }
                        Text(getTitle(query: query))
                            .font(.subheadline).bold()
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        videoManager.selectedQuery = query
                    }
                }
            }
            .padding(20)
        }
        .frame(height: 80)
    }
}

struct QueryListView_Previews: PreviewProvider {
    static var previews: some View {
        QueryListView(videoManager: VideoManager())
    }
}
