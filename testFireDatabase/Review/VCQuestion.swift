//
//  VCQuestion.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 23/05/22.
//

import UIKit

class VCQuestion: UIViewController {

    @IBOutlet weak var lblQuestionText: UILabel!
    @IBOutlet weak var tblAnswerList: UITableView!
    var selectedFormId: String!
    var optionList: answerReviewModel!
    var AnswersDetail = optionsType()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblAnswerList.register(UINib(nibName: "cellText", bundle: nil), forCellReuseIdentifier: "cellText")
        self.tblAnswerList.register(UINib(nibName: "cellMCQ", bundle: nil), forCellReuseIdentifier: "cellMCQ")
        if optionList != nil {
            self.lblQuestionText.text = optionList.qTitle as! String
        }
    }
   
    @IBAction func onTapBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

}

extension VCQuestion : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if optionList.qtype == "textfield" {
            return optionList.ans?.count ?? 0
        }else{
            return optionList.options?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if optionList.qtype == "textfield" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellText", for: indexPath)as! cellText
            cell.lblText.text = optionList.ans![indexPath.row] as! String
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellMCQ", for: indexPath)as! cellMCQ
            let obj = optionList.options![indexPath.row] as! optionsType
            cell.lblText.text = obj.opTitle as! String
            cell.lblCount.text = "\(obj.selectCount as! NSNumber)"
            return cell
        }
        return UITableViewCell()
    }
}
