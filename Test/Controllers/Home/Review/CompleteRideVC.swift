//
//  CompleteRideVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import HCSStarRatingView
import Firebase

class CompleteRideVC: UIViewController {
    @IBOutlet weak var txtPicupLocation:UITextField!
    @IBOutlet weak var txtDroupLocation:UITextField!
    
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblTimeDate:UILabel!
    
    let db = Firestore.firestore()
    
    var rideStatus = 1
    var bookingId = ""
    var bookingDict = ModelMyRides(dict: ["":""])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parseData()
    }
}

//MARK: - custome Method extension
extension CompleteRideVC {
    func parseData() {
        self.txtDroupLocation.text = bookingDict.dropAddress
        self.txtPicupLocation.text = bookingDict.pickupAddress
        self.lblPrice.text = "$"+bookingDict.amount
        self.lblTimeDate.text = bookingDict.createdData
    }
}

//MARK: - Button Method extension
extension CompleteRideVC {
    
    @IBAction func backAction(sender: UIButton) {
        self.view.endEditing(true)
        setNavigationRootStoryboard()
    }
    
    @IBAction func submitAction(sender: UIButton) {
        self.view.endEditing(true)
        setNavigationRootStoryboard()
    }
}
