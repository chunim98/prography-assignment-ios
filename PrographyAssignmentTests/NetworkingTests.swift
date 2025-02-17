//
//  NetworkingTests.swift
//  PrographyAssignmentTests
//
//  Created by 신정욱 on 2/14/25.
//

import XCTest

@testable import PrographyAssignment

final class NetworkingTests: XCTestCase {

    // 이 친구를 테스트(System Under Test)
    var sut: TMDBNetworkManager!

    override func setUpWithError() throws {
        
        /// 테스트 코드를 작성하기 전 기본 세팅 코드를 먼저 작성해준다.
        /// 먼저 부모 클래스의 setUpWithError 메소드를 호출하여, 만약 에러를 포착한다면 호출자에게 에러를 전파한다.

        try super.setUpWithError()
        sut = TMDBNetworkManager.shered
    }

    override func tearDownWithError() throws {
        
        /// 테스트가 끝나고, 테스트에 생성된 모든 리소스나 객체를 정리.
        /// 이렇게 하면 각 테스트가 격리되고 후속 테스트에 영향을 줄 수 있는 잔여 효과가 발생하지 않음.
        
        sut = nil
        try super.tearDownWithError()
    }
    
    // MARK: Testing
    
    func test_xcconfig_접근() {
        let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as? String ?? ""
        print("APIKey", apiKey)
        XCTAssertNotEqual(apiKey, "")
    }
    
    func test_NowPlaying_응답_받아오기() async throws {
        let data = try? await sut.fetchMovieList(.nowPlaying, 4)
        data?.results.forEach { print($0) }
        
        XCTAssertNotNil(data, "nil인듯")
    }

    func test_Popular_응답_받아오기() async throws {
        let data = try? await sut.fetchMovieList(.popular, 2)
        data?.results.forEach { print($0) }
        
        XCTAssertNotNil(data, "nil인듯")
    }
    
    func test_TopRated_응답_받아오기() async throws {
        let data = try? await sut.fetchMovieList(.topRated, 14)
        data?.results.forEach { print($0) }
        
        XCTAssertNotNil(data, "nil인듯")
    }
    
    func test_영화_세부정보_받아오기() async throws {
        let data = try await sut.fetchMovieDetails(939243) // "수퍼 소닉 3"의 id를 사용
        
        print(data.genres)
        print(data.id)
        print(data.overview)
        print(data.posterPath)
        print(data.title)
        print(data.voteAverage)
        
        XCTAssertNotNil(data, "nil인듯")
    }
}
