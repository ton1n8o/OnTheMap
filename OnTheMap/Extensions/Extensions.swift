//
//  Extensions.swift
//  OnTheMap
//
//  Created by Antonio on 11/25/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

