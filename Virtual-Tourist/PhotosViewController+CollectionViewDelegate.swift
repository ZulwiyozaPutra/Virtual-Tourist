//
//  PhotosViewController+CollectionViewDelegate.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension PhotosViewController: UICollectionViewDelegate {
    
    func getIndexesFromSelectedIndexPath() -> [Int] {
        var indexes:[Int] = []
        
        let indexPaths = collectionView.indexPathsForSelectedItems!
        
        for indexPath in indexPaths {
            indexes.append(indexPath.row)
        }
        
        return indexes
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        guard self.isEditing == true else {
            return
        }
        
        print(collectionView.indexPathsForSelectedItems!)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.5
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        guard self.isEditing == true else {
            return
        }
        
        print(collectionView.indexPathsForSelectedItems!)
        
        cell?.contentView.alpha = 1.0
    }

    
}
