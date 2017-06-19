//
//  CollectionViewCell.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Get Photos
    
    func initWithPhoto(_ flickrImage: FlickrImage) {
        
        downloadImage(flickrImage)
    }
    
    //Download Images
    
    private func downloadImage(_ flickrImage: FlickrImage) {
        
        let url = URL(string: flickrImage.imageURL)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data! as Data)
                    self.activityIndicator.stopAnimating()
                }
            }
            
        }
        .resume()
    }

}
