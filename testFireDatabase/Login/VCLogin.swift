//
//  VCLogin.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import FirebaseAuth

class VCLogin: UIViewController {
    //MARK: Variable
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblFooter: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        AuthManager.logOutUser()
        //        if AuthManager.isUserLoggedIn() {
        //            print("No More sign ins please !!!!")
        //        }
    }
    
    //MARK: IBAction
    @IBAction func onTapLogin(_ sender: Any) {
        if self.tfEmail.text == "" || self.tfPassword.text == "" {
            //show alert here
            return
        }
        if !self.tfEmail.text!.isValidEmail() {
            //show alert
            return
        }
        
        Auth.auth().signIn(withEmail: self.tfEmail.text!, password: self.tfPassword.text!) { (authResult, error) in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    print("Error: \(error.localizedDescription)")
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    print("Error: \(error.localizedDescription)")
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    print("Error: \(error.localizedDescription)")
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    print("Error: \(error.localizedDescription)")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("User signs in successfully")
                let userInfo = Auth.auth().currentUser
                let email = userInfo?.email
            }
            
        }
    }
    @IBAction func onTapSignUp(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCSignUp") as! VCSignUp
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Textfield Handle
extension VCLogin: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfEmail {
            self.tfPassword.becomeFirstResponder()
        } else if textField == self.tfPassword {
            self.tfPassword.resignFirstResponder()
        }
        return true
    }
}
