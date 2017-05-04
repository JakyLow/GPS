//
//  MarkersService.swift
//  GPS
//
//  Created by Maxim Mazhuga on 28.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit

@objc
protocol MarkersService {
    func loadMarkers() -> AnyPromise
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> AnyPromise
}
