//
//  MediaListCell.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import UIKit

class MediaListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var media : Media? = nil {
        didSet {
            self.imageView.setImage(fromUrlString: self.media?.thumbnailURL)
        }
    }
}
