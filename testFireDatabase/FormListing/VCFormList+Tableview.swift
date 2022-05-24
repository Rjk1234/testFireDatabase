//
//  VCFormList+Tableview.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 21/04/22.
//

import UIKit

extension VCFormList: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellForm", for: indexPath) as! cellForm
        cell.lblTitle.text = self.list[indexPath.row].value(forKey: "title") as! String
        cell.btnOpen.tag = indexPath.row
        cell.btnOpen.addTarget(self, action: #selector(openSurvey), for: .touchUpInside)
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(onTapRemove), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Functions.isUserTypeAdmin() {return}
        let id = self.list[indexPath.row].value(forKey: "formID") as! String
       print(self.list[indexPath.row])
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCReview") as! VCReview
        vc.selectedFormId = id
          navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openSurvey(_ sender: UIButton){
        print(sender.tag)
        let obj = self.list[sender.tag]
        selectedForm = obj
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCFillForm") as! VCFillForm
          navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onTapRemove(_ sender: UIButton){
        self.alertwith(title: "Survey Plus", message: "Delete this Form?", options: ["OK","Cancel"], completion: {success in
            if success == 0 {
                let obj = self.list[sender.tag]
               if let formId = obj.value(forKey: "formID") as? String{
                   DatabaseManger.shared.removeform(id:formId){success in
                       if success {
                           self.list.remove(at: sender.tag)
                           self.tblList.reloadData()
                       }
                   }
                }
            }
        })
    }
    
}
