//
//  cellTemplate.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 22/04/22.
//

import UIKit

class cellTemplate: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var verticleView:UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTextFieldCount:UILabel!
    @IBOutlet weak var lblRadioCount:UILabel!
    @IBOutlet weak var lblCheckBoxCount:UILabel!
    @IBOutlet weak var btnSelect:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.makeShadowDrop()
        cardView.layer.cornerRadius = 5
        verticleView.layer.cornerRadius = 5
        verticleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnSelect.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
