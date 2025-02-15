//
//  TMDBNetworkManager.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TMDBNetworkManager {
    static let shered = TMDBNetworkManager()
    private let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""

    private init() {}
    
    // MARK: Methods
    
#warning("나중에 이거 예외처리 할 것")
    private func requestTMDB(_ url: String) async throws -> Data {
        let url = URL(string: url)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "ko"),
          URLQueryItem(name: "page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer " + apiKey
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    func fetchNowPlaying() async throws -> MovieInfo {
        let data = try await requestTMDB("https://api.themoviedb.org/3/movie/now_playing")
        let decoder = JSONDecoder()
        return try decoder.decode(MovieInfo.self, from: data)
    }
    
    func fetchPopular() async throws -> MovieInfo {
        let data = try await requestTMDB("https://api.themoviedb.org/3/movie/popular")
        let decoder = JSONDecoder()
        return try decoder.decode(MovieInfo.self, from: data)
    }
    
    func fetchTopRated() async throws -> MovieInfo {
        let data = try await requestTMDB("https://api.themoviedb.org/3/movie/top_rated")
        let decoder = JSONDecoder()
        return try decoder.decode(MovieInfo.self, from: data)
    }

//    // 리퀘스트를 보내지는 않는 테스트용 메서드
//    func fetchNowPlaying() async throws -> MovieInfo {
//        let decoder = JSONDecoder()
//        return try decoder.decode(MovieInfo.self, from: MockData.response)
//    }
}
