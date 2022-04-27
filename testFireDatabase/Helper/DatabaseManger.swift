//
//  DatabaseManger.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 22/04/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class DatabaseManger: NSObject {
    static let shared = DatabaseManger()
    
    var ref: DatabaseReference!
    
    func saveUserToDatabse(user:UserInfo){
        ref = Database.database().reference().child("Users")
        let key = ref.childByAutoId().key
       
        let userObj : [String: Any] = ["userId":"\(user.userId!)",
                                       "userName":"\(user.userName!)",
                                       "userEmail":"\(user.userEmail!)"]
        ref.child(key!).setValue(userObj)
        Functions.saveUserInfo(user:UserInfo(userId: "\(user.userId!)", userName: "\(user.userName!)", userEmail: "\(user.userEmail!)"))
        }
    
    func saveANswerToDatabse(user:UserInfo,formInfo:reviewRecord){
        ref = Database.database().reference().child("Answers")
        let key = ref.childByAutoId().key
        
        let ansObj : [String: Any] = ["userid": user.userId!,
                                      "userName": user.userName!,
                                      "formId": formInfo.formId!,
                                      ]
        ref.child(key!).setValue(ansObj)
        var answerList = [[String: Any]]()
        for i in 0..<formInfo.answers!.count{
            let obj : [String: Any] = ["questionID":"\(formInfo.answers![i].questionID!)",
                                       "answerText":"\(formInfo.answers![i].answerText!)"]
            answerList.append(obj)
        }
        print(answerList)
        ref.child(key!).child("answers").setValue(answerList)
        }

    func saveFormToDataBase(List:FormData){
        ref = Database.database().reference().child("Forms")
        let key = ref.childByAutoId().key
        let form: [String:Any] = ["formID": "\(key!)", //List.formID!
                                  "title": "\(List.title!)",
                                  "status": "\(List.status!)",
        ]
        ref.child(key!).setValue(form)
        var prop = [[String: Any]]()
        if List.property != nil {
            for j in 0..<List.property!.count {
                var optionList = [[String:Any]]()
                if List.property![j].option != nil {
                    for i in 0..<List.property![j].option!.count {
                        let aDict:[String : Any] = [
                            "opid": "\(List.property![j].option![i].opid!)",
                            "optitle": "\(List.property![j].option![i].optitle!)",
                            "opdisplay": "\(List.property![j].option![i].opdisplay!)",
                            "isSelected": "\(List.property![j].option![i].isSelected!)"]
                        optionList.append(aDict)
                    }
                }
                let propObj : [String:Any] = [
                    "questionID" : "\(List.property![j].questionID!)",
                    "qTitle" : "\(List.property![j].qTitle!)",
                    "qType": "\(List.property![j].qType!)",
                    "answer": "\(List.property![j].answer!)",
                    "option": optionList
                ]
                prop.append(propObj)
            }
            ref.child(key!).child("property").setValue(prop)
        }
    }
}
    
//    func fetchFromDatabse(){
//        ref = Database.database().reference().child("Forms")
//        var list = [NSMutableDictionary]()
//        ref.observe(DataEventType.value, with: { (snapshot) in
//            if snapshot.childrenCount > 0 {
//                for obj in snapshot.children.allObjects as! [DataSnapshot] {
//                    let root = obj.value as? [String: Any]
//                    let dictObj = NSMutableDictionary()
//                    let val = root!["formID"] as! String
//                    dictObj.setValue(val, forKey: "formID")
//                    dictObj.setValue(root!["property"], forKey: "property")
//                    dictObj.setValue(root!["title"], forKey: "title")
//                    dictObj.setValue(root!["status"], forKey: "status")
//                    list.append(dictObj)
//                }
//                print(list.count)
//
//            }
//        })
//    }


