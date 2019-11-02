//
//  DiaryImageListViewController.swift
//  Diary
//
//  Created by Bharath on 31/10/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit


class DiaryImageListViewController: DiaryUpdateViewController {
    
    let diary: Diary
    
    lazy var imageListViewModels: [DiaryImageListViewModel] = {
        
         let imageListViewModels: [DiaryImageListViewModel] = diary.photos?.compactMap( {return DiaryImageListViewModel(withPhoto: $0 as! Photo) }) ?? []
        return imageListViewModels
    }()
    
    var imageListTableView: DiaryImageListTableView? = nil
    
    
    init(withDiary diary: Diary) {
        self.diary = diary
        super.init(withContext: nil, nameOfNibToLoad: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        
        imageListTableView = DiaryImageListTableView(withImageListViewModels: imageListViewModels)
        self.view.addSubview(imageListTableView!)
        imageListTableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageListTableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageListTableView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        imageListTableView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToolbar()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
   
    
    func configureToolbar() {
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        let cameraBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped(_:)))
        
        self.setToolbarItems([cameraBarButtonItem], animated: true)
        
    }
    
    
    @objc func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        let actionSheetController: UIAlertController = UIAlertController.init(title: nil, message: "What do you wish to do?", preferredStyle: .actionSheet)
        
        
        let cameraAction: UIAlertAction = UIAlertAction.init(title: "Take photo", style: .default, handler: { (action: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cameraAction)
        
        
        let photoLibraryAction: UIAlertAction = UIAlertAction.init(title: "Choose from library", style: .default, handler: { [unowned self] (action: UIAlertAction) -> Void in
            
            //Go to the photo library.
            self.chooseFromPhotoLibrary()
            
        })
        actionSheetController.addAction(photoLibraryAction)
        
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
    override func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        super.rightBarbuttonItemTapped(sender)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        super.leftBarbuttonItemTapped(sender)
        navigationController?.popViewController(animated: true)
    }
    
}


extension DiaryImageListViewController: UIImagePickerControllerDelegate&UINavigationControllerDelegate {
    
    
    func chooseFromPhotoLibrary() {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let imageSelected: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let imageSelected = imageSelected {
            
            let previewVC: DiaryImagePreviewViewController = DiaryImagePreviewViewController(withImage: imageSelected, completionHandler: { [unowned self] (usePhoto: Bool) -> Void in
                
                if usePhoto == true {
                                        
                    let imageData: Data? = imageSelected.pngData()
                    
                    
                    if let imageData = imageData {
                        
                        let photo: Photo = Photo(context: self.context!)
                        photo.content = imageData
                        photo.id = "\(photo.objectID)"
                        photo.createdDate = Date()
                        self.diary.addToPhotos(photo)
                        let viewModel: DiaryImageListViewModel = DiaryImageListViewModel(withPhoto: photo)
                        self.imageListViewModels.append(viewModel)
                        self.imageListTableView?.addImageListViewModel(viewModel)
                    }
                    
                }
                
            })
            let navigationController: UINavigationController = UINavigationController(rootViewController: previewVC)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
}
