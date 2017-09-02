//
//  Media.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import Foundation

class Media {
    private(set) var ID : String?
    private(set) var thumbnailURL : String?
    private(set) var standartImageURL : String?
    private(set) var likesCount : Int?
    private(set) var commentsCount : Int?
    private(set) var tags : Array<String>?
    
    class func media(withDictionary dictionary : Dictionary<String, Any>) -> Media
    {
        let media = Media()
        media.ID = dictionary["id"] as? String
        media.thumbnailURL = ((dictionary["images"] as? Dictionary<String, Any>)?["thumbnail"] as? Dictionary<String, Any>)?["url"] as? String
        media.standartImageURL = ((dictionary["images"] as? Dictionary<String, Any>)?["standard_resolution"] as? Dictionary<String, Any>)?["url"] as? String
        if let count = (dictionary["likes"] as? Dictionary<String, Any>)?["count"] as? Int {
            media.likesCount = count
        }
        if let count = (dictionary["comments"] as? Dictionary<String, Any>)?["count"] as? Int {
            media.commentsCount = count
        }
        media.tags = dictionary["tags"] as? Array<String>
        
        return media
    }
}
