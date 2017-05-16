//
//  Navigator.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

@objc
protocol Navigator {
    
    func appDelegate(didFinishLaunchingWithOptions delegate: AppDelegate)
    func viewController(openHelpViewController viewcontroller: ViewController)
    func loginViewController(openHelpViewController viewcontroller: LoginViewController)
    func loginViewController(openViewController viewcontroller: LoginViewController)
    func viewController(openLoginViewController viewcontroller: ViewController)
    func viewController(openInfoViewController viewcontroller: ViewController)
    func viewController(openSettingsViewController viewcontroller: ViewController)
    func infoController(openViewController viewcontroller: InfoViewController)
    func settingsViewController(openDetailSettingsController viewcontroller: SettingsViewController)
    func detailSettingsController(openSettingsViewController viewcontroller: DetailSettingsController)
}

