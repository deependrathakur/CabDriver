//
//  UserProfileVC.swift
//  Test
//
//  Created by Harshit on 01/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class UserProfileVC: UIViewController,GMSAutocompleteViewControllerDelegate, SWRevealViewControllerDelegate {
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    var userDict = [String:Any]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate = self
        revealViewController()?.rearViewRevealWidth = 80
        self.parseUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate().getUserDetailFromFirebase()
        UserDefaults.standard.set(userProfileVC, forKey: "vc")
    }
    
    @IBAction func updateUserDetilAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.txtEmail.isEmptyText() {
            self.txtEmail.shakeTextField()
        } else if !self.txtEmail.isValidateEmail() {
            showAlertVC(title: kAlertTitle, message: InvalidEmail, controller: self)
        } else if self.txtName.isEmptyText() {
            self.txtName.shakeTextField()
        } else if self.txtPhone.isEmptyText() {
            self.txtPhone.shakeTextField()
        } else if self.txtAddress.isEmptyText() {
            self.txtAddress.shakeTextField()
        } else {
            userDict["name"] = self.txtName.text ?? ""
            userDict["email"] = self.txtEmail.text ?? ""
            userDict["address"] = self.txtAddress.text ?? ""
            userDict["mobile"] = self.txtPhone.text ?? ""
            if let userId = UserDefaults.standard.string(forKey: "userId") {
                if userId != "" {
                    self.db.collection("driver").document(userId).updateData(userDict)
                    DictUserDetails = userDict
                    modelUserDetail = ModelUserDetail.init(Dict: DictUserDetails ?? ["":""])
                    showAlertVC(title: kAlertTitle, message: "Profile update successfully.", controller: self)
                }
            }
        }
    }
    
    @IBAction func placePickerAction(sender: UIButton) {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        placePickerController.tableCellBackgroundColor = whiteColor
        placePickerController.tintColor = appColor
        placePickerController.primaryTextColor = appColor
        placePickerController.secondaryTextColor = blackColor
        present(placePickerController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        userDict["address"] = "\(place.name ?? ""), " + "\(place.formattedAddress ?? "")"
        self.txtAddress.text = userDict["address"] as? String ?? ""
        userDict["currentLocation"] = GeoPoint.init(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: - Custome method extension
extension UserProfileVC {
    func parseUserData() {
        if let userDetail = DictUserDetails {
            self.txtName.text = dictToStringKeyParam(dict: userDetail, key: "name")
            self.txtEmail.text = dictToStringKeyParam(dict: userDetail, key: "email")
            self.txtPhone.text = dictToStringKeyParam(dict: userDetail, key: "mobile")
            self.txtAddress.text = dictToStringKeyParam(dict: userDetail, key: "address")
            userDict = userDetail
            if let url = URL(string: modelUserDetail?.documentFile?.profilePicture ?? "") {
                userImage.loadImageFromURL(url: url)
            }
            let storage = Storage.storage()
            // Create a storage reference from the URL
            let aa = storage.reference(forURL:modelUserDetail?.documentFile?.profilePicture ?? "")
            print(aa)
            // Download the data, assuming a max size of 1MB (you can change this as necessary
        }
    }
}

//MARK: - Button Method extension
fileprivate extension UserProfileVC {
    @IBAction func NotificationAction(sender: UIButton) {
        showAlertVC(title: kAlertTitle, message: WIP, controller: self)
    }
    @IBAction func updateCabDetails(sender: UIButton) {
        let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: updateCabDetailVC) as? UpdateCabDetailVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func updateCertificateDetails(sender: UIButton) {
        let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: updateDocVC) as? UpdateDocVC
        self.navigationController?.pushViewController(vc!, animated: true)
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
