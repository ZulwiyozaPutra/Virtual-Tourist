//
//  PhotosViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var flickrImages: [FlickrImage]? = nil
    var location: CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlickrClient.getFlickrImages(location: self.location!) { (error: Error?, flickrImages: [FlickrImage]?) in
            self.flickrImages = flickrImages!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
