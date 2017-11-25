//
//  ViewController+Extensions.swift
//  OnTheMap
//
//  Created by Antonio on 11/18/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var locations: [Location] {
        get {
            return appDelegate.locations
        }
        set {
            appDelegate.locations = newValue
        }
    }
    
    func showInfo(withTitle: String = "Info", withMessage: String) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    
    func showConfirmationAlert(withMessage: String, actionTitle: String, action: @escaping () -> Void) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: nil, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (alertAction) in
                action()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
