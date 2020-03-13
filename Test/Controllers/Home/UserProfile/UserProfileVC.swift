//
//  UserProfileVC.swift
//  Test
//
//  Created by Harshit on 01/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class UserProfileVC: UIViewController, SWRevealViewControllerDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate = self
        revealViewController()?.rearViewRevealWidth = 60
        self.parseUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(userProfileVC, forKey: "vc")
    }
}

//MARK: - Custome method extension
extension UserProfileVC {
    func parseUserData() {
        if let userDetail = UserDefaults.standard.value(forKey: "userDetail") as? [String:Any] {
            self.txtName.text = dictToStringKeyParam(dict: userDetail, key: "name")
            self.txtEmail.text = dictToStringKeyParam(dict: userDetail, key: "email")
            self.txtPhone.text = dictToStringKeyParam(dict: userDetail, key: "mobile")
            self.txtAddress.text = dictToStringKeyParam(dict: userDetail, key: "address")
        }
    }
}

//MARK: - Button Method extension
fileprivate extension UserProfileVC {
    
    @IBAction func updateUserDetilAction(sender: UIButton) {
        showAlertVC(title: kAlertTitle, message: "Under development", controller: self)
    }
}
// MARK: - ENSideMenu Delegate
extension UserProfileVC {
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
            
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
            
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
            
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        case FrontViewPosition.left:
            print("Left")
            
        case FrontViewPosition.right:
            print("Right")
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
        @unknown default:
            print("Unknown")
        }
    }
    func sideMenuWillOpen() {
        self.view.isUserInteractionEnabled=false;
        print("sideMenuWillOpen")
    }
    func sideMenuWillClose() {
        self.view.isUserInteractionEnabled=true;
        print("sideMenuWillClose")
    }
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}
