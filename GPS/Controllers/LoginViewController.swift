//
//  LoginViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 22.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import BPStatusBarAlert
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var navigator: Navigator!
    var settingsService: SettingsService!
    
    @IBAction func openHelp(_ sender: UIButton) {
        navigator.loginViewController(openHelpViewController: self)
    }
    
    @IBAction func openViewController(_ sender: UIButton) {
        if checkFields() != [:] {   auth()  }
    }
    
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var Auth: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var gifLogin: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var activeTextField: UITextField?
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
   
// MARK: DemoLogin
    @IBAction func demoAuth(_ sender: Any) {
        loginField.text = "demo"
        passField.text = "accepted"
        auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNotificationKeyboard()
        self.navigationController?.isNavigationBarHidden = true
        
// MARK: AutoLogin
    if KeychainSwift().get("login") != nil && KeychainSwift().get("password") != nil {   auth()  }
        
}
    
    fileprivate let settingsAPI = SettingsRepositoryImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsAPI.delegate = self
        
        self.gifLogin.image = UIImage.gif(name: "loginBg")
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        Auth.layer.cornerRadius = 5
        loginView.layer.cornerRadius = 5
        passwordView.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
// MARK: Keyboard settings
    func setNotificationKeyboard ()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeTextField=textField;
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeTextField=nil;
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height+10, 0.0)
        self.theScrollView.contentInset = contentInsets
        self.theScrollView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,0.0, 0.0)
        self.theScrollView.contentInset = contentInsets
        self.theScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    @IBAction override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
// MARK: Auth
    func auth() {
        
        Auth.isEnabled = false
        registerButton.isEnabled = false
        demoButton.isEnabled = false
        
        self.loadingIndicator.isHidden = false
        self.settingsAPI.authorization().then{response -> Void in
            if response as! Bool == true {
                self.navigator.loginViewController(openViewController: self)
            }
        self.loadingIndicator.isHidden = true
            
        self.Auth.isEnabled = true
        self.registerButton.isEnabled = true
        self.demoButton.isEnabled = true
            }.catch { error in
                
        }
    }
}

// MARK: TextFieds Delegate
extension LoginViewController: LoginDelegate {
    func checkFields() -> [String:String] {
        
        var result = [String:String]()
        if KeychainSwift().get("login") == nil && KeychainSwift().get("password") == nil {
            if loginField.text == "" && passField.text == "" {
                BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                    .message(message: "Введите логин и пароль")
                    .messageColor(color: .white)
                    .bgColor(color: .flatRed)
                    .show()
            } else if loginField.text == "" {
                BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                    .message(message: "Введите логин")
                    .messageColor(color: .white)
                    .bgColor(color: .flatRed)
                    .show()
            } else if passField.text == "" {
                BPStatusBarAlert(duration: 0.3, delay: 2, position: .statusBar)
                    .message(message: "Введите пароль")
                    .messageColor(color: .white)
                    .bgColor(color: .flatRed)
                    .show()
            } else {
                result["login"] = loginField.text
                result["password"] = passField.text
                KeychainSwift().set(loginField.text!, forKey: "login")
                KeychainSwift().set(passField.text!, forKey: "password")
            }
        } else {
            result["login"] = KeychainSwift().get("login")
            result["password"] = KeychainSwift().get("password")
            loginField.text = KeychainSwift().get("login")
            passField.text = KeychainSwift().get("password")
        }
        return result
    }
}
