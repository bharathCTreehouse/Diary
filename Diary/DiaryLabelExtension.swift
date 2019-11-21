//
//  DiaryLabelExtension.swift
//  Diary
//
//  Created by Bharath on 21/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit

enum DiaryLabelText {
    
    case firstPriorityText (text: String)   //Alpha will always be 1.0                                      for this case.
    
    case alternateText (text: String, alphaValue: CGFloat?)
}


extension UILabel {
    
    func update(withText labelText: DiaryLabelText) {
        
        switch labelText {
            case .firstPriorityText(text: let str):
                self.text = str
                self.alpha = 1.0
        case .alternateText(text: let str, alphaValue: let aValue):
                self.text = str
                self.alpha = aValue ?? 1.0
        }
    }
    
}
