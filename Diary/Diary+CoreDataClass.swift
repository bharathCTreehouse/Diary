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
    
    
    func lastModifiedTimeString(usingTwentyFourHourFormat hourFormat24: Bool) -> String {
        
        if let lastModDate = modifiedDate {
            
            if hourFormat24 == true {
                
                let df: DateFormatter = DateFormatCreator.dateFormatter(withLocale: .current, dateStyle: .none, timeStyle: .none, timeZone: .current)
                df.dateFormat = "HH:mm"
                return df.string(from: lastModDate)
                
            }
            else {
                
                return DateFormatCreator.dateFormatter(withLocale: .current, dateStyle: .none, timeStyle: .short, timeZone: .current).string(from: lastModDate)
                
            }
        }
        else {
            return ""
        }
        
    }

}
