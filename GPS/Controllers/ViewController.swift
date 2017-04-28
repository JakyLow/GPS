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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfMarkers: UITableView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var ghostView: UIView!
    @IBOutlet weak var tableView: UITableView!

    let searchController = UISearchController(searchResultsController: nil)
    
// MARK: Update markers
    @IBAction func updateMarkers(_ sender: UIBarButtonItem) {
        getMarkers()
    }
// MARK: UISegmentedControl
    @IBAction func selector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            searchBar.isHidden = false
            ghostView.isHidden = false
            listOfMarkers.isHidden = false
            map.isHidden = true
        case 1:
            searchBar.isHidden = true
            ghostView.isHidden = true
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
            self.navigator.viewController(openLoginViewController: self)
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
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        settingsService.setSearchButtonText(text: "Отмена", searchBar: searchBar)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        searchBar.delegate = self
        
        getMarkers()
        
        let marker = Marker(title: "Pepa", info: "Едет", status: "o", gpsLevel: "1", batteryLevel: "1", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
        
        var array = [Marker]()
        array.append(marker)
        
//        map.addAnnotation(marker)
        map.delegate = self
        
        map.showAnnotations(array, animated: true)
    }
    
    
// MARK: GetMarkers
    var markersArray = [[String:String]]()
    var markersArrayFiltered = [[String:String]]()
    
    func getMarkers() {

        self.loadingView.isHidden = false
        
        
        settingsService.authorization().then{response -> Void in
            if response as! Bool == true {
        
          self.settingsService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [[String:String]])!
            
            if self.markersArray.count == 0 {
                self.listOfMarkers.isHidden = true
                self.loadingView.isHidden = true
            } else {
            
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.markersArrayFiltered = self.markersArray
            self.tableView.reloadData()
                
            self.loadingView.isHidden = true
            self.listOfMarkers.isHidden = false
            }
                }
            } else {
                KeychainSwift().clear()
                self.navigator.viewController(openLoginViewController: self)
            }
        }
    }

    
// MARK: TableView Settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.markersArrayFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MarkersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MarkersTableViewCell
        
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.7)
        }
    
        cell.titleTableView?.text = markersArrayFiltered[indexPath.row]["markerName"]
        let _status = (settingsService.getStatus(status: markersArrayFiltered[indexPath.row]["info"]!)).text
        cell.batteryStatus.image = settingsService.getBatLevel(level: markersArrayFiltered[indexPath.row]["bat_level"]!, status: _status!)
        cell.gpsStatus.image = settingsService.getGPSLevel(level: markersArrayFiltered[indexPath.row]["gps_level"]!, status: _status!)
        cell.status.text = _status
        cell.status.textColor = (settingsService.getStatus(status: markersArrayFiltered[indexPath.row]["info"]!)).textColor
        cell.subtitleTableView.text = settingsService.getModifySubtitleTableView(subtitle: markersArrayFiltered[indexPath.row]["info"]!)

        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.viewController(openInfoViewController: self)
        settingsService.setMarkerName(name: markersArrayFiltered[indexPath.row]["markerName"]!)
        settingsService.setMarkerInfo(info: settingsService.getModifySubtitleTableView(subtitle: markersArrayFiltered[indexPath.row]["info"]!))
        settingsService.setMarkerStatus(info: markersArrayFiltered[indexPath.row]["info"]!)
        settingsService.setMarkerLongitude(longitude: markersArrayFiltered[indexPath.row]["longitude"]!)
        settingsService.setMarkerLatitude(latitude: markersArrayFiltered[indexPath.row]["latitude"]!)
        let _status = (settingsService.getStatus(status: markersArrayFiltered[indexPath.row]["info"]!)).text
        settingsService.setMarkerBatteryStatus(img: settingsService.getBatLevel(level: markersArrayFiltered[indexPath.row]["bat_level"]!, status: _status!))
        settingsService.setMarkerGPSstatus(img: settingsService.getGPSLevel(level: markersArrayFiltered[indexPath.row]["gps_level"]!, status: _status!))
    }
    
// MARK: Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        markersArrayFiltered = searchText.isEmpty ? markersArray : markersArray.filter{
            let string = $0["markerName"]!
            return string.range(of: searchText) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        markersArrayFiltered = markersArray
        searchBar.text = ""
        tableView.reloadData()
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
