//
//  MyRidesVC.swift
//  Test
//
//  Created by Harshit on 27/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase

class MyRidesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var button1:UIButton!
    @IBOutlet weak var button2:UIButton!
    @IBOutlet weak var button3:UIButton!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var noRecord:UILabel!
    @IBOutlet var indicator: UIActivityIndicatorView!

    @IBOutlet var viewForSide: UIView!
    
    var arrBooking = [ModelMyRides]()
    let db = Firestore.firestore()
    var selectSegment = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getBookingList()
        button1.setTitle("UPCOMING", for: .normal)
        button2.setTitle("COMPLETED", for: .normal)
        button3.setTitle("CANCLED", for: .normal)
        changeSegmentAction(sender: button1)
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate=self
        revealViewController()?.rearViewRevealWidth = 60
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(myRidesVC, forKey: "vc")
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        viewForSide.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}

//MARK: - Tableview Extension
extension MyRidesVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrBooking.count > 0 {
            self.noRecord.isHidden = true
        } else {
            self.noRecord.isHidden = false
        }
        return self.arrBooking.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellMyRides, for: indexPath as IndexPath) as? CellMyRides {
            let object = self.arrBooking[indexPath.row]
            cell.lblPicLocation.text = object.pickup
            cell.lblDropLocation.text = object.drop
            cell.lblPrice.text = "$" + object.amount
            cell.lblDate.text = object.date
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: cabVC) as? CabVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

//MARK: - Button Method extension
fileprivate extension MyRidesVC {
    
    @IBAction func changeSegmentAction(sender: UIButton) {
        self.view.endEditing(true)
        selectSegment = sender.tag
        if sender.tag == 0 {
            button1.addBottomLineWithColor(color: appColor, lineHeight: 2, textColor: appColor)
            button2.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
            button3.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
        } else if sender.tag == 1 {
            button2.addBottomLineWithColor(color: appColor, lineHeight: 2, textColor: appColor)
            button1.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
            button3.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
        } else if sender.tag == 2 {
            button3.addBottomLineWithColor(color: appColor, lineHeight: 2, textColor: appColor)
            button2.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
            button1.addBottomLineWithColor(color: whiteColor, lineHeight: 2, textColor: grayColor)
        }
        self.getBookingList()
    }
}

//MARK: - Firebase method extension
fileprivate extension MyRidesVC {
    func getBookingList() {
        self.arrBooking.removeAll()
        self.indicator.isHidden = false
        db.collection("booking").getDocuments() { (querySnapshot, err) in
            if let err = err {
                self.indicator.isHidden = true
                self.tableView.reloadData()
                print("Error getting documents: \(err)")
            } else {
                self.arrBooking.removeAll()
                for document in querySnapshot!.documents {
                    let modelObject = ModelMyRides.init(dict: document.data())
                    if self.selectSegment == 0 && modelObject.status == "3" {
                        self.arrBooking.append(modelObject)
                    } else if self.selectSegment == 1 && modelObject.status == "4" {
                        self.arrBooking.append(modelObject)
                    } else if self.selectSegment == 2 && modelObject.status == "5" {
                        self.arrBooking.append(modelObject)
                    }
                }
                self.tableView.reloadData()
                self.indicator.isHidden = true
            }
        }
    }
}

//MARK: - Revel extension
extension MyRidesVC {
    
    // MARK: - ENSideMenu Delegate
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
