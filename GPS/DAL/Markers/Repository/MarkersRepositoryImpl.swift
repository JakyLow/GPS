//
//  MarkersRepositoryImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 28.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import Foundation
import PromiseKit
import MapKit

class MarkersRepositoryImpl: NSObject, MarkersService {
    
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
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                        fulfill("reverse geodcode fail: \(error!.localizedDescription)")
                    }
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
            })
            
        }
        return AnyPromise(promise)
    }
    
}
