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



class DiaryUpdateViewController: UIViewController, DiaryUpdateBarButtonItemActionable {
    
    
    var context: NSManagedObjectContext? = nil
    
    var unsavedChangesPresent: Bool = false {
        
        didSet {
            navigationItem.rightBarButtonItem = rightBarbuttonItem()
            navigationItem.leftBarButtonItem = leftBarbuttonItem()
        }
    }
    
    
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
        navigationItem.rightBarButtonItem = rightBarbuttonItem()
        navigationItem.leftBarButtonItem = leftBarbuttonItem()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        context?.addObserver(self, forKeyPath: "hasChanges", options: .new, context: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        context?.removeObserver(self, forKeyPath: "hasChanges")
    }
    
    
    func rightBarbuttonItem() -> UIBarButtonItem? {
        
        if self.unsavedChangesPresent == true {
            return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarbuttonItemTapped(_:)))
        }
        else {
            //return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarbuttonItemTapped(_:)))
            return nil
        }
    }
    
    
    func leftBarbuttonItem() -> UIBarButtonItem? {
        
        if self.unsavedChangesPresent == true {

            return UIBarButtonItem.init(title: "Discard", style: .plain, target: self, action: #selector(leftBarbuttonItemTapped(_:)))
        }
        else {
            //return nil
            return UIBarButtonItem.init(title: "Back", style: .plain, target: self, action: #selector(leftBarbuttonItemTapped(_:)))
        }
    }
    
    
    @objc func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        saveToStore()
        
    }
    
    
    func saveToStore() {
        
        do {
            if context?.hasChanges == true {
                //Save
                try context?.save()
            }
        }
        catch {
            print("Save failed: \(error.localizedDescription)")
        }
    }
    
    
    @objc func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        //Cancel/Discard
        discardChanges()
    }
    
    
    func discardChanges() {
        context?.rollback()
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
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "hasChanges" {
            unsavedChangesPresent = self.context!.hasChanges
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
}
