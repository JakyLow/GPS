//
//  ViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var navigator: Navigator!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listOfMarkers: UITableView!
    @IBOutlet weak var map: MKMapView!

// MARK: UISegmentedControl
    @IBAction func selector(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex  {
        case 0:
            searchBar.isHidden = false
            listOfMarkers.isHidden = false
            map.isHidden = true
        case 1:
            searchBar.isHidden = true
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
            })
            let exitAction = UIAlertAction(title: "Сменить аккаунт", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
