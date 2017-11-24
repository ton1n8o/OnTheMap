//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/10/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEmail.delegate = self
        userPassword.delegate = self
        userEmail.text = "antoniocarlos.dev@gmail.com"
        userPassword.text = ""
    }
    
    // MARK: - Actions
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        
        activityIndicator.startAnimating()
        enableUI(false)
        
        guard  let email = userEmail.text, !email.isEmpty else {
            activityIndicator.stopAnimating()
            enableUI(true)
            showInfo(withTitle: "Field required", withMessage: "Please fill in your email.")
            return
        }
        guard  let password = userPassword.text, !password.isEmpty else {
            activityIndicator.stopAnimating()
            enableUI(true)
            showInfo(withTitle: "Field required", withMessage: "Please fill in your password.")
            return
        }
        
        Client.shared().authenticateWith(userEmail: email, andPassword: password) { (success, errorMessage) in
            if success {
                self.performSegue(withIdentifier: "showMap", sender: nil)
            } else {
                self.performUIUpdatesOnMain {
                    self.showInfo(withTitle: "Login falied", withMessage: errorMessage ?? "Error while performing login.")
                }
            }
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
            }
            self.enableUI(true)
        }
    }
    
    // MARK: - Helpers
    
    func enableUI(_ enable: Bool) {
        performUIUpdatesOnMain {
            self.userEmail.isEnabled = enable
            self.userPassword.isEnabled = enable
            self.buttonLogin.isEnabled = enable
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

