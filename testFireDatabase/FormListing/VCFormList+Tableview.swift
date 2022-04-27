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
        return cell
    }
    
    
    @objc func openSurvey(_ sender: UIButton){
        print(sender.tag)
        let obj = self.list[sender.tag]
        selectedForm = obj
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCFillForm") as! VCFillForm
          navigationController?.pushViewController(vc, animated: true)
    }
    
}
