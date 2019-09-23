//
//  CoreDataError.swift
//  Diary
//
//  Created by Bharath on 21/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation


enum CoreDataError: Error {
    
    case stackCreationFailure
    case viewContextCreationFailure
    case saveOperationFailed
    case fetchOperationFailure
    case unknownError
    
    var isFatalError: Bool {
        
        switch self {
            case .stackCreationFailure: return true
            default: return false
        }
    }
}
