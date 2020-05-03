//
//  CellWalletCell.swift
//  Test
//
//  Created by Harshit on 14/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class CellWallet: UITableViewCell {
    
    @IBOutlet weak var lblWalletType:UILabel!
    @IBOutlet weak var lblTransectiondate:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
