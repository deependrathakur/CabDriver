//
//  WaitingForCustomerVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class WaitingForCustomerVC: UIViewController, SWRevealViewControllerDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var txtPicupLocation:UITextField!
    @IBOutlet weak var txtDroupLocation:UITextField!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblNumberDetail:UILabel!
    @IBOutlet weak var imgUser:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate = self
        revealViewController()?.rearViewRevealWidth = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(waitingForCustomerVC, forKey: "vc")
    }
}
//MARK: - Button Method extension
extension WaitingForCustomerVC {
    
    @IBAction func MenuAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CallAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ENSideMenu Delegate
extension WaitingForCustomerVC {
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
