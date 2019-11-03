//
//  DiaryImageListFromCacheViewModel.swift
//  Diary
//
//  Created by Bharath on 03/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryImageListFromCacheViewModel {
    
    let date: Date
    let diaryImage: UIImage
    let identifier: String
    
    init(withDate date: Date, image: UIImage, identifier: String) {
        self.date =  date
        diaryImage = image
        self.identifier = identifier
    }
}


extension DiaryImageListFromCacheViewModel: ImageDetailDisplayable {
    
    var image: UIImage? {
        return diaryImage
    }
    
    var detail: (text: String, font: UIFont, textColor: UIColor)? {
        return self.date.diaryImageDateDetail
    }
    
    var uniqueIdentifier: String {
        return self.identifier
    }
}
