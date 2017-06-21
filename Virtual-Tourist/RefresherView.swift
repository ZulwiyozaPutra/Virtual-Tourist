//
//  RefresherView.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/21/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class RefresherView: UIView {

    @IBOutlet weak var refresherButton: UIButton!
    
    @IBOutlet weak var selectAllButton: UIButton!
    
    @IBOutlet weak var deselectAllButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        refresherButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
        deleteButton.layer.borderWidth = 1
        let red = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        deleteButton.layer.borderColor = red.cgColor
    }

}
