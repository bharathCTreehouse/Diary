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
    
    let photo: Photo
    
    init(withPhoto photo: Photo) {
        self.photo = photo
    }
}


extension DiaryImageListViewModel: ImageDetailDisplayable {
    
    var image: UIImage? {
        
        if let imageData = photo.content {
            return UIImage(data: imageData as Data)
        }
        else {
            return nil
        }
    }
    
    
    var detail: (text: String, font: UIFont, textColor: UIColor)? {
        
        return (text: formattedDateString(), font: UIFont.systemFont(ofSize: 16.0), textColor: UIColor.gray)
        
    }
    
    
    func formattedDateString() -> String {
        
        let df: DateFormatter = DateFormatter()
        df.locale = Locale.current
        df.dateStyle = .medium
        df.timeZone = .current
        df.timeStyle = .short
        
        return df.string(from: photo.createdDate)
    }
}
