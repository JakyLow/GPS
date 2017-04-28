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
        
        infoView.layer.cornerRadius = 10
        lat.text = settingsService.getMarkerLatitude()
        lon.text = settingsService.getMarkerLongitude()
        titleMarker.text = settingsService.getMarkerName()
        subtitle.text = settingsService.getMarkerInfo()
        status.text = settingsService.getMarkerStatus().text
        status.textColor  = settingsService.getMarkerStatus().textColor
        batteryStatus.image = settingsService.getMarkerBatteryStatus()
        
        markersService.getAddressFromLatLon(pdblLatitude: settingsService.getMarkerLatitude(), pdblLongitude: settingsService.getMarkerLongitude()).then{response -> Void in
            self.adress.text = (response as! String)
        }
        
        self.title = settingsService.getMarkerName()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        map.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: Double(settingsService.getMarkerLatitude())!, longitude: Double(settingsService.getMarkerLongitude())!)
        
        let centerLocation = CLLocationCoordinate2D(latitude: (Double(settingsService.getMarkerLatitude())! - 0.004), longitude: Double(settingsService.getMarkerLongitude())!)
        
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = settingsService.getMarkerName()
        annotation.subtitle = settingsService.getMarkerStatus().text
        map.addAnnotation(annotation)
        
    }

}
