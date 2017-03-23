//
//  AssemblyViewControllers.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import Foundation
import Typhoon

// MARK: ViewController

extension Assembly {
    
    func _viewController() -> AnyObject {
        return TyphoonDefinition.withClass(ViewController.self) { definition in
            definition!.injectProperty(#selector(getter: ViewController.navigator), with: self.navigator)
//            definition!.injectProperty(#selector(getter: ViewController.settings), with: self.settingService)
            } as AnyObject
    }
}

// MARK: LoginViewController

extension Assembly {
    
    func _loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) { definition in
            definition!.injectProperty(#selector(getter: LoginViewController.navigator), with: self.navigator)
            } as AnyObject
    }
}
