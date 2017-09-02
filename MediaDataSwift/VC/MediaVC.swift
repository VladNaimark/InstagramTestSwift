//
//  MediaVC.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import UIKit

class MediaVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var media : Media? = nil {
        didSet {
            if !self.isViewLoaded
            {
                return
            }
            
            self.configure()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configure()
    }

    func configure() -> Void {
        self.imageView.setImage(fromUrlString: self.media?.standartImageURL)
        self.commentCountLabel.text = "\(self.media?.commentsCount ?? 0)"
        self.likesCountLabel.text = "\(self.media?.likesCount ?? 0)"
        var tags = ""
        if let allTags = self.media?.tags
        {
            for tag in allTags
            {
                if !tags.isEmpty
                {
                    tags.append("\n")
                }
                tags.append("#")
                tags.append(tag)
            }
        }
        self.tagsLabel.text = tags
    }
}
