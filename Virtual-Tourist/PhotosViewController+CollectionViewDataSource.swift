//
//  PhotosViewController+CollectionViewDataSource.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo's Cell", for: indexPath) as! CollectionViewCell
        
        if (flickrImages != nil) {
            cell.activityIndicator.startAnimating()
            cell.initWithPhoto((flickrImages?[indexPath.row])!)
            return cell
        } else {
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (flickrImages != nil) {
            return (flickrImages?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (flickrImages != nil) {
            let spacingBetweenItems: CGFloat = 3.0
            let width = (UIScreen.main.bounds.width / 3) - spacingBetweenItems
            let height = width
            return CGSize(width: width, height: height)
        } else {
            let spacingBetweenItems: CGFloat = 3.0
            let width = (UIScreen.main.bounds.width / 3) - spacingBetweenItems
            let height = width
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        let spacingBetweenItems: CGFloat = 5.0
        return spacingBetweenItems
    }
}
