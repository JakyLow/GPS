//
//  SettingsRepositoryImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit
import MessageUI
import BPStatusBarAlert
import KeychainSwift

protocol LoginDelegate {
    func checkFields() -> [String:String]
}

class SettingsRepositoryImpl: NSObject, SettingsService, MFMailComposeViewControllerDelegate {

    
    // MARK: Send Mail
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let gAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "0"
        let gAppBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? "0"
        let iosVersion = UIDevice.current.systemVersion
        
        mailComposerVC.setToRecipients(["everly@bk.ru"])
        mailComposerVC.setSubject("GPS tracking: Bugreport from user [iOS \(iosVersion) - \(gAppVersion) - \(gAppBuild)]")
        mailComposerVC.setMessageBody("\n\n\n- \(UIDevice.current.model) (\(iosVersion))\n- GPS tracking \(gAppVersion) (\(gAppBuild))", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
            .message(message: "Ошибка отправки e-mail")
            .messageColor(color: .white)
            .bgColor(color: .flatRed)
            .show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .sent:
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                    .message(message: "Сообщение отправлено!")
                    .messageColor(color: .white)
                    .bgColor(color: .flatGreen)
                    .show()
            })
            
        default: return
        }
    }
  
// MARK: Connection Error
    func connectionErrorAlert() {
        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
            .message(message: "Проблема с интернет соединением")
            .messageColor(color: .white)
            .bgColor(color: .flatRed)
            .show()
    }
    
// MARK: Authorization
    var delegate:LoginDelegate?
    
    func authorization() -> AnyPromise {
        
        let loginAndPassword = delegate?.checkFields()
        
        let login = (loginAndPassword?["login"])!
        let password = (loginAndPassword?["password"])!
        let url = "http://gps-tracker.com.ua/login.php"
        let parameters: Parameters = [
            "login": login,
            "password": password
        ]
        
        let promise = Promise<Bool> { fulfill, reject in
            
            if Reachability.isConnectedToNetwork() == true
            {
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success:
                        KeychainSwift().set(login, forKey: "login")
                        KeychainSwift().set(password, forKey: "password")
                        fulfill(true)
                    case .failure:
                        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                            .message(message: "Неправильный логин или пароль")
                            .messageColor(color: .white)
                            .bgColor(color: .flatRed)
                            .show()
                        KeychainSwift().clear()
                        fulfill(false)
                    }
                }
            } else {
                connectionErrorAlert()
                        fulfill(false)
            }
            
        }
        
        return AnyPromise(promise)
    }

// MARK: SearchBar settings
    func setSearchButtonText(text:String,searchBar:UISearchBar) {
        for subview in searchBar.subviews {
            for innerSubViews in subview.subviews {
                if let cancelButton = innerSubViews as? UIButton {
                    cancelButton.setTitle(text, for: .normal)
                }
            }
        }
        
    }
    
// MARK: Load markers
    func loadMarkers() -> AnyPromise {
        
        let url = "http://gps-tracker.com.ua/loadevents.php"
        let parameters: Parameters = [
            "param": "icars"
        ]
        
        let promise = Promise<[[String:String]]> { fulfill, reject in
            
            if Reachability.isConnectedToNetwork() == true
            {
                
                Alamofire.request(url, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        var markerProperties = [String:String]()
                        var markersArray = [[String:String]]()
                        for item in json["rows"].arrayValue {
                            markerProperties["markerName"] = item["CarName"].stringValue
                            markerProperties["gps_level"] = item["gps_level"].stringValue
                            markerProperties["gsm_level"] = item["gsm_level"].stringValue
                            markerProperties["bat_level"] = item["bat_level"].stringValue
                            markerProperties["longitude"] = item["X"].stringValue
                            markerProperties["latitude"] = item["Y"].stringValue
                            markerProperties["info"] = item["Speed"].stringValue
                            markersArray.append(markerProperties)
                        }
                        fulfill(markersArray)
                    case .failure:
                        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                            .message(message: "Ошибка запроса")
                            .messageColor(color: .white)
                            .bgColor(color: .flatRed)
                            .show()
                    }
                }
            } else {
                connectionErrorAlert()
            }
            
        }
        
        return AnyPromise(promise)
    }
    
    
// MARK: Markers Model
    
    var markerName = String()
    
    func setMarkerName(name:String) {
        markerName = name
    }
    
    func getMarkerName() -> String {
        return markerName
    }
    
    func getBatLevel(level: String, status: String) -> UIImage {
        var _level = Int()
        
        if level != "" {
        _level = Int(level)!
        } else {
            _level = 0
        }
        
        var result = UIImage()
        
        if status == "online" {
        switch _level {
        case 0...3:
            result = #imageLiteral(resourceName: "lowBattery")
        case 4...6:
            result = #imageLiteral(resourceName: "normalBattery")
        case 7...10:
            result = #imageLiteral(resourceName: "fullBattery")
        default:
            result = #imageLiteral(resourceName: "fullBattery")
        }
        } else {
            result = #imageLiteral(resourceName: "noBattery")
        }
        
        return result
    }
    
    func getGPSLevel(level: String, status: String) -> UIImage {
        var _level = Int()
        
        if level != "" {
            _level = Int(level)!
        } else {
            _level = 0
        }
        
        var result = UIImage()
        
        if status == "online" {
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

    func getGSMLevel(level: String) -> UILabel {
        let result = UILabel()
        
        if level == "" || level == "0" {
            result.text = "offline"
            result.textColor = UIColor.flatRed

        } else {
            result.text = "online"
            result.textColor = UIColor.flatGreen
        }
        
        return result
    }
    
    func getModifySubtitleTableView(subtitle: String) -> String {
        var result = String()
        
        if subtitle.lowercased().contains("нет данных") {
            result = "нет данных"
        } else if subtitle.lowercased().contains("стоит") {
            result = subtitle.lowercased().replacingOccurrences(of: "д.", with: " д.")
        } else if subtitle.lowercased().contains("нет gprs") {
            result = subtitle.lowercased().replacingOccurrences(of: "gprs:", with: "связи").replacingOccurrences(of: "д.", with: " д.").replacingOccurrences(of: "ч. ", with: ":").replacingOccurrences(of: "м.", with: ":00")
        }
        
        return result
    }
    
}
