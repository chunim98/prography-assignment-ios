//
//  CoreDataManagerTests.swift
//  PrographyAssignmentTests
//
//  Created by 신정욱 on 2/18/25.
//

import XCTest

@testable import PrographyAssignment

final class CoreDataManagerTests: XCTestCase {
    
    var sut: CoreDataManager!
    let mockData = ReviewData(
        movieId: 12121212,
        posterPath: "대충 주소라고 치자.",
        personalRate: 2,
        date: Date(),
        title: "제목",
        commentData: .init(comment: "무슨 영화인지는 모르겠지만 재미있었다!", date: Date())
    )
    let newMockData = ReviewData(
        movieId: 12121212,
        posterPath: "주소였던 것.",
        personalRate: 2,
        date: Date(),
        title: "제목",
        commentData: nil
    )
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoreDataManager.shared
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testCreate() {
//        sut.create(with: mockData)
        let result = sut.readAll()
        
//        result.forEach {
//            print("movieId: \($0.movieId)")
//            print("posterPath: \($0.posterPath)")
//            print("personalRate: \($0.personalRate)")
//            print("date: \($0.date)")
//            print("commentData: \($0.commentData)")
//        }
        
        XCTAssertFalse(result.isEmpty)
    }
    
    func testReadWithMovieId() {
        let result = sut.read(movieId: 12121212)
        
//        if let result {
//            print("movieId: \(result.movieId)")
//            print("posterPath: \(result.posterPath)")
//            print("personalRate: \(result.personalRate)")
//            print("date: \(result.date)")
//            print("commentData: \(result.commentData)")
//        }
        
        XCTAssertNotNil(result)
    }
    
    func testDelete() {
        sut.delete(mockData)
        let result = sut.readAll()
        
//        result.forEach {
//            print("movieId: \($0.movieId)")
//            print("posterPath: \($0.posterPath)")
//            print("personalRate: \($0.personalRate)")
//            print("date: \($0.date)")
//            print("commentData: \($0.commentData)")
//        }
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testUpdate() {
        sut.update(with: mockData)
        let result = sut.readAll()
        
//        result.forEach {
//            print("결과 - movieId: \($0.movieId)")
//            print("결과 - posterPath: \($0.posterPath)")
//            print("결과 - personalRate: \($0.personalRate)")
//            print("결과 - date: \($0.date)")
//            print("결과 - commentData: \($0.commentData)")
//        }
        
        XCTAssertFalse(result.isEmpty)
    }
}
