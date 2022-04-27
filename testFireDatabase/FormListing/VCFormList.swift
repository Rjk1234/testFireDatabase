//
//  VCFormList.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 21/04/22.
//

import UIKit
import Firebase

class VCFormList: UIViewController {
    
    //MARK: Variables
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnCreate:UIButton!
    @IBOutlet weak var cardView:UIView!
    var ref: DatabaseReference!
    var list = [NSMutableDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        ref = Database.database().reference().child("Forms");
        fetch()
    }
    
    
    func configView(){
        cardView.makeShadowDrop()
        cardView.layer.cornerRadius = 10
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnCreate.layer.cornerRadius = btnCreate.frame.size.height/2
        self.tblList.register(UINib(nibName: "cellForm", bundle: nil), forCellReuseIdentifier: "cellForm")
    }
    
    
    func fetch(){
        Functions.showActivityIndicator(In: self)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.list.removeAll()
                for obj in snapshot.children.allObjects as! [DataSnapshot] {
                    let root = obj.value as? [String:Any]
                                       let dictObj = NSMutableDictionary()
                                       let val = root!["formID"] as! String
                    dictObj.setValue(val, forKey: "formID")
                    dictObj.setValue(root!["property"], forKey: "property")
                    dictObj.setValue(root!["title"], forKey: "title")
                    dictObj.setValue(root!["status"], forKey: "status")
//
//                    var propArray = [Property]()
//                   let arr = root!["property"] as! [NSDictionary]
//                    for i in 0..<arr.count{
//                        var options: [Option]?
//                        if arr[i].value(forKey: "option") != nil {
//                            let optArr = arr[i].value(forKey: "option") as! [NSDictionary]
//                            for j in 0..<optArr.count{
//                                let obj = Option(opid: optArr[j].value(forKey: "opid") as? String,
//                                                 optitle: optArr[j].value(forKey: "optitle") as? String,
//                                                 opdisplay: optArr[j].value(forKey: "opdisplay") as? String, isSelected: optArr[j].value(forKey: "isSelected") as? Bool)
//                                options?.append(obj)
//                            }
//
//                        }else{
//                            options = nil
//                        }
//                        let item = Property(questionID: arr[i].value(forKey: "questionID") as! String ,
//                                            qTitle: arr[i].value(forKey: "qTitle") as! String,
//                                            qType: arr[i].value(forKey: "qType") as! String,
//                                            answer: arr[i].value(forKey: "answer") as! String,
//                                            option: options)
//                        propArray.append(item)
//                    }
//                    var form = FormData(formID: root!["formID"] as! String, title: root!["title"] as! String, status: false, property: root!["property"] as! [Property])
                   
                    self.list.append(dictObj)
//                    print(dictObj.value(forKey: "property"))
                    
                }
                print(self.list.count)
//                Functions.hideActivityIndicator()
//                self.tblList.reloadData()
            }
            Functions.hideActivityIndicator()
            self.tblList.reloadData()
        })
    }
    @IBAction func onTapBack(_ sender:UIButton){
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func onTapCreate(_ sender:UIButton){
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCAddForm") as! VCAddForm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
