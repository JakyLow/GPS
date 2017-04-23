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
    
    func setMarkerInfo(info:String) {
        return settingsRepository.setMarkerInfo(info: info)
    }
    
    func getMarkerInfo() -> String {
        return settingsRepository.getMarkerInfo()
    }
    
    func getBatLevel(level: String, status: String) -> UIImage {
        return settingsRepository.getBatLevel(level: level, status: status)
    }
    
    func getGPSLevel(level: String, status: String) -> UIImage {
        return settingsRepository.getGPSLevel(level: level, status: status)
    }
    
    func getStatus(status: String) -> UILabel {
        return settingsRepository.getStatus(status: status)
    }
    
    func getModifySubtitleTableView(subtitle: String) -> String {
        return settingsRepository.getModifySubtitleTableView(subtitle:subtitle)
    }
    
    func setMarkerLongitude(longitude: String) {
        return settingsRepository.setMarkerLongitude(longitude: longitude)
    }
    
    func setMarkerLatitude(latitude: String) {
        return settingsRepository.setMarkerLatitude(latitude: latitude)
    }
    
    func getMarkerLongitude() -> String {
        return settingsRepository.getMarkerLongitude()
    }
    
    func getMarkerLatitude() -> String {
        return settingsRepository.getMarkerLatitude()
    }
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> AnyPromise {
        return settingsRepository.getAddressFromLatLon(pdblLatitude: pdblLatitude, pdblLongitude: pdblLongitude)
    }
    
    func setMarkerStatus(info: String) {
        return settingsRepository.setMarkerStatus(info: info)
    }
    
    func getMarkerStatus() -> UILabel {
        return settingsRepository.getMarkerStatus()
    }
    
    func setMarkerBatteryStatus(img: UIImage) {
        return settingsRepository.setMarkerBatteryStatus(img: img)
    }

    
    func getMarkerBatteryStatus() -> UIImage {
        return settingsRepository.getMarkerBatteryStatus()
    }

    func setMarkerGPSstatus(img: UIImage) {
        return settingsRepository.setMarkerGPSstatus(img: img)
    }
    
    
    func getMarkerGPSstatus() -> UIImage {
        return settingsRepository.getMarkerGPSstatus()
    }
}
