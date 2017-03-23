//
//  Router.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import UIKit

@objc
protocol Router {
    func presentViewController(type: RouterViewControllerType) -> UIViewController
    func pushViewController(type: RouterViewControllerType) -> UIViewController
}
