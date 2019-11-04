//
//  DiaryImageListViewModel.swift
//  Diary
//
//  Created by Bharath on 01/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryImageListViewModel {
    
    var imageDetailDictionary: [String: Any]
    
    init(withImageDetailDictionary imageDetail: [String: Any]) {
        imageDetailDictionary = imageDetail
    }
}


extension DiaryImageListViewModel: ImageDetailDisplayable {
    
    var image: UIImage? {
        
        if let imageData = imageDetailDictionary["content"] as? Data {
            return UIImage(data: imageData as Data)
        }
        else {
            return nil
        }
    }
    
    
    var detail: (text: String, font: UIFont, textColor: UIColor)? {
        return (imageDetailDictionary["createdDate"] as? Date)?.diaryImageDateDetail
    }
    
    
    var uniqueIdentifier: String {
        return (imageDetailDictionary["id"] as? String) ?? ""
    }
}
