//
//  ViewController+Extensions.swift
//  OnTheMap
//
//  Created by Antonio on 11/18/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showInfo(withTitle: String = "Info", withMessage: String) {
        let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
