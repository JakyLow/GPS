//
//  InfoViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 05.04.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    
    var settingsService: SettingsService!
    var markersService: MarkersService!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lon: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var titleMarker: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var batteryStatus: UIImageView!
    @IBOutlet weak var gpsStatus: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        let _marker = markersService.getMarker()
        
        self.title = _marker.title
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        infoView.layer.cornerRadius = 10
        
        let _lat = String(_marker.coordinate.latitude)
        let _lon = String(_marker.coordinate.longitude)
        
        lat.text = _lat
        lon.text = _lon
        titleMarker.text = _marker.title
        subtitle.text = _marker.subtitle
        status.text = _marker.status.text
        status.textColor  = _marker.status.textColor
        batteryStatus.image = _marker.batteryLevelImage
        
        markersService.getAddressFromLatLon(pdblLatitude: _lat, pdblLongitude: _lon).then{response -> Void in
            self.adress.text = (response as! String)
            }.catch { error in
                self.adress.text = "адрес не найден"
        }
        
        let centerLocation = CLLocationCoordinate2D(latitude: (Double(_lat)! - 0.004), longitude: Double(_lon)!)
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        map.setRegion(region, animated: true)
        map.addAnnotation(_marker)
        
    }
    
}
