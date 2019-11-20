//
//  DiaryListTableViewCell.swift
//  Diary
//
//  Created by Bharath on 21/09/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class DiaryListTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var moodIndicatorImageView: UIImageView!
    @IBOutlet private weak var diaryContentLabel: UILabel!
    @IBOutlet private weak var geoLocationImageView: UIImageView!
    @IBOutlet private weak var geoLocationLabel: UILabel!
    @IBOutlet private weak var diaryModifiedTime: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    func update(withDiary diary: Diary) {
        
        diaryContentLabel.text = diary.content
        moodIndicatorImageView.image = DiaryMood(rawValue: diary.moodIndicator)?.image
        diaryModifiedTime.text = diary.lastModifiedTimeString(usingTwentyFourHourFormat: false)
        geoLocationLabel.text = diary.location ?? "Unspecified location"
        
        if diary.location == nil {
            geoLocationLabel.alpha = 0.3
            geoLocationImageView.alpha = 0.3
        }
        else {
            geoLocationLabel.alpha = 1.0
            geoLocationImageView.alpha = 1.0

        }
    }
    
    
    deinit {
        
        moodIndicatorImageView = nil
        diaryContentLabel = nil
        geoLocationImageView = nil
        geoLocationLabel = nil
        diaryModifiedTime = nil
        
    }
    
}
