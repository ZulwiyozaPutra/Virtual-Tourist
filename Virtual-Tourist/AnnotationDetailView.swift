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
        showPhotosButton.layer.cornerRadius = 5
        removeLocationButton.layer.cornerRadius = 5
        removeLocationButton.layer.borderWidth = 1
        let blue = UIColor(red: 64/255, green: 129/255, blue: 255/255, alpha: 1.0)
        removeLocationButton.layer.borderColor = blue.cgColor
    }
    
}
