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
    @IBOutlet weak var labelUrl: UILabel!
    
    func configWith(_ info: StudentInformation) {
        labelName.text = info.labelName
        labelUrl.text = info.mediaURL
    }

}
