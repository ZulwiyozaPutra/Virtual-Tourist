//
//  MainViewController+CustomViewPresenter.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    func presentAnnotationDetailView() {
        self.annotationDetailView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.annotationDetailView)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.annotationDetailView.frame.origin.y -= 168
        }, completion: nil)
    }
    
    func dismissAnnotationDetailView() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.annotationDetailView.frame.origin.y += 168
            self.executeOnMain(withDelay: 0.1, {
                self.annotationDetailView.removeFromSuperview()
            })
        }, completion: nil)
        
        self.location = nil
    }
    
    func presentEditModeDescriptionView() {
        let frame = CGRect(x: 0.0, y: -30.0, width: self.view.frame.width, height: 30.0)
        editingModeDescriptionView.frame = frame
        self.view.addSubview(editingModeDescriptionView)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.editingModeDescriptionView.frame.origin.y += 30.0
        }, completion: nil)
    }
    
    func dismissEditModeDescriptionView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.editingModeDescriptionView.frame.origin.y -= 30.0
            self.executeOnMain(withDelay: 0.2, {
                self.editingModeDescriptionView.removeFromSuperview()
            })
        }, completion: nil)
    }
}
