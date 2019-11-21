//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Bharath on 22/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Photos

enum DiaryState {
    case new
    case existing
}


enum DiaryMood: Int16 {
    
    case good = 0
    case average = 1
    case bad = 2
    
    var image: UIImage? {
        
        var nameOfImage: String = ""
        
        switch self {
            case .good: nameOfImage = "happy"
            case .average: nameOfImage = "average"
            case .bad: nameOfImage = "bad"
        }
        
        return UIImage(named: nameOfImage)
    }
}


class DiaryDetailViewController: DiaryUpdateViewController {
    
    var diary: Diary?
    var diaryDataSavedCompletionHandler: (() -> Void)? = nil
    let diaryState: DiaryState
    
    var moodIndicator: DiaryMood = .good {
        didSet {
            moodIndicatorImageView.image = moodIndicator.image
        }
    }
    
    var locationConfigurer: DiaryLocationConfigurer? = nil
    
    
    @IBOutlet weak var moodIndicatorImageView: UIImageView!
    @IBOutlet weak var diaryContentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goodMoodButton: UIButton!
    @IBOutlet weak var averageMoodButton: UIButton!
    @IBOutlet weak var badMoodButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!




    init(withDiary diary: Diary, context: NSManagedObjectContext? = nil, nameOfNib nib: String? = "DiaryDetailViewController", stateOfDiary state: DiaryState, diarySavedCompletionHandler completion: (() -> Void)? = nil) {
        
        self.diary = diary
        diaryDataSavedCompletionHandler = completion
        diaryState = state
        super.init(withContext: context, nameOfNibToLoad: nib)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        diaryState = .new
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if diaryState == .new {
            unsavedChangesPresent = true
        }
    }
    


    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateUI()
    }
    
    
    override func leftBarbuttonItem() -> UIBarButtonItem? {
        
        if diaryState == .new && unsavedChangesPresent == false {
            return UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(leftBarbuttonItemTapped(_:)))
        }
        else {
            return super.leftBarbuttonItem()
        }
    }
    
  
    @objc override func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        updateDiaryWithLastModifiedDate()
        
        super.rightBarbuttonItemTapped(sender)
        
        if diaryState == .new {
            dismiss(animated: true, completion: nil)
            diaryDataSavedCompletionHandler?()
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc override func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        super.leftBarbuttonItemTapped(sender)
        
        if diaryState == .new {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    func updateDiaryWithLastModifiedDate() {
        
        if unsavedChangesPresent == true {
            diary?.modifiedDate = Date()
        }
    }
    
    
    
    func updateUI() {
        
        diaryContentTextView.text = diary?.content ?? ""
        moodIndicator = DiaryMood(rawValue: diary!.moodIndicator)! //Image setting shall happen in didSet.
        
        //Last modified date
        if let modDate = self.diary?.modifiedDate {
            
            dateLabel.text =  DateFormatCreator.dateFormatter(withLocale: .current, dateStyle: .medium, timeStyle: .short, timeZone: .current).string(from: modDate)
        }
        else {
            dateLabel.text = ""
        }
        
        locationLabel.text = diary?.location ?? "Unspecified location"
        
        if diary?.location == nil {
            locationLabel.alpha = 0.3
        }
        else {
            locationLabel.alpha = 1.0
        }
    }
    
    
    deinit {
        diaryDataSavedCompletionHandler = nil
        moodIndicatorImageView = nil
        diaryContentTextView = nil
        dateLabel = nil
        goodMoodButton = nil
        averageMoodButton = nil
        badMoodButton = nil
        locationLabel = nil
    }
    
}


extension DiaryDetailViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //May have to alter the textView contentSize based on keypad size.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        diary?.content = textView.text
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
        
    }
    
}


extension DiaryDetailViewController {
    
    @IBAction func goodMoodButtonTapped(_ sender: UIButton) {
        
        if self.diary?.moodIndicator != DiaryMood.good.rawValue {
            moodIndicator = .good
            self.diary?.moodIndicator = moodIndicator.rawValue
        }
    }
    
    @IBAction func averageMoodButtonTapped(_ sender: UIButton) {
        
        if self.diary?.moodIndicator != DiaryMood.average.rawValue {
            moodIndicator = .average
            self.diary?.moodIndicator = moodIndicator.rawValue
        }
    }
    
    @IBAction func badMoodButtonTapped(_ sender: UIButton) {
        
        if self.diary?.moodIndicator != DiaryMood.bad.rawValue {
            moodIndicator = .bad
            self.diary?.moodIndicator = moodIndicator.rawValue
        }
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        if self.unsavedChangesPresent == false {
            pushImageListViewController()
        }
        else {
            updateDiaryWithLastModifiedDate()
            saveToStore()
            pushImageListViewController()
        }
    }
    
    
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        
        var options: [String] = []
        
        if diary?.location == nil {
            //Show option to just add.
            options.append("Add location")
        }
        else {
            //Show options to update and remove location.
            options.append(contentsOf: ["Update location", "Remove location"])
        }
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: "What do you wish to do ?", preferredStyle: .actionSheet)
        
        
        for (index, actionString) in options.enumerated() {
            
            let actionStyle: UIAlertAction.Style = (index > 0) ? UIAlertAction.Style.destructive : UIAlertAction.Style.default
            
            let action: UIAlertAction = UIAlertAction(title: actionString, style: actionStyle, handler: { [unowned self] (action: UIAlertAction) -> Void in
                
                if alertController.actions.firstIndex(of: action) == 1 {
                    
                    //Remove the added location from Diary.
                    
                    self.diary?.location = nil
                    self.updateLocationLabel(withStatus: DiaryLocationStatus.notKnown)

                }
                else {
                    
                    //Add or overwrite location.
                    
                    self.locationConfigurer = DiaryLocationConfigurer(withCompletionHandler: { [unowned self] (locationStatus: DiaryLocationStatus) -> Void in
                        
                        self.updateLocationLabel(withStatus: locationStatus)
                        
                    })
                    self.locationConfigurer!.beginLocationFetching()
                    
                }
            })
            alertController.addAction(action)
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    func updateLocationLabel(withStatus locationStatus: DiaryLocationStatus) {
        
        
        switch locationStatus {
            
            case .accessRequested:
                locationLabel.update(withText: .firstPriorityText(text: "Waiting for user to grant access ..."))
            
            case .accessGranted:
                locationLabel.update(withText: .firstPriorityText(text: "Access granted. Preparing to fetch your location ..."))
            
            case .fetchingLocation:
                locationLabel.update(withText: .firstPriorityText(text: "Fetching your location ..."))

            case .accessRejected:
                    diary?.location = nil
                    locationLabel.update(withText: .alternateText(text: "Location unspecified", alphaValue: 0.3))
                    //Alert to be shown

            case .currentLocation(let currentLocation):
               
                locationConfigurer!.endLocationFetching()
                DiaryLocationConfigurer.fetchUserReadableData(fromLocation: currentLocation, withCompletionHandler: { [unowned self] (placemarks: [CLPlacemark]?, error: Error?) -> Void in
                    
                    let readableInfo: DiaryLocationUserReadableInfo = DiaryLocationUserReadableInfo(placemark: placemarks?.last)
                    self.locationLabel.update(withText: .firstPriorityText(text: readableInfo.displayableString))
                    self.diary?.location = self.locationLabel.text

                })
            
                case .locationError(let locError): print(locError)
            
                default:
                    diary?.location = nil
                    locationLabel.update(withText: .alternateText(text: "Location unspecified", alphaValue: 0.3))
        }
        
    }
    
    
    
    func pushImageListViewController() {
        
        let imageListVC: DiaryImageListViewController = DiaryImageListViewController(withDiary: diary!, diaryState: diaryState)
        navigationController?.pushViewController(imageListVC, animated: true)
    }
    
}


