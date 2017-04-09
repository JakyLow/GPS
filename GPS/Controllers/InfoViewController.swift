//
//  InfoViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 05.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
   
    var settingsService: SettingsService!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = settingsService.getMarkerName()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}
