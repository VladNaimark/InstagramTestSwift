//
//  ViewController.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webView.loadRequest(URLRequest(url: InstaAPI.sharedInstance.loginURL))
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        self.webView.loadRequest(URLRequest(url: InstaAPI.sharedInstance.loginURL))
    }
    
// MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if InstaAPI.sharedInstance.checkAndUpdateToken(url: request.url!)
        {
            self.performSegue(withIdentifier: "toGridSegue", sender: self)
            return false
        }
        return true
    }
}

