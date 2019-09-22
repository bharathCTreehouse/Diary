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
    
    
    var diaryListTableView: DiaryListTableView? = nil {
        
        didSet {
            if diaryListTableView != nil {
                addDiaryListTableView()
            }
        }
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadDiaryData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewDiaryButtonTapped(_:)))
    }
    
    
    @objc func addNewDiaryButtonTapped(_ sender: UIBarButtonItem) {
        
        let diary: Diary = Diary(context: context!)
        pushDetailViewController(forDiary: diary, unsavedDiary: true)
        
    }
    
    
    func addDiaryListTableView() {
        
        view.addSubview(diaryListTableView!)
        
        diaryListTableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        diaryListTableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        diaryListTableView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        diaryListTableView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    
    func loadDiaryData() {
        
        let diaryListFetchRequest:  NSFetchRequest<Diary> = Diary.basicFetchRequest()
        diaryListFetchRequest.propertiesToFetch = ["content", "id", "location", "moodIndicator"]
        
        let sortDesc: NSSortDescriptor = NSSortDescriptor.init(key: "modifiedDate", ascending: false)
        diaryListFetchRequest.sortDescriptors = [sortDesc]
        
        let diaryListFetchedResController: NSFetchedResultsController<Diary> = NSFetchedResultsController(fetchRequest: diaryListFetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        
        
        do {
            try diaryListFetchedResController.performFetch()
            
            diaryListTableView = DiaryListTableView(withFetchedResultsController: diaryListFetchedResController, tapCompletionHandler: { [unowned self] (diary: Diary?, idxPath: IndexPath?) -> Void in
                
                if let diary = diary {
                    
                    //Push the detail diary screen with the diary object.
                    self.pushDetailViewController(forDiary: diary, unsavedDiary: false)
                   
                }
            })
            
        }
        catch {
            
        }
        
    }
    
    
    func pushDetailViewController(forDiary diary: Diary, unsavedDiary unsaved: Bool) {
        
        let detailVC: DiaryDetailViewController = DiaryDetailViewController(withDiary: diary)
        
        if unsaved == false {
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
        else {
            
            let navController: UINavigationController = UINavigationController(rootViewController: detailVC)
            present(navController, animated: true, completion: nil)
        }
    }
    
    
    deinit {
        diaryListTableView = nil
        context = nil
    }
}

