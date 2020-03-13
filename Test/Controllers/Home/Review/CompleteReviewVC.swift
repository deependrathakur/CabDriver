//
//  CompleteReviewVC.swift
//  Test
//
//  Created by Harshit on 29/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CompleteReviewVC: UIViewController {
    @IBOutlet weak var txtPicupLocation:UITextField!
    @IBOutlet weak var txtDroupLocation:UITextField!

    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblTimeDate:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Button Method extension
extension CompleteReviewVC {
    
    @IBAction func backAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
