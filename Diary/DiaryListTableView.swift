//
//  DiaryListTableView.swift
//  Diary
//
//  Created by Bharath on 22/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData


enum DiaryListUserAction {
    case tap
    case delete
}


class DiaryListTableView: UITableView {
    
    var diaryListFetchedResultsController: NSFetchedResultsController<Diary>
    var diaryListActionCompletionHandler: ((Diary?, IndexPath?, DiaryListUserAction) -> Void)? = nil
    
    
    required init(withFetchedResultsController controller: NSFetchedResultsController<Diary>, tapCompletionHandler handler: ((Diary?, IndexPath?, DiaryListUserAction) -> Void)? ) {
        
        diaryListFetchedResultsController = controller
        diaryListActionCompletionHandler = handler
        super.init(frame: .zero, style: .grouped)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        
        //Setup datasource and delegates.
        dataSource = self
        delegate = self
        register(UINib.init(nibName: "DiaryListTableViewCell", bundle: .main), forCellReuseIdentifier: "diaryListCell")
        estimatedRowHeight = 90.0
        rowHeight = UITableView.automaticDimension
    }
    
    
    func toggleEditingMode() {
        setEditing(!(isEditing), animated: true)
    }
    
    
    deinit {
        diaryListActionCompletionHandler = nil
    }
}



extension DiaryListTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return diaryListFetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionInfo: NSFetchedResultsSectionInfo? = diaryListFetchedResultsController.sections?[section]
        return sectionInfo?.name ?? ""
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return  diaryListFetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let diaryCell: DiaryListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "diaryListCell", for: indexPath) as! DiaryListTableViewCell
        
        let diary: Diary = diaryListFetchedResultsController.object(at: indexPath)
        diaryCell.update(withDiary: diary)
        
        return diaryCell
        
    }
}


extension DiaryListTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let diaryTapped: Diary = diaryListFetchedResultsController.object(at: indexPath)
        diaryListActionCompletionHandler?(diaryTapped, indexPath, .tap)
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let diaryTapped: Diary = diaryListFetchedResultsController.object(at: indexPath)
            diaryListActionCompletionHandler?(diaryTapped, indexPath, .delete)
        }
        
    }

    
}

