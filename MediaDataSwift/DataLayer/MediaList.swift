//
//  MediaList.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import Foundation

class MediaList {
    
    private(set) var media : Array<Media>?
    private(set) var nextPageUrl : String?
    
    class func mediaList(withDictionary dictionary: Dictionary<String, Any>) -> MediaList
    {
        let list = MediaList()
        list.update(withDictionary: dictionary)
        return list
    }
    
    func update(withDictionary dictionary: Dictionary<String, Any>)
    {
        self.nextPageUrl = (dictionary["pagination"] as? Dictionary<String, Any>)?["next_url"] as? String
        var media = Array<Media>()
        if let data = dictionary["data"] as? Array<Dictionary<String, Any>>
        {
            for mediaData in data
            {
                media.append(Media.media(withDictionary: mediaData))
            }
        }
        self.media = media
    }
}
