//
//  DiaryUpdateViewController.swift
//  Diary
//
//  Created by Bharath on 22/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class DiaryUpdateViewController: UIViewController {
    
    var context: NSManagedObjectContext? = nil
    
    
    init(withContext context: NSManagedObjectContext? = nil, nameOfNibToLoad nibName: String? = nil) {
        
        self.context = context
        super.init(nibName: nibName, bundle: .main)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if context == nil {
            configureDefaultManagedObjectContext()
        }
    }
    
    
    deinit {
        context = nil
    }
}



extension DiaryUpdateViewController {
    
    
    final func configureDefaultManagedObjectContext() {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        do {
            self.context = try appDelegate.persistentContainerViewContext()
        }
        catch (let error as CoreDataError) {
            
            if error.isFatalError == true {
                //Show an alert and request the user to quit and relaunch the app.
                print("Fatal error")
            }
            else {
                //Just show the error.
                print("Just error")
            }
            
        }
        catch {
            print("Just error")
        }
        
    }
}
