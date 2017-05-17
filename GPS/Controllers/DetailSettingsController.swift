//
//  DetailSettings.swift
//  GPS
//
//  Created by Maxim Mazhuga on 16.05.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

class DetailSettingsController: UITableViewController {

    var settingsService: SettingsService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markersAutoLoadingSettingsMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailSettings", for: indexPath)
        cell.textLabel?.text = markersAutoLoadingSettingsMenu[indexPath.row].0

        
        if settingsService.getTimeForTimer() == markersAutoLoadingSettingsMenu[indexPath.row].1 {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set([markersAutoLoadingSettingsMenu[indexPath.row].0, String(describing: markersAutoLoadingSettingsMenu[indexPath.row].1)], forKey: "TimeForMarkersAutoLoading")
        self.navigationController?.popViewController(animated: true)
    }
    
}
