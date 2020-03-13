//
//  PickerViewVC.swift
//  Test
//
//  Created by Harshit on 12/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

protocol PickerDelegate
{  func onSelectPicker(date: Date) }

class PickerViewVC: UIViewController {
   
    @IBOutlet weak var picker:UIDatePicker!
    var delegate:PickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.minimumDate = Date()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func DoneAction(sender: UIButton) {
        let date = self.picker.date
        delegate?.onSelectPicker(date: date)
        self.dismiss(animated: true, completion: nil)
    }

}
