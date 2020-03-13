//
//  MyMenuVC.swift
//  Wedding
//
//  Created by mindiii on 11/16/17.
//  Copyright © 2017 mindiii. All rights reserved.
//

import UIKit

class MyMenuVC: UIViewController, UITableViewDelegate,UITableViewDataSource,SWRevealViewControllerDelegate {
    
    // Fro Vendor
    var arrImgOptions:[UIImage] = []
    var arrSelectedImgOptions:[UIImage] = []
    @IBOutlet weak var viewForSide: UIView!
    @IBOutlet weak var tableSide: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfigureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableSide.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
    }
    
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

// MARK: - Custom Methods
extension MyMenuVC{
    
    func ConfigureView(){
        tableSide.delegate = self
        tableSide.dataSource = self
        arrImgOptions = [#imageLiteral(resourceName: "close"),#imageLiteral(resourceName: "vehicleGray"),#imageLiteral(resourceName: "timeGray"),#imageLiteral(resourceName: "userGray")]
        arrSelectedImgOptions = [#imageLiteral(resourceName: "close"),#imageLiteral(resourceName: "vehicle"),#imageLiteral(resourceName: "time"),#imageLiteral(resourceName: "user")]
        
        tableSide.reloadData()
    }
}

// MARK: - Tableview delegate methods
extension MyMenuVC{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImgOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "cellForSideIdentifier"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyMenuCell{
            if indexPath.row == 0 {
                cell.backgroundColor = appColor
            } else {
                cell.backgroundColor = whiteColor
            }
            cell.imgOption.image = arrImgOptions[indexPath.row]
            
            let vcId = ["",cabVC,myRidesVC,userProfileVC]
            if  vcId[indexPath.row] == UserDefaults.standard.string(forKey: "vc") {
                cell.imgOption.image = arrSelectedImgOptions[indexPath.row]
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 1 {
            setRevelVC(storyBoardID: homeStoryBoard, vc_id: cabVC, currentVC: self)
        }
        else if indexPath.row == 2 {
            setRevelVC(storyBoardID: homeStoryBoard, vc_id: myRidesVC, currentVC: self)
        }
        else if indexPath.row == 3 {
            setRevelVC(storyBoardID: homeStoryBoard, vc_id: userProfileVC, currentVC: self)
        } else {
            if let currentCV = UserDefaults.standard.string(forKey: "vc") {
                setRevelVC(storyBoardID: homeStoryBoard, vc_id: currentCV, currentVC: self)
            }
        }
    }
    
    
    @IBAction func logOutAction(sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        UserDefaults.standard.set([], forKey: "userDetail")
        let sb: UIStoryboard = UIStoryboard(name: mainStoryBoard, bundle:Bundle.main)
        let vcNew = sb.instantiateViewController(withIdentifier: "main") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = vcNew
    }
    
}






