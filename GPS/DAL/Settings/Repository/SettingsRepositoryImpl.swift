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
        
        mailComposerVC.setToRecipients(["everly@bk.ru"])
        mailComposerVC.setSubject("GPS tracking: Bugreport from user [iOS \(gAppVersion) - \(gAppBuild)]")
        mailComposerVC.setMessageBody("\n\n\n- \(UIDevice.current.model) (\(UIDevice.current.systemVersion))\n- GPS tracking \(gAppVersion) (\(gAppBuild))", isHTML: false)
        
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
                        fulfill(true)
                    case .failure:
                        BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                            .message(message: "Неправильный логин или пароль")
                            .messageColor(color: .white)
                            .bgColor(color: .flatRed)
                            .show()
                        fulfill(false)
                    }
                }
            }
            else
            {
                BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                    .message(message: "Проблема с интернет соединением")
                    .messageColor(color: .white)
                    .bgColor(color: .flatRed)
                    .show()
            }
            
        }
        
        return AnyPromise(promise)
    }
}
