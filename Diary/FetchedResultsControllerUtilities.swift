//
//  FetchedResultsControllerUtilities.swift
//  Diary
//
//  Created by Bharath on 24/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData


extension NSFetchedResultsController {
    
    @objc func performFetch(withObserverKeyPath keyPath: String) throws {
        
        do {
            self.willChangeValue(forKey: keyPath)
            try self.performFetch()
            self.didChangeValue(forKey: keyPath)
        }
        catch {
            throw CoreDataError.fetchOperationFailure
        }
    }
}
