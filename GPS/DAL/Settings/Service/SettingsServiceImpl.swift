//
//  SettingsServiceImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit
import MessageUI

class SettingsServiceImpl: NSObject, SettingsService, MFMailComposeViewControllerDelegate {
    
    var settingsRepository: SettingsRepository!
    
    func getAlert(type: String, message: String) {
        return settingsRepository.getAlert(type: type, message: message)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        return settingsRepository.configuredMailComposeViewController()
    }
    
    func authorization() -> AnyPromise {
        return settingsRepository.authorization()
    }
    
    func setSearchButtonText(text:String,searchBar:UISearchBar) {
        return settingsRepository.setSearchButtonText(text: text, searchBar: searchBar)
    }
    
    func getSleepTime() -> Double {
        return settingsRepository.getSleepTime()
    }
    
    func getTimeForTimer() -> Double {
        return settingsRepository.getTimeForTimer()
    }
}
