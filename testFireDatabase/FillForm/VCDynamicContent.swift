//
//  VCDynamicContent.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 23/04/22.
//

import UIKit
import FirebaseDatabase

enum questionType{
    case textType
    case radioType
    case checkType
}

class VCDynamicContent: UIViewController {
    
    var question: questionType = .textType
    var index = 0
    var totalPageCount = 0
    
    @IBOutlet weak var btnPrev:UIButton!
    @IBOutlet weak var btnNext:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var cardView:UIView!
    
    @IBOutlet weak var lblQuestionText:UILabel!
    @IBOutlet weak var answerText:UITextView!
    @IBOutlet weak var answerTextView:UIView!
    @IBOutlet var viewList:[UIView]!
    @IBOutlet var lblOptionList:[UILabel]!
    @IBOutlet var checkList:[UIButton]!
    @IBOutlet var btnSelectList:[UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.cornerRadius = 10
        lblQuestionText.text = "\(index)"
        answerText.delegate = self
        resetAll()
        if selectedForm != nil {
            loadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnSubmit.isHidden = true
        if index == totalPageCount-1 {
            if Functions.isUserTypeAdmin() {return}
            btnSubmit.isHidden = false
            btnSubmit.layer.cornerRadius = 5
        }
    }
    
    //MARK: UI Configurations
    func resetAll(){
        answerTextView.isHidden = true
        resetButtons()
        for viewitem in viewList {
            viewitem.isHidden = true
        }
    }
    
    func configUI(){
        switch question {
        case .textType:
            answerTextView.isHidden = false
            answerText.layer.borderColor = UIColor.init(named: "AppDarkBlue")?.cgColor
            answerText.layer.borderWidth = 0.3
            answerText.layer.cornerRadius = 0.3
            let property = selectedForm.value(forKey: "property") as! [NSDictionary]
            self.answerText.text = property[index].value(forKey: "answer") as! String
        case .radioType, .checkType:
            for viewitem in viewList {
                viewitem.isHidden = false
            }
            configOptionList()
            
        }
    }
    func resetButtons(){
        for viewitem in checkList {
            viewitem.isSelected = false
        }
    }
    
    //MARK: Data Configuration
    func loadData(){
         guard let questionData = selectedForm.value(forKey: "property") as? [NSDictionary] else  {return}
        self.lblQuestionText.text = questionData[index].value(forKey: "qTitle") as? String
        let type = questionData[index].value(forKey: "qType") as? String
        if  type == "textfield" {
            self.question = .textType
        }else if type == "radio" {
            self.question = .radioType
            for item in checkList{
                item.setImage(UIImage(systemName:  "circlebadge"), for: .normal)
                item.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
            }
        }else{
            self.question = .checkType
            for item in checkList{
                item.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                item.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            }
        }
        configUI()
    }
    
    
    func configOptionList(){
        let property = selectedForm.value(forKey: "property") as! [NSDictionary]
        self.answerText.text = property[index].value(forKey: "answer") as! String
        if property[index].value(forKey: "option") != nil {
            let options = property[index].value(forKey: "option") as! [NSDictionary]
            for i in 0..<options.count {
                lblOptionList[i].text = options[i].value(forKey: "optitle") as! String
                print((options[i].value(forKey: "isSelected") as! String))
                checkList[i].isSelected = (options[i].value(forKey: "isSelected") as! String) == "true" ? true : false
            }
        }
    }
    
    
    //MARK: Button Actions
    //    @IBAction func onTapNext(_ sender: UIButton){}
    //    @IBAction func onTapBack(_ sender: UIButton){}
    @IBAction func onTapSubmit(_ sender: UIButton){
        if userReview.answers?.count ?? 0 == 0 {
            return
        }
        DatabaseManger.shared.saveANswerToDatabse(user: UserInfo(userId: "\(UserDefaults.standard.value(forKey: "UserId")!)", userName: "\(UserDefaults.standard.value(forKey: "Name")!)", userEmail: "\(UserDefaults.standard.value(forKey: "Email")!)"), formInfo:userReview )
        self.alertwith(title: "Add Form", message: "Review Submitted", options: ["Ok"], completion: { result in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func onTapSelect(_ sender: UIButton){
        print(sender.tag)
        if question == .radioType {
            onRadio(index: sender.tag)
        }else if question == .checkType {
            onCheckBox(index: sender.tag)
        }
    }
    
    func onCheckBox(index:Int){
        checkList[index].isSelected = !checkList[index].isSelected
        var text = ""
        for i in 0..<checkList.count {
            if checkList[i].isSelected == true {
                if text != "" {text += ", "}
                text += "\(lblOptionList[i].text!)"
            }
        }
        storeData(text:text, indexOp: index)
        updateRecord(ind:index,status:checkList[index].isSelected)
    }
    
    func onRadio(index:Int){
        resetButtons()
        checkList[index].isSelected =  true
        storeData(text: lblOptionList[index].text!, indexOp:index)
        updateRecord(ind:index)
    }
    func updateRecord(text:String){
        if Functions.isUserTypeAdmin(){return}
        guard var questionData = selectedForm.value(forKey: "property") as? [NSMutableDictionary] else  {return}
        if questionData[index].value(forKey: "option") == nil {
            questionData[index].setValue("\(text)", forKey: "answer")
            selectedForm.setValue(questionData, forKey: "property")
        }
    }
    func updateRecord(ind:Int,status:Bool){
        if Functions.isUserTypeAdmin(){return}
        guard var questionData = selectedForm.value(forKey: "property") as? [NSMutableDictionary] else  {return}
        if questionData[index].value(forKey: "option") != nil {
            var options = questionData[index].value(forKey: "option") as! [NSMutableDictionary]
            let type = options[ind].value(forKey: "opdisplay") as! String
            if type == "checkbox" {
                options[ind].setValue("\(status)", forKey: "isSelected")
                selectedForm.setValue(questionData, forKey: "property")
            }
            
        }
    }
    func updateRecord(ind:Int){
        if Functions.isUserTypeAdmin(){return}
        guard var questionData = selectedForm.value(forKey: "property") as? [NSMutableDictionary] else  {return}
        if questionData[index].value(forKey: "option") != nil {
            var options = questionData[index].value(forKey: "option") as! [NSMutableDictionary]
            let type = options[ind].value(forKey: "opdisplay") as! String
            if type == "radio" {
                for item in options{
                    if item.value(forKey: "isSelected")as! String == "true" {
                        item.setValue("false", forKey: "isSelected")
                    }
                }
                options[ind].setValue("true", forKey: "isSelected")
                selectedForm.setValue(questionData, forKey: "property")
            }
            
        }
    }
    func storeData(text:String, indexOp: Int?){
        if Functions.isUserTypeAdmin() {return}
        let obj = Answers()
        guard let questionData = selectedForm.value(forKey: "property") as? [NSDictionary] else  {return}
        obj.questionID = questionData[index].value(forKey: "questionID") as? String
        obj.answerText = text
        if ((questionData[index].value(forKey: "qType") as! String) != "textfield") && (indexOp != nil){
            obj.optionId = "\(indexOp!)"
        }
        
        
        
        if userReview.answers == nil {
            userReview.answers = [Answers]()
        }
        
        let inx = userReview.answers?.firstIndex(where: { $0.questionID == obj.questionID})
        guard let objindex = inx else {
            userReview.answers?.append(obj)
            return}
        userReview.answers?.remove(at: objindex)
        userReview.answers?.insert(obj, at: objindex)
    }
}

extension VCDynamicContent: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" { return }
        storeData(text: textView.text!, indexOp: nil)
        updateRecord(text: textView.text!)
    }
}

