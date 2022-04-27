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
        btnLogin.layer.cornerRadius = 5
        tfPassword.isSecureTextEntry = true
    }
    
    //MARK: IBAction
    @IBAction func onTapLogin(_ sender: Any) {
        if self.tfEmail.text == "" || self.tfPassword.text == "" {
            self.alertwith(title: "Survey Plus", message: "Please enter all information", options: ["Ok"], completion: {result in })
            return
        }
        if !self.tfEmail.text!.isValidEmail() {
            self.alertwith(title: "Survey Plus", message: "Please enter valid email", options: ["Ok"], completion: {result in })
            return
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCLandingPage") as! VCLandingPage
        Functions.showActivityIndicator(In: self)
        Auth.auth().signIn(withEmail: self.tfEmail.text!, password: self.tfPassword.text!) { (authResult, error) in
            Functions.hideActivityIndicator()
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
                self.alertwith(title: "Survey Plus", message: "\(error.localizedDescription)", options: ["Ok"], completion: {result in })
            } else {
                print("User signs in successfully")
                let userInfo = Auth.auth().currentUser
                let email = userInfo?.email
                let UID = userInfo?.uid ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                Functions.saveUserInfo(user:UserInfo(userId: "\(UID)", userName: "", userEmail: "\(userInfo?.email ?? "")"))
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
