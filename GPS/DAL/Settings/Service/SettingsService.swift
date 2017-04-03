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
}
