//
//  SettingsRepository .swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation
import PromiseKit
import MessageUI

@objc
protocol SettingsRepository {
    func configuredMailComposeViewController() -> MFMailComposeViewController
    func showSendMailErrorAlert()
}

