//
//  SettingsRepositoryImpl.swift
//  GPS
//
//  Created by Maxim Mazhuga on 18.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import MessageUI
import BPStatusBarAlert
import KeychainSwift

class SettingsRepositoryImpl: NSObject, SettingsService, MFMailComposeViewControllerDelegate {
    
    // MARK: BPStatusBarAlert Error & Confirmation
    func getAlert(type: String, message: String) {
        if type.lowercased() == "error" {
            BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                .message(message: message)
                .messageColor(color: .white)
                .bgColor(color: .flatRed)
                .show()
        } else if type.lowercased() == "confirmation" {
            BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                .message(message: message)
                .messageColor(color: .white)
                .bgColor(color: .flatGreen)
                .show()
        } else {
            print("Такой тип alert не поддерживается функцией getAlert. Доступны типы error и confirmation.")
        }
    }
    
    
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
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .sent:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.getAlert(type: "confirmation", message: "Сообщение отправлено!")
            })
            
        default: return
        }
    }
    
    // MARK: Authorization
    func authorization() -> AnyPromise {
        
        let url = "http://gps-tracker.com.ua/login.php"        
        let parameters: Parameters = [
            "login": KeychainSwift().get("login")!,
            "password": KeychainSwift().get("password")!
        ]
        
        let promise = Promise<Bool> { fulfill, reject in
            
            if Reachability.isConnectedToNetwork() == true
            {
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
                    switch response.result {
                    case .success:
                        fulfill(true)
                    case .failure:
                        self.getAlert(type: "error", message: "Неправильный логин или пароль")
                        KeychainSwift().clear()
                        fulfill(false)
                    }
                }
            } else {
                getAlert(type: "error", message: "Проблема с интернет соединением")
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
}
