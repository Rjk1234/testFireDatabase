//
//  VCSignUp.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import Firebase
import FirebaseAuth

class VCSignUp: UIViewController {
    //MARK:  Variable
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblFooter: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 5
        tfPassword.isSecureTextEntry = true
    }
    
    //MARK: IBAction
    @IBAction func onTapSignUp(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCLandingPage") as! VCLandingPage

//        self.navigationController?.pushViewController(vc, animated: true)
//        return
        if self.tfEmail.text == "" || self.tfPassword.text == "" || self.tfUserName.text == "" {
            //show alert here
            return
        }
        if !self.tfEmail.text!.isValidEmail() {
            //show alert
            return
        }
        Functions.showActivityIndicator(In: self)
        Auth.auth().createUser(withEmail: self.tfEmail.text!, password: self.tfPassword.text!) { authResult, error in
            Functions.hideActivityIndicator()
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    print("Error: \(error.localizedDescription)")
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    print("Error: \(error.localizedDescription)")
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    print("Error: \(error.localizedDescription)")
                case .weakPassword:
                    // Error: The password must be 6 characters long or more.
                    print("Error: \(error.localizedDescription)")
                default:
                    print("Error: \(error.localizedDescription)")
                }
                self.alertwith(title: "Survey Plus", message: "\(error.localizedDescription)", options: ["Ok"], completion: {result in })
            } else {
                print("User signs up successfully")
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let UID = newUserInfo?.uid ?? ""
                DatabaseManger.shared.saveUserToDatabse(user: UserInfo(userId: UID, userName: self.tfUserName.text!, userEmail: self.tfEmail.text!))
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func onTapLogin(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: Textfield Handle
extension VCSignUp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfUserName {
            self.tfEmail.becomeFirstResponder()
        } else if textField == self.tfEmail {
            self.tfPassword.becomeFirstResponder()
        } else if textField == self.tfPassword {
            self.tfPassword.resignFirstResponder()
        }
        return true
    }
}
