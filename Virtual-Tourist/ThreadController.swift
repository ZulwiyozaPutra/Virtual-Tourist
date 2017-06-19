//
//  ThreadController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

extension ViewController {
    func executeOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func executeOnMain(withDelay timeInSecond: Double,_ updates: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSecond, execute: {
            updates()
        })
    }
}

