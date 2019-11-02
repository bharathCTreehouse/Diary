//
//  DiaryImagePreviewViewController.swift
//  Diary
//
//  Created by Bharath on 30/10/19.
//  Copyright © 2019 Bharath. All rights reserved.
//

import UIKit

class DiaryImagePreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let image: UIImage
    let decisionHandler: ((Bool) -> Void)
    
    
    init(withImage image: UIImage, completionHandler handler: @escaping ((Bool) -> Void)) {
        
        self.image = image
        decisionHandler = handler
        super.init(nibName: "DiaryImagePreviewViewController", bundle: .main)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.image = image
        imageView.sizeToFit()
        
        navigationItem.rightBarButtonItem = self.rightBarbuttonItem()
        navigationItem.leftBarButtonItem = self.leftBarbuttonItem()
    }

}


extension DiaryImagePreviewViewController: DiaryUpdateBarButtonItemActionable {
    
    
    func rightBarbuttonItem() -> UIBarButtonItem? {
        return UIBarButtonItem.init(title: "Use photo", style: .done, target: self, action: #selector(rightBarbuttonItemTapped(_:)))
    }
    
    func leftBarbuttonItem() -> UIBarButtonItem? {
        return UIBarButtonItem.init(title: "Discard", style: .done, target: self, action: #selector(leftBarbuttonItemTapped))
    }
    
    
    @objc func rightBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        decisionHandler(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func leftBarbuttonItemTapped(_ sender: UIBarButtonItem) {
        decisionHandler(false)
        dismiss(animated: true, completion: nil)
    }
    
}
