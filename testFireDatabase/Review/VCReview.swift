//
//  VCReview.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 13/05/22.
//

import UIKit

var formToBeReviewd: NSMutableDictionary!
var modelList = [answerReviewModel]()
class VCReview: UIViewController {

    @IBOutlet var viewList: [UIView]!
    @IBOutlet var btnList: [UIButton]!
    var selectedFormId: String!
    @IBOutlet weak var contentView:UIView!
   
    
    lazy var orderedViewControllers: [UIViewController] = {
           return [
                   self.newVc(viewController: "VCQuestionReview"),
                   self.newVc(viewController: "VCIndividualReview")
                    ]
       }()
       var viewControllers : [UIViewController]!
       var selectedIndex: Int = 0
       var pageIndex : Int = 0
       var pageVc: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getForm()
        getAnswerData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configUI()
    }
    
    @IBAction func onTapBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func  getForm(){
        DatabaseManger.shared.getFormWith(id: selectedFormId){ [self] result in
            selectedForm = result.mutableCopy() as! NSMutableDictionary
            formToBeReviewd = selectedForm
        }
    }
    
    func getAnswerData(){
        if selectedFormId != nil {
        DatabaseManger.shared.getAnswerListForForm(formId: selectedFormId!){ response in
            print(response)
            if let list = response as? [NSDictionary]{
                print(list.count)
                self.configAnswerData(list: list)
            }
        }
      }
    }
    
    func configAnswerData(list:[NSDictionary]){
         modelList = [answerReviewModel]()
        let formPropertyList = selectedForm.value(forKey: "property") as! [NSDictionary]
        print(list)
        print(formPropertyList)
        for i in 0..<formPropertyList.count{
        var modelObj = answerReviewModel()
            var qObj = formPropertyList[i] as! NSDictionary
            modelObj.qid = qObj.value(forKey: "questionID") as! String
            modelObj.qTitle = qObj.value(forKey: "qTitle") as! String
            modelObj.qtype = qObj.value(forKey: "qType") as! String
            if modelObj.qtype == "textfield" {
                modelObj.ans = [String]()
                for j in 0..<list.count{
                    print(list[j])
                    if let ansObj = list[j].value(forKey: "answers") as? [NSDictionary]{
                        for k in 0..<ansObj.count{
                    if (ansObj[k].value(forKey: "questionID") as! String) == modelObj.qid {
                    modelObj.ans?.append(ansObj[k].value(forKey: "answerText") as! String)
                    }
                        }
                    }
                }
                print(modelObj.ans)
            } else {
                modelObj.options = [optionsType]()
                
                var optionPropList = qObj.value(forKey: "option") as! [NSDictionary]
                for k in 0..<optionPropList.count{
                    var optionObj = optionsType()
                var optionPropObj = optionPropList[k] as! NSDictionary
                    optionObj.qid = optionPropObj.value(forKey: "opid") as! String
                    optionObj.opDisplay = optionPropObj.value(forKey: "opdisplay") as! String
                    optionObj.opTitle = optionPropObj.value(forKey: "optitle") as! String
                    optionObj.selectCount = 0
                    
                
               
                for j in 0..<list.count{
                    print(list[j])
                    if let ansObj = list[j].value(forKey: "answers") as? [NSDictionary]{
                    for k in 0..<ansObj.count{
                    if (ansObj[k].value(forKey: "questionID") as! String) == modelObj.qid {
                        if optionObj.qid == (ansObj[k].value(forKey: "answerOpId")as! String) {
                            optionObj.selectCount += 1
                        }
                    }
                    }
                    }
                }
                    modelObj.options?.append(optionObj)
                }//optionproplist loop
                }//else part
            modelList.append(modelObj)
            }
        print(modelList)
    }
      
    func configUI(){
        viewControllers = [self.newVc(viewController: "VCQuestionReview"),
        self.newVc(viewController: "VCIndividualReview")]
       
        pageVc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVc.dataSource = self
        pageVc.delegate = self
        
        DispatchQueue.main.async {
            
            if let firstViewController = self.orderedViewControllers.first {
                self.pageVc.setViewControllers([firstViewController],
                                               direction: .forward,
                                               animated: true,
                                               completion: nil)
                if let visibleVC = firstViewController as? VCQuestionReview {
                    visibleVC.selectedFormId = self.selectedFormId
                }
            }
            self.addChild(self.pageVc)
        }
        pageVc.view.frame = CGRect(x:0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        self.contentView.addSubview(pageVc.view)
        pageVc.didMove(toParent: self)
    }
    
    @IBAction func onSelect(_ sender: UIButton){
        for btn in btnList{
            btn.setTitleColor(UIColor.lightGray, for: .normal)
        }
        for view in viewList{
            view.backgroundColor = UIColor.lightGray
        }
        btnList[sender.tag].setTitleColor(UIColor(named: "AppDarkBlue"), for: .normal)
        viewList[sender.tag].backgroundColor = UIColor(named: "AppDarkBlue")
        self.menuBarDidSelectItemAt(index: sender.tag)
        selectedIndex = sender.tag
    }
}


