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
    
//    func read() -> [ReviewData] {
//        let empty = [ReviewData]() // nil을 반환하는 것 보다 빈 배열 반환하는 게 나음
//        guard let context = context else { return empty } // 임시 저장소 접근한다는 뜻
//        
//        let order = NSSortDescriptor(key: "date", ascending: false) // 어떤 친구 기준으로 소팅할건지?
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName) // 엔티티에 접근한다는 신청서
//        request.sortDescriptors = [order] // 왠지 모르겠지만 얘는 배열에 담아서 줘야함
//        
//        guard let data = try? context.fetch(request) as? [ReviewCoreData] // fetch() 배열만 리턴함
//        else { return empty }
//
//        return data.map { coreData in
//            ReviewData(
//                movieId: coreData.movieId.int,
//                posterPath: coreData.posterPath,
//                personalRate: coreData.personalRate.int,
//                commentData: coreData.commentData.map { // 옵셔널 타입에도 map 있다!
//                    ReviewData.CommentData(comment: $0.comment, date: Date())
//                }
//            )
//        }
//    }
    
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
    
    
//    /// 테스트 못해봄, 사용하게 될 경우 테스트 해볼 것
//    func update(target: LogData, from: [SymptomCardData]) {
//        guard let context = context else { return }
//        var replacementCardDataArr = [SymptomCardCoreData]() // 대체할 SymptomCardData 담을 배열 준비
//
//        // 교체할 하위 엔티티 객체 값 설정하고 배열에 추가
//        guard let cardDataEntity = NSEntityDescription.entity(forEntityName: "SymptomCardCoreData", in: context) else { return } // 하위 엔티티 만들고
//        from.forEach { // 받아온 데이터들로 for문 돌려준다
//            guard let cardDataObject = NSManagedObject(entity: cardDataEntity, insertInto: context) as? SymptomCardCoreData else { return } // CardData인스턴스 만들기(꼴랑 인스하나 만드는데 엄청 복잡하네;;)
//            cardDataObject.name = $0.name
//            cardDataObject.hex = $0.hex.to32
//            cardDataObject.isNegative = $0.isNegative
//            cardDataObject.rate = $0.rate.to16
//            // 일단 배열에 담아주기
//            replacementCardDataArr.append(cardDataObject)
//        }
//        
//        // 상위 엔티티 객체 가져오기
//        let request = NSFetchRequest<NSManagedObject>(entityName: entityName) // 요청서
//        request.predicate = NSPredicate(format: "date = %@", target.date as CVarArg) // 가져올 객체들의 조건 설정
//        do {
//            guard let logData = try context.fetch(request) as? [LogCoreData] else { return } // 요청서를 통해서 객체 가져오기
//            for i in logData { i.addToSymptomCards((NSOrderedSet(array: replacementCardDataArr))) } // date는 냅두고 내부데이터만 업데이트
//            
//            appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
//        } catch {
//            print("업데이트 실패")
//        }
//    }
}
