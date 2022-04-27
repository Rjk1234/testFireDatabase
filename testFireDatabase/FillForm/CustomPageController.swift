//
//  CustomPageController.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 23/04/22.
//

import UIKit

class CustomPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
    var page = 0
    var totalCount = 0
    var curind = 0
    
    func setupContentVC(page: Int) -> VCDynamicContent? {
        guard let contentPage = storyboard?.instantiateViewController(identifier: "VCDynamicContent") as? VCDynamicContent else {
            return nil
        }
        contentPage.index = page
        contentPage.totalPageCount = totalCount
        return contentPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let totalPages = selectedForm.value(forKey: "property") as! [NSDictionary]
        totalCount = totalPages.count
        userReview.formId = selectedForm.value(forKey: "formID") as! String
        
        self.dataSource = self
        self.delegate = self
        
        guard let contentVC = setupContentVC(page: 0) else { return }
        
        self.setViewControllers([contentVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        
        let btnPrev = UIButton()
        btnPrev.frame = CGRect(x: 20, y: UIScreen.main.bounds.size.height - 300, width: 50, height: 50)
        btnPrev.backgroundColor = UIColor(named: "AppDarkBlue")
        btnPrev.setTitle("", for: .normal)
        btnPrev.setImage(UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnPrev.tintColor = UIColor.white
        btnPrev.addTarget(self, action: #selector(onTapback), for: .touchUpInside)
        self.view.addSubview(btnPrev)
        btnPrev.layer.cornerRadius = 25
        let btnNext = UIButton()
        
        btnNext.frame = CGRect(x:self.view.frame.size.width - 70, y: self.view.frame.size.height - 300, width: 50, height: 50)
        btnNext.backgroundColor = UIColor(named: "AppDarkBlue")
        btnNext.setTitle("", for: .normal)
        btnNext.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnNext.tintColor = UIColor.white
        btnNext.addTarget(self, action: #selector(onTapNext), for: .touchUpInside)
        self.view.addSubview(btnNext)
        btnNext.layer.cornerRadius = 25
        
        
        print(self.view.frame.size.height)
        print(self.view.frame.size.height-100)
    }
    
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if curind == 0 {
            return nil
        }
        return setupContentVC(page: page - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if curind+1 == totalCount {
            return nil
        }
        return setupContentVC(page: page + 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            guard let journalVC = viewControllers?.first as? VCDynamicContent else { return }
            
            let index = journalVC.index
            self.page = index
            curind = index
        }
    }
    
    @objc func onTapNext(){
        if curind+1 == totalCount {
            return
        }
        guard let VC = setupContentVC(page: page + 1) else { return }
        self.setViewControllers([VC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        let index = VC.index
        self.page = index
        curind = index
    }
    @objc func onTapback(){
        if curind == 0 {
            return
        }
        guard let VC = setupContentVC(page: page - 1) else { return }
        self.setViewControllers([VC], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
        let index = VC.index
        self.page = index
        curind = index
    }
    
    
}

