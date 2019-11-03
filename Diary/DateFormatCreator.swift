//
//  DateFormatCreator.swift
//  Diary
//
//  Created by Bharath on 03/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


class DateFormatCreator {
    
    static func dateFormatter(withLocale locale: Locale, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style, timeZone: TimeZone) -> DateFormatter {
        
        let df: DateFormatter = DateFormatter()
        df.locale = locale
        df.dateStyle = dateStyle
        df.timeStyle = timeStyle
        df.timeZone = timeZone
        
        return df
        
    }
}
