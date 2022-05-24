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
    var database = Database.database().reference()
    
    func getFormWith(id:String, completion: @escaping (NSDictionary) -> Void ) {
        formRef.queryOrdered(byChild: "formID").queryEqual(toValue: "\(id)" ).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            print(snapshot.value as? [String: [String:Any]])
            for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    let dict = childSnap.value as! NSDictionary
                completion(dict)
                }
        })
    }
    
    func getAnswerListForForm(formId:String, completion: @escaping ([NSDictionary]) -> Void ) {
        print(formId)
        answerRef.queryOrdered(byChild: "formId").queryEqual(toValue: "\(formId)" ).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
//               print(snapshot.value as? [String: [String:Any]])
            var list = [NSDictionary]()
            var i = 1
            print(snapshot.childrenCount)
            for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    let dict = childSnap.value as! NSDictionary
                list.append(dict)
                if i == snapshot.childrenCount {
                    completion(list)
                }
                i += 1
            }
               })
    }
    
    func getAnswerOfUser(id:String){
        print(id)
        answerRef.queryOrdered(byChild: "userid").queryEqual(toValue: "VOx1snqKN5UykvuYLBr3retZKw42").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            print(snapshot.value as? [String: [String:Any]])
        })
        

    }
    
    func getUserInfo(id:String, completion: @escaping (NSDictionary) -> Void ) {
        userRef.queryOrdered(byChild: "userId").queryEqual(toValue: "\(id)").observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            print(snapshot.value as? [String: [String:Any]])
            for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    let dict = childSnap.value as! NSDictionary
                 completion(dict)
                }
            })
        
    }
    
    
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void ) {
        database.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
            if let result = snapshot.value as? [String:[String:Any]] {
                completion(true)
            } else {
                completion(false)
            }
        } )
    }
    
    func removeform(id:String, completion: @escaping (Bool) -> Void){
        ref = formRef
        ref.child("\(id)").removeValue(){ error,val  in
            if error != nil {
                print("error \(error?.localizedDescription)")
                completion(false)
            }else{
                completion(true)
            }
        }
    }
    
    func saveUserToDatabse(user:UserInfo){
        ref = userRef //Database.database().reference().child("Users")
        let key = ref.childByAutoId().key
        
        let userObj : [String: Any] = ["userId":"\(user.userId!)",
                                       "userName":"\(user.userName!)",
                                       "userEmail":"\(user.userEmail!)"]
        ref.child(key!).setValue(userObj)
        Functions.saveUserInfo(user:UserInfo(userId: "\(user.userId!)", userName: "\(user.userName!)", userEmail: "\(user.userEmail!)"))
    }
    
    func saveANswerToDatabse(user:UserInfo,formInfo:reviewRecord){
        ref = answerRef //Database.database().reference().child("Answers")
        let key = ref.childByAutoId().key
        
        let ansObj : [String: Any] = ["userid": user.userId!,
                                      "userName": user.userName!,
                                      "formId": formInfo.formId!
        ]
        ref.child(key!).setValue(ansObj)
        var answerList = [[String: Any]]()
        for i in 0..<formInfo.answers!.count{
            let obj : [String: Any] = ["questionID":"\(formInfo.answers![i].questionID!)",
                                       "answerText":"\(formInfo.answers![i].answerText!)",
                                       "answerOpId": "\(formInfo.answers![i].optionId ?? "NA")"]
            answerList.append(obj)
        }
        print(answerList)
        ref.child(key!).child("answers").setValue(answerList)
    }
    
    func saveFormToDataBase(List:FormData){
        ref = formRef //Database.database().reference().child("Forms")
        let key = ref.childByAutoId().key
        print(key)
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

