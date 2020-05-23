//
//  OTPVC.swift
//  Test
//
//  Created by Harshit on 27/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class OTPVC: UIViewController {
    
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var lblMobile:UILabel!
    @IBOutlet weak var txtOTP:UITextField!
    @IBOutlet weak var btnVerify:UIButton!
    var driverDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblMobile.text = driverDict["mobile"] as? String ?? ""
        self.indicator.isHidden = true
    }
}

//MARK: - System Method extension
extension OTPVC {
    override func viewWillAppear(_ animated: Bool) {
    }
}

//MARK: - Button Method extension
fileprivate extension OTPVC {
    
    @IBAction func verifiAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtOTP.isEmptyText() {
            self.txtOTP.shakeTextField()
        } else {
            verifyCode()
        }
    }
    
    func verifyCode() {
        let verificationID = UserDefaults.standard.value(forKey: "firebase_verification")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode: self.txtOTP.text ?? "")
        self.indicator.isHidden = false

        Auth.auth().signIn(with: credential) { (response, error) in
            if error == nil {
                self.nextVC()
            } else {
                self.indicator.isHidden = true
                showAlertVC(title: kAlertTitle, message: kErrorMessage, controller: self)
            }
        }
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func nextVC() {
        let vc = UIStoryboard.init(name: mainStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: cabDetailViewController) as? CabDetailViewController
        driverDict["mobileVerity"] = true
        driverDict["otp"] = self.txtOTP.text ?? ""
        vc?.userDict = driverDict
        self.navigationController?.pushViewController(vc ?? UploadDocVC(), animated: true)
    }
}


