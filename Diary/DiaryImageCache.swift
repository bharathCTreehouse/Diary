//
//  DiaryImageCache.swift
//  Diary
//
//  Created by Bharath on 03/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryImageCache {
    
    static let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    static func storeImage(_ image: UIImage, forKey key: NSString) {
        imageCache.setObject(image, forKey: key)
    }
    
    static func image(forKey key: NSString) -> UIImage? {
        return imageCache.object(forKey: key)
    }
    
}
