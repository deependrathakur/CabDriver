//
//  RegisterVC.swift
//  Test
//
//  Created by Harshit on 26/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtFullName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtMobile:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
    }
}

//MARK: - System Method extension
extension RegisterVC {
    override func viewWillAppear(_ animated: Bool) {
    }
}

//MARK: - Button Method extension
fileprivate extension RegisterVC {
    
    @IBAction func loginAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func registeredAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtFullName.isEmptyText() {
            self.txtFullName.shakeTextField()
        } else if self.txtEmail.isEmptyText() {
            self.txtEmail.shakeTextField()
        } else if !self.txtEmail.isValidateEmail() {
            showAlertVC(title: kAlertTitle, message: InvalidEmail, controller: self)
        } else if self.txtMobile.isValidateEmail() {
            self.txtMobile.shakeTextField()
        } else if self.txtPassword.isValidateEmail() {
            self.txtPassword.shakeTextField()
        } else {
            self.indicator.isHidden = false

            var ref: DocumentReference? = nil
            let dict = [
                "created":Date(),//getCurrentTimeStampWOMiliseconds(dateToConvert: Date() as NSDate),
                "email":self.txtEmail.text ?? "",
                "mobile":self.txtMobile.text ?? "",
                "mobileVerity":false,
                "emailVerify":false,
                "otp":"1234",
                "password":self.txtPassword.text ?? "",
                "userType":1,
                "wallet":0,
                "name":self.txtFullName.text ?? ""
                ] as [String : Any]

            ref = db.collection("driver").addDocument(data: dict) { err in
                self.indicator.isHidden = true
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    UserDefaults.standard.set("\(ref!.documentID)", forKey: "userId")
                    UserDefaults.standard.set(dict, forKey: "userDetail")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                }
            }
            goToNextVC(storyBoardID: mainStoryBoard, vc_id: registerVC, currentVC: self)
        }
    }
}
