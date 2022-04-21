//
//  AuthManager.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import FirebaseAuth

class AuthManager: NSObject {
 
    
   class func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
      }
    
   class func logOutUser(){
        do {
          try Auth.auth().signOut()
        } catch {
          print("Sign out error")
        }
    }
}
