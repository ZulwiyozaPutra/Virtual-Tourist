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
    @IBOutlet weak var dismissButton: UIButton!
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        showPhotosButton.layer.cornerRadius = 10
    }
    
}
