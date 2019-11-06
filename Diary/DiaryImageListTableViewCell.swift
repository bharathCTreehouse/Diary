//
//  DiaryImageListTableViewCell.swift
//  Diary
//
//  Created by Bharath on 01/11/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class DiaryImageListTableViewCell: UITableViewCell {
    
    private(set) var diaryImageView: UIImageView!
    private(set) var diaryImageDetailLabel: UILabel!
    private(set) var topConstraint: NSLayoutConstraint? = nil
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
        selectionStyle = .none
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureSubViews() {
        
        diaryImageView  = UIImageView()
        diaryImageView.translatesAutoresizingMaskIntoConstraints = false
        diaryImageView.contentMode = .scaleAspectFit
        contentView.addSubview(diaryImageView)
        diaryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        diaryImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        diaryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        diaryImageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        
        diaryImageDetailLabel = UILabel()
        diaryImageDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(diaryImageDetailLabel)
        
        diaryImageDetailLabel.numberOfLines = 0
        diaryImageDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        diaryImageDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        diaryImageDetailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    
    
    func update(withImageDetailDisplayable imageDetail: ImageDetailDisplayable) {
        
        update(withImage: imageDetail.image)
        update(withDetailText: imageDetail.detail)
    }
    
    
    func update(withImage image: UIImage?) {
        
        diaryImageView.image = image
        diaryImageView.sizeToFit()
    }
    
    
    func update(withDetailText detail: (text: String, font: UIFont, textColor: UIColor)?) {
        
        if diaryImageDetailLabel.text == nil || diaryImageDetailLabel.text != detail?.text {
            
            topConstraint?.isActive = false
            topConstraint = diaryImageDetailLabel.topAnchor.constraint(equalTo: diaryImageView.bottomAnchor, constant: 8.0)
            topConstraint?.isActive = true
            diaryImageDetailLabel.font = detail?.font
            diaryImageDetailLabel.textColor = detail?.textColor
            diaryImageDetailLabel.text = detail?.text
            diaryImageDetailLabel.textAlignment = .center
        }
    }
    
    
    deinit {
        diaryImageView = nil
        diaryImageDetailLabel = nil
    }
    
}
