//
//  UIImageView+MediaData.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView
{
    func setImage(fromUrlString: String?) -> Void
    {
        var url : URL? = nil
        if let sUrl = fromUrlString
        {
            url = URL(string: sUrl)
        }
        self.setImage(url: url)
    }
    
    func setImage(url: URL?) -> Void
    {
        self.sd_setImage(with: url, placeholderImage: UIImage(named: "no_image"), options: SDWebImageOptions.retryFailed)
    }
}
