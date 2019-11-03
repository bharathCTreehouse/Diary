//
//  DiaryImageListTableView.swift
//  Diary
//
//  Created by Bharath on 31/10/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryImageListTableView: UITableView {
    
    private(set) var imageListViewModels: [ImageDetailDisplayable]
    
    
    init(withImageListViewModels viewModels: [ImageDetailDisplayable]) {
        
        imageListViewModels = viewModels
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addImageListViewModel(_ viewModel: DiaryImageListViewModel) {
        
        imageListViewModels.append(viewModel)
        self.insertRows(at: [IndexPath.init(row: imageListViewModels.count-1, section: 0)], with: .automatic)
    }
    
    
    func configure() {
        
        estimatedRowHeight = 80.0
        rowHeight = UITableView.automaticDimension
        dataSource = self
        register(DiaryImageListTableViewCell.classForCoder(), forCellReuseIdentifier: "imageCell")
    }
    
}


extension DiaryImageListTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageListViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DiaryImageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DiaryImageListTableViewCell
        
        let imageViewModel: ImageDetailDisplayable = imageListViewModels[indexPath.row]
        //let imageIdentifier: String = imageViewModel.uniqueIdentifier
        cell.update(withImageDetailDisplayable: imageViewModel)
        
        return cell
        
    }
    
    
}
