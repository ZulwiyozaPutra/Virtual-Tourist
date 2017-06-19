//
//  UIStateController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class UIStateController: ViewController {
    func state(state: UIActivityState) {
        switch state {
            
        case .loading:
            self.view.isUserInteractionEnabled = false
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            activityIndicatorBackgroundView.frame = frame
            activityIndicatorBackgroundView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.40)
            self.view.addSubview(activityIndicatorBackgroundView)
            self.indicateState(activityIndicator: activityIndicator, animate: true, on: activityIndicatorBackgroundView)
            
            
        default:
            activityIndicatorBackgroundView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
            self.indicateState(activityIndicator: activityIndicator, animate: false, on: activityIndicatorBackgroundView)
            
        }
    }
    
    private func indicateState(activityIndicator: UIActivityIndicatorView, animate: Bool, on view: UIView) {
        if animate {
            
            let centerX = self.view.bounds.size.width/2
            var centerY = CGFloat()
            
            if self.navigationController == nil {
                centerY = self.view.bounds.size.height/2
            } else {
                centerY = self.view.bounds.size.height/2 - (self.navigationController?.navigationBar.bounds.height)!
            }
            
            activityIndicator.center = CGPoint(x: centerX, y: centerY)
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            
        } else {
            
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()
        }
    }
}
