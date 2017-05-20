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
    func setMarker(marker: Marker)
    func getMarker() -> Marker
    func setMarkersArray(markers: [Marker])
    func getMarkersArray() -> [Marker]?
    func clearMarkersArray()
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> AnyPromise
}
