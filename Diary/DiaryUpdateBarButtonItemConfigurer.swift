//
//  DiaryUpdateBarButtonItemConfigurer.swift
//  Diary
//
//  Created by Bharath on 23/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol DiaryUpdateBarButtonItemConfigurer {
    
    func rightBarbuttonItem() -> UIBarButtonItem?
    func leftBarbuttonItem() -> UIBarButtonItem?
}



 protocol DiaryUpdateBarButtonItemActionable: DiaryUpdateBarButtonItemConfigurer {
    
    func rightBarbuttonItemTapped(_ sender: UIBarButtonItem)
    func leftBarbuttonItemTapped(_ sender: UIBarButtonItem)
}
