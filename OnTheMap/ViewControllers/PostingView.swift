//
//  PostingView.swift
//  OnTheMap
//
//  Created by Antonio on 11/25/17.
//  Copyright © 2017 Antonio. All rights reserved.
//

import UIKit

class PostingView: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var buttonFindLocation: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonFindLocation.roundCorners()
        setUpNavBar()
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationItem.title = "Add Location"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "CANCEL"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

}
