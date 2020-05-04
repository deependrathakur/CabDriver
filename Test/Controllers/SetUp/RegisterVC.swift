//
//  RegisterVC.swift
//  Test
//  Created by Harshit on 26/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//
import UIKit

import Firebase
class RegisterVC: UIViewController,CountryCodeDelegate {
    @IBOutlet weak var txtFullName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtMobile:UITextField!
    @IBOutlet weak var txtPassword:UITextField!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnRegister:UIButton!
    @IBOutlet weak var btnCountryCode:UIButton!

    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
    }
    
    func onSelectCountry(countryCode: String) {
        self.btnCountryCode.setTitle(countryCode, for: .normal)
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
            let mobileNo = (self.btnCountryCode.currentTitle ?? "+91") + (self.txtMobile.text ?? "")
            let dict = ["available": true, "busy" : false, "cabAdded" : true, "cab_type": "micro", "currentLocation": "",
                        "deviceToken": "",
                        "documentAdded": true,
                        "gender":"", "id":"",
                        "verified":true,
                        "created":Date(),
                "email":self.txtEmail.text ?? "",
                "mobile":mobileNo,
                "password":self.txtPassword.text ?? "",
                "userType":1,
                "name":self.txtFullName.text ?? ""
                ] as [String : Any]
            let vc = UIStoryboard.init(name: mainStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: cabDetailViewController) as? CabDetailViewController
            vc?.userDict = dict
            self.navigationController?.pushViewController(vc ?? UploadDocVC(), animated: true)
        }
    }
    
    @IBAction func countruCodeAction(sender: UIButton) {
        self.view.endEditing(true)
         let vc = UIStoryboard.init(name: mainStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: "CountryCodeVC") as? CountryCodeVC
        vc?.delegat = self
        self.present(vc ?? CountryCodeVC(), animated: true, completion: nil)
    }
    
}
