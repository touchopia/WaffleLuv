//
//  InstaPhotosCollectionViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/11/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import QuartzCore

private let reuseIdentifier = "Cell"

class InstaPhotosCollectionViewController: UICollectionViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var instaApi = Instagram()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if DataStore.sharedInstance.instaPhotos.count <= 19 {
            
            instaApi.fetchInstaPhotos()
            
            print("Photos fetched") 
        } 

        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return DataStore.sharedInstance.instaPhotos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photo = DataStore.sharedInstance.instaPhotos[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as? photoCollectionViewCell

        cell?.photo.image = nil
        
        cell?.photo.layer.cornerRadius = 20
        
        cell!.photo.image = photo.image 
        
        return cell!
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = self.view.frame.size
        return CGSizeMake(size.width / 2.02, size.width / 2.02)
    }
    
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }


}
