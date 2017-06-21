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
    func selectedToDeleteFromIndexPath(_ indexPathArray: [IndexPath]) -> [Int] {
        var selected:[Int] = []
        
        for indexPath in indexPathArray {
            selected.append(indexPath.row)
        }
        return selected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard self.isEditing == true else {
            return
        }
        
        selectedIndexCells = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            
            cell?.contentView.alpha = 0.5
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard self.isEditing == true else {
            return
        }
        
        selectedIndexCells = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            
            cell?.contentView.alpha = 1
        }
    }

    
}
