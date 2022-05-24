//
//  Functions.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import FirebaseAuth


//MARK: Activity Indicator instance
var indicatorView: UIActivityIndicatorView?
var activityIndicator: UIActivityIndicatorView?
private var blurView: UIView?
private var effectView:UIView!

class Functions: NSObject {
    
    class func logout(){
        AuthManager.logOutUser()
        UserDefaults.standard.removeObject(forKey: "UserId")
        UserDefaults.standard.removeObject(forKey: "Email")
        UserDefaults.standard.removeObject(forKey: "Name")
    }
    
    class func isUserLogIn()->Bool{
        if let info = UserDefaults.standard.value(forKey: "UserId") as? String{
            return true
        }
        return false
    }
    
    class func isUserTypeAdmin()->Bool{
        if let info = UserDefaults.standard.value(forKey: "UserId") as? String{
            if info == "rEQyaRvZLZOVW7ToRSwKtr4ifVC2"{
                return true
            }
        }
        return false
    }
    
    class func saveUserInfo(user:UserInfo){
        UserDefaults.standard.set(user.userName, forKey: "Name")
        UserDefaults.standard.set(user.userEmail, forKey: "Email")
        UserDefaults.standard.set(user.userId, forKey: "UserId")
    }
    
    class func showActivityIndicator(In view: UIViewController) {
        activityIndicator?.removeFromSuperview()
        activityIndicator = UIActivityIndicatorView()
        blurView?.removeFromSuperview()
        blurView = UIView()
        effectView = UIView()
        effectView.removeFromSuperview()
        blurView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        blurView?.backgroundColor = .black
        blurView?.alpha = 0.4
        view.view.addSubview(blurView!)
        effectView.frame = CGRect(x: view.view.frame.midX-25, y: view.view.frame.midY-25, width: 50, height: 50)
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator?.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator?.startAnimating()
        activityIndicator?.tag = 999999
        effectView.addSubview(activityIndicator!)
        view.view.addSubview(effectView)
        view.view.bringSubviewToFront(effectView)
        if let topMostController = UIApplication.shared.windows[0].rootViewController {
            topMostController.view.isUserInteractionEnabled = false
        }
    }
    class func hideActivityIndicator() {
        activityIndicator?.removeFromSuperview()
        effectView.removeFromSuperview()
        blurView?.removeFromSuperview()
        activityIndicator = nil
        blurView = nil
        if let topMostController = UIApplication.shared.windows[0].rootViewController {
            topMostController.view.isUserInteractionEnabled = true
        }
    }
    
    class func readJsonWith(name:String)->Data?{
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }
}

extension String {
    
    func isValidEmail()-> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    
    func isValidPassword()-> Bool {
        
        if self.count >= 4 {
            return true
        }
        return false
    }
    
    
}

extension UIView{
    func makeShadowDrop(){
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 4.0
    }
}

extension UIViewController {
    func alertwith(title: String, message: String, options: [String], completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    } }
