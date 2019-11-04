//
//  DiaryImageListTableView.swift
//  Diary
//
//  Created by Bharath on 31/10/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


protocol DiaryImageListTableViewDelegate: class {
    func fetchImageData(forViewModel viewModel: ImageDetailDisplayable, presentAtIndexPath idxPath: IndexPath)
}


class DiaryImageListTableView: UITableView {
    
    private(set) var imageListViewModels: [ImageDetailDisplayable]
    weak private(set) var imageListDelegate: DiaryImageListTableViewDelegate? = nil
    
    
    init(withImageListViewModels viewModels: [ImageDetailDisplayable], delegate: DiaryImageListTableViewDelegate? = nil) {
        
        imageListViewModels = viewModels
        imageListDelegate = delegate
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
    
    
    deinit {
        imageListDelegate = nil
    }
    
}


extension DiaryImageListTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageListViewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: DiaryImageListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DiaryImageListTableViewCell
        
        let imageViewModel: ImageDetailDisplayable = imageListViewModels[indexPath.row]
        let imageIdentifier: String = imageViewModel.uniqueIdentifier
        var img: UIImage? = DiaryImageCache.image(forKey: imageIdentifier as NSString)
        if let img = img {
            //Image present in cache
            cell.update(withImage: img)
            cell.update(withDetailText: imageViewModel.detail)
        }
        else {
            //Image not present in cache.
            //Try and look for it in the view model.
            img = imageViewModel.image
            if img == nil {
                //Not present in the view model.
                //Fetch from the store.
                imageListDelegate?.fetchImageData(forViewModel: imageViewModel, presentAtIndexPath: indexPath)
                cell.update(withDetailText: imageViewModel.detail)
            }
            else {
                cell.update(withImageDetailDisplayable: imageViewModel)
            }
        }
        
        return cell
        
    }
    
    
}
