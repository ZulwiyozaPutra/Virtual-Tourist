//
//  AlertViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

extension ViewController {
    func presentErrorAlertController(_ alertTitle: String?, alertMessage: String?) {
        self.executeOnMain {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            let destructive = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive, handler: nil)
            alert.addAction(destructive)
            
            guard alertTitle != nil else {
                if alertMessage != nil {
                    self.present(alert, animated: true, completion: nil)
                    return
                } else {
                    alert.title = "Error"
                    alert.message = "Something Went Wrong"
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
