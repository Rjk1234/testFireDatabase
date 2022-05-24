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
       if Functions.isUserTypeAdmin(){
        assignAnswersToForm()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func assignAnswersToForm(){
       let prop = selectedForm.value(forKey: "property") as! [NSDictionary]
        var newProp = [NSMutableDictionary]()
        for i in 0..<prop.count{
            if let mutableProp = prop[i].mutableCopy() as? NSMutableDictionary {
            if (mutableProp.value(forKey: "questionID") as! String) == userReview.answers![i].questionID {
                if (mutableProp.value(forKey: "qType") as! String) == "textfield" {
                    let ans = userReview.answers![i].answerText
                    mutableProp.setValue(ans!, forKey: "answer")
                }else{
                    if let optionList = mutableProp.value(forKey: "option") as? [NSDictionary]{
                        for option in optionList{
                            let answerText = userReview.answers![i].answerText as! String
                            print(answerText)
                          let arr = answerText.components(separatedBy: ",") as! [String]
                            if answerText.contains(option.value(forKey: "optitle") as! String){

                                option.setValue("true", forKey: "isSelected")
                            }else{
                                option.setValue("false", forKey: "isSelected")
                            }
                        }
                        //reset option
                        mutableProp.setValue(optionList, forKey: "option")
                    }
                }
            }
                //reset proprty
                newProp.append(mutableProp)
              
            }//mutablecopy
            
        }
        selectedForm.setValue(newProp, forKey: "property")
        print(selectedForm)
    }
    
    @IBAction func onTapBack(_ sender: UIButton){
//        if !Functions.isUserTypeAdmin(){
        selectedForm = nil
        userReview = reviewRecord()
//        }
        navigationController?.popViewController(animated: true)
    }
}
