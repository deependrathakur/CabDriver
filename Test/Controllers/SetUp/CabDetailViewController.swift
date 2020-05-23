//
//  CabDetailViewController.swift
//  Test
//
//  Created by Harshit on 19/04/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase

class CabDetailViewController: UIViewController {
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
        self.setVechicleType(type: "mini")
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
            self.indicator.stopAnimating()
            
         let vc = UIStoryboard.init(name: mainStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: uploadDocVC) as? UploadDocVC
         vc?.userDict = dict
         self.navigationController?.pushViewController(vc ?? UploadDocVC(), animated: true)
         }
     }
}

