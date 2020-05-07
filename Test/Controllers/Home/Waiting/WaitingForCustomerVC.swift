//
//  WaitingForCustomerVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GooglePlaces
import GoogleMaps
import FirebaseAuth

class WaitingForCustomerVC: UIViewController, SWRevealViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, AuthUIDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var txtPicupLocation:UITextField!
    @IBOutlet weak var txtDroupLocation:UITextField!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var imgUser:UIImageView!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var btnCancelRide:UIButton!
    @IBOutlet weak var btnCompleteRide:UIButton!
    @IBOutlet weak var btnStartRide:UIButton!
    @IBOutlet weak var btnArrived:UIButton!
    @IBOutlet weak var lblHeader:UILabel!
    
    let db = Firestore.firestore()
    fileprivate let locationManager = CLLocationManager()
    
    var rideStatus = 1
    var bookingId = ""
    var bookingDict = ModelMyRides(dict: ["":""])
    var mobileNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.txtOTP.delegate = self
        mapView.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate = self
        revealViewController()?.rearViewRevealWidth = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.set(waitingForCustomerVC, forKey: "vc")
        self.txtPicupLocation.text = bookingDict.pickupAddress
        self.txtDroupLocation.text = bookingDict.dropAddress
        self.manageUI_OnStatus()
        self.getUserData()
    }
}

//MARK: firebase method
extension WaitingForCustomerVC {
    func getUserData() {
        if bookingDict.userId.count > 0 {
            db.collection("user").document(bookingDict.userId).getDocument { (querySnapshot, err) in
                if let err = err {
                } else {
                    if let document = querySnapshot?.data() {
                        print("<><><><><>")
                        let objModel = ModelUserDetail.init(Dict: document)
                        self.lblName.text = objModel.name
                        self.mobileNo = objModel.mobile ?? ""
                    }
                }
            }
        }
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
        if let url = URL(string: "tel://\(mobileNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func RideAction(sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1 && self.txtOTP.isEmptyText() {
            showAlertVC(title: kAlertTitle, message: "Please enter OTP", controller: self)
        } else if sender.tag == 1 {
            self.verifyCode()
        } else {
            clickRideAction(senderTag: sender.tag)
        }
    }
    
    @IBAction func currentLocation(sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: currentLocationGeoPoint.latitude, longitude: currentLocationGeoPoint.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
    func clickRideAction(senderTag:Int) {
        var message = ""
        if senderTag == 0 {
            //i have arrived
            message = "Are you arrived to pick up location?"
        } else if senderTag == 1 {
            //start ride
            message = "Are you sure to start ride?"
            
        } else if senderTag == 2 {
            //complete ride
            message = "Are you sure to complete ride?"
            
        } else if senderTag == 3 {
            //cancel booking
            message = "Are you sure to cancel ride?"
            
        } else {
            message = ""
        }
        let alertController = UIAlertController(title: kAlertTitle, message: message, preferredStyle: .alert)
        let subView = alertController.view.subviews.first!
        let alertContentView = subView.subviews.first!
        alertContentView.backgroundColor = UIColor.gray
        alertContentView.layer.cornerRadius = 20
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if senderTag == 0 {
                //i have arrived
                self.rideStatus = 2
                self.phoneVarification(mobile: modelUserDetail?.mobile ?? "00000")
            } else if senderTag == 1 {
                //start ride
                self.rideStatus = 3
                let updatedDict = ["status":self.rideStatus,] as [String : Any]
                self.db.collection("booking").document(self.bookingId).updateData(updatedDict)
                self.manageUI_OnStatus()
            } else if senderTag == 2 {
                //complete ride
                self.rideStatus = 4
                let updatedDict = ["status":self.rideStatus,] as [String : Any]
                self.db.collection("booking").document(self.bookingId).updateData(updatedDict)
                self.manageUI_OnStatus()
            } else if senderTag == 3 {
                //cancel booking
                self.rideStatus = 5
                let updatedDict = ["status":self.rideStatus,] as [String : Any]
                self.db.collection("booking").document(self.bookingId).updateData(updatedDict)
                self.manageUI_OnStatus()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func manageUI_OnStatus() {
        self.btnCancelRide.isHidden = true
        self.btnCompleteRide.isHidden = true
        self.btnStartRide.isHidden = true
        self.btnArrived.isHidden = true
        self.txtOTP.isHidden = true
        if rideStatus == 0 {
            self.lblHeader.text = "Waiting for Customer"
        } else if rideStatus == 1 {
            self.btnCancelRide.isHidden = false
            self.btnArrived.isHidden = false
            self.lblHeader.text = "Booking Detail"
        } else if rideStatus == 2 {
            self.btnCancelRide.isHidden = false
            self.btnStartRide.isHidden = false
            self.txtOTP.isHidden = false
            self.lblHeader.text = "Reached"
        } else if rideStatus == 3 {
            self.btnCompleteRide.isHidden = false
            self.lblHeader.text = "On The Way"
        } else if rideStatus == 4 {
            let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: completeRideVC) as? CompleteRideVC
            vc?.rideStatus = rideStatus
            vc?.bookingId = bookingId
            vc?.bookingDict = bookingDict
            self.navigationController?.pushViewController(vc!, animated: true)
        }
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
    
    func phoneVarification(mobile: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+919025223780", uiDelegate: self) { (verificationID, error) in
            self.indicator.isHidden = false
            if (error) != nil {
                self.indicator.isHidden = true
                print(error)
            } else {
                self.indicator.isHidden = true
                UserDefaults.standard.set(verificationID, forKey: "ride_otp")
                UserDefaults.standard.synchronize()
                let updatedDict = ["status":self.rideStatus,] as [String : Any]
                self.db.collection("booking").document(self.bookingId).updateData(updatedDict)
                self.manageUI_OnStatus()
            }
        }
    }
    
    func verifyCode() {
        let verificationID = UserDefaults.standard.value(forKey: "ride_otp")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID! as! String, verificationCode: self.txtOTP.text ?? "")
        self.indicator.isHidden = false
        
        Auth.auth().signIn(with: credential) { (response, error) in
            if error == nil {
                self.indicator.isHidden = true
                self.clickRideAction(senderTag: 1)
            } else {
                self.indicator.isHidden = true
                showAlertVC(title: kAlertTitle, message: kErrorMessage, controller: self)
            }
        }
    }
}
