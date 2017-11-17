//
//  ViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/10/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!

    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        guard  let email = userEmail.text, !email.isEmpty else {
            print("Please fill in your email.")
            return
        }
        guard  let password = userPassword.text, !password.isEmpty else {
            print("Please fill in your password.")
            return
        }
        
    }

}

