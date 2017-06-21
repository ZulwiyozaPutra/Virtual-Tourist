//
//  AnnotationDetailView.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit
import MapKit

class AnnotationDetailView: UIView {

    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstLineSubtitle: UILabel!
    @IBOutlet weak var secondLineSubtitle: UILabel!
    @IBOutlet weak var showPhotosButton: UIButton!
    @IBOutlet weak var removeLocationButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
        showPhotosButton.layer.cornerRadius = 5
        removeLocationButton.layer.cornerRadius = 5
        removeLocationButton.layer.borderWidth = 1
        let red = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        removeLocationButton.layer.borderColor = red.cgColor
    }
    
}
