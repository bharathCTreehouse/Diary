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

enum DiaryState {
    case new
    case existing
}


class DiaryDetailViewController: DiaryUpdateViewController {
    
    var diary: Diary?
    var diaryDataSavedCompletionHandler: (() -> Void)? = nil
    let diaryState: DiaryState
    
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
        updateUI()
    }
    
    
    
    @objc override func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        
        updateDiary()
        
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
    
    
    
    func updateDiary() {
        
        diary?.id = "1"
        diary?.content = diaryContentTextView.text
        diary?.moodIndicator = 0
        diary?.modifiedDate = Date()
    }
    
    
    func updateUI() {
        
        diaryContentTextView.text = diary?.content
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
