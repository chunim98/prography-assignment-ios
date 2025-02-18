//
//  CommentCoreData+CoreDataProperties.swift
//  PrographyAssignment
//
//  Created by 신정욱 on 2/18/25.
//
//

import Foundation
import CoreData


extension CommentCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommentCoreData> {
        return NSFetchRequest<CommentCoreData>(entityName: "CommentCoreData")
    }

    @NSManaged public var comment: String
    @NSManaged public var date: Date
    @NSManaged public var reviewData: ReviewCoreData?

}

extension CommentCoreData : Identifiable {

}
