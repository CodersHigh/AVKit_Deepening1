# AVKit_Barebones
AVKit을 처음 접해 본다면 [이 리포지토리](https://github.com/CodersHigh/AVKit_Barebones)를 먼저 참고해 보세요. 로컬 비디오를 재생하는 방법을 배웁니다. ⭐️

<br/>
<br/>

### 프로젝트 소개
- AVKit의 기능 구현을 익히는 데에 도움을 주는 심화 프로젝트입니다.
- AVKit을 통해 **SwiftUI 기반의 (비디오 API를 활용해) 비디오를 받아와 재생하는 앱**을 구현합니다.

https://user-images.githubusercontent.com/74223246/184056603-0ab0b1c0-7e1d-45e1-8d48-b914eb78a1cb.MP4

<br/>
<br/>

### 핵심 코드
비디오 API를 통해 비디오를 받아오고 재생하는 코드를 참고하세요. 

<br/>

**비디오 받아오기**
```Swift
// 선택한 query가 변경될 때마다 호출하여, 해당 query에 맞는 비디오를 불러오는 메소드
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
        }
            
    } catch {
        print("Error fetching data from Pexels: \(error)")
    }
}
```

<br/>

**비디오 재생하기**
```Swift
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
```
