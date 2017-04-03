//
//  Assembly.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import Typhoon

// MARK: AppDelegate
class Assembly: TyphoonAssembly {
    
    func appDelegate() -> AnyObject {
        return TyphoonDefinition.withClass(AppDelegate.self) { definition in
            definition!.injectProperty(#selector(getter: AppDelegate.navigator), with: self.navigator)
            } as AnyObject
    }
}

