//
//  DiaryImageFetchOperation.swift
//  Diary
//
//  Created by Bharath on 04/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import CoreData


class DiaryImageFetchOperation: Operation {
    
    let fetchRequest: NSFetchRequest<NSDictionary>
    let context: NSManagedObjectContext
    let viewModel: DiaryImageListViewModel
    
    
    init(withFetchRequest fetchReq: NSFetchRequest<NSDictionary>, inContext context: NSManagedObjectContext, forImageViewModel viewModel: DiaryImageListViewModel) {
        
        fetchRequest = fetchReq
        self.context = context
        self.viewModel = viewModel
    }
    
    
    override func main() {
        
        do {
            if self.isCancelled == false {
                let imageData: [NSDictionary] =  try self.context.fetch(fetchRequest)
                
                if imageData.isEmpty == false { viewModel.imageDetailDictionary.updateValue(imageData.first!.object(forKey: "content") as! Data, forKey: "content")
                }
            }
        }
        catch (let err as NSError) {
            print(err)
        }
    }
}
