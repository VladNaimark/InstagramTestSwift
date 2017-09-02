//
//  MediaGridVC.swift
//  MediaDataSwift
//
//  Created by Vlad Naimark on 9/2/17.
//  Copyright © 2017 Vlad Naimark. All rights reserved.
//

import UIKit

let MEDIA_PER_REQUEST = 7

class MediaGridVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var mediaList : MediaList?
    var requestingData : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.requestData()
        
        let screenSize = UIScreen.main.bounds.size
        let minSize = min(screenSize.width, screenSize.height)
        let itemsPerRow = ceil(minSize / 150)
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: ceil(minSize / itemsPerRow), height: ceil(minSize / itemsPerRow))
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        let newBackButton = UIBarButtonItem(title: "🚪 Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    
    func logout(sender: Any?) -> Void {
        InstaAPI.sharedInstance.logout()
        self.performSegue(withIdentifier: "toLoginSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMedia"
        {
            (segue.destination as! MediaVC).media = (self.mediaList?.media?[(self.collectionView.indexPathsForSelectedItems?.first?.item)!])!
        }
    }

// MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mediaList?.media?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaListCell", for: indexPath) as! MediaListCell
        cell.media = (self.mediaList?.media?[indexPath.item])!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toMedia", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.requestingData || self.mediaList?.nextPageUrl == nil
        {
            return
        }
        
        if indexPath.item > (self.mediaList?.media?.count)! - MEDIA_PER_REQUEST/2
        {
            self.requestData()
        }
    }
    
// MARK: private
    private func requestData() -> Void {
        self.requestingData = true
        InstaAPI.sharedInstance.getMedia(forMediaList: self.mediaList, count: MEDIA_PER_REQUEST) {[weak self] (mediaList: MediaList?, error: Error?) in
            
            if self == nil
            {
                return;
            }
            
            self?.requestingData = false
            if let error = error
            {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            if let mediaList = mediaList
            {
                self?.mediaList = mediaList
                self?.collectionView.reloadData()
            }
        }
    }
}
