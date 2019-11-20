//
//  DiaryLocationUserReadableInfo.swift
//  Diary
//
//  Created by Bharath on 20/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreLocation


struct DiaryLocationUserReadableInfo {
    let placemark: CLPlacemark?
}


extension DiaryLocationUserReadableInfo {
    
    var displayableString: String {
        return "\(placemark?.locality ?? "Unknown city")" + ", " + "\(placemark?.country ?? "Unknown country")" + ", " + "\(placemark?.subLocality ?? "")"
    }
}
