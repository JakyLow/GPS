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
    func getAlert(type: String, message: String)
    func configuredMailComposeViewController() -> MFMailComposeViewController
    func authorization() -> AnyPromise
    func setSearchButtonText(text:String,searchBar:UISearchBar)
    func getSleepTime() -> Double
    func getTimeForTimer() -> Double
    func getNameForTimer() -> String
}
