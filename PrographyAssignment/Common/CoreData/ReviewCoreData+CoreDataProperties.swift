//
//  ReviewCoreData+CoreDataProperties.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/19/25.
//
//

import Foundation
import CoreData


extension ReviewCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewCoreData> {
        return NSFetchRequest<ReviewCoreData>(entityName: "ReviewCoreData")
    }

    @NSManaged public var date: Date
    @NSManaged public var movieId: Int32
    @NSManaged public var personalRate: Int16
    @NSManaged public var posterPath: String
    @NSManaged public var title: String
    @NSManaged public var commentData: CommentCoreData?

}

extension ReviewCoreData : Identifiable {

}
