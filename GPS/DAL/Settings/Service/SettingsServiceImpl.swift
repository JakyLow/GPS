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
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        return settingsRepository.configuredMailComposeViewController()
    }
    func showSendMailErrorAlert() {
        return settingsRepository.showSendMailErrorAlert()
    }
    func authorization() -> AnyPromise {
        return settingsRepository.authorization()
    }
    
    func loadMarkers() -> AnyPromise {
        return settingsRepository.loadMarkers()
    }
    
    func setSearchButtonText(text:String,searchBar:UISearchBar) {
        return settingsRepository.setSearchButtonText(text: text, searchBar: searchBar)
    }
    
    func setMarkerName(name:String) {
        return settingsRepository.setMarkerName(name: name)
    }
    
    func getMarkerName() -> String {
        return settingsRepository.getMarkerName()
    }
    
    func getBatLevel(level: String, status: String) -> UIImage {
        return settingsRepository.getBatLevel(level: level, status: status)
    }
    
    func getGPSLevel(level: String, status: String) -> UIImage {
        return settingsRepository.getGPSLevel(level: level, status: status)
    }
    
    func getGSMLevel(level: String) -> UILabel {
        return settingsRepository.getGSMLevel(level: level)
    }
    
    func getModifySubtitleTableView(subtitle: String) -> String {
        return settingsRepository.getModifySubtitleTableView(subtitle:subtitle)
    }

}
