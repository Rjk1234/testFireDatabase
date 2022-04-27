//
//  VCAddForm+TableView.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 22/04/22.
//

import UIKit

extension VCAddForm: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTemplate", for: indexPath)as! cellTemplate
        cell.lblTitle.text = self.list[indexPath.row].title as! String
        cell.btnSelect.tag =  indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(onTapSelect), for: .touchUpInside)
        var textType = 0
        var radioType = 0
        var checkType = 0
        for i in 0..<list[indexPath.row].property!.count {
            if let item = list[indexPath.row].property![i].qType as? String{
                if item == "textfield" {
                    textType += 1
                }else if item == "radio" {
                    radioType += 1
                }else if item == "checkbox" {
                    checkType += 1
                }
            }
        }
        cell.lblTextFieldCount.text = "\(textType)"
        cell.lblRadioCount.text = "\(radioType)"
        cell.lblCheckBoxCount.text = "\(checkType)"
        
        return cell
    }
    
}
