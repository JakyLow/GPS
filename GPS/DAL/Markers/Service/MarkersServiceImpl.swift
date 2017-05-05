//
//  MarkersServiceImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 28.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit

class MarkersServiceImpl: NSObject, MarkersService {
    
    var markersRepository: MarkersRepository!
    
    func loadMarkers() -> AnyPromise {
        return markersRepository.loadMarkers()
    }
    
    func setMarker(marker: Marker) {
        return markersRepository.setMarker(marker: marker)
    }
    
    func getMarker() -> Marker {
        return markersRepository.getMarker()
    }
    
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> AnyPromise {
        return markersRepository.getAddressFromLatLon(pdblLatitude: pdblLatitude, pdblLongitude: pdblLongitude)
    }
}
