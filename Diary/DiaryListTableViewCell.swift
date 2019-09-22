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


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func update(withDiary diary: Diary) {
        
        diaryContentLabel.text = diary.content
        
        //Update image indicator here.
    }
    
    
    deinit {
        
        moodIndicatorImageView = nil
        diaryContentLabel = nil
        geoLocationImageView = nil
        geoLocationLabel = nil
        
    }
    
}
