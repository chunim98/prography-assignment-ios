//
//  NetworkManager.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import Foundation

import RxSwift
import RxCocoa

final class NetworkManager {
    static let shered = NetworkManager()
    private let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""

    private init() {}
    
    // MARK: Methods
    
//    func fetchNowPlaying() async throws -> NowPlaying {
//        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing")!
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        let queryItems: [URLQueryItem] = [
//          URLQueryItem(name: "language", value: "ko"),
//          URLQueryItem(name: "page", value: "1"),
//        ]
//        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//
//        var request = URLRequest(url: components.url!)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        request.allHTTPHeaderFields = [
//          "accept": "application/json",
//          "Authorization": "Bearer " + apiKey
//        ]
//
//        let (data, _) = try await URLSession.shared.data(for: request)
//        
//        let decoder = JSONDecoder()
//        return try decoder.decode(NowPlaying.self, from: data)
//    }
    
    // 리퀘스트를 보내지는 않는 테스트용 메서드
    func fetchNowPlaying() async throws -> NowPlaying {
        let decoder = JSONDecoder()
        return try decoder.decode(NowPlaying.self, from: MockData.response)
    }
}
