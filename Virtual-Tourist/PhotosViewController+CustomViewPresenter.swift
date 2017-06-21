//
//  PhotosViewController+CustomViewPresenter.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension PhotosViewController {
    func presentRefresherView() {
        let frame = CGRect(x: 0.0, y: self.view.frame.height, width: self.view.frame.width, height: 96.0)
        self.refresherView.frame = frame
        self.view.addSubview(refresherView)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.refresherView.frame.origin.y -= 96.0
        }, completion: nil)
    }
    
    func dismissRefresherView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.refresherView.frame.origin.y += 96.0
            self.executeOnMain(withDelay: 0.2, {
                self.refresherView.removeFromSuperview()
            })
        }, completion: nil)
    }
}
