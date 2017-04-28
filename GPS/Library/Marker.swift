//
//  Markers.swift
//  GPS
//
//  Created by Maxim Mazhuga on 28.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MapKit

class Marker: NSObject, MKAnnotation {
    let title: String?
    let info: String
    let status: String
    let gpsLevel: String
    let batteryLevel: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, info: String, status: String, gpsLevel: String, batteryLevel: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.status = status
        self.gpsLevel = gpsLevel
        self.batteryLevel = batteryLevel
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return info
    }
    
    func pinColor() -> UIColor  {
        switch status {
        case "online":
            return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        default:
            return UIColor.red
        }
    }
}
