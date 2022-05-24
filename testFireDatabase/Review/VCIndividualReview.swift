//
//  VCIndividualReview.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 13/05/22.
//

import UIKit

class VCIndividualReview: UIViewController {
    
    @IBOutlet weak var tblReviewerList: UITableView!
    @IBOutlet weak var lblReviewCount: UILabel!
    
    var reviewerList = [NSDictionary](){
        didSet {
            lblReviewCount.text = "Total \(self.reviewerList.count) reviews."
        }
    }
    var formId: String! {
        didSet  {
            getFormData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(formId)
//        getFormData()
    }
    
    func getFormData(){
        if formId != nil {
        DatabaseManger.shared.getAnswerListForForm(formId: formId!){ response in
            print(response)
            if let list = response as? [NSDictionary]{
                print(list.count)
                self.reviewerList = list
                self.tblReviewerList.reloadData()
            }
        }
      }
    }
    
    func filterUserData(id: String){
        let arr = self.reviewerList.filter({ $0["userid"] as! String == id }) as? [NSDictionary]
        print(arr!.count)
        print(arr![0])
        var newAnswerObj = reviewRecord()
        let obj = arr![0] as! NSDictionary
       
        var ansArr = [Answers]()
        if let arr = obj.value(forKey: "answers") as? NSArray{
            print(arr.count)
            for i in 0..<arr.count{
                let dataObj = Answers()
                if let sub = arr[i] as? NSDictionary{
                    dataObj.questionID = sub.value(forKey: "questionID") as! String
                    dataObj.answerText = sub.value(forKey: "answerText") as! String
                    ansArr.append(dataObj)
                }
            }
        }
        newAnswerObj.formId = obj.value(forKey: "formId") as! String
        newAnswerObj.answers = ansArr
        userReview = reviewRecord()
        selectedForm = formToBeReviewd
        userReview = newAnswerObj
       print(userReview)
        let vc = storyboard?.instantiateViewController(withIdentifier: "VCFillForm") as! VCFillForm
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension VCIndividualReview: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReviewer", for: indexPath) as! cellReviewer
        let obj = self.reviewerList[indexPath.row] as! NSDictionary
        cell.lblName.text = obj.value(forKey: "userName") as! String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.reviewerList[indexPath.row] as! NSDictionary
        let id = obj.value(forKey: "userid") as! String
        filterUserData(id: id)
    }
    
}
