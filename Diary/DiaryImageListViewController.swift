//
//  DiaryImageListViewController.swift
//  Diary
//
//  Created by Bharath on 31/10/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class DiaryImageListViewController: DiaryUpdateViewController {
    
    let diary: Diary
    
    lazy var imageListViewModels: [ImageDetailDisplayable] = {
        
        //Investigate whether this fetching can be done in a background context.
        //On the first attempt, let us just fetch Photos with all properties except the binaryData (the actual image).
        
        let photoPredicate: NSPredicate = NSPredicate(format: "diary == %@", self.diary)
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "createdDate", ascending: true)
        
        let fetchRequest: NSFetchRequest<NSDictionary> = DiaryFetchRequestConfigurer.fetchRequestForPhoto(withPredicate: photoPredicate, sortDescriptors: [sorter], propertiesToGet: ["id", "createdDate"]) as! NSFetchRequest<NSDictionary>
        
        do {
            let result: [NSDictionary]? = try self.context?.fetch(fetchRequest)
            
            if let result = result {
                
                let imageListViewModels: [DiaryImageListViewModel] = result.compactMap({ return DiaryImageListViewModel(withImageDetailDictionary: $0 as! [String: Any]) })
                return imageListViewModels
            }
            
        }
        catch (let error) {
            print("Error: \(error)")
        }
        
        return []
        
    }()
    
    var imageListTableView: DiaryImageListTableView? = nil
    let diaryState: DiaryState  //Not being used currently. Check at a later stage and please remove.
    
    var lastRemovedImageDate: Date? = nil
    
    
    init(withDiary diary: Diary, diaryState state: DiaryState) {
        
        self.diary = diary
        diaryState = state
        super.init(withContext: nil, nameOfNibToLoad: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureToolbar()
        
        imageListTableView = DiaryImageListTableView(withImageListViewModels: imageListViewModels, delegate: self)
        self.view.addSubview(imageListTableView!)
        imageListTableView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageListTableView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageListTableView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        imageListTableView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: false)
    }
    
   
    func configureToolbar() {
        
        navigationController?.setToolbarHidden(false, animated: true)
        
        let cameraBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped(_:)))
        
        let flexiSpaceBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let editBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(editButtonTapped(_:)))
        
        self.setToolbarItems([cameraBarButtonItem,flexiSpaceBarButtonItem, editBarButtonItem], animated: true)
        
    }
    
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        
        let editButton: UIBarButtonItem = toolbarItems![2]
        
        if self.imageListTableView?.isEditing == false {
            self.imageListTableView?.setEditing(true, animated: true)
            editButton.title = "Done"
        }
        else {
            self.imageListTableView?.setEditing(false, animated: true)
            editButton.title = "Edit"
        }
    }
    
    
    @objc func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        let actionSheetController: UIAlertController = UIAlertController.init(title: nil, message: "What do you wish to do?", preferredStyle: .actionSheet)
        
        
        let cameraAction: UIAlertAction = UIAlertAction.init(title: "Take photo", style: .default, handler: { [unowned self] (action: UIAlertAction) -> Void in
            
            //Activate the camera.
            self.chooseFromCamera()
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
        
        updateDiaryModifiedDate()
        if self.diary.modifiedDate != nil {
            super.rightBarbuttonItemTapped(sender)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    override func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        super.leftBarbuttonItemTapped(sender)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func updateDiaryModifiedDate() {
        
        if let diaryModifiedDate = self.diary.modifiedDate {
            
            //Saved/Existing diary.
            
            if imageListViewModels.isEmpty == false {
                
                let lastAddedImageViewModel: DiaryImageListViewModel = imageListViewModels.last as! DiaryImageListViewModel
                
                let lastAddedImageDate: Date = lastAddedImageViewModel.imageDetailDictionary["createdDate"] as! Date
                
                if self.lastRemovedImageDate == nil {
                    if lastAddedImageDate > diaryModifiedDate {
                        diary.modifiedDate = lastAddedImageDate
                    }
                }
                else {
                    let lastModDate: Date = [lastRemovedImageDate!, lastAddedImageDate, diary.modifiedDate!].sorted().last!
                    diary.modifiedDate = lastModDate
                }
                
            }
            else {
                //Before doing this, check if any image was removed.
                diary.modifiedDate = self.lastRemovedImageDate ?? Date()
            }
            
        }
        else {
            
            //Unsaved diary.
            
            if imageListViewModels.isEmpty == false {
                
                let lastAddedImageViewModel: DiaryImageListViewModel = imageListViewModels.last as! DiaryImageListViewModel
                
                let lastAddedImageDate: Date = lastAddedImageViewModel.imageDetailDictionary["createdDate"] as! Date
                
                //No image deleted/removed at all. So update the modified date with the last added date.
                diary.modifiedDate = lastAddedImageDate
                
                if let latestImageRemovedDate = lastRemovedImageDate {
                    //Last removed date present. Make a comparison.
                    if latestImageRemovedDate > lastAddedImageDate {
                        diary.modifiedDate = latestImageRemovedDate
                    }
                }
            }
            
        }
    }
    
}


extension DiaryImageListViewController: UIImagePickerControllerDelegate&UINavigationControllerDelegate {
    
    
    func chooseFromPhotoLibrary() {
        
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func chooseFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .rear
            present(imagePickerController, animated: true, completion: nil)
            
        }
        else {
            //Show an alert telling the user that camera capture is not available.
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        let imageSelected: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let imageSelected = imageSelected {
            
            let previewVC: DiaryImagePreviewViewController = DiaryImagePreviewViewController(withImage: imageSelected, completionHandler: { [unowned self] (usePhoto: Bool) -> Void in
                
                if usePhoto == true {
                    
                    let scaledImage: UIImage = UIImage.init(cgImage: imageSelected.cgImage!, scale: 1.0, orientation: imageSelected.imageOrientation)
                                        
                    let imageData: Data? = scaledImage.jpegData(compressionQuality: 1.0)
                    
                    
                    if let imageData = imageData {
                        
                        let photo: Photo = Photo(context: self.context!)
                        photo.content = imageData
                        photo.id = "\(photo.objectID)"
                        photo.createdDate = Date()
                        self.diary.addToPhotos(photo)
                        let viewModel: DiaryImageListViewModel = DiaryImageListViewModel(withImageDetailDictionary: ["content":imageData, "id":"\(photo.objectID)", "createdDate":photo.createdDate])
                        self.imageListViewModels.append(viewModel)
                        self.imageListTableView?.addImageListViewModel(viewModel)
                        
                        //Save the image in the cache.
                        DiaryImageCache.storeImage(imageSelected, forKey: "\(photo.objectID)" as NSString)
                    }
                    
                }
                
            })
            let navigationController: UINavigationController = UINavigationController(rootViewController: previewVC)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
}



extension DiaryImageListViewController: DiaryImageListTableViewDelegate {
    
    
    func fetchImageData(forViewModel viewModel: ImageDetailDisplayable, presentAtIndexPath idxPath: IndexPath) {

        let pred: NSPredicate = NSPredicate.init(format: "id == %@", viewModel.uniqueIdentifier)
        
        
        let fetchReq: NSFetchRequest<NSDictionary> = DiaryFetchRequestConfigurer.fetchRequestForPhoto(withPredicate: pred, sortDescriptors: nil, propertiesToGet: ["content"], fetchLimit: 1) as! NSFetchRequest<NSDictionary>
        
        //Create operation queue and pass the fetchRequest.
        let opQueue: OperationQueue = OperationQueue()
        let imageOperation: DiaryImageFetchOperation = DiaryImageFetchOperation(withFetchRequest: fetchReq, inContext: self.context!, forImageViewModel: viewModel as! DiaryImageListViewModel)
        
        imageOperation.completionBlock = {
            
            DiaryImageCache.storeImage(viewModel.image!, forKey: viewModel.uniqueIdentifier as NSString)
            DispatchQueue.main.async { [unowned self] () -> Void in
                self.imageListTableView?.reloadRows(at: [idxPath], with: .automatic)
                
            }
        }
        
        opQueue.addOperation(imageOperation)
        
    }
    
    
    func removeImageData(presentAtIndexPath idxPath: IndexPath) {
        
        self.diary.removeFromPhotos(at: idxPath.row)
        self.imageListViewModels.remove(at: idxPath.row)
        lastRemovedImageDate = Date()
    }
}
