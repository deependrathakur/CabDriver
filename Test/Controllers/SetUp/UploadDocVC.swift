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
    
    fileprivate var imgDrivingLicence = UIImage()
    fileprivate var imgCommercialInsurance = UIImage()
    fileprivate var imgRegistrationCertificate = UIImage()
    fileprivate var imgPANCard = UIImage()
    fileprivate var imgProfilePhoto = UIImage()
    fileprivate var imgTouristPermit = UIImage()
    var storage = Storage.storage()
    fileprivate var forImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageTextFieldColor()
        self.viewConfigure()
    }
}

//MARK: - Custome Method extension
fileprivate extension UploadDocVC {
    func viewConfigure() {
        storage = Storage.storage(url:"gs://cab7-84952.appspot.com")

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
        if sender.tag == 0 {
            forImage = "0"
        } else if sender.tag == 1 {
            forImage = "1"
        } else if sender.tag == 2 {
            forImage = "2"
        } else if sender.tag == 3 {
            forImage = "3"
        } else if sender.tag == 4 {
            forImage = "4"
        } else if sender.tag == 5 {
            forImage = "5"
        }
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

//            
//            let uploadTask = storage.putData(imgPANCard.pngData(), metadata: nil) { (metadata, error) in
//              guard let metadata = metadata else {
//                // Uh-oh, an error occurred!
//                return
//              }
//              // Metadata contains file metadata such as size, content-type.
//              let size = metadata.size
//              // You can also access to download URL after upload.
//              riversRef.downloadURL { (url, error) in
//                guard let downloadURL = url else {
//                  // Uh-oh, an error occurred!
//                  return
//                }
//              }
//            }
//
            let vc = UIStoryboard.init(name: homeStoryBoard, bundle: Bundle.main).instantiateViewController(withIdentifier: myRidesVC) as? MyRidesVC
            self.navigationController?.pushViewController(vc!, animated: true)
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
        let newImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        
        if forImage == "0" {
            self.imgDrivingLicence = newImage
        } else if forImage == "1" {
            self.imgCommercialInsurance = newImage
        } else if forImage == "2" {
            self.imgRegistrationCertificate = newImage
        } else if forImage == "3" {
            self.imgPANCard = newImage
        } else if forImage == "4" {
            self.imgProfilePhoto = newImage
        } else if forImage == "5" {
            self.imgTouristPermit = newImage
        }
        self.manageTextFieldColor()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
