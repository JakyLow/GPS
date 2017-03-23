//
//  Assembly.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
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

