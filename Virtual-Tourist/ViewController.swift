//
//  ViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let activityIndicatorBackgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        keyboardShouldResign()
    }
    
}

extension ViewController: UITextFieldDelegate {
    func isTextFieldEmpty(textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)!  {
            return true
        } else {
            return false
        }
    }
}
