//
//  cellForm.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 21/04/22.
//

import UIKit

class cellForm: UITableViewCell {
    @IBOutlet weak var cardView:UIView!
    @IBOutlet weak var verticleView:UIView!
    @IBOutlet weak var lblHeaderInfo:UILabel!
    @IBOutlet weak var lblTimeStamp:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnOpen:UIButton!
    @IBOutlet weak var btnRemove:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.makeShadowDrop()
        cardView.layer.cornerRadius = 5
        verticleView.layer.cornerRadius = 5
        verticleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        btnOpen.layer.cornerRadius = 5
        
        if Functions.isUserTypeAdmin() {
        btnRemove.isHidden = false
        btnRemove.layer.cornerRadius = btnRemove.frame.size.height/2
        btnRemove.makeShadowDrop()
        }else{
            btnRemove.isHidden = true
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


