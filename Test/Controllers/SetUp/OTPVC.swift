//
//  OTPVC.swift
//  Test
//
//  Created by Harshit on 27/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class OTPVC: UIViewController {
    
    @IBOutlet weak var lblMobile:UILabel!
    @IBOutlet weak var txtOTP:UITextField!
    @IBOutlet weak var btnVerify:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        } else if self.txtOTP.text != "1234" {
            showAlertVC(title: kAlertTitle, message: "Please enter valid OTP", controller: self)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
