//
//  Review.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 26/04/22.
//

import UIKit

class reviewRecord {
    var formId:String?
    var answers : [Answers]?
}
class Answers {
    var questionID: String?
    var answerText: String?
}

class UserInfo:Codable{
    var userName: String?
    var userId: String?
    var userEmail: String?
    init(userId: String?, userName: String?, userEmail: String?) {
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
       
    }
}
