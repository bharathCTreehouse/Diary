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
    
    
    @IBOutlet weak var moodIndicatorImageView: UIImageView!
    @IBOutlet weak var diaryContentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goodMoodButton: UIButton!
    @IBOutlet weak var averageMoodButton: UIButton!
    @IBOutlet weak var badMoodButton: UIButton!



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
    }
    
    
    deinit {
        diaryDataSavedCompletionHandler = nil
        moodIndicatorImageView = nil
        diaryContentTextView = nil
        dateLabel = nil
        goodMoodButton = nil
        averageMoodButton = nil
        badMoodButton = nil
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
    
    
    
    func pushImageListViewController() {
        
        let imageListVC: DiaryImageListViewController = DiaryImageListViewController(withDiary: diary!, diaryState: diaryState)
        navigationController?.pushViewController(imageListVC, animated: true)
    }
    
}


