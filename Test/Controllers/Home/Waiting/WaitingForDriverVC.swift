//
//  WaitingForDriverVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class WaitingForDriverVC: UIViewController, SWRevealViewControllerDelegate {
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
}
//MARK: - Button Method extension
extension WaitingForDriverVC {
    
    @IBAction func MenuAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CallAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reviewAction(sender: UIButton) {
         self.view.endEditing(true)
        goToNextVC(storyBoardID: homeStoryBoard, vc_id: writeReviewVC, currentVC: self)
     }
}
