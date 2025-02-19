//
//  CoreDataManager.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    // MARK: Singleton Instance
    
    static let shared  = CoreDataManager()
    
    // MARK: Properties

    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    private let entityName = "ReviewCoreData"
    private let subEntityName = "CommentCoreData"
    
    // MARK: Init
    
    private init() {}
    
    // MARK: CRUD Methods

    func readAll() -> [ReviewData] {
        guard let context = context else { return [] }
        
        let request = NSFetchRequest<ReviewCoreData>(entityName: entityName) // 이 타입 엔티티 다 가져올게요
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)] // 근데 내림차순으로요
        
        guard let data = try? context.fetch(request) else { return [] }
        return data.map {
            ReviewData(
                movieId: $0.movieId.int,
                posterPath: $0.posterPath,
                personalRate: $0.personalRate.int,
                date: $0.date,
                title: $0.title,
                commentData: $0.commentData.map { // 옵셔널 타입에도 map 있다!
                    ReviewData.CommentData(comment: $0.comment, date: $0.date)
                }
            )
        }
    }
    
    func read(movieId: Int) -> ReviewData? {
        guard let context = context else { return nil }
        
        let request = NSFetchRequest<ReviewCoreData>(entityName: entityName) // 이 타입 엔티티 다 가져올게요
        request.predicate = NSPredicate(format: "movieId = %d", movieId as CVarArg) // 근데 movieId 똑같은 걸로요
        
        guard let data = try? context.fetch(request) else { return nil }
        return data.first.map { // 옵셔널 타입에도 map 있다!
            ReviewData(
                movieId: $0.movieId.int,
                posterPath: $0.posterPath,
                personalRate: $0.personalRate.int,
                date: $0.date,
                title: $0.title,
                commentData: $0.commentData.map { // 옵셔널 타입에도 map 있다!
                    ReviewData.CommentData(comment: $0.comment, date: $0.date)
                }
            )
        }
    }
    
    func create(with reviewData: ReviewData) {
        // 대충 "entityName 타입 파일을 넣을 계획입니다" 라는 뜻
        guard
            let context = context,
            let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        else { return }
        
        // 임시저장소에 올라가게 할 객체만들기
        let reviewCoreData = ReviewCoreData(entity: entity, insertInto: context)
        reviewCoreData.movieId = reviewData.movieId.int32
        reviewCoreData.posterPath = reviewData.posterPath
        reviewCoreData.personalRate = reviewData.personalRate.int16
        reviewCoreData.date = reviewData.date
        reviewCoreData.title = reviewData.title
        reviewCoreData.commentData = reviewData.commentData.flatMap { // 옵셔널 타입에도 flatMap 있다!
            // 하위 코어데이터 객체 만들어서 넘겨주기
            let subEntity = NSEntityDescription.entity(forEntityName: subEntityName, in: context)
            guard let subEntity else { return nil }
            
            let commentCoreData = CommentCoreData(entity: subEntity, insertInto: context)
            commentCoreData.comment = $0.comment
            commentCoreData.date = $0.date
            return commentCoreData
        }
        
        appDelegate?.saveContext()
    }
    
    func delete(_ reviewData: ReviewData) {
        guard let context = context else { return }
        
        let request = NSFetchRequest<ReviewCoreData>(entityName: entityName) // 이 타입 엔티티 다 가져올게요
        request.predicate = NSPredicate(format: "movieId = %d", reviewData.movieId as CVarArg) // 근데 movieId 똑같은 걸로요
        
        guard let data = try? context.fetch(request) else { return }
        data.forEach{ context.delete($0) } // 데이터 삭제하기
        
        appDelegate?.saveContext()
    }
    
    func update(with reviewData: ReviewData) {
        guard let context = context else { return }
        
        // 기존 데이터 찾기
        let request = NSFetchRequest<ReviewCoreData>(entityName: entityName) // 이 타입 엔티티 다 가져올게요
        request.predicate = NSPredicate(format: "movieId = %d", reviewData.movieId as CVarArg) // 근데 movieId 똑같은 걸로요
        
        guard
            let data = try? context.fetch(request),
            let reviewCoreData = data.first
        else { return }
        
        // 기존 데이터 업데이트
        reviewCoreData.posterPath = reviewData.posterPath
        reviewCoreData.personalRate = reviewData.personalRate.int16
        reviewCoreData.date = reviewData.date
        reviewCoreData.title = reviewData.title
        reviewCoreData.commentData = reviewData.commentData.flatMap {
            let subEntity = NSEntityDescription.entity(forEntityName: subEntityName, in: context)
            guard let subEntity else { return nil }
            
            let commentCoreData = CommentCoreData(entity: subEntity, insertInto: context)
            commentCoreData.comment = $0.comment
            commentCoreData.date = $0.date
            return commentCoreData
        }
        
        appDelegate?.saveContext()
    }
}
