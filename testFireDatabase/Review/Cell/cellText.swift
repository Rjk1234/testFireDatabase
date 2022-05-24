//
//  cellText.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 23/05/22.
//

import UIKit

class cellText: UITableViewCell {
    @IBOutlet weak var lblText:UILabel!
    @IBOutlet weak var bgView:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.makeShadowDrop()
        bgView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
