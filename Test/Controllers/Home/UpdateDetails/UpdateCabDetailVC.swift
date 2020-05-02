//
//  UpdateCabDetailVC.swift
//  Test
//
//  Created by Harshit on 02/05/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
class UpdateCabDetailVC: UIViewController {
    
    @IBOutlet weak var txtBrandName:UITextField!
    @IBOutlet weak var txtNumber:UITextField!
    @IBOutlet weak var txtColor:UITextField!
    @IBOutlet weak var txtModelName:UITextField!
    @IBOutlet weak var btnMini:UIButton!
    @IBOutlet weak var btnMicro:UIButton!
    @IBOutlet weak var btnTruck:UIButton!
    var selectedVechicleType = 0
    let db = Firestore.firestore()
    var userDict = [String:Any]()
    
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setVechicleType(type: modelUserDetail?.cab_type ?? "mini")
        self.parseData()
        indicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func setVechicleType(type: String) {
        
        if type == "mini" {
            self.btnMini.setImage(#imageLiteral(resourceName: "active_check_box"), for: .normal)
            self.btnMicro.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
            self.btnTruck.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
        } else if type == "micro" {
            self.btnMini.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
            self.btnMicro.setImage(#imageLiteral(resourceName: "active_check_box"), for: .normal)
            self.btnTruck.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
        } else {
            self.btnMini.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
            self.btnMicro.setImage(#imageLiteral(resourceName: "inactive_check_box"), for: .normal)
            self.btnTruck.setImage(#imageLiteral(resourceName: "active_check_box"), for: .normal)
        }
    }
    func parseData() {
        if modelUserDetail?.cabAdded ?? false {
            self.txtColor.text = modelUserDetail?.cab?.color ?? ""
            self.txtNumber.text = modelUserDetail?.cab?.number ?? ""
            self.txtBrandName.text = modelUserDetail?.cab?.brandName ?? ""
            self.txtModelName.text = modelUserDetail?.cab?.modelName ?? ""
        }
    }
    @IBAction func selectVechicleType(sender: UIButton) {
        self.view.endEditing(true)
        selectedVechicleType = sender.tag
        if sender.tag == 0 {
            self.setVechicleType(type: "mini")
        } else if sender.tag == 1 {
            self.setVechicleType(type: "micro")
        } else if sender.tag == 2 {
            self.setVechicleType(type: "sedan")
        }
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtBrandName.isEmptyText() {
            self.txtBrandName.shakeTextField()
        } else if self.txtModelName.isEmptyText() {
            self.txtModelName.shakeTextField()
        } else if self.txtColor.isValidateEmail() {
            self.txtColor.shakeTextField()
        } else if self.txtNumber.isValidateEmail() {
            self.txtNumber.shakeTextField()
        } else {
            //  self.phoneVarification()
            self.indicator.isHidden = false
            if selectedVechicleType == 0 {
                userDict["cab_type"] = "mini"
            } else if selectedVechicleType == 1 {
                userDict["cab_type"] = "micro"
            } else if selectedVechicleType == 2 {
                userDict["cab_type"] = "sedan"
            }
            let dict = [ "brandName":self.txtBrandName.text ?? "",
                         "color": self.txtColor.text ?? "",
                         "modelName": self.txtModelName.text ?? "",
                         "number": self.txtNumber.text ?? ""]
            userDict["cab"] = dict
            userDict["cabAdded"] = true
            
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            indicator.isHidden = true
            modelUserDetail?.cabAdded = true
            modelUserDetail?.cab_type = userDict["cab_type"] as? String ?? ""
            modelUserDetail?.cab?.brandName = self.txtBrandName.text ?? ""
            modelUserDetail?.cab?.color = self.txtColor.text ?? ""
            modelUserDetail?.cab?.number = self.txtNumber.text ?? ""
            modelUserDetail?.cab?.modelName = self.txtModelName.text ?? ""
            self.db.collection("driver").document(userId).updateData(userDict)
            showAlertVC(title: kAlertTitle, message: "Cab detail update successfully.", controller: self)
            AppDelegate().getUserDetailFromFirebase()
        }
            indicator.isHidden = true
        }
    }
}

