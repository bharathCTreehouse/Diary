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
        diaryListFetchRequest.propertiesToFetch = ["content", "id", "location", "moodIndicator", "modifiedDate"]
        diaryListFetchRequest.resultType = .managedObjectResultType
        
        let sortDesc: NSSortDescriptor = NSSortDescriptor.init(key: "modifiedDate", ascending: true)
        diaryListFetchRequest.sortDescriptors = [sortDesc]
        
        let fetchedResultsCont =   NSFetchedResultsController(fetchRequest: diaryListFetchRequest, managedObjectContext: context!, sectionNameKeyPath: "modifiedDateStringSansTime", cacheName: nil)
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
        diary.id = "\(diary.objectID)"
        diary.content = ""
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
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        diaryListTableView?.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        if type == .insert {
            diaryListTableView?.insertSections(IndexSet.init(integer: sectionIndex), with: .fade)
        }
        else if type == .update {
            diaryListTableView?.reloadSections(IndexSet.init(integer: sectionIndex), with: .automatic)
        }
        else if type == .delete {
            diaryListTableView?.deleteSections(IndexSet.init(integer: sectionIndex), with: .fade)
        }
        else if type == .move {
            diaryListTableView?.reloadSections(IndexSet.init(integer: sectionIndex), with: .automatic)
        }
        else {
            diaryListTableView?.reloadData()
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        print("Delegate method")
        
        if type == .insert {
            diaryListTableView?.insertRows(at: [newIndexPath!], with: .fade)
        }
        else if type == .update {
            diaryListTableView?.reloadRows(at: [indexPath!], with: .automatic)
        }
        else if type == .delete {
            diaryListTableView?.deleteRows(at: [indexPath!], with: .fade)
        }
        else if type == .move {
            diaryListTableView?.moveRow(at: indexPath!, to: newIndexPath!)
        }
        else {
            diaryListTableView?.reloadData()
        }
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        diaryListTableView?.endUpdates()
        
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

