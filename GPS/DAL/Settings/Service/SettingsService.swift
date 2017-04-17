//
//  Settings.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit
import MessageUI

@objc
protocol SettingsService {
    func configuredMailComposeViewController() -> MFMailComposeViewController
    func showSendMailErrorAlert()
    func authorization() -> AnyPromise
    func loadMarkers() -> AnyPromise
    func setSearchButtonText(text:String,searchBar:UISearchBar)
    func setMarkerName(name:String)
    func getMarkerName() -> String
    func getBatLevel(level: String, status: String) -> UIImage
    func getGPSLevel(level: String, status: String) -> UIImage
    func getGSMLevel(level: String) -> UILabel
    func getModifySubtitleTableView(subtitle: String) -> String
}
