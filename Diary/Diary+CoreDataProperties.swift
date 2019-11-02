//
//  Diary+CoreDataProperties.swift
//  Diary
//
//  Created by Bharath on 01/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: String?
    @NSManaged public var location: String?
    @NSManaged public var modifiedDate: Date?
    @NSManaged public var moodIndicator: Int16
    @NSManaged public var photos: NSOrderedSet?

}

// MARK: Generated accessors for photos
extension Diary {

    @objc(insertObject:inPhotosAtIndex:)
    @NSManaged public func insertIntoPhotos(_ value: Photo, at idx: Int)

    @objc(removeObjectFromPhotosAtIndex:)
    @NSManaged public func removeFromPhotos(at idx: Int)

    @objc(insertPhotos:atIndexes:)
    @NSManaged public func insertIntoPhotos(_ values: [Photo], at indexes: NSIndexSet)

    @objc(removePhotosAtIndexes:)
    @NSManaged public func removeFromPhotos(at indexes: NSIndexSet)

    @objc(replaceObjectInPhotosAtIndex:withObject:)
    @NSManaged public func replacePhotos(at idx: Int, with value: Photo)

    @objc(replacePhotosAtIndexes:withPhotos:)
    @NSManaged public func replacePhotos(at indexes: NSIndexSet, with values: [Photo])

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSOrderedSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSOrderedSet)

}
