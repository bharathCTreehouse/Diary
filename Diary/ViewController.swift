//
//  ViewController.swift
//  Diary
//
//  Created by Bharath on 10/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: DiaryUpdateViewController {
    
    var diaryListTableView: DiaryListTableView? = nil
    
    lazy var listFetchedResultsController: NSFetchedResultsController<Diary> = {
        
        let diaryListFetchRequest:  NSFetchRequest<Diary> = Diary.fetchRequest()
        diaryListFetchRequest.propertiesToFetch = ["content", "id", "location", "moodIndicator"]
        
        let sortDesc: NSSortDescriptor = NSSortDescriptor.init(key: "modifiedDate", ascending: false)
        diaryListFetchRequest.sortDescriptors = [sortDesc]
        
        let fetchedResultsCont =   NSFetchedResultsController(fetchRequest: diaryListFetchRequest, managedObjectContext: context!, sectionNameKeyPath: "modifiedDate", cacheName: nil)
        fetchedResultsCont.delegate = self
        
        return fetchedResultsCont
        
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.listFetchedResultsController.addObserver(self, forKeyPath: "fetchedObjects", options: .new, context: nil)
        fetchAllDiaryData()
    }
    
    
    override func rightBarbuttonItem() -> UIBarButtonItem? {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightBarbuttonItemTapped(_:)))
    }
    
    
    override func leftBarbuttonItem() -> UIBarButtonItem? {
        return nil
    }
    
    
    @objc override func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        let diary: Diary = Diary(context: context!)
        pushDetailViewController(forDiary: diary, unsavedDiary: true)
    }
    
    
    @objc override func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        return
    }
    
    
    
    deinit {
        diaryListTableView = nil
        context = nil
    }
}


extension ViewController: NSFetchedResultsControllerDelegate {
    
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("Delegate method")
        self.diaryListTableView?.reloadData()
        
    }
    
}



extension ViewController {
    
    
    func fetchAllDiaryData() {
        
        do {
            
            try listFetchedResultsController.performFetch(withObserverKeyPath: "fetchedObjects")
        }
        catch {
            print("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "fetchedObjects" {
            
            if diaryListTableView == nil {
                configureDiaryListTableView()
            }
            else {
                //Just UI update
                diaryListTableView!.diaryListFetchedResultsController = listFetchedResultsController
                diaryListTableView!.reloadData()
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
    }
    
}



extension ViewController {
    
    func configureDiaryListTableView() {
        
        diaryListTableView = DiaryListTableView(withFetchedResultsController: listFetchedResultsController, tapCompletionHandler: { [unowned self] (diary: Diary?, idxPath: IndexPath?) -> Void in
            
            if let diary = diary {
                
                //Push the detail diary screen with the diary object.
                self.pushDetailViewController(forDiary: diary, unsavedDiary: false)
                
            }
        })
        
        
        view.addSubview(diaryListTableView!)
        
        diaryListTableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListTableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        diaryListTableView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListTableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func pushDetailViewController(forDiary diary: Diary, unsavedDiary unsaved: Bool) {
        
        var detailVC: DiaryDetailViewController
        
        if unsaved == false {
            
            detailVC = DiaryDetailViewController(withDiary: diary, stateOfDiary: .existing)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        else {
            
            detailVC = DiaryDetailViewController(withDiary: diary, stateOfDiary: .new, diarySavedCompletionHandler: { [unowned self] () -> Void in
                
                //self.fetchAllDiaryData()
                
            })
            
            let navController: UINavigationController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true, completion: nil)
        }
    }
    
}
