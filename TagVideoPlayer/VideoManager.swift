//
//  VideoManager.swift
//  TagVideoPlayer
//
//  Created by 이로운 on 2022/08/10.
//

import Foundation

enum Query {
    case mountain, sunset, beach, flowers, nature, forest, rain, food, sky, space
}

struct ResponseBody: Decodable {
    var videos: [Video]
    
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
}
