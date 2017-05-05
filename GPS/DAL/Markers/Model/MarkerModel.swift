//
//  MarkerModel.swift
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
    private let gpsLevel: String
    private let batteryLevel: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, info: String, gpsLevel: String, batteryLevel: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info.lowercased()
        self.gpsLevel = gpsLevel
        self.batteryLevel = batteryLevel
        self.coordinate = coordinate
        
        super.init()
    }
    
    var status: UILabel {
        let result = UILabel()
        
        if info.contains("gprs") {
            result.text = "offline"
            result.textColor = UIColor.flatRed
        } else {
            result.text = "online"
            result.textColor = UIColor.flatGreen
        }
        
        return result
    }
    
    var gpsLevelImage: UIImage {
        var _level = Int()
        
        if gpsLevel != "" {
            _level = Int(gpsLevel)!
        } else {
            _level = 0
        }
        
        var result = UIImage()
        
        if status.text == "online" {
            switch _level {
            case 0:
                result = #imageLiteral(resourceName: "noGPS")
            default:
                result = #imageLiteral(resourceName: "yesGPS")
            }
        } else {
            result = #imageLiteral(resourceName: "noGPS")
        }
        return result
    }
    
    var batteryLevelImage: UIImage {
        var _level = Int()
        
        if batteryLevel != "" {
            _level = Int(batteryLevel)!
        } else {
            _level = 0
        }
        
        var result = UIImage()
        
        if status.text == "online" {
            switch _level {
            case 0:
                result = #imageLiteral(resourceName: "chargingBattery")
            case 1...3:
                result = #imageLiteral(resourceName: "lowBattery")
            case 4...6:
                result = #imageLiteral(resourceName: "normalBattery")
            default:
                result = #imageLiteral(resourceName: "fullBattery")
            }
        } else {
            result = #imageLiteral(resourceName: "noBattery")
        }
        
        return result
    }
    
    var subtitle: String? {
        var result = "нет данных"
        
        if info.contains("нет данных") {
            result = info.replacingOccurrences(of: "нет данных:", with: "нет данных").replacingOccurrences(of: "д.", with: " д. ").replacingOccurrences(of: "ч. ", with: " ч. ").replacingOccurrences(of: "м.", with: " м.")
            
        } else if info.contains("стоит") {
            result = info.replacingOccurrences(of: "д.", with: " д.")
        } else if info.contains("нет gprs") {
            result = info.replacingOccurrences(of: "gprs:", with: "связи").replacingOccurrences(of: "д.", with: " д.").replacingOccurrences(of: "ч. ", with: " ч. ").replacingOccurrences(of: "м.", with: " м.")
        } else if info.contains("едет") {
            result = info.replacingOccurrences(of: "едет", with: "в движении, ")
        }
        
        return result
    }
    
    func pinColor() -> UIColor  {
        switch status.text! {
        case "online":
            return UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0)
        default:
            return UIColor.red
        }
    }
}
