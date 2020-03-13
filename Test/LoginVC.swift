//
//  ViewController.swift
//  Test
//
//  Created by Harshit on 25/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmailPhone:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - System Method extension
extension LoginVC {
    override func viewWillAppear(_ animated: Bool) {
        self.indicator.isHidden = true
        self.setNavigationRootStoryboard()
    }
}

//MARK: - Button Method extension
fileprivate extension LoginVC {
    
    @IBAction func loginAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtEmailPhone.isEmptyText() {
            self.txtEmailPhone.shakeTextField()
        } else if !self.txtEmailPhone.isValidateEmail() {
            showAlertVC(title: kAlertTitle, message: InvalidEmail, controller: self)
        } else if self.txtPassword.isEmptyText() {
            self.txtPassword.shakeTextField()
        } else {
            self.indicator.isHidden = false
            db.collection("user").getDocuments() { (querySnapshot, err) in
                var registeredUser = false
                var dictUser = [String:Any]()
                if let err = err {
                    self.indicator.isHidden = true
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dict = document.data()
                        if (self.txtPassword.text == dict["password"] as? String ?? "") && ((self.txtEmailPhone.text == dict["email"] as? String ?? "") || (self.txtPassword.text == dict["mobile"] as? String ?? "")) {
                            registeredUser = true
                            dictUser = dict
                        }
                    }
                }
                if registeredUser {
                    self.indicator.isHidden = true
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    dictUser["created"] = ""
                    UserDefaults.standard.set(dictUser, forKey: "userDetail")
                    self.setNavigationRootStoryboard()
                } else {
                    self.indicator.isHidden = true
                    showAlertVC(title: kAlertTitle, message: "Please check your login detail", controller: self)
                }
            }
        }
    }
    
    @IBAction func registeredAction(sender: UIButton) {
        self.view.endEditing(true)
        goToNextVC(storyBoardID: mainStoryBoard, vc_id: registerVC, currentVC: self)
    }
    
    @IBAction func forgotAction(sender: UIButton) {
        self.view.endEditing(true)
        goToNextVC(storyBoardID: mainStoryBoard, vc_id: otpVC, currentVC: self)
    }
    
    func setNavigationRootStoryboard() {
        if UserDefaults.standard.bool(forKey: "isLogin") as Bool == true {
           let sb: UIStoryboard = UIStoryboard(name: homeStoryBoard, bundle:Bundle.main)
            let vcNew = sb.instantiateViewController(withIdentifier: "HomeNav") as? UINavigationController
            UIApplication.shared.keyWindow?.rootViewController = vcNew
        }
    }
}
