//
//  Functions.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import FirebaseAuth
class Functions: NSObject {
    

 
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
