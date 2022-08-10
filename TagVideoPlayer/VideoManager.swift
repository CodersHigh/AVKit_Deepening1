//
//  VideoManager.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import Foundation

// MARK: - Query

enum Query: String, CaseIterable {
    case mountain, sunset, beach, flowers, forest, rain, food, sky, space
}

// MARK: - ResponseBody

struct ResponseBody: Decodable {
    var videos: [Video]
}

struct Video: Decodable {
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Decodable {
        var name: String
    }
    
    struct VideoFile: Decodable {
        var link: String
    }
}

// MARK: - VideoManager

class VideoManager: ObservableObject {
    @Published var videos: [Video] = []
    @Published var selectedQuery: Query = Query.beach {
        didSet {
            Task.init {
                await fetchVideo(query: selectedQuery)
            }
        }
    }
    
    init() {
        Task.init {
            await fetchVideo(query: selectedQuery)
        }
    }
    
    // 선택한 query에 맞는 비디오를 불러오는 메소드
    func fetchVideo(query: Query) async {
        do {
            // 비디오 검색 URL 구하기
            guard let seachVideoURL = URL(string: "https://api.pexels.com/videos/search?query=\(query)&per_page=10&orientation=portrait") else {
                fatalError("Missing seachVideoURL")
            }
            
            // API 키 URL 구하기
            guard let searchAPIKEYURL = Bundle.main.url(forResource: "PexelsInfo", withExtension: "plist") else {
                fatalError("Missing searchAPIKEYURL")
            }
            guard let dictionary = NSDictionary(contentsOf: searchAPIKEYURL) else {
                fatalError("Missing dictionary")
            }
            let APIKEY = dictionary["API_KEY"] as? String
            
            // 구한 URL을 활용하여 URLRequest 생성하기
            var urlRequest = URLRequest(url: seachVideoURL)
            urlRequest.setValue(APIKEY, forHTTPHeaderField: "Authorization")
            
            // URLRequest를 통해 데이터 불러오기
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("Error while fetching data")
            }
            
            // 데이터 디코딩하기 (사용할 수 있는 형태로 변환)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            // Published 변수인 videos 업데이트하기
            DispatchQueue.main.async {
                self.videos = []
                self.videos = decodedData.videos
                print(self.videos)
            }
            
        } catch {
            print("Error fetching data from Pexels: \(error)")
        }
    }
    
}
