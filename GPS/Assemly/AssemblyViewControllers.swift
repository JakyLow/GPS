//
//  AssemblyViewControllers.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import Typhoon

// MARK: ViewController
extension Assembly {
    
    func _viewController() -> AnyObject {
        return TyphoonDefinition.withClass(ViewController.self) { definition in
            definition!.injectProperty(#selector(getter: ViewController.navigator), with: self.navigator)
            definition!.injectProperty(#selector(getter: ViewController.settingsService), with: self.settingService)
            definition!.injectProperty(#selector(getter: ViewController.markersService), with: self.markersService)
            } as AnyObject
    }
}

// MARK: LoginViewController
extension Assembly {
    
    func _loginViewController() -> AnyObject {
        return TyphoonDefinition.withClass(LoginViewController.self) { definition in
            definition!.injectProperty(#selector(getter: LoginViewController.navigator), with: self.navigator)
            definition!.injectProperty(#selector(getter: LoginViewController.settingsService), with: self.settingService)
            } as AnyObject
    }
}

// MARK: HelpViewController
extension Assembly {
    
    func _helpViewController() -> AnyObject {
        return TyphoonDefinition.withClass(HelpViewController.self) { definition in
            definition!.injectProperty(#selector(getter: HelpViewController.settingsService), with: self.settingService)
            } as AnyObject
    }
}

// MARK: InfoViewController
extension Assembly {
    
    func _infoViewController() -> AnyObject {
        return TyphoonDefinition.withClass(InfoViewController.self) { definition in
            definition!.injectProperty(#selector(getter: InfoViewController.settingsService), with: self.settingService)
            definition!.injectProperty(#selector(getter: InfoViewController.markersService), with: self.markersService)
            definition!.injectProperty(#selector(getter: InfoViewController.navigator), with: self.navigator)
            } as AnyObject
    }
}
