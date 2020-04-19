//
//  UploadDocVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadDocVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var txtDrivingLicence:UITextField!
    @IBOutlet weak var txtCommercialInsurance:UITextField!
    @IBOutlet weak var txtRegistrationCertificate:UITextField!
    @IBOutlet weak var txtPANCard:UITextField!
    @IBOutlet weak var txtProfilePhoto:UITextField!
    @IBOutlet weak var txtTouristPermit:UITextField!
    @IBOutlet weak var btnUpload:UIButton!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    
    fileprivate var imgDrivingLicence = UIImage()
    fileprivate var imgCommercialInsurance = UIImage()
    fileprivate var imgRegistrationCertificate = UIImage()
    fileprivate var imgPANCard = UIImage()
    fileprivate var imgProfilePhoto = UIImage()
    fileprivate var imgTouristPermit = UIImage()
    fileprivate var forImage = ""
    
    var storageRef = Storage.storage().reference()
    
    let db = Firestore.firestore()
    var userDict = [String:Any]()
    var docDict = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.manageTextFieldColor()
        self.viewConfigure()
    }
}

//MARK: - Custome Method extension
fileprivate extension UploadDocVC {
    func viewConfigure() {
        //        storageRef = Storage.storage(url:"gs://cab7-84952.appspot.com")
        txtDrivingLicence.textFieldCorner(cornerRadius: 5)
        txtCommercialInsurance.textFieldCorner(cornerRadius: 5)
        txtRegistrationCertificate.textFieldCorner(cornerRadius: 5)
        txtPANCard.textFieldCorner(cornerRadius: 5)
        txtProfilePhoto.textFieldCorner(cornerRadius: 5)
        txtTouristPermit.textFieldCorner(cornerRadius: 5)
        btnUpload.buttonCorner(cornerRadius: 23)
    }
    func manageTextFieldColor() {
        (imgDrivingLicence.imageIsNull() == true) ? self.txtDrivingLicence.changeTextColor(textColor: grayColor) : self.txtDrivingLicence.changeTextColor(textColor: appColor)
        (imgCommercialInsurance.imageIsNull() == true) ? self.txtCommercialInsurance.changeTextColor(textColor: grayColor) : self.txtCommercialInsurance.changeTextColor(textColor: appColor)
        (imgRegistrationCertificate.imageIsNull() == true) ? self.txtRegistrationCertificate.changeTextColor(textColor: grayColor) : self.txtRegistrationCertificate.changeTextColor(textColor: appColor)
        (imgPANCard.imageIsNull() == true) ? self.txtPANCard.changeTextColor(textColor: grayColor) : self.txtPANCard.changeTextColor(textColor: appColor)
        (imgProfilePhoto.imageIsNull() == true) ? self.txtProfilePhoto.changeTextColor(textColor: grayColor) : self.txtProfilePhoto.changeTextColor(textColor: appColor)
        (imgTouristPermit.imageIsNull() == true) ? self.txtTouristPermit.changeTextColor(textColor: grayColor) : self.txtTouristPermit.changeTextColor(textColor: appColor)
    }
}

//MARK: - Button Method extension
fileprivate extension UploadDocVC {
    @IBAction func selectAction(sender: UIButton) {
        self.view.endEditing(true)
        forImage = "\(sender.tag)"
        self.selectProfileImage()
    }
    
    @IBAction func uploadAction(sender: UIButton) {
        self.view.endEditing(true)
        self.manageTextFieldColor()
        if self.imgDrivingLicence.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select Driving Licence", controller: self)
        } else if imgCommercialInsurance.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select Commercial Insurance", controller: self)
        } else if imgRegistrationCertificate.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select Registration Certificate", controller: self)
        } else if imgPANCard.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select PAN Card", controller: self)
        } else if imgProfilePhoto.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select Profile Photo", controller: self)
        } else if imgTouristPermit.imageIsNull() {
            showAlertVC(title: kAlertTitle, message: "Please select Tourist Permit", controller: self)
        } else {
            var ref: DocumentReference? = nil
            userDict["documentFile"] = docDict
            ref = db.collection("driver").addDocument(data: userDict) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    UserDefaults.standard.set("\(ref!.documentID)", forKey: "userId")
                    UserDefaults.standard.set(self.userDict, forKey: "userDetail")
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    self.db.collection("driver").document("\(ref!.documentID)").updateData(["id":"\(ref!.documentID)"])
                    setNavigationRootStoryboard()
                }
            }
        }
    }
    @IBAction func backAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Image picker Method extension
extension UploadDocVC {
    func selectProfileImage() {
        let selectImage = UIAlertController(title: "Select Profile Image", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let btn0 = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        let btn1 = UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.showsCameraControls = true
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true)
            }
        })
        let btn2 = UIAlertAction(title: "Photo Library", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true;
                self.present(imagePicker, animated: true)
            }
        })
        selectImage.addAction(btn0)
        selectImage.addAction(btn1)
        selectImage.addAction(btn2)
        present(selectImage, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let newImage = resizeImage(image:(info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!)
        self.indicator.isHidden = false
        if forImage == "0" {
            self.imgDrivingLicence = newImage
            docDict["driverLicence"] = uploading(imageName: "driverLicence", img: imgDrivingLicence) { (url) in }
        } else if forImage == "1" {
            self.imgCommercialInsurance = newImage
            docDict["commercialInsurance"] = uploading(imageName: "commercialInsurance", img: imgCommercialInsurance) { (url) in }
        } else if forImage == "2" {
            self.imgRegistrationCertificate = newImage
            docDict["certificateRegistration"] = uploading(imageName: "certificateRegistration", img: imgRegistrationCertificate) { (url) in }
        } else if forImage == "3" {
            self.imgPANCard = newImage
            docDict["penCard"] = uploading(imageName: "penCard", img: imgPANCard) { (url) in }
        } else if forImage == "4" {
            self.imgProfilePhoto = newImage
            docDict["profilePicture"] = uploading(imageName: "profilePicture", img: imgProfilePhoto) { (url) in }
        } else if forImage == "5" {
            self.imgTouristPermit = newImage
            docDict["touristPermit"] = uploading(imageName: "touristPermit", img: imgTouristPermit) { (url) in }
        }
        self.manageTextFieldColor()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK: - Upload image on firestore
extension UploadDocVC {
    func uploading(imageName: String, img : UIImage, completion: @escaping ((String) -> Void)) {
        var strURL = ""
        let keyName = imageName
        let imageName = NSUUID().uuidString
        let storeImage = (self.storageRef.child(imageName) as AnyObject).child(imageName)
        if let uploadImageData = (img).pngData(){
            if uploadImageData.count > 2000000 {
                self.indicator.isHidden = true
                dismiss(animated: true)
                if forImage == "0" {
                    self.imgDrivingLicence = UIImage()
                } else if forImage == "1" {
                    self.imgCommercialInsurance = UIImage()
                } else if forImage == "2" {
                    self.imgRegistrationCertificate = UIImage()
                } else if forImage == "3" {
                    self.imgPANCard = UIImage()
                } else if forImage == "4" {
                    self.imgProfilePhoto = UIImage()
                } else if forImage == "5" {
                    self.imgTouristPermit = UIImage()
                }
                self.manageTextFieldColor()
                showAlertVC(title: kAlertTitle, message: "Please select small file", controller: self)
                return
            }
            storeImage.putData(uploadImageData, metadata: nil, completion: { (metaData, error) in
                storeImage.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        strURL = urlText
                        self.docDict[keyName] = strURL
                        self.indicator.isHidden = true
                        completion(strURL)
                    } else {
                        self.indicator.isHidden = true
                    }
                })
            })
        }
    }
}
