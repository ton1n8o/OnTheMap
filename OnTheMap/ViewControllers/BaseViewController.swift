//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any) {
        
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        
    }

}
