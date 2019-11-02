//
//  ImageDetailDisplayable.swift
//  Diary
//
//  Created by Bharath on 01/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol ImageDetailDisplayable {
    var image: UIImage? { get }
    var detail: (text: String, font: UIFont, textColor: UIColor)? { get }
}
