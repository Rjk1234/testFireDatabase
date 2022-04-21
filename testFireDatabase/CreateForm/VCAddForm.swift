//
//  VCAddForm.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 21/04/22.
//

import UIKit
import Firebase

class VCAddForm: UIViewController {

    var ref: DatabaseReference!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        create()
    }
    
    func create(){
        let key = ref.childByAutoId().key
//        var dataone : FormData!
//        dataone = FormData(formID: key, title: "Form two", status: false, property:nil)
                //generating a new key inside artists node
                //and also getting the generated key
        
        //***dummy data****
        let form: [String : Any] = [    "formID":key,
                                "title": "some title here2",
                                "status": false,
                                "property": ""
                ]
       
        let aDict = ["opid": "0",
                     "optitle": "xxxx",
                     "opdisplay": "radio",
                     "isSelected": false] as [String : Any]
        let bDict = ["opid": "1",
                     "optitle": "xxxx",
                     "opdisplay": "radio",
                     "isSelected": false] as [String : Any]
        let cDict = ["opid": "2",
                     "optitle": "xxxx",
                     "opdisplay": "radio",
                     "isSelected": false] as [String : Any]
        let dDict = ["opid": "3",
                     "optitle": "xxxx",
                     "opdisplay": "radio",
                     "isSelected": false] as [String : Any]
       let arr = [aDict,bDict,cDict,dDict]
        //adding the data inside the generated unique key
        ref.child("Forms").child(key!).setValue(form)
        //adding under property
        ref.child("Forms").child(key!).child("property").setValue(arr)
        
        let user: [String:Any] = ["userId":key,
                                  "name":"Rajveer",
                                  "email":"rajveer@yomail.com" ]
//        ref.child("Users").child(key!).setValue(user)
        
        // fetch saved schema
        fetch()
        }
    
    
    func fetch(){
        //observing the data changes
        ref.observe(DataEventType.value, with: { (snapshot) in
                    
                    //if the reference have some values
                    if snapshot.childrenCount > 0 {
                         //iterating through all the values
                        for obj in snapshot.children.allObjects as! [DataSnapshot] {
                            //getting values
                            let root = obj.value as? [String: Any]
                           print(root)
                        }
                        
                        //reload the ui
                        
                    }
                })

    }
    
    @IBAction func onTapCreate(_ sender: UIButton){
        
    }

}
