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
        prepareForReuse()
        self.activityIndicator.startAnimating()
        
    }
    
    //Get Photos
    
    func initWithPhoto(_ photo: Photo) {
        
        if photo.imageData == nil {
            downloadImage(photo)
        } else {
            self.imageView.image = UIImage(data: photo.imageData! as Data)
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    //Download Images
    
    private func downloadImage(_ photo: Photo) -> Void {
        URLSession.shared.dataTask(with: URL(string: photo.imageURL!)!) { (data, response, error) in
            if error == nil {
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data! as Data)
                    self.activityIndicator.stopAnimating()
                    self.saveImageDataToCoreData(photo: photo, imageData: data! as NSData)
                }
            }
        }.resume()
    }
    
    //Save Images
    func saveImageDataToCoreData(photo: Photo, imageData: NSData) {
        do {
            photo.imageData = imageData
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack
            try stack.saveContext()
        } catch {
            print("Saving Photo imageData Failed")
        }
    }


}
