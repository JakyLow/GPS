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
}

