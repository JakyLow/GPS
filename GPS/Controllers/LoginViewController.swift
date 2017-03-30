//
//  LoginViewController.swift
//  GPS
//
//  Created by Maxim Mazhuga on 22.03.17.
//  Copyright © 2017 Maxim Mazhuga. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var navigator: Navigator!

    @IBAction func openHelp(_ sender: UIButton) {
        navigator.loginViewController(openHelpViewController: self)
    }
    @IBAction func openViewController(_ sender: UIButton) {
        navigator.loginViewController(openViewController: self)
    }
    
    @IBOutlet weak var gifLogin: UIImageView!
    @IBOutlet weak var Auth: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var activeTextField: UITextField?
  
    override func viewWillAppear(_ animated: Bool) {
        self.setNotificationKeyboard()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
