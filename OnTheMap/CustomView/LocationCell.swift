//
//  LocationCell.swift
//  OnTheMap
//
//  Created by Antonio on 11/23/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    static let identifier = "LocationCell"
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    func configWith(location: Location) {
        labelName.text = location.firstName ?? location.lastName
    }

}
