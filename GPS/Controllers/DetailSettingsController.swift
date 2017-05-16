//
//  DetailSettings.swift
//  GPS
//
//  Created by Maxim Mazhuga on 16.05.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

class DetailSettingsController: UITableViewController {

    var navigator: Navigator!
    var settingsService: SettingsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
    }
    
}
