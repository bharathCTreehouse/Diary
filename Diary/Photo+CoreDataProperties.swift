//
//  Photo+CoreDataProperties.swift
//  Diary
//
//  Created by Bharath on 01/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var content: Data?
    @NSManaged public var id: String?
    @NSManaged public var createdDate: Date
    @NSManaged public var diary: Diary?

}
