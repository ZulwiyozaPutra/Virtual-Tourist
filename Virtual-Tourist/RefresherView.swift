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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.clear
        refresherButton.layer.cornerRadius = 5
    }

}
