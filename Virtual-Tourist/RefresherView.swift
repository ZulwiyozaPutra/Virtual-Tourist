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
    
    @IBOutlet weak var deleteAllButton: UIButton!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        refresherButton.layer.cornerRadius = 5
    }

}
