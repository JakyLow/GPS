//
//  ViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MapKit
import KeychainSwift

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var navigator: Navigator!
    var settingsService: SettingsService!
    var markersService: MarkersService!
    var timer = Timer()
    var sleepTimer = Timer()
    var flag = 0
    let notificationCenter = NotificationCenter.default
    var sleepTime:Double?
    var timeLoading:Double?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfMarkers: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var ghostView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var centerMap: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: Update markers
    @IBAction func updateMarkers(_ sender: UIBarButtonItem) {
        if self.markersArrayFiltered?.count != 0 {
            self.map.removeAnnotations(self.markersArrayFiltered!)
        }
        getMarkers()
        self.centerMap.isHidden = true
    }
    
    // MARK: UISegmentedControl
    @IBAction func selector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            listOfMarkers.isHidden = false
            map.isHidden = true
        case 1:
            listOfMarkers.isHidden = true
            map.isHidden = false
        default:
            break;
        }
    }
    
    // MARK: UIBarButtonItem
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigator.viewController(openSettingsViewController: self)
        })
        let exitAction = UIAlertAction(title: "Сменить аккаунт", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            KeychainSwift().clear()
            self.timeLoading = nil
            self.markersArray?.removeAll()
            self.markersArrayFiltered?.removeAll()
            self.dismiss(animated: true, completion: nil)
            
        })
        let helpAction = UIAlertAction(title: "Помощь", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigator.viewController(openHelpViewController: self)
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(settingsAction)
        optionMenu.addAction(exitAction)
        optionMenu.addAction(helpAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeLoading = settingsService.getTimeForTimer()
        sleepTime = settingsService.getSleepTime()
        startTimer()
        
        notificationCenter.addObserver(self, selector: #selector(timersInvalidate), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(timerDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // MARK: Fast reload data
        let reserverdArray = markersService.getMarkersArray()
        if reserverdArray != nil {
            markersArrayFiltered = reserverdArray
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        self.hideKeyboardWhenTappedAround()
        settingsService.setSearchButtonText(text: "Отмена", searchBar: searchBar)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        searchBar.delegate = self


        getMarkers()
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
        mapView()
        centerMap.isHidden = true
    }
    
    // MARK: GetMarkers
    var markersArray:[Marker]?
    var markersArrayFiltered:[Marker]?
    
    func getMarkers() {
        self.loadingView.isHidden = false
        
        self.markersService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [Marker])!
            
            if self.markersArray?.count == 0 {
                self.ghostView.isHidden = false
                self.loadingView.isHidden = true
                self.markersArrayFiltered = []
            } else {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.markersArrayFiltered = self.markersArray
                self.tableView.reloadData()
                self.loadingView.isHidden = true
                self.ghostView.isHidden = true
                self.mapView()
                self.centerMap.isHidden = true
            }
            }.catch { error in
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Quiet GetMarkers
    func quietGetMarkers() {
        print("ViewController - quietGetMarkers")
        self.markersService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [Marker])!
            
            if self.markersArray?.count == 0 {
                self.ghostView.isHidden = false
            } else {
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.ghostView.isHidden = true
                
                if self.markersArrayFiltered != nil {
                    self.map.removeAnnotations(self.markersArrayFiltered!)
                }
                
                self.markersArrayFiltered = self.markersArray
                self.tableView.reloadData()
                self.mapView()
                self.centerMap.isHidden = true
            }
            }.catch { error in
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: MapView
    func mapView() {
        map.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        map.showAnnotations(markersArrayFiltered!, animated: true)
    }
    
    // MARK: TableView Settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.markersArrayFiltered!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MarkersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MarkersTableViewCell
        
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.7)
        }
        
        cell.titleTableView?.text = markersArrayFiltered?[indexPath.row].title
        cell.batteryStatus.image = markersArrayFiltered?[indexPath.row].batteryLevelImage
        cell.gpsStatus.image = markersArrayFiltered?[indexPath.row].gpsLevelImage
        cell.status.text = markersArrayFiltered?[indexPath.row].status.text
        cell.status.textColor = markersArrayFiltered?[indexPath.row].status.textColor
        cell.subtitleTableView.text = markersArrayFiltered?[indexPath.row].subtitle
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        markersService.setMarker(marker: (markersArrayFiltered?[indexPath.row])!)
        navigator.viewController(openInfoViewController: self)
    }
    
    // MARK: Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timersInvalidate()
        
        map.removeAnnotations(markersArrayFiltered!)
        markersArrayFiltered = searchText.isEmpty ? markersArray : markersArray?.filter{
            let string = $0.title
            return string!.range(of: searchText) != nil
        }
        
        mapView()
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        startTimer()
        
        markersArrayFiltered = markersArray
        searchBar.text = ""
        mapView()
        tableView.reloadData()
    }
    
    // MARK: Pause timer if touch map
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if flag == 3 {
            timersInvalidate()
            centerMap.isHidden = false
            print("ViewController - sleep timer")
            sleepTimer = Timer.scheduledTimer(timeInterval: sleepTime!, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: false)
        }
        
        if flag < 3 {
            flag += 1
        }
    }

    func timerDidBecomeActive() {
        print("ViewController - didBecomeActive")
        quietGetMarkers()
        startTimer()
    }
    
    // MARK: Timers
    func startTimer() {
        print("ViewController - start timer")
        if timeLoading != 0.0 {
            timer = Timer.scheduledTimer(timeInterval: timeLoading!, target: self, selector: #selector(self.quietGetMarkers), userInfo: nil, repeats: true)
        }
    }
    
    func timersInvalidate() {
        print("ViewController - stop timers")
        timer.invalidate()
        sleepTimer.invalidate()
    }
}

// MARK: Hide Keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
