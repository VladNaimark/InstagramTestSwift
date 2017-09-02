//
//  InstaData.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import UIKit
import AFNetworking

class InstaAPI
{
    static let sharedInstance = InstaAPI()
    
    var loginURL : URL {
        return URL(string: "https://api.instagram.com/oauth/authorize/?client_id=\(CLIENT_ID)&redirect_uri=\(REDIRECT_URI)&response_type=token")!
    }
    
    let sessionManager = AFHTTPSessionManager()
    
    private var accessToken = ""
    private let CLIENT_SECRET = "7a316fbc1ac14f139ab4045442fcfd62"
    private let CLIENT_ID = "515632bc76bb4f8ea4702243d86a1422"
    private let REDIRECT_URI = "https://mediadata.com/auth/instagram/callback"
    
    init() {
        self.sessionManager.responseSerializer = AFJSONResponseSerializer()
    }
    
    func checkAndUpdateToken(url: URL) -> Bool
    {
        guard url.absoluteString.hasPrefix(REDIRECT_URI) else {
            return false
        }
        
        let template = "\(REDIRECT_URI)#access_token="
        self.accessToken = url.absoluteString.replacingOccurrences(of: template, with: "")
        return true
    }
    
    func logout()
    {
        let cookieStorage = HTTPCookieStorage.shared
        var cookiesToClean = [HTTPCookie]()
        for cookie in cookieStorage.cookies!
        {
            if cookie.domain == "www.instagram.com" || cookie.domain == "api.instagram.com"
            {
                cookiesToClean.append(cookie)
            }
        }
        for cookie in cookiesToClean
        {
            cookieStorage.deleteCookie(cookie)
        }
        self.accessToken = ""
    }
    
    func getMedia(forMediaList mediaList: MediaList?, count: Int?, completion: ((_ mediaList: MediaList?, _ error: Error?) -> Void)?)
    {
        var params = Dictionary<String, Any>()
        var endPoint = "users/self/media/recent/"
        if mediaList?.nextPageUrl == nil
        {
            params["count"] = count
        }
        else
        {
            endPoint = mediaList!.nextPageUrl!
        }
        
        self.sendRequest(endPoint:endPoint, parameters: params) { (response: HTTPURLResponse?, data: Dictionary<String, Any>?, error: Error?) in
            
            if let error = error
            {
                if let completion = completion
                {
                    completion(nil, error)
                }
                return
            }
            
            mediaList?.update(withDictionary: data!)
            
            if let completion = completion
            {
                completion(mediaList ?? MediaList.mediaList(withDictionary: data!), error)
            }
        }
    }
    
// MARK: - Private
    private func sendRequest(endPoint: String, parameters: Dictionary<String, Any>?, completion : ((_ response: HTTPURLResponse?, _ data: Dictionary<String, Any>?, _ error: Error?) -> Void)? ) -> Void
    {
        var url : URL!
        var params = [String : Any]()
        params["access_token"] = self.accessToken
        
        if endPoint.hasPrefix("http")
        {
            url = URL(string: endPoint)
        }
        else
        {
            url = URL(string: "https://api.instagram.com/v1/")?.appendingPathComponent(endPoint)
        }
        
        let task = self.sessionManager.get(url.absoluteString, parameters: params, progress: nil, success: { (task: URLSessionDataTask, data : Any) in
            if let completion = completion
            {
                completion(task.response as? HTTPURLResponse, data as? Dictionary<String, Any>, nil)
            }
        }) { (task: URLSessionDataTask?, error: Error) in
            if let completion = completion
            {
                completion(task?.response as? HTTPURLResponse, nil, error)
            }
        }
        
        if task == nil && completion != nil
        {
            completion!(nil, nil, NSError(domain:"com.mediadata.swift", code:-1001, userInfo:[NSLocalizedDescriptionKey : "Network request is not available"]))
        }
    }
}










