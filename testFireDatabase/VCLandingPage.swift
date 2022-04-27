//
//  VCLandingPage.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 26/04/22.
//

import UIKit

class VCLandingPage: UIViewController {

    @IBOutlet var viewList:[UIView]!
    @IBOutlet var btnList:[UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

//        configUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
        
        configUI()
    }
    func configUI(){
        for views in viewList {
            views.isHidden = true
        }
        if Functions.isUserLogIn(){
            viewList[4].isHidden = false
            viewList[2].isHidden = false
            if Functions.isUserTypeAdmin() {
                viewList[3].isHidden = false
            }
        }else{
            viewList[0].isHidden = false
            viewList[1].isHidden = false
        }
        for btn in btnList{
            btn.layer.cornerRadius = 5
        }
    }
    
    @IBAction func onTap(_ sender: UIButton){
        switch sender.tag {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VCLogin")as! VCLogin
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VCSignUp")as! VCSignUp
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VCFormList")as! VCFormList
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = storyboard?.instantiateViewController(withIdentifier: "VCAddForm")as! VCAddForm
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            Functions.logout()
            configUI()
        default:
            print("")
        }
    }
   

}
