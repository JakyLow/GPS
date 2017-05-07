//
//  NavigatorImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation

class NavigatorImpl: NSObject, Navigator {
    
    var router: Router!
    
    func appDelegate(didFinishLaunchingWithOptions delegate: AppDelegate) {
        _ = router.presentViewController(type: .loginViewController)
    }
    func viewController(openHelpViewController viewcontroller: ViewController) {
        _ = router.pushViewController(type: .helpViewController)
    }
    func loginViewController(openHelpViewController viewcontroller: LoginViewController) {
        _ = router.pushViewController(type: .helpViewController)
    }
    func loginViewController(openViewController viewcontroller: LoginViewController) {
        _ = router.presentViewController(type: .viewController)
    }
    func viewController(openLoginViewController viewcontroller: ViewController) {
        _ = router.presentViewController(type: .loginViewController)
    }
    func viewController(openInfoViewController viewcontroller: ViewController) {
        _ = router.pushViewController(type: .infoViewController)
    }
    func viewController(openSettingsViewController viewcontroller: ViewController) {
        _ = router.pushViewController(type: .settingsViewController)
    }
    func infoController(openViewController viewcontroller: InfoViewController) {
        _ = router.pushViewController(type: .viewController)
    }
}
