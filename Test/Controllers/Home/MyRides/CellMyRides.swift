//
//  CellMyRides.swift
//  Test
//
//  Created by Harshit on 27/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class CellMyRides: UITableViewCell {
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblNo:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblPicLocation:UILabel!
    @IBOutlet weak var lblDropLocation:UILabel!
    @IBOutlet weak var imgUser:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgUser.imageCorner(cornerRadius: self.imgUser.layer.frame.width/2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
