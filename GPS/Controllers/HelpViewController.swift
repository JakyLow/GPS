//
//  HelpViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 21.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MessageUI

class HelpViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var settingsService: SettingsService!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Send E-mail
    @IBAction func sendEmail(_ sender: UIButton) {
        let mailComposeViewController = settingsService.configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.settingsService.showSendMailErrorAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
