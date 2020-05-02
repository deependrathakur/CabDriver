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
        setNavigationRootStoryboard()
    }
}

//MARK: - Button Method extension
fileprivate extension LoginVC {
    
    @IBAction func loginAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtEmailPhone.isEmptyText() {
            self.txtEmailPhone.shakeTextField()
        } else if self.txtPassword.isEmptyText() {
            self.txtPassword.shakeTextField()
        } else {
            self.indicator.isHidden = false
            db.collection("driver").getDocuments() { (querySnapshot, err) in
                var registeredUser = false
                if let err = err {
                    self.indicator.isHidden = true
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let dict = document.data()
                        if (self.txtPassword.text == dict["password"] as? String ?? "") && ((self.txtEmailPhone.text == dict["email"] as? String ?? "") || (self.txtPassword.text == dict["mobile"] as? String ?? "")) {
                            UserDefaults.standard.set(document.documentID, forKey: "userId")
                            registeredUser = true
                            DictUserDetails = dict
                        }
                    }
                }
                if registeredUser {
                    self.indicator.isHidden = true
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    modelUserDetail = ModelUserDetail.init(Dict: DictUserDetails ?? ["":""])
                    setNavigationRootStoryboard()
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
}
