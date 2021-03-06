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
    
    var navigator: Navigator!
    var settingsService: SettingsService!
    var markersService: MarkersService!
    var timer = Timer()
    var sleepTimer = Timer()
    var markersArray:[Marker]?
    var reserveMarker:Marker?
    var flag = 0
    var _marker:Marker?
    let notificationCenter = NotificationCenter.default
    var sleepTime:Double?
    var timeLoading:Double?
    
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
    @IBOutlet weak var centerMap: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
    @IBAction func updateMarker(_ sender: Any) {
        getMarkers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeLoading = settingsService.getTimeForTimer()
        sleepTime = settingsService.getSleepTime()
        startTimer()
        
        notificationCenter.addObserver(self, selector: #selector(timersInvalidate), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(timerDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        infoView.layer.cornerRadius = 10
        
        _marker = markersService.getMarker()
        reloadData(marker: _marker!)
        
        mapView(map, regionWillChangeAnimated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timersInvalidate()
        
        notificationCenter.removeObserver(self, name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: Center map
    @IBAction func centerMap(_ sender: UIButton) {
        if markersArray != nil {
            for item in self.markersArray! {
                if item.id == _marker!.id {
                    if self.reserveMarker != nil {
                        self.map.removeAnnotation(self.reserveMarker!)
                    }
                    self.reloadData(marker: item)
                }
            }
        } else {
            self.reloadData(marker: _marker!)
        }
        centerMap.isHidden = true
    }
    
    // MARK: Reload data
    func reloadData(marker: Marker) {
        self.title = marker.title
        let _lat = String(marker.coordinate.latitude)
        let _lon = String(marker.coordinate.longitude)
        lat.text = _lat
        lon.text = _lon
        titleMarker.text = marker.title
        subtitle.text = marker.subtitle
        status.text = marker.status.text
        status.textColor  = marker.status.textColor
        batteryStatus.image = marker.batteryLevelImage
        gpsStatus.image = marker.gpsLevelImage
        
        markersService.getAddressFromLatLon(pdblLatitude: _lat, pdblLongitude: _lon).then{response -> Void in
            self.adress.text = (response as! String)
            }.catch { error in
                self.adress.text = "адрес не найден"
        }
        
        let centerLocation = CLLocationCoordinate2D(latitude: (Double(_lat)! - 0.004), longitude: Double(_lon)!)
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegion(center: centerLocation, span: span)
        map.setRegion(region, animated: true)
        map.addAnnotation(marker)
        reserveMarker(marker: marker)
    }
    
    // MARK: Reserve old marker
    func reserveMarker(marker: Marker) {
        reserveMarker = marker
    }
    
    // MARK: GetMarkers
    func getMarkers() {
        self.loadingView.isHidden = false
        
        self.markersService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [Marker])!
            
            if self.markersArray?.count == 0 {
                self.navigationController?.popViewController(animated: true)
            } else {
                for item in self.markersArray! {
                    if item.id == self._marker!.id {
                        if self.reserveMarker != nil {
                            self.map.removeAnnotation(self.reserveMarker!)
                        }
                        self.reloadData(marker: item)
                    }
                }
                self.loadingView.isHidden = true
                self.centerMap.isHidden = true
            }
            }.catch { error in
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Quiet GetMarkers
    func quietGetMarkers() {
        print("InfoViewController - quietGetMarkers")
        self.markersService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [Marker])!
            if self.markersArray?.count == 0 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.markersService.setMarkersArray(markers: self.markersArray!)
                for item in self.markersArray! {
                    if item.id == self._marker!.id {
                        if self.reserveMarker != nil {
                            self.map.removeAnnotation(self.reserveMarker!)
                        }
                        self.reloadData(marker: item)
                        self.centerMap.isHidden = true
                    }
                }
            }
            }.catch { error in
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Pause timer if touch map
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if flag == 2 {
            timersInvalidate()
            centerMap.isHidden = false
            print("InfoViewController - sleep timer")
            sleepTimer = Timer.scheduledTimer(timeInterval: sleepTime!, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: false)
        }

        if flag < 2 {
            flag += 1
        }
    }
    
    func timerDidBecomeActive() {
        print("InfoViewController - didBecomeActive")
        quietGetMarkers()
        startTimer()
    }
    
    // MARK: Timers
    func startTimer() {
        print("InfoViewController - start timer")
        if timeLoading != 0.0 {
            timer = Timer.scheduledTimer(timeInterval: timeLoading!, target: self, selector: #selector(self.quietGetMarkers), userInfo: nil, repeats: true)
        }
    }
    
    func timersInvalidate() {
        print("InfoViewController - stop timers")
        timer.invalidate()
        sleepTimer.invalidate()
    }
}
