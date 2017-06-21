//
//  MainViewController+CustomViewPresenter.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MainViewController {
    func presentPhotosViewController() {
        let annotation = mapView.selectedAnnotations[0]
        performSegue(withIdentifier: "Show Photos", sender: nil)
        mapView.deselectAnnotation(annotation, animated: false)
    }
    
    func presentPointDetailView() {
        
        self.annotationDetailView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.annotationDetailView.firstLineSubtitle.text = activeMapPointAnnotation!.title
        self.annotationDetailView.secondLineSubtitle.text = activeMapPointAnnotation!.subtitle
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
