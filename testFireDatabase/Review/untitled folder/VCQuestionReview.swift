//
//  VCQuestionReview.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 13/05/22.
//

import UIKit

class VCQuestionReview: UIViewController {

    @IBOutlet weak var lblFormTitle:UILabel!
    @IBOutlet weak var tblQuestionList: UITableView!
    var questionList = [NSDictionary]()
    var selectedFormId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblQuestionList.register(UINib(nibName: "cellText", bundle: nil), forCellReuseIdentifier: "cellText")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.getForm()
        })
       
    }
    func  getForm(){
        Functions.showActivityIndicator(In: self)
        DatabaseManger.shared.getFormWith(id: self.selectedFormId){ [self] result in
            Functions.hideActivityIndicator()
            selectedForm = result.mutableCopy() as! NSMutableDictionary
            formToBeReviewd = selectedForm
            self.lblFormTitle.text = selectedForm.value(forKey: "title") as! String
            populateList()
        }
    }
    
    func populateList(){
        if let list = selectedForm.value(forKey: "property") as? [NSDictionary] {
            self.questionList = list
            self.tblQuestionList.reloadData()
        }
    }
  
}

extension VCQuestionReview : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = questionList[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellText", for: indexPath)as! cellText
        cell.lblText.text = obj.value(forKey: "qTitle") as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCQuestion")as! VCQuestion
        vc.optionList = modelList[indexPath.row] as! answerReviewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}

class answerReviewModel{
    var qid: String?
    var qTitle:String?
    var qtype: String?
    var ans: [String]?
    var options: [optionsType]?
}

class optionsType{
    var qid:String?
    var opTitle:String?
    var opDisplay:String?
    var selectCount:Int = 0
}
