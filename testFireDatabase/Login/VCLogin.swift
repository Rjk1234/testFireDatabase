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
//        DatabaseManger.shared.removeform()
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
//        DatabaseManger.shared.checkIfEmailExists(email: self.tfEmail.text!, completion: {result in
//            print(result)
//        })
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
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                let UID = newUserInfo?.uid ?? ""
               
                DatabaseManger.shared.getUserInfo(id: "\(UID)"){result in
                    let name  = result.value(forKey: "userName") as! String
                    let user = UserInfo(userId: "\(UID)", userName: "\(name)", userEmail: "\(email ?? "")")
                if authResult!.user.isEmailVerified {
                    print("email is verified!!")
                
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCLandingPage") as! VCLandingPage
                    self.navigationController?.pushViewController(vc, animated: true)
                    Functions.saveUserInfo(user: user)
                } else {
                    authResult?.user.sendEmailVerification(){error in
                        if error ==  nil {
                            print("verification mail sent!")
                            // go to verification screen!
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCVerification") as! VCVerification
                            vc.userInfoOnject = user
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            print("retry sending verification mail")
                        }
                    }
                } }
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
