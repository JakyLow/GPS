//
//  SettingsRepository .swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit
import MessageUI

@objc
protocol SettingsRepository {
    func configuredMailComposeViewController() -> MFMailComposeViewController
    func showSendMailErrorAlert()
    func authorization() -> AnyPromise
    func loadMarkers() -> AnyPromise
    func setSearchButtonText(text:String,searchBar:UISearchBar)
    func setMarkerName(name:String)
    func getMarkerName() -> String
    func setMarkerInfo(info:String)
    func getMarkerInfo() -> String
    func getBatLevel(level: String, status: String) -> UIImage
    func getGPSLevel(level: String, status: String) -> UIImage
    func getStatus(status: String) -> UILabel
    func getModifySubtitleTableView(subtitle: String) -> String
    func setMarkerLongitude(longitude:String)
    func setMarkerLatitude(latitude:String)
    func getMarkerLongitude() -> String
    func getMarkerLatitude() -> String
    func setMarkerStatus(info: String)
    func getMarkerStatus() -> UILabel
    func setMarkerBatteryStatus(img: UIImage)
    func getMarkerBatteryStatus() -> UIImage
    func setMarkerGPSstatus(img: UIImage)
    func getMarkerGPSstatus() -> UIImage
}

