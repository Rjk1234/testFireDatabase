//
//  VCVerification.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 12/05/22.
//

import UIKit
import FirebaseAuth

class VCVerification: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    var userInfoOnject: UserInfo!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.layer.cornerRadius = 5
    }

    @IBAction func onTapNext(_ sender: UIButton){
        Functions.showActivityIndicator(In: self)
        Auth.auth().currentUser?.reload(){result in
            print(result)
            Functions.hideActivityIndicator()
       if Auth.auth().currentUser!.isEmailVerified {
           Functions.saveUserInfo(user:UserInfo(userId: "\(self.userInfoOnject.userId!)", userName: "\(self.userInfoOnject.userName!)", userEmail: "\(self.userInfoOnject.userEmail!)"))
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCLandingPage") as! VCLandingPage
           self.navigationController?.pushViewController(vc, animated: true)
       }else{
           self.alertwith(title: "Verification Required!", message: "Please tap on the link given in the mail sent to your address to proceed!", options: ["Ok"], completion: {result in })
       }
    }
    }
}
