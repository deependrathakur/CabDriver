//
//  MyMenuCell.swift
//  Wedding
//
//  Created by mindiii on 11/17/17.
//  Copyright © 2017 mindiii. All rights reserved.
//

import UIKit

class MyMenuCell: UITableViewCell {

    @IBOutlet weak var viewOption: UIView!
    @IBOutlet weak var imgOption: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
