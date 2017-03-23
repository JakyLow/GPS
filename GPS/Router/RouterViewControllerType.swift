//
//  RouterViewController.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation

@objc
enum RouterViewControllerType:Int {
    case loginViewController, viewController, helpViewController
    
    var identifier: String {
        
        switch self {
            
        case .loginViewController:
            return "NavigationControllerLogin"
            
        case .viewController:
            return "NavigationController"
            
        case .helpViewController:
            return "HelpViewController"
            
        }
    }
}
