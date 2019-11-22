//
//  DiaryAlertController.swift
//  Diary
//
//  Created by Bharath on 22/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryAlertController {
    
    static func diaryAlertController(withTitle title: String?, message: String?, alertActions: [(actionTitle: String, actionStyle: UIAlertAction.Style)], alertActionHandler handler: ((Int) -> Void)? ) -> UIAlertController {
        
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for alertActionDetail in alertActions {
            
            let action: UIAlertAction = UIAlertAction.init(title: alertActionDetail.actionTitle, style: alertActionDetail.actionStyle, handler: { (act: UIAlertAction) -> Void in
                
                handler?(alertController.actions.firstIndex(of: act)!)
                
            })
            
            alertController.addAction(action)
        }
        
        
        return alertController
        
    }
    
}
