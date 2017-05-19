//
//  MarkersRepositoryImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 28.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON
import PromiseKit
import BPStatusBarAlert

class MarkersRepositoryImpl: NSObject, MarkersService {
    
    var settingsService: SettingsService!
    
    // MARK: Load markers
    func loadMarkers() -> AnyPromise {
        let url = "http://gps-tracker.com.ua/loadevents.php"
        let parameters: Parameters = [
            "param": "icars"]
        
        let promise = Promise<[Marker]> { fulfill, reject in
            
            settingsService.authorization().then{response -> Void in
                if response as! Bool == true {
                    Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            var markersArray = [Marker]()
                            for item in json["rows"].arrayValue {
                                let _marker = Marker(title: item["CarName"].stringValue, id: item["CarId"].stringValue, info: item["Speed"].stringValue, gpsLevel: item["gps_level"].stringValue, batteryLevel: item["bat_level"].stringValue, coordinate: CLLocationCoordinate2D(latitude: Double(item["pX"].stringValue)!, longitude: Double(item["pY"].stringValue)!))
                                markersArray.append(_marker)
                            }
                            fulfill(markersArray)
                        case .failure:
                            self.settingsService.getAlert(type: "error", message: "Ошибка запроса")
                        }
                    }
                    
                }
                }.catch { error in
                    self.settingsService.getAlert(type: "error", message: "Ошибка авторизации - \(error)")
            }
        }
        
        return AnyPromise(promise)
    }
    
    // MARK: Set&Get marker's model
    var _marker: Marker?
    func setMarker(marker: Marker) {
        _marker = marker
    }
    
    func getMarker() -> Marker {
        return _marker!
    }
    
    // MARK: Set&Get marker's array for fast present
    private var _markersArray: [Marker]?
    func setMarkersArray(markers: [Marker]) {
        _markersArray = markers
    }
    
    func getMarkersArray() -> [Marker]? {
        return _markersArray
    }
    
    // MARK: Find address
    func getAddressFromLatLon(pdblLatitude: String, pdblLongitude: String) -> AnyPromise {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        let promise = Promise<String> { fulfill, reject in
            
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        fulfill("адрес не найден")
                    }
                    
                    if placemarks != nil {
                    let pm = placemarks! as [CLPlacemark]

                    var addressString : String = ""
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode!
                            if pm.country != nil {
                                addressString = addressString + ", "
                            }
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country!
                            if pm.locality != nil {
                                addressString = addressString + ", "
                            }
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality!
                            if pm.thoroughfare != nil {
                                addressString = addressString + ", "
                            }
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare!
                            if pm.subThoroughfare != nil {
                                addressString = addressString + ", "
                            }
                        }
                        if pm.subThoroughfare != nil {
                            addressString = addressString + "д. " + pm.subThoroughfare!
                        }
                        fulfill(addressString)
                                }
                    }
            })
            
        }
        return AnyPromise(promise)
    }
    
}
