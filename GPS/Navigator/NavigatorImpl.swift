//
//  NavigatorImpl.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
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
    
}
