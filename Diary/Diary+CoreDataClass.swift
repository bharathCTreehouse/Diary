//
//  Diary+CoreDataClass.swift
//  Diary
//
//  Created by Bharath on 22/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Diary)
public class Diary: NSManagedObject {
    
    @objc var modifiedDateStringSansTime: String {
        
        if let lastModDate = modifiedDate {
            
            return DateFormatCreator.dateFormatter(withLocale: .current, dateStyle: .full, timeStyle: .none, timeZone: .current).string(from: lastModDate)
        }
        else {
            return ""
        }
    }

}
