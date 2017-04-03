//
//  Router.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit

@objc
protocol Router {
    func presentViewController(type: RouterViewControllerType) -> UIViewController
    func pushViewController(type: RouterViewControllerType) -> UIViewController
}
