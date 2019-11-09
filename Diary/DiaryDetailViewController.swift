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
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        if diary?.id == nil {
            diary?.id = "\(diary!.objectID)"
        }
        if diary?.content != diaryContentTextView.text {
            diary?.content = diaryContentTextView.text
        }
        if diary?.moodIndicator != moodIndicator.rawValue {
            diary?.moodIndicator = moodIndicator.rawValue
        }
        if context?.hasChanges == true {
            diary?.modifiedDate = Date()
        }
    }
    
    
    
    func updateUI() {
        
        diaryContentTextView.text = diary?.content ?? ""
        moodIndicator = DiaryMood(rawValue: diary!.moodIndicator)! //Image setting shall happen in didSet.
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


extension DiaryDetailViewController {
    
    @IBAction func goodMoodButtonTapped(_ sender: UIButton) {
        moodIndicator = .good
    }
    
    @IBAction func averageMoodButtonTapped(_ sender: UIButton) {
        moodIndicator = .average
    }
    
    @IBAction func badMoodButtonTapped(_ sender: UIButton) {
        moodIndicator = .bad
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        
        updateDiary()
        let imageListVC: DiaryImageListViewController = DiaryImageListViewController(withDiary: diary!, diaryState: diaryState)
        navigationController?.pushViewController(imageListVC, animated: true)
    }
    
}


