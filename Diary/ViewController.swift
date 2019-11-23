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
        
        let sortDesc: NSSortDescriptor = NSSortDescriptor.init(key: "modifiedDate", ascending: false)
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
        
        if self.diaryListTableView?.isEditing == true {
            
            return UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(leftBarbuttonItemTapped(_:)))

        }
        else {
            return UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(leftBarbuttonItemTapped(_:)))

        }
    }
    
    
    @objc override func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        //Create a new diary object.
        let diary: Diary = Diary(context: context!)
        diary.id = "\(diary.objectID)"
        diary.content = ""
        pushDetailViewController(forDiary: diary, unsavedDiary: true)
    }
    
    
    @objc override func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        diaryListTableView?.toggleEditingMode()
        self.navigationItem.leftBarButtonItem = self.leftBarbuttonItem()
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
            //diaryListTableView?.reloadSections(IndexSet.init(integer: sectionIndex), with: .automatic)
        }
        else {
            diaryListTableView?.reloadData()
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
                
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
            
            if indexPath! != newIndexPath! {
                
                //The new and old index paths are different.
                //So let us first reorder the rows and then reload after a slight delay.
                diaryListTableView?.moveRow(at: indexPath!, to: newIndexPath!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.diaryListTableView?.reloadRows(at: [newIndexPath!], with: .automatic)
                }
            }
            else {
                //New and old index paths the same. So no need to reorder. Just reload.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.diaryListTableView?.reloadRows(at: [newIndexPath!], with: .automatic)
                }
            }
            
        }
        else {
            diaryListTableView?.reloadData()
        }
        
    }
    

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        self.diaryListTableView?.endUpdates()
        
    }
}



extension ViewController {
    
    
    func fetchAllDiaryData(containingText text: String? = nil) {
        
        do {
            
            if let text = text {
                listFetchedResultsController.fetchRequest.predicate = NSPredicate(format: "content CONTAINS[CD] %@", text)
            }
            else {
               listFetchedResultsController.fetchRequest.predicate = nil
            }
            
            try listFetchedResultsController.performFetch(withObserverKeyPath: "fetchedObjects")
            
        }
        catch {
            
            displayAlertController(withTitle: "Data retrieval error", message: error.localizedDescription, action: (actionTitle: "OK", actionStyle: UIAlertAction.Style.default))
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
        
        diaryListTableView = DiaryListTableView(withFetchedResultsController: listFetchedResultsController, searchBarDelegate: self,  tapCompletionHandler: { [unowned self] (diary: Diary?, idxPath: IndexPath?, userAction: DiaryListUserAction) -> Void in
            
            if let diary = diary {
                
                if userAction == .tap {
                    //Push the detail diary screen with the diary object.
                    self.pushDetailViewController(forDiary: diary, unsavedDiary: false)
                }
                else if userAction == .delete {
                    
                    //Get confirmation.
                    
                    let alertController: UIAlertController = UIAlertController(title: "Are you sure you want this diary deleted?", message: "This action cannot be undone.", preferredStyle: .alert)
                    
                    let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(noAction)
                    
                    let yesAction: UIAlertAction = UIAlertAction(title: "DELETE", style: .destructive, handler: { [unowned self] (deleteAction: UIAlertAction) -> Void in
                        
                        self.context?.delete(diary)
                        self.saveToStore()
                    })
                    alertController.addAction(yesAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
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
            
            detailVC = DiaryDetailViewController(withDiary: diary, stateOfDiary: .new)
            
            let navController: UINavigationController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true, completion: nil)
        }
    }
    
}


extension ViewController: DiaryListSearchBarDelegate {
    
    func filterResults(withText text: String?) {
        fetchAllDiaryData(containingText: text)
    }
}

