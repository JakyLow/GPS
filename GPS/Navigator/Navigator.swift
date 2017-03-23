//
//  Navigator.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import UIKit

@objc
protocol Navigator {
    
    func appDelegate(didFinishLaunchingWithOptions delegate: AppDelegate)
    
    func viewController(openHelpViewController viewcontroller: ViewController)
    
    func loginViewController(openHelpViewController viewcontroller: LoginViewController)
    
    func loginViewController(openViewController viewcontroller: LoginViewController)
}

