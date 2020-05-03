//
//  WalletVC.swift
//  Test
//
//  Created by Harshit on 14/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase

class WalletVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var noRecord:UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    var arrWalletList = [ModelMyRides]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getBookingList()
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate=self
        revealViewController()?.rearViewRevealWidth = 60
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(walletVC, forKey: "vc")
    }
}

//MARK: - Tableview Extension
extension WalletVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrWalletList.count > 0 {
            self.noRecord.isHidden = true
        } else {
            self.noRecord.isHidden = false
        }
        return self.arrWalletList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellWallet, for: indexPath as IndexPath) as? CellWallet {
            let object = self.arrWalletList[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: cabVC) as? CabVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK: - Firebase method extension
fileprivate extension WalletVC {
    func getBookingList() {
        self.arrWalletList.removeAll()
        self.indicator.isHidden = false
        db.collection("booking").getDocuments() { (querySnapshot, err) in
            if let err = err {
                self.indicator.isHidden = true
                self.tableView.reloadData()
                print("Error getting documents: \(err)")
            } else {
                self.arrWalletList.removeAll()
                for document in querySnapshot!.documents {
                    let modelObject = ModelMyRides.init(dict: document.data())
                    self.arrWalletList.append(modelObject)
                }
                self.tableView.reloadData()
                self.indicator.isHidden = true
            }
        }
    }
}
//MARK: - Button Method extension
fileprivate extension WalletVC {
    
    @IBAction func NotificationAction(sender: UIButton) {
        self.view.endEditing(true)
        showAlertVC(title: kAlertTitle, message: WIP, controller: self)
    }
    
    @IBAction func WithdrowAction(sender: UIButton) {
        self.view.endEditing(true)
        showAlertVC(title: kAlertTitle, message: WIP, controller: self)
    }
    
}

//MARK: - Revel extension
extension WalletVC {
    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

