//
//  SettingsRepositoryImpl.swift
//  test
//
//  Created by Vasily Bodnarchuk on 18.02.17.
//  Copyright © 2017 vasilybodnarchuk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit
import MessageUI

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
        let sendMailErrorAlert = UIAlertView(title: "Ошибка", message: "Ваше устройство не может отправить e-mail.  Пожалуйста, проверьте настройки и попробуйте еще раз.", delegate: self, cancelButtonTitle: "ОК")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
            switch result {
                case .sent: CRNotifications.showNotification(type: .success, title: "Сообщение отправлено!", message: "Мы постараемся ответить на Ваш e-mail в ближайшее время.", dismissDelay: 4)
                default: return
            }
    }
}


