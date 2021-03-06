//
//  RouterViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation

@objc
enum RouterViewControllerType:Int {
    case loginViewController, viewController, helpViewController, settingsViewController, infoViewController, detailSettingsController
    
    var identifier: String {
        
        switch self {
            
        case .loginViewController:
            return "NavigationControllerLogin"
            
        case .viewController:
            return "NavigationController"
            
        case .helpViewController:
            return "HelpViewController"
            
        case .settingsViewController:
            return "SettingsViewController"
            
        case .infoViewController:
            return "InfoViewController"

        case .detailSettingsController:
            return "DetailSettingsController"
        }
    }
}
