//
//  InitialViewController.swift
//  Virtual-Tourist
//
//  Created by Zulwiyoza Putra on 6/19/17.
//  Copyright © 2017 Zulwiyoza Putra. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if isSIgnedIn() {
            presentMain(animate: true)
        } else {
            presentSignIn(animate: true)
        }
    }
    
    // log in check
    func isSIgnedIn() -> Bool {
        if UserDefaults.standard.value(forKey: "uniqueKey") as? String != nil {
            return true
        } else {
            return false
        }
    }
    
    // Presenting Main view
    func presentMain(animate: Bool) -> Void {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "MainViewController")
        if animate {
            print(mainViewController)
            self.present(mainViewController, animated: true, completion: nil)
        } else {
            self.present(mainViewController, animated: false, completion: nil)
        }
    }
    
    // Presenting Login view
    func presentSignIn(animate: Bool) -> Void {
        let storyBoard = UIStoryboard(name: "SignIn", bundle: nil)
        let signInViewController = storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        if animate {
            self.present(signInViewController, animated: true, completion: nil)
        } else {
            self.present(signInViewController, animated: false, completion: nil)
        }
    }

}
