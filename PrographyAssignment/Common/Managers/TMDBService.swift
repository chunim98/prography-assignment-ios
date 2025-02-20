//
//  TMDBService.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/13/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TMDBService {
    
    // 네트워킹 요청을 식별하는 용도의 열거형
    enum Article: String {
        case nowPlaying = "https://api.themoviedb.org/3/movie/now_playing"
        case popular = "https://api.themoviedb.org/3/movie/popular"
        case topRated = "https://api.themoviedb.org/3/movie/top_rated"
    }
    
    static let shered = TMDBService()
    private let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""

    private init() {}
    
    // MARK: Methods
    
    #warning("나중에 이거 예외처리 할 것")
    func fetchMovieList(_ article: Article, _ page: Int) async throws -> MoviesInfo {
        let url = URL(string: article.rawValue)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "ko"),
            URLQueryItem(name: "page", value: "\(page)"),
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
        let decoder = JSONDecoder()
        return try decoder.decode(MoviesInfo.self, from: data)
    }
    
    func fetchMovieDetail(_ id: Int) async throws -> MovieDetail {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "ko"),
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
        let decoder = JSONDecoder()
        return try decoder.decode(MovieDetail.self, from: data)
    }

    // 리퀘스트를 보내지는 않는 디버깅용 메서드
    func fetchMovieListMock() async throws -> MoviesInfo {
        let decoder = JSONDecoder()
        return try decoder.decode(MoviesInfo.self, from: MockData.moviesInfo)
    }
}
