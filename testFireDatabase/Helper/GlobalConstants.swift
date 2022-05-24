//
//  GlobalConstants.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 20/04/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


let storyboard = UIStoryboard(name: "Main", bundle: nil)

let userRef = Database.database().reference().child("Users")
let answerRef = Database.database().reference().child("Answers")
let formRef = Database.database().reference().child("Forms")
