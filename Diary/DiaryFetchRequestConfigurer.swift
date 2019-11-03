//
//  DiaryFetchRequestConfigurer.swift
//  Diary
//
//  Created by Bharath on 03/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData


class DiaryFetchRequestConfigurer {
    
    
    static func fetchRequestForPhoto(withPredicate predicate: NSPredicate?, sortDescriptors sorters: [NSSortDescriptor]? = nil, propertiesToGet properties: [String]? = nil, fetchLimit limit: Int? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        
        
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()
        
        configure(fetchRequest: fetchReq , withPredicate: predicate, sortDescriptors: sorters, propertiesToFetch: properties, fetchLimit: limit)
        
        
        return fetchReq
        
    }
    
    
    
    static func fetchRequestForDiary(withPredicate predicate: NSPredicate?, sortDescriptors sorters: [NSSortDescriptor]? = nil, propertiesToGet properties: [String]? = nil, fetchLimit limit: Int? = nil) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = Diary.fetchRequest()
        
        configure(fetchRequest: fetchReq , withPredicate: predicate, sortDescriptors: sorters, propertiesToFetch: properties, fetchLimit: limit)
        
        return fetchReq
        
    }
}


extension DiaryFetchRequestConfigurer {
    
    private static func configure(fetchRequest fetchReq: NSFetchRequest<NSFetchRequestResult>, withPredicate predicate: NSPredicate?, sortDescriptors descriptors: [NSSortDescriptor]?, propertiesToFetch properties: [String]?, fetchLimit limit: Int?) {
        
        
        fetchReq.predicate = predicate
        fetchReq.sortDescriptors = descriptors
        fetchReq.propertiesToFetch = properties
        
        if let limit = limit {
            fetchReq.fetchLimit = limit
        }
        
        if properties != nil {
            fetchReq.resultType = .dictionaryResultType
        }
        
    }
}
