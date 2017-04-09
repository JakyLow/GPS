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
        
        getMarkers()
    }
    
// MARK: Show markers
    var markersArray = [[String:String]]()
    func getMarkers() {

        self.loadingView.isHidden = false
          settingsService.loadMarkers().then{response -> Void in
            self.markersArray = (response as? [[String:String]])!
            
            if self.markersArray.count == 0 {
                self.listOfMarkers.isHidden = true
                self.loadingView.isHidden = true
            } else {
            
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.delegate = self
            self.tableView.dataSource = self 
            self.tableView.reloadData()
            
            self.loadingView.isHidden = true
            self.listOfMarkers.isHidden = false
            }
        }

    }

    
// MARK: TableView Settings
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.markersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        cell.textLabel?.text = markersArray[indexPath.row]["markerName"]
        

            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigator.viewController(openInfoViewController: self)
        settingsService.setMarkerName(name: markersArray[indexPath.row]["markerName"]!)
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
