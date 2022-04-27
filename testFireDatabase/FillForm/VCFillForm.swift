//
//  VCFillForm.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 23/04/22.
//

import UIKit

var selectedForm: NSMutableDictionary!
var userReview = reviewRecord()
class VCFillForm: UIViewController {

    @IBOutlet weak var pageContainer:UIView!
    @IBOutlet weak var lblFormTitle:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblFormTitle.text =  selectedForm.value(forKey: "title")as! String
    }
   
    @IBAction func onTapBack(_ sender: UIButton){
        selectedForm = nil
        userReview = reviewRecord()
        navigationController?.popViewController(animated: true)
    }
}
