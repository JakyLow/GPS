//
//  SettingsServiceImpl.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
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
}
