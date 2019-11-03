//
//  DiaryImageDateUtilities.swift
//  Diary
//
//  Created by Bharath on 03/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


extension Date {
    
    var diaryImageDateDetail: (text: String, font: UIFont, textColor: UIColor) {
        
        let dateDetailString: String = DateFormatCreator.dateFormatter(withLocale: .current, dateStyle: .medium, timeStyle: .short, timeZone: .autoupdatingCurrent).string(from: self)
        
        return (text: dateDetailString, font: UIFont.systemFont(ofSize: 16.0), textColor: UIColor.gray)
    }
}



